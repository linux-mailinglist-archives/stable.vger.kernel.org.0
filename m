Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B50004744D
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 13:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbfFPLDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jun 2019 07:03:15 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:43944 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfFPLDP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jun 2019 07:03:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:Subject:To:From:
        Sender:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xNFAhUR8C6jSLoxmM0Zg/060Hhe5jBwAjxjNvqrSiUc=; b=g29zpUf0ZXVF18GrgP3pBXhYb
        5oVkW5WKAX12ydOEfl0CmMqNwpdGtCJeJACSG0TIwzDapJ1oA0xsj8zxV3M036KRWSZjdG0Ql3+f4
        6YfwCuQh07fxRbXWiWqYWMYzNcgT8aDyMKKdtadCS06ft4B4oBXAbPu2b/si3gw6tVVMg=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=optimist)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hcSwJ-0007AC-TZ; Sun, 16 Jun 2019 11:03:11 +0000
Received: from broonie by optimist with local (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hcSwJ-0006KF-6L; Sun, 16 Jun 2019 12:03:11 +0100
From:   Build bot for Mark Brown <broonie@kernel.org>
To:     kernel-build-reports@lists.linaro.org,
        linaro-kernel@lists.linaro.org, stable@vger.kernel.org
Subject: v5.1.10 build: 0 failures 10 warnings (v5.1.10)
Message-Id: <E1hcSwJ-0006KF-6L@optimist>
Date:   Sun, 16 Jun 2019 12:03:11 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tree/Branch: v5.1.10
Git describe: v5.1.10
Commit: 7e1bdd68ff Linux 5.1.10

Build Time: 135 min 21 sec

Passed:   11 / 11   (100.00 %)
Failed:    0 / 11   (  0.00 %)

Errors: 0
Warnings: 10
Section Mismatches: 0

-------------------------------------------------------------------------------
defconfigs with issues (other than build errors):
      1 warnings    0 mismatches  : arm64-allmodconfig
      5 warnings    0 mismatches  : arm-multi_v5_defconfig
      5 warnings    0 mismatches  : arm-multi_v7_defconfig
      9 warnings    0 mismatches  : arm-allmodconfig
      5 warnings    0 mismatches  : arm-multi_v4t_defconfig
      3 warnings    0 mismatches  : x86_64-allmodconfig
      1 warnings    0 mismatches  : arm64-defconfig

-------------------------------------------------------------------------------

Warnings Summary: 10
	  8 ../drivers/regulator/core.c:234:45: warning: array subscript is above array bounds [-Warray-bounds]
	  5 ../include/linux/spinlock.h:279:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]
	  4 ../drivers/regulator/core.c:4761:38: warning: array subscript is above array bounds [-Warray-bounds]
	  3 ../arch/arm/mm/init.c:471:13: warning: unused variable 'itcm_end' [-Wunused-variable]
	  3 ../arch/arm/mm/init.c:470:13: warning: unused variable 'dtcm_end' [-Wunused-variable]
	  2 ../drivers/i2c/busses/i2c-sh_mobile.c:399:26: warning: 'data' may be used uninitialized in this function [-Wmaybe-uninitialized]
	  1 ../samples/seccomp/user-trap.c:83:2: warning: dereferencing type-punned pointer will break strict-aliasing rules [-Wstrict-aliasing]
	  1 ../samples/seccomp/user-trap.c:50:2: warning: dereferencing type-punned pointer will break strict-aliasing rules [-Wstrict-aliasing]
	  1 ../drivers/staging/erofs/unzip_vle.c:263:29: warning: array subscript is above array bounds [-Warray-bounds]
	  1 ../drivers/scsi/myrs.c:821:24: warning: 'sshdr.sense_key' may be used uninitialized in this function [-Wmaybe-uninitialized]



===============================================================================
Detailed per-defconfig build reports below:


-------------------------------------------------------------------------------
arm64-allmodconfig : PASS, 0 errors, 1 warnings, 0 section mismatches

Warnings:
	../include/linux/spinlock.h:279:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]

-------------------------------------------------------------------------------
arm-multi_v5_defconfig : PASS, 0 errors, 5 warnings, 0 section mismatches

Warnings:
	../arch/arm/mm/init.c:471:13: warning: unused variable 'itcm_end' [-Wunused-variable]
	../arch/arm/mm/init.c:470:13: warning: unused variable 'dtcm_end' [-Wunused-variable]
	../drivers/regulator/core.c:234:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:234:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:4761:38: warning: array subscript is above array bounds [-Warray-bounds]

-------------------------------------------------------------------------------
arm-multi_v7_defconfig : PASS, 0 errors, 5 warnings, 0 section mismatches

Warnings:
	../drivers/i2c/busses/i2c-sh_mobile.c:399:26: warning: 'data' may be used uninitialized in this function [-Wmaybe-uninitialized]
	../drivers/regulator/core.c:234:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:234:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:4761:38: warning: array subscript is above array bounds [-Warray-bounds]
	../include/linux/spinlock.h:279:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]

-------------------------------------------------------------------------------
arm-allmodconfig : PASS, 0 errors, 9 warnings, 0 section mismatches

Warnings:
	../arch/arm/mm/init.c:471:13: warning: unused variable 'itcm_end' [-Wunused-variable]
	../arch/arm/mm/init.c:470:13: warning: unused variable 'dtcm_end' [-Wunused-variable]
	../drivers/i2c/busses/i2c-sh_mobile.c:399:26: warning: 'data' may be used uninitialized in this function [-Wmaybe-uninitialized]
	../drivers/regulator/core.c:234:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:234:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:4761:38: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/scsi/myrs.c:821:24: warning: 'sshdr.sense_key' may be used uninitialized in this function [-Wmaybe-uninitialized]
	../drivers/staging/erofs/unzip_vle.c:263:29: warning: array subscript is above array bounds [-Warray-bounds]
	../include/linux/spinlock.h:279:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]

-------------------------------------------------------------------------------
arm-multi_v4t_defconfig : PASS, 0 errors, 5 warnings, 0 section mismatches

Warnings:
	../arch/arm/mm/init.c:471:13: warning: unused variable 'itcm_end' [-Wunused-variable]
	../arch/arm/mm/init.c:470:13: warning: unused variable 'dtcm_end' [-Wunused-variable]
	../drivers/regulator/core.c:234:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:234:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:4761:38: warning: array subscript is above array bounds [-Warray-bounds]

-------------------------------------------------------------------------------
x86_64-allmodconfig : PASS, 0 errors, 3 warnings, 0 section mismatches

Warnings:
	../samples/seccomp/user-trap.c:50:2: warning: dereferencing type-punned pointer will break strict-aliasing rules [-Wstrict-aliasing]
	../samples/seccomp/user-trap.c:83:2: warning: dereferencing type-punned pointer will break strict-aliasing rules [-Wstrict-aliasing]
	../include/linux/spinlock.h:279:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]

-------------------------------------------------------------------------------
arm64-defconfig : PASS, 0 errors, 1 warnings, 0 section mismatches

Warnings:
	../include/linux/spinlock.h:279:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]
-------------------------------------------------------------------------------

Passed with no errors, warnings or mismatches:

x86_64-allnoconfig
arm64-allnoconfig
arm-allnoconfig
x86_64-defconfig
