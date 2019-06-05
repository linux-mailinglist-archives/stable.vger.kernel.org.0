Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B21A3682C
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 01:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfFEXkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 19:40:37 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:38804 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbfFEXkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 19:40:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:Subject:To:From:
        Sender:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bsSczBSFEfDqWg7fP9/1D75MgGf2v+NGPg/Sf5uQPCQ=; b=K+uc0eO8iKednOBVJ3ClFJocj
        Oc+4XCfLsKrAbN+ALZ2hZIzqeEtpn1lCOulqEkkK4rCwUkkoJ11mj7G6M0bvIMRtDVAEmh56TVfYg
        fzfMKWh5XEHxhEEbqiK9ZBfJ8wstLhYUpuIprnlz86njzHX9JFtOBfeGB4Pl/h9lUndgY=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=optimist)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hYfWF-00028z-8K; Wed, 05 Jun 2019 23:40:35 +0000
Received: from broonie by optimist with local (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hYfWE-0001LY-EU; Thu, 06 Jun 2019 00:40:34 +0100
From:   Build bot for Mark Brown <broonie@kernel.org>
To:     kernel-build-reports@lists.linaro.org,
        linaro-kernel@lists.linaro.org, stable@vger.kernel.org
Subject: v5.0.21 build: 5 failures 8 warnings (v5.0.21)
Message-Id: <E1hYfWE-0001LY-EU@optimist>
Date:   Thu, 06 Jun 2019 00:40:34 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tree/Branch: v5.0.21
Git describe: v5.0.21
Commit: fd1594eb70 Linux 5.0.21

Build Time: 261 min 35 sec

Passed:    6 / 11   ( 54.55 %)
Failed:    5 / 11   ( 45.45 %)

Errors: 0
Warnings: 8
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
      3 warnings    0 mismatches  : arm-multi_v5_defconfig
      4 warnings    0 mismatches  : arm-multi_v7_defconfig
      7 warnings    0 mismatches  : arm-allmodconfig
      3 warnings    0 mismatches  : arm-multi_v4t_defconfig
      3 warnings    0 mismatches  : x86_64-allmodconfig
      1 warnings    0 mismatches  : arm64-defconfig

-------------------------------------------------------------------------------

Warnings Summary: 8
	  8 ../drivers/regulator/core.c:244:45: warning: array subscript is above array bounds [-Warray-bounds]
	  5 ../include/linux/spinlock.h:279:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]
	  4 ../drivers/regulator/core.c:4798:38: warning: array subscript is above array bounds [-Warray-bounds]
	  1 ../samples/seccomp/user-trap.c:83:2: warning: dereferencing type-punned pointer will break strict-aliasing rules [-Wstrict-aliasing]
	  1 ../samples/seccomp/user-trap.c:50:2: warning: dereferencing type-punned pointer will break strict-aliasing rules [-Wstrict-aliasing]
	  1 ../drivers/staging/erofs/unzip_vle.c:268:29: warning: array subscript is above array bounds [-Warray-bounds]
	  1 ../drivers/scsi/myrs.c:821:24: warning: 'sshdr.sense_key' may be used uninitialized in this function [-Wmaybe-uninitialized]
	  1 ../drivers/net/ethernet/mellanox/mlx5/core/en_stats.c:221:1: warning: the frame size of 1096 bytes is larger than 1024 bytes [-Wframe-larger-than=]



===============================================================================
Detailed per-defconfig build reports below:


-------------------------------------------------------------------------------
arm64-allmodconfig : PASS, 0 errors, 1 warnings, 0 section mismatches

Warnings:
	../include/linux/spinlock.h:279:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]

-------------------------------------------------------------------------------
arm-multi_v5_defconfig : FAIL, 0 errors, 3 warnings, 0 section mismatches

Warnings:
	../drivers/regulator/core.c:244:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:244:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:4798:38: warning: array subscript is above array bounds [-Warray-bounds]

-------------------------------------------------------------------------------
arm-multi_v7_defconfig : FAIL, 0 errors, 4 warnings, 0 section mismatches

Warnings:
	../drivers/regulator/core.c:244:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:244:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:4798:38: warning: array subscript is above array bounds [-Warray-bounds]
	../include/linux/spinlock.h:279:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]

-------------------------------------------------------------------------------
arm-allmodconfig : FAIL, 0 errors, 7 warnings, 0 section mismatches

Warnings:
	../drivers/regulator/core.c:244:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:244:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:4798:38: warning: array subscript is above array bounds [-Warray-bounds]
	../include/linux/spinlock.h:279:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]
	../drivers/staging/erofs/unzip_vle.c:268:29: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/net/ethernet/mellanox/mlx5/core/en_stats.c:221:1: warning: the frame size of 1096 bytes is larger than 1024 bytes [-Wframe-larger-than=]
	../drivers/scsi/myrs.c:821:24: warning: 'sshdr.sense_key' may be used uninitialized in this function [-Wmaybe-uninitialized]

-------------------------------------------------------------------------------
arm-multi_v4t_defconfig : FAIL, 0 errors, 3 warnings, 0 section mismatches

Warnings:
	../drivers/regulator/core.c:244:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:244:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:4798:38: warning: array subscript is above array bounds [-Warray-bounds]

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
