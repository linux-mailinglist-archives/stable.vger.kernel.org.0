Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 790D16C6BE
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391400AbfGRDS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:18:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391114AbfGRDM3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:12:29 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3DAD205F4;
        Thu, 18 Jul 2019 03:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419549;
        bh=wmul7ddf5AQioH045RZ+cY8LU5EmZOOYUhS9oeAnjyk=;
        h=From:To:Cc:Subject:Date:From;
        b=jULahcVPZ/QGbZWzciu61Jz5TNuyyCbuQqky+b8CodCLnx7bWGuyPAEHok+ZYM/lm
         6SwUpqW27Ltce1Lxy1L9TEteJTHVloWqxUwAS13etRH6HSZQGzaIggz4GMplMBj+yO
         CvHCagK8J9CcydjDO7cAH3pjfhlXTWYarEZg4qK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/54] 4.9.186-stable review
Date:   Thu, 18 Jul 2019 12:01:30 +0900
Message-Id: <20190718030048.392549994@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.186-rc1
X-KernelTest-Deadline: 2019-07-20T03:00+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.186 release.
There are 54 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.186-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.186-rc1

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qdio: don't touch the dsci in tiqdio_add_input_queues()

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qdio: (re-)initialize tiqdio list entries

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390: fix stfle zero padding

Arnd Bergmann <arnd@arndb.de>
    ARC: hide unused function unw_hdr_alloc

Milan Broz <gmazyland@gmail.com>
    dm verity: use message limit for data block corruption message

Sébastien Szymanski <sebastien.szymanski@armadeus.com>
    ARM: dts: imx6ul: fix PWM[1-4] interrupts

Sergej Benilov <sergej.benilov@googlemail.com>
    sis900: fix TX completion

Takashi Iwai <tiwai@suse.de>
    ppp: mppe: Add softdep to arc4

Petr Oros <poros@redhat.com>
    be2net: fix link failure after ethtool offline test

Arnd Bergmann <arnd@arndb.de>
    ARM: omap2: remove incorrect __init annotation

Peter Zijlstra <peterz@infradead.org>
    perf/core: Fix perf_sample_regs_user() mm check

Mark Rutland <mark.rutland@arm.com>
    arm64: crypto: remove accidentally backported files

Masahiro Yamada <yamada.masahiro@socionext.com>
    nilfs2: do not use unexported cpu_to_le32()/le32_to_cpu() in uapi header

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    e1000e: start network tx queue only when link is up

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    Revert "e1000e: fix cyclic resets at link up with active tx"

Sean Young <sean@mess.org>
    MIPS: Remove superfluous check for __linux__

Vishnu DASA <vdasa@vmware.com>
    VMCI: Fix integer overflow in VMCI handle arrays

Christian Lamparter <chunkeey@gmail.com>
    carl9170: fix misuse of device driver API

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: amplc_pci230: fix null pointer deref on interrupt

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: dt282x: fix a null pointer deref on interrupt

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: renesas_usbhs: add a workaround for a race condition of workqueue

Kiruthika Varadarajan <Kiruthika.Varadarajan@harman.com>
    usb: gadget: ether: Fix race between gether_disconnect and rx_submit

Alan Stern <stern@rowland.harvard.edu>
    p54usb: Fix race between disconnect and firmware loading

Oliver Barta <o.barta89@gmail.com>
    Revert "serial: 8250: Don't service RX FIFO if interrupts are disabled"

Jörgen Storvist <jorgen.storvist@gmail.com>
    USB: serial: option: add support for GosunCn ME3630 RNDIS mode

Andreas Fritiofson <andreas.fritiofson@unjo.com>
    USB: serial: ftdi_sio: add ID for isodebug v1

Brian Norris <briannorris@chromium.org>
    mwifiex: Don't abort on small, spec-compliant vendor IEs

Hongjie Fang <hongjiefang@asrmicro.com>
    fscrypt: don't set policy for a dead directory

Takashi Iwai <tiwai@suse.de>
    mwifiex: Fix heap overflow in mwifiex_uap_parse_tail_ies()

Takashi Iwai <tiwai@suse.de>
    mwifiex: Abort at too short BSS descriptor element

Dianzhang Chen <dianzhangchen0@gmail.com>
    x86/tls: Fix possible spectre-v1 in do_get_thread_area()

Dianzhang Chen <dianzhangchen0@gmail.com>
    x86/ptrace: Fix possible spectre-v1 in ptrace_get_debugreg()

Steven J. Magnani <steve.magnani@digidescorp.com>
    udf: Fix incorrect final NOT_ALLOCATED (hole) extent length

Lin Yi <teroincn@163.com>
    net :sunrpc :clnt :Fix xps refcount imbalance on the error path

Xin Long <lucien.xin@gmail.com>
    ip6_tunnel: allow not to count pkts on tstats by passing dev as NULL

Mauro S. M. Rodrigues <maurosr@linux.vnet.ibm.com>
    bnx2x: Check if transceiver implements DDM before access

Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
    md: fix for divide error in status_resync

Yibo Zhao <yiboz@codeaurora.org>
    mac80211: only warn once on chanctx_conf being NULL

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    ARM: davinci: da8xx: specify dma_coherent_mask for lcdc

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    ARM: davinci: da850-evm: call regulator_has_full_constraints()

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum: Disallow prio-tagged packets when PVID is removed

Dave Martin <Dave.Martin@arm.com>
    KVM: arm/arm64: vgic: Fix kvm_device leak in vgic_its_destroy

Anson Huang <anson.huang@nxp.com>
    Input: imx_keypad - make sure keyboard can always wake up system

Sean Nyekjaer <sean@geanix.com>
    can: mcp251x: add support for mcp25625

Sean Nyekjaer <sean@geanix.com>
    dt-bindings: can: mcp251x: add mcp25625 support

Guillaume Nault <gnault@redhat.com>
    netfilter: ipv6: nf_defrag: accept duplicate fragments again

Guillaume Nault <gnault@redhat.com>
    netfilter: ipv6: nf_defrag: fix leakage of unqueued fragments

Takashi Iwai <tiwai@suse.de>
    mwifiex: Fix possible buffer overflows at parsing bss descriptor

Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
    mac80211: free peer keys before vif down in mesh

Thomas Pedersen <thomas@eero.com>
    mac80211: mesh: fix RCU warning

Melissa Wen <melissa.srw@gmail.com>
    staging:iio:ad7150: fix threshold mode config bit

Chang-Hsien Tsai <luke.tw@gmail.com>
    samples, bpf: fix to change the buffer size for read()

Aaron Ma <aaron.ma@canonical.com>
    Input: elantech - enable middle button support on 2 ThinkPads

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - rename alternative AEAD algos.


-------------

Diffstat:

 .../bindings/net/can/microchip,mcp251x.txt         |    1 +
 Makefile                                           |    4 +-
 arch/arc/kernel/unwind.c                           |    9 +-
 arch/arm/boot/dts/imx6ul.dtsi                      |    8 +-
 arch/arm/mach-davinci/board-da850-evm.c            |    2 +
 arch/arm/mach-davinci/devices-da8xx.c              |    3 +
 arch/arm/mach-omap2/prm3xxx.c                      |    2 +-
 arch/arm64/crypto/sha256-core.S                    | 2061 --------------------
 arch/arm64/crypto/sha512-core.S                    | 1085 -----------
 arch/mips/include/uapi/asm/sgidefs.h               |    8 -
 arch/s390/include/asm/facility.h                   |   21 +-
 arch/x86/kernel/ptrace.c                           |    5 +-
 arch/x86/kernel/tls.c                              |    9 +-
 drivers/crypto/talitos.c                           |   16 +-
 drivers/input/keyboard/imx_keypad.c                |   18 +-
 drivers/input/mouse/elantech.c                     |    2 +
 drivers/md/dm-verity-target.c                      |    4 +-
 drivers/md/md.c                                    |   36 +-
 drivers/misc/vmw_vmci/vmci_context.c               |   80 +-
 drivers/misc/vmw_vmci/vmci_handle_array.c          |   38 +-
 drivers/misc/vmw_vmci/vmci_handle_array.h          |   29 +-
 drivers/net/can/spi/Kconfig                        |    5 +-
 drivers/net/can/spi/mcp251x.c                      |   25 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c    |    3 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h   |    1 +
 drivers/net/ethernet/emulex/benet/be_ethtool.c     |   28 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |   21 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |    2 +-
 drivers/net/ethernet/sis/sis900.c                  |   16 +-
 drivers/net/ppp/ppp_mppe.c                         |    1 +
 drivers/net/wireless/ath/carl9170/usb.c            |   39 +-
 drivers/net/wireless/intersil/p54/p54usb.c         |   43 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |   12 +-
 drivers/net/wireless/marvell/mwifiex/ie.c          |   45 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |   31 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |    4 +-
 drivers/net/wireless/marvell/mwifiex/wmm.c         |    2 +-
 drivers/s390/cio/qdio_setup.c                      |    2 +
 drivers/s390/cio/qdio_thinint.c                    |    5 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |    3 +-
 drivers/staging/comedi/drivers/dt282x.c            |    3 +-
 drivers/staging/iio/cdc/ad7150.c                   |   19 +-
 drivers/tty/serial/8250/8250_port.c                |    3 +-
 drivers/usb/gadget/function/u_ether.c              |    6 +-
 drivers/usb/renesas_usbhs/fifo.c                   |   34 +-
 drivers/usb/serial/ftdi_sio.c                      |    1 +
 drivers/usb/serial/ftdi_sio_ids.h                  |    6 +
 drivers/usb/serial/option.c                        |    1 +
 fs/crypto/policy.c                                 |    2 +
 fs/udf/inode.c                                     |   93 +-
 include/linux/vmw_vmci_defs.h                      |   11 +-
 include/net/ip6_tunnel.h                           |    9 +-
 include/uapi/linux/nilfs2_ondisk.h                 |   24 +-
 kernel/events/core.c                               |    2 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |   22 +-
 net/mac80211/ieee80211_i.h                         |    2 +-
 net/mac80211/mesh.c                                |    6 +-
 net/sunrpc/clnt.c                                  |    1 +
 samples/bpf/bpf_load.c                             |    2 +-
 virt/kvm/arm/vgic/vgic-its.c                       |    1 +
 60 files changed, 516 insertions(+), 3461 deletions(-)


