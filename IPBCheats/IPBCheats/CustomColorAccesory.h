@interface CustomColorAccesory : UIControl
{
	UIColor *_accessoryColor;
	UIColor *_highlightedColor;
}

@property (nonatomic, retain) UIColor *accessoryColor;
@property (nonatomic, retain) UIColor *highlightedColor;

+ (CustomColorAccesory *)accessoryWithColor:(UIColor *)color;

@end