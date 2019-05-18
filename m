Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDFCB2237A
	for <lists+stable@lfdr.de>; Sat, 18 May 2019 14:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbfERMWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 May 2019 08:22:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729805AbfERMWm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 May 2019 08:22:42 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A667520882;
        Sat, 18 May 2019 12:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558182160;
        bh=HZeg8QbpcU2fthAxOpg7CQEiOy3gTHb35eWTxW1fIsw=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=BHMY8c3TXVDfLU5bMan3UmCGSc+gE8DPGBRRu1dkdxbTAEu0p0w0suPWLJrQXB8zR
         3gjz49blBjKNDqAzM9CiKJyYiJohL+W1fcqJlVo6Q2pZL98I1m9mZ/hhkGTNU27tgx
         v//NrRu/FJ26pLri4EXnZ8HhUZSU4cXDqJKOq27w=
Date:   Sat, 18 May 2019 12:22:39 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Alex Deucher <alexdeucher@gmail.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     Alex Deucher <alexander.deucher@amd.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] drm/amdgpu/soc15: skip reset on init
In-Reply-To: <20190517142647.26034-1-alexander.deucher@amd.com>
References: <20190517142647.26034-1-alexander.deucher@amd.com>
Message-Id: <20190518122240.A667520882@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.1.3, v5.0.17, v4.19.44, v4.14.120, v4.9.177, v4.4.180, v3.18.140.

v5.1.3: Build OK!
v5.0.17: Failed to apply! Possible dependencies:
    9281f12cabb0 ("drm/amdgpu/soc15: add need_reset_on_init asic callback for SOC15 (v2)")
    b45e18acd394 ("drm/amdgpu: Add sysfs file for PCIe usage v5")

v4.19.44: Failed to apply! Possible dependencies:
    062f38072537 ("drm/amdgpu: Vega10 doorbell index initialization")
    4e2c1ac2027d ("drm/amdgpu: Doorbell index initialization for ASICs before vega10")
    520cbe0f4a7f ("drm/amdgpu: set CG flags for raven2 (v2)")
    5253163a11fb ("drm/amdgpu: Add asic func interface to init doorbell index")
    9281f12cabb0 ("drm/amdgpu/soc15: add need_reset_on_init asic callback for SOC15 (v2)")
    a2a8fb512e09 ("drm/amdgpu/sriov: Correct the setting about sdma doorbell offset of Vega10")
    b45e18acd394 ("drm/amdgpu: Add sysfs file for PCIe usage v5")
    c3bce35c662b ("drm/amdgpu: fix sdma doorbell comments typo")
    c5892230d98b ("drm/amdgpu: Doorbell assignment for 8 sdma user queue per engine")
    c93aa77586c2 ("drm/amdgpu: Doorbell layout for vega20 and future asic")

v4.14.120: Failed to apply! Possible dependencies:
    11dc9364bddd ("drm/amdgpu: move struct amd_powerplay to amdgpu.h")
    2df1b8b6a140 ("drm/amdgpu: add new asic callbacks for HDP flush/invalidation")
    4522824c488e ("drm/amdgpu: Dynamic initialize IP base offset")
    5253163a11fb ("drm/amdgpu: Add asic func interface to init doorbell index")
    690706900421 ("drm/amdgpu: add asic need_full_reset callback")
    698825653fdf ("drm/amdgpu: add optional ring to *_hdp callbacks")
    780cffc599b6 ("drm/amdgpu: add powerplay support for CI asics")
    9281f12cabb0 ("drm/amdgpu/soc15: add need_reset_on_init asic callback for SOC15 (v2)")
    946a4d5b3010 ("drm/amdgpu: Avoid use SOC15_REG_OFFSET in static const array")
    b45e18acd394 ("drm/amdgpu: Add sysfs file for PCIe usage v5")
    bf383fb64e7c ("drm/amdgpu: convert nbio to use callbacks (v2)")
    cd4d74648b80 ("drm/amdgpu: unify the interface of amd_pm_funcs")
    cfa289fd4986 ("drm/amdgpu: rename amdgpu_dpm_funcs to amd_pm_funcs")
    d04f257635a2 ("drm/amd/powerplay: fix memory leak in powerplay")
    dd5a6fe2af03 ("drm/amd/powerplay: Port vega10_hwmgr.c over to PP_CAP")
    df1e63942063 ("drm/amd/powerplay: delete eventmgr layer in poweprlay")
    f93f0c3a7e86 ("drm/amd/powerplay: use struct amd_pm_funcs in powerplay")

v4.9.177: Failed to apply! Possible dependencies:
    073440d26272 ("drm/amdgpu: move VM defines into amdgpu_vm.h")
    1245a694617e ("drm/amdgpu: update golden setting for pitcairn")
    1e9f1392795e ("drm/amdgpu/virt: add high level interfaces for virt")
    2120df475d6d ("drm/amdgpu: enable virtual dce on SI")
    220ab9bd1ccf ("drm/amdgpu: soc15 enable (v3)")
    2df1b8b6a140 ("drm/amdgpu: add new asic callbacks for HDP flush/invalidation")
    4522824c488e ("drm/amdgpu: Dynamic initialize IP base offset")
    4e4bbe7343a6 ("drm/amdgpu:add new file for SRIOV")
    4e638ae9c1e7 ("drm/amdgpu/gfx8: add support kernel interface queue(KIQ)")
    5253163a11fb ("drm/amdgpu: Add asic func interface to init doorbell index")
    561135049992 ("drm/amdgpu: move sync handling into a separate header")
    5a5099cbf4d8 ("drm/amdgpu/virt: rename fieldes of virtualization structure")
    690706900421 ("drm/amdgpu: add asic need_full_reset callback")
    698825653fdf ("drm/amdgpu: add optional ring to *_hdp callbacks")
    6a7f76e70fac ("drm/amdgpu: add VRAM manager v2")
    6b7985efc3b5 ("drm/amdgpu: update golden setting for oland")
    78023016116f ("drm/amdgpu: move fence and ring defines into amdgpu_ring.h")
    78bbe771174c ("drm/amd/amdgpu: De-numberify golden SI registers")
    7c0a705e0326 ("drm/amdgpu: update golden setting/tiling table of tahiti")
    880e87e38098 ("drm/amdgpu/gfx8: implement emit_rreg/wreg function")
    914b4dce4fda ("drm/amdgpu: stop using a bo list entry for the VM PTs")
    9281f12cabb0 ("drm/amdgpu/soc15: add need_reset_on_init asic callback for SOC15 (v2)")
    946a4d5b3010 ("drm/amdgpu: Avoid use SOC15_REG_OFFSET in static const array")
    954d5d437f22 ("drm/amdgpu: add nbio7 support")
    ab71ac56f6d8 ("drm/amdgpu/virt: implement VI virt operation interfaces")
    b45e18acd394 ("drm/amdgpu: Add sysfs file for PCIe usage v5")
    bbf282d88479 ("drm/amdgpu: add asic callback to get memsize register")
    bc992ba5a3c1 ("drm/amdgpu/virt: use kiq to access registers (v2)")
    bd27b678c26e ("drm/amdgpu: update golden setting for hainan")
    bd7de27d81a7 ("drm/amdgpu:new field members for SRIOV")
    bf383fb64e7c ("drm/amdgpu: convert nbio to use callbacks (v2)")
    c1d83da98070 ("drm/amdgpu: add NBIO 6.1 driver")
    c9c9de93a33c ("drm/amdgpu/virt: impl mailbox for ai")
    dae5c2985da9 ("drm/amdgpu: update golden setting for verde")
    f7da30d979d4 ("drm/amdgpu: move PT validation back into VM code v2")

v4.4.180: Failed to apply! Possible dependencies:
    048765ad5af7 ("amdgpu: fix asic initialization for virtualized environments (v2)")
    0c34f4536842 ("drm/amdgpu: add SI SMC support")
    0f27e46258ee ("drm/amdgpu: add si header files v4")
    1245a694617e ("drm/amdgpu: update golden setting for pitcairn")
    1e9f1392795e ("drm/amdgpu/virt: add high level interfaces for virt")
    1eb22bd38ac5 ("drm/amdgpu: add read_bios_from_rom callback for CI parts")
    1f7371b2a5fa ("drm/amd/powerplay: add basic powerplay framework")
    2120df475d6d ("drm/amdgpu: enable virtual dce on SI")
    220ab9bd1ccf ("drm/amdgpu: soc15 enable (v3)")
    288912cb95d1 ("drm/amdgpu: use $(src) in Makefile (v2)")
    2cd46ad22383 ("drm/amdgpu: add graphic pipeline implementation for si v8")
    2df1b8b6a140 ("drm/amdgpu: add new asic callbacks for HDP flush/invalidation")
    4522824c488e ("drm/amdgpu: Dynamic initialize IP base offset")
    4e99a44e37bf ("drm/amdgpu:changes of virtualization cases probe (v3)")
    5253163a11fb ("drm/amdgpu: Add asic func interface to init doorbell index")
    62a37553414a ("drm/amdgpu: add si implementation v10")
    690706900421 ("drm/amdgpu: add asic need_full_reset callback")
    698825653fdf ("drm/amdgpu: add optional ring to *_hdp callbacks")
    6b7985efc3b5 ("drm/amdgpu: update golden setting for oland")
    78bbe771174c ("drm/amd/amdgpu: De-numberify golden SI registers")
    7946b878038d ("drm/amdgpu: add a callback for reading the bios from the rom directly")
    7c0a705e0326 ("drm/amdgpu: update golden setting/tiling table of tahiti")
    7e471e6fbab8 ("drm/amdgpu: track whether the asic supports SR-IOV")
    841686df9f7d ("drm/amdgpu: add SI DPM support (v4)")
    8cce244cf67c ("drm/amdgpu: always repost cards that support SR-IOV")
    9281f12cabb0 ("drm/amdgpu/soc15: add need_reset_on_init asic callback for SOC15 (v2)")
    946a4d5b3010 ("drm/amdgpu: Avoid use SOC15_REG_OFFSET in static const array")
    954d5d437f22 ("drm/amdgpu: add nbio7 support")
    95addb2ae06f ("drm/amdgpu: add read_bios_from_rom callback for VI parts")
    a8fe58cec351 ("drm/amd: add ACP driver support")
    ab71ac56f6d8 ("drm/amdgpu/virt: implement VI virt operation interfaces")
    b45e18acd394 ("drm/amdgpu: Add sysfs file for PCIe usage v5")
    bbf282d88479 ("drm/amdgpu: add asic callback to get memsize register")
    bc992ba5a3c1 ("drm/amdgpu/virt: use kiq to access registers (v2)")
    bd27b678c26e ("drm/amdgpu: update golden setting for hainan")
    bf383fb64e7c ("drm/amdgpu: convert nbio to use callbacks (v2)")
    c1d83da98070 ("drm/amdgpu: add NBIO 6.1 driver")
    c9c9de93a33c ("drm/amdgpu/virt: impl mailbox for ai")
    dae5c2985da9 ("drm/amdgpu: update golden setting for verde")
    eca2240fb044 ("drm/amdgpu: mark amdgpu_allowed_register_entry tables as 'const'")
    f4b373f41cfc ("drm/amdgpu/trace: Add tracepoints to MMIO read/writes")
    fdff8cfa72b3 ("drm/amdgpu: vBIOS post only call when mem_size zero")

v3.18.140: Failed to apply! Possible dependencies:
    048765ad5af7 ("amdgpu: fix asic initialization for virtualized environments (v2)")
    04df25d12394 ("MAINTAINERS: Update amdkfd files")
    130e0371b7d4 ("drm/amdgpu: Add H/W agnostic amdgpu <--> amdkfd interface")
    16423d67936f ("Update MAINTAINERS and CREDITS files with amdkfd info")
    1f7371b2a5fa ("drm/amd/powerplay: add basic powerplay framework")
    288912cb95d1 ("drm/amdgpu: use $(src) in Makefile (v2)")
    2df1b8b6a140 ("drm/amdgpu: add new asic callbacks for HDP flush/invalidation")
    46651cc5dbee ("drm/amdgpu fix amdgpu.dpm=0 (v2)")
    49e7d9df9046 ("MAINTAINERS: Use tabs consistently")
    5253163a11fb ("drm/amdgpu: Add asic func interface to init doorbell index")
    564ea7900cff ("drm/amdgpu: enable uvd dpm and powergating")
    5fc3aeeb9e55 ("drm/amdgpu: rename amdgpu_ip_funcs to amd_ip_funcs (v2)")
    690706900421 ("drm/amdgpu: add asic need_full_reset callback")
    698825653fdf ("drm/amdgpu: add optional ring to *_hdp callbacks")
    7e471e6fbab8 ("drm/amdgpu: track whether the asic supports SR-IOV")
    841686df9f7d ("drm/amdgpu: add SI DPM support (v4)")
    8e9198d0698a ("drm/amdgpu: move some atombios definitions to common folder (v2)")
    9281f12cabb0 ("drm/amdgpu/soc15: add need_reset_on_init asic callback for SOC15 (v2)")
    97b2e202fba0 ("drm/amdgpu: add amdgpu.h (v2)")
    a02860aa2b2d ("drm/amdgpu: add atombios headers")
    a2e73f56fa62 ("drm/amdgpu: Add support for CIK parts")
    a8fe58cec351 ("drm/amd: add ACP driver support")
    aaa36a976bbb ("drm/amdgpu: Add initial VI support")
    b45e18acd394 ("drm/amdgpu: Add sysfs file for PCIe usage v5")
    b80d8475c1fd ("drm/amdgpu: add scheduler initialization")
    bbf282d88479 ("drm/amdgpu: add asic callback to get memsize register")
    d03846af9275 ("drm/amd: Add CGS interfaces")
    d38ceaf99ed0 ("drm/amdgpu: add core driver (v4)")


How should we proceed with this patch?

--
Thanks,
Sasha
