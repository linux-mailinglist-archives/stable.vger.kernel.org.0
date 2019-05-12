Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 877AD1ACB0
	for <lists+stable@lfdr.de>; Sun, 12 May 2019 16:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfELOs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 May 2019 10:48:57 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:45776 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfELOs4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 May 2019 10:48:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:Subject:To:From:
        Sender:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IegFnEL5PGAX95hIOqsYH8OQfGpRhAgetJtPSBGU5XQ=; b=kQyAFySTaxdAquJkluRNy3gd5
        D7Nz0QoiPPi8vcjc9/IRSPJ0YdTrCvD449fSC/xuYTu3BCnezMPO7CCPE0o4hppVHQHOn9R7apCXh
        Jwwgsh9ADUAOasB3MK05JYL0LSj2kfhNWgRzSQf4V8KjhS2xFuiEvBoFONZQY0UTcHq9c=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=optimist)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hPpmY-0003kH-8s; Sun, 12 May 2019 14:48:54 +0000
Received: from broonie by optimist with local (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hPpmV-0005cG-Ku; Sun, 12 May 2019 15:48:51 +0100
From:   Build bot for Mark Brown <broonie@kernel.org>
To:     kernel-build-reports@lists.linaro.org,
        linaro-kernel@lists.linaro.org, stable@vger.kernel.org
Subject: v5.0.15 build: 0 failures 8 warnings (v5.0.15)
Message-Id: <E1hPpmV-0005cG-Ku@optimist>
Date:   Sun, 12 May 2019 15:48:51 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tree/Branch: v5.0.15
Git describe: v5.0.15
Commit: 7b13756d2c Linux 5.0.15

Build Time: 135 min 9 sec

Passed:   11 / 11   (100.00 %)
Failed:    0 / 11   (  0.00 %)

Errors: 0
Warnings: 8
Section Mismatches: 0

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
	  4 ../drivers/regulator/core.c:4801:38: warning: array subscript is above array bounds [-Warray-bounds]
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
arm-multi_v5_defconfig : PASS, 0 errors, 3 warnings, 0 section mismatches

Warnings:
	../drivers/regulator/core.c:244:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:244:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:4801:38: warning: array subscript is above array bounds [-Warray-bounds]

-------------------------------------------------------------------------------
arm-multi_v7_defconfig : PASS, 0 errors, 4 warnings, 0 section mismatches

Warnings:
	../drivers/regulator/core.c:244:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:244:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:4801:38: warning: array subscript is above array bounds [-Warray-bounds]
	../include/linux/spinlock.h:279:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]

-------------------------------------------------------------------------------
arm-allmodconfig : PASS, 0 errors, 7 warnings, 0 section mismatches

Warnings:
	../drivers/regulator/core.c:244:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:244:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:4801:38: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/staging/erofs/unzip_vle.c:268:29: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/scsi/myrs.c:821:24: warning: 'sshdr.sense_key' may be used uninitialized in this function [-Wmaybe-uninitialized]
	../include/linux/spinlock.h:279:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]
	../drivers/net/ethernet/mellanox/mlx5/core/en_stats.c:221:1: warning: the frame size of 1096 bytes is larger than 1024 bytes [-Wframe-larger-than=]

-------------------------------------------------------------------------------
arm-multi_v4t_defconfig : PASS, 0 errors, 3 warnings, 0 section mismatches

Warnings:
	../drivers/regulator/core.c:244:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:244:45: warning: array subscript is above array bounds [-Warray-bounds]
	../drivers/regulator/core.c:4801:38: warning: array subscript is above array bounds [-Warray-bounds]

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
