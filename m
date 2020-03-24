Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAD0191CA3
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 23:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgCXW3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 18:29:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10754 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728216AbgCXW3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 18:29:11 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200324222907epoutp04b5b953ee8ea387ff834e69942b82ac12~-Xf-jgdX73079930799epoutp04n
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 22:29:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200324222907epoutp04b5b953ee8ea387ff834e69942b82ac12~-Xf-jgdX73079930799epoutp04n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1585088947;
        bh=Nx1yBUUy5HsYqeDfSoeruzmyY780DIbR3vsGN0YWcNk=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=NTK8kBzw2O7Z5RjzXzkGr8bCgf1lecEiNni3zpcCgcnt+EQrgBAUCOJR0k3J/m0K0
         kVhuhhoo1pyt2jpXP92Q0ySCp8Go2Xlk+qy+gOXebwrzwzlxu7ZKoYjPAvrLlejiRW
         oS8JN+kcctg/ocTFvDKMR4EpnO+dot2hqYZoBW+o=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20200324222907epcas1p3bd1ca82cc2fc87f328d9c555e6240ad6~-Xf-IzWAM1889418894epcas1p3R;
        Tue, 24 Mar 2020 22:29:07 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.156]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 48n5Wh5sCKzMqYkW; Tue, 24 Mar
        2020 22:29:04 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        16.4B.04071.0B98A7E5; Wed, 25 Mar 2020 07:29:04 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200324222903epcas1p241bb9a19d8e75e784c6f7dcd4214b24b~-Xf8NzcDG0883108831epcas1p2O;
        Tue, 24 Mar 2020 22:29:03 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200324222903epsmtrp27fd01daea93f40c2c6e6da95bdd5b427~-Xf8NDc-E3079530795epsmtrp2c;
        Tue, 24 Mar 2020 22:29:03 +0000 (GMT)
X-AuditID: b6c32a37-7afff70000000fe7-a3-5e7a89b0627f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4B.8E.04158.FA98A7E5; Wed, 25 Mar 2020 07:29:03 +0900 (KST)
Received: from [10.113.221.102] (unknown [10.113.221.102]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200324222903epsmtip13cc70bfe80a456013b5f396cb8a161e3~-Xf8GJX7f0788207882epsmtip1-;
        Tue, 24 Mar 2020 22:29:03 +0000 (GMT)
Subject: Re: [PATCH resend] extcon: axp288: Add wakeup support
To:     Hans de Goede <hdegoede@redhat.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
From:   Chanwoo Choi <cw00.choi@samsung.com>
Organization: Samsung Electronics
Message-ID: <cf0700cf-caed-0451-f8ba-b536e01488f6@samsung.com>
Date:   Wed, 25 Mar 2020 07:37:59 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:59.0) Gecko/20100101
        Thunderbird/59.0
MIME-Version: 1.0
In-Reply-To: <20200323215939.79008-1-hdegoede@redhat.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTYRjm29mOR2l6nGlv+1HzSJSK5nHOjpISZLHIQAj6IbF1mJ+buJs7
        UzIJNCKvSRJZahfByktIOuelwgwviUUWSBcVJbSrqZVSGSG0eYz897zv+zzf8z3f91KEoppU
        UllWJ3ZYeTND+km7BsKjo9pKT+liXC6Wmx++LOHG7l8lucmiJpKrb59B3O/+55J9Mm3bzB2Z
        9uvDl6S20t2CtMuubWnS9Oy9JsxnYIcKWw22jCyrMYk5fFS/X6+Jj2Gj2ARuD6Oy8hacxKSk
        pkUdzDJ7fBlVHm/O9bTSeEFgdifvddhynVhlsgnOJAbbM8z2BHu0wFuEXKsx2mCzJLIxMbEa
        D/FEtqnmZgdpHww8+evJDVSIqv3LkC8FdBycr3sgLUN+lILuQdD4uAOJxRKCuqGx9eInghdz
        85J/kiH3Nx9x0Ivgs/stKRZfEVS2dhJeVhCdDMVXZtcUm2k7FK10eUgURdAcFPdpvG2SjoC+
        T29ILw6gQ+HlyizyYrlHWvdsQebFUnoHzFyeWDsmmD4GI11n1zmBMFLzTurFvnQCNLYOrJ1D
        0Ftg4t0NiYi3Q/fCVcJ7N6AnSXjfMYrEBClQU7qyniYI5obdPiJWwvJiLyniAmgeGSRFcQkC
        d98LmThQQ9+tixIxTDjcvb9bbIfCvT/XkGjsD4s/KmReCtByKDmnEClhMPZ2at12KzQUl5IX
        EFO7IU7thgi1GyLU/jerR9IWFILtgsWIBdau3vjbLrS2kxF7elDbaGo/oinEbJIXzubrFDI+
        T8i39COgCGazvAOf1CnkGXz+Keyw6R25Ziz0I43ntasIZbDB5tlwq1PPamLVajUXx8ZrWJbZ
        Ir/02qxT0EbeibMxtmPHP52E8lUWoiDtxKg+kU2KHA9aamLrF12WsO/pxe0543OhyurTZX4h
        JqJLd9y/c7Q8X1h1fqhsnOZTbmduLeAnrifS1c2PKqZ8JxtWu1sP1O1a2hl8RpUzbfgY1/jF
        aijLuViQ57PqxzeUDyDjkfRM/0UccKCos+oQcY+L8on882ryaWBOLCMVTDwbQTgE/i/JF3ED
        qQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWy7bCSnO76zqo4g7enjS3eHJ/OZHF51xw2
        i9uNK9gsFmx8xGjx89B5JgdWjw2PVrN6vN93lc2jb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4
        MmYu2cxWcESw4vup+YwNjNP4uhg5OSQETCSObvnA3sXIxSEksJtR4v7hD6wQCUmJaRePMncx
        cgDZwhKHDxdD1LxllNg2Yy8zSI2wgJ1E+4zHTCA1IgIFEn3fKkFMZgELifb9phDlPYwSbz6+
        AytnE9CS2P/iBhuIzS+gKHH1x2NGEJsXaMzss2/B1rIIqEo8mn6LCcQWFQiT2LnkMRNEjaDE
        yZlPWEBsTgFLieVrD4PNYRZQl/gz7xIzhC0ucevJfCYIW15i+9s5zBMYhWchaZ+FpGUWkpZZ
        SFoWMLKsYpRMLSjOTc8tNiwwykst1ytOzC0uzUvXS87P3cQIjhYtrR2MJ07EH2IU4GBU4uHV
        eFgZJ8SaWFZcmXuIUYKDWUmEd3NqRZwQb0piZVVqUX58UWlOavEhRmkOFiVxXvn8Y5FCAumJ
        JanZqakFqUUwWSYOTqkGRqUwq7Uyl76zz9hoeHDZt8oHv/hXMpR6HPs0oSEvuXHth5z+G78Z
        LjqZSWeunrtHZlP2kU0CpXX6H+zVbkTJp9+fl3aJK6X6zMnp6zJq/v5XP5Dgw/ZPM/Duuk8J
        jyqd039WH1Np/8vCpBjQtvDx2lpTAb97zIEMyU+fW3tmZdwMapsyZ42gmxJLcUaioRZzUXEi
        AI3B2a6SAgAA
X-CMS-MailID: 20200324222903epcas1p241bb9a19d8e75e784c6f7dcd4214b24b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200323215949epcas1p33af2bba09c458dd09ed22e3de200955a
References: <CGME20200323215949epcas1p33af2bba09c458dd09ed22e3de200955a@epcas1p3.samsung.com>
        <20200323215939.79008-1-hdegoede@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/24/20 6:59 AM, Hans de Goede wrote:
> On devices with an AXP288, we need to wakeup from suspend when a charger
> is plugged in, so that we can do charger-type detection and so that the
> axp288-charger driver, which listens for our extcon events, can configure
> the input-current-limit accordingly.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/extcon/extcon-axp288.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/drivers/extcon/extcon-axp288.c b/drivers/extcon/extcon-axp288.c
> index a7f216191493..710a3bb66e95 100644
> --- a/drivers/extcon/extcon-axp288.c
> +++ b/drivers/extcon/extcon-axp288.c
> @@ -443,9 +443,40 @@ static int axp288_extcon_probe(struct platform_device *pdev)
>  	/* Start charger cable type detection */
>  	axp288_extcon_enable(info);
>  
> +	device_init_wakeup(dev, true);
> +	platform_set_drvdata(pdev, info);
> +
> +	return 0;
> +}
> +
> +static int __maybe_unused axp288_extcon_suspend(struct device *dev)
> +{
> +	struct axp288_extcon_info *info = dev_get_drvdata(dev);
> +
> +	if (device_may_wakeup(dev))
> +		enable_irq_wake(info->irq[VBUS_RISING_IRQ]);
> +
>  	return 0;
>  }
>  
> +static int __maybe_unused axp288_extcon_resume(struct device *dev)
> +{
> +	struct axp288_extcon_info *info = dev_get_drvdata(dev);
> +
> +	/*
> +	 * Wakeup when a charger is connected to do charger-type
> +	 * connection and generate an extcon event which makes the
> +	 * axp288 charger driver set the input current limit.
> +	 */
> +	if (device_may_wakeup(dev))
> +		disable_irq_wake(info->irq[VBUS_RISING_IRQ]);
> +
> +	return 0;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(axp288_extcon_pm_ops, axp288_extcon_suspend,
> +			 axp288_extcon_resume);
> +
>  static const struct platform_device_id axp288_extcon_table[] = {
>  	{ .name = "axp288_extcon" },
>  	{},
> @@ -457,6 +488,7 @@ static struct platform_driver axp288_extcon_driver = {
>  	.id_table = axp288_extcon_table,
>  	.driver = {
>  		.name = "axp288_extcon",
> +		.pm = &axp288_extcon_pm_ops,
>  	},
>  };
>  
> 

Applied it. Thanks.


-- 
Best Regards,
Chanwoo Choi
Samsung Electronics
