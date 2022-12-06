Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61473643FEE
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 10:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbiLFJhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 04:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235108AbiLFJhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 04:37:08 -0500
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2067.outbound.protection.outlook.com [40.92.53.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AEEDF5F;
        Tue,  6 Dec 2022 01:37:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KqXpQb3/49Xp4Bg+RjSCcR2Url+ugfad9yLlRDd6G+tUCo1YzA8kHm897gSZsK5GI3fqXQff8TOq1s2+BOs/eXfalpLCdbzXM8nRm/u4OGTFbY/dFNoSKepIQ3xDQM7bLrAXRhwKIVFEqEOe9yXecV4x2xtZqe4Oxr5euW5M7sN6UMqETHplIojpoZBT8H+VGjTFZ7E2NlGm7dTaz9o/r2sbtgKjHTTjx4omi2PByL4XC1gd12eg+N+761jMgQvl5l1/j4+y3P1YfN4s1MsECchqORZi1eAMMK+aD4TmWRucJOITBccxXVax1UHNNlb8NLSb0DUD6fgNnguF9QwR7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u6IaMZZ9tebl5XumMYBGTVA6TlDmw79NvGt3X27cSVs=;
 b=UB94Tcnnb/45DL5a7IHbuyTSoCvpTk2REKFWeCxxalHiDFf/9kSzwxTzzsFqKdDBn8/fxOq+YGUGxWldMTiOI9ePvd4mAmS/Ic1WBJfRghqEjeVEbE/GanRc1xChpdLXvarRqPGUwY3bbkQ60AlwtcAyDv4ow81dJm+bKLbI8Jh81Y2VFCSxmayFVHFg4pcGC/UGOMokMbeknFeOrI/QdIQqWoNm5P4dmS5sZnyxJoq0AJmvY1e2qaB3QhDTNhzzlei1pVBvBPUZ71AzExXTIjo3+ZcCQ1siGZ0uZSc7Lm/U8Mwsx9qnWRNWePTv0RglfnyTnKJ+saH+nZq9MxTkUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u6IaMZZ9tebl5XumMYBGTVA6TlDmw79NvGt3X27cSVs=;
 b=fgytWXOT9ZGCm0aIfzuY3lZm4j+A5iOwG5gHgK0nFAJcPRcyHwQI+YxH28MyZwchjM1D1xanCAeFFaRmeDpTuooT9C8iGsNLvMsKCf3xfdYal8KXd/0d4/eOvW/EzvDB9/Rx07MFNncrJuP8vQyZHfi2hvrNowbvyJ394AJJ+iTcK/oLBe25Q4IeiR/20D+2i9BUF01PKwDh0ZD2oD4ltjs6R42nZHTagF4d3SBfGST0zKvESN82MRA+0AuocsBfM1d96zacRmkjgJSKbyCPM5Bjh6rrirXRl7q0nFN2xmS6aUzbkyCt7XesJEec/RDAWe4MWxSRClRxZ+2Lx8SvxA==
Received: from SG2PR02MB5878.apcprd02.prod.outlook.com (2603:1096:4:1d2::9) by
 TY0PR02MB5790.apcprd02.prod.outlook.com (2603:1096:400:1b5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 09:37:02 +0000
Received: from SG2PR02MB5878.apcprd02.prod.outlook.com
 ([fe80::2c81:c803:d49b:eebb]) by SG2PR02MB5878.apcprd02.prod.outlook.com
 ([fe80::2c81:c803:d49b:eebb%6]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 09:37:02 +0000
From:   Dicheng Wang <wangdicheng123@hotmail.com>
To:     perex@perex.cz, tiwai@suse.com, sdoregor@sdore.me,
        connerknoxpublic@gmail.com, wangdicheng@kylinos.cn,
        hahnjo@hahnjo.de, john-linux@pelago.org.uk
Cc:     alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2 -next] ALSA:usb-audio:Add the information of KT0206 device driven by USB audio
Date:   Tue,  6 Dec 2022 17:36:37 +0800
Message-ID: <SG2PR02MB58780ED138433086A3213AE98A1B9@SG2PR02MB5878.apcprd02.prod.outlook.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [kOYsakc9vfiiplObWFNDSx+Ar7j0WU7oP/cCeTZ1vPY=]
X-ClientProxiedBy: TYAPR01CA0129.jpnprd01.prod.outlook.com
 (2603:1096:404:2d::21) To SG2PR02MB5878.apcprd02.prod.outlook.com
 (2603:1096:4:1d2::9)
X-Microsoft-Original-Message-ID: <20221206093637.20093-1-wangdicheng123@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SG2PR02MB5878:EE_|TY0PR02MB5790:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ffd90ad-788b-4e66-de53-08dad76d6dae
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iw39xBgGz6/a4q3CW9PP4vsGPDJemFqlHS6elDwKIGZWoYrGb10xtj28dffvo8y59umC7RDe7IKKLZ8pIP5sL6o2saPCylBki2tKr3Hd3Q6B5svCjCaLVOvY4+Y+l3BofFoL/uCutKR72xxg7Dsgus9KLgQIRo+kYkPd07yxv47bWezn7Blb/ZUt0Sd0+bhMX57GdcPrF8SElfcyBdYUwOACxqR393AJOuAOxNqULqClMhdrETQQgR9wrWzpMcYCtHQ9W/D9mhDmIIqJjzm9R0ndTZBdX0iw0GjrDZ8rCatF5mrszswuaDlpulvZrPUEteimYdUrafAteE3JKEb9uOP9X6GBBJPJ/5/IfJpxQ7HQH8UV+Of235anuGddX7LBSbGjb8ZdomfCSFY8aVLZofktSbJl91/x4t2bhy78AJSIQKm8YbVZ/2Jq99hPL6miS/865AMsi+Ahs74w5tgvRDQuWJO199NmGajcI5YOk//XoOWQet+ARFheRf1FvlkS3sdW6OnoRoLf+kHjxxnAVe1VEYz9uyPk6wCNv3SIrzvB4EFZY9EROGkn7XPS/21iyaEgF0qJugBNGohytNQLvoMfgOvBSp34s12I1jiZRd0=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hnotf4Shh3yWV2bMpP8gAuDO6wpX+tEq9fsYqOpCMecasVLR8zKOyXGPmOd8?=
 =?us-ascii?Q?DkXdAuh2181wY2E2EOo4l9sVYNDaLFYrU8sMinS7dniCEzg7igBOsSjy0IQE?=
 =?us-ascii?Q?TSRqYLp1CjsuV416pWB+AiN95ojTjWMK0CWFLADcAodT4lO1kxGBV5rutOhE?=
 =?us-ascii?Q?fd+7IgEAdmJxBcjx4ntNwe2C1xW6nPjhqDIFDfNlUZ5cEhuO/eIzO7nTpBxZ?=
 =?us-ascii?Q?qroaUCJAHADNHLhAJ+9OpVAGYCesrmly/PV1kQ1H+9XQe/q+zPS1O2lANC9T?=
 =?us-ascii?Q?OZcj7OOk+jSIAoRw+8qZqlIaJcMvT+PcNo6POQhazEn0N6Wd0OEN3QLSOM9p?=
 =?us-ascii?Q?2F10IXHH5KiKUuRajNG/jgqzqqWpPeHidb3/SJlTHY24J51f5N7X9kMkC4PH?=
 =?us-ascii?Q?o3t6gBDXkk+K6HmnitkIKYU1Q5OFxmLSgaONZ+730n8vQbGsDtBHk/o3uiSY?=
 =?us-ascii?Q?LekJZIjnUuyGsIJ692D8kNNmeu/S+pvDwY3jabZpXSqgeZDSg1KHBtz67IJ2?=
 =?us-ascii?Q?SJaXRP2+5CuguFme6W1ojf5YXXmEuPost35EPQU7u953DSje72xQZ5sgb5rx?=
 =?us-ascii?Q?itVSVBs2ppMcu99lxs7h9WMFmX6bQnN8stjKZQg824AuTLBI/1Xji/re6Wr4?=
 =?us-ascii?Q?IBNRsUTStSKe9kW5bA34neVgm5XNDnl8DweH5y4oZYiO9GsZ9lfpriekTHpi?=
 =?us-ascii?Q?6wcLsEaIVgx+/x1VP6AxvEyhpubQ/E2HZj2oRPjNW1dNoMGBEVhuF+QeA4Q/?=
 =?us-ascii?Q?MeYHpLAN8EGOv9lE7hh6eEsfXPB1aHkcX+PkhjTNwQ+0uEr98+yux9z96eOR?=
 =?us-ascii?Q?OF6Uwa/O5qQKIsYsPuYYGHYFuky0H/Q+ZlhGgTr/PAtoVig+hqdcGF54Jqra?=
 =?us-ascii?Q?81WXjSy9np8AjuPK8w5TSgV/mT2tP3iaRUK4rb6q0TmSyyexteNP+6GIjP3r?=
 =?us-ascii?Q?vUO7Kf7IkUa1DnMEHESE5SyQVnGojJadahhf9lA2e6jJcg2Y3BS/0pm5B+9s?=
 =?us-ascii?Q?Y4Yjno/soOWEsTDrjCwFLW+lHNVLlfFrJ3/B6yTuCQkTSah9Ixbflmt4VVzV?=
 =?us-ascii?Q?WwsrbWQbtJ53dbVfx6U7p8J2e6xWxGVaaAibOOtanGtV66St+cgdZBjyBAlO?=
 =?us-ascii?Q?EHqoNuo/xfnwG8SDGhsySdBrPVz1jvwUoA/yztegsjaeDhB/L5xvShk+PHjz?=
 =?us-ascii?Q?KFMLXr+PJr1rMA4DFEd/1Zyd5BMioojySFKaulQ7bbYdSweO5f0hhGyL5edp?=
 =?us-ascii?Q?CVv8oTQpb1l5npX1NXPXoqT7FosZR+F1Okko/wuLPjJ4M7MbR9rNaUT09hXi?=
 =?us-ascii?Q?YKM=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-20e34.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ffd90ad-788b-4e66-de53-08dad76d6dae
X-MS-Exchange-CrossTenant-AuthSource: SG2PR02MB5878.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 09:37:02.4491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR02MB5790
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wangdicheng <wangdicheng@kylinos.cn>

Cc: stable@vger.kernel.org
Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
---
v2:use USB_DEVICE_VENDOR_SPEC() suggested by Takashi Iwai

 sound/usb/quirks-table.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 874fcf245747..271884e35003 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -76,6 +76,8 @@
 { USB_DEVICE_VENDOR_SPEC(0x041e, 0x3f0a) },
 /* E-Mu 0204 USB */
 { USB_DEVICE_VENDOR_SPEC(0x041e, 0x3f19) },
+/* Ktmicro Usb_audio device */
+{ USB_DEVICE_VENDOR_SPEC(0x31b2, 0x0011) },
 
 /*
  * Creative Technology, Ltd Live! Cam Sync HD [VF0770]
-- 
2.25.1

