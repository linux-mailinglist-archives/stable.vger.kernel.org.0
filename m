Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C22B492078
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 08:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiARHoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 02:44:54 -0500
Received: from mail-ma1ind01olkn0164.outbound.protection.outlook.com ([104.47.100.164]:16374
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229683AbiARHoy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jan 2022 02:44:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=etpEjDirDxqPDds0SfiLqdhpxSx4+CzU8gvO19+54WYvyh0/5h+6QNzm2baPbE9c/e8pD0ncZT12QkPfzJyPtx/ZYthjPuzBRPTlQ1o4GIs3h/aLQZ6iE0JthTA0pMd1aLNz+QiwthtgM95d9pGEpbUOk5J05gTFwgG8ChaafQwoe6a4Rr1EYdMD6qSxu+12KEjfMMDPc//UiRpLpAmcQWIzYYw4qwoLpgGAr/dCyIGLP+EQHp2wTKDp90PEli4Sr5KRJamz3GDZrraNYOG1hETVko6pfM/iSbBk5dkkFlZls8v/lhjs71f+OW3wpGXbP5zi78d0BnuVi+6zxAfBCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oFz/dFzkqSmibvr/mjWmi0rTKBpsFERE+wTR8fS1BMI=;
 b=Z5uXvI9IJ8BAzUMnFdHrme8yM0u6zPblkmzKCSKTbOL84unIDfhKGVXohXtfRCa/OZwu/84CDsCDIlTjjGZju+5PaEDqWGkh9Q4YeIX8v4EJgey1Fz8KofBU6j+AHwWsF4OA5lwSSzTtRc4LPo/2pzbqasNNVofxnLizcU8I+epmklNkMWqIW5p4YXxQg8CHoLKJo59MfRTVsuZpXNRMErElnKgUVAoHNddYPtquBHrthjuXj0euWrxoKNmvFIAYX/3jR0FE/OPCX5Ix2bPBVb0MC67A8BbJ3Jdm9kYdmhI2RVVqhZ3ht+jRCVzU1PH6MAzynp0qPhlTSy6fo5WtSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFz/dFzkqSmibvr/mjWmi0rTKBpsFERE+wTR8fS1BMI=;
 b=euyRZo9zt/tWXsLB8o6bOf6ag1pyB9jQbEwdJUbvyRJIsqbvF9ozel7mJH/SlU9X7w7LZKZFa3Uw8vR4zDrjsI76meYN0WoqjX9+O3NUgbl0WSwdu4BgTkZV1K7zLWs6zHJk/hTxtNrM/Ftm070VhB5W6dK1NA6gU989suszcpze6/D6r112z1Guz7qiLljy1za3ilRVE6hydceZd3q64MyhmfRgplWo3kn52qeDwlLj/Jz3xJOY8mUiBBLB8vI1CqKY59DKxHjdVHVIxMzAHd8vlGXf7tlMeePH3SBaluqc3bYeyDEbEc+18zWQvmb+fidEVDvmXS5AaNW+8+Gz3Q==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by MA0PR01MB6724.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:7e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Tue, 18 Jan
 2022 07:44:50 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7ca6:9165:19ec:4cd7%8]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 07:44:50 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Ard Biesheuvel <ardb@kernel.org>
CC:     "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jeremy Kerr <jk@ozlabs.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Orlando Chamberlain <redecorating@protonmail.com>
Subject: Re: [PATCH] efi: runtime: avoid EFIv2 runtime services on Apple x86
 machines
Thread-Topic: [PATCH] efi: runtime: avoid EFIv2 runtime services on Apple x86
 machines
Thread-Index: AQHYB50ylhurY5X5s0m/eR0FtoJLiaxob0wA
Date:   Tue, 18 Jan 2022 07:44:50 +0000
Message-ID: <14A0A3D6-8935-4C21-891C-ED1ED9459124@live.com>
References: <20220112101413.188234-1-ardb@kernel.org>
In-Reply-To: <20220112101413.188234-1-ardb@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [BdQ+tNGpuRmbizw5T/QFHIumW77Z2RfQB2yEDVdP/TYMyGNW1Ux7FUnekTTK0cfj]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5aee44b-f54a-40ad-4a01-08d9da566855
x-ms-traffictypediagnostic: MA0PR01MB6724:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LdQdAfgUaMDgaHpvpF7qhO+hXE7Rojt4GcE+oC615wJuZiTuTf0XpDDhB0ncex+FKU0fC5dwbv3tkCMtaPwisdpnxoNnSrE1GQ0nC0h2nfzXEi8CkUW1yOSXB/fOKPlpoR3osquvOhhKE4y65rH9vzX4XHaspIZnC8GyqiagF2PGpG3KdvXVgcok6ekXv1Hg/x9LdAJbIP/ykEFWJwh5RaMg6IwPwO+JkSxy6PBRbCkEO/LJJK4asn8+BrRRfbIVruhqNyZgyg9XMfzdUXVFwA4cpQLeYzJmZsFrViYs/vOOejEXX5G4/kGUx/2ZMLlqkd0IrkwamQI5CnSUZT3+2zbzOZBihWbm9x9HP+IXvRWt3ktOulLulTvdJ12JCnR/9Zf1QzigjlQ95Hrz1wwgOXDB6vtiuCm8MFwfwAucRVJLOTQh+xiiK1jOKTkCQ1mSbe5CfmIO+cDacuEW/kHTCzFabG1mxavdwIYSRYUWsLDR4eyHO7pIm/K0bDZl/JRzQ9tCJaZlP/reCgikwRLj4RWX9S7UijdJXpd9PTJTIt4rNEfYWNx3TucvKoMURYw3oaYUR82jQPeGjo5CkHj2vw==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MM4OltjmNFbRUQZ7dKB786KgMHg+sQ0Av3Rfk5sJsr4wOVJDi2O4tG+xATS5?=
 =?us-ascii?Q?SafA+GZ8KQ1vvJQ7qxXYaGyOnu3hZ1CqbbmRI4KFGGrZzfy23NGBIy2228fQ?=
 =?us-ascii?Q?vlWkGOVfsgjoCEBUNzbEkxCDwAr2RVceoAT7bJYY9gUe/POPeyM30RjUOTbU?=
 =?us-ascii?Q?Pqa058QQuIbpJshVMiY4fg++c5VVYQMHbAd2/V3SXxDS4qogVJyjoj+lbUKq?=
 =?us-ascii?Q?sf1rEhYMcXYUY5pifFvJaCW1rZPgrubH/okuCMj8YE4ex8etpfDSr8jPb4qA?=
 =?us-ascii?Q?9CRUhspVjkWo+RQ/tdhVU1N7P2KpYVQYXtsAFJG9PjjizO3DXqzggYKHNZdq?=
 =?us-ascii?Q?ELMSGxUpRWUxLFwEVtKwfVdQugSCpUd7dD/CsH3/KgjdEU47yUf4uBh5Xp3e?=
 =?us-ascii?Q?hTM6yfqhn3dl8Xde3pEChWNGuqMaBPDYNdBv3l+A65NDMkFIulUsh7qGD07N?=
 =?us-ascii?Q?d8s9ehqyabX6/aPmoix0r/kYZjgiL5t2qZwku95sh1WvZ8J8u9UTxNz255Z9?=
 =?us-ascii?Q?uGGcX5UfGiEKtZKzhDHbUIJ/xsGUSGjhAO0dqcS5avVLsWsYtDHErMQ42BNk?=
 =?us-ascii?Q?rPMiuVrz7s9MM4bSCXSmX9JegmAk5zoHGmLxDB8XaDYhgvU3aNjhi/RRk8zV?=
 =?us-ascii?Q?f01Y0fYofP/R1JMSkeZvXizaC/FXcAJxqNszymOrs1A87ya3xNQSNjrpkY5L?=
 =?us-ascii?Q?sZUwyPgt6KD0TNY39pYItLXAF5SaBBQKgHRoebyagcRhhP45cixi3rbuszlV?=
 =?us-ascii?Q?uooOZHykq9XuPEcKynzYiLoaAXTl5FMk1JXhkNcXZB4JawaoA/TdUJnpVlpQ?=
 =?us-ascii?Q?TQzMwJgRdE2Xx/gBCrjAjs8lGPqiV8MEFtWjUDyGdUjn45zFmF9osNbEUFGT?=
 =?us-ascii?Q?Sy1x4p16lWD8/YdKwFbfUJyHtAiqxsTQdfNp1y/0+vhgu0/WkaBHYW/EOEi0?=
 =?us-ascii?Q?BMDujXGLOk0DSBQX/38Yz0r596/svgkQIlgWdKCnUbD4bsiHPeqyFePVT0Gv?=
 =?us-ascii?Q?pcOih2tVUbq9wAPerpA8yT6fWg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DE282B740594FC4C9FE9DB40FFB4BD11@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: b5aee44b-f54a-40ad-4a01-08d9da566855
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2022 07:44:50.1162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MA0PR01MB6724
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ard

> drivers/firmware/efi/efi.c | 7 +++++++
> 1 file changed, 7 insertions(+)
>=20
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index ae79c3300129..7de3f5b6e8d0 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -722,6 +722,13 @@ void __init efi_systab_report_header(const efi_table=
_hdr_t *systab_hdr,
> 		systab_hdr->revision >> 16,
> 		systab_hdr->revision & 0xffff,
> 		vendor);
> +
> +	if (IS_ENABLED(CONFIG_X86_64) &&
> +	    systab_hdr->revision > EFI_1_10_SYSTEM_TABLE_REVISION &&
> +	    !strcmp(vendor, "Apple")) {
> +		pr_info("Apple Mac detected, using EFI v1.10 runtime services only\n")=
;
> +		efi.runtime_version =3D EFI_1_10_SYSTEM_TABLE_REVISION;
> +	}
> }
>=20
> static __initdata char memory_type_name[][13] =3D {
> --=20
> 2.30.2
>=20

Just a friendly reminder to upstream this patch.=
