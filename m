Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C7B60F436
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 11:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbiJ0J67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 05:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234847AbiJ0J6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 05:58:13 -0400
Received: from IND01-MAX-obe.outbound.protection.outlook.com (mail-maxind01olkn2013.outbound.protection.outlook.com [40.92.102.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755D997D4C;
        Thu, 27 Oct 2022 02:57:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j+eu0zSYzQ5+Nn99iwkuAzLUI1DawQU7nghyy4x9dhM2bTC6Ybd2mtErobA0dJvMeL1+ptZMPIqJX81vR+eSyFYLGIeHQMW7pubGevj5piZg/j42Z1MJWn1SlvAET2OokEKdfhsbmu73HH8zxsnUTFqnLKE2z2UdiJK68vRE4WYIfQ2eUJ3GCB7OC/3hqFD4RObnpK4z+/UBTCKlKk9EHnStk0a3Fsqb22rprwHESDf5exwknj5wqlvsTX4lj0OdzS5jVfzpOsxr6vbYgb5K5+YZ71ov6U+C+tahJmHBmO/rx0zRgMXkHgcILPN9zxSCC1FIJcGrgiSEjUQExr+5hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0J/K0jHKE+VWvSv2kPNuWSM721hfnQcQ6L5uCrWFK2c=;
 b=bT/Askdk08Jibf2XqQln2Y+HPMkWI9o+awzQ/rbiGbcrTjSrdKNOUq2IciEo/1j7MAKGb0J6lm7JembHHZ2vDMBDt4NAS4MQufGsYay02IZDB5m6WSqZs8yl+I1718ylcIIBTZedkXdoPd/UBKwzmfK7Ls8L220JPRT1vTzYsu/RRC5eKiWX2l565QPJ7UayzGgrV28YDC9RgqfWUSrjHPhT6EF6EXE8tZ+9zuhnXpSs0D1dneof7N1luehXYGelzSD+dsma8ABq1DgrAblMskoGW/E6A8uPxHCkesLUMbFIVUTvwbkbqW18YhEy9InGVPrVzuU+248G0dARM1C+9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0J/K0jHKE+VWvSv2kPNuWSM721hfnQcQ6L5uCrWFK2c=;
 b=GvA3bfT6mdBFNMedVDmv898FdJyKqvNIFBt3SO3jpC0XeRZlbq5yM9fRLnPfAAD4MMvAeE7/UN76fuDIS0ddTaEZbXGYZc6Y04Tck01pe5oqBhVacmTOCa7cKMBj02+QAdjWZz91MC0BVb9Iix/DYynThLaj79mXJYsddHHisABiJzsmHQ/eqnjHFH2MLvo7AD+E4LSbNbrWsFVd6mYCCmH1U4LB1ye2V384usCQDcEKaT3k8qyx85gYTuJJkvyKxHU7RXRPwTAL+yxJNYAceVaK+dt1/8rpg1f3kF2kuiXqXIqCvSN3lcBoCGoiHkX3MpIhvxwNmKpk4ARO4bBJuQ==
Received: from BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:2::9) by
 PN3PR01MB6485.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:84::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Thu, 27 Oct 2022 09:57:47 +0000
Received: from BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::3dc1:f6bc:49e4:b294]) by BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::3dc1:f6bc:49e4:b294%9]) with mapi id 15.20.5746.029; Thu, 27 Oct 2022
 09:57:47 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "chyishian.jiang@gmail.com" <chyishian.jiang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>
Subject: efi: Add iMac Pro 2017 to uefi skip cert quirk
Thread-Topic: efi: Add iMac Pro 2017 to uefi skip cert quirk
Thread-Index: AQHY6eqR5YhWYy3yGEqpjWLgtMkkQQ==
Date:   Thu, 27 Oct 2022 09:57:47 +0000
Message-ID: <6E49388A-E403-4F99-BF7C-34BA9D489A02@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [NtkeS8GdP+nI3u5G6SaNiyLK/JbBgRfN]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BM1PR01MB0931:EE_|PN3PR01MB6485:EE_
x-ms-office365-filtering-correlation-id: 34c345f3-7f61-447e-7d1d-08dab801b3b0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wCdVgOfoMYk44de463SE/W4fy22M7+xZQAd0x3Jvqe1SDPZR5ncF3LSOMlSqd9ZQu/YDwp53EQrJZ8rtE1RGTmaakXhhh1Py0Mk+Njyatp+3gRXKDz85/7anR/vHPZqiC9HctE0cBCfi9uysq34+5aNW658DES+e/3N6bFT7neMyR5hIFVINKdByBt4/vbHYwQCeH+BS8ACxLOM8ceB7oI0JicRiOo9O5MbBtM+W2tGm3GmfOG14uopw7vEnZ+gBjAxP6Rv4+Fpzz+cVILjElc2ir5i4p3oq2Smhz8lgtQZPg4jJic5ZsruEQEWrMKChl5Gbp9PsgMaH1rdrcuwy6smpA5iIPCr0lFIZlXQMy3TbXCFwMqKhkC8G3WE8DcxhZ+4i+tsbUON70V2RROYX/5Wu0PLJyfGn56Bx6VO2M9/AKf0/ZkSxBvxUwEQaMaEXUqBB+FwsF8OYDkOb24HpF3nzitEBJ9ZjcbOtwHY9wCWLfxbgKcj10w6XzOe9IgKwKs5nmwkkhrpLqzrNIn0hU/wD01dgJnLwhvkrV0JnQd41yZ9AzxsaQLoIP2GyCvT1YR8GZPPcu1J2QU4b5JHhgXJZum6LR9R4W+zRIu+kxnsnDT9JiDU6Px9tEuiy2oszXsNmF1fmHX8hv5gLMoP1+Q==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fHZgCxgURNTUeBw+Na9zNV0zsIpgYw9U2O4tL8Bp7QIxDXzmDpUY2E2Evvg3?=
 =?us-ascii?Q?mAZFFL/Yf9Et5mLt2NzoG36/LWRtut4dgx4EECqGpHBUsrm3AB6n0ZQpAzEL?=
 =?us-ascii?Q?adFNiGe8vhcEcnEdedbizKwVD9rRZCXKfwefcr2e4W837Oa10Y14fUYWlnl3?=
 =?us-ascii?Q?4DPqrH60mkJFrBjLouXjBl+owd9Bo1m0ZTJHOGVhkZViaNANTvIYcjbZDx9y?=
 =?us-ascii?Q?b+uSDhQrVq1raWLnHy0mLzsZj1Vn+xgGLTZPKAIBRg5FQw2nSDNIPbhUmgGV?=
 =?us-ascii?Q?5o8mhcE3bgDlDWb0z0cWzIcCDfWsouVOicpcrU8PR/tZXPesiSZGuCAtChUu?=
 =?us-ascii?Q?Q0XsUZvCBTt66WLTdRBb/NQIhk4GjwcTbh9zmFlYoFvrQZtqkYfTp8BQSWV8?=
 =?us-ascii?Q?fHfm7UiZlRrFgjEDqvFf1n1/JiihW46tpYH81oIVzxSrAKr84+g3kyx/zvX2?=
 =?us-ascii?Q?qUwZ6EY2QlckOwK7prqIMcvfGtBQNCbb9QoUE288XUNL1b+YsOEetYWLppSf?=
 =?us-ascii?Q?A2yVTDT7MP+0fAIjQelMCPhbU5AapajX5/MHrZgIn72q3jyz9RxwpX+Tz11s?=
 =?us-ascii?Q?G49Kv8TDU74rjo7+Lyn/JguXkoY/9Pvh96dy7kc1RTAJhtGl0zYgZUUe9b6T?=
 =?us-ascii?Q?NnfSo1Tu+mW7CZpQ8Uz6YjX/h8IWQV5FGLsWnH5ClVWtNnhX+MWptD1rW6sV?=
 =?us-ascii?Q?+Q7SsH9xuhwoayBELNyR4ByQyWBoKRo9UR/IcE/v/2S2SDrtD5jnjamsIa+I?=
 =?us-ascii?Q?Rf5ZYmhnFsWwjr+mDDHcVCMZ8OhEceXx820iUOOpDp4vgYh51dKRUXzUWYud?=
 =?us-ascii?Q?8KaEi4j636H90LYdV4f6d1IsILbKXucxWnfnBHTS5CgACiqyhjxsQ7rT7DUE?=
 =?us-ascii?Q?OnidbepYCgZTLyxhoB/Lm0KQY+Q3h66nnM13AODOEhYvnNMM0evnxWRI6bqu?=
 =?us-ascii?Q?gZoD5mBtWnVnNG4v5UWs9iE7KlRnQHHPpuDZTdMuINCJBGQcMxORq1ZzABfT?=
 =?us-ascii?Q?DFMh4uoOKW7BM263exCJvoeRZg0scODbnfpqxhs6ayY0x0+e8grlFVJfeUib?=
 =?us-ascii?Q?h9PQBDH2IwCQXKCYeZRswPSU6hT51s05JxGMF5bljFLCMTDJ7feaJwA5NAZQ?=
 =?us-ascii?Q?LKu3vK47DL+ylMyVSYgHink3xgRrfFbvz7CSjsMuQgfB75CAvsPSe6B5K1Ds?=
 =?us-ascii?Q?WJ4GBfX9pLbU0RCZvfukQzXIPakwF7AYhfjcewuhOFGC3bUJSNot0AGGhNu7?=
 =?us-ascii?Q?J03H3KD6HOEe4BQXevxmuEzH8UiMqAFdbTEIuFwyhg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9F8838A4ED268D4C9F39B330B4B0CDC6@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 34c345f3-7f61-447e-7d1d-08dab801b3b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 09:57:47.5043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN3PR01MB6485
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

The iMac Pro 2017 is also a T2 Mac. Thus add it to the list of uefi skip ce=
rt.

Cc: stable@vger.kernel.org
Signed-off-by: Aditya Garg <gargaditya08@live.com>
---
 security/integrity/platform_certs/load_uefi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/integrity/platform_certs/load_uefi.c b/security/integ=
rity/platform_certs/load_uefi.c
index b78753d27d8ea6..d1fdd113450a63 100644
--- a/security/integrity/platform_certs/load_uefi.c
+++ b/security/integrity/platform_certs/load_uefi.c
@@ -35,6 +35,7 @@ static const struct dmi_system_id uefi_skip_cert[] =3D {
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacPro7,1") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,1") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,2") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMacPro1,1") },
 	{ }
 };
 =
