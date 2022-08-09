Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F17D558DDE7
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344920AbiHISHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344842AbiHISG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:06:56 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8251327168;
        Tue,  9 Aug 2022 11:03:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E7359CE18C6;
        Tue,  9 Aug 2022 18:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4ECC43470;
        Tue,  9 Aug 2022 18:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068178;
        bh=OEgPa9DO/ZirG7FYLua89HsmbXEREYGHihrwYPfMhY0=;
        h=From:To:Cc:Subject:Date:From;
        b=g3sd3CUWazAbPuZP/4CRDpA3fJEB6NppGkh4OV1rqnPcxiAq5VDk8hzhudYL/BY3G
         kQjMlAYP/pB5k9ptLWsMJ+Ti9jcl1ni05zRJRwGvAEHomd9BONhDtkZGl2YN/KTaJL
         14zoXDj14suYYOhKqjO6l1hbKWPdvbPCEyg6QXaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/15] 5.4.210-rc1 review
Date:   Tue,  9 Aug 2022 20:00:18 +0200
Message-Id: <20220809175510.312431319@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.210-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.210-rc1
X-KernelTest-Deadline: 2022-08-11T17:55+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.210 release.
There are 15 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.210-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.210-rc1

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation: Add LFENCE to RSB fill sequence

Daniel Sneddon <daniel.sneddon@linux.intel.com>
    x86/speculation: Add RSB VM Exit protections

Ning Qiang <sohu0106@126.com>
    macintosh/adb: fix oob read in do_adb_query() function

Chen-Yu Tsai <wenst@chromium.org>
    media: v4l2-mem2mem: Apply DST_QUEUE_OFF_BASE on MMAP buffers across ioctls

Raghavendra Rao Ananta <rananta@google.com>
    selftests: KVM: Handle compiler optimizations in ucall

Alexey Kardashevskiy <aik@ozlabs.ru>
    KVM: Don't null dereference ops->destroy

Jean-Philippe Brucker <jean-philippe@linaro.org>
    selftests/bpf: Fix "dubious pointer arithmetic" test

Stanislav Fomichev <sdf@google.com>
    selftests/bpf: Fix test_align verifier log patterns

John Fastabend <john.fastabend@gmail.com>
    bpf: Test_verifier, #70 error message updates for 32-bit right shift

Jakub Sitnicki <jakub@cloudflare.com>
    selftests/bpf: Extend verifier and bpf_sock tests for dst_port loads

John Fastabend <john.fastabend@gmail.com>
    bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()

Tony Luck <tony.luck@intel.com>
    ACPI: APEI: Better fix to avoid spamming the console with old error logs

Werner Sembach <wse@tuxedocomputers.com>
    ACPI: video: Shortening quirk list by identifying Clevo by board_name only

Werner Sembach <wse@tuxedocomputers.com>
    ACPI: video: Force backlight native for some TongFang devices

Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
    thermal: Fix NULL pointer dereferences in of_thermal_ functions


-------------

Diffstat:

 Documentation/admin-guide/hw-vuln/spectre.rst   |  8 +++
 Makefile                                        |  4 +-
 arch/x86/include/asm/cpufeatures.h              |  2 +
 arch/x86/include/asm/msr-index.h                |  4 ++
 arch/x86/include/asm/nospec-branch.h            | 19 +++++-
 arch/x86/kernel/cpu/bugs.c                      | 61 ++++++++++++++++++-
 arch/x86/kernel/cpu/common.c                    | 12 +++-
 arch/x86/kvm/vmx/vmenter.S                      |  1 +
 drivers/acpi/apei/bert.c                        | 31 +++++++---
 drivers/acpi/video_detect.c                     | 55 +++++++++++------
 drivers/macintosh/adb.c                         |  2 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c          | 60 +++++++++++++-----
 drivers/thermal/of-thermal.c                    |  9 ++-
 kernel/bpf/verifier.c                           |  1 +
 tools/arch/x86/include/asm/cpufeatures.h        |  1 +
 tools/include/uapi/linux/bpf.h                  |  3 +-
 tools/testing/selftests/bpf/test_align.c        | 41 +++++++------
 tools/testing/selftests/bpf/verifier/bounds.c   |  6 +-
 tools/testing/selftests/bpf/verifier/sock.c     | 81 ++++++++++++++++++++++++-
 tools/testing/selftests/kvm/lib/aarch64/ucall.c |  9 ++-
 virt/kvm/kvm_main.c                             |  5 +-
 21 files changed, 329 insertions(+), 86 deletions(-)


