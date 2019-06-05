Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C39E6356EE
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 08:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfFEGXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 02:23:04 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:46846 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfFEGXE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 02:23:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:Subject:To:From:
        Sender:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=04oBsmDc9bjsmWwPn0eZajuumazeGInbcwxnhttUUrc=; b=mrEYVMOuKYUglB+0Ik3CPva1t
        cqTBU3CTXacmucvylmjdIveIsNL55tbf6J0JdqirRb8iaPfxDl8LjsvnvW303J5xFVxUNXOqGxsVf
        4Wu0m2oHVbPUYrSlG4wdFNnHmblNhsTFZMQLdx9xg+tikkdIR21BrFIuEm1eOWEMsBmIs=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=optimist)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hYPK6-0007uF-Kh; Wed, 05 Jun 2019 06:22:58 +0000
Received: from broonie by optimist with local (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hYPK5-000226-JP; Wed, 05 Jun 2019 07:22:57 +0100
From:   Build bot for Mark Brown <broonie@kernel.org>
To:     kernel-build-reports@lists.linaro.org,
        linaro-kernel@lists.linaro.org, stable@vger.kernel.org
Subject: v4.19.48 build: 8 failures 3 warnings (v4.19.48)
Message-Id: <E1hYPK5-000226-JP@optimist>
Date:   Wed, 05 Jun 2019 07:22:57 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tree/Branch: v4.19.48
Git describe: v4.19.48
Commit: e109a984cf Linux 4.19.48

Build Time: 2 min 9 sec

Passed:    3 / 11   ( 27.27 %)
Failed:    8 / 11   ( 72.73 %)

Errors: 10
Warnings: 3
Section Mismatches: 0

Failed defconfigs:
	arm64-allnoconfig
	arm64-allmodconfig
	arm-multi_v7_defconfig
	arm-allmodconfig
	arm64-defconfig

Errors:

	arm64-allnoconfig
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:31:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:36:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:41:31: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?

	arm64-allmodconfig
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:31:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:36:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:41:31: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?

	arm64-defconfig
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:31:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:36:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:41:31: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?

-------------------------------------------------------------------------------
defconfigs with issues (other than build errors):
      1 warnings    0 mismatches  : arm64-allnoconfig
      1 warnings    0 mismatches  : arm64-allmodconfig
      1 warnings    0 mismatches  : arm-multi_v7_defconfig
      2 warnings    0 mismatches  : arm-allmodconfig
      1 warnings    0 mismatches  : x86_64-allmodconfig
      1 warnings    0 mismatches  : arm64-defconfig

-------------------------------------------------------------------------------

Errors summary: 10
	 15 ../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	 15 ../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	 15 ../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	 12 ../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	 12 ../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	 12 ../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	 12 ../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	  3 ../arch/arm64/include/asm/preempt.h:41:31: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	  3 ../arch/arm64/include/asm/preempt.h:36:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	  3 ../arch/arm64/include/asm/preempt.h:31:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?

Warnings Summary: 3
	  3 ../include/linux/spinlock.h:279:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]
	  3 ../arch/arm64/include/asm/preempt.h:7:0: warning: "PREEMPT_NEED_RESCHED" redefined
	  1 ../drivers/staging/erofs/unzip_vle.c:198:29: warning: array subscript is above array bounds [-Warray-bounds]



===============================================================================
Detailed per-defconfig build reports below:


-------------------------------------------------------------------------------
arm64-allnoconfig : FAIL, 34 errors, 1 warnings, 0 section mismatches

Errors:
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:31:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:36:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:41:31: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?

Warnings:
	../arch/arm64/include/asm/preempt.h:7:0: warning: "PREEMPT_NEED_RESCHED" redefined

-------------------------------------------------------------------------------
arm64-allmodconfig : FAIL, 34 errors, 1 warnings, 0 section mismatches

Errors:
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:31:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:36:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:41:31: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?

Warnings:
	../arch/arm64/include/asm/preempt.h:7:0: warning: "PREEMPT_NEED_RESCHED" redefined

-------------------------------------------------------------------------------
arm-multi_v7_defconfig : FAIL, 0 errors, 1 warnings, 0 section mismatches

Warnings:
	../include/linux/spinlock.h:279:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]

-------------------------------------------------------------------------------
arm-allmodconfig : FAIL, 0 errors, 2 warnings, 0 section mismatches

Warnings:
	../drivers/staging/erofs/unzip_vle.c:198:29: warning: array subscript is above array bounds [-Warray-bounds]
	../include/linux/spinlock.h:279:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]

-------------------------------------------------------------------------------
x86_64-allmodconfig : PASS, 0 errors, 1 warnings, 0 section mismatches

Warnings:
	../include/linux/spinlock.h:279:3: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]

-------------------------------------------------------------------------------
arm64-defconfig : FAIL, 34 errors, 1 warnings, 0 section mismatches

Errors:
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:12:40: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:18:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:31:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:36:23: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:41:31: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:46:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:48:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:53:42: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:55:34: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?
	../arch/arm64/include/asm/preempt.h:64:15: error: 'struct thread_info' has no member named 'preempt'; did you mean 'preempt_count'?

Warnings:
	../arch/arm64/include/asm/preempt.h:7:0: warning: "PREEMPT_NEED_RESCHED" redefined
-------------------------------------------------------------------------------

Passed with no errors, warnings or mismatches:

x86_64-allnoconfig
arm-multi_v4t_defconfig
arm-allnoconfig
arm-multi_v5_defconfig
x86_64-defconfig
