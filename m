Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275994AF40C
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 15:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234934AbiBIO2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 09:28:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235053AbiBIO2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 09:28:16 -0500
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2014.outbound.protection.outlook.com [40.92.103.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E676DC050CD1;
        Wed,  9 Feb 2022 06:28:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JbE1vpWBpB0b4K8GCUtmvf4epjRiLIPmZnCWLpB+xnDlwy8B6pcaeLcR/WSgTCAGdFMHVKxkrzXGTWvl4oYqNG7gZY/itaXMZ5++cOTmyBozGBBHZ1CCr9R6Wev7dMcb3ryH0DqSVXFxT0tWuSwvUhLf8O5wjt/gi6lmz0frN7xR2CVJA9Dx38HcWNmIHHpO2eguYgwkVT6qgQxQF0xM0ve1D6FFEakZk6AxwGc36nag/32a7oDh8PdvTK4Wooz7brdHt9lfrOv90vgMF6U0RJBpv0N4LP06Y/2s1fXhwaHHVZ4arDxY3EGPQVY4iYa9bJgZdh/Db9kdXV0QZZ5Ejw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+HpWECCZCfVirzvXo1+7kLylFAWoPQUlc6uBqE5xQZ4=;
 b=bwVjoGNvEF09iEySYrm+rRaDOqW7A5QYDHycB8p0gsRqdNGQqEC6Fky/vl6Fea1GFZ18bhhUQdF7GAODP/IWwEDtXx2j4PLbCGHbdxV/gdILQi4Ct1eTX59OV9VnMWm7h8dScXlUenygrQbNJyk527dcBtHoGXzjcgR2rNWa2FxurUGJArhDhiDIi8Z6FhA2zbjv3IRprB0fDnsBFq7kh0Z7VDSomRGavC2MTiKxklj/NXlijLiyJXqzhEsXuPEd784wVLXirLn6wEMbVLubPW4oIBGsbER3joJ25Dp9YbEpnM79f6Smz8jLRZXWOOcRGEfEYehXQZW/swspqvwNFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+HpWECCZCfVirzvXo1+7kLylFAWoPQUlc6uBqE5xQZ4=;
 b=KpEU+1w12goQlPk92UPovfHeo5NbK9kCN3W6vGByCFIRGYCobrw8hcPYPUo4W5vFMxFo7As10e+7hGgtrlKT1N9CBheglavL8pXrAqgkFRTdzeg80CEDjLJU4vfbgTq7tpBm/XTRXQTn+XMjTRizm5EehGOeT6R6U7gJex84SLkRLOytW1N0sPtrhFkDfDi3To2ijIdJCKcKjJxvLZrX880VMCCYBSSf20P1Uk6SXsw7okciagoHCfQjKtxgpQ9SXHA9Estp6M/9yeUlCEQvx9N8+HHYujjf8OLZKwAsvSLnLIn5koJH2hr71DgJtoTxCKRn6fOfQEcFDpGwzdFjMg==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN2PR01MB4905.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 9 Feb
 2022 14:27:51 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055%9]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 14:27:51 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Jeremy Kerr <jk@ozlabs.org>,
        "joeyli.kernel@gmail.com" <joeyli.kernel@gmail.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eric.snowberg@oracle.com" <eric.snowberg@oracle.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "jlee@suse.com" <jlee@suse.com>,
        "James.Bottomley@hansenpartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "mic@digikod.net" <mic@digikod.net>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Aun-Ali Zaidi <admin@kodeit.net>
Subject: [PATCH] efi: Do not import certificates from UEFI Secure Boot for T2
 Macs
Thread-Topic: [PATCH] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Index: AQHYHcE4Urimp9LpDkeI7ezkgv1YDQ==
Date:   Wed, 9 Feb 2022 14:27:51 +0000
Message-ID: <9D0C961D-9999-4C41-A44B-22FEAF0DAB7F@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [kQ5oa6bUVc+aBCKEVWQud2S/0CbvwGuZZhHqQw0mYj88dvxRNfyvfuelnutQ9tvb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e85b989-ac84-454b-1e32-08d9ebd85a9f
x-ms-traffictypediagnostic: PN2PR01MB4905:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w9X7msMj2ttZ+mOhcCyNa0ocKlFeVzUSFDLVeHTeCYoJd14F+qYtripjAteEtbnfM4KVvKJnx1sir6p3EE/Rg5UTwpmMadlGsL79NOAUl8Mie6itFwU5s8e3KUtvk8b8vq9bRVQGA4RUvLOrfy1HL/3hSWbuw3vwmdF8lgTnGAVsNmqiYCsUL3wOEgmWmC4jRhOH9iuQ8KYDd8R328rSArYM8ODCjSjJAzKf1EpJp5sUk81qZb4ngFQzW3eoOsrShb7mttif9mmlOCd2VowZ6ZKzoDQeDMFn+7s4wTecKs4Ww7in8zTJWmD2oGUzx+/H+9dlIEkSu2kG0SGMlfGmw9yyK9kCRyli00Ta84knpSt1FP70vbpDIWM8TtYyj9yBjMgVSrHf50hBg9Wtjfk0pBroWpaAYqwqlwC7go3dLsfthgWZY4qJtQtOHH6Kls684Uo2bUXyNI9scyUfhdsxKYfYnMRSCy+pj8QryvDNv1vNAqZS31nVO9JhUDTXQ3hR+o7A4L+gNxIkWFpTKbxJyVRLLgkYCPQ0LWljQz7rJcqaVqgRR/P+KeahDZ9rhZZbB9E6G8OfOW48k9kvkHODsg==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pN/DciCaPd3DoszN5Cqp2YlA0+zZy6vMTgMEN8ujbFYK6FRrz7LA51Bu3rVc?=
 =?us-ascii?Q?Cu93AGhbXpdJmKmOO4G6mLfHXZdBuxjS1Wpcq6oN3Y9MHMrmpc1+gZCBZkXS?=
 =?us-ascii?Q?4B7X7eLoaRHK1WAqiVRbzeZ6YuMDgy31yEe8fR9bvj47f8fOvTyvavhyaZjf?=
 =?us-ascii?Q?xGcxz2SVVYsVTlTFe+gkvQQoRxO5oP8GJ5tAgTVMpZRDQLShdjqiJVSstwaS?=
 =?us-ascii?Q?XhUjeqXsm9zwdqsBF/WdCMIX2hcqNj/Sd6WGQf/79fb7IFXbon16S35jmP2P?=
 =?us-ascii?Q?lGIvjrgHsFRvvtxITMkU0H3AVmo5PcLwzXiXfqKOK7yqfCo3Zp8c6cmN1cCR?=
 =?us-ascii?Q?hl1143am1kzuLYb/z2TrSNPE3V2iiAkaNT/6/649TmES//jVyOFjpqxKCiQj?=
 =?us-ascii?Q?gJuiA7ILNUZsLcbIKUrMOdGguh4wsGUDeRFlxl/Bhqi9Rj/gf221HtWAKGW8?=
 =?us-ascii?Q?qp8UA2ZGHCeDa0E+1ESsR5vBnyY2bpFyRt4wK4gQIjxetBIJQHm0wJQoWPTo?=
 =?us-ascii?Q?CrH0RLwq/Lp+1lTU3S6ofyq0Ft1/NPpcvscCqBSQkgkStT7epLzTn4q5WLwF?=
 =?us-ascii?Q?B8EYHOlkZJfAT71YD+KJQi7XbN0jSwE6hYTVTlgyiP+k0NdDRa7pEabCSEVo?=
 =?us-ascii?Q?QbGbq3qXXXl18jWvf8yq+i0rThIE2TB1s0ueKDakR2NoDTU2Pr9/OX2pvfTb?=
 =?us-ascii?Q?Pjlh1t5ZaMt7HVQgAxzQNJkmsTzD878UM/Auz5TYJuORDIRnW01TFR5PKYrb?=
 =?us-ascii?Q?q1PCG8L4MWFa6lKK2gP5VrHZw4oLVNF4rv272pi8gBtEwmDzPuXLx+suCxmU?=
 =?us-ascii?Q?/Z2GcBGK/uYhXJ8I55hkNAEnUGL93Wy4k3Ws5RaF4OP8yIgH3pz1Z/LRlHL6?=
 =?us-ascii?Q?OuryPQRCPNmdI5v5Zo1x3d+aNAGN1r5EQ7gjL6xxy+9EJmcVGk7h2d72hAwJ?=
 =?us-ascii?Q?vGF+MxMpqxuMzsEfQH6I2dy1HdaJthCDkhN9UAReqLlv7ZtgweGXAhPuE6+M?=
 =?us-ascii?Q?jomhTQHmzKFIoqkfw9bfE3yeoQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <252E772FAB961442B7E586DB6B1037D4@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e85b989-ac84-454b-1e32-08d9ebd85a9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 14:27:51.5007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2PR01MB4905
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

On T2 Macs, the secure boot is handled by the T2 Chip. If enabled, only
macOS and Windows are allowed to boot on these machines. Thus we need to
disable secure boot for Linux. If we boot into Linux after disabling
secure boot, if CONFIG_LOAD_UEFI_KEYS is enabled, EFI Runtime services
fail to start, with the following logs in dmesg

Call Trace:
 <TASK>
 page_fault_oops+0x4f/0x2c0
 ? search_bpf_extables+0x6b/0x80
 ? search_module_extables+0x50/0x80
 ? search_exception_tables+0x5b/0x60
 kernelmode_fixup_or_oops+0x9e/0x110
 __bad_area_nosemaphore+0x155/0x190
 bad_area_nosemaphore+0x16/0x20
 do_kern_addr_fault+0x8c/0xa0
 exc_page_fault+0xd8/0x180
 asm_exc_page_fault+0x1e/0x30
(Removed some logs from here)
 ? __efi_call+0x28/0x30
 ? switch_mm+0x20/0x30
 ? efi_call_rts+0x19a/0x8e0
 ? process_one_work+0x222/0x3f0
 ? worker_thread+0x4a/0x3d0
 ? kthread+0x17a/0x1a0
 ? process_one_work+0x3f0/0x3f0
 ? set_kthread_struct+0x40/0x40
 ? ret_from_fork+0x22/0x30
 </TASK>
---[ end trace 1f82023595a5927f ]---
efi: Froze efi_rts_wq and disabled EFI Runtime Services
integrity: Couldn't get size: 0x8000000000000015
integrity: MODSIGN: Couldn't get UEFI db list
efi: EFI Runtime Services are disabled!
integrity: Couldn't get size: 0x8000000000000015
integrity: Couldn't get UEFI dbx list
integrity: Couldn't get size: 0x8000000000000015
integrity: Couldn't get mokx list
integrity: Couldn't get size: 0x80000000

This patch prevents querying of these UEFI variables, since these Macs
seem to use a non-standard EFI hardware

Cc: stable@vger.kernel.org
Signed-off-by: Aditya Garg <gargaditya08@live.com>
---
 security/integrity/platform_certs/load_uefi.c | 122 ++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/security/integrity/platform_certs/load_uefi.c b/security/integ=
rity/platform_certs/load_uefi.c
index 08b6d12f9..668b2a713 100644
--- a/security/integrity/platform_certs/load_uefi.c
+++ b/security/integrity/platform_certs/load_uefi.c
@@ -3,6 +3,7 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/cred.h>
+#include <linux/dmi.h>
 #include <linux/err.h>
 #include <linux/efi.h>
 #include <linux/slab.h>
@@ -12,6 +13,106 @@
 #include "../integrity.h"
 #include "keyring_handler.h"
=20
+/* Apple Macs with T2 Security chip don't support these UEFI variables.
+ * The T2 chip manages the Secure Boot and does not allow Linux to boot
+ * if it is turned on. If turned off, an attempt to get certificates
+ * causes a crash, so we simply return 0 for them in each function.
+ */
+
+static const struct dmi_system_id uefi_apple_ignore[] =3D {
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro15,1"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro15,2"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro15,3"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro15,4"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,1"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,2"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,3"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,4"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir8,1"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir8,2"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir9,1"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacMini8,1"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacPro7,1"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,1"),
+		},
+	},
+	{
+		 .matches =3D {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,2"),
+		},
+	},
+	{ }
+};
+
 /*
  * Look to see if a UEFI variable called MokIgnoreDB exists and return tru=
e if
  * it does.
@@ -21,12 +122,18 @@
  * is set, we should ignore the db variable also and the true return indic=
ates
  * this.
  */
+
 static __init bool uefi_check_ignore_db(void)
 {
 	efi_status_t status;
 	unsigned int db =3D 0;
 	unsigned long size =3D sizeof(db);
 	efi_guid_t guid =3D EFI_SHIM_LOCK_GUID;
+	const struct dmi_system_id *dmi_id;
+
+	dmi_id =3D dmi_first_match(uefi_apple_ignore);
+	if (dmi_id)
+		return 0;
=20
 	status =3D efi.get_variable(L"MokIgnoreDB", &guid, NULL, &size, &db);
 	return status =3D=3D EFI_SUCCESS;
@@ -41,6 +148,11 @@ static __init void *get_cert_list(efi_char16_t *name, e=
fi_guid_t *guid,
 	unsigned long lsize =3D 4;
 	unsigned long tmpdb[4];
 	void *db;
+	const struct dmi_system_id *dmi_id;
+
+	dmi_id =3D dmi_first_match(uefi_apple_ignore);
+	if (dmi_id)
+		return 0;
=20
 	*status =3D efi.get_variable(name, guid, NULL, &lsize, &tmpdb);
 	if (*status =3D=3D EFI_NOT_FOUND)
@@ -85,6 +197,11 @@ static int __init load_moklist_certs(void)
 	unsigned long moksize;
 	efi_status_t status;
 	int rc;
+	const struct dmi_system_id *dmi_id;
+
+	dmi_id =3D dmi_first_match(uefi_apple_ignore);
+	if (dmi_id)
+		return 0;
=20
 	/* First try to load certs from the EFI MOKvar config table.
 	 * It's not an error if the MOKvar config table doesn't exist
@@ -138,6 +255,11 @@ static int __init load_uefi_certs(void)
 	unsigned long dbsize =3D 0, dbxsize =3D 0, mokxsize =3D 0;
 	efi_status_t status;
 	int rc =3D 0;
+	const struct dmi_system_id *dmi_id;
+
+	dmi_id =3D dmi_first_match(uefi_apple_ignore);
+	if (dmi_id)
+		return 0;
=20
 	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE))
 		return false;
--=20
2.25.1


