Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8B6359B21
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbhDIKHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234221AbhDIKFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:05:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B21561353;
        Fri,  9 Apr 2021 10:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962504;
        bh=c4bOUHKr1wcbHTa0a06A7Ok9kagKGMG/V7n56xb4enI=;
        h=From:To:Cc:Subject:Date:From;
        b=hnBDemjqpVSBfRnjTCg9fx/2Mwbct8kO7uEEYxyyaRsQvUuP8Z/jveEpQlQaCSuE5
         63RFO2sVIYYDXo1ZptlgXPXz3pLnGQAEJnvc1oQC4VpQQus3YKo7qCi6q8lD3yt0UY
         Jr/OyefftQJ1DkbmT46sta+RAV+11NY3FI/WELh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.11 00/45] 5.11.13-rc1 review
Date:   Fri,  9 Apr 2021 11:53:26 +0200
Message-Id: <20210409095305.397149021@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.11.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.11.13-rc1
X-KernelTest-Deadline: 2021-04-11T09:53+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.11.13 release.
There are 45 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.13-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.11.13-rc1

Masahiro Yamada <masahiroy@kernel.org>
    init/Kconfig: make COMPILE_TEST depend on HAS_IOMEM

Piotr Krysiuk <piotras@gmail.com>
    bpf, x86: Validate computation of branch displacements for x86-32

Piotr Krysiuk <piotras@gmail.com>
    bpf, x86: Validate computation of branch displacements for x86-64

Stanislav Fomichev <sdf@google.com>
    tools/resolve_btfids: Add /libbpf to .gitignore

Jiri Olsa <jolsa@kernel.org>
    kbuild: Do not clean resolve_btfids if the output does not exist

Jiri Olsa <jolsa@kernel.org>
    kbuild: Add resolve_btfids clean to root clean target

Jiri Olsa <jolsa@kernel.org>
    tools/resolve_btfids: Set srctree variable unconditionally

Jiri Olsa <jolsa@kernel.org>
    tools/resolve_btfids: Check objects before removing

Jiri Olsa <jolsa@kernel.org>
    tools/resolve_btfids: Build libbpf and libsubcmd in separate directories

David S. Miller <davem@davemloft.net>
    math: Export mul_u64_u64_div_u64

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix timeout cancel return code

Vincent Whitchurch <vincent.whitchurch@axis.com>
    cifs: Silently ignore unknown oplock break handle

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: revalidate mapping when we open files for SMB1 POSIX

Sergei Trofimovich <slyfox@gentoo.org>
    ia64: fix format strings for err_inject

Sergei Trofimovich <slyfox@gentoo.org>
    ia64: mca: allocate early mca with GFP_ATOMIC

Rong Chen <rong.a.chen@intel.com>
    selftests/vm: fix out-of-tree build

Rich Wiley <rwiley@nvidia.com>
    arm64: kernel: disable CNP on Carmel

Martin Wilck <mwilck@suse.com>
    scsi: target: pscsi: Clean up after failure in pscsi_map_sg()

Yangbo Lu <yangbo.lu@nxp.com>
    ptp_qoriq: fix overflow in ptp_qoriq_adjfine() u64 calcalation

David E. Box <david.e.box@linux.intel.com>
    platform/x86: intel_pmc_core: Ignore GBE LTR on Tiger Lake platforms

David E. Box <david.e.box@linux.intel.com>
    platform/x86: intel_pmt_class: Initial resource to 0

Chris Chiu <chris.chiu@canonical.com>
    block: clear GD_NEED_PART_SCAN later in bdev_disk_changed

Arnd Bergmann <arnd@arndb.de>
    x86/build: Turn off -fcf-protection for realmode targets

Kalyan Thota <kalyant@codeaurora.org>
    drm/msm/disp/dpu1: icc path needs to be set before dpu runtime resume

Andre Przywara <andre.przywara@arm.com>
    kselftest/arm64: sve: Do not use non-canonical FFR register value

Esteve Varela Colominas <esteve.varela@gmail.com>
    platform/x86: thinkpad_acpi: Allow the FnLock LED to change state

Alex Elder <elder@linaro.org>
    net: ipa: fix init header command validation

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nftables: skip hook overlap logic if flowtable is stale

Ludovic Senecaux <linuxludo@free.fr>
    netfilter: conntrack: Fix gre tunneling over ipv6

Rob Clark <robdclark@chromium.org>
    drm/msm: Ratelimit invalid-fence message

Konrad Dybcio <konrad.dybcio@somainline.org>
    drm/msm/adreno: a5xx_power: Don't apply A540 lm_setup to other GPUs

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dsi_pll_7nm: Fix variable usage for pll_lockdet_rate

Karthikeyan Kathirvel <kathirve@codeaurora.org>
    mac80211: choose first enabled channel for monitor

Daniel Phan <daniel.phan36@gmail.com>
    mac80211: Check crypto_aead_encrypt for errors

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: Add support for USBcan Pro 4xHS

Tong Zhang <ztong0001@gmail.com>
    net: arcnet: com20020 fix error handling

Tong Zhang <ztong0001@gmail.com>
    mISDN: fix crash in fritzpci

David Gow <davidgow@google.com>
    kunit: tool: Fix a python tuple typing error

Pavel Andrianov <andrianov@ispras.ru>
    net: pxa168_eth: Fix a potential data race in pxa168_eth_remove

Tariq Toukan <tariqt@nvidia.com>
    net/mlx5e: Enforce minimum value check for ICOSQ size

Yonghong Song <yhs@fb.com>
    bpf, x86: Use kvmalloc_array instead kmalloc_array in bpf_jit_comp

Alban Bedel <albeu@free.fr>
    platform/x86: intel-hid: Support Lenovo ThinkPad X1 Tablet Gen 2

Jordan Crouse <jcrouse@codeaurora.org>
    drm/msm: a6xx: Make sure the SQE microcode is safe

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix warning on unbind if reset is not deasserted

Mans Rullgard <mans@mansr.com>
    ARM: dts: am33xx: add aliases for mmc interfaces


-------------

Diffstat:

 Documentation/arm64/silicon-errata.rst            |  3 +
 Makefile                                          | 17 ++++-
 arch/arm/boot/dts/am33xx.dtsi                     |  3 +
 arch/arm64/Kconfig                                | 10 +++
 arch/arm64/include/asm/cpucaps.h                  |  3 +-
 arch/arm64/kernel/cpu_errata.c                    |  8 +++
 arch/arm64/kernel/cpufeature.c                    |  5 +-
 arch/ia64/kernel/err_inject.c                     | 22 +++----
 arch/ia64/kernel/mca.c                            |  2 +-
 arch/x86/Makefile                                 |  2 +-
 arch/x86/net/bpf_jit_comp.c                       | 15 ++++-
 arch/x86/net/bpf_jit_comp32.c                     | 11 +++-
 drivers/bus/ti-sysc.c                             |  4 +-
 drivers/gpu/drm/msm/adreno/a5xx_power.c           |  2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c             | 77 +++++++++++++++++++----
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c           | 12 ++--
 drivers/gpu/drm/msm/dsi/pll/dsi_pll_7nm.c         |  2 +-
 drivers/gpu/drm/msm/msm_fence.c                   |  2 +-
 drivers/isdn/hardware/mISDN/mISDNipac.c           |  2 +-
 drivers/net/arcnet/com20020-pci.c                 | 34 +++++-----
 drivers/net/can/usb/Kconfig                       |  1 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c  |  4 +-
 drivers/net/ethernet/marvell/pxa168_eth.c         |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |  5 +-
 drivers/net/ipa/ipa_cmd.c                         | 50 ++++++++++-----
 drivers/platform/x86/intel-hid.c                  |  7 +++
 drivers/platform/x86/intel_pmc_core.c             | 50 ++++++++++-----
 drivers/platform/x86/intel_pmt_class.c            |  2 +-
 drivers/platform/x86/thinkpad_acpi.c              |  8 ++-
 drivers/ptp/ptp_qoriq.c                           | 13 ++--
 drivers/target/target_core_pscsi.c                |  8 +++
 fs/block_dev.c                                    |  4 +-
 fs/cifs/file.c                                    |  1 +
 fs/cifs/smb2misc.c                                |  4 +-
 fs/io_uring.c                                     |  8 +--
 init/Kconfig                                      |  3 +-
 lib/math/div64.c                                  |  1 +
 net/mac80211/aead_api.c                           |  5 +-
 net/mac80211/aes_gmac.c                           |  5 +-
 net/mac80211/main.c                               | 13 +++-
 net/netfilter/nf_conntrack_proto_gre.c            |  3 -
 net/netfilter/nf_tables_api.c                     |  3 +
 tools/bpf/resolve_btfids/.gitignore               |  3 +-
 tools/bpf/resolve_btfids/Makefile                 | 44 ++++++-------
 tools/testing/kunit/kunit_config.py               |  2 +-
 tools/testing/selftests/arm64/fp/sve-test.S       | 22 +++++--
 tools/testing/selftests/vm/Makefile               |  4 +-
 47 files changed, 357 insertions(+), 154 deletions(-)


