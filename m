Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C825C03FF
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbiIUQXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbiIUQX2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:23:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197B46C111;
        Wed, 21 Sep 2022 09:06:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54DD8B830B8;
        Wed, 21 Sep 2022 15:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6176AC43149;
        Wed, 21 Sep 2022 15:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775521;
        bh=AQb4Y0w60HqF0h8kQLJ75Yf/Qlvcf8+N2uMMmKvSjWc=;
        h=From:To:Cc:Subject:Date:From;
        b=I5ZlVKw5kINStgRUtqRIcp5s45MazJxIe/B/OfWc0qQatBg6/BycLTgSDX31K4iYJ
         Wh0I0hd5qowSmlvWpjbPAmW6l5tXWQbTpLyB1siW1J86Tcro6GmeRX/S1sepQEed7B
         n+kflVE2EYB1wbu5pC0LxeOyUFfzaPF1B89WNgvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/39] 5.10.145-rc1 review
Date:   Wed, 21 Sep 2022 17:46:05 +0200
Message-Id: <20220921153645.663680057@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.145-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.145-rc1
X-KernelTest-Deadline: 2022-09-23T15:36+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.145 release.
There are 39 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 23 Sep 2022 15:36:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.145-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.145-rc1

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/sigmatel: Fix unused variable warning for beep power change

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    cgroup: Add missing cpus_read_lock() to cgroup_attach_task_all()

Hyunwoo Kim <imv4bel@gmail.com>
    video: fbdev: pxa3xx-gcu: Fix integer overflow in pxa3xx_gcu_write

Youling Tang <tangyouling@loongson.cn>
    mksysmap: Fix the mismatch of 'L0' symbols in System.map

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    MIPS: OCTEON: irq: Fix octeon_irq_force_ciu_mapping()

David Howells <dhowells@redhat.com>
    afs: Return -EAGAIN, not -EREMOTEIO, when a file already locked

jerry.meng <jerry-meng@foxmail.com>
    net: usb: qmi_wwan: add Quectel RM520N

Mohan Kumar <mkumard@nvidia.com>
    ALSA: hda/tegra: Align BDL entry to 4KB boundary

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/sigmatel: Keep power up while beep is enabled

Soenke Huster <soenke.huster@eknoes.de>
    wifi: mac80211_hwsim: check length for virtio packets

David Howells <dhowells@redhat.com>
    rxrpc: Fix calc of resend age

David Howells <dhowells@redhat.com>
    rxrpc: Fix local destruction being repeated

Xiaolei Wang <xiaolei.wang@windriver.com>
    regulator: pfuze100: Fix the global-out-of-bounds access in pfuze100_regulator_probe()

Takashi Iwai <tiwai@suse.de>
    ASoC: nau8824: Fix semaphore unbalance at error paths

Johan Hovold <johan@kernel.org>
    Revert "serial: 8250: Fix reporting real baudrate value in c_ospeed field"

Zheyu Ma <zheyuma97@gmail.com>
    video: fbdev: i740fb: Error out if 'pixclock' equals zero

Ben Hutchings <benh@debian.org>
    tools/include/uapi: Fix <asm/errno.h> for parisc and xtensa

Stefan Metzmacher <metze@samba.org>
    cifs: don't send down the destination address to sendmsg for a SOCK_STREAM

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: revalidate mapping when doing direct writes

Thierry Reding <treding@nvidia.com>
    of/device: Fix up of_dma_configure_id() stub

Yipeng Zou <zouyipeng@huawei.com>
    tracing: hold caller_addr to hardirq_{enable,disable}_ip

Yang Yingliang <yangyingliang@huawei.com>
    parisc: ccio-dma: Add missing iounmap in error path in ccio_probe()

Stuart Menefy <stuart.menefy@mathembedded.com>
    drm/meson: Fix OSD1 RGB to YCbCr coefficient

Stuart Menefy <stuart.menefy@mathembedded.com>
    drm/meson: Correct OSD1 global alpha value

Pali Rohár <pali@kernel.org>
    gpio: mpc8xxx: Fix support for IRQ_TYPE_LEVEL_LOW flow_type in mpc85xx

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Turn off open-by-filehandle and NFS re-export for NFSv4.0

Michael Wu <michael@allwinnertech.com>
    pinctrl: sunxi: Fix name for A100 R_PIO

Sergey Shtylyov <s.shtylyov@omp.ru>
    of: fdt: fix off-by-one error in unflatten_dt_nodes()

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: dsa: mv88e6xxx: allow use of PHYs on CPU and DSA ports

Alex Hung <alex.hung@canonical.com>
    platform/x86/intel: hid: add quirk to support Surface Go 3

Frank Li <Frank.Li@nxp.com>
    usb: cdns3: gadget: fix new urb never complete if ep cancel previous requests

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/mobility: ignore ibm, platform-facilities updates

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/mobility: refactor node lookup during DT update

Anatolij Gustschin <agust@denx.de>
    dmaengine: bestcomm: fix system boot lockups

John David Anglin <dave.anglin@bell.net>
    parisc: Flush kernel data mapping in set_pte_at() when installing pte for user page

Helge Deller <deller@gmx.de>
    parisc: Optimize per-pagetable spinlocks

Pali Rohár <pali@kernel.org>
    serial: 8250: Fix reporting real baudrate value in c_ospeed field

Laurent Vivier <lvivier@redhat.com>
    KVM: PPC: Tick accounting should defer vtime accounting 'til after IRQ handling

Nicholas Piggin <npiggin@gmail.com>
    KVM: PPC: Book3S HV: Context tracking exit guest context before enabling irqs


-------------

Diffstat:

 Makefile                                      |   4 +-
 arch/mips/cavium-octeon/octeon-irq.c          |  10 +++
 arch/parisc/Kconfig                           |  10 +++
 arch/parisc/include/asm/mmu_context.h         |   7 ++
 arch/parisc/include/asm/page.h                |   2 +-
 arch/parisc/include/asm/pgalloc.h             |  76 ++++-------------
 arch/parisc/include/asm/pgtable.h             |  97 ++++++---------------
 arch/parisc/kernel/asm-offsets.c              |   1 -
 arch/parisc/kernel/cache.c                    |   4 +-
 arch/parisc/kernel/entry.S                    | 116 +++++++++++---------------
 arch/parisc/mm/hugetlbpage.c                  |  13 ---
 arch/parisc/mm/init.c                         |  10 +--
 arch/powerpc/kvm/book3s_hv.c                  |  32 ++++++-
 arch/powerpc/kvm/booke.c                      |  16 +++-
 arch/powerpc/platforms/pseries/mobility.c     |  77 ++++++++++-------
 drivers/dma/bestcomm/ata.c                    |   2 +-
 drivers/dma/bestcomm/bestcomm.c               |  22 ++---
 drivers/dma/bestcomm/fec.c                    |   4 +-
 drivers/dma/bestcomm/gen_bd.c                 |   4 +-
 drivers/gpio/gpio-mpc8xxx.c                   |   1 +
 drivers/gpu/drm/meson/meson_plane.c           |   2 +-
 drivers/gpu/drm/meson/meson_viu.c             |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.c              |  64 +++++++-------
 drivers/net/usb/qmi_wwan.c                    |   1 +
 drivers/net/wireless/mac80211_hwsim.c         |   7 +-
 drivers/of/fdt.c                              |   2 +-
 drivers/parisc/ccio-dma.c                     |   1 +
 drivers/pinctrl/sunxi/pinctrl-sun50i-a100-r.c |   2 +-
 drivers/platform/x86/intel-hid.c              |   7 ++
 drivers/regulator/pfuze100-regulator.c        |   2 +-
 drivers/usb/cdns3/gadget.c                    |  20 +----
 drivers/video/fbdev/i740fb.c                  |   3 +
 drivers/video/fbdev/pxa3xx-gcu.c              |   2 +-
 fs/afs/misc.c                                 |   1 +
 fs/cifs/file.c                                |   3 +
 fs/cifs/transport.c                           |   4 +-
 fs/nfs/super.c                                |  27 ++++--
 include/linux/of_device.h                     |   5 +-
 kernel/cgroup/cgroup-v1.c                     |   2 +
 kernel/trace/trace_preemptirq.c               |   6 +-
 net/rxrpc/call_event.c                        |   2 +-
 net/rxrpc/local_object.c                      |   3 +
 scripts/mksysmap                              |   2 +-
 sound/pci/hda/hda_tegra.c                     |   3 +-
 sound/pci/hda/patch_sigmatel.c                |  24 ++++++
 sound/soc/codecs/nau8824.c                    |  17 ++--
 tools/include/uapi/asm/errno.h                |   4 +-
 47 files changed, 378 insertions(+), 348 deletions(-)


