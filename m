Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B90F1D9597
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 13:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbgESLtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 07:49:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728626AbgESLtJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 07:49:09 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1574B20709;
        Tue, 19 May 2020 11:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589888948;
        bh=Q9HfJy6VdawZJlpU6m18c2Kc27q9zWaPvUZXoLjBWZU=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=LXbImAaUG/gxP2sv1kmRsdu1I7dAYnpXmvFiBIGtwgn7uCRK8GzguaScc3Gu1L2Lr
         8Xzy0LGSqqaj6/Ecwt5G/OIjoXs7lPrivgy8Gr4awNmeajFSDJu8P+U8A3GnSVjEXu
         V42GQcd+4wiVoDYOdfQDo4RjPhXXEcZfrVXUaXTs=
Date:   Tue, 19 May 2020 11:49:06 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     "tip-bot2 for Borislav Petkov" <tip-bot2@linutronix.de>
To:     linux-tip-commits@vger.kernel.org
Cc:     Sergei Trofimovich <slyfox@gentoo.org>
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [tip: x86/urgent] x86: Fix early boot crash on gcc-10, third try
In-Reply-To: <158954160454.17951.15828011095215471629.tip-bot2@tip-bot2>
References: <158954160454.17951.15828011095215471629.tip-bot2@tip-bot2>
Message-Id: <20200519114908.1574B20709@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.13, v5.4.41, v4.19.123, v4.14.180, v4.9.223, v4.4.223.

v5.6.13: Build OK!
v5.4.41: Build OK!
v4.19.123: Failed to apply! Possible dependencies:
    53c99bd665a2 ("init: add arch_call_rest_init to allow stack switching")
    ec0bbef66f86 ("Compiler Attributes: homogenize __must_be_array")

v4.14.180: Failed to apply! Possible dependencies:
    53c99bd665a2 ("init: add arch_call_rest_init to allow stack switching")
    771c035372a0 ("deprecate the '__deprecated' attribute warnings entirely and for good")
    815f0ddb346c ("include/linux/compiler*.h: make compiler-*.h mutually exclusive")
    8793bb7f4a9d ("kbuild: add macro for controlling warnings to linux/compiler.h")
    cafa0010cd51 ("Raise the minimum required gcc version to 4.6")
    ec0bbef66f86 ("Compiler Attributes: homogenize __must_be_array")

v4.9.223: Failed to apply! Possible dependencies:
    1cec20f0ea0e ("dma-buf: Restart reservation_object_wait_timeout_rcu() after writes")
    38b8d208a454 ("sched/headers: Prepare for new header dependencies before moving code to <linux/sched/nmi.h>")
    555570d744f8 ("sched/clock: Update static_key usage")
    78010cd9736e ("dma-buf/fence: add an lockdep_assert_held()")
    83b96794e0ea ("x86/xen: split off smp_pv.c")
    983de5f97169 ("firmware: tegra: Add BPMP support")
    9881b024b7d7 ("sched/clock: Delay switching sched_clock to stable")
    a52482d9355e ("x86/xen: split off smp_hvm.c")
    aa1c84e8ca7f ("x86/xen: split xen_cpu_die()")
    acb04058de49 ("sched/clock: Fix hotplug crash")
    b52992c06c90 ("drm/i915: Support asynchronous waits on struct fence from i915_gem_request")
    ca791d7f4256 ("firmware: tegra: Add IVC library")
    e601757102cf ("sched/headers: Prepare for new header dependencies before moving code to <linux/sched/clock.h>")
    f54d1867005c ("dma-buf: Rename struct fence to dma_fence")
    fedf54132d24 ("dma-buf: Restart reservation_object_get_fences_rcu() after writes")

v4.4.223: Failed to apply! Possible dependencies:
    090e77c391dd ("cpu/hotplug: Restructure FROZEN state handling")
    1cf4f629d9d2 ("cpu/hotplug: Move online calls to hotplugged cpu")
    4baa0afc6719 ("cpu/hotplug: Convert the hotplugged cpu work to a state machine")
    949338e35131 ("cpu/hotplug: Move scheduler cpu_online notifier to hotplug core")
    984581728eb4 ("cpu/hotplug: Split out cpu down functions")
    ba997462435f ("cpu/hotplug: Restructure cpu_up code")
    cff7d378d3fd ("cpu/hotplug: Convert to a state machine for the control processor")
    fc6d73d67436 ("arch/hotplug: Call into idle with a proper state")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
