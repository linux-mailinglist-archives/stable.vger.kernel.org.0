Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323B14B0B49
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 11:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240104AbiBJKre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 05:47:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234440AbiBJKrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 05:47:33 -0500
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2038.outbound.protection.outlook.com [40.92.103.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47447FF1;
        Thu, 10 Feb 2022 02:47:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFrUpqiPYSavrgdCDAOu5zdls4hj0EEBotqfKDnx1gyseqMgp4Fx1XBYUU6RhrmXbKvBGp330n/eu/SY+9EiGOC62mIbWYEDcTRGe24yfHKPh64cYgUjNTqhihEMgWxtY4WWW/OtvAe4BjteFbYHa7W85jrZ/5gCJ9BTWUAzkp3TB8otKzkgON73oeX/+VI6OoZSzNqI0bKHkE1M5ar9rn9rPsNvNjafp9lAmthQqVQ5asAlsl31YPO+tJ5ff55+jCvYZvzXHZc0s3OKP5rQgHBqqI35D7wIDcInaht4+e2gLgH3rXsUMYjMFimjZ3rxriw2ujXAqQhnhQa2API1Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HRYT9HIVLI3JsGOF2U/SbYZObbuVI/T8O37W1Car8WE=;
 b=FLmsHtfpZ+78p7HK+wHBEyQZxdWG3ufoMdz7eCSxT/4/sZ9F7HSScVllzDe5tz2H3M4dZiBn/SQc90ija2YjO+dUPxx24N8sIYtQKHY5EaMX67syVAj75k/jxNiYadOHbPSyXMzZmS84almOlB7+cMQyPpksmND5qBuObv6DwbpwsVe3z3oONpWTg5R+H5CjDXzhkheFXBVRrsV5RMNAXnbKRJDpFoHehJRTFU6u7RPaUJCNeGevRFCaxom7CgR8j8GCD2tINs0ajAXrcgsc4QW+I9MD2x/qsgehcOcgYmJtgUjCesc7BVteqfUHEkl4iI9hUTN3nhRf1C5Dz9muLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRYT9HIVLI3JsGOF2U/SbYZObbuVI/T8O37W1Car8WE=;
 b=D4jf82eRSo8B2zEYU1zKOtxNjqn/STW4m9RxVv0+IKwgr88Zkj1EDS8VCdyZlKgp7OaNnqj8Lnciw1nPdIs69sU9gEOct9n6lxsQ5wkChbathNLFZ4dGybkLQrKt222ZGO2kKcl/NrYC8gggVX124tyZpnXzpPA4+OYANkU8MSzPmZxK8nCUngdTHECJPjzOxkw2YRnLWFzdt8kfWOJiDkLBCiUlTTyzm4JEAXAydG+d2kElh3CsmfqovE+mtLFs4MwyiVw5cKOYUM9D5pWGzGNG+c4K7/RBjR9nKvMOPFOj1fVCskXp05jkkRCIzhlgmzYWVNshmfHHyLFfEFz4CA==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN1PR0101MB1373.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:12::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Thu, 10 Feb
 2022 10:47:26 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055%9]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 10:47:26 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     David Laight <David.Laight@ACULAB.COM>
CC:     Ard Biesheuvel <ardb@kernel.org>,
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
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Aun-Ali Zaidi <admin@kodeit.net>
Subject: [PATCH v3] efi: Do not import certificates from UEFI Secure Boot for
 T2 Macs
Thread-Topic: [PATCH v3] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Index: AQHYHmuXo0OUa+Hs10CvZQHQjSvBZw==
Date:   Thu, 10 Feb 2022 10:47:25 +0000
Message-ID: <7038A8ED-AC52-4966-836B-7B346713AEE9@live.com>
References: <9D0C961D-9999-4C41-A44B-22FEAF0DAB7F@live.com>
 <755cffe1dfaf43ea87cfeea124160fe0@AcuMS.aculab.com>
 <B6D697AB-2AC5-4925-8300-26BBB4AC3D99@live.com>
 <20103919-A276-4CA6-B1AD-6E45DB58500B@live.com>
In-Reply-To: <20103919-A276-4CA6-B1AD-6E45DB58500B@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [/sn4PgodRv9bp3IRw+XKISIGt2VAsvHyyOZg3fZAaHq2IkR3TBxOimRl23uz3VvO]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c25890f6-4da8-415f-0fcf-08d9ec82ba0c
x-ms-traffictypediagnostic: PN1PR0101MB1373:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EKvigcjQ0iSdMsUaMVKfS3hvQ9Hqdx8JxB9zUKKbUDOaI5FYcN8aK1JLiexF+J/JLOfVbm25tqPMt2R/f7d9AuM7e6oEORUhWmcxSitkafDeHavYsEutWb/pUtNzHpQochaahgZru6PQUEpcdjF2jVPUdOp3YJYSXNxLwEk4zwdZtppUmAOgUMyAjaCHqcATN3SWefRtlFsMu2dHaQ4zckTODsY1FiKbKTtM/D4ZOIDbqSXkHPfBpKh3W7SQIFAt1fte7w0P3+2SCORbixO5eoyiP97hYaA8OpmkEIYg1ZZySlZximCR6kc+HR90TxgoHs2NADAl+x5+ZH5GQGB1/33OeBG2m3O1NrgAQ8fkIGwvbDhOznJgnFIFuV0cQAK8LCF8QahLWrIMoC9DTk5P5+CzVJXv3VXxtV2hNZSSmCCJUk5+jL478bCI0ss1Hg/3LAFUiAv+5dM6PFVxyxQbfOTNqsHGfhKZJ4uRs9nJe24UoZM+fTX+AUPCrpBUghVnPflQ1KRMaWIEKay84YzDJfjOLDSiOBcCFhJWAISxpN7TX/96ec/VUBg1y9sjxRIk5DM+VmZYmI6TfjbrwRWACg==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2yBzg5IZ8d0M+F+JwJ16lgaVCn4WqxWQabmjx/iTgWkbtJZjrl45y3sjLbnl?=
 =?us-ascii?Q?x9zJIlwwbuNkXN6/nCWSdEL2W83oWt94xpiz0VkHC0BmM7e3L5Wqr4xD9pXX?=
 =?us-ascii?Q?Y7kIHEW6bYYmAKn+gKkNyR36U4PvyVh4Ie63Kk+DPQPV8HnlpSBRRrJUyI2i?=
 =?us-ascii?Q?SIioqTsr47RoSNyLmOg8LeYKAmSAEiL4bA907cjmc7XC2K/QJOmBs99KvbUI?=
 =?us-ascii?Q?WmavmTKJHL9cYzU5V9JIbq6fxGNzd7u/fYKoEvVWoTojymQ37X2A5SOR4PIA?=
 =?us-ascii?Q?CgBxAkrw2Sm8FUBHxQ56necMHVLPozcojvIVVEIiiKXCWprawd4efiaC347r?=
 =?us-ascii?Q?mos0pLsE41efOG5vx1RnSataDeTeNFddBQyyXy11KcxNNUhFCtwui4Du4Ao/?=
 =?us-ascii?Q?c5io+Nzn0kt/EJPTaKAelAJ1TRQ4LinNoy01hth68LKsJZXMyMvP3vWnLea4?=
 =?us-ascii?Q?kdjmET5kCbcmTOcIrv7dYFB8rwDrAbYSCx+poOoa5HEShhrSZD1C0DHmBGaR?=
 =?us-ascii?Q?w1Qk237FYQuMVtMGAAX98+oiy79+D8/BZntWrpqqNx1Qn1VCATpw5k6M3TO5?=
 =?us-ascii?Q?DC4t3PFfyXKhP0iWCvkgCToMOxmoRjUtsa98KkU0ZqFhx2K5UEcDxTsuTUCs?=
 =?us-ascii?Q?/v7RAeBROZ+/gpoaaap8Y3s6cK87NvfbpaM+RzIHDtZFTkoNlIOjFJZum3aN?=
 =?us-ascii?Q?segm22RbDozlIhAyzb905P1+LIfwHMf6fGAsaJLr4jzMRYRf2FMK0C9Z5fWt?=
 =?us-ascii?Q?iuBYdyMGQT6yZjLgmlqdR0DhTdBbsCl1VLYY5icdTiLl4PmRLxDxIjecNg0U?=
 =?us-ascii?Q?jaH7wk9bcM5hX6NIAQlQgrNMxDuYh4CA0SHHAsMkzdKmaRZGr4ooIlDHxaen?=
 =?us-ascii?Q?TQcjeZHOcd1Bd4+Uz681RP3J5Y2OKQiaPB+jAH/JLS/ay2SJRnotgykoVXNP?=
 =?us-ascii?Q?9Lwk3gcDdua8wfHy7b8e5bH4m+tnF8jWPryuBKff2/Q7emd/anFZsBFfwkGN?=
 =?us-ascii?Q?+L6qfr0umpmWLCfTB/xrWUSJ7w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7AAD87CC3986174F99B9712487CAEA1F@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: c25890f6-4da8-415f-0fcf-08d9ec82ba0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 10:47:25.9798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN1PR0101MB1373
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
v2 :- Reduce code size of the table.
V3 :- Close the brackets which were left open by mistake.
 .../platform_certs/keyring_handler.h          |  8 ++++
 security/integrity/platform_certs/load_uefi.c | 48 +++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/security/integrity/platform_certs/keyring_handler.h b/security=
/integrity/platform_certs/keyring_handler.h
index 2462bfa08..cd06bd607 100644
--- a/security/integrity/platform_certs/keyring_handler.h
+++ b/security/integrity/platform_certs/keyring_handler.h
@@ -30,3 +30,11 @@ efi_element_handler_t get_handler_for_db(const efi_guid_=
t *sig_type);
 efi_element_handler_t get_handler_for_dbx(const efi_guid_t *sig_type);
=20
 #endif
+
+#ifndef UEFI_QUIRK_SKIP_CERT
+#define UEFI_QUIRK_SKIP_CERT(vendor, product) \
+		 .matches =3D { \
+			DMI_MATCH(DMI_BOARD_VENDOR, vendor), \
+			DMI_MATCH(DMI_PRODUCT_NAME, product), \
+		},
+#endif
diff --git a/security/integrity/platform_certs/load_uefi.c b/security/integ=
rity/platform_certs/load_uefi.c
index 08b6d12f9..f246c8732 100644
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
@@ -12,6 +13,32 @@
 #include "../integrity.h"
 #include "keyring_handler.h"
=20
+/* Apple Macs with T2 Security chip don't support these UEFI variables.
+ * The T2 chip manages the Secure Boot and does not allow Linux to boot
+ * if it is turned on. If turned off, an attempt to get certificates
+ * causes a crash, so we simply return 0 for them in each function.
+ */
+
+static const struct dmi_system_id uefi_skip_cert[] =3D {
+
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,2") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,3") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,4") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,2") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,3") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,4") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir8,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir8,2") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir9,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacMini8,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacPro7,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,2") },
+	{ }
+};
+
 /*
  * Look to see if a UEFI variable called MokIgnoreDB exists and return tru=
e if
  * it does.
@@ -21,12 +48,18 @@
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
+	dmi_id =3D dmi_first_match(uefi_skip_cert);
+	if (dmi_id)
+		return 0;
=20
 	status =3D efi.get_variable(L"MokIgnoreDB", &guid, NULL, &size, &db);
 	return status =3D=3D EFI_SUCCESS;
@@ -41,6 +74,11 @@ static __init void *get_cert_list(efi_char16_t *name, ef=
i_guid_t *guid,
 	unsigned long lsize =3D 4;
 	unsigned long tmpdb[4];
 	void *db;
+	const struct dmi_system_id *dmi_id;
+
+	dmi_id =3D dmi_first_match(uefi_skip_cert);
+	if (dmi_id)
+		return 0;
=20
 	*status =3D efi.get_variable(name, guid, NULL, &lsize, &tmpdb);
 	if (*status =3D=3D EFI_NOT_FOUND)
@@ -85,6 +123,11 @@ static int __init load_moklist_certs(void)
 	unsigned long moksize;
 	efi_status_t status;
 	int rc;
+	const struct dmi_system_id *dmi_id;
+
+	dmi_id =3D dmi_first_match(uefi_skip_cert);
+	if (dmi_id)
+		return 0;
=20
 	/* First try to load certs from the EFI MOKvar config table.
 	 * It's not an error if the MOKvar config table doesn't exist
@@ -138,6 +181,11 @@ static int __init load_uefi_certs(void)
 	unsigned long dbsize =3D 0, dbxsize =3D 0, mokxsize =3D 0;
 	efi_status_t status;
 	int rc =3D 0;
+	const struct dmi_system_id *dmi_id;
+
+	dmi_id =3D dmi_first_match(uefi_skip_cert);
+	if (dmi_id)
+		return 0;
=20
 	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE))
 		return false;
--=20
2.25.1


