Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6591B6D605
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 22:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbfGRUvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 16:51:49 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:51468 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727687AbfGRUvt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 16:51:49 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 68FB3C0A75;
        Thu, 18 Jul 2019 20:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563483108; bh=n6uWkuvjhu3Hdf5gkmZc44j9tCtYMS9DvhGOul33ooY=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Brw0uk9VeypXYpplEYUJCMKNXUfzNlcN8sHAINMh230juNe5fG+e/KdggCPmCNg2g
         HnGv0KFyJ5lUasAFASD8DWlka8pjDjOObQS1KDQeQQeG4Nc46luyH7KXgPEWsAhxOQ
         gKKb+TV9Nm6LVGEwJJNjO31ZKgLhUrYokqPeop4lpu99RWvrOLTYGAhNqJV1ZtMjVf
         XB4zxg+Jacb3r+VQiP0Nk/eCtqUmn+iojYWA3NADinwi1D/HTUUxkLXbVK3YRMYX4A
         eT378AMmQue8DzT3JvhvdKe9sg/LW4XbSK2/vz5YXc3TLS4pMdPVbOUYpd9W8i5psu
         SjZTPk+7ZZgUQ==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 2FDD0A009A;
        Thu, 18 Jul 2019 20:51:42 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 18 Jul 2019 13:51:26 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 18 Jul 2019 13:51:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9Tin9B7imO1x67LyU3FGnJprhIkaxQIuSaZAxsPxQbq6Oy9SDW4TfD20Yvk9N1EkDppkD43DvtFiJLbLhy8yXdTIBNNSmMSNRlpzj0gzMWqtTQ/cjfkjdErNsIBnuaMIOVKRZT7H/UUuUgrFVCEXf7s4JTIriXLP78ToijbYFpcTTZuKNTbUev/leUC30P+XEk2Zw5Nvxi4TWSMgbtZpkPiqjHURVyzxye30Jkg4uCI+wdioaskqAlsOd4wp1Yhwh7WmgDXmr1bOut4q4KsG1Z6vBsQZOt9BclfOSfg7Jh7Rey75eQ+wnrbMz8A1BxZj6TBGWLWOGdGzuFpcbsVAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLbsui8LwC4H3ZPZbAfPK7eKWOlQwvA8/Zx/7ZMRxQU=;
 b=W5cQd14YIIKhhMg2hBRWx1im1FvX855SPBDOmBtoBoYn78M9h7uvR708a+kkCsSbIKIuyUyqCceQsbYGk9XE/ybNlk94v1bZXFyfv/MmC6bU/nWqCLWyk3grHC6F87fnbGiiMFzAKrjInnSCFlAE6swTgnEus/Yi/BmGbl2QOrmNGnvLRr4UsuzhNJAtrd8RDpHnVyytILM8pd2Q4o55TKMrLBScGxKnq21xTiEV8W+//SL3zVSMN3ukNwsmTVpfyVG3fFTff6MeJ/gsCgcjajVBugnYa5fsDEyMEbGO9qfmjyF13cOM8SVa2QOO/XQxkQ2Gsf31wNePg2YegcyEBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLbsui8LwC4H3ZPZbAfPK7eKWOlQwvA8/Zx/7ZMRxQU=;
 b=cDdNWV81+AHIL+fNaM56meNzXfWqO6leNHdjK5HhaUMgJrM+WZly8tBb4vCfyynzG3csQezwiCBHNSsp41tB7Y99za1hZ6xIiEX93BtgpVDk28laWHUnWeFcgpw8PvB27qn/soEI2ZKl8UXrTVT6AF/5mKCP1n5hPZ7m9KdsslE=
Received: from CY4PR1201MB0120.namprd12.prod.outlook.com (10.172.78.14) by
 CY4SPR00MB2380.namprd12.prod.outlook.com (10.173.43.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Thu, 18 Jul 2019 20:51:23 +0000
Received: from CY4PR1201MB0120.namprd12.prod.outlook.com
 ([fe80::1c8d:9b3c:7538:477b]) by CY4PR1201MB0120.namprd12.prod.outlook.com
 ([fe80::1c8d:9b3c:7538:477b%4]) with mapi id 15.20.2094.011; Thu, 18 Jul 2019
 20:51:23 +0000
From:   Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To:     linux-stable <stable@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Corentin Labbe" <clabbe@baylibre.com>,
        "khilman@baylibre.com" <khilman@baylibre.com>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: RE: [PATCH v2 2/2] ARC: enable uboot support unconditionally
Thread-Topic: [PATCH v2 2/2] ARC: enable uboot support unconditionally
Thread-Index: AQHUxHcRQQpuVpv4ikGdBs8+CyKThqbRyW7g
Date:   Thu, 18 Jul 2019 20:51:23 +0000
Message-ID: <CY4PR1201MB0120530B12273DDC5B06D823A1C80@CY4PR1201MB0120.namprd12.prod.outlook.com>
References: <20190214150745.18773-1-Eugeniy.Paltsev@synopsys.com>
 <20190214150745.18773-3-Eugeniy.Paltsev@synopsys.com>
In-Reply-To: <20190214150745.18773-3-Eugeniy.Paltsev@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=abrodkin@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a9014e51-f4a1-4452-c3b5-08d70bc1b1c9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CY4SPR00MB2380;
x-ms-traffictypediagnostic: CY4SPR00MB2380:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <CY4SPR00MB2380071444F2C6067F202264A1C80@CY4SPR00MB2380.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 01026E1310
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(39860400002)(396003)(136003)(376002)(13464003)(199004)(189003)(7736002)(6246003)(6306002)(81156014)(55016002)(81166006)(9686003)(66066001)(74316002)(71200400001)(14444005)(53936002)(486006)(54906003)(5660300002)(478600001)(99286004)(3846002)(2906002)(102836004)(305945005)(53546011)(6506007)(33656002)(14454004)(7696005)(11346002)(8936002)(25786009)(66476007)(6116002)(76176011)(966005)(68736007)(66946007)(52536014)(256004)(86362001)(446003)(186003)(316002)(229853002)(4326008)(6916009)(8676002)(476003)(66556008)(71190400001)(64756008)(66446008)(107886003)(26005)(76116006)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4SPR00MB2380;H:CY4PR1201MB0120.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HS1371qlQJ1bZ9Bc5KB8v1l0fcMynZ99CZKV6PKmIU9jTjrXCRmcOPreu2c2s0awIhxIU7TZvcsuAwTmc/mUsGR7gIKh2uTdDVvsNooSvkZKSq+1ibKc/HPkk9JJ12raHsZphojn11WRiUgF7z85w+zAJQBZ5lCRHAtyoP8GyPYOHQ1N6sOy6lUPHFXR3LERjghryveoo5WTpwFqDTu3wYj1XQgdQ4WELIY/ZydprCfjnp5z68knuJxdqDm6ED+2UhMWb5qi5KTo7xzWFfpUBR1RU9d8yuw3Gb6DavegvqmAWmsVuJhAA6tYX5NWrh4fpgPgpeJpFD2Xw04Tv3gpR1Io/Kdbwn3Gt+5O8S3rbYXQYKtt/LWBYA/8yhq/tzQl5AoWmhdnhFLNB3bCen9rN1JbBj+4GhcqCgFbKnE/Bx4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a9014e51-f4a1-4452-c3b5-08d70bc1b1c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2019 20:51:23.2079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: abrodkin@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4SPR00MB2380
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

> -----Original Message-----
> From: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
> Sent: Thursday, February 14, 2019 6:08 PM
> To: linux-snps-arc@lists.infradead.org; Vineet Gupta <vgupta@synopsys.com=
>
> Cc: linux-kernel@vger.kernel.org; Alexey Brodkin <abrodkin@synopsys.com>;=
 Corentin Labbe
> <clabbe@baylibre.com>; khilman@baylibre.com; Eugeniy Paltsev <Eugeniy.Pal=
tsev@synopsys.com>
> Subject: [PATCH v2 2/2] ARC: enable uboot support unconditionally
>=20
> After reworking U-boot args handling code and adding paranoid
> arguments check we can eliminate CONFIG_ARC_UBOOT_SUPPORT and
> enable uboot support unconditionally.
>=20
> For JTAG case we can assume that core registers will come up
> reset value of 0 or in worst case we rely on user passing
> '-on=3Dclear_regs' to Metaware debugger.
>=20
> Signed-off-by: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>

May we have this one back-ported to linux-4.19.y?

It was initially applied to Linus' tree during 5.0 development
cycle [1] but was never back-ported.

Now w/o that patch in KernelCI we see boot failure on ARC HSDK
board [2] as opposed to normally working later kernel versions.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D493a2f812446e92bcb1e69a77381b4d39808d730
[2] https://storage.kernelci.org/stable/linux-4.19.y/v4.19.59/arc/hsdk_defc=
onfig/gcc-8/lab-baylibre/boot-hsdk.txt

Below is that same patch but rebased on linux-4.19 as in its pristine
form it won't apply due to offset of one of hunks.

-Alexey

------------------------------------>8--------------------------------
From 3e565355f6a2d1a82bc9ecd47a46d1fa3c0cd2c1 Mon Sep 17 00:00:00 2001
From: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
Date: Thu, 14 Feb 2019 18:07:45 +0300
Subject: [PATCH] ARC: enable uboot support unconditionally

After reworking U-boot args handling code and adding paranoid
arguments check we can eliminate CONFIG_ARC_UBOOT_SUPPORT and
enable uboot support unconditionally.

For JTAG case we can assume that core registers will come up
reset value of 0 or in worst case we rely on user passing
'-on=3Dclear_regs' to Metaware debugger.

Cc: stable@vger.kernel.org
Tested-by: Corentin LABBE <clabbe@baylibre.com>
Signed-off-by: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/Kconfig                        | 13 -------------
 arch/arc/configs/nps_defconfig          |  1 -
 arch/arc/configs/vdk_hs38_defconfig     |  1 -
 arch/arc/configs/vdk_hs38_smp_defconfig |  2 --
 arch/arc/kernel/head.S                  |  2 --
 arch/arc/kernel/setup.c                 |  2 --
 6 files changed, 21 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 85eb7fc2e241..97b45fe8f0c2 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -199,7 +199,6 @@ config NR_CPUS
=20
 config ARC_SMP_HALT_ON_RESET
 	bool "Enable Halt-on-reset boot mode"
-	default y if ARC_UBOOT_SUPPORT
 	help
 	  In SMP configuration cores can be configured as Halt-on-reset
 	  or they could all start at same time. For Halt-on-reset, non
@@ -538,18 +537,6 @@ config ARC_DBG_TLB_PARANOIA
=20
 endif
=20
-config ARC_UBOOT_SUPPORT
-	bool "Support uboot arg Handling"
-	default n
-	help
-	  ARC Linux by default checks for uboot provided args as pointers to
-	  external cmdline or DTB. This however breaks in absence of uboot,
-	  when booting from Metaware debugger directly, as the registers are
-	  not zeroed out on reset by mdb and/or ARCv2 based cores. The bogus
-	  registers look like uboot args to kernel which then chokes.
-	  So only enable the uboot arg checking/processing if users are sure
-	  of uboot being in play.
-
 config ARC_BUILTIN_DTB_NAME
 	string "Built in DTB"
 	help
diff --git a/arch/arc/configs/nps_defconfig b/arch/arc/configs/nps_defconfi=
g
index 6e84060e7c90..621f59407d76 100644
--- a/arch/arc/configs/nps_defconfig
+++ b/arch/arc/configs/nps_defconfig
@@ -31,7 +31,6 @@ CONFIG_ARC_CACHE_LINE_SHIFT=3D5
 # CONFIG_ARC_HAS_LLSC is not set
 CONFIG_ARC_KVADDR_SIZE=3D402
 CONFIG_ARC_EMUL_UNALIGNED=3Dy
-CONFIG_ARC_UBOOT_SUPPORT=3Dy
 CONFIG_PREEMPT=3Dy
 CONFIG_NET=3Dy
 CONFIG_UNIX=3Dy
diff --git a/arch/arc/configs/vdk_hs38_defconfig b/arch/arc/configs/vdk_hs3=
8_defconfig
index 1e59a2e9c602..e447ace6fa1c 100644
--- a/arch/arc/configs/vdk_hs38_defconfig
+++ b/arch/arc/configs/vdk_hs38_defconfig
@@ -13,7 +13,6 @@ CONFIG_PARTITION_ADVANCED=3Dy
 CONFIG_ARC_PLAT_AXS10X=3Dy
 CONFIG_AXS103=3Dy
 CONFIG_ISA_ARCV2=3Dy
-CONFIG_ARC_UBOOT_SUPPORT=3Dy
 CONFIG_ARC_BUILTIN_DTB_NAME=3D"vdk_hs38"
 CONFIG_PREEMPT=3Dy
 CONFIG_NET=3Dy
diff --git a/arch/arc/configs/vdk_hs38_smp_defconfig b/arch/arc/configs/vdk=
_hs38_smp_defconfig
index b5c3f6c54b03..c82cdb10aaf4 100644
--- a/arch/arc/configs/vdk_hs38_smp_defconfig
+++ b/arch/arc/configs/vdk_hs38_smp_defconfig
@@ -15,8 +15,6 @@ CONFIG_AXS103=3Dy
 CONFIG_ISA_ARCV2=3Dy
 CONFIG_SMP=3Dy
 # CONFIG_ARC_TIMERS_64BIT is not set
-# CONFIG_ARC_SMP_HALT_ON_RESET is not set
-CONFIG_ARC_UBOOT_SUPPORT=3Dy
 CONFIG_ARC_BUILTIN_DTB_NAME=3D"vdk_hs38_smp"
 CONFIG_PREEMPT=3Dy
 CONFIG_NET=3Dy
diff --git a/arch/arc/kernel/head.S b/arch/arc/kernel/head.S
index 208bf2c9e7b0..a72bbda2f7aa 100644
--- a/arch/arc/kernel/head.S
+++ b/arch/arc/kernel/head.S
@@ -100,7 +100,6 @@ ENTRY(stext)
 	st.ab   0, [r5, 4]
 1:
=20
-#ifdef CONFIG_ARC_UBOOT_SUPPORT
 	; Uboot - kernel ABI
 	;    r0 =3D [0] No uboot interaction, [1] cmdline in r2, [2] DTB in r2
 	;    r1 =3D magic number (always zero as of now)
@@ -109,7 +108,6 @@ ENTRY(stext)
 	st	r0, [@uboot_tag]
 	st      r1, [@uboot_magic]
 	st	r2, [@uboot_arg]
-#endif
=20
 	; setup "current" tsk and optionally cache it in dedicated r25
 	mov	r9, @init_task
diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
index a1218937abd6..89c97dcfa360 100644
--- a/arch/arc/kernel/setup.c
+++ b/arch/arc/kernel/setup.c
@@ -493,7 +493,6 @@ void __init handle_uboot_args(void)
 	bool use_embedded_dtb =3D true;
 	bool append_cmdline =3D false;
=20
-#ifdef CONFIG_ARC_UBOOT_SUPPORT
 	/* check that we know this tag */
 	if (uboot_tag !=3D UBOOT_TAG_NONE &&
 	    uboot_tag !=3D UBOOT_TAG_CMDLINE &&
@@ -525,7 +524,6 @@ void __init handle_uboot_args(void)
 		append_cmdline =3D true;
=20
 ignore_uboot_args:
-#endif
=20
 	if (use_embedded_dtb) {
 		machine_desc =3D setup_machine_fdt(__dtb_start);
--=20
2.16.2
