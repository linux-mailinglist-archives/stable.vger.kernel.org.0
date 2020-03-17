Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A99418917A
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 23:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgCQWa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 18:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727232AbgCQWa1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 18:30:27 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3623120409;
        Tue, 17 Mar 2020 22:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584484227;
        bh=u91BC3NXkPdPIVBTn/xMmycQLs8sWQ1e5NtnOF5IDVo=;
        h=Date:From:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=nBbMhx0SmUy5n0wd7DtRTrr1cMsQPPg3Ooi3vYddcp4QPxU+x3dFRJpY4LMel8UO1
         W441wVJIKv+DdtOiz35F987n0LAjAZ8ow0pFdtPXGsD2VUg9mdo28hniga9E+pTasA
         hw21CTeljUPpXcEMs2tKsB3suOXL1Fmx81ORqMgI=
Date:   Tue, 17 Mar 2020 22:30:26 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     linux-tip-commits@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [tip: x86/timers] x86/tsc_msr: Use named struct initializers
In-Reply-To: <158396431730.28353.16602854182721546383.tip-bot2@tip-bot2>
References: <158396431730.28353.16602854182721546383.tip-bot2@tip-bot2>
Message-Id: <20200317223027.3623120409@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.9, v5.4.25, v4.19.109, v4.14.173, v4.9.216, v4.4.216.

v5.5.9: Build OK!
v5.4.25: Build OK!
v4.19.109: Failed to apply! Possible dependencies:
    0cc5359d8fd4 ("x86/cpu: Update init data for new Airmont CPU model")
    bba10c5cab4d ("x86/cpu: Use constant definitions for CPU models")

v4.14.173: Failed to apply! Possible dependencies:
    0cc5359d8fd4 ("x86/cpu: Update init data for new Airmont CPU model")
    397d3ad18dc4 ("x86/tsc: Convert to use x86_match_cpu() and INTEL_CPU_FAM6()")
    bba10c5cab4d ("x86/cpu: Use constant definitions for CPU models")

v4.9.216: Failed to apply! Possible dependencies:
    0cc5359d8fd4 ("x86/cpu: Update init data for new Airmont CPU model")
    397d3ad18dc4 ("x86/tsc: Convert to use x86_match_cpu() and INTEL_CPU_FAM6()")
    bba10c5cab4d ("x86/cpu: Use constant definitions for CPU models")

v4.4.216: Failed to apply! Possible dependencies:
    05680e7fa8a4 ("x86/tsc_msr: Correct Silvermont reference clock values")
    0cc5359d8fd4 ("x86/cpu: Update init data for new Airmont CPU model")
    397d3ad18dc4 ("x86/tsc: Convert to use x86_match_cpu() and INTEL_CPU_FAM6()")
    6fcb41cdaee5 ("x86/tsc_msr: Add Airmont reference clock values")
    9e0cae9f6227 ("x86/tsc_msr: Update comments, expand definitions")
    ba8268330dc1 ("x86/tsc_msr: Identify Intel-specific code")
    bba10c5cab4d ("x86/cpu: Use constant definitions for CPU models")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
