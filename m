Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661D85E7B10
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 14:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbiIWMrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 08:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbiIWMrc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 08:47:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C79138F0A;
        Fri, 23 Sep 2022 05:47:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3070CB82133;
        Fri, 23 Sep 2022 12:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A741C433C1;
        Fri, 23 Sep 2022 12:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663937246;
        bh=Wo5QeW2M/qffFzfoc+Y0mEA9lIje6klF2+baCQrRGcU=;
        h=From:To:Cc:Subject:Date:From;
        b=mWV5AMt3VkAgHKawfV94wo2Rgf6NfFYCtXf6dOe4LjM5idW21RoekIlIJeZab6Opb
         pIIo/AR/NMFsY+vpDB0V5lvC/eCpYduPHvIn7I01gQe19pLx+HAC8RAGb/CkJ/61Om
         aGWEsQ57TDokbJgqcSwH7zKOOQrflrHec71LfwBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.70
Date:   Fri, 23 Sep 2022 14:47:11 +0200
Message-Id: <1663937231121107@kroah.com>
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

I'm announcing the release of the 5.15.70 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                      |    2 -
 arch/arm64/boot/dts/arm/juno-base.dtsi        |    3 +-
 arch/mips/cavium-octeon/octeon-irq.c          |   10 +++++++++
 arch/parisc/Kconfig                           |   12 ++++++++++-
 arch/x86/include/asm/kvm-x86-ops.h            |    1 
 arch/x86/include/asm/kvm_host.h               |    1 
 arch/x86/kvm/svm/sev.c                        |    8 +++++++
 arch/x86/kvm/svm/svm.c                        |    1 
 arch/x86/kvm/svm/svm.h                        |    2 +
 arch/x86/kvm/x86.c                            |    5 ++++
 block/blk-core.c                              |    4 +--
 drivers/android/binder_alloc.c                |    7 ------
 drivers/gpio/gpio-mpc8xxx.c                   |    1 
 drivers/gpio/gpio-rockchip.c                  |    4 +--
 drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c        |    9 +++++++-
 drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c        |    9 +++++++-
 drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c        |    9 +++++++-
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c        |    5 ++++
 drivers/gpu/drm/amd/amdgpu/soc15.c            |   25 ------------------------
 drivers/gpu/drm/amd/amdgpu/vega10_ih.c        |    4 +++
 drivers/gpu/drm/amd/amdgpu/vega20_ih.c        |    4 +++
 drivers/gpu/drm/meson/meson_plane.c           |    2 -
 drivers/gpu/drm/meson/meson_viu.c             |    2 -
 drivers/gpu/drm/panfrost/panfrost_devfreq.c   |   11 ++++++++++
 drivers/gpu/drm/tegra/vic.c                   |    4 +--
 drivers/net/usb/qmi_wwan.c                    |    1 
 drivers/net/wireless/mac80211_hwsim.c         |    7 +++++-
 drivers/of/fdt.c                              |    2 -
 drivers/parisc/ccio-dma.c                     |    1 
 drivers/pinctrl/qcom/pinctrl-sc8180x.c        |   10 ++++-----
 drivers/pinctrl/sunxi/pinctrl-sun50i-a100-r.c |    2 -
 drivers/regulator/pfuze100-regulator.c        |    2 -
 drivers/scsi/lpfc/lpfc_scsi.c                 |    4 +--
 drivers/tty/serial/atmel_serial.c             |    8 +------
 drivers/video/fbdev/i740fb.c                  |    3 ++
 drivers/video/fbdev/pxa3xx-gcu.c              |    2 -
 fs/afs/misc.c                                 |    1 
 fs/cifs/connect.c                             |   11 ++--------
 fs/cifs/file.c                                |    3 ++
 fs/cifs/transport.c                           |    6 -----
 fs/nfs/super.c                                |   27 +++++++++++++++++---------
 include/linux/kvm_host.h                      |    2 +
 include/linux/of_device.h                     |    5 ++--
 include/net/xfrm.h                            |    2 +
 kernel/cgroup/cgroup-v1.c                     |    2 +
 net/ipv4/ip_output.c                          |    2 -
 net/ipv4/tcp_ipv4.c                           |    2 +
 net/ipv6/tcp_ipv6.c                           |    5 +++-
 net/rxrpc/call_event.c                        |    2 -
 net/rxrpc/local_object.c                      |    3 ++
 scripts/mksysmap                              |    2 -
 sound/pci/hda/hda_tegra.c                     |    3 +-
 sound/pci/hda/patch_sigmatel.c                |   24 +++++++++++++++++++++++
 sound/soc/codecs/nau8824.c                    |   17 +++++++++-------
 tools/include/uapi/asm/errno.h                |    4 +--
 virt/kvm/kvm_main.c                           |   27 +++++++++++++++++++++++---
 56 files changed, 232 insertions(+), 105 deletions(-)

Alex Deucher (2):
      drm/amdgpu: move nbio ih_doorbell_range() into ih code for vega
      drm/amdgpu: move nbio sdma_doorbell_range() into sdma code for vega

Alexander Sverdlin (1):
      MIPS: OCTEON: irq: Fix octeon_irq_force_ciu_mapping()

Ben Hutchings (1):
      tools/include/uapi: Fix <asm/errno.h> for parisc and xtensa

Carlos Llamas (1):
      binder: remove inaccurate mmap_assert_locked()

Clément Péron (1):
      drm/panfrost: devfreq: set opp to the recommended one to configure regulator

David Howells (3):
      rxrpc: Fix local destruction being repeated
      rxrpc: Fix calc of resend age
      afs: Return -EAGAIN, not -EREMOTEIO, when a file already locked

Greg Kroah-Hartman (1):
      Linux 5.15.70

Hannes Reinecke (1):
      scsi: lpfc: Return DID_TRANSPORT_DISRUPTED instead of DID_REQUEUE

Helge Deller (1):
      parisc: Allow CONFIG_64BIT with ARCH=parisc

Hyunwoo Kim (1):
      video: fbdev: pxa3xx-gcu: Fix integer overflow in pxa3xx_gcu_write

Jassi Brar (1):
      arm64: dts: juno: Add missing MHU secure-irq

João H. Spies (1):
      pinctrl: rockchip: Enhance support for IRQ_TYPE_EDGE_BOTH

Lijo Lazar (1):
      drm/amdgpu: Don't enable LTR if not supported

Lino Sanfilippo (1):
      serial: atmel: remove redundant assignment in rs485_config

Michael Wu (1):
      pinctrl: sunxi: Fix name for A100 R_PIO

Mingwei Zhang (1):
      KVM: SEV: add cache flush to solve SEV cache incoherency issues

Mohan Kumar (1):
      ALSA: hda/tegra: Align BDL entry to 4KB boundary

Molly Sophia (2):
      pinctrl: qcom: sc8180x: Fix gpio_wakeirq_map
      pinctrl: qcom: sc8180x: Fix wrong pin numbers

Pali Rohár (1):
      gpio: mpc8xxx: Fix support for IRQ_TYPE_LEVEL_LOW flow_type in mpc85xx

Ronnie Sahlberg (1):
      cifs: revalidate mapping when doing direct writes

Sergey Shtylyov (1):
      of: fdt: fix off-by-one error in unflatten_dt_nodes()

Sergiu Moga (1):
      tty: serial: atmel: Preserve previous USART mode if RS485 disabled

Soenke Huster (1):
      wifi: mac80211_hwsim: check length for virtio packets

Stefan Metzmacher (2):
      cifs: don't send down the destination address to sendmsg for a SOCK_STREAM
      cifs: always initialize struct msghdr smb_msg completely

Stefan Roesch (1):
      block: blk_queue_enter() / __bio_queue_enter() must return -EAGAIN for nowait

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

Youling Tang (1):
      mksysmap: Fix the mismatch of 'L0' symbols in System.map

YueHaibing (1):
      drm/tegra: vic: Fix build warning when CONFIG_PM=n

Zheyu Ma (1):
      video: fbdev: i740fb: Error out if 'pixclock' equals zero

jerry.meng (1):
      net: usb: qmi_wwan: add Quectel RM520N

sewookseo (1):
      net: Find dst with sk's xfrm policy not ctl_sk

