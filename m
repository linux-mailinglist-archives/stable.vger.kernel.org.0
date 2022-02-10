Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADA54B0B2C
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 11:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239998AbiBJKpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 05:45:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbiBJKpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 05:45:07 -0500
Received: from IND01-MA1-obe.outbound.protection.outlook.com (mail-ma1ind01olkn0153.outbound.protection.outlook.com [104.47.100.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B22FF4;
        Thu, 10 Feb 2022 02:45:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EyxUOJTml0JO98PqWFA0qUP1iw8hbxltNf3eeUOi74dQMsuvDE7FCugTUpghK0dyTkaaWS8vcGq7A/5EVfb8VuvjYNKO8b9DxU8A00ZgQDKnZP7gfBdDO3TJgzlTdZ2+12Bxl4n8jv1N4ASlICh6l/+VGYza68/R8qk9FAAYfBWu+Uw8uEF2hTfFbwtXb6P6j//JBYGMNLg3ivKvZLMN1THS1HAjE5xQczEsSun67dD48xdEUx0hPqYkY3NL3a2YAhGirWA0D3G7r/tL1Zi6BuAtZV2EemTdQlW67SyVdVOQ02pMQREoAkiDzCIKxANgb7O0DRZx3AiAhcFpy4czUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wc3dSmCSjCIjoJ73nz48ZoO2auXacdEJ4TRoLW1aub0=;
 b=JJTkrEFeQffZs3BSC/3jU6zcRLxmF5razmRww2HvFSCTISpuRVm6l0BcMaSzwmsefEldHjXKFvLjx+uegOQxyVeQR+4AVZ3R4X3sjEkE6nBG3n3rgGm0jkQOsTFkGjgZxAA5lPDcIvA9qgDPNt4XOSQom7N03yFr6fO4JCxx5SHQvOYW0fzxTbBo7IqfjjkU3uVj5wjebszEDPlD50Lc5qGzr9csr4F2t03xBffCyOEY24TNB9son9SSL4O6TORZ1pPHJIfTqgKmVPa9p8dbQPpB9LqjrC9kLWfjJ7Q8hQcpovJ1RCYBRQN7rTK5fDbgkECfmRHLFECZZ8JxG7MqRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wc3dSmCSjCIjoJ73nz48ZoO2auXacdEJ4TRoLW1aub0=;
 b=IPz/dkgDet8YGhCneM8Z7ZiWSofQTZWJfTJE4r/Vvdcy/YHR4QKQx451I56FUwRVAmpepmsyeorF5I+BJAOTQrz9RiXu49IGKoGzlLGgTIMvX6nbTcghnrDNyjo3vNg4l2eWz6dfgZG+WNU7rh281Dmw43u9PShyISo7y2v0EjPc0Aw561RjLTw6RuWoegXEgBNvU5H6c5W0GBFm8h28v1kKYaZueBhfJdd5fUB53vfJtvNSwIDJ6pRjTPrwq+SX+BimsNYvE3efBZhNeyx8flDRUliadAdC5mRsBFNiQuWtXDGGuLuNZ1q39PFN1suq1GsJvDDgAruSUz0CrLdK9A==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by BM1PR01MB3298.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:70::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 10:44:59 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::d19b:7cd1:3760:b055%9]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 10:44:59 +0000
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
Subject: [PATCH v2] efi: Do not import certificates from UEFI Secure Boot for
 T2 Macs
Thread-Topic: [PATCH v2] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Index: AQHYHmtA4z5wqqQYYE6Kz0MkHvU+bQ==
Date:   Thu, 10 Feb 2022 10:44:59 +0000
Message-ID: <20103919-A276-4CA6-B1AD-6E45DB58500B@live.com>
References: <9D0C961D-9999-4C41-A44B-22FEAF0DAB7F@live.com>
 <755cffe1dfaf43ea87cfeea124160fe0@AcuMS.aculab.com>
 <B6D697AB-2AC5-4925-8300-26BBB4AC3D99@live.com>
In-Reply-To: <B6D697AB-2AC5-4925-8300-26BBB4AC3D99@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [ALG0XufgQanVVK8iVwTCo3ZAr2dWJg3LsLzXJn9gzXIjNA6LTl3wjscGbomlWyEl]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a8b8826-bc44-4708-8720-08d9ec8262ec
x-ms-traffictypediagnostic: BM1PR01MB3298:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5oRxMoaVOUcrmTJX0myokozFWmZY0lrieDaI8hK8bt86g6gRISviGj8zfaEW22zAdaZTzwHy0/nWGgvM9a3IsOJLhdVPTSOue5PLNFuqlElXbnNYxLZ13yY1TjQSoveA7ilVsyx3/lpeZzeqFS1Ii1uDhZkNX97guJJb2F/ODe/KQQvtdsZpMr/VMyryXD449z+hTTwWzflGhUN3owLpH+c6Dwi4FeomK0a1yBeTV6+7xSFPKywR/ZfMEL+3FaQoXT6y26hfG25r07RE6piblykbHDwC25nrYpzIgqM4OCpwnVmTvtrnj5lFtYz1n7QtECksjC0+w2Ej/HhO6CqwF98xRQKgx6pEzkuQf8mMl8lfNgeXBJdOMFchb+qUXJCRbvtMQ7K4JppQkiLUpwYx5ajj1zTGdUuqAsOpErz03TOrwfRX4JAUXeU/3E3V4bAjZpZnwRuak+sny2FQM5Np5qe2RV5qQxS/HLPjj9a8zjzg5RlUoxtlJjQRIZCJnUI09lEKV4QwZ/Ag59zk1ZqxmLm1Rf9FxqvIndI0UbYAK2ULRWQco45U/8YYBOCPipTd5M3SlwUZ/1D1CaTn/YED8A==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SODpoHymS9kqtcA59kCT6k7ztYGuBNnIqfHuWFQTysAFGhKrSn7vNlrmI9Tj?=
 =?us-ascii?Q?3CGQvuJ8eyKXxbbSDbm/OJAEMw1GwiHq9Cvny3fgFGAkLyUSBxmEC9shvofS?=
 =?us-ascii?Q?E5W2aT8q74/Q0eaKQJIh2PCD1Hia7/3MKnGL47Rc5RpvRs3HFwIHp3172UX4?=
 =?us-ascii?Q?6g9CfZLoDnbXaiwFA2Yt+bAcHzl1dXkl217czSp+zLKTq6j8JPTgHwwgi5jo?=
 =?us-ascii?Q?H/ywyK5Vs7P+OIBn0pP5X1T+hy5vVJqKd1g+BQxJNl0Q0fda9V20YgosVUZr?=
 =?us-ascii?Q?9B1L73ZlPy2ps2F5NH2ijgqpz+3FCLANJwxKaB4J+UVLdTsGGEd2ftXkILZB?=
 =?us-ascii?Q?nP1owOUOf1nZA1Cme/BRCpn+zQGkYl9EiRr+mP+ey+5v8QX6kTQcNCymrPbg?=
 =?us-ascii?Q?XQvrCo8HAvNGT/0gmZlNLTVp0rsyhMt/M4f3e1Ki2K6y4c1LxbjjLNEOG3zD?=
 =?us-ascii?Q?d6UATQONRJQJWypkqyBpuydtEceFeOi/5FMJfs0r3W8vmBge8fapNlluiwZG?=
 =?us-ascii?Q?Oh8KPT2lu5YiHvP709l3LRHEWQVXl49/UpcNDPSwcCwL3Yewi22OJgFA2090?=
 =?us-ascii?Q?hCesqUnFbEW943QcvXSsksm065O9mRnDZ7vY9/aB2AhxZP0BHZ7oSaHD0q+j?=
 =?us-ascii?Q?hKez7snetOkipgmsCK/3RYT+uMBDvw41rMUuN2D0iC8SN4+3eetEgkzEpGXT?=
 =?us-ascii?Q?JOWj5SuqiLtEY0wY9CNx5M3l4OEn/Z0O6LrlLPfx31zav4DTrrDMlJXrD5P+?=
 =?us-ascii?Q?+TTkhEIpezQrcY1B1aq9X12NerznJ/JZA5FRSgzkxNv+sPd8UdqOAGwqyHV3?=
 =?us-ascii?Q?kZAVtkysI0nVNh+EuRmqh/plHroAE812lmMeJ/tIqw8r60aWD8eUH25TX8NE?=
 =?us-ascii?Q?TenxyddJxnevniRmkjoRFDQ2Hd62BmRvooIMOWE2pS2V+lDgLhMd5u/lduyd?=
 =?us-ascii?Q?cu10UtkMsViOyFClPTuDcoTv/hGp6zueKy391sG+5rLBYi7sTSjRVuL5fcNh?=
 =?us-ascii?Q?9uqHB4rCA8fS3P96BPHnuJdgGw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EF5D9B2848637449B46CE31C7B34D124@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a8b8826-bc44-4708-8720-08d9ec8262ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 10:44:59.8739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BM1PR01MB3298
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
v2 :- Reduce code size of the table.
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
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,1" },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,2" },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,3" },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro15,4" },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,1" },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,2" },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,3" },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookPro16,4" },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir8,1" },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir8,2" },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir9,1" },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacMini8,1" },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacPro7,1" },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,1" },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,2" },
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


