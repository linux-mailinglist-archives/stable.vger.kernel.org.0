Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0D860F465
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 12:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbiJ0KEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 06:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbiJ0KEH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 06:04:07 -0400
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2016.outbound.protection.outlook.com [40.92.103.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047DCBC34;
        Thu, 27 Oct 2022 03:04:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E+shBmqzFD4ayPbdP4wJY8sIEr5kntGKhOUflNUtrtgVECBYNoWakP56s4RUZrkStPc9zsOLlC0+YXJgkgI8nWwJ3p4zrOartMzqKIA5Qahs56BPQ7EfeOiv7eaVNdIBuC+8Gxz+pF51t6bN6t3++CUhlT1y4AK2JuyDahc4OV8qxzcCUivhw8mMGmtx9DmFrOCBo3a4rn192SBasbITfU3qNfKA42FaijGemvMzDPMpw7fsPGik+mwjHE2W1+LsV2jeq9OR2FePhf0aI9jVrJFDHJlPHr9xW/PD6aNc5JxI6CsBWNo7DWLlS/z/DkfUK7jKTpYd+6tEcwrX3X99sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0J/K0jHKE+VWvSv2kPNuWSM721hfnQcQ6L5uCrWFK2c=;
 b=LvMMOgS1ONxhiy9JhlYp12OBPvIYxbIgtS12nr7wlU06CcOgp9jvywM0t+3XzYWL3Gj+xb+mjtfz7jBm8HFzWeBBD+AWKp8xBz6YubRTAZ9EOx2ANcW/0Blzhl/gZ/0xSx2bHerz8lONKXOuUW4XBdXphWVXiuxeTsM52ivvDbBW6U1MdCUbz7ykjePozL+RifjJnySF5wcKzTiCfw+FweMsyD2Qyf4CXqj5rZt/missO8/Be/sE9yqKjNW9MY/Bx/g6a5sgatM3ajo9vktb/YfPWGMZyXHK5SjedRWywP14NxEwzOzfc2Pu0ZuOMwq/oy5EzNEb375iPEBHj++iPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0J/K0jHKE+VWvSv2kPNuWSM721hfnQcQ6L5uCrWFK2c=;
 b=mu6XZHW0hMIEr69E+/TLBjqZEOgIWrdNxcBbepRu8NTI3byxAuSXqrPNLPf/likfhRv1h4Mf0ZN3JX9jK1rSMuOX28/ZrZ41XJZhhrb24UX/EaxugQrxTVXsagVSxT8Z8a0nAyqvSpg9SnZyrRhoDlvHg+BBMnNJTBCuj2kKWG+FompBclM/U6xr4cfhENRiQzwK9aUSoo96kRHe1Umtffx0jWb4u8tyvcFoxsGaYOLfe25o0QRjc1UhHQV5zX5YUHwPYNJ84t6PbdzPGfk7SDE6lnjFOo9SYj+2cuzpC3nJGsqFBPWJ2m9vvYLQTfT18KfhUUgouQELUdVlifHPww==
Received: from BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:2::9) by
 MAZPR01MB7794.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:22::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Thu, 27 Oct 2022 10:01:43 +0000
Received: from BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::3dc1:f6bc:49e4:b294]) by BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::3dc1:f6bc:49e4:b294%9]) with mapi id 15.20.5746.029; Thu, 27 Oct 2022
 10:01:43 +0000
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
Subject: [PATCH] efi: Add iMac Pro 2017 to uefi skip cert quirk
Thread-Topic: [PATCH] efi: Add iMac Pro 2017 to uefi skip cert quirk
Thread-Index: AQHY6esdtcYgI4FYkkmedEvra7eSTA==
Date:   Thu, 27 Oct 2022 10:01:43 +0000
Message-ID: <8CB9E43B-AB65-4735-BB8D-A8A7A10F9E30@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [dDbCyKXgOYUmPwvmRCV6wwTMpaoeSwdA]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BM1PR01MB0931:EE_|MAZPR01MB7794:EE_
x-ms-office365-filtering-correlation-id: 82a215f4-4939-4da4-505d-08dab802405f
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JiNC2Ko5c9NwSt5IQ+Nwz0KbEoO9pbEl0K/cb3ZPUrBeAcXj4eOULGoZCQoGLslw64Dx9TRckSUA9LlsvsNaED8Bc+TzeBHZSJgoH2dWhz2jPe8tqB9qerdY+Qr8oBmTN1j8PEIU0vTyxKaJbCNZeVv8s64bv9A77wzChF+Qs9vm6EO/y3vcV455tRFJt68nTNkCyilJKx3Z2Skk78DI18SUlq4QPCIaoM14LCXfoYEVVRCUZTZxSymPgihXrqfK96l+mixpCLlt4iBkBUmfiFUZt4i2xmxUktP3Y3Qzc6zj5jato620hDQeBXujpnj7RwyoRBxgoGhCpzdXyVNxCM7OUD1n7Io4eGBkSBWz1+GVmUIUCc0hGiNLWUENx5zY/kji+CxrdH4+HovrhySVyVAScgBC/7CnaNAXEp6wmjBR3Xo9uWtRUJohP+wUKq6oIj8Cl3C5u/ao+oFRXWuSfwOuO69HYt+hTaF0FWiMQDf64B7VqHlPUVTrQUdMGh7dIhxpa++969PJVUBYYEUgWEmog2tSWbXcSpQXc1ShwtPRH1rmrwVVJILM+GgNsm6/ukE36/FT4NTkbyJuRmhOTyh7/0xsHc7IZZyHlW3vA+wqrM+fTipGKERC0Zg3qoAAwqh8pE+ONBXmvw4Fma+bfw==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oDuTxBmGS2JwxhsKiIshO+Q2UdXYSfFeWebfh4xL0743pOMxXBRJg7UImMsf?=
 =?us-ascii?Q?Il7P9UkfEOud8G7Xi4zaqkjJoI0pePji+QCk7/WtQ7TPD+w7ms1lBcnxMFrO?=
 =?us-ascii?Q?NvsTxmsDu7GzjzvPfZcxLa0NOmpJma7XMp9SkEEDpPjz58yoOHgkKHhWtHyL?=
 =?us-ascii?Q?Vl5YCOEorVD0IdcYDmqUdaFqNmvUP1Ys0T65vPuGlgTAUudPDvVHCGPbhZ6C?=
 =?us-ascii?Q?wGLEhZcVQStANopcwQuqeYiHKPvjCTEns7Emerz3GWEc/F/28mcrnVPPahct?=
 =?us-ascii?Q?kgxlP/joQjXOrh5zsZavsGd+dOjvVXMwJTLo/qFYrXx1DMGJlbuY+UuUCwic?=
 =?us-ascii?Q?BciMEAzrIQ0QSePdJOn9erDn03vY7cr5i0GZgTUxvMHnYEg9C+zpgsNZorqv?=
 =?us-ascii?Q?LZe9tP1tSDHOCV51ckOZRL1NiSXc8+p0w+q3R4PACtHgf/jq8aC7R55CrtH1?=
 =?us-ascii?Q?gYxVDdMvbnpVpRShDFhtpL3Szb37gpVRSxGcpVidgSN8mfWwC8nXQXrfCfC6?=
 =?us-ascii?Q?a9YSMHzENZHLvE2TUuFCk84KoJoUpvWcuFJdZ3wEOQx93TXetWhEX66D/cyx?=
 =?us-ascii?Q?fFvE7bWc5UR9Cl9CkRJSYFQkW+jIQ1lvybt9OtlD3i9KD0X5CrnSs+F8OGOL?=
 =?us-ascii?Q?2nTH+QbHHYQQgAN759Haq80/FNGADoimmeahFOdJsZkJ9Z68ADY/acvEmR1R?=
 =?us-ascii?Q?JhCoU0orAh8wg0Hu4UxjX6mP3SWVO9PEmxNJSCZbCKh1eIAh+R7VvhKg5AWM?=
 =?us-ascii?Q?fG6JVFVb63GkRgW+25tbaiqqhBvBAHtekNI0/KxaqOSZTdIfKtmgdrjygRPj?=
 =?us-ascii?Q?yeh/4I8uXozXhKDQCAqzDIdpG2PJ+G5ceLwKlBgD0VZtRtuoeKtWEj2SJrLl?=
 =?us-ascii?Q?P3MMzUk89ULNp+c0hhkdWSCI8LywRb30Kwn46DZJuQczAnOm0T1kheL9bxXK?=
 =?us-ascii?Q?X6byaMda2pPwmOrL3rlbiPkal+6gqqqeuDuhdnWh5r5+K9fxlj0/CNDSBdrS?=
 =?us-ascii?Q?kwew+5iHsNVehfY81dlqQf1+FC7iqYuCS4jzUuLqYSUzs7AccIkSrJDO0Abk?=
 =?us-ascii?Q?PChnK0oSuJf9HD0kSzSMXASOHtSJcdHPVjzQ6Tcx5K0Ay5w7cXNZI06/6ZVJ?=
 =?us-ascii?Q?OsSoIMOme1G6mvkkC2Y7yG4AlhMbxr/yu0S+xBWSUzKaP+rxbtKw/s0UZ3S/?=
 =?us-ascii?Q?NClHFwn7BpXY6wdpfUA8DyNyKfI2DGNYwJojbmiEkN4AViLK7b8t6TnLK4ta?=
 =?us-ascii?Q?rlTTCn7/W5BSQPW77kKcQ/rBmO+nmwMN9Lhd0y4LXg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EF434E29E7CDBB49B2738354A64078F6@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 82a215f4-4939-4da4-505d-08dab802405f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 10:01:43.5311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MAZPR01MB7794
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
