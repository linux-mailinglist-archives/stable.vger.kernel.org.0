Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD2E26E4AD
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 20:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgIQSy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 14:54:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728427AbgIQQU3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 12:20:29 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C71E820838;
        Thu, 17 Sep 2020 15:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600358012;
        bh=BtZuIOQ2AXfXh4G/ZSZrBBignVvcDNW/IeO3mEubLVc=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=bGA6ep5sAhnDwDjorYpJHVboSdmbjgryg4SFVYMHSKzCxyWqZywj3PhwlHNpacocB
         E9XYsPOfnTyVkMsFFQNyVRbW8BfxLpPcQeeO4QWqS3NG4iXMvajulz19QcHFrO3yzr
         BV+f7GPtFrNx+Md+VtdEZSvLQGAKFk+gliaw0Pok=
Date:   Thu, 17 Sep 2020 15:53:31 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Harald Freudenberger <freude@linux.ibm.com>
To:     linux390-list@tuxmaker.boeblingen.de.ibm.com
Cc:     Alexander.Egorenkov@ibm.com
Cc:     Stable <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] s390/pkey: fix paes selftest failure with paes and pkey static build
In-Reply-To: <20200915092153.5483-1-freude@linux.ibm.com>
References: <20200915092153.5483-1-freude@linux.ibm.com>
Message-Id: <20200917155331.C71E820838@mail.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.9, v5.4.65, v4.19.145, v4.14.198, v4.9.236, v4.4.236.

v5.8.9: Build OK!
v5.4.65: Build OK!
v4.19.145: Failed to apply! Possible dependencies:
    00fab2350e6b ("s390/zcrypt: multiple zcrypt device nodes support")
    0534bde7de19 ("s390/pkey: Define protected key blob format")
    183cb46954dd ("s390/pkey: pkey cleanup: narrow in-kernel API, fix some variable types")
    a45a5c7d36a5 ("s390/pkey: Introduce new API for random protected key generation")
    af504452d10e ("s390/pkey: Add sysfs attributes to emit secure key blobs")
    cb26b9ff7187 ("s390/pkey: Introduce new API for random protected key verification")
    d632c0478d64 ("s390/pkey: Add sysfs attributes to emit protected key blobs")
    ebb7c695d3bc ("pkey: Indicate old mkvp only if old and current mkvp are different")
    ee410de890cd ("s390/zcrypt: zcrypt device driver cleanup")
    efc598e6c8a9 ("s390/zcrypt: move cca misc functions to new code file")
    f2bbc96e7cfa ("s390/pkey: add CCA AES cipher key support")
    f822ad2c2c03 ("s390/pkey: move pckmo subfunction available checks away from module init")
    fb1136d6580c ("s390/pkey: Introduce new API for transforming key blobs")

v4.14.198: Failed to apply! Possible dependencies:
    01451ad47e27 ("powerpc/powermac: Use setup_timer() helper")
    0534bde7de19 ("s390/pkey: Define protected key blob format")
    2a80786d477a ("s390/zcrypt: Remove deprecated ioctls.")
    812141a9fe61 ("s390: crypto: add SPDX identifiers to the remaining files")
    83ad1e6a1dc0 ("powerpc/oprofile: Use setup_timer() helper")
    8d6b1bf20f61 ("powerpc/6xx: Use setup_timer() helper")
    9a5641080bf4 ("s390/zcrypt: Introduce QACT support for AP bus devices.")
    a45a5c7d36a5 ("s390/pkey: Introduce new API for random protected key generation")
    ac2b96f351d7 ("s390/zcrypt: code beautify")
    af4a72276d49 ("s390/zcrypt: Support up to 256 crypto adapters.")
    b9eaf1872222 ("treewide: init_timer() -> setup_timer()")
    c828a8920307 ("treewide: Use DEVICE_ATTR_RO")
    cb26b9ff7187 ("s390/pkey: Introduce new API for random protected key verification")
    e629cfa36ea0 ("MIPS: Lasat: Use setup_timer() helper")
    e99e88a9d2b0 ("treewide: setup_timer() -> timer_setup()")
    f2bbc96e7cfa ("s390/pkey: add CCA AES cipher key support")
    fb1136d6580c ("s390/pkey: Introduce new API for transforming key blobs")

v4.9.236: Failed to apply! Possible dependencies:
    1d9995771fcb ("s390: update defconfigs")
    80abb39b504e ("s390: update defconfig")
    a3358e3de393 ("s390/zcrypt: Rework CONFIG_ZCRYPT Kconfig text.")
    a45a5c7d36a5 ("s390/pkey: Introduce new API for random protected key generation")
    cb26b9ff7187 ("s390/pkey: Introduce new API for random protected key verification")
    e61a6134e7a5 ("s390/pkey: Introduce new API for secure key verification")
    e80d4af0a320 ("s390/pkey: Introduce pkey kernel module")
    f2bbc96e7cfa ("s390/pkey: add CCA AES cipher key support")
    fb1136d6580c ("s390/pkey: Introduce new API for transforming key blobs")
    fc1d3f02544a ("s390/zcrypt: Move the ap bus into kernel")

v4.4.236: Failed to apply! Possible dependencies:
    1d9995771fcb ("s390: update defconfigs")
    6e127efeeae5 ("s390/config: make the vector optimized crc function builtin")
    80abb39b504e ("s390: update defconfig")
    a086171ad886 ("s390: Updated kernel config files")
    cb14def6a9ca ("s390/configs: update default configurations")
    e80d4af0a320 ("s390/pkey: Introduce pkey kernel module")
    e9bc15f28e5f ("s390/config: update default configuration")
    f2bbc96e7cfa ("s390/pkey: add CCA AES cipher key support")
    fdcebf6f18ee ("s390/config: Enable config options for Docker")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
