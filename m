Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9935C54B90C
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 20:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357276AbiFNSpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357253AbiFNSoK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:44:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1D44D261;
        Tue, 14 Jun 2022 11:42:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4219B81AF1;
        Tue, 14 Jun 2022 18:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5481C3411D;
        Tue, 14 Jun 2022 18:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232174;
        bh=zQzBRU4KNLh+Ue+WmDy0cihfJOxzSAY9yZ3SInmnV9c=;
        h=From:To:Cc:Subject:Date:From;
        b=cZecKPp3RrajnTNavhE8+oSaT5bkd7baNn5U2PsRu0enfnzeVtMkESEf99oGYhH9q
         OnyWH9pua0HqR3vjIK9g4OAnYH+N73PwrfP3negGxzvO3gdbp/mGFpuQSNjzDoqbvi
         +mFuw8bOTpZTetYuGR//x7Bx5F7i2EUFOJxtpOiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.19 00/16] 4.19.248-rc1 review
Date:   Tue, 14 Jun 2022 20:40:01 +0200
Message-Id: <20220614183720.928818645@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.248-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.248-rc1
X-KernelTest-Deadline: 2022-06-16T18:37+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.248 release.
There are 16 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.248-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.248-rc1

Josh Poimboeuf <jpoimboe@kernel.org>
    x86/speculation/mmio: Print SMT warning

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    KVM: x86/speculation: Disable Fill buffer clear within guests

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation/mmio: Reuse SRBDS mitigation for SBDS

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation/srbds: Update SRBDS mitigation selection

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation/mmio: Add sysfs reporting for Processor MMIO Stale Data

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation/mmio: Enable CPU Fill buffer clearing on idle

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Group MDS, TAA & Processor MMIO Stale Data mitigations

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation/mmio: Add mitigation for Processor MMIO Stale Data

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation: Add a common function for MD_CLEAR mitigation update

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation/mmio: Enumerate Processor MMIO Stale Data bug

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    Documentation: Add documentation for Processor MMIO Stale Data

Gayatri Kammela <gayatri.kammela@intel.com>
    x86/cpu: Add another Alder Lake CPU to the Intel family

Tony Luck <tony.luck@intel.com>
    x86/cpu: Add Lakefield, Alder Lake and Rocket Lake models to the to Intel CPU family

Zhang Rui <rui.zhang@intel.com>
    x86/cpu: Add Jasper Lake to Intel family

Guenter Roeck <linux@roeck-us.net>
    cpu/speculation: Add prototype for cpu_show_srbds()

Gayatri Kammela <gayatri.kammela@intel.com>
    x86/cpu: Add Elkhart Lake to Intel family


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-devices-system-cpu |   1 +
 Documentation/admin-guide/hw-vuln/index.rst        |   1 +
 .../hw-vuln/processor_mmio_stale_data.rst          | 246 +++++++++++++++++++++
 Documentation/admin-guide/kernel-parameters.txt    |  36 +++
 Makefile                                           |   4 +-
 arch/x86/include/asm/cpufeatures.h                 |   1 +
 arch/x86/include/asm/intel-family.h                |  11 +
 arch/x86/include/asm/msr-index.h                   |  25 +++
 arch/x86/include/asm/nospec-branch.h               |   2 +
 arch/x86/kernel/cpu/bugs.c                         | 235 +++++++++++++++++---
 arch/x86/kernel/cpu/common.c                       |  52 ++++-
 arch/x86/kvm/vmx.c                                 |  77 ++++++-
 arch/x86/kvm/x86.c                                 |   4 +
 drivers/base/cpu.c                                 |   8 +
 include/linux/cpu.h                                |   4 +
 15 files changed, 665 insertions(+), 42 deletions(-)


