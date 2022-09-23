Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0E85E7B0A
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 14:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiIWMrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 08:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiIWMrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 08:47:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DA013570D;
        Fri, 23 Sep 2022 05:47:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39E82B82133;
        Fri, 23 Sep 2022 12:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838B8C433D6;
        Fri, 23 Sep 2022 12:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663937235;
        bh=3pbsewwaw/CpaSy16xA/2TfxstKLe6ScbD7aJmef6Dw=;
        h=From:To:Cc:Subject:Date:From;
        b=0CKmH3zUMPrsoMaPxusj1/dJEA3u6rTWCZjL/mHU34z+yqPKZgMQd/qOypUSKySVp
         zIVhGY5/riO8HEyAbFSHFOm9/UJqlSoPMJ1DtgP50o+BcOF9v21fE0A1bVcGfj964H
         ILaCnTXVUNNBnUTnsFPj+jwm/b/gHNjUgVJTSSmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.145
Date:   Fri, 23 Sep 2022 14:47:06 +0200
Message-Id: <16639372271583@kroah.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
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

I'm announcing the release of the 5.10.145 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                      |    2 
 arch/mips/cavium-octeon/octeon-irq.c          |   10 ++
 arch/parisc/Kconfig                           |   10 ++
 arch/parisc/include/asm/mmu_context.h         |    7 +
 arch/parisc/include/asm/page.h                |    2 
 arch/parisc/include/asm/pgalloc.h             |   76 ++++-------------
 arch/parisc/include/asm/pgtable.h             |   97 +++++----------------
 arch/parisc/kernel/asm-offsets.c              |    1 
 arch/parisc/kernel/cache.c                    |    4 
 arch/parisc/kernel/entry.S                    |  116 +++++++++++---------------
 arch/parisc/mm/hugetlbpage.c                  |   13 --
 arch/parisc/mm/init.c                         |   10 +-
 arch/powerpc/kvm/book3s_hv.c                  |   32 ++++++-
 arch/powerpc/kvm/booke.c                      |   16 +++
 arch/powerpc/platforms/pseries/mobility.c     |   77 ++++++++++-------
 drivers/dma/bestcomm/ata.c                    |    2 
 drivers/dma/bestcomm/bestcomm.c               |   22 ++--
 drivers/dma/bestcomm/fec.c                    |    4 
 drivers/dma/bestcomm/gen_bd.c                 |    4 
 drivers/gpio/gpio-mpc8xxx.c                   |    1 
 drivers/gpu/drm/meson/meson_plane.c           |    2 
 drivers/gpu/drm/meson/meson_viu.c             |    2 
 drivers/net/dsa/mv88e6xxx/chip.c              |   64 +++++++-------
 drivers/net/usb/qmi_wwan.c                    |    1 
 drivers/net/wireless/mac80211_hwsim.c         |    7 +
 drivers/of/fdt.c                              |    2 
 drivers/parisc/ccio-dma.c                     |    1 
 drivers/pinctrl/sunxi/pinctrl-sun50i-a100-r.c |    2 
 drivers/platform/x86/intel-hid.c              |    7 +
 drivers/regulator/pfuze100-regulator.c        |    2 
 drivers/usb/cdns3/gadget.c                    |   20 ----
 drivers/video/fbdev/i740fb.c                  |    3 
 drivers/video/fbdev/pxa3xx-gcu.c              |    2 
 fs/afs/misc.c                                 |    1 
 fs/cifs/file.c                                |    3 
 fs/cifs/transport.c                           |    4 
 fs/nfs/super.c                                |   27 ++++--
 include/linux/of_device.h                     |    5 -
 kernel/cgroup/cgroup-v1.c                     |    2 
 kernel/trace/trace_preemptirq.c               |    6 -
 net/rxrpc/call_event.c                        |    2 
 net/rxrpc/local_object.c                      |    3 
 scripts/mksysmap                              |    2 
 sound/pci/hda/hda_tegra.c                     |    3 
 sound/pci/hda/patch_sigmatel.c                |   24 +++++
 sound/soc/codecs/nau8824.c                    |   17 ++-
 tools/include/uapi/asm/errno.h                |    4 
 47 files changed, 377 insertions(+), 347 deletions(-)

Alex Hung (1):
      platform/x86/intel: hid: add quirk to support Surface Go 3

Alexander Sverdlin (1):
      MIPS: OCTEON: irq: Fix octeon_irq_force_ciu_mapping()

Anatolij Gustschin (1):
      dmaengine: bestcomm: fix system boot lockups

Ben Hutchings (1):
      tools/include/uapi: Fix <asm/errno.h> for parisc and xtensa

David Howells (3):
      rxrpc: Fix local destruction being repeated
      rxrpc: Fix calc of resend age
      afs: Return -EAGAIN, not -EREMOTEIO, when a file already locked

Frank Li (1):
      usb: cdns3: gadget: fix new urb never complete if ep cancel previous requests

Greg Kroah-Hartman (1):
      Linux 5.10.145

Helge Deller (1):
      parisc: Optimize per-pagetable spinlocks

Hyunwoo Kim (1):
      video: fbdev: pxa3xx-gcu: Fix integer overflow in pxa3xx_gcu_write

Johan Hovold (1):
      Revert "serial: 8250: Fix reporting real baudrate value in c_ospeed field"

John David Anglin (1):
      parisc: Flush kernel data mapping in set_pte_at() when installing pte for user page

Laurent Vivier (1):
      KVM: PPC: Tick accounting should defer vtime accounting 'til after IRQ handling

Michael Wu (1):
      pinctrl: sunxi: Fix name for A100 R_PIO

Mohan Kumar (1):
      ALSA: hda/tegra: Align BDL entry to 4KB boundary

Nathan Lynch (2):
      powerpc/pseries/mobility: refactor node lookup during DT update
      powerpc/pseries/mobility: ignore ibm, platform-facilities updates

Nicholas Piggin (1):
      KVM: PPC: Book3S HV: Context tracking exit guest context before enabling irqs

Pali Rohár (2):
      serial: 8250: Fix reporting real baudrate value in c_ospeed field
      gpio: mpc8xxx: Fix support for IRQ_TYPE_LEVEL_LOW flow_type in mpc85xx

Ronnie Sahlberg (1):
      cifs: revalidate mapping when doing direct writes

Russell King (Oracle) (1):
      net: dsa: mv88e6xxx: allow use of PHYs on CPU and DSA ports

Sergey Shtylyov (1):
      of: fdt: fix off-by-one error in unflatten_dt_nodes()

Soenke Huster (1):
      wifi: mac80211_hwsim: check length for virtio packets

Stefan Metzmacher (1):
      cifs: don't send down the destination address to sendmsg for a SOCK_STREAM

Stuart Menefy (2):
      drm/meson: Correct OSD1 global alpha value
      drm/meson: Fix OSD1 RGB to YCbCr coefficient

Takashi Iwai (3):
      ASoC: nau8824: Fix semaphore unbalance at error paths
      ALSA: hda/sigmatel: Keep power up while beep is enabled
      ALSA: hda/sigmatel: Fix unused variable warning for beep power change

Tetsuo Handa (1):
      cgroup: Add missing cpus_read_lock() to cgroup_attach_task_all()

Thierry Reding (1):
      of/device: Fix up of_dma_configure_id() stub

Trond Myklebust (1):
      NFSv4: Turn off open-by-filehandle and NFS re-export for NFSv4.0

Xiaolei Wang (1):
      regulator: pfuze100: Fix the global-out-of-bounds access in pfuze100_regulator_probe()

Yang Yingliang (1):
      parisc: ccio-dma: Add missing iounmap in error path in ccio_probe()

Yipeng Zou (1):
      tracing: hold caller_addr to hardirq_{enable,disable}_ip

Youling Tang (1):
      mksysmap: Fix the mismatch of 'L0' symbols in System.map

Zheyu Ma (1):
      video: fbdev: i740fb: Error out if 'pixclock' equals zero

jerry.meng (1):
      net: usb: qmi_wwan: add Quectel RM520N

