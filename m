Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2795C640137
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 08:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbiLBHuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 02:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbiLBHuH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 02:50:07 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01olkn2107.outbound.protection.outlook.com [40.92.52.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AFA9FEF8
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 23:50:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTf0brpctMPscx64+xoWtEyVNnHuUBHUnzeQsJcJ66sTbNVDOUaapqTItp32rU/gSr6SPXrKM1MMr0ZHLCicg+GxXjyrTaiOsLoZLlMlngagMkMkX3fi5dfywtz6GX4Zzio4mcqH9s9j8LEjdNRpUR7Jdm475lv7P5zBmlI8fbwCwiN2pRZiLqUYZhWPDjsmimFNdchlbwhyVu1WaecvvqS8zKxzBfzXrlX/AGL675aLFTS729RmW6nr/75Zt1NbESdvN1nXJTYZpxJ4HhbpVxVlXF+XpuXPE5K/Gw0d6y6As3l4t9wbNSaOkykMKsqR9t0i2v8G1aZYSkVpEc3v5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pTM7LgfYCGVcMXxG1qA5AfTeHnBOAgelb8FXWZUo/uo=;
 b=job0c2uSyS/SCj3jE95anmp8Vw7DyCVMdImUOR/CL7LsK17CVxf+BMx2CutbO7PdEjrWk6x8K+jthoXqsfPgRplqxyzonwMwNFn5XcWEW6ALCvSSw5j3QMwZaitu+Az0GmBPnSkXj74SiC49pa24yKt8336sq5tnTlfQKBZcWxxQf6uvc15RKkveUd3jW3Alq/HVppAquWL5KAiOPuU9Jn3doKem8texZwqfAgjnLoGmUv1sQwi26m8x4QuEL8iopbKLQvZdSRjR5PtSeS5YjxMgnKviDCZFj7URDQNtl0vv25ZY7B0JH7i7Z7U5cSzFRIngnE2Pg9k3T398Ve2I3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pTM7LgfYCGVcMXxG1qA5AfTeHnBOAgelb8FXWZUo/uo=;
 b=PNrrztKZlpKHPVCQ/0F0q/TsdO2eTdwDS6+z3zwLWAwT+cYJNE7/1rxGL9SpUJ1xAgL23sA2hLVxtCnuFQcHSkJtY780qLIoD198n76jA2FALf4Y2+rLMjiSgHaHXO7uEMmYwF4b64zLamQxW803yEWhvwWjyHrz6LjHJf5EHpSoGpPsaeD3KQwb0n2rNwksEs3Uu2RQWQb4Hx/bLLuZLa5ZBz/jAfIQ6h+qGgOr7Ouj08Lt1nyuH86Zhc1Ao7E9SE0/LS60HpmvoxUxzTCVb7WBBfUV16HvC/oMOkaQ/wAkyMadbGak1A16ITZ/3S3C7wiHgkAwWxKtynIdEgChJA==
Received: from SG2PR02MB5878.apcprd02.prod.outlook.com (2603:1096:4:1d2::9) by
 TY0PR02MB6169.apcprd02.prod.outlook.com (2603:1096:400:279::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 07:50:01 +0000
Received: from SG2PR02MB5878.apcprd02.prod.outlook.com
 ([fe80::2c81:c803:d49b:eebb]) by SG2PR02MB5878.apcprd02.prod.outlook.com
 ([fe80::2c81:c803:d49b:eebb%4]) with mapi id 15.20.5880.010; Fri, 2 Dec 2022
 07:50:01 +0000
From:   Dicheng Wang <wangdicheng123@hotmail.com>
To:     wangdicheng@kylinos.cn
Cc:     stable@vger.kernel.org
Subject: [PATCH -next] The USB audio driver does not contain the VID and PID of this sound card, so the driver is not loaded.
Date:   Fri,  2 Dec 2022 15:49:34 +0800
Message-ID: <SG2PR02MB58786472A08370F924C3E7828A179@SG2PR02MB5878.apcprd02.prod.outlook.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [TbNM+8ew8Yx392AsVGKcY08uEu+8gGahYLj8Z9wfgeQ=]
X-ClientProxiedBy: TY2PR02CA0057.apcprd02.prod.outlook.com
 (2603:1096:404:e2::21) To SG2PR02MB5878.apcprd02.prod.outlook.com
 (2603:1096:4:1d2::9)
X-Microsoft-Original-Message-ID: <20221202074934.288482-1-wangdicheng123@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SG2PR02MB5878:EE_|TY0PR02MB6169:EE_
X-MS-Office365-Filtering-Correlation-Id: 8614da88-b452-402b-1b34-08dad439d101
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PqMp6kHphteENSkkaRLOUsTI8pOIBPXJUZMQ9hWka3Y2ZytElMawqjUAcl4GHsY7Ln5FwGOLN6CzHeN/4iVZvpW/ZMcbrVZ/F9t2rKkauakt6QSnazZNDewKKGCRHc65597L/1rmwZ69FhtVlawWYFsbOjP/+iblstizfvXAVzFvuXeQRLOwzFGYrH6woPdJBJof6T4k+xOgZUwryxkb3BuHEpHYZhSyy1lTqTLBK8ut1wK9CzeTv+Y3zrIZtmjcsskhO6/5ylG7gfbsJ688fEKB2OO2K0+VyFezumMKsfpELSrk1ls2ddWKTcXYRDS9QCOefp9E40xWrFx+b3yvifl8ovrzwPdfRk3BQdl/Q7NsL1tiWecwUae5kaCevx/lIQh81mV8Cu4DnAS0NtXXtuLtXGDRJVQq/03xcKpqO4P3JgyqG2mDbMNqsfNX5I/Dbnakhl3eKlhSQ0amlF670YIhFlcSCxf6+OGaJ092QlFM0XrC+flEPhJ7m5t5T7V+/iFerMANsrLWeN7yU4p8MApB67fuq6hCjWbuPkUkhl8NxLU9oxEmKGFFbxyaHChPtRR5RSnMKchAXnXxwrv/Fs+J36Nw6z8wnhEnkLBk7Yc=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HhheG1BALpcDtn1B+x4FnTmPx3FKidH3W4sFbDKc6+0ia2m9aGR//6GKaSmS?=
 =?us-ascii?Q?sosLmZxDNkCboERqJWs/lVpkmWlA6765jp/c8xVef8NJGptciXZvbYLO+o1a?=
 =?us-ascii?Q?BQw7gIV43G6OFkp7C6SPO/vr7m3upRYI2zaYrcbHwCk/hX8AUvEHWCWP1Mza?=
 =?us-ascii?Q?4iHJAeSCqEjOqdmsDZJWzUqsJmeigRfCeEaBeSWL9SKbY4FsuN1v+TcYM+Mc?=
 =?us-ascii?Q?kd9jHN868iAcb0780qQitvWidbrn6/0be8a7S6MiBPKyei/XeDD6fPvAVWmO?=
 =?us-ascii?Q?jSkSpkij8RNzBM4cXLsHI1J7O6mojv6LieCTfYYL8and9izNKN7r6Mo6LXjC?=
 =?us-ascii?Q?ahXjGAqJdmERezu+sH9FwaK8tKZYS2zmczYGLR8eae7reCFbMYBai/bSqCUM?=
 =?us-ascii?Q?zC6fQtac+iTBgrlgeXWf+GQ9vORP2yrw5smuc7eUbJgQUlmO34lLT8Rr3GG3?=
 =?us-ascii?Q?naAXw7a4BSYLOYXbyO45MUgHJC1GkrISRrffrgfj2v5vOtfZkUoLCadYD6ti?=
 =?us-ascii?Q?RmjQ5qiWk7kQxgdzTCDSTwCOng4YZ7uTvKny9RABiTkglAeIWeMldjOnVqBx?=
 =?us-ascii?Q?HhGl0jG24s0MVtIjXN/vnbVWraO5PuaFvpf02KJT0TqmqrMUzvxhmjgUkkH1?=
 =?us-ascii?Q?27y7ZVzCipZ7abtY7pv3f3UjJgUq/ILfp9Fs6cvZ9sC7fxcXf0fz5xy6MTbj?=
 =?us-ascii?Q?wjI0IE5EB3li7o4Ypaq5DbRpwuVulzG40KcD+58r/ZioY0/aqvgbEJHF34JA?=
 =?us-ascii?Q?VUVK2Uws3Z9IbRNhyb2fGjkaspZZIifR2SylZTI9XgTNfWYSClm2QTZiEhTp?=
 =?us-ascii?Q?+m5kYSTwmWDnpH4A2rTK43fFwY7TO/dGzIxHHOuVuHcwF6OL5tM6/K9LAcV+?=
 =?us-ascii?Q?gnI5WGOxTn6jhxUzhDc0Xiti0VTgNCgzE6278KUMxKUnrgpNRDEnmzteQhYv?=
 =?us-ascii?Q?QKyY4BvQ7moRUfCrmdw2mhaDZJtQ9H66iUsCtRsXum+5W+4VDOhAHOA6fde9?=
 =?us-ascii?Q?ZS5v0F61oxbXmotXIhPZss7kZX+cLqlB8JzN91kQX5cpsycZx/1438GQtK4K?=
 =?us-ascii?Q?sPmQyO2ZQ1qbBB0sLMMooSnw0R94f73mr/JoxVQWCT0yBx2Yzmht2WMOItLj?=
 =?us-ascii?Q?UF/spMl7RV6bUGCVNBGqDYwUEqGYDPJtX+nKAB5IbC+RmpFJudstxklgqtK7?=
 =?us-ascii?Q?6exBH1XXLctl/QuUPdn+MHFvQmzba8/ziidkOoy7iqultHuJS4q5WdhKer5d?=
 =?us-ascii?Q?OlPCWa9xUale4Veu7NfcTmk6ODDE4secLwwkBPV7bk2tEwm4k39oQUEUgGp4?=
 =?us-ascii?Q?Amo=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-20e34.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 8614da88-b452-402b-1b34-08dad439d101
X-MS-Exchange-CrossTenant-AuthSource: SG2PR02MB5878.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 07:50:01.4518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR02MB6169
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

Cc: stable@vger.kernel.org

Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
---
 sound/usb/quirks-table.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 874fcf245747..24b8d4fc87c4 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2801,6 +2801,12 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	.idVendor = 0x17cc,
 	.idProduct = 0x1020,
 },
+{
+	/* Ktmicro Usb_audio */
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE,
+	.idVendor = 0x31b2,
+	.idProduct = 0x0011,
+},
 
 /* QinHeng devices */
 {
-- 
2.25.1

