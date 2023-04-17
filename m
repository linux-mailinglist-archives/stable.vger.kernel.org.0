Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9496E4792
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 14:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjDQMXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 08:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjDQMXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 08:23:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976F419A5
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 05:22:37 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1poNrw-000410-JM; Mon, 17 Apr 2023 14:22:04 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1poNrs-00018M-Fb; Mon, 17 Apr 2023 14:22:00 +0200
Date:   Mon, 17 Apr 2023 14:22:00 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Tim K <tpkuester@gmail.com>, "Alex G ." <mr.nuke.me@gmail.com>,
        Nick Morrow <morrownr@gmail.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Andreas Henriksson <andreas@fatal.se>,
        ValdikSS <iam@valdikss.org.ru>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] wifi: rtw88: rtw8821c: Fix rfe_option field width
Message-ID: <20230417122200.GN13543@pengutronix.de>
References: <20230404072508.578056-1-s.hauer@pengutronix.de>
 <20230404072508.578056-3-s.hauer@pengutronix.de>
 <e9c9b7d470904d9f8c8d6892cb8efd7d@realtek.com>
 <20230411102609.GB19113@pengutronix.de>
 <303221420e8e467dba0857261970d254@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <303221420e8e467dba0857261970d254@realtek.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 14, 2023 at 02:05:44AM +0000, Ping-Ke Shih wrote:
> 
> > -----Original Message-----
> > From: Sascha Hauer <s.hauer@pengutronix.de>
> > Sent: Tuesday, April 11, 2023 6:26 PM
> > To: Ping-Ke Shih <pkshih@realtek.com>
> > Cc: linux-wireless <linux-wireless@vger.kernel.org>; Hans Ulli Kroll <linux@ulli-kroll.de>; Larry Finger
> > <Larry.Finger@lwfinger.net>; Tim K <tpkuester@gmail.com>; Alex G . <mr.nuke.me@gmail.com>; Nick Morrow
> > <morrownr@gmail.com>; Viktor Petrenko <g0000ga@gmail.com>; Andreas Henriksson <andreas@fatal.se>;
> > ValdikSS <iam@valdikss.org.ru>; kernel@pengutronix.de; stable@vger.kernel.org
> > Subject: Re: [PATCH v2 2/2] wifi: rtw88: rtw8821c: Fix rfe_option field width
> > 
> > On Thu, Apr 06, 2023 at 01:54:55AM +0000, Ping-Ke Shih wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Sascha Hauer <s.hauer@pengutronix.de>
> > > > Sent: Tuesday, April 4, 2023 3:25 PM
> > > > To: linux-wireless <linux-wireless@vger.kernel.org>
> > > > Cc: Hans Ulli Kroll <linux@ulli-kroll.de>; Larry Finger <Larry.Finger@lwfinger.net>; Ping-Ke Shih
> > > > <pkshih@realtek.com>; Tim K <tpkuester@gmail.com>; Alex G . <mr.nuke.me@gmail.com>; Nick Morrow
> > > > <morrownr@gmail.com>; Viktor Petrenko <g0000ga@gmail.com>; Andreas Henriksson <andreas@fatal.se>;
> > > > ValdikSS <iam@valdikss.org.ru>; kernel@pengutronix.de; Sascha Hauer <s.hauer@pengutronix.de>;
> > > > stable@vger.kernel.org
> > > > Subject: [PATCH v2 2/2] wifi: rtw88: rtw8821c: Fix rfe_option field width
> > > >
> > > > On my RTW8821CU chipset rfe_option reads as 0x22. Looking at the
> > > > downstream driver suggests that the field width of rfe_option is 5 bit,
> > > > so rfe_option should be masked with 0x1f.
> > >
> > > I don't aware of this. Could you point where you get it?
> > 
> > See
> > https://github.com/morrownr/8821cu-20210916/blob/main/hal/btc/halbtc8821c1ant.c#L2480
> > and
> > https://github.com/morrownr/8821cu-20210916/blob/main/hal/btc/halbtc8821c2ant.c#L2519
> > 
> > But I now see that this masked value is only used at the places I
> > pointed to, there are other places in the driver that use the unmasked
> > value.
> 
> After I read vendor driver, there are three variety of rfe_option for 8821C.
> 1. raw value from efuse
>    hal->rfe_type = map[EEPROM_RFE_OPTION_8821C];
> 
> 2. BT-coexistence 
>    rfe_type->rfe_module_type = board_info->rfe_type & 0x1f;
> 
> 3. PHY
>    dm->rfe_type_expand = hal->rfe_type = raw value
>    dm->rfe_type = dm->rfe_type_expand >> 3;
> 
> 
> For rtw88, there are only two variety, but they are identical
>    coex_rfe->rfe_module_type = efuse->rfe_option;
> 
> The flaws are rfe_type->rfe_module_type of item 2 and dm->rfe_type of item 3
> above, and most things are addressed by your draft patch. Exception is
> check_positive() check dm->rfe_type, but we don't have this conversion in
> rtw88 (i.e. cond.rfe = efuse->rfe_option; in rtw_phy_setup_phy_cond()).
> 
> Since I don't have a hardware with rfe_option larger than 8, could you
> please give below patch a try?
> 
> --- a/phy.c
> +++ b/phy.c
> @@ -1048,6 +1048,9 @@ void rtw_phy_setup_phy_cond(struct rtw_dev *rtwdev, u32 pkg)
>         cond.plat = 0x04;
>         cond.rfe = efuse->rfe_option;
> 
> +       if (rtwdev->chip->id == RTW_CHIP_TYPE_8821C)
> +               cond.rfe = efuse->rfe_option >> 3;
> +
>         switch (rtw_hci_type(rtwdev)) {
>         case RTW_HCI_TYPE_USB:
>                 cond.intf = INTF_USB;

This change doesn't make any difference. cond.rfe is only used in
check_positive() which is implemented like this:

static bool check_positive(struct rtw_dev *rtwdev, struct rtw_phy_cond cond)
{
	struct rtw_hal *hal = &rtwdev->hal;
	struct rtw_phy_cond drv_cond = hal->phy_cond;

	if (cond.cut && cond.cut != drv_cond.cut)
		return false;

	if (cond.pkg && cond.pkg != drv_cond.pkg)
		return false;

	if (cond.intf && cond.intf != drv_cond.intf)
		return false;

	if (cond.rfe != drv_cond.rfe)
		return false;

	return true;
}

In my case check_positive() always returns early when comparing cond.pkg which
is always set to '15' in rtw_phy_setup_phy_cond():

void rtw_phy_setup_phy_cond(struct rtw_dev *rtwdev, u32 pkg)
{
	...
	cond.pkg = pkg ? pkg : 15;
	...
}

In the upstream driver rtw_phy_setup_phy_cond() is only ever called with
'0' as pkg argument. Now in the downstream driver I found this snippet:

void phydm_init_hw_info_by_rfe_type_8821c(struct dm_struct *dm)
{
	...

        if (dm->rfe_type_expand == 2 || dm->rfe_type_expand == 4 || dm->rfe_type_expand == 7) {
                dm->default_rf_set_8821c = SWITCH_TO_BTG;
        } else if (dm->rfe_type_expand == 0 || dm->rfe_type_expand == 1 ||
                   dm->rfe_type_expand == 3 || dm->rfe_type_expand == 5 ||
                   dm->rfe_type_expand == 6) {
                dm->default_rf_set_8821c = SWITCH_TO_WLG;
        } else if (dm->rfe_type_expand == 0x22 || dm->rfe_type_expand == 0x24 ||
                   dm->rfe_type_expand == 0x27 || dm->rfe_type_expand == 0x2a ||
                   dm->rfe_type_expand == 0x2c || dm->rfe_type_expand == 0x2f) {
                dm->default_rf_set_8821c = SWITCH_TO_BTG;
                odm_cmn_info_init(dm, ODM_CMNINFO_PACKAGE_TYPE, 1);
        } else if (dm->rfe_type_expand == 0x20 || dm->rfe_type_expand == 0x21 ||
                   dm->rfe_type_expand == 0x23 || dm->rfe_type_expand == 0x25 ||
                   dm->rfe_type_expand == 0x26 || dm->rfe_type_expand == 0x28 ||
                   dm->rfe_type_expand == 0x29 || dm->rfe_type_expand == 0x2b ||
                   dm->rfe_type_expand == 0x2d || dm->rfe_type_expand == 0x2e) {
                dm->default_rf_set_8821c = SWITCH_TO_WLG;
                odm_cmn_info_init(dm, ODM_CMNINFO_PACKAGE_TYPE, 1);
        }

	...
}

odm_cmn_info_init(dm, ODM_CMNINFO_PACKAGE_TYPE, 1); seems to be the
analogue of the pkg type argument. This suggests that for rfe_type >=
0x20 we should call rtw_phy_setup_phy_cond() with '1' as pkg argument.
When doing this here I will end up with check_positive() returning
'true' in some cases.  However, I didn't notice any change in the driver
behaviour then.

Note how the above code snippet looks like the rfe_type is indeed
encoded in the lower 5 bits whereas BIT(5) could be used as the package
type. That could be by chance, but it's striking that rfe_type (x) always
ends up in the same code path as (x + 0x20) also in other parts of this
file.

I'm a bit lost here. I suggest that we stick with the variant I tried in
v1 of this series, but I'll add a note that there might be some
inaccuracies in how some currently unknown chip variants are handled.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
