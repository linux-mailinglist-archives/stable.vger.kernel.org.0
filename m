Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA6FC62483
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731468AbfGHPX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:23:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388261AbfGHPXy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:23:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B137214C6;
        Mon,  8 Jul 2019 15:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599434;
        bh=56IrnD6Tc2gTYfbFkReMgZxeLTuPpNpPTzfiVjBAD5s=;
        h=From:To:Cc:Subject:Date:From;
        b=pvksK43mrTFANkqJlYoZlaqFQl4eW6f53OWgGiBdQ57Kh4fRZW2d/77aeXkLCSrZz
         Np1yR/Fcs0Ia8YNww7XFBvp+bnKXbxQGz1A8oFOtXN5O9ZI8dQrYCI1TXqzGK4rbS8
         S/Ca8FNQpiyv3W4piyd4h8v85gyqTdhfzJ/D5V/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/56] 4.14.133-stable review
Date:   Mon,  8 Jul 2019 17:12:52 +0200
Message-Id: <20190708150514.376317156@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.133-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.133-rc1
X-KernelTest-Deadline: 2019-07-10T15:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.133 release.
There are 56 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.133-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.133-rc1

Stanislaw Gruszka <sgruszka@redhat.com>
    stable/btrfs: fix backport bug in d819d97ea025 ("btrfs: honor path->skip_locking in backref code")

Robin Gong <yibin.gong@nxp.com>
    dmaengine: imx-sdma: remove BD_INTR for channel0

Dmitry Korotin <dkorotin@wavecomp.com>
    MIPS: Add missing EHB in mtc0 -> mfc0 sequence.

Hauke Mehrtens <hauke@hauke-m.de>
    MIPS: Fix bounds check virt_addr_valid

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Ignore source port when computing DRC hash

Wanpeng Li <wanpengli@tencent.com>
    KVM: LAPIC: Fix pending interrupt in IRR blocked by software disable LAPIC

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: degrade WARN to pr_warn_ratelimited

Vineet Gupta <vgupta@synopsys.com>
    ARC: handle gcc generated __builtin_trap for older compiler

Linus Torvalds <torvalds@linux-foundation.org>
    tty: rocket: fix incorrect forward declaration of 'rp_init()'

Jason Wang <jasowang@redhat.com>
    vhost: scsi: add weight support

Jason Wang <jasowang@redhat.com>
    vhost: vsock: add weight support

Jason Wang <jasowang@redhat.com>
    vhost_net: fix possible infinite loop

Jason Wang <jasowang@redhat.com>
    vhost: introduce vhost_exceeds_weight()

Jason Wang <jasowang@redhat.com>
    vhost_net: introduce vhost_exceeds_weight()

Paolo Abeni <pabeni@redhat.com>
    vhost_net: use packet weight for rx handler, too

haibinzhang(张海斌) <haibinzhang@tencent.com>
    vhost-net: set packet weight of tx polling to 2 * vq size

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

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx9: use reset default for PA_SC_FIFO_SIZE

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    arm64: kaslr: keep modules inside module region when KASAN is enabled

Joshua Scott <joshua.scott@alliedtelesis.co.nz>
    ARM: dts: armada-xp-98dx3236: Switch to armada-38x-uart serial node

Eiichi Tsukata <devel@etsukata.com>
    tracing/snapshot: Resize spare buffer if size changed

Herbert Xu <herbert@gondor.apana.org.au>
    lib/mpi: Fix karactx leak in mpi_powm

Dennis Wassenberg <dennis.wassenberg@secunet.com>
    ALSA: hda/realtek - Change front mic location for Lenovo M710q

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

Paul Burton <paul.burton@mips.com>
    MIPS: netlogic: xlr: Remove erroneous check in nlm_fmn_send()

Wei Li <liwei391@huawei.com>
    ftrace: Fix NULL pointer dereference in free_ftrace_func_mapper()

Josh Poimboeuf <jpoimboe@redhat.com>
    module: Fix livepatch/ftrace module text permissions race

swkhack <swkhack@gmail.com>
    mm/mlock.c: change count_mm_mlocked_page_nr return type

Manuel Traut <manut@linutronix.de>
    scripts/decode_stacktrace.sh: prefix addr2line with $CROSS_COMPILE

Joel Savitz <jsavitz@redhat.com>
    cpuset: restore sanity to cpuset_cpus_allowed_fallback()

Vadim Pasternak <vadimp@mellanox.com>
    platform/x86: mlx-platform: Fix parent device in i2c-mux-reg device registration

Don Brace <don.brace@microsemi.com>
    scsi: hpsa: correct ioaccel2 chaining

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    SoC: rt274: Fix internal jack assignment in set_jack callback

Alexandre Belloni <alexandre.belloni@bootlin.com>
    usb: gadget: udc: lpc32xx: allocate descriptor with GFP_ATOMIC

Young Xiao <92siuyang@gmail.com>
    usb: gadget: fusb300_udc: Fix memory leak of fusb300->ep[i]

Marcus Cooper <codekipper@gmail.com>
    ASoC: sun4i-i2s: Add offset to RX channel select

Marcus Cooper <codekipper@gmail.com>
    ASoC: sun4i-i2s: Fix sun8i tx channel offset mask

Yu-Hsuan Hsu <yuhsuan@chromium.org>
    ASoC: max98090: remove 24-bit format support if RJ is 0

Hsin-Yi Wang <hsinyi@chromium.org>
    drm/mediatek: call mtk_dsi_stop() after mtk_drm_crtc_atomic_disable()

Hsin-Yi Wang <hsinyi@chromium.org>
    drm/mediatek: call drm_atomic_helper_shutdown() when unbinding driver

Hsin-Yi Wang <hsinyi@chromium.org>
    drm/mediatek: fix unbind functions

YueHaibing <yuehaibing@huawei.com>
    spi: bitbang: Fix NULL pointer dereference in spi_unregister_master

Libin Yang <libin.yang@intel.com>
    ASoC: soc-pcm: BE dai needs prepare when pause release after resume

Matt Flax <flatmax@flatmax.org>
    ASoC : cs4265 : readable register too low

Matias Karhumaa <matias.karhumaa@gmail.com>
    Bluetooth: Fix faulty expression for minimum encryption key size check


-------------

Diffstat:

 Makefile                                  |  4 ++--
 arch/arc/kernel/traps.c                   |  8 ++++++++
 arch/arm/boot/dts/armada-xp-98dx3236.dtsi |  8 ++++++++
 arch/arm64/kernel/module.c                |  8 ++++++--
 arch/mips/include/asm/netlogic/xlr/fmn.h  |  2 --
 arch/mips/mm/mmap.c                       |  2 +-
 arch/mips/mm/tlbex.c                      | 29 ++++++++++++++++++---------
 arch/x86/kernel/ftrace.c                  |  3 +++
 arch/x86/kvm/lapic.c                      |  2 +-
 arch/x86/kvm/x86.c                        |  6 +++---
 crypto/cryptd.c                           |  1 +
 crypto/crypto_user.c                      |  3 +++
 drivers/dma/imx-sdma.c                    |  4 ++--
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c     | 19 ------------------
 drivers/gpu/drm/i915/intel_csr.c          | 18 +++++++++++++++++
 drivers/gpu/drm/imx/ipuv3-crtc.c          |  6 +++---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c    |  1 +
 drivers/gpu/drm/mediatek/mtk_dsi.c        | 12 ++++++++++-
 drivers/platform/x86/mlx-platform.c       |  2 +-
 drivers/scsi/hpsa.c                       |  7 ++++++-
 drivers/scsi/hpsa_cmd.h                   |  1 +
 drivers/spi/spi-bitbang.c                 |  2 +-
 drivers/tty/rocket.c                      |  2 +-
 drivers/usb/gadget/udc/fusb300_udc.c      |  5 +++++
 drivers/usb/gadget/udc/lpc32xx_udc.c      |  3 +--
 drivers/vhost/net.c                       | 33 ++++++++++++++++++-------------
 drivers/vhost/scsi.c                      | 14 +++++++++----
 drivers/vhost/vhost.c                     | 20 ++++++++++++++++++-
 drivers/vhost/vhost.h                     |  6 +++++-
 drivers/vhost/vsock.c                     | 27 ++++++++++++++++++-------
 fs/btrfs/backref.c                        |  2 --
 fs/btrfs/dev-replace.c                    | 29 +++++++++++++++++----------
 fs/btrfs/volumes.c                        |  2 ++
 fs/btrfs/volumes.h                        |  5 +++++
 kernel/cgroup/cpuset.c                    | 15 +++++++++++++-
 kernel/livepatch/core.c                   |  6 ++++++
 kernel/ptrace.c                           |  4 +---
 kernel/trace/ftrace.c                     |  7 +++++--
 kernel/trace/trace.c                      | 10 ++++++----
 lib/mpi/mpi-pow.c                         |  6 ++----
 mm/mlock.c                                |  4 ++--
 mm/vmscan.c                               | 27 ++++++++++++++-----------
 net/bluetooth/l2cap_core.c                |  2 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c  |  7 ++++++-
 scripts/decode_stacktrace.sh              |  2 +-
 sound/core/seq/oss/seq_oss_ioctl.c        |  2 +-
 sound/core/seq/oss/seq_oss_rw.c           |  2 +-
 sound/firewire/amdtp-am824.c              |  2 +-
 sound/pci/hda/patch_realtek.c             |  1 +
 sound/soc/codecs/cs4265.c                 |  2 +-
 sound/soc/codecs/max98090.c               | 16 +++++++++++++++
 sound/soc/codecs/rt274.c                  |  3 ++-
 sound/soc/soc-pcm.c                       |  3 ++-
 sound/soc/sunxi/sun4i-i2s.c               |  6 +++++-
 sound/usb/line6/pcm.c                     |  5 +++++
 sound/usb/mixer_quirks.c                  |  4 ++--
 56 files changed, 302 insertions(+), 130 deletions(-)


