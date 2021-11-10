Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372C944C41A
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 16:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbhKJPN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 10:13:28 -0500
Received: from mga05.intel.com ([192.55.52.43]:61903 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232468AbhKJPNW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 10:13:22 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10164"; a="318888173"
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="318888173"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 07:10:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="669830325"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga005.jf.intel.com with ESMTP; 10 Nov 2021 07:10:33 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 10 Nov 2021 07:10:33 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 10 Nov 2021 07:10:33 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 10 Nov 2021 07:10:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h+fTQsrR4cdX8zyhgc4Ge6dOSy4QPm8LzEiN++HCUCoggK4SwsbgZu5fw2jc5JbjNGGCEhxh7PwsvumHEgBVM74HB+rJI3uho8Y3izXZnPUg9Gjyt6OEbH/3BdWYvw5ipVfwbfQ2EOd6g3SXzB02p04GGbRSCYAu9cGlwIx6GcA7/YAIHT4Kie8GUVEvvUWAqHS9DPFweyilBXc2BTCRV72OGxd/QfgB8uFh48p1sD75CJXrR4ejIPAHQzgvZHsLHUY0TvHIfzTCFQAAIyMbIxvfuA/7T6mRb2SqmJk8UeoaUxLDKaGSu59xoNUWM6zNWngy/xQoU+E51fWNuOxp3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XdBAPtA2thbzIvDGozWG/mfhDOLrqnPylSFlRLMgNmM=;
 b=cav+GglfgPShgkeI5v5c1yh8kJByC5nuzqdUBmXrpGvLpkY8lVKnmaZH2WLRP8ZUYroDr4/phBnxWmU9BULmAU0K2OIC7LWIjlw9xq3XAZQfdJxuuu2q4/FYEzn/u4dWQV2vozrOfPCA31ckbeJM/j6d9gUMA9eGSpzdY9oqnhe/Lbq8y9SxHArz+4sWlUge8VjQIF+0VwUe2zBAss7JFhA9Gd9f+m/KqJlBW5qWR/ojMg1begydR1LEvr4psDXSycwaDUgXCg5DpsDacJl9LXxVHRtUXOlqjZRkcoY0q0l/wcNw6Xae3CKtlkbVFCmVGFEjKa86vdDruFP2NZkOtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XdBAPtA2thbzIvDGozWG/mfhDOLrqnPylSFlRLMgNmM=;
 b=BxWmgFV4RlE6YnA5aEq2nly6Mue6Eqq+nFl6bO446K8ccmmoGd/UmikdaOTkhTmfz7dpRS0Ox1EfaphxpTJUvsbanAf1rvC18orAOToeaxtWrsixyKv2oLBXd0FwosycyZfBJXmNX3Dj3nRykdoMNVYM4fzzzaIeu/aUaX/vTAw=
Received: from BYAPR11MB3256.namprd11.prod.outlook.com (2603:10b6:a03:76::19)
 by SJ0PR11MB4815.namprd11.prod.outlook.com (2603:10b6:a03:2dd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.18; Wed, 10 Nov
 2021 15:10:31 +0000
Received: from BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::61d4:ab77:cc62:fabf]) by BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::61d4:ab77:cc62:fabf%6]) with mapi id 15.20.4669.016; Wed, 10 Nov 2021
 15:10:31 +0000
From:   "Moore, Robert" <robert.moore@intel.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Reik Keutterling <spielkind@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>
Subject: RE: [PATCH AUTOSEL 4.4 15/30] ACPICA: Avoid evaluating methods too
 early during system resume
Thread-Topic: [PATCH AUTOSEL 4.4 15/30] ACPICA: Avoid evaluating methods too
 early during system resume
Thread-Index: AQHX1QZ+Ms7KajTmukyGgWbWHmy0Yqv83/Cw
Date:   Wed, 10 Nov 2021 15:10:30 +0000
Message-ID: <BYAPR11MB3256001FA32D50DE6F56425087939@BYAPR11MB3256.namprd11.prod.outlook.com>
References: <20211109010918.1192063-1-sashal@kernel.org>
 <20211109010918.1192063-15-sashal@kernel.org>
In-Reply-To: <20211109010918.1192063-15-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae64611f-ff13-4907-ec31-08d9a45c3cad
x-ms-traffictypediagnostic: SJ0PR11MB4815:
x-microsoft-antispam-prvs: <SJ0PR11MB4815776C505BA29AD02CA96C87939@SJ0PR11MB4815.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f0yjFSZ2u5BCxSOlF3MftlQys9dQ2cE/8g4L7xoO5reevVPpr9OTdVMA8a7WIuZjZWzYX9/tFLSmRux8Mr8O30MltdMv3GYGYNKQOeTHruOre0zga9AmdwaZFegW2sCZpOvcpRpMdHblNcN08rFqnW9yuCHB5zZuEGQKJgiXhqypFzV7Idjif3jOzGaIba+jLRzkD47Au/Ei52/vCrBj9B0uJEV1W4duQCAkT2L1yUJdSdwkFt9dS0SUwiIa/8W9huq6ZxgtFQWBkbRq5e6cT5E9qmjN8IqHEUwh0gAppldo+Z4+eLMHevDwTYubU50bVIzHb5/U7BtCzaq3aRtvErUHImy0JeYAwyVlZTywhjPUDXvwMXOMdmLZ6hOd61BI9vbF04+yvUMADsnWgOdwOGBHXTNir5Zz+uHmCGi82TgxOrv4rCwWizknSIxFeet49uf9buD9v/rX4JS2Gg05cdMaYFKcSxffkcccWJn4rL1LeYaYMAW6R1IRVnO4cFfGyJHMkeWOUoew/P/uJ/EjDxwzm20wOsZR2beFF5+C1eJYssjx4mqozaZp1DlYc0S6JwrHc+XVEzRGiKJDKae3UTnXlLaHD0KSownfAoxnxa9ifz7pI5AfSeViXUXt50GzOPNr1YLXTFhXZHrQcCk1zIOqr8/81L0L4lzHTcpd/7Y+z1hohRCsINGRf3tvi2JG6alNeCWtBSqZac5qe8aYzhEN8qNHYruZqLtZ8asfKB/6Q+CcSQes4R3IZ2h5lSBwSTPCZc63qbxcpjwrelY26CYqkou1DjttrGe22uEkWCM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3256.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(83380400001)(5660300002)(38100700002)(66446008)(64756008)(66556008)(66476007)(966005)(110136005)(54906003)(8676002)(71200400001)(26005)(38070700005)(508600001)(82960400001)(9686003)(316002)(8936002)(55016002)(52536014)(86362001)(33656002)(2906002)(66946007)(122000001)(6506007)(76116006)(53546011)(7696005)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lCLNPzd1P4JhillxKXDUgRCsEVvcK0NY6VIRM8+jTxLXSRewD6O21tYsLMD/?=
 =?us-ascii?Q?6xbDsVPCMoArCXYmMKxeYZuMvrBKG1p/nC7rK3eCFtpn8D9KH6CYA8XSyW21?=
 =?us-ascii?Q?EpyggZQ6W6eenleQN6wnDQhKkK9j9322+thKkdnr1Mm6mX1+Ag9ym8w8ZsvA?=
 =?us-ascii?Q?WRWu+RQVm8SIKaDTwKC4SBr6dGhNS25EhgSVJ3tg4PyHr/YZdg1XSc2kpmaV?=
 =?us-ascii?Q?RGTRiqEKgMEliSiuQ/XVzCpvY3ideYhA8EB61LztSDgVK3EBrhINRq9rO/mZ?=
 =?us-ascii?Q?rfFSmLJapaA1U48kO+yZuBB6g+APPz4Wr1MCGA8+cqtOXAKn1xcsN03r6Jej?=
 =?us-ascii?Q?vHbTyWqY5sUzhIfnswE+fqsxEOsPiVBrlHxUD/mcZaipiOxsZxpiSZMr38Km?=
 =?us-ascii?Q?A6HtoOy0ARjitD8mxVgS3xEBaGcWNfnFYUa1i9aHpUmMhmZVZFj82X/iz17K?=
 =?us-ascii?Q?4XlZzp7UMfJ4xQLTmfGm0vsUnjY2y74tmGRaKHrrRMMVIBtbIUmQJROPQ74w?=
 =?us-ascii?Q?SaQ2Pap1mF5GzUJw86U9vq9JAbDJt/Xz4+tO+GVsLx5qyPmBOC5zOUPcGq1U?=
 =?us-ascii?Q?FI6aM+a2u7S+ggKfkhBT66DWqUjscQlAcIbOf1yk6xQr47zrYqYH8k+Diiex?=
 =?us-ascii?Q?RyQ9gcT7DiXBNLPZk/MFYNthenZ4lyrDPHo71LnQeaf5ip5jWxVO+SaFqLti?=
 =?us-ascii?Q?QJyzrCGV3k3Zd367H07u3A0e5XMZxjy1D3P995ckUVC6qQsLynemo4Xp1lSZ?=
 =?us-ascii?Q?IeW+Rg4Zl/utH2/uoE7CEBjnDA8rd/6+skPaQ7PzSK3KyCPA8SE66CRp0WbQ?=
 =?us-ascii?Q?URr8rpOoNTGgcOKrGrlWhvfzj26W/K6DneDlBQlhjJGcsk7pNWhpGlbdD1qc?=
 =?us-ascii?Q?AdWHH3yR1OdXovfTtxOD+p0h7b5BbPheCrqRe1UCHYBNTwyAxrf/6fZSDMvD?=
 =?us-ascii?Q?lsD+Z3lYxn/+FTvnZf0mbR6lRcfcl1aRRV81B2NRvTaxBMxCgKjbtPlvNnu/?=
 =?us-ascii?Q?5JuyGbS9zYc73J0p2vMN4cV8FoY5jBqk+YazPj7odDVSBgxEf6N8/S5/OCgd?=
 =?us-ascii?Q?DEKFjAUsf+WOPztC5z2jsDGUS66Hp63t8JxnyOVZ4TZWMijcfVpukYNDqdOi?=
 =?us-ascii?Q?GZyqrwiphDP7nuZynS0imkhQXe86NIQp3f8r0yhlf5COEW4WNVvTMlsUDPWl?=
 =?us-ascii?Q?VRq9qFAU1ZFpHJXG1MOsIQztnM5eqz8A+XMqN+JqSOEq3qgQ2zVgD7yEMtFo?=
 =?us-ascii?Q?TnjV8Il9p9QFznw6Skoj5zWcv+E0lmmaoyjZiM7yNsru3yqBAHgNqgg/aFXS?=
 =?us-ascii?Q?Ful4gukYscKgqCQO6dK2nhF29kNv/wG6fhLs60l2RIKpv+vdaAQaXbwoY3Bs?=
 =?us-ascii?Q?MQcshEIrhOkR1YOXbaCChenamMx1dwXP6Kz9AnoBG2XskwAqeXh/x/QCQQT/?=
 =?us-ascii?Q?Vpdfd2YcowzGBsjJrs5y8hbu5ITvx/GjbsNMTsn+LNfjOx/X48bn49uR/Mu8?=
 =?us-ascii?Q?qzUTC75KnekPPUHtQiX/mqy3PDD0tSn65TIJpYFOjMoB6TA1aZqWfoD1eNqt?=
 =?us-ascii?Q?Ok6VUTvgGT7teNgfbg8s1/wjx8FC95PBctQWaoVsaVSAvzIuk9+836R2gEma?=
 =?us-ascii?Q?Ic3RG8px1la2Mq72V7A9aFU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3256.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae64611f-ff13-4907-ec31-08d9a45c3cad
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2021 15:10:31.0224
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9SJpaWewptQ8Ys4zwOknZbI5zf/Jnx0fBa+JiIn9OHmltoYIPydNLtnj7nTqY7Kx8KifOEYHCj4Q2nJwl+VeeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4815
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha,
Can you re-do this patch in native ACPICA format, then add a pull request t=
o our github?

Thanks,
Bob


-----Original Message-----
From: Sasha Levin <sashal@kernel.org>=20
Sent: Monday, November 08, 2021 5:09 PM
To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
Cc: Wysocki, Rafael J <rafael.j.wysocki@intel.com>; Reik Keutterling <spiel=
kind@gmail.com>; Sasha Levin <sashal@kernel.org>; Moore, Robert <robert.moo=
re@intel.com>; linux-acpi@vger.kernel.org; devel@acpica.org
Subject: [PATCH AUTOSEL 4.4 15/30] ACPICA: Avoid evaluating methods too ear=
ly during system resume

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit d3c4b6f64ad356c0d9ddbcf73fa471e6a841cc5c ]

ACPICA commit 0762982923f95eb652cf7ded27356b247c9774de

During wakeup from system-wide sleep states, acpi_get_sleep_type_data() is =
called and it tries to get memory from the slab allocator in order to evalu=
ate a control method, but if KFENCE is enabled in the kernel, the memory al=
location attempt causes an IRQ work to be queued and a self-IPI to be sent =
to the CPU running the code which requires the memory controller to be read=
y, so if that happens too early in the wakeup path, it doesn't work.

Prevent that from taking place by calling acpi_get_sleep_type_data() for S0=
 upfront, when preparing to enter a given sleep state, and saving the data =
obtained by it for later use during system wakeup.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=3D214271
Reported-by: Reik Keutterling <spielkind@gmail.com>
Tested-by: Reik Keutterling <spielkind@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/acglobal.h  |  2 ++  drivers/acpi/acpica/hwesleep.c  |=
  8 ++------
 drivers/acpi/acpica/hwsleep.c   | 11 ++++-------
 drivers/acpi/acpica/hwxfsleep.c |  7 +++++++
 4 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.=
h index faa97604d878e..f178d11597c09 100644
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -256,6 +256,8 @@ extern struct acpi_bit_register_info
=20
 ACPI_GLOBAL(u8, acpi_gbl_sleep_type_a);  ACPI_GLOBAL(u8, acpi_gbl_sleep_ty=
pe_b);
+ACPI_GLOBAL(u8, acpi_gbl_sleep_type_a_s0); ACPI_GLOBAL(u8,=20
+acpi_gbl_sleep_type_b_s0);
=20
 /*************************************************************************=
****
  *
diff --git a/drivers/acpi/acpica/hwesleep.c b/drivers/acpi/acpica/hwesleep.=
c index e5599f6108083..e4998cc0ce283 100644
--- a/drivers/acpi/acpica/hwesleep.c
+++ b/drivers/acpi/acpica/hwesleep.c
@@ -184,17 +184,13 @@ acpi_status acpi_hw_extended_sleep(u8 sleep_state)
=20
 acpi_status acpi_hw_extended_wake_prep(u8 sleep_state)  {
-	acpi_status status;
 	u8 sleep_type_value;
=20
 	ACPI_FUNCTION_TRACE(hw_extended_wake_prep);
=20
-	status =3D acpi_get_sleep_type_data(ACPI_STATE_S0,
-					  &acpi_gbl_sleep_type_a,
-					  &acpi_gbl_sleep_type_b);
-	if (ACPI_SUCCESS(status)) {
+	if (acpi_gbl_sleep_type_a_s0 !=3D ACPI_SLEEP_TYPE_INVALID) {
 		sleep_type_value =3D
-		    ((acpi_gbl_sleep_type_a << ACPI_X_SLEEP_TYPE_POSITION) &
+		    ((acpi_gbl_sleep_type_a_s0 << ACPI_X_SLEEP_TYPE_POSITION) &
 		     ACPI_X_SLEEP_TYPE_MASK);
=20
 		(void)acpi_write((u64)(sleep_type_value | ACPI_X_SLEEP_ENABLE), diff --g=
it a/drivers/acpi/acpica/hwsleep.c b/drivers/acpi/acpica/hwsleep.c index 7d=
21cae6d6028..7e44ba8c6a1ab 100644
--- a/drivers/acpi/acpica/hwsleep.c
+++ b/drivers/acpi/acpica/hwsleep.c
@@ -217,7 +217,7 @@ acpi_status acpi_hw_legacy_sleep(u8 sleep_state)
=20
 acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state)  {
-	acpi_status status;
+	acpi_status status =3D AE_OK;
 	struct acpi_bit_register_info *sleep_type_reg_info;
 	struct acpi_bit_register_info *sleep_enable_reg_info;
 	u32 pm1a_control;
@@ -230,10 +230,7 @@ acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state)
 	 * This is unclear from the ACPI Spec, but it is required
 	 * by some machines.
 	 */
-	status =3D acpi_get_sleep_type_data(ACPI_STATE_S0,
-					  &acpi_gbl_sleep_type_a,
-					  &acpi_gbl_sleep_type_b);
-	if (ACPI_SUCCESS(status)) {
+	if (acpi_gbl_sleep_type_a_s0 !=3D ACPI_SLEEP_TYPE_INVALID) {
 		sleep_type_reg_info =3D
 		    acpi_hw_get_bit_register_info(ACPI_BITREG_SLEEP_TYPE);
 		sleep_enable_reg_info =3D
@@ -254,9 +251,9 @@ acpi_status acpi_hw_legacy_wake_prep(u8 sleep_state)
=20
 			/* Insert the SLP_TYP bits */
=20
-			pm1a_control |=3D (acpi_gbl_sleep_type_a <<
+			pm1a_control |=3D (acpi_gbl_sleep_type_a_s0 <<
 					 sleep_type_reg_info->bit_position);
-			pm1b_control |=3D (acpi_gbl_sleep_type_b <<
+			pm1b_control |=3D (acpi_gbl_sleep_type_b_s0 <<
 					 sleep_type_reg_info->bit_position);
=20
 			/* Write the control registers and ignore any errors */ diff --git a/dr=
ivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c index d62a6=
1612b3f1..b04e2b0f62246 100644
--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -372,6 +372,13 @@ acpi_status acpi_enter_sleep_state_prep(u8 sleep_state=
)
 		return_ACPI_STATUS(status);
 	}
=20
+	status =3D acpi_get_sleep_type_data(ACPI_STATE_S0,
+					  &acpi_gbl_sleep_type_a_s0,
+					  &acpi_gbl_sleep_type_b_s0);
+	if (ACPI_FAILURE(status)) {
+		acpi_gbl_sleep_type_a_s0 =3D ACPI_SLEEP_TYPE_INVALID;
+	}
+
 	/* Execute the _PTS method (Prepare To Sleep) */
=20
 	arg_list.count =3D 1;
--
2.33.0

