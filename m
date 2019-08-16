Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E449A90039
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 12:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbfHPKt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 06:49:28 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34756 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfHPKt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 06:49:27 -0400
Received: by mail-pg1-f195.google.com with SMTP id n9so2782125pgc.1;
        Fri, 16 Aug 2019 03:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ALT2zVPfrpiV9w+qHWfwMLqCQXgrH0vqOfd1TFdnhuw=;
        b=BvzE01tIaPGXXcqH7+eQ38JfRspqVD1GYF5c55Qd7iCP0UQ2awR90rUOi/wQu9WpkY
         +zI7rjH3kHWDGlQ3RMwD1jzuxnFPeiSaq36sSWwYGwjMiVTJofSb02OQRXI1K1YA3bHb
         sxbCz+LuIn0wNC4wI/hOQwb5sSFN0vu7ahAMfdbeN6qaMLQUyhxS/gZu8rVHJolNw7sC
         2z0eQkTb2F2AbwTHtr7vdT5jaDQSRhGfD0e1LCfHYdmUCT1s4cZArQirFzoZqzzynHF6
         8+3XHH8ZXfZWotwURxxpZdSk0msIPcqIHDniU6OyPJRM6WEZ2mrqpryQu++2E5Pog9YC
         s6jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ALT2zVPfrpiV9w+qHWfwMLqCQXgrH0vqOfd1TFdnhuw=;
        b=BisjOEVZdibnkmvb/7IwMmUwkM0QXcFtIE1iOuJeFKMCxkwXmAiCb9cVQN8iuI8dLg
         uus1pXEtEtg3KQAf5LwoS7J3HKEBd9qCHf6wrJh3j7oMZx4by1kJWZ2z/SAW6XBSIGjH
         G9HQlVxpUqZPdP3KFPnuyQ4MOpe4STAKuy1RKu6JuAkVuRn/LemuOlUx9LGk8qzdrN/p
         oQcSIP2y7csswjOAsd4K4k9t22N6raSiaFkGuiPjbNhGvaujYrIcb41sU2PUIsxoh1I4
         iEuwbiI0WyU3toVjbefq46OVyV5Lgfh0ZAN1oqoQOVFWVHlT8pGtfuoH3Q1nHhQzwgA+
         qrLg==
X-Gm-Message-State: APjAAAVFm8a0mbXBLYxoDzp7CtPPeXWhj3ot2hjqMfuwCLv92IIm59r+
        7Diuh3qA9BkSFxbSM9RujF4=
X-Google-Smtp-Source: APXvYqxawkkmkCRadfZ25/Ngs8CneTxhyIGmB1dL5w4hhOfbPX2SfzvBFghfJvqwMFLVTJ+KO7aIKg==
X-Received: by 2002:a65:50c5:: with SMTP id s5mr7235937pgp.368.1565952566022;
        Fri, 16 Aug 2019 03:49:26 -0700 (PDT)
Received: from Slackware ([103.231.91.68])
        by smtp.gmail.com with ESMTPSA id v189sm8012012pfv.176.2019.08.16.03.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 03:49:24 -0700 (PDT)
Date:   Fri, 16 Aug 2019 16:19:11 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.2.9
Message-ID: <20190816104911.GA19729@Slackware>
References: <20190816094508.GA8784@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <20190816094508.GA8784@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Thanks, a bunch Greg! :)

On 11:45 Fri 16 Aug 2019, Greg KH wrote:
>I'm announcing the release of the 5.2.9 kernel.
>
>All users of the 5.2 kernel series must upgrade.
>
>The updated 5.2.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git lin=
ux-5.2.y
>and can be browsed at the normal kernel.org git web browser:
>	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3D=
summary
>
>thanks,
>
>greg k-h
>
>------------
>
> Makefile                                                  |    2
> arch/arm/boot/dts/bcm47094-linksys-panamera.dts           |    3
> arch/arm/boot/dts/imx6ul-14x14-evk.dtsi                   |    2
> arch/arm/boot/dts/imx6ul-geam.dts                         |    2
> arch/arm/boot/dts/imx6ul-isiot.dtsi                       |    2
> arch/arm/boot/dts/imx6ul-pico-hobbit.dts                  |    2
> arch/arm/boot/dts/imx6ul-pico-pi.dts                      |    4
> arch/arm/mach-davinci/sleep.S                             |    1
> arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h            |    4
> arch/arm64/boot/dts/freescale/imx8mq.dtsi                 |    3
> arch/arm64/include/asm/processor.h                        |   14 +
> arch/arm64/kernel/entry.S                                 |   22 +
> arch/arm64/kernel/process.c                               |   29 ++
> arch/powerpc/kvm/powerpc.c                                |    5
> arch/powerpc/mm/mem.c                                     |    2
> arch/powerpc/platforms/pseries/papr_scm.c                 |   15 +
> arch/s390/include/asm/page.h                              |    2
> arch/x86/boot/string.c                                    |    8
> arch/x86/events/intel/core.c                              |    7
> arch/x86/events/intel/ds.c                                |    2
> arch/x86/include/asm/kvm_host.h                           |    1
> arch/x86/kvm/svm.c                                        |   10
> arch/x86/kvm/vmx/vmx.c                                    |    6
> arch/x86/kvm/x86.c                                        |   16 +
> arch/x86/mm/fault.c                                       |   15 -
> arch/x86/purgatory/Makefile                               |   36 ++-
> arch/x86/purgatory/purgatory.c                            |    6
> arch/x86/purgatory/string.c                               |   23 -
> block/blk-rq-qos.c                                        |    6
> drivers/acpi/arm64/iort.c                                 |    4
> drivers/base/platform.c                                   |    9
> drivers/block/drbd/drbd_receiver.c                        |   14 +
> drivers/block/loop.c                                      |    2
> drivers/cpufreq/pasemi-cpufreq.c                          |   23 -
> drivers/crypto/ccp/ccp-crypto-aes-galois.c                |   14 +
> drivers/crypto/ccp/ccp-ops.c                              |   33 ++
> drivers/firmware/Kconfig                                  |    5
> drivers/firmware/iscsi_ibft.c                             |    4
> drivers/gpu/drm/amd/display/dc/core/dc.c                  |    6
> drivers/gpu/drm/amd/display/dc/core/dc_link.c             |    9
> drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c          |    9
> drivers/gpu/drm/amd/display/dc/core/dc_resource.c         |   11
> drivers/gpu/drm/amd/display/dc/dce/dce_abm.c              |    4
> drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c |   21 -
> drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c     |    2
> drivers/gpu/drm/amd/display/dc/inc/core_types.h           |    2
> drivers/gpu/drm/amd/display/dc/inc/hw/hw_shared.h         |    1
> drivers/gpu/drm/drm_framebuffer.c                         |    2
> drivers/gpu/drm/i915/vlv_dsi_pll.c                        |    4
> drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c               |    3
> drivers/hid/hid-sony.c                                    |   15 +
> drivers/hwmon/lm75.c                                      |    2
> drivers/hwmon/nct6775.c                                   |    3
> drivers/hwmon/nct7802.c                                   |    6
> drivers/hwmon/occ/common.c                                |    6
> drivers/hwtracing/coresight/coresight-etm-perf.c          |    1
> drivers/iio/accel/cros_ec_accel_legacy.c                  |    1
> drivers/iio/adc/ingenic-adc.c                             |   54 ++++
> drivers/iio/adc/max9611.c                                 |    2
> drivers/iio/adc/rcar-gyroadc.c                            |    4
> drivers/iio/imu/inv_mpu6050/inv_mpu_core.c                |   43 +++
> drivers/input/mouse/elantech.c                            |   54 ++--
> drivers/input/mouse/synaptics.c                           |    1
> drivers/input/touchscreen/usbtouchscreen.c                |    2
> drivers/iommu/intel-iommu.c                               |    8
> drivers/mmc/host/cavium.c                                 |    4
> drivers/net/can/flexcan.c                                 |   39 ++-
> drivers/net/can/rcar/rcar_canfd.c                         |    9
> drivers/net/can/usb/peak_usb/pcan_usb_core.c              |    8
> drivers/net/can/usb/peak_usb/pcan_usb_fd.c                |    2
> drivers/net/can/usb/peak_usb/pcan_usb_pro.c               |    2
> drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c      |    3
> drivers/net/wireless/intel/iwlwifi/mvm/fw.c               |   29 +-
> drivers/net/wireless/intel/iwlwifi/mvm/tx.c               |    3
> drivers/net/wireless/intel/iwlwifi/pcie/tx.c              |    2
> drivers/net/wireless/marvell/mwifiex/main.h               |    1
> drivers/net/wireless/marvell/mwifiex/scan.c               |    3
> drivers/nvme/host/core.c                                  |   12 -
> drivers/nvme/host/pci.c                                   |    2
> drivers/pci/pci.c                                         |   29 --
> drivers/pci/pci.h                                         |    1
> drivers/pci/pcie/portdrv_core.c                           |   66 -----
> drivers/s390/cio/qdio_main.c                              |   12 -
> drivers/s390/cio/vfio_ccw_cp.c                            |    4
> drivers/s390/cio/vfio_ccw_drv.c                           |    2
> drivers/scsi/device_handler/scsi_dh_alua.c                |    7
> drivers/scsi/ibmvscsi/ibmvfc.c                            |    2
> drivers/scsi/megaraid/megaraid_sas_base.c                 |    3
> drivers/staging/android/ion/ion_page_pool.c               |    3
> drivers/staging/fbtft/fbtft-core.c                        |   43 +--
> drivers/staging/gasket/apex_driver.c                      |    2
> drivers/staging/wilc1000/wilc_wfi_cfgoperations.c         |    1
> drivers/tty/tty_ldsem.c                                   |    5
> drivers/usb/core/devio.c                                  |    2
> drivers/usb/host/xhci-rcar.c                              |    9
> drivers/usb/misc/iowarrior.c                              |    7
> drivers/usb/misc/rio500.c                                 |   43 ++-
> drivers/usb/misc/yurex.c                                  |    2
> drivers/usb/typec/tcpm/tcpm.c                             |   58 +++-
> drivers/usb/typec/ucsi/ucsi_ccg.c                         |    2
> fs/block_dev.c                                            |    5
> fs/cifs/smb2pdu.c                                         |    7
> fs/dax.c                                                  |    2
> fs/gfs2/bmap.c                                            |  164 ++++++++=
------
> fs/nfs/delegation.c                                       |    2
> fs/nfs/delegation.h                                       |    2
> fs/nfs/nfs4proc.c                                         |   39 +--
> include/kvm/arm_vgic.h                                    |    1
> include/linux/ccp.h                                       |    2
> include/linux/kvm_host.h                                  |    1
> include/sound/compress_driver.h                           |    5
> include/uapi/linux/nl80211.h                              |    2
> kernel/events/core.c                                      |    2
> kernel/irq/affinity.c                                     |    6
> lib/test_firmware.c                                       |    5
> mm/vmalloc.c                                              |    9
> net/ipv4/netfilter/ipt_rpfilter.c                         |    1
> net/ipv6/netfilter/ip6t_rpfilter.c                        |    8
> net/mac80211/cfg.c                                        |    8
> net/mac80211/driver-ops.c                                 |   13 -
> net/mac80211/mlme.c                                       |   10
> net/netfilter/nf_conntrack_proto_tcp.c                    |    8
> net/netfilter/nfnetlink.c                                 |    2
> net/netfilter/nft_chain_nat.c                             |    3
> net/netfilter/nft_hash.c                                  |    2
> net/netfilter/nft_redir.c                                 |    2
> scripts/gen_compile_commands.py                           |    4
> scripts/sphinx-pre-install                                |   74 ++++--
> sound/core/compress_offload.c                             |   60 ++++-
> sound/firewire/packets-buffer.c                           |    2
> sound/pci/hda/hda_controller.c                            |   13 -
> sound/pci/hda/hda_controller.h                            |    2
> sound/pci/hda/hda_intel.c                                 |   63 +++++
> sound/sound_core.c                                        |    3
> sound/usb/hiface/pcm.c                                    |   11
> sound/usb/stream.c                                        |    1
> tools/perf/arch/s390/util/machine.c                       |   31 ++
> tools/perf/builtin-probe.c                                |   10
> tools/perf/builtin-script.c                               |    2
> tools/perf/builtin-stat.c                                 |    9
> tools/perf/util/evsel.c                                   |    2
> tools/perf/util/header.c                                  |    2
> tools/perf/util/machine.c                                 |    3
> tools/perf/util/machine.h                                 |    2
> tools/perf/util/session.c                                 |   22 +
> tools/perf/util/session.h                                 |    1
> tools/perf/util/symbol.c                                  |    7
> tools/perf/util/symbol.h                                  |    1
> tools/perf/util/thread.c                                  |   12 -
> tools/perf/util/zstd.c                                    |    4
> virt/kvm/arm/arm.c                                        |   11
> virt/kvm/arm/vgic/vgic-v2.c                               |    9
> virt/kvm/arm/vgic/vgic-v3.c                               |    7
> virt/kvm/arm/vgic/vgic.c                                  |   11
> virt/kvm/arm/vgic/vgic.h                                  |    2
> virt/kvm/kvm_main.c                                       |   25 ++
> 156 files changed, 1222 insertions(+), 551 deletions(-)
>
>Adham Abozaeid (1):
>      staging: wilc1000: flush the workqueue before deinit the host
>
>Adrian Hunter (1):
>      perf db-export: Fix thread__exec_comm()
>
>Alexey Budankov (1):
>      perf session: Fix loading of compressed data split across adjacent r=
ecords
>
>Alvin Lee (1):
>      drm/amd/display: Only enable audio if speaker allocation exists
>
>Andi Kleen (1):
>      perf script: Fix off by one in brstackinsn IPC computation
>
>Andrea Arcangeli (1):
>      powerpc: fix off by one in max_zone_pfn initialization for ZONE_DMA
>
>Andreas Gruenbacher (1):
>      gfs2: gfs2_walk_metadata fix
>
>Anson Huang (1):
>      arm64: dts: imx8mm: Correct SAI3 RXC/TXFS pin's mux option #1
>
>Arnaldo Carvalho de Melo (1):
>      perf probe: Avoid calling freeing routine multiple times for same po=
inter
>
>Arnd Bergmann (4):
>      iio: adc: gyroadc: fix uninitialized return code
>      drbd: dynamically allocate shash descriptor
>      ARM: davinci: fix sleep.S build error on ARMv4
>      ARM: dts: bcm: bcm47094: add missing #cells for mdio-bus-mux
>
>Bj=F6rn Gerhart (1):
>      hwmon: (nct6775) Fix register address and added missed tolerance for=
 nct6106
>
>Brian Norris (4):
>      driver core: platform: return -ENXIO for missing GpioInt
>      mac80211: don't warn about CW params when not using them
>      mac80211: don't WARN on short WMM parameters from AP
>      mwifiex: fix 802.11n/WPA detection
>
>Charles Keepax (4):
>      ALSA: compress: Fix regression on compressed capture streams
>      ALSA: compress: Prevent bypasses of set_params
>      ALSA: compress: Don't allow paritial drain operations on capture str=
eams
>      ALSA: compress: Be more restrictive about when a drain is allowed
>
>Christian Hesse (1):
>      netfilter: nf_tables: fix module autoload for redir
>
>Derek Lai (1):
>      drm/amd/display: allocate 4 ddc engines for RV2
>
>Dmitry Safonov (1):
>      iommu/vt-d: Check if domain->pgd was allocated
>
>Dmitry Torokhov (1):
>      Input: synaptics - enable RMI mode for HP Spectre X360
>
>Emmanuel Grumbach (3):
>      iwlwifi: don't unmap as page memory that was mapped as single
>      iwlwifi: mvm: fix an out-of-bound access
>      iwlwifi: mvm: fix a use-after-free bug in iwl_mvm_tx_tso_segment
>
>Eric Yang (1):
>      drm/amd/display: put back front end initialization sequence
>
>Farhan Ali (2):
>      vfio-ccw: Set pa_nr to 0 if memory allocation fails for pa_iova_pfn
>      vfio-ccw: Don't call cp_free if we are processing a channel program
>
>Florian Westphal (2):
>      netfilter: nfnetlink: avoid deadlock due to synchronous request_modu=
le
>      netfilter: conntrack: always store window size un-scaled
>
>Gary R Hook (3):
>      crypto: ccp - Fix oops by properly managing allocated structures
>      crypto: ccp - Add support for valid authsize values less than 16
>      crypto: ccp - Ignore tag length when decrypting GCM ciphertext
>
>Gavin Li (1):
>      usb: usbfs: fix double-free of usb memory upon submiturb error
>
>Greg Kroah-Hartman (1):
>      Linux 5.2.9
>
>Guenter Roeck (3):
>      usb: typec: tcpm: Add NULL check before dereferencing config
>      usb: typec: tcpm: Ignore unsupported/unknown alternate mode requests
>      hwmon: (nct7802) Fix wrong detection of in4 presence
>
>Gwendal Grignou (1):
>      iio: cros_ec_accel_legacy: Fix incorrect channel setting
>
>Halil Pasic (1):
>      s390/dma: provide proper ARCH_ZONE_DMA_BITS value
>
>Hannes Reinecke (1):
>      scsi: scsi_dh_alua: always use a 2 second delay before retrying RTPG
>
>Harmanprit Tatla (1):
>      drm/amd/display: No audio endpoint for Dell MST display
>
>Heikki Krogerus (1):
>      usb: typec: ucsi: ccg: Fix uninitilized symbol error
>
>Iker Perez del Palomar Sustatxa (1):
>      hwmon: (lm75) Fixup tmp75b clr_mask
>
>Ivan Bornyakov (1):
>      staging: gasket: apex: fix copy-paste typo
>
>James Morse (1):
>      arm64: entry: SP Alignment Fault doesn't write to FAR_EL1
>
>Jan Kara (1):
>      bdev: Fixup error handling in blkdev_get()
>
>Jean-Baptiste Maneyrol (1):
>      iio: imu: mpu6050: add missing available scan masks
>
>Jiri Olsa (2):
>      perf tools: Fix proper buffer size for feature processing
>      perf stat: Fix segfault for event group in repeat mode
>
>Joakim Zhang (1):
>      can: flexcan: fix stop mode acknowledgment
>
>Joe Perches (1):
>      iio: adc: max9611: Fix misuse of GENMASK macro
>
>Joerg Roedel (3):
>      x86/mm: Check for pfn instead of page in vmalloc_sync_one()
>      x86/mm: Sync also unmappings in vmalloc_sync_all()
>      mm/vmalloc: Sync unmappings in __purge_vmap_area_lazy()
>
>John Crispin (1):
>      nl80211: fix NL80211_HE_MAX_CAPABILITY_LEN
>
>Josef Bacik (3):
>      rq-qos: don't reset has_sleepers on spurious wakeups
>      rq-qos: set ourself TASK_UNINTERRUPTIBLE after we schedule
>      rq-qos: use a mb for got_token
>
>Julian Parkin (1):
>      drm/amd/display: Fix dc_create failure handling and 666 color depths
>
>Julian Wiedmann (1):
>      s390/qdio: add sanity checks to the fast-requeue path
>
>Junxiao Bi (1):
>      scsi: megaraid_sas: fix panic on loading firmware crashdump
>
>Kai-Heng Feng (1):
>      Input: elantech - enable SMBus on new (2018+) systems
>
>Kan Liang (1):
>      perf/x86/intel: Fix SLOTS PEBS event constraint
>
>Kevin Hao (2):
>      mmc: cavium: Set the correct dma max segment size for mmc_host
>      mmc: cavium: Add the missing dma unmap when the dma has finished.
>
>Laura Garcia Liebana (1):
>      netfilter: nft_hash: fix symhash with modulus one
>
>Lei YU (1):
>      hwmon: (occ) Fix division by zero issue
>
>Leonard Crestez (1):
>      perf/core: Fix creating kernel counters for PMUs that override event=
->cpu
>
>Li Jun (2):
>      usb: typec: tcpm: free log buf memory when remove debug file
>      usb: typec: tcpm: remove tcpm dir if no children
>
>Logan Gunthorpe (1):
>      nvme: fix memory leak caused by incorrect subsystem free
>
>Lorenzo Bianconi (1):
>      mac80211: fix possible memory leak in ieee80211_assign_beacon
>
>Lorenzo Pieralisi (1):
>      ACPI/IORT: Fix off-by-one check in iort_dev_find_its_id()
>
>Luca Coelho (2):
>      iwlwifi: mvm: don't send GEO_TX_POWER_LIMIT on version < 41
>      iwlwifi: mvm: fix version check for GEO_TX_POWER_LIMIT support
>
>Lucas Stach (1):
>      arm64: dts: imx8mq: fix SAI compatible
>
>Maarten ter Huurne (1):
>      IIO: Ingenic JZ47xx: Set clock divider on probe
>
>Marc Zyngier (2):
>      arm64: Force SSBS on context switch
>      KVM: arm/arm64: Sync ICH_VMCR_EL2 back when about to block
>
>Masahiro Yamada (1):
>      gen_compile_commands: lower the entry count threshold
>
>Mauro Carvalho Chehab (3):
>      scripts/sphinx-pre-install: fix script for RHEL/CentOS
>      scripts/sphinx-pre-install: don't use LaTeX with CentOS 7
>      scripts/sphinx-pre-install: fix latexmk dependencies
>
>Miaohe Lin (1):
>      netfilter: Fix rpfilter dropping vrf packets by mistake
>
>Mika Westerberg (1):
>      Revert "PCI: Add missing link delays required by the PCIe spec"
>
>Mikulas Patocka (1):
>      loop: set PF_MEMALLOC_NOIO for the worker thread
>
>Ming Lei (1):
>      genirq/affinity: Create affinity mask for single vector
>
>Misha Nasledov (1):
>      nvme: ignore subnqn for ADATA SX6000LNP
>
>Murton Liu (1):
>      drm/amd/display: Clock does not lower in Updateplanes
>
>Navid Emamdoost (1):
>      allocate_flower_entry: should check for null deref
>
>Nick Desaulniers (2):
>      x86/purgatory: Do not use __builtin_memcpy and __builtin_memset
>      x86/purgatory: Use CFLAGS_REMOVE rather than reset KBUILD_CFLAGS
>
>Nikita Yushchenko (1):
>      can: rcar_canfd: fix possible IRQ storm on high load
>
>Oliver Neukum (3):
>      Revert "USB: rio500: simplify locking"
>      usb: iowarrior: fix deadlock on disconnect
>      Input: usbtouchscreen - initialize PM mutex before using it
>
>Pavel Shilovsky (1):
>      SMB3: Fix deadlock in validate negotiate hits reconnect
>
>Peter Zijlstra (1):
>      tty/ldsem, locking/rwsem: Add missing ACQUIRE to read_failed sleep l=
oop
>
>Phil Reid (2):
>      Staging: fbtft: Fix probing of gpio descriptor
>      Staging: fbtft: Fix reset assertion when using gpio descriptor
>
>Phil Sutter (1):
>      netfilter: nf_tables: Support auto-loading for inet nat
>
>Qian Cai (1):
>      drm: silence variable 'conn' set but not used
>
>Roderick Colenbrander (1):
>      HID: sony: Fix race condition between rumble and device remove.
>
>Shubhashree Dhar (1):
>      drm/msm/dpu: Correct dpu encoder spinlock initialization
>
>SivapiriyanKumarasamy (1):
>      drm/amd/display: Wait for backlight programming completion in set ba=
cklight level
>
>Stanislav Lisovskiy (1):
>      drm/i915: Fix wrong escape clock divisor init for GLK
>
>Stephane Grosjean (1):
>      can: peak_usb: fix potential double kfree_skb()
>
>Steve French (1):
>      smb3: send CAP_DFS capability during session setup
>
>Suzuki K Poulose (2):
>      coresight: Fix DEBUG_LOCKS_WARN_ON for uninitialized attribute
>      usb: yurex: Fix use-after-free in yurex_delete
>
>S=E9bastien Szymanski (1):
>      ARM: dts: imx6ul: fix clock frequency property name of I2C buses
>
>Tai Man (2):
>      drm/amd/display: use encoder's engine id to find matched free audio =
device
>      drm/amd/display: Increase size of audios array
>
>Takashi Iwai (2):
>      ALSA: hda - Don't override global PCM hw info flag
>      ALSA: hda - Workaround for crackled sound on AMD controller (1022:14=
57)
>
>Tetsuo Handa (1):
>      staging: android: ion: Bail out upon SIGKILL when allocating memory.
>
>Thomas Richter (2):
>      perf annotate: Fix s390 gap between kernel end and module start
>      perf record: Fix module size on s390
>
>Thomas Tai (1):
>      iscsi_ibft: make ISCSI_IBFT dependson ACPI instead of ISCSI_IBFT_FIND
>
>Tomas Bortoli (2):
>      can: peak_usb: pcan_usb_pro: Fix info-leaks to USB devices
>      can: peak_usb: pcan_usb_fd: Fix info-leaks to USB devices
>
>Trond Myklebust (3):
>      NFSv4: Fix delegation state recovery
>      NFSv4: Check the return value of update_open_stateid()
>      NFSv4: Fix an Oops in nfs4_do_setattr
>
>Tyrel Datwyler (1):
>      scsi: ibmvfc: fix WARN_ON during event pool release
>
>Vaibhav Jain (1):
>      powerpc/papr_scm: Force a scm-unbind if initial scm-bind fails
>
>Vitaly Kuznetsov (1):
>      KVM/nSVM: properly map nested VMCB
>
>Vivek Goyal (1):
>      dax: dax_layout_busy_page() should not unmap cow pages
>
>Wanpeng Li (1):
>      KVM: Fix leak vCPU's VMCS value into other pCPU
>
>Wen Yang (2):
>      can: flexcan: fix an use-after-free in flexcan_setup_stop_mode()
>      cpufreq/pasemi: fix use-after-free in pas_cpufreq_cpu_init()
>
>Wenwen Wang (5):
>      sound: fix a memory leak bug
>      test_firmware: fix a memory leak bug
>      ALSA: usb-audio: fix a memory leak bug
>      ALSA: firewire: fix a memory leak bug
>      ALSA: hiface: fix multiple memory leak bugs
>
>Yoshihiro Shimoda (1):
>      usb: host: xhci-rcar: Fix timeout in xhci_suspend()
>
>Yunying Sun (1):
>      perf/x86/intel: Fix invalid Bit 13 for Icelake MSR_OFFCORE_RSP_x reg=
ister
>
>Zhenzhong Duan (1):
>      perf/x86: Apply more accurate check on hypervisor platform
>
>Zi Yu Liao (1):
>      drm/amd/display: fix DMCU hang when going into Modern Standby
>



--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl1WiiMACgkQsjqdtxFL
KRVzPwf/ciXMMqNvUOHvMoGug9MovX1dz3IzcEuzwoXAajHqTCRR6WoFUvqRHTp9
WIzeI45Ksv+BULhn9LXY4WnVtP8Vjm574RS5VSEzVoKMZgcPttjsgEHKpHOaD3h8
7COr8zOctUKcfB8CQ858RbzoVE7Jmyqb6IaX8XoFwH341t5fHocl4BVxB2mVKoTL
z1D2UEpxG3OFRhaKl97EIok0amKaDDu3C1t/xmgecL4LKRstPrMp0BW10gcwPa8y
x9vBkgHStwNGoiyaSrzNKxsf65k2PXUE/FwHs1lxIhZ2KJ3e3RDzcnhmDxow5J6k
PtQu53FS+VcPsxrboeLNMiTPF+Gayw==
=VDft
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
