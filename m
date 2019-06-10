Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC943B0BB
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 10:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387753AbfFJI3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 04:29:49 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:41332 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387702AbfFJI3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 04:29:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:Subject:To:From:
        Sender:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=t5edaO4CsZ+Ar+2JDAMDir6vhKMlIzKVCg4h90UMhtA=; b=e1IFcLHEuknYxZ3zfd6PyEye1
        XQv4YFhfLeQCnhX5UR6aO56CJBU5FEgrbLCtX54OXzBi3j//FppGgEp8D7sdi/SonGoFmpE09Tczx
        48kW2nBB7hT/n2KOB/1TdWdKjvATDWPxeI09k2mnYXEjgVygaWfqiibhOOAT1qWBQc+Jw=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=optimist)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1haFgX-00053B-Ly; Mon, 10 Jun 2019 08:29:45 +0000
Received: from broonie by optimist with local (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1haFgW-0005KX-Ro; Mon, 10 Jun 2019 09:29:44 +0100
From:   Build bot for Mark Brown <broonie@kernel.org>
To:     kernel-build-reports@lists.linaro.org,
        linaro-kernel@lists.linaro.org, stable@vger.kernel.org
Subject: v5.1.8 build: 0 failures 10 warnings (v5.1.8)
Message-Id: <E1haFgW-0005KX-Ro@optimist>
Date:   Mon, 10 Jun 2019 09:29:44 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tree/Branch: v5.1.8
Git describe: v5.1.8
Commit: 937cc0cc22 Linux 5.1.8

Build Time: 135 min 24 sec

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
	../drivers/staging/erofs/unzip_vle.c:263:29: warning: array subscript is above array bounds [-Warray-bounds]
	../include/linux/spinlock.h:279:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]
	../drivers/scsi/myrs.c:821:24: warning: 'sshdr.sense_key' may be used uninitialized in this function [-Wmaybe-uninitialized]

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
