Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37616D8D18
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 03:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbjDFBzz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 5 Apr 2023 21:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjDFBzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 21:55:54 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2133383D2;
        Wed,  5 Apr 2023 18:55:35 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 3361saDlB028391, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 3361saDlB028391
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Thu, 6 Apr 2023 09:54:36 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Thu, 6 Apr 2023 09:54:56 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 6 Apr 2023 09:54:55 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Thu, 6 Apr 2023 09:54:55 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        linux-wireless <linux-wireless@vger.kernel.org>
CC:     Hans Ulli Kroll <linux@ulli-kroll.de>,
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
Thread-Index: AQHZZsamg/4VwhlxlEqb+Fqs2PgqWa8dhrAA
Date:   Thu, 6 Apr 2023 01:54:55 +0000
Message-ID: <e9c9b7d470904d9f8c8d6892cb8efd7d@realtek.com>
References: <20230404072508.578056-1-s.hauer@pengutronix.de>
 <20230404072508.578056-3-s.hauer@pengutronix.de>
In-Reply-To: <20230404072508.578056-3-s.hauer@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Sascha Hauer <s.hauer@pengutronix.de>
> Sent: Tuesday, April 4, 2023 3:25 PM
> To: linux-wireless <linux-wireless@vger.kernel.org>
> Cc: Hans Ulli Kroll <linux@ulli-kroll.de>; Larry Finger <Larry.Finger@lwfinger.net>; Ping-Ke Shih
> <pkshih@realtek.com>; Tim K <tpkuester@gmail.com>; Alex G . <mr.nuke.me@gmail.com>; Nick Morrow
> <morrownr@gmail.com>; Viktor Petrenko <g0000ga@gmail.com>; Andreas Henriksson <andreas@fatal.se>;
> ValdikSS <iam@valdikss.org.ru>; kernel@pengutronix.de; Sascha Hauer <s.hauer@pengutronix.de>;
> stable@vger.kernel.org
> Subject: [PATCH v2 2/2] wifi: rtw88: rtw8821c: Fix rfe_option field width
> 
> On my RTW8821CU chipset rfe_option reads as 0x22. Looking at the
> downstream driver suggests that the field width of rfe_option is 5 bit,
> so rfe_option should be masked with 0x1f.

I don't aware of this. Could you point where you get it?

As I check it internally, 0x22 is expected, so I suggest to have 0x22 entry
as below

-       [34] = RTW_DEF_RFE(8821c, 0, 0),
+       [34] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),  // copy from type 2

> 
> Without this the rfe_option comparisons with 2 further down the
> driver evaluate as false when they should really evaluate as true.
> The effect is that 2G channels do not work.
> 
> rfe_option is also used as an array index into rtw8821c_rfe_defs[].
> rtw8821c_rfe_defs[34] (0x22) was added as part of adding USB support,
> likely because rfe_option reads as 0x22. As this now becomes 0x2,
> rtw8821c_rfe_defs[34] is no longer used and can be removed.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Tested-by: ValdikSS <iam@valdikss.org.ru>
> Tested-by: Alexandru gagniuc <mr.nuke.me@gmail.com>
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: stable@vger.kernel.org
> ---
>  drivers/net/wireless/realtek/rtw88/rtw8821c.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
> b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
> index 17f800f6efbd0..67efa58dd78ee 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
> @@ -47,7 +47,7 @@ static int rtw8821c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
> 
>         map = (struct rtw8821c_efuse *)log_map;
> 
> -       efuse->rfe_option = map->rfe_option;
> +       efuse->rfe_option = map->rfe_option & 0x1f;
>         efuse->rf_board_option = map->rf_board_option;
>         efuse->crystal_cap = map->xtal_k;
>         efuse->pa_type_2g = map->pa_type;
> @@ -1537,7 +1537,6 @@ static const struct rtw_rfe_def rtw8821c_rfe_defs[] = {
>         [2] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
>         [4] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
>         [6] = RTW_DEF_RFE(8821c, 0, 0),
> -       [34] = RTW_DEF_RFE(8821c, 0, 0),
>  };
> 
>  static struct rtw_hw_reg rtw8821c_dig[] = {
> --
> 2.39.2

