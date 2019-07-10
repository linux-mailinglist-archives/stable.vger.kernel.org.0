Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2276469D
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 14:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfGJM7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 08:59:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbfGJM7m (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jul 2019 08:59:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 603A120861;
        Wed, 10 Jul 2019 12:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562763580;
        bh=sqM9ij7C74zlNZ4ajMhV2kVN8UyYVpDYmLH9DdG+ijw=;
        h=Date:From:To:Cc:Subject:From;
        b=o8yXh1w4tRyHvqTwPw5VnYBzCxtx5vEN9Fy7DZLjuOJcKnRUwUKd+XnGqlw5rYUUh
         8foaunn1gT3KoP9LAOnnYyXPo0BdE7iz8lrQfKd6PnkzzKyiUBFLs1btXCZzyHtgIs
         M3b+uImJ1Hbec/Kg9rE/BqzEAP5nk75ErztUvazk=
Date:   Wed, 10 Jul 2019 14:59:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.133
Message-ID: <20190710125938.GA13266@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.133 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                 |    2 -
 arch/arc/kernel/traps.c                  |    8 +++++++
 arch/arm64/kernel/module.c               |    8 +++++--
 arch/mips/include/asm/netlogic/xlr/fmn.h |    2 -
 arch/mips/mm/mmap.c                      |    2 -
 arch/mips/mm/tlbex.c                     |   29 ++++++++++++++++++---------
 arch/x86/kernel/ftrace.c                 |    3 ++
 arch/x86/kvm/lapic.c                     |    2 -
 arch/x86/kvm/x86.c                       |    6 ++---
 crypto/cryptd.c                          |    1=20
 crypto/crypto_user.c                     |    3 ++
 drivers/dma/imx-sdma.c                   |    4 +--
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c    |   19 -----------------
 drivers/gpu/drm/i915/intel_csr.c         |   18 ++++++++++++++++
 drivers/gpu/drm/imx/ipuv3-crtc.c         |    6 ++---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c   |    1=20
 drivers/gpu/drm/mediatek/mtk_dsi.c       |   12 ++++++++++-
 drivers/platform/x86/mlx-platform.c      |    2 -
 drivers/scsi/hpsa.c                      |    7 +++++-
 drivers/scsi/hpsa_cmd.h                  |    1=20
 drivers/spi/spi-bitbang.c                |    2 -
 drivers/tty/rocket.c                     |    2 -
 drivers/usb/gadget/udc/fusb300_udc.c     |    5 ++++
 drivers/usb/gadget/udc/lpc32xx_udc.c     |    3 --
 drivers/vhost/net.c                      |   33 +++++++++++++++++---------=
-----
 drivers/vhost/scsi.c                     |   14 +++++++++----
 drivers/vhost/vhost.c                    |   20 +++++++++++++++++-
 drivers/vhost/vhost.h                    |    6 ++++-
 drivers/vhost/vsock.c                    |   27 ++++++++++++++++++-------
 fs/btrfs/backref.c                       |    2 -
 fs/btrfs/dev-replace.c                   |   29 +++++++++++++++++----------
 fs/btrfs/volumes.c                       |    2 +
 fs/btrfs/volumes.h                       |    5 ++++
 kernel/cgroup/cpuset.c                   |   15 +++++++++++++-
 kernel/livepatch/core.c                  |    6 +++++
 kernel/ptrace.c                          |    4 ---
 kernel/trace/ftrace.c                    |    7 ++++--
 kernel/trace/trace.c                     |   10 +++++----
 lib/mpi/mpi-pow.c                        |    6 +----
 mm/mlock.c                               |    4 +--
 mm/vmscan.c                              |   27 ++++++++++++++-----------
 net/bluetooth/l2cap_core.c               |    2 -
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    7 +++++-
 scripts/decode_stacktrace.sh             |    2 -
 sound/core/seq/oss/seq_oss_ioctl.c       |    2 -
 sound/core/seq/oss/seq_oss_rw.c          |    2 -
 sound/firewire/amdtp-am824.c             |    2 -
 sound/pci/hda/patch_realtek.c            |    1=20
 sound/soc/codecs/cs4265.c                |    2 -
 sound/soc/codecs/max98090.c              |   16 +++++++++++++++
 sound/soc/codecs/rt274.c                 |    3 +-
 sound/soc/soc-pcm.c                      |    3 +-
 sound/soc/sunxi/sun4i-i2s.c              |    6 ++++-
 sound/usb/line6/pcm.c                    |    5 ++++
 sound/usb/mixer_quirks.c                 |    4 +--
 55 files changed, 293 insertions(+), 129 deletions(-)

Alex Deucher (1):
      drm/amdgpu/gfx9: use reset default for PA_SC_FIFO_SIZE

Alexandre Belloni (1):
      usb: gadget: udc: lpc32xx: allocate descriptor with GFP_ATOMIC

Amadeusz S=C5=82awi=C5=84ski (1):
      SoC: rt274: Fix internal jack assignment in set_jack callback

Ard Biesheuvel (1):
      arm64: kaslr: keep modules inside module region when KASAN is enabled

Chuck Lever (1):
      svcrdma: Ignore source port when computing DRC hash

Colin Ian King (2):
      ALSA: seq: fix incorrect order of dest_client/dest_ports arguments
      ALSA: usb-audio: fix sign unintended sign extension on left shifts

Dennis Wassenberg (1):
      ALSA: hda/realtek - Change front mic location for Lenovo M710q

Dmitry Korotin (1):
      MIPS: Add missing EHB in mtc0 -> mfc0 sequence.

Don Brace (1):
      scsi: hpsa: correct ioaccel2 chaining

Eiichi Tsukata (1):
      tracing/snapshot: Resize spare buffer if size changed

Eric Biggers (1):
      crypto: user - prevent operating on larval algorithms

Greg Kroah-Hartman (1):
      Linux 4.14.133

Hauke Mehrtens (1):
      MIPS: Fix bounds check virt_addr_valid

Herbert Xu (1):
      lib/mpi: Fix karactx leak in mpi_powm

Hsin-Yi Wang (3):
      drm/mediatek: fix unbind functions
      drm/mediatek: call drm_atomic_helper_shutdown() when unbinding driver
      drm/mediatek: call mtk_dsi_stop() after mtk_drm_crtc_atomic_disable()

Jann Horn (1):
      ptrace: Fix ->ptracer_cred handling for PTRACE_TRACEME

Jason Wang (5):
      vhost_net: introduce vhost_exceeds_weight()
      vhost: introduce vhost_exceeds_weight()
      vhost_net: fix possible infinite loop
      vhost: vsock: add weight support
      vhost: scsi: add weight support

Joel Savitz (1):
      cpuset: restore sanity to cpuset_cpus_allowed_fallback()

Josh Poimboeuf (1):
      module: Fix livepatch/ftrace module text permissions race

Libin Yang (1):
      ASoC: soc-pcm: BE dai needs prepare when pause release after resume

Linus Torvalds (1):
      tty: rocket: fix incorrect forward declaration of 'rp_init()'

Lucas De Marchi (1):
      drm/i915/dmc: protect against reading random memory

Manuel Traut (1):
      scripts/decode_stacktrace.sh: prefix addr2line with $CROSS_COMPILE

Marcus Cooper (2):
      ASoC: sun4i-i2s: Fix sun8i tx channel offset mask
      ASoC: sun4i-i2s: Add offset to RX channel select

Matias Karhumaa (1):
      Bluetooth: Fix faulty expression for minimum encryption key size check

Matt Flax (1):
      ASoC : cs4265 : readable register too low

Nikolay Borisov (1):
      btrfs: Ensure replaced device doesn't have pending chunk allocation

Paolo Abeni (1):
      vhost_net: use packet weight for rx handler, too

Paolo Bonzini (1):
      KVM: x86: degrade WARN to pr_warn_ratelimited

Paul Burton (1):
      MIPS: netlogic: xlr: Remove erroneous check in nlm_fmn_send()

Petr Mladek (1):
      ftrace/x86: Remove possible deadlock between register_kprobe() and ft=
race_run_update_code()

Robert Beckett (2):
      drm/imx: notify drm core before sending event during crtc disable
      drm/imx: only send event on crtc disable if kept disabled

Robin Gong (1):
      dmaengine: imx-sdma: remove BD_INTR for channel0

Shakeel Butt (1):
      mm/vmscan.c: prevent useless kswapd loops

Stanislaw Gruszka (1):
      stable/btrfs: fix backport bug in d819d97ea025 ("btrfs: honor path->s=
kip_locking in backref code")

Takashi Iwai (1):
      ALSA: line6: Fix write on zero-sized buffer

Takashi Sakamoto (1):
      ALSA: firewire-lib/fireworks: fix miss detection of received MIDI mes=
sages

Vadim Pasternak (1):
      platform/x86: mlx-platform: Fix parent device in i2c-mux-reg device r=
egistration

Vincent Whitchurch (1):
      crypto: cryptd - Fix skcipher instance memory leak

Vineet Gupta (1):
      ARC: handle gcc generated __builtin_trap for older compiler

Wanpeng Li (1):
      KVM: LAPIC: Fix pending interrupt in IRR blocked by software disable =
LAPIC

Wei Li (1):
      ftrace: Fix NULL pointer dereference in free_ftrace_func_mapper()

Young Xiao (1):
      usb: gadget: fusb300_udc: Fix memory leak of fusb300->ep[i]

Yu-Hsuan Hsu (1):
      ASoC: max98090: remove 24-bit format support if RJ is 0

YueHaibing (1):
      spi: bitbang: Fix NULL pointer dereference in spi_unregister_master

haibinzhang(=E5=BC=A0=E6=B5=B7=E6=96=8C) (1):
      vhost-net: set packet weight of tx polling to 2 * vq size

swkhack (1):
      mm/mlock.c: change count_mm_mlocked_page_nr return type


--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0l4ToACgkQONu9yGCS
aT7POw/7Bf79L+L1U9laPSDOGXSKnwIH7DkxSfvhITaydizUvq7wf91WeHdjHv1L
Izw1f/3ikscTqw4NEoPoWMRuSsefJxA+AE2VJW+9rBJSNfPJuR1QSmpCJ813letD
E+rsuGZJgnwRkGmPDnUif+1jsKu/CJbMOCHKY4/wHhfU5zsM+2zLqF9qGuPgAvqt
3UaD+fV21eBYZNIKhzxJq7/H/Ebb1q/7chhsLDyGSVjLb1TpPkHXglP6fUGCk+3S
DSSkBBB3N6Fr3DterYJ0YPR3/f5CrIaGuNS/rQdR1U2yDqOLSlEMyvNC+GgE7rvR
zI3QlSxjmkS3rGzCy3hFHvup4KwCouX9kCy3vZLkHJgRxhUyaVtwjyeFraKZ/7Ax
KHQzphvIJ5a4PK5JY+i6/okbEuA8eSEDcMPzh4X32TsYqM4wuTDm1QUZ7EwjfEW5
20JRVA0OYgCqtuhDuvuDdqAqkeuFTppZX7wk3VaIOjD0mLGp3WKmDpoA8WOms+60
EDy3bF7J8cnXQ021kjc6l9ACMY+UDlWSrmrvBoLZnu6fx+takif/heYqij562FVH
X4etDY2uC9/4HFSeobdLKUNoWHhvXe/ieRDoUhUQ7j8bmG88raYU0hYqthfsqLsC
FalzGJAKIELsyx4DQuY4s9LQ4Am95rQpq5JLHZyzSUe5O9zcnbA=
=pbjG
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
