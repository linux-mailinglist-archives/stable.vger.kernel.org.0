Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C496350E0
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 08:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236214AbiKWHFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 02:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236167AbiKWHFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 02:05:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E95F2412;
        Tue, 22 Nov 2022 23:05:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 537A161AAD;
        Wed, 23 Nov 2022 07:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54187C433D6;
        Wed, 23 Nov 2022 07:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669187115;
        bh=/hEp7t8vfIWgPmYYJ4gCINdFaRzCHwCO2bpTb2kS/xU=;
        h=From:To:Cc:Subject:Date:From;
        b=Nh8h65J/2v5p/TstxhL6PJa7HwCvcs1f0tgGBU/UqVn42zf+IK1VA1mDpDkSVRQ3I
         Z2qoyd2sfkNQMbO4p4ehOGHjDx+dCb+bmYmDgM/zkG6MV0bM6ULUwemp51wgP6SM0B
         PULRQAgxAWMNMxUjkPNBMADpslAEqTXsdq9XrCXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.266
Date:   Wed, 23 Nov 2022 08:05:07 +0100
Message-Id: <16691871078882@kroah.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.266 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt |   13 
 Makefile                                        |    2 
 arch/x86/entry/calling.h                        |   68 +++-
 arch/x86/entry/entry_32.S                       |    2 
 arch/x86/entry/entry_64.S                       |   34 +-
 arch/x86/entry/entry_64_compat.S                |   11 
 arch/x86/include/asm/cpu_device_id.h            |  168 ++++++++++
 arch/x86/include/asm/cpufeatures.h              |   18 -
 arch/x86/include/asm/intel-family.h             |    6 
 arch/x86/include/asm/msr-index.h                |   10 
 arch/x86/include/asm/nospec-branch.h            |   53 +--
 arch/x86/kernel/cpu/amd.c                       |   21 -
 arch/x86/kernel/cpu/bugs.c                      |  368 +++++++++++++++++++-----
 arch/x86/kernel/cpu/common.c                    |   60 ++-
 arch/x86/kernel/cpu/match.c                     |   44 ++
 arch/x86/kernel/cpu/scattered.c                 |    1 
 arch/x86/kernel/process.c                       |    2 
 arch/x86/kvm/svm.c                              |    1 
 arch/x86/kvm/vmx.c                              |   53 +++
 arch/x86/kvm/x86.c                              |    4 
 drivers/base/cpu.c                              |    8 
 drivers/cpufreq/acpi-cpufreq.c                  |    1 
 drivers/cpufreq/amd_freq_sensitivity.c          |    1 
 drivers/idle/intel_idle.c                       |   43 ++
 include/linux/cpu.h                             |    2 
 include/linux/kvm_host.h                        |    2 
 include/linux/mod_devicetable.h                 |    4 
 tools/arch/x86/include/asm/cpufeatures.h        |    1 
 28 files changed, 814 insertions(+), 187 deletions(-)

Alexandre Chartre (2):
      x86/bugs: Report AMD retbleed vulnerability
      x86/bugs: Add AMD retbleed= boot parameter

Andrew Cooper (1):
      x86/cpu/amd: Enumerate BTC_NO

Daniel Sneddon (1):
      x86/speculation: Add RSB VM Exit protections

Greg Kroah-Hartman (1):
      Linux 4.19.266

Ingo Molnar (1):
      x86/cpufeature: Fix various quality problems in the <asm/cpu_device_hd.h> header

Josh Poimboeuf (8):
      x86/speculation: Fix RSB filling with CONFIG_RETPOLINE=n
      x86/speculation: Fix firmware entry SPEC_CTRL handling
      x86/speculation: Fix SPEC_CTRL write on SMT state change
      x86/speculation: Use cached host SPEC_CTRL value for guest entry/exit
      x86/speculation: Remove x86_spec_ctrl_mask
      KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS
      KVM: VMX: Fix IBRS handling after vmexit
      x86/speculation: Fill RSB on vmexit for IBRS

Kan Liang (1):
      x86/cpufeature: Add facility to check for min microcode revisions

Mark Gross (1):
      x86/cpu: Add a steppings field to struct x86_cpu_id

Nathan Chancellor (1):
      x86/speculation: Use DECLARE_PER_CPU for x86_spec_ctrl_current

Pawan Gupta (4):
      x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS
      x86/bugs: Add Cannon lake to RETBleed affected CPU list
      x86/speculation: Disable RRSBA behavior
      x86/bugs: Warn when "ibrs" mitigation is selected on Enhanced IBRS parts

Peter Zijlstra (10):
      x86/cpufeatures: Move RETPOLINE flags to word 11
      x86/bugs: Keep a per-CPU IA32_SPEC_CTRL value
      x86/entry: Remove skip_r11rcx
      x86/entry: Add kernel IBRS implementation
      x86/bugs: Optimize SPEC_CTRL MSR writes
      x86/bugs: Split spectre_v2_select_mitigation() and spectre_v2_user_select_mitigation()
      x86/bugs: Report Intel retbleed vulnerability
      intel_idle: Disable IBRS during long idle
      x86/speculation: Change FILL_RETURN_BUFFER to work with objtool
      x86/common: Stamp out the stepping madness

Suleiman Souhlal (2):
      Revert "x86/speculation: Add RSB VM Exit protections"
      Revert "x86/cpu: Add a steppings field to struct x86_cpu_id"

Thomas Gleixner (2):
      x86/devicetable: Move x86 specific macro out of generic code
      x86/cpu: Add consistent CPU match macros

