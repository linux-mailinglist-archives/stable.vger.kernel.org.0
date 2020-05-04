Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23671C36A7
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 12:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbgEDKUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 06:20:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbgEDKUv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 06:20:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CA8E20721;
        Mon,  4 May 2020 10:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588587650;
        bh=An3ohXfoTOxXuLezMvBIxU/TU88HBBlH9orhXN4erJ4=;
        h=Date:From:To:Cc:Subject:From;
        b=V4igDQBXEtAAbKqQb9TV5QAyFZ/Leu56+tAWBXKl9tUH2rfVOAK0fu7GEvnpfpvXQ
         0QnD79ZHdUre0mPZmLPTnjHcgHpGBH3TbPy2+Q7+W8i5x27AaYwlrcZegGb6r9qGY/
         0q45JvPKONJ3lW98SQgQWROy7kg6KnlDHbFksn8c=
Date:   Mon, 4 May 2020 12:20:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.221
Message-ID: <20200504102048.GA1432206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.221 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                   |    2 
 arch/arm/mach-imx/Makefile                 |    2 
 arch/x86/kvm/vmx.c                         |    2 
 arch/x86/net/bpf_jit_comp.c                |   18 +++++++-
 drivers/crypto/mxs-dcp.c                   |    4 -
 drivers/iio/adc/xilinx-xadc-core.c         |   17 ++++++--
 drivers/mtd/chips/cfi_cmdset_0002.c        |    6 ++
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c |    2 
 drivers/net/macvlan.c                      |    2 
 drivers/net/team/team.c                    |    4 +
 drivers/pwm/pwm-bcm2835.c                  |    1 
 drivers/pwm/pwm-rcar.c                     |   10 +++-
 drivers/pwm/pwm-renesas-tpu.c              |    9 +---
 drivers/remoteproc/remoteproc_core.c       |    2 
 drivers/s390/cio/device.c                  |   13 ++++--
 drivers/scsi/lpfc/lpfc_sli.c               |    2 
 drivers/scsi/scsi_transport_iscsi.c        |    4 +
 drivers/staging/comedi/comedi_fops.c       |    4 +
 drivers/staging/comedi/drivers/dt2815.c    |    3 +
 drivers/staging/vt6656/int.c               |    3 -
 drivers/staging/vt6656/main_usb.c          |    9 ++--
 drivers/target/target_core_fabric_lib.c    |    2 
 drivers/tty/hvc/hvc_console.c              |   23 ++++++-----
 drivers/tty/rocket.c                       |   25 ++++++------
 drivers/usb/core/hub.c                     |   14 ++++++
 drivers/usb/core/message.c                 |   53 +++++++++++++-------------
 drivers/usb/core/quirks.c                  |    4 +
 drivers/usb/gadget/function/f_fs.c         |    4 +
 drivers/usb/gadget/udc/bdc/bdc_ep.c        |    2 
 drivers/usb/misc/sisusbvga/sisusb.c        |   20 ++++-----
 drivers/usb/misc/sisusbvga/sisusb_init.h   |   14 +++---
 drivers/usb/storage/uas.c                  |   46 +++++++++++++++++++++-
 drivers/usb/storage/unusual_devs.h         |    7 +++
 drivers/xen/xenbus/xenbus_client.c         |    9 +++-
 fs/ceph/caps.c                             |    8 ++-
 fs/ceph/export.c                           |    5 ++
 fs/ext4/block_validity.c                   |   54 ++++++++++++++++++++++++++
 fs/ext4/ext4.h                             |   15 ++++++-
 fs/ext4/extents.c                          |   59 +++++++++++++++++------------
 fs/ext4/ialloc.c                           |    2 
 fs/ext4/inode.c                            |   48 +++++++++++++++++------
 fs/ext4/ioctl.c                            |    2 
 fs/ext4/mballoc.c                          |    6 +-
 fs/ext4/namei.c                            |    4 -
 fs/ext4/resize.c                           |    5 +-
 fs/ext4/super.c                            |   28 ++++---------
 fs/fuse/dev.c                              |   12 ++++-
 fs/namespace.c                             |    2 
 fs/pnode.c                                 |    9 +---
 include/linux/kvm_host.h                   |    2 
 include/net/tcp.h                          |    2 
 ipc/util.c                                 |    2 
 kernel/audit.c                             |    3 +
 kernel/events/core.c                       |   13 ++++--
 kernel/gcov/fs.c                           |    2 
 net/ipv4/ip_vti.c                          |    4 -
 net/ipv4/raw.c                             |    4 +
 net/ipv4/route.c                           |    3 -
 net/ipv4/xfrm4_output.c                    |    2 
 net/ipv6/ipv6_sockglue.c                   |   13 ++----
 net/ipv6/xfrm6_output.c                    |    2 
 net/netrom/nr_route.c                      |    1 
 net/sctp/socket.c                          |    6 +-
 net/x25/x25_dev.c                          |    4 +
 sound/pci/hda/hda_intel.c                  |    1 
 sound/pci/hda/patch_realtek.c              |    2 
 sound/soc/intel/atom/sst-atom-controls.c   |    2 
 sound/soc/soc-dapm.c                       |   20 ++++++++-
 sound/usb/format.c                         |   52 +++++++++++++++++++++++++
 sound/usb/mixer_quirks.c                   |   12 +++--
 sound/usb/usx2y/usbusx2yaudio.c            |    2 
 71 files changed, 542 insertions(+), 213 deletions(-)

Ahmad Fatoum (1):
      ARM: imx: provide v7_cpu_resume() only on ARM_CPU_SUSPEND=y

Al Viro (1):
      propagate_one(): mnt_set_mountpoint() needs mount_lock

Alan Stern (3):
      USB: core: Fix free-while-in-use bug in the USB S-Glibrary
      USB: hub: Fix handling of connect changes during sleep
      usb-storage: Add unusual_devs entry for JMicron JMS566

Alexander Tsoy (1):
      ALSA: usb-audio: Filter out unsupported sample rates on Focusrite devices

Andrew Melnychenko (1):
      tty: hvc: fix buffer overflow during hvc_alloc().

Arnd Bergmann (1):
      net: ipv4: avoid unused variable warning for sysctl

Bodo Stroesser (1):
      scsi: target: fix PR IN / READ FULL STATUS for FC

Changming Liu (1):
      USB: sisusbvga: Change port variable from signed to unsigned

Clement Leger (1):
      remoteproc: Fix wrong rvring index computation

Colin Ian King (1):
      ext4: unsigned int compared against zero

Cornelia Huck (1):
      s390/cio: avoid duplicated 'ADD' uevents

David Ahern (1):
      xfrm: Always set XFRM_TRANSFORMED in xfrm{4,6}_output_finish

David Mosberger (2):
      drivers: usb: core: Don't disable irqs in usb_sg_wait() during URB submit.
      drivers: usb: core: Minimize irq disabling in usb_sg_cancel()

Dmitry Monakhov (1):
      ext4: fix extent_status fragmentation for plain files

Eric Dumazet (1):
      tcp: cache line align MAX_TCP_HEADER

Florian Fainelli (1):
      pwm: bcm2835: Dynamically allocate base

Geert Uytterhoeven (2):
      pwm: rcar: Fix late Runtime PM enablement
      pwm: renesas-tpu: Fix late Runtime PM enablement

Greg Kroah-Hartman (1):
      Linux 4.4.221

Gyeongtaek Lee (1):
      ASoC: dapm: fixup dapm kcontrol widget

Hans de Goede (1):
      ASoC: Intel: atom: Take the drv->lock mutex before calling sst_send_slot_map()

Ian Abbott (1):
      staging: comedi: dt2815: fix writing hi byte of analog output

Ian Rogers (1):
      perf/core: fix parent pid/tid in task exit events

James Smart (1):
      scsi: lpfc: Fix kasan slab-out-of-bounds error in lpfc_unreg_login

Jason Gunthorpe (1):
      net/cxgb4: Check the return from t4_query_params properly

Jeremy Sowden (1):
      vti4: removed duplicate log message.

Jiri Slaby (1):
      tty: rocket, avoid OOB access

John Haxby (1):
      ipv6: fix restrict IPV6_ADDRFORM operation

Jonathan Cox (1):
      USB: Add USB_QUIRK_DELAY_CTRL_MSG and USB_QUIRK_DELAY_INIT for Corsair K70 RGB RAPIDFIRE

Juergen Gross (1):
      xen/xenbus: ensure xenbus_map_ring_valloc() returns proper grant status

Lars-Peter Clausen (3):
      iio: xilinx-xadc: Fix ADC-B powerdown
      iio: xilinx-xadc: Fix clearing interrupt when enabling trigger
      iio: xilinx-xadc: Fix sequencer configuration for aux channels in simultaneous mode

Liu Jian (1):
      mtd: cfi: fix deadloop in cfi_cmdset_0002.c do_write_buffer

Luke Nelson (1):
      bpf, x86: Fix encoding for lower 8-bit registers in BPF_STX BPF_B

Malcolm Priestley (2):
      staging: vt6656: Fix drivers TBTT timing counter.
      staging: vt6656: Power save stop wake_up_count wrap around.

Miklos Szeredi (1):
      fuse: fix possibly missed wake-up after abort

Nathan Chancellor (1):
      usb: gadget: udc: bdc: Remove unnecessary NULL checks in bdc_req_complete

Nicolai Stange (1):
      net: ipv4: emulate READ_ONCE() on ->hdrincl bit-field in raw_sendmsg()

Oliver Neukum (2):
      UAS: no use logging any details in case of ENODEV
      UAS: fix deadlock in error handling and PM flushing work

Paul Moore (1):
      audit: check the length of userspace generated audit records

Piotr Krysiuk (1):
      fs/namespace.c: fix mountpoint reference counter race

Qiujun Huang (1):
      ceph: return ceph_mdsc_do_request() errors from __get_parent()

Sean Christopherson (1):
      KVM: Check validity of resolved slot when searching memslots

Taehee Yoo (2):
      macvlan: fix null dereference in macvlan_device_event()
      team: fix hang in team_mode_get()

Takashi Iwai (3):
      ALSA: hda - Fix incorrect usage of IS_REACHABLE()
      ALSA: hda: Remove ASUS ROG Zenith from the blacklist
      ALSA: usx2y: Fix potential NULL dereference

Theodore Ts'o (5):
      ext4: convert BUG_ON's to WARN_ON's in mballoc.c
      ext4: avoid declaring fs inconsistent due to invalid file handles
      ext4: protect journal inode's blocks using block_validity
      ext4: don't perform block validity checks on the journal inode
      ext4: fix block validity checks for journal inodes using indirect blocks

Udipto Goswami (1):
      usb: f_fs: Clear OS Extended descriptor counts to zero in ffs_data_reset()

Uros Bizjak (1):
      KVM: VMX: Enable machine check support for 32bit targets

Vasily Averin (2):
      kernel/gcov/fs.c: gcov_seq_next() should increase position index
      ipc/util.c: sysvipc_find_ipc() should increase position index

Wei Yongjun (1):
      crypto: mxs-dcp - make symbols 'sha1_null_hash' and 'sha256_null_hash' static

Wu Bo (1):
      scsi: iscsi: Report unbind session event when the target has been removed

Xin Long (1):
      sctp: use right member as the param of list_for_each_entry

Xiyu Yang (4):
      net: netrom: Fix potential nr_neigh refcnt leak in nr_add_node
      net/x25: Fix x25_neigh refcnt leak when receiving frame
      ALSA: usb-audio: Fix usb audio refcnt leak when getting spdif
      staging: comedi: Fix comedi_device refcnt leak in comedi_open

Yan, Zheng (1):
      ceph: don't skip updating wanted caps when cap is stale

