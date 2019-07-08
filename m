Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E41BB622B4
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbfGHP2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:28:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727411AbfGHP2P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:28:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9182320645;
        Mon,  8 Jul 2019 15:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599695;
        bh=GwQdK83U2AkxzIyna+TgmeRyOrMn61IAzefxGZlEQ4s=;
        h=From:To:Cc:Subject:Date:From;
        b=W8AKG6eimoQzwYaC8xNOO0Rx6KJ7VB2J/BWVL4KlUkbbGLPiARUWIUeHRnZWtLswK
         EMuRoddEM1TNlMK+nWH59P/hU7qJK/yxSO2lAmHWDb3RItNVfffZf8qTnpVCdKY+HW
         DNvexFTxW1Gb7Liwv71f9Lzm5F15lCuRWa597EdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/90] 4.19.58-stable review
Date:   Mon,  8 Jul 2019 17:12:27 +0200
Message-Id: <20190708150521.829733162@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.58-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.58-rc1
X-KernelTest-Deadline: 2019-07-10T15:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.58 release.
There are 90 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.58-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.58-rc1

Robin Gong <yibin.gong@nxp.com>
    dmaengine: imx-sdma: remove BD_INTR for channel0

Sricharan R <sricharan@codeaurora.org>
    dmaengine: qcom: bam_dma: Fix completed descriptors count

Cedric Hombourger <Cedric_Hombourger@mentor.com>
    MIPS: have "plain" make calls build dtbs for selected platforms

Dmitry Korotin <dkorotin@wavecomp.com>
    MIPS: Add missing EHB in mtc0 -> mfc0 sequence.

Hauke Mehrtens <hauke@hauke-m.de>
    MIPS: Fix bounds check virt_addr_valid

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Ignore source port when computing DRC hash

Paul Menzel <pmenzel@molgen.mpg.de>
    nfsd: Fix overflow causing non-working mounts on 1 TB machines

Wanpeng Li <wanpengli@tencent.com>
    KVM: LAPIC: Fix pending interrupt in IRR blocked by software disable LAPIC

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: degrade WARN to pr_warn_ratelimited

Guillaume Nault <gnault@redhat.com>
    netfilter: ipv6: nf_defrag: accept duplicate fragments again

Daniel Borkmann <daniel@iogearbox.net>
    bpf: fix bpf_jit_limit knob for PAGE_SIZE >= 64K

Colin Ian King <colin.king@canonical.com>
    net: hns: fix unsigned comparison to less than zero

Guoqing Jiang <gqjiang@suse.com>
    sc16is7xx: move label 'err_spi' to correct section

Guillaume Nault <gnault@redhat.com>
    netfilter: ipv6: nf_defrag: fix leakage of unqueued fragments

Eric Dumazet <edumazet@google.com>
    ip6: fix skb leak in ip6frag_expire_frag_queue()

David S. Miller <davem@davemloft.net>
    rds: Fix warning.

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Initialize power_state field properly

Salil Mehta <salil.mehta@huawei.com>
    net: hns: Fixes the missing put_device in positive leg for roce reset

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    x86/boot/compressed/64: Do not corrupt EDX on EFER.LME=1 setting

David Ahern <dsahern@gmail.com>
    selftests: fib_rule_tests: Fix icmp proto with ipv6

Xiubo Li <xiubli@redhat.com>
    scsi: tcmu: fix use after free

Wei Yongjun <weiyongjun1@huawei.com>
    mac80211: mesh: fix missing unlock on error in table_path_del()

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: don't access node/meta inode mapping after iput

Noralf Trønnes <noralf@tronnes.org>
    drm/fb-helper: generic: Don't take module ref for fbcon

Marek Szyprowski <m.szyprowski@samsung.com>
    media: s5p-mfc: fix incorrect bus assignment in virtual child device

Ursula Braun <ubraun@linux.ibm.com>
    net/smc: move unhash before release of clcsock

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum: Handle VLAN device unlinking

Linus Torvalds <torvalds@linux-foundation.org>
    tty: rocket: fix incorrect forward declaration of 'rp_init()'

Nikolay Borisov <nborisov@suse.com>
    btrfs: Ensure replaced device doesn't have pending chunk allocation

Shakeel Butt <shakeelb@google.com>
    mm/vmscan.c: prevent useless kswapd loops

Petr Mladek <pmladek@suse.com>
    ftrace/x86: Remove possible deadlock between register_kprobe() and ftrace_run_update_code()

Robert Beckett <bob.beckett@collabora.com>
    drm/imx: only send event on crtc disable if kept disabled

Robert Beckett <bob.beckett@collabora.com>
    drm/imx: notify drm core before sending event during crtc disable

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: add missing failure path to destroy suballoc

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx9: use reset default for PA_SC_FIFO_SIZE

Evan Quan <evan.quan@amd.com>
    drm/amd/powerplay: use hardware fan control if no powerplay fan table

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    arm64: kaslr: keep modules inside module region when KASAN is enabled

Joshua Scott <joshua.scott@alliedtelesis.co.nz>
    ARM: dts: armada-xp-98dx3236: Switch to armada-38x-uart serial node

Eiichi Tsukata <devel@etsukata.com>
    tracing/snapshot: Resize spare buffer if size changed

Eric Biggers <ebiggers@google.com>
    fs/userfaultfd.c: disable irqs for fault_pending and event locks

Herbert Xu <herbert@gondor.apana.org.au>
    lib/mpi: Fix karactx leak in mpi_powm

Dennis Wassenberg <dennis.wassenberg@secunet.com>
    ALSA: hda/realtek - Change front mic location for Lenovo M710q

Richard Sailer <rs@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirks for several Clevo notebook barebones

Colin Ian King <colin.king@canonical.com>
    ALSA: usb-audio: fix sign unintended sign extension on left shifts

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Fix write on zero-sized buffer

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-lib/fireworks: fix miss detection of received MIDI messages

Colin Ian King <colin.king@canonical.com>
    ALSA: seq: fix incorrect order of dest_client/dest_ports arguments

Vincent Whitchurch <vincent.whitchurch@axis.com>
    crypto: cryptd - Fix skcipher instance memory leak

Eric Biggers <ebiggers@google.com>
    crypto: user - prevent operating on larval algorithms

Jann Horn <jannh@google.com>
    ptrace: Fix ->ptracer_cred handling for PTRACE_TRACEME

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/i915/dmc: protect against reading random memory

Wei Li <liwei391@huawei.com>
    ftrace: Fix NULL pointer dereference in free_ftrace_func_mapper()

Josh Poimboeuf <jpoimboe@redhat.com>
    module: Fix livepatch/ftrace module text permissions race

Vasily Gorbik <gor@linux.ibm.com>
    tracing: avoid build warning with HAVE_NOP_MCOUNT

swkhack <swkhack@gmail.com>
    mm/mlock.c: change count_mm_mlocked_page_nr return type

Manuel Traut <manut@linutronix.de>
    scripts/decode_stacktrace.sh: prefix addr2line with $CROSS_COMPILE

Joel Savitz <jsavitz@redhat.com>
    cpuset: restore sanity to cpuset_cpus_allowed_fallback()

Linus Walleij <linus.walleij@linaro.org>
    i2c: pca-platform: Fix GPIO lookup code

Vadim Pasternak <vadimp@mellanox.com>
    platform/mellanox: mlxreg-hotplug: Add devm_free_irq call to remove flow

Vadim Pasternak <vadimp@mellanox.com>
    platform/x86: mlx-platform: Fix parent device in i2c-mux-reg device registration

Mathew King <mathewk@chromium.org>
    platform/x86: intel-vbtn: Report switch events when event wakes device

Hans de Goede <hdegoede@redhat.com>
    platform/x86: asus-wmi: Only Tell EC the OS will handle display hotkeys from asus_nb_wmi

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Add quirk for GPD MicroPC

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Add quirk for GPD pocket2

Don Brace <don.brace@microsemi.com>
    scsi: hpsa: correct ioaccel2 chaining

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    SoC: rt274: Fix internal jack assignment in set_jack callback

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ALSA: hdac: fix memory release for SST and SOF drivers

Alexandre Belloni <alexandre.belloni@bootlin.com>
    usb: gadget: udc: lpc32xx: allocate descriptor with GFP_ATOMIC

Young Xiao <92siuyang@gmail.com>
    usb: gadget: fusb300_udc: Fix memory leak of fusb300->ep[i]

Kan Liang <kan.liang@linux.intel.com>
    x86/CPU: Add more Icelake model numbers

Marcus Cooper <codekipper@gmail.com>
    ASoC: sun4i-i2s: Add offset to RX channel select

Marcus Cooper <codekipper@gmail.com>
    ASoC: sun4i-i2s: Fix sun8i tx channel offset mask

Yu-Hsuan Hsu <yuhsuan@chromium.org>
    ASoC: max98090: remove 24-bit format support if RJ is 0

Hsin-Yi Wang <hsinyi@chromium.org>
    drm/mediatek: call mtk_dsi_stop() after mtk_drm_crtc_atomic_disable()

Hsin-Yi Wang <hsinyi@chromium.org>
    drm/mediatek: clear num_pipes when unbind driver

Hsin-Yi Wang <hsinyi@chromium.org>
    drm/mediatek: call drm_atomic_helper_shutdown() when unbinding driver

Hsin-Yi Wang <hsinyi@chromium.org>
    drm/mediatek: unbind components in mtk_drm_unbind()

Hsin-Yi Wang <hsinyi@chromium.org>
    drm/mediatek: fix unbind functions

YueHaibing <yuehaibing@huawei.com>
    spi: bitbang: Fix NULL pointer dereference in spi_unregister_master

Viorel Suman <viorel.suman@nxp.com>
    ASoC: ak4458: rstn_control - return a non-zero on error only

Libin Yang <libin.yang@intel.com>
    ASoC: soc-pcm: BE dai needs prepare when pause release after resume

Viorel Suman <viorel.suman@nxp.com>
    ASoC: ak4458: add return value for ak4458_probe

Matt Flax <flatmax@flatmax.org>
    ASoC : cs4265 : readable register too low

Florian Westphal <fw@strlen.de>
    netfilter: nft_flow_offload: IPCB is only valid for ipv4 family

Florian Westphal <fw@strlen.de>
    netfilter: nft_flow_offload: don't offload when sequence numbers need adjustment

Florian Westphal <fw@strlen.de>
    netfilter: nft_flow_offload: set liberal tracking mode for tcp

Florian Westphal <fw@strlen.de>
    netfilter: nf_flow_table: ignore DF bit setting

Guilherme G. Piccoli <gpiccoli@canonical.com>
    md/raid0: Do not bypass blocking queue entered for raid0 bios

Guilherme G. Piccoli <gpiccoli@canonical.com>
    block: Fix a NULL pointer dereference in generic_make_request()

Matias Karhumaa <matias.karhumaa@gmail.com>
    Bluetooth: Fix faulty expression for minimum encryption key size check


-------------

Diffstat:

 Makefile                                           |  4 +--
 arch/arm/boot/dts/armada-xp-98dx3236.dtsi          |  8 +++++
 arch/arm64/kernel/module.c                         |  8 +++--
 arch/mips/Makefile                                 |  3 +-
 arch/mips/mm/mmap.c                                |  2 +-
 arch/mips/mm/tlbex.c                               | 29 ++++++++++-----
 arch/x86/boot/compressed/head_64.S                 |  2 ++
 arch/x86/include/asm/intel-family.h                |  3 ++
 arch/x86/kernel/ftrace.c                           |  3 ++
 arch/x86/kvm/lapic.c                               |  2 +-
 arch/x86/kvm/x86.c                                 |  6 ++--
 block/blk-core.c                                   |  5 ++-
 crypto/cryptd.c                                    |  1 +
 crypto/crypto_user.c                               |  3 ++
 drivers/dma/imx-sdma.c                             |  4 +--
 drivers/dma/qcom/bam_dma.c                         |  3 ++
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              | 19 ----------
 .../amd/powerplay/hwmgr/process_pptables_v1_0.c    |  4 ++-
 drivers/gpu/drm/amd/powerplay/inc/hwmgr.h          |  1 +
 .../drm/amd/powerplay/smumgr/polaris10_smumgr.c    |  4 +++
 drivers/gpu/drm/drm_fb_helper.c                    |  6 ++--
 drivers/gpu/drm/drm_panel_orientation_quirks.c     | 32 +++++++++++++++++
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |  7 ++--
 drivers/gpu/drm/i915/intel_csr.c                   | 18 ++++++++++
 drivers/gpu/drm/imx/ipuv3-crtc.c                   |  6 ++--
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |  8 ++---
 drivers/gpu/drm/mediatek/mtk_dsi.c                 | 12 ++++++-
 drivers/i2c/busses/i2c-pca-platform.c              |  3 +-
 drivers/md/raid0.c                                 |  2 ++
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  1 -
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c |  5 ++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     | 10 ++++++
 drivers/platform/mellanox/mlxreg-hotplug.c         |  1 +
 drivers/platform/x86/asus-nb-wmi.c                 |  8 +++++
 drivers/platform/x86/asus-wmi.c                    |  2 +-
 drivers/platform/x86/asus-wmi.h                    |  1 +
 drivers/platform/x86/intel-vbtn.c                  | 16 +++++++--
 drivers/platform/x86/mlx-platform.c                |  2 +-
 drivers/scsi/hpsa.c                                |  7 +++-
 drivers/scsi/hpsa_cmd.h                            |  1 +
 drivers/spi/spi-bitbang.c                          |  2 +-
 drivers/target/target_core_user.c                  |  3 +-
 drivers/tty/rocket.c                               |  2 +-
 drivers/tty/serial/sc16is7xx.c                     |  2 ++
 drivers/usb/gadget/udc/fusb300_udc.c               |  5 +++
 drivers/usb/gadget/udc/lpc32xx_udc.c               |  3 +-
 fs/btrfs/dev-replace.c                             | 26 +++++++++-----
 fs/btrfs/volumes.c                                 |  2 ++
 fs/btrfs/volumes.h                                 |  5 +++
 fs/f2fs/debug.c                                    | 19 ++++++----
 fs/f2fs/super.c                                    |  5 +++
 fs/nfsd/nfs4state.c                                |  2 +-
 fs/userfaultfd.c                                   | 42 +++++++++++++---------
 include/linux/filter.h                             |  2 +-
 include/net/ipv6_frag.h                            |  1 -
 kernel/bpf/core.c                                  | 21 +++++++----
 kernel/cgroup/cpuset.c                             | 15 +++++++-
 kernel/livepatch/core.c                            |  6 ++++
 kernel/ptrace.c                                    |  4 +--
 kernel/trace/ftrace.c                              | 12 ++++---
 kernel/trace/trace.c                               | 10 +++---
 lib/mpi/mpi-pow.c                                  |  6 ++--
 mm/mlock.c                                         |  4 +--
 mm/vmscan.c                                        | 27 +++++++-------
 net/bluetooth/l2cap_core.c                         |  2 +-
 net/core/sysctl_net_core.c                         | 20 +++++++++--
 net/ipv6/netfilter/nf_conntrack_reasm.c            | 22 ++++++------
 net/mac80211/mesh_pathtbl.c                        |  2 +-
 net/netfilter/nf_flow_table_ip.c                   |  3 +-
 net/netfilter/nft_flow_offload.c                   | 31 ++++++++++------
 net/rds/send.c                                     |  4 ++-
 net/smc/af_smc.c                                   |  6 ++--
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |  7 +++-
 scripts/decode_stacktrace.sh                       |  2 +-
 sound/core/seq/oss/seq_oss_ioctl.c                 |  2 +-
 sound/core/seq/oss/seq_oss_rw.c                    |  2 +-
 sound/firewire/amdtp-am824.c                       |  2 +-
 sound/hda/ext/hdac_ext_bus.c                       |  1 -
 sound/pci/hda/hda_codec.c                          |  1 +
 sound/pci/hda/patch_realtek.c                      |  8 +++--
 sound/soc/codecs/ak4458.c                          | 18 ++++++----
 sound/soc/codecs/cs4265.c                          |  2 +-
 sound/soc/codecs/max98090.c                        | 16 +++++++++
 sound/soc/codecs/rt274.c                           |  3 +-
 sound/soc/soc-pcm.c                                |  3 +-
 sound/soc/sunxi/sun4i-i2s.c                        |  6 +++-
 sound/usb/line6/pcm.c                              |  5 +++
 sound/usb/mixer_quirks.c                           |  4 +--
 tools/testing/selftests/net/fib_rule_tests.sh      |  4 +--
 89 files changed, 466 insertions(+), 198 deletions(-)


