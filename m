Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CA027245E
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 14:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgIUMzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 08:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727048AbgIUMzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 08:55:00 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE05121D95;
        Mon, 21 Sep 2020 12:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600692900;
        bh=L7mpo/hdPHFXkLwvMJXZi/1ZXCvyf06RoZzLjTU7Y7A=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=1bh876qYoBipNBg+++MAmD0oTMf8jwAXhtmcGlXCulkMz6vZFsunIExHegIwcMABi
         x0R3CPHVpHzDGJ8ePXeuu0pXUvG2AWqVh5TlXKZE9Dpy368svZqimpd4xdg8grII+6
         RDOpCBSSQ5ixqcVV3QI0cNyJPSCCed7XCMv5fsEA=
Date:   Mon, 21 Sep 2020 12:54:59 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Will Deacon <will@kernel.org>
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 02/19] arm64: Run ARCH_WORKAROUND_1 enabling code on all CPUs
In-Reply-To: <20200918164729.31994-3-will@kernel.org>
References: <20200918164729.31994-3-will@kernel.org>
Message-Id: <20200921125459.DE05121D95@mail.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 73f381660959 ("arm64: Advertise mitigation of Spectre-v2, or lack thereof").

The bot has tested the following trees: v5.8.10, v5.4.66, v4.19.146, v4.14.198.

v5.8.10: Build OK!
v5.4.66: Build OK!
v4.19.146: Build OK!
v4.14.198: Failed to apply! Possible dependencies:
    4b472ffd1513 ("arm64: Enable ARM64_HARDEN_EL2_VECTORS on Cortex-A57 and A72")
    631989303b06 ("Merge tag 'kvmarm-for-v4.19' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD")
    8892b71885df ("arm64: capabilities: Rework EL2 vector hardening entry")
    93916beb7014 ("arm64: Enable workaround for Cavium TX2 erratum 219 when running SMT")
    95b861a4a6d9 ("arm64: arch_timer: Add workaround for ARM erratum 1188873")
    969f5ea62757 ("arm64: errata: Add workaround for Cortex-A76 erratum #1463225")
    a457b0f7f50d ("arm64: Add configuration/documentation for Cortex-A76 erratum 1165522")
    dc6ed61d2f82 ("arm64: Add temporary ERRATA_MIDR_ALL_VERSIONS compatibility macro")
    e03a4e5bb743 ("arm64: Add silicon-errata.txt entry for ARM erratum 1188873")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
