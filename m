Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A540314669A
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 12:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgAWLTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 06:19:32 -0500
Received: from mail-eopbgr70040.outbound.protection.outlook.com ([40.107.7.40]:29832
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729247AbgAWLT3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 06:19:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lHIX29rrRaHA/n8r5x1VpEfkI+mHhDjyq7/006mhugPIxBKh6+wD/TeNwrb6JqXRJU52Ck7yToasx2njSi0g+gXVdTovzNDwKV1iuKCupoRpxlVJ7W1uMHKByUXzVAVq4Pe7Jq+IQhCaOz0GLCrNhhcMVh74NZokQH6PlWMDkKeA7kHjkbZwfntu/Z/+mLV8cOt9Ei4CvepbU02kToMthWZnHTinAfIUV9GhS/QTfGp3xIozwHmKD3AM0Mw7W6KhYv9aiadnmtJErQ+p5XWJ5ttO5Om+TbnDhzhvmQ8yiTyYwjR03IB90UsPk5D1k2+SleEd1S7ytpXjNBY6NGPtvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hwYB92UaAiVD6zyggC3JbzvjtjnWo9noS1G5TkEtS/0=;
 b=lBW+e8HpVtpUAw+bcjRXctPe2pQnpF1bC+YXWwEt6n+wCM+nrUNs9YDdmwp/SmmG8jOWTfO/WRnwRMbQto8TgrkBy17A+PFG0v2FPN1LpsoEp2OC+XWfghkoq2VhPZPkJx3j2g1V4UC7O9G5Fn4sGEkvLSMidk8BWRbNCO7m5+GC14vvz+/3HbYh5Fsg9C1fa33W5Avhtz82YHXbF6u0X7ffx93xEu+CdpJu5m9UBacBVU5ewv00u04Fh9MrR3NOumeLkM3/mUGNVHj1OZSd6iGdQuchXZEtTmbyeDKY3Cn0cNfjQfdR1nX4GWlplUKJetK0q+kAHWgRUgNQxrUbwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hwYB92UaAiVD6zyggC3JbzvjtjnWo9noS1G5TkEtS/0=;
 b=V34+SC6nSITF/JgkTGU1ceDEps+6znMe5wTWTgAbG62qi4twzm6OM6x9m9xbKYzQHjpFTmHhIWymNZPwDliBZlV3wtWDotn63Hx5kYewN4XJxlQwmvH17HplnbGQ4VS+QRkppUS57tdWJIP2QrcetszRNmPiZ576+oOtFSLQe5k=
Received: from AM6PR04MB5878.eurprd04.prod.outlook.com (20.179.0.89) by
 AM6PR04MB4679.eurprd04.prod.outlook.com (20.177.37.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Thu, 23 Jan 2020 11:19:25 +0000
Received: from AM6PR04MB5878.eurprd04.prod.outlook.com
 ([fe80::bcef:1c59:7d27:d0e]) by AM6PR04MB5878.eurprd04.prod.outlook.com
 ([fe80::bcef:1c59:7d27:d0e%6]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 11:19:25 +0000
Received: from fsr-ub1864-101.ea.freescale.net (89.37.124.34) by LO2P265CA0090.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:8::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.9 via Frontend Transport; Thu, 23 Jan 2020 11:19:24 +0000
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
To:     "oss@buserror.net" <oss@buserror.net>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>
CC:     "christophe.leroy@c-s.fr" <christophe.leroy@c-s.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] powerpc/fsl_booke: avoid creating duplicate tlb1 entry
Thread-Topic: [PATCH] powerpc/fsl_booke: avoid creating duplicate tlb1 entry
Thread-Index: AQHV0d73S4yfrqtzL0CCUBQaf/Q2KQ==
Date:   Thu, 23 Jan 2020 11:19:25 +0000
Message-ID: <20200123111914.2565-1-laurentiu.tudor@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0090.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::30) To AM6PR04MB5878.eurprd04.prod.outlook.com
 (2603:10a6:20b:a2::25)
x-mailer: git-send-email 2.17.1
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=laurentiu.tudor@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [89.37.124.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 70323e96-e45a-431f-e780-08d79ff61a5f
x-ms-traffictypediagnostic: AM6PR04MB4679:|AM6PR04MB4679:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB4679D3B5EAE977ED13EFC48BEC0F0@AM6PR04MB4679.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(39860400002)(366004)(136003)(199004)(189003)(316002)(54906003)(110136005)(44832011)(2906002)(956004)(2616005)(36756003)(478600001)(86362001)(4326008)(71200400001)(52116002)(66446008)(186003)(64756008)(16526019)(66476007)(6512007)(5660300002)(66556008)(26005)(1076003)(66946007)(6486002)(81166006)(6506007)(81156014)(8936002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR04MB4679;H:AM6PR04MB5878.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CR30ktTEf03bz4WNRschwH6fzznIkCobofji8yai43nchkwRJ4W62idyeXkHIzYy3MF7a+GcVh3ylG64md25bk1u1T5yP1s8Vx76gLKEs8xQffR8wHJRuKQkYv7ZD9XbPLUyPeBEXdauMy4mGubMAwFAjTcY7d8GVUhmM1GAUE++G+qutwf7txd0jjmbsL9LJIvg77TvykYOdtA8pgN800CmKZRJ1omkBDO1XQBmgRcyeXH/GR8CD3uXTQkzCymCrwvwUfk4+/TJhI7ZUG1wRGu0+AkIRQo8TCAnOGmeVPt7NvCGCqMP3QeiK48grXnpW0a7GdVQus98fDpGtNlfgjnV/nbIXqhWmieQGS8eUH3OEMDsDMJ6MZtbx6d7Wd12OtcXQ3XpubVYk6WKlD0tuLkuaRQ7Jb9/TbHoUz5zqOs7yeu3Z/Gm4vTLIc/KTIQp
Content-Type: text/plain; charset="us-ascii"
Content-ID: <026E68B3014B5546B523C1E54921E0FA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70323e96-e45a-431f-e780-08d79ff61a5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 11:19:25.2326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nfV5qnKD9xFBGxoD+im9ObN1xMw1RjtePnlfrw99H1sywLEcwn8KRw5O0hq1CbmZHrJ0g561FfyuCdcalCMqRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4679
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the current implementation, the call to loadcam_multi() is wrapped
between switch_to_as1() and restore_to_as0() calls so, when it tries
to create its own temporary AS=3D1 TLB1 entry, it ends up duplicating the
existing one created by switch_to_as1(). Add a check to skip creating
the temporary entry if already running in AS=3D1.

Fixes: d9e1831a4202 ("powerpc/85xx: Load all early TLB entries at once")
Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Cc: stable@vger.kernel.org
---
 arch/powerpc/mm/nohash/tlb_low.S | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/nohash/tlb_low.S b/arch/powerpc/mm/nohash/tlb_=
low.S
index 2ca407cedbe7..eaeee402f96e 100644
--- a/arch/powerpc/mm/nohash/tlb_low.S
+++ b/arch/powerpc/mm/nohash/tlb_low.S
@@ -397,7 +397,7 @@ _GLOBAL(set_context)
  * extern void loadcam_entry(unsigned int index)
  *
  * Load TLBCAM[index] entry in to the L2 CAM MMU
- * Must preserve r7, r8, r9, and r10
+ * Must preserve r7, r8, r9, r10 and r11
  */
 _GLOBAL(loadcam_entry)
 	mflr	r5
@@ -433,6 +433,10 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_BIG_PHYS)
  */
 _GLOBAL(loadcam_multi)
 	mflr	r8
+	/* Don't switch to AS=3D1 if already there */
+	mfmsr	r11
+	andi.	r11,r11,MSR_IS
+	bne	10f
=20
 	/*
 	 * Set up temporary TLB entry that is the same as what we're
@@ -458,6 +462,7 @@ _GLOBAL(loadcam_multi)
 	mtmsr	r6
 	isync
=20
+10:
 	mr	r9,r3
 	add	r10,r3,r4
 2:	bl	loadcam_entry
@@ -466,6 +471,10 @@ _GLOBAL(loadcam_multi)
 	mr	r3,r9
 	blt	2b
=20
+	/* Don't return to AS=3D0 if we were in AS=3D1 at function start */
+	andi.	r11,r11,MSR_IS
+	bne	3f
+
 	/* Return to AS=3D0 and clear the temporary entry */
 	mfmsr	r6
 	rlwinm.	r6,r6,0,~(MSR_IS|MSR_DS)
@@ -481,6 +490,7 @@ _GLOBAL(loadcam_multi)
 	tlbwe
 	isync
=20
+3:
 	mtlr	r8
 	blr
 #endif
--=20
2.17.1

