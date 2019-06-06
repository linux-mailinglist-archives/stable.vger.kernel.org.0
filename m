Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDBE0381F5
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 01:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfFFXva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 19:51:30 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:46508 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfFFXva (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 19:51:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:Subject:To:From:
        Sender:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7WA/zDWtu83SwSKbuJmqelAzChMPjRBeh/fIYxmCchM=; b=gIB37IG18ETCEYsTQK6jcKfQn
        MJUFaR2JUw5wvXeKWItfJtVSYJSrUcsfUFkXsUum8ROCH1hWo76iOz5TgkiNEwPpSmSTgx0fDNXS8
        fu/JtEiTMakMAtkgjuGKTWB/RFedl1Zo7gzVSHHNlkpq+VyW48zHv9/buH8DgX5v6tLmM=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=optimist)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hZ2AK-0007xQ-AE; Thu, 06 Jun 2019 23:51:28 +0000
Received: from broonie by optimist with local (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hZ2AJ-0006KS-Gv; Fri, 07 Jun 2019 00:51:27 +0100
From:   Build bot for Mark Brown <broonie@kernel.org>
To:     kernel-build-reports@lists.linaro.org,
        linaro-kernel@lists.linaro.org, stable@vger.kernel.org
Subject: v5.1.7 build: 5 failures 10 warnings (v5.1.7)
Message-Id: <E1hZ2AJ-0006KS-Gv@optimist>
Date:   Fri, 07 Jun 2019 00:51:27 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tree/Branch: v5.1.7
Git describe: v5.1.7
Commit: 2f7d9d4757 Linux 5.1.7

Build Time: 262 min 15 sec

Passed:    6 / 11   ( 54.55 %)
Failed:    5 / 11   ( 45.45 %)

Errors: 0
Warnings: 10
Section Mismatches: 0

Failed defconfigs:
	arm-multi_v5_defconfig
	arm-multi_v7_defconfig
	arm-allmodconfig
	arm-multi_v4t_defconfig

Errors:

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
arm-multi_v5_defconfig : FAIL, 0 errors, 5 warnings, 0 section mismatches

Warnings:
	../arch/arm/mm/init.c:471:13: warning: unused variable 'itcm_end' [-Wunused-variable]
	../arch/arm/mm/init.c:470:13: warning: unused variable 'dtcm_end' [-Wunused-variable]
	../drivers/regulator/core.c:234:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:234:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:4761:38: warning: array subscript is above array bounds [-Warray-bounds]

-------------------------------------------------------------------------------
arm-multi_v7_defconfig : FAIL, 0 errors, 5 warnings, 0 section mismatches

Warnings:
	../drivers/i2c/busses/i2c-sh_mobile.c:399:26: warning: 'data' may be used uninitialized in this function [-Wmaybe-uninitialized]
	../drivers/regulator/core.c:234:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:234:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:4761:38: warning: array subscript is above array bounds [-Warray-bounds]
	../include/linux/spinlock.h:279:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]

-------------------------------------------------------------------------------
arm-allmodconfig : FAIL, 0 errors, 9 warnings, 0 section mismatches

Warnings:
	../arch/arm/mm/init.c:471:13: warning: unused variable 'itcm_end' [-Wunused-variable]
	../arch/arm/mm/init.c:470:13: warning: unused variable 'dtcm_end' [-Wunused-variable]
	../drivers/i2c/busses/i2c-sh_mobile.c:399:26: warning: 'data' may be used uninitialized in this function [-Wmaybe-uninitialized]
	../drivers/regulator/core.c:234:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:234:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:4761:38: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/staging/erofs/unzip_vle.c:263:29: warning: array subscript is above array bounds [-Warray-bounds]
	../include/linux/spinlock.h:279:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]
	../drivers/scsi/myrs.c:821:24: warning: 'sshdr.sense_key' may be used uninitialized in this function [-Wmaybe-uninitialized]

-------------------------------------------------------------------------------
arm-multi_v4t_defconfig : FAIL, 0 errors, 5 warnings, 0 section mismatches

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
close failed in file object destructor:
sys.excepthook is missing
lost sys.stderr
