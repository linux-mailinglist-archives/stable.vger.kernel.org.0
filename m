Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0130D645280
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 04:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiLGDUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 22:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiLGDUp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 22:20:45 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01olkn2043.outbound.protection.outlook.com [40.92.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6998554D7;
        Tue,  6 Dec 2022 19:20:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kb3CSGm6N4TVqvfWRYCxM7Vwk4pmhyzW/5keLOVoOxPasvGV2Vl/Gkbodkd+DvIk71m/PtGH0v1JakaCkRn+IbaoXCQf2EMPyfCcaguUKpNCOriS1UZSdbiq524MfoxAJoxLZ7VRgks8cdXuO7dyTV5AieTKHcB4IF95+jx/83cZ4MzfSbuttee5Xi5TaDL9IjPy9YY71qHPz4LDxQuqf1QL/0iN+lLYBR7M/b4W40PGzJ2p3ZPVheqgKBVULaPIs7NJYO0hI9tC4u4Zo0qXxOUH6x+x3x5LiIUX5LMXfbvbSUn33LP2g12yFkOdkGqe/4A+EVoTNaHWt7VASlLjvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ygrx8jG4GN9LmJLO6IGTc3kPJztQLPVgtjoAyjN1eo=;
 b=M5s4T97MjuE41qspCjf5w3BpnU2cR9sn6VOFWmFYqV6IzhIgJgKeRPy/O8zmXBco3XRkN5kHG3O2M1oCDk5oBGXWlw66hshw700/U8K+bVFrd+kGSPXlw0E9jMcPAzv5lliP5yYPajzKBL2quiAOLLN9d9QgiYSlDTaAhMRak99Xnu3d7dIE8WCbW5YEM8mom/saXPqo1k9nGPVbMEhLn/hoDY3CijYs44oo+cPQEh0G+bQ9UTtZ5dkaNFNTYQdOyEhUDW3FGmi7Nzw5Msu18/1U/b6IVBVUObSdgtNW0Ug60f9g1bTMCe5FvfFOFqM+QqN/GubaLq1R1gflTfsglg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ygrx8jG4GN9LmJLO6IGTc3kPJztQLPVgtjoAyjN1eo=;
 b=iXTJYRGek340MwwnJPyTgzqGAon2t0wQoAy0jHYH3pJqcl+inyGz+tVzVfg0apelkd6Vqp9vImVxUL06Zi8eolZ/guzQurmn2tEpSRNDkSHsMiif4APLID9aW3ChIfrEUduKVR2ufeXEuL3WjbeZP4+cd+6zBraQvdUDmL65uEvd4InNPvlkL7bCJLCwSsIqfOdyM22qsIfivSVap8qKgy54J8o6HX5oLBHCQgmJKnWf9FvAE5Xow4StP9B+Ay9b7P0kvnF5tEpDk0KXb0CfoqM8kttPgy8tf/GNSgSOIMKsznkRGJ8rh3beUjC330IDLA/cseJOPzDewx8SFT6Qqg==
Received: from SG2PR02MB5878.apcprd02.prod.outlook.com (2603:1096:4:1d2::9) by
 TYZPR02MB6163.apcprd02.prod.outlook.com (2603:1096:400:28c::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.10; Wed, 7 Dec 2022 03:20:41 +0000
Received: from SG2PR02MB5878.apcprd02.prod.outlook.com
 ([fe80::2c81:c803:d49b:eebb]) by SG2PR02MB5878.apcprd02.prod.outlook.com
 ([fe80::2c81:c803:d49b:eebb%6]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 03:20:41 +0000
From:   Dicheng Wang <wangdicheng123@hotmail.com>
To:     gregkh@linuxfoundation.org
Cc:     alsa-devel@alsa-project.org, connerknoxpublic@gmail.com,
        hahnjo@hahnjo.de, john-linux@pelago.org.uk,
        linux-kernel@vger.kernel.org, sdoregor@sdore.me,
        stable@vger.kernel.org, tiwai@suse.com, wangdicheng@kylinos.cn
Subject: [PATCH v3 -next] ALSA:usb-audio:add the information of KT0206 device driven by USB audio
Date:   Wed,  7 Dec 2022 11:20:23 +0800
Message-ID: <SG2PR02MB58789FBF9A2EA801AF49D5E88A1A9@SG2PR02MB5878.apcprd02.prod.outlook.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <Y480pd/XynYddrHk@kroah.com>
References: <Y480pd/XynYddrHk@kroah.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [3TPzpI3AAqcz5P36QnqqV5jlBmA3iZkb]
X-ClientProxiedBy: TYAPR01CA0228.jpnprd01.prod.outlook.com
 (2603:1096:404:11e::24) To SG2PR02MB5878.apcprd02.prod.outlook.com
 (2603:1096:4:1d2::9)
X-Microsoft-Original-Message-ID: <20221207032023.65856-1-wangdicheng123@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SG2PR02MB5878:EE_|TYZPR02MB6163:EE_
X-MS-Office365-Filtering-Correlation-Id: 90f09f2f-c9cf-452b-f9b8-08dad80204ab
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cu/cnXDfltxnHy9+pyHtFcaZz3W2KoLbBZDPUpSQxQrV856U9GPZ0MDI0X13hf03P8VFRxVWZONncaZlec10K6E+/p2K5WYj1akPERhgeScLVSJBcVSVPzvNXDT9odQr2wTmDXPkRbH8g7vVob0Ap4u3uVOsP+NvLxT6Klg6k5TC709sCiNsGWVVsEUkMZ/PGWimN+QOHejb1W8nl4a2Irh1mk2u87uoeYRRJLKvO8e840YNitodG1Cswz7CmXw/VXmEkdJwCGh8Uqnl1NUs95KTf1FB7To9AiyvqQQhgXveq+pEize1pt3BXNaImI2cnGgv+RKVKNuTjjTJiZ+dFfCpXRP+ACKCBP0csGCdZu9EUUEPipRQTTGC1v460HVPTRXz2B/OHlMlu4AtkIDfz1ztYe/60zixRAz6Dc7KSZ677PgJNKDgX4d2U/BCeqe/fcVyjSfpTds6rgYKxvHIeQZDIhgPyNLTYv1UElQ6lPqPeo73gGhz4rgFJiLNof1zVWTmlfM16sXAqVxgSA2lCeGo+mddYC6Hjnd0wYJ+/n80GCZIKMkaRpR7NeHUXINv1uoQgI+m+bnbi4aqWS+plxUvafkFrl71eYJgsvn8+xQ=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ezbQs0lgVB41nPMexRxIaNirHrzc0e1Rb0DRvbx6LibT8XfwlgWafaL9oIME?=
 =?us-ascii?Q?LG/ShX7kONKX6Cvl//cO1IF29wkW1ZEuCQFVQfDlwGZypdXFVcDru3pvu9Yn?=
 =?us-ascii?Q?f7iFH3Ky1OM10U5qeqe3+tZKlpPw3PTV+dPLiCPvUHw7e8YvhwXHz4xSxbdI?=
 =?us-ascii?Q?40XGLU1hDOlZWGFNKls9osdZr1W8D34K1kVWxa7y1vb14oiottUYjd+H3XMQ?=
 =?us-ascii?Q?h6BFBnc08QPDkbc+V4D2vU3h0MFlW1XRiJQG8eKwDBSm0K9jhXecqXNBevMu?=
 =?us-ascii?Q?ftvrw2P++/BPAuO3YWoqKMTpGiqjs+QRMSlaf4NyJQ2a6YSagbdlfhMHM/ES?=
 =?us-ascii?Q?Qh2MGGLV5vtK8qSAdSxhGOsskCmE4Fa8AKguyXVxQsrbQeZ8drMatMWSBOb6?=
 =?us-ascii?Q?y2si1pP0lYxUkK4RA4hmkIj59QWGjNc7AMpM+qZHDxSJvjZLdyq8NUfVXjoA?=
 =?us-ascii?Q?z3GNEbeUTyIQLLas1fNk9cnC6adR89XS8OF9FZJWR/H/JLU39wr1lDi6Fzw6?=
 =?us-ascii?Q?Ev+vcvNAchbA7WFRk/yyGubd6kghu4ZYgj1rlebdrtuLre5/hxBf54fT5Onv?=
 =?us-ascii?Q?5QaMg6fMztiZYEUIeEdv3snRxDi7Zfyt4GCzmy0VMyjvd/h5QCPgcX6mw4LE?=
 =?us-ascii?Q?GVpOH9eO0sb0hUzBlv+JoIk2ihwEHQmruNidUsWH0GQSjtCdKCCMdDOi1GgS?=
 =?us-ascii?Q?EwEWzxMJ93LsMbraeqsKF5ZVXlsNbxInIb6Wu7ckE5r1D2uao+giI+ltkjc3?=
 =?us-ascii?Q?M6gnuJqqiLa8gNNa3HcEthPGWb/bLJr9ZHBegw0ivQ7aYPki5aU9SARwe6vw?=
 =?us-ascii?Q?BU3YujPC6ubPkvlVmUw/IFPMND20+aYL/3h+EnLp5tJ2zklQa4o/G1ZxmziP?=
 =?us-ascii?Q?qwcBjWNR6VwJGXpBMx8FR3V2E1VlIKGDL0fidaejvBt+vFbJKxkViGaMpAgs?=
 =?us-ascii?Q?5NUBvDquln2+540qaQpaeKyBuI7wfPXHaxAO6dquT/sZjD1khb1jwVyUfZWV?=
 =?us-ascii?Q?JlFW5QUr7K69Empr5qk56BiFhkXDLEtwQgt5SztQARWNe4evCGMZRQsnKcQ/?=
 =?us-ascii?Q?Q/c5S8F36ZfR9E46GhQUUDq3ZRDT8aXvU+ArvoYYAkwjZXYJU4gcm43F/xSt?=
 =?us-ascii?Q?g4+c3ydu6r1zKjKfQyuXzgRYcvv+F2ZUOp7iNdSCFRO4dh7fpL/tu3Wtb//m?=
 =?us-ascii?Q?4wMzIUwVtrchxvsPEcgMX/5Ux9jCe/VCPxdlSETLdge6cGYbixGDrEEgYjKc?=
 =?us-ascii?Q?sslHWdF2JXHw6Q9xtieE+vLIN84MxT4k5/k9qs5prVBcNIQ+lcmb00iAoLp4?=
 =?us-ascii?Q?1fU=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-20e34.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 90f09f2f-c9cf-452b-f9b8-08dad80204ab
X-MS-Exchange-CrossTenant-AuthSource: SG2PR02MB5878.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 03:20:41.0009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR02MB6163
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

Add relevant information to the quirks-table.h file.
The test passes and the sound source file plays normally.

Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
---
v3:add body information 

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

