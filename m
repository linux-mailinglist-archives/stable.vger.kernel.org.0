Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82CFF6E19FA
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 04:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjDNCGu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 13 Apr 2023 22:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjDNCGu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 22:06:50 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B573C3A;
        Thu, 13 Apr 2023 19:06:47 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 33E25M9L0008987, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 33E25M9L0008987
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Fri, 14 Apr 2023 10:05:22 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Fri, 14 Apr 2023 10:05:44 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 14 Apr 2023 10:05:44 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Fri, 14 Apr 2023 10:05:44 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>
CC:     linux-wireless <linux-wireless@vger.kernel.org>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Tim K <tpkuester@gmail.com>, "Alex G ." <mr.nuke.me@gmail.com>,
        Nick Morrow <morrownr@gmail.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Andreas Henriksson <andreas@fatal.se>,
        ValdikSS <iam@valdikss.org.ru>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] wifi: rtw88: rtw8821c: Fix rfe_option field width
Thread-Topic: [PATCH v2 2/2] wifi: rtw88: rtw8821c: Fix rfe_option field width
Thread-Index: AQHZZsamg/4VwhlxlEqb+Fqs2PgqWa8dhrAAgAfltoCABKdF8A==
Date:   Fri, 14 Apr 2023 02:05:44 +0000
Message-ID: <303221420e8e467dba0857261970d254@realtek.com>
References: <20230404072508.578056-1-s.hauer@pengutronix.de>
 <20230404072508.578056-3-s.hauer@pengutronix.de>
 <e9c9b7d470904d9f8c8d6892cb8efd7d@realtek.com>
 <20230411102609.GB19113@pengutronix.de>
In-Reply-To: <20230411102609.GB19113@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> -----Original Message-----
> From: Sascha Hauer <s.hauer@pengutronix.de>
> Sent: Tuesday, April 11, 2023 6:26 PM
> To: Ping-Ke Shih <pkshih@realtek.com>
> Cc: linux-wireless <linux-wireless@vger.kernel.org>; Hans Ulli Kroll <linux@ulli-kroll.de>; Larry Finger
> <Larry.Finger@lwfinger.net>; Tim K <tpkuester@gmail.com>; Alex G . <mr.nuke.me@gmail.com>; Nick Morrow
> <morrownr@gmail.com>; Viktor Petrenko <g0000ga@gmail.com>; Andreas Henriksson <andreas@fatal.se>;
> ValdikSS <iam@valdikss.org.ru>; kernel@pengutronix.de; stable@vger.kernel.org
> Subject: Re: [PATCH v2 2/2] wifi: rtw88: rtw8821c: Fix rfe_option field width
> 
> On Thu, Apr 06, 2023 at 01:54:55AM +0000, Ping-Ke Shih wrote:
> >
> >
> > > -----Original Message-----
> > > From: Sascha Hauer <s.hauer@pengutronix.de>
> > > Sent: Tuesday, April 4, 2023 3:25 PM
> > > To: linux-wireless <linux-wireless@vger.kernel.org>
> > > Cc: Hans Ulli Kroll <linux@ulli-kroll.de>; Larry Finger <Larry.Finger@lwfinger.net>; Ping-Ke Shih
> > > <pkshih@realtek.com>; Tim K <tpkuester@gmail.com>; Alex G . <mr.nuke.me@gmail.com>; Nick Morrow
> > > <morrownr@gmail.com>; Viktor Petrenko <g0000ga@gmail.com>; Andreas Henriksson <andreas@fatal.se>;
> > > ValdikSS <iam@valdikss.org.ru>; kernel@pengutronix.de; Sascha Hauer <s.hauer@pengutronix.de>;
> > > stable@vger.kernel.org
> > > Subject: [PATCH v2 2/2] wifi: rtw88: rtw8821c: Fix rfe_option field width
> > >
> > > On my RTW8821CU chipset rfe_option reads as 0x22. Looking at the
> > > downstream driver suggests that the field width of rfe_option is 5 bit,
> > > so rfe_option should be masked with 0x1f.
> >
> > I don't aware of this. Could you point where you get it?
> 
> See
> https://github.com/morrownr/8821cu-20210916/blob/main/hal/btc/halbtc8821c1ant.c#L2480
> and
> https://github.com/morrownr/8821cu-20210916/blob/main/hal/btc/halbtc8821c2ant.c#L2519
> 
> But I now see that this masked value is only used at the places I
> pointed to, there are other places in the driver that use the unmasked
> value.

After I read vendor driver, there are three variety of rfe_option for 8821C.
1. raw value from efuse
   hal->rfe_type = map[EEPROM_RFE_OPTION_8821C];

2. BT-coexistence 
   rfe_type->rfe_module_type = board_info->rfe_type & 0x1f;

3. PHY
   dm->rfe_type_expand = hal->rfe_type = raw value
   dm->rfe_type = dm->rfe_type_expand >> 3;


For rtw88, there are only two variety, but they are identical
   coex_rfe->rfe_module_type = efuse->rfe_option;

The flaws are rfe_type->rfe_module_type of item 2 and dm->rfe_type of item 3
above, and most things are addressed by your draft patch. Exception is
check_positive() check dm->rfe_type, but we don't have this conversion in
rtw88 (i.e. cond.rfe = efuse->rfe_option; in rtw_phy_setup_phy_cond()).

Since I don't have a hardware with rfe_option larger than 8, could you
please give below patch a try?

--- a/phy.c
+++ b/phy.c
@@ -1048,6 +1048,9 @@ void rtw_phy_setup_phy_cond(struct rtw_dev *rtwdev, u32 pkg)
        cond.plat = 0x04;
        cond.rfe = efuse->rfe_option;

+       if (rtwdev->chip->id == RTW_CHIP_TYPE_8821C)
+               cond.rfe = efuse->rfe_option >> 3;
+
        switch (rtw_hci_type(rtwdev)) {
        case RTW_HCI_TYPE_USB:
                cond.intf = INTF_USB;


8821C is more complex than others, and I'm not familiar with it, so maybe I
could miss something. Please correct me if any.

> 
> >
> > As I check it internally, 0x22 is expected, so I suggest to have 0x22 entry
> > as below
> >
> > -       [34] = RTW_DEF_RFE(8821c, 0, 0),
> > +       [34] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),  // copy from type 2
> 
> That alone is not enough. There are other places in rtw8821c.c that
> compare with rfe_option. See below for a patch with annotations where to
> find the corresponding code in the downstream driver. Note how BIT(5) is
> irrelevant for all decisions. I can't tell of course if that's just by
> chance or by intent.

You're right. I miss these points.

> 
> I don't know where to go from here. It looks like we really only want to
> make a decision between SWITCH_TO_WLG and SWITCH_TO_BTG at most places,
> so it might be better to store a flag somewhere rather than having the
> big switch/case in multiple places.
> 

Agreed. Add something like:

--- a/main.h
+++ b/main.h
@@ -2076,6 +2076,7 @@ struct rtw_hal {
        u8 mp_chip;
        u8 oem_id;
        struct rtw_phy_cond phy_cond;
+       bool rfe_btg;

        u8 ps_mode;
        u8 current_channel;

--- a/rtw8821c.c
+++ b/rtw8821c.c
@@ -47,6 +47,7 @@ enum rtw8821ce_rf_set {

 static int rtw8821c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 {
+       struct rtw_hal *hal = &rtwdev->hal;
        struct rtw_efuse *efuse = &rtwdev->efuse;
        struct rtw8821c_efuse *map;
        int i;
@@ -91,6 +92,12 @@ static int rtw8821c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
                return -ENOTSUPP;
        }

+       switch (efuse->rfe_option) {
+       case 0x02: case 0x22: // ...
+               hal->rfe_btg = true;
+               break;
+       }
+
        return 0;
 }


[...]

>  static const struct rtw_rfe_def rtw8821c_rfe_defs[] = {
> -       [0] = RTW_DEF_RFE(8821c, 0, 0),
> -       [2] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
> -       [4] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
> -       [6] = RTW_DEF_RFE(8821c, 0, 0),
> -       [34] = RTW_DEF_RFE(8821c, 0, 0),
> +       [0x00] = RTW_DEF_RFE(8821c, 0, 0),
> +       [0x01] = RTW_DEF_RFE(8821c, 0, 0),
> +       [0x02] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
> +       [0x03] = RTW_DEF_RFE(8821c, 0, 0),
> +       [0x04] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
> +       [0x05] = RTW_DEF_RFE(8821c, 0, 0),
> +       [0x06] = RTW_DEF_RFE(8821c, 0, 0),
> +       [0x07] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
> +       [0x20] = RTW_DEF_RFE(8821c, 0, 0),
> +       [0x21] = RTW_DEF_RFE(8821c, 0, 0),
> +       [0x22] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
> +       [0x23] = RTW_DEF_RFE(8821c, 0, 0),
> +       [0x24] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
> +       [0x25] = RTW_DEF_RFE(8821c, 0, 0),
> +       [0x26] = RTW_DEF_RFE(8821c, 0, 0),
> +       [0x27] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
> +       [0x28] = RTW_DEF_RFE(8821c, 0, 0),
> +       [0x29] = RTW_DEF_RFE(8821c, 0, 0),
> +       [0x2a] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
> +       [0x2b] = RTW_DEF_RFE(8821c, 0, 0),
> +       [0x2c] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
> +       [0x2d] = RTW_DEF_RFE(8821c, 0, 0),
> +       [0x2e] = RTW_DEF_RFE(8821c, 0, 0),
> +       [0x2f] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),

I'm not sure if we add all of them, since some aren't tested, but maybe it would
be better than nothing. 

Ping-Ke

