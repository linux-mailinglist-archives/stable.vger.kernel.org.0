Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D88120A9C
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 17:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfEPPFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 11:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726692AbfEPPFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 11:05:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A03D72082E;
        Thu, 16 May 2019 15:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558019151;
        bh=5TfZaLHNiD396/5N5HctD8OQz6eqLGARdArIe9zA2Mk=;
        h=Date:From:To:Cc:Subject:From;
        b=ZLXbrVF4y17Q34yvd2W9LbNOwsBzXUocedUClTp3gJ31Vm3T9xPAHB35BuTYf6I0F
         Vo5VFVnevyMXHfNORFrhJ8z2AZ5EcihkE15Pc6f+SbOhquzHWfiLUntpQCJ+95bYxo
         nCwsotIzlmBnpBynVD/YejjOEkutLyN/uSrRibSE=
Date:   Thu, 16 May 2019 17:05:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.18.140
Message-ID: <20190516150548.GA30718@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.18.140 kernel.

All users of the 3.18 kernel series must upgrade.

Note, this is the LAST 3.18.y release that I will be doing on
kernel.org.  I know it has been marked as End-of-Life for quite some
time, but I have kept it alive due to a few million phones out there in
the wild that depend on it, and can not move to a new kernel base due to
them being stuck with a SoC vendor that does not work upstream.

But, this does not mean the tree is dead, oh no, if only it were that
easy...

I, and a few other people, will be keeping it "alive" over in AOSP here:
	https://android.googlesource.com/kernel/common/+/refs/heads/android-3.18
and you can submit patches to it using gerrit {shudder} in aosp.  Here's
a link to the tree in gerrit, if that helps people find the location:
	https://android-review.googlesource.com/q/project:kernel%252Fcommon+branch=
:android-3.18

There will not be any new "releases", but any user of that kernel should
sync and update their trees every month or so, just to be safe.

As for how long that will be kept alive, I'm not quite sure, email me
off-list if you depend on this and we can talk details.

Anyway, thanks all for putting up with 3.18.y for so long, but there's
no need to email stable@vger for any issues with it any more.

The updated 3.18.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.18.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/usb/power-management.txt              |   14 +++-
 Makefile                                            |    2=20
 arch/arm/mach-iop13xx/setup.c                       |    8 +-
 arch/arm/mach-iop13xx/tpmi.c                        |   10 +--
 arch/arm/plat-iop/adma.c                            |    6 +-
 arch/arm/plat-orion/common.c                        |    4 -
 arch/mips/kernel/scall64-o32.S                      |    2=20
 arch/powerpc/include/asm/reg_booke.h                |    2=20
 arch/x86/kvm/trace.h                                |    4 -
 drivers/ata/libata-zpodd.c                          |   34 ++++++++---
 drivers/block/loop.c                                |   47 ++++++++--------
 drivers/block/loop.h                                |    1=20
 drivers/block/xsysace.c                             |    2=20
 drivers/gpu/ipu-v3/ipu-dp.c                         |   12 +++-
 drivers/hid/hid-debug.c                             |    5 +
 drivers/hid/hid-input.c                             |    4 +
 drivers/iio/adc/xilinx-xadc-core.c                  |    2=20
 drivers/iommu/amd_iommu_init.c                      |    2=20
 drivers/md/raid5.c                                  |   19 +-----
 drivers/media/i2c/ov7670.c                          |   16 ++---
 drivers/media/usb/tlg2300/Kconfig                   |    1=20
 drivers/net/bonding/bond_options.c                  |    7 --
 drivers/net/bonding/bond_sysfs_slave.c              |    4 +
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c   |    8 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c           |    1=20
 drivers/net/ethernet/intel/igb/e1000_defines.h      |    2=20
 drivers/net/ethernet/intel/igb/igb_main.c           |   57 ++-------------=
-----
 drivers/net/ethernet/micrel/ks8851.c                |   36 ++++++------
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c |    2=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c   |    4 -
 drivers/net/slip/slhc.c                             |    2=20
 drivers/net/team/team.c                             |    6 ++
 drivers/platform/x86/sony-laptop.c                  |    8 +-
 drivers/rtc/rtc-sh.c                                |    2=20
 drivers/s390/block/dasd_eckd.c                      |    6 +-
 drivers/s390/char/con3270.c                         |    2=20
 drivers/s390/char/fs3270.c                          |    3 -
 drivers/s390/char/raw3270.c                         |    3 -
 drivers/s390/char/raw3270.h                         |    4 +
 drivers/s390/char/tty3270.c                         |    3 -
 drivers/s390/net/ctcm_main.c                        |    1=20
 drivers/s390/scsi/zfcp_fc.c                         |   21 +++++--
 drivers/scsi/csiostor/csio_scsi.c                   |    5 +
 drivers/scsi/libsas/sas_expander.c                  |    9 +--
 drivers/scsi/qla2xxx/qla_attr.c                     |    4 -
 drivers/scsi/qla4xxx/ql4_os.c                       |    2=20
 drivers/scsi/storvsc_drv.c                          |   13 +++-
 drivers/staging/iio/addac/adt7316.c                 |   22 +++++--
 drivers/usb/core/driver.c                           |   13 ----
 drivers/usb/core/message.c                          |    4 +
 drivers/usb/gadget/udc/net2272.c                    |    1=20
 drivers/usb/gadget/udc/net2280.c                    |    4 -
 drivers/usb/host/u132-hcd.c                         |    3 +
 drivers/usb/misc/yurex.c                            |    1=20
 drivers/usb/serial/generic.c                        |   57 ++++++++++++++-=
-----
 drivers/usb/storage/realtek_cr.c                    |   13 +---
 drivers/usb/usbip/stub_rx.c                         |   18 +-----
 drivers/usb/usbip/usbip_common.h                    |    7 ++
 drivers/virt/fsl_hypervisor.c                       |   29 +++++-----
 drivers/w1/masters/ds2490.c                         |    6 +-
 fs/ceph/dir.c                                       |    6 +-
 fs/ceph/inode.c                                     |    2=20
 fs/hugetlbfs/inode.c                                |   20 ++++---
 fs/jffs2/readinode.c                                |    5 -
 fs/jffs2/super.c                                    |    5 +
 fs/nfs/super.c                                      |    3 -
 fs/proc/proc_sysctl.c                               |    6 +-
 include/linux/usb.h                                 |    2=20
 include/net/bluetooth/hci_core.h                    |    3 +
 init/main.c                                         |    4 -
 kernel/irq/manage.c                                 |    4 +
 kernel/sched/fair.c                                 |    4 +
 kernel/time/timer_stats.c                           |    2=20
 kernel/trace/ring_buffer.c                          |    2=20
 net/8021q/vlan_dev.c                                |    4 +
 net/bluetooth/hci_conn.c                            |    8 ++
 net/bluetooth/hidp/sock.c                           |    1=20
 net/bridge/br_if.c                                  |   13 ++--
 net/bridge/netfilter/ebtables.c                     |    3 -
 net/ipv4/ip_output.c                                |    1=20
 net/ipv4/raw.c                                      |    4 -
 net/ipv4/route.c                                    |   32 ++++++++---
 net/ipv6/ip6_flowlabel.c                            |   23 ++++----
 net/netfilter/x_tables.c                            |    2=20
 net/packet/af_packet.c                              |   48 +++++++++++-----
 net/sunrpc/cache.c                                  |    3 +
 scripts/kconfig/lxdialog/inputbox.c                 |    3 -
 scripts/kconfig/nconf.c                             |    2=20
 scripts/kconfig/nconf.gui.c                         |    3 -
 sound/soc/codecs/cs4270.c                           |    1=20
 sound/soc/codecs/tlv320aic32x4.c                    |    2=20
 sound/soc/soc-pcm.c                                 |    7 +-
 tools/lib/traceevent/event-parse.c                  |    2=20
 tools/testing/selftests/net/run_netsocktests        |    2=20
 94 files changed, 473 insertions(+), 349 deletions(-)

Aditya Pakki (1):
      qlcnic: Avoid potential NULL pointer dereference

Al Viro (2):
      ceph: fix use-after-free on symlink traversal
      jffs2: fix use-after-free on symlink traversal

Alan Stern (4):
      USB: yurex: Fix protection fault after device removal
      USB: w1 ds2490: Fix bug caused by improper use of altsetting array
      USB: core: Fix unterminated string returned by usb_string()
      USB: core: Fix bug caused by duplicate interface PM usage counter

Andrew Vasquez (1):
      scsi: qla2xxx: Fix incorrect region-size setting in optrom SYSFS rout=
ines

Annaliese McDermond (1):
      ASoC: tlv320aic32x4: Fix Common Pins

Arnd Bergmann (3):
      ARM: orion: don't use using 64-bit DMA masks
      ARM: iop: don't use using 64-bit DMA masks
      s390: ctcm: fix ctcm_new_device error return code

Arvind Sankar (1):
      igb: Fix WARN_ONCE on runtime suspend

Aurelien Jarno (1):
      MIPS: scall64-o32: Fix indirect syscall number load

Ben Hutchings (1):
      timer/debug: Change /proc/timer_stats from 0644 to 0600

Changbin Du (1):
      kconfig/[mn]conf: handle backspace (^H) key

Christophe Leroy (1):
      net: ucc_geth - fix Oops when changing number of buffers in the ring

Dan Carpenter (2):
      drivers/virt/fsl_hypervisor.c: dereferencing error pointers in ioctl
      drivers/virt/fsl_hypervisor.c: prevent integer overflow in ioctl

Dan Williams (1):
      init: initialize jump labels before command line option parsing

Daniel Mack (1):
      ASoC: cs4270: Set auto-increment bit for register writes

David Ahern (1):
      ipv4: Fix raw socket lookup for local traffic

Dmitry Torokhov (1):
      HID: input: add mapping for keyboard Brightness Up/Down/Toggle keys

Eric Dumazet (2):
      ipv4: add sanity checks in ipv4_link_failure()
      ipv6/flowlabel: wait rcu grace period before put_pid()

Florian Westphal (1):
      netfilter: ebtables: CONFIG_COMPAT: drop a bogus WARN_ON

Francesco Ruggeri (1):
      netfilter: compat: initialize all fields in xt_init

Geert Uytterhoeven (1):
      rtc: sh: Fix invalid alarm warning for non-enabled alarm

Greg Kroah-Hartman (3):
      Revert "block/loop: Use global lock for ioctl() operation."
      USB: media: disable tlg2300 driver
      Linux 3.18.140

Guenter Roeck (1):
      xsysace: Fix error handling in ace_setup

Guido Kiener (2):
      usb: gadget: net2280: Fix overrun of OUT messages
      usb: gadget: net2272: Fix net2272_dequeue()

Gustavo A. R. Silva (1):
      platform/x86: sony-laptop: Fix unintentional fall-through

Hangbin Liu (2):
      team: fix possible recursive locking when add slaves
      vlan: disable SIOCSHWTSTAMP in container

He, Bo (1):
      HID: debug: fix race condition with between rdesc_show() and device r=
emoval

Jacopo Mondi (1):
      media: v4l2: i2c: ov7670: Fix PLL bypass register values

Jarod Wilson (1):
      bonding: fix arp_validate toggling in active-backup mode

Jason Yan (1):
      scsi: libsas: fix a race condition when smp task timeout

Jeff Layton (1):
      ceph: ensure d_name stability in ceph_dentry_hash()

Jeremy Fertic (3):
      staging: iio: adt7316: allow adt751x to use internal vref for all dacs
      staging: iio: adt7316: fix the dac read calculation
      staging: iio: adt7316: fix the dac write calculation

Joerg Roedel (1):
      iommu/amd: Set exclusion range correctly

Johan Hovold (1):
      USB: serial: fix unthrottle races

Kangjie Lu (1):
      scsi: qla4xxx: fix a potential NULL pointer dereference

Konstantin Khorenko (1):
      bonding: show full hw address in sysfs for slave entries

Laurentiu Tudor (1):
      powerpc/booke64: set RI in default MSR

Linus Torvalds (1):
      slip: make slhc_free() silently accept an error pointer

Lucas Stach (1):
      gpu: ipu-v3: dp: fix CSC handling

Lukas Wunner (4):
      net: ks8851: Dequeue RX packets explicitly
      net: ks8851: Reassert reset pin if chip ID check fails
      net: ks8851: Delay requesting IRQ until opened
      net: ks8851: Set initial carrier state to down

Malte Leip (1):
      usb: usbip: fix isoc packet num validation in get_pipe

Marcel Holtmann (1):
      Bluetooth: Align minimum encryption key size for LE and BR/EDR connec=
tions

Martin Schwidefsky (1):
      s390/3270: fix lockdep false positive on view->lock

Michael Kelley (1):
      scsi: storvsc: Fix calculation of sub-channel count

Mike Kravetz (1):
      hugetlbfs: fix memory leak for resv_map

Mukesh Ojha (1):
      usb: u132-hcd: fix resource leak

NeilBrown (1):
      sunrpc: don't mark uninitialised items as VALID.

Nigel Croxon (1):
      Don't jump to compute_result state from check_result state

Oliver Neukum (1):
      USB: serial: use variable for status

Peter Oberparleiter (1):
      s390/dasd: Fix capacity calculation for large volumes

Peter Zijlstra (1):
      trace: Fix preempt_enable_no_resched() abuse

Po-Hsu Lin (1):
      selftests/net: correct the return value for run_netsocktests

Prasad Sodagudi (1):
      genirq: Prevent use-after-free and work list corruption

Rander Wang (1):
      ASoC:soc-pcm:fix a codec fixup issue in TDM case

Rikard Falkeborn (1):
      tools lib traceevent: Fix missing equality check for strcmp

Shmulik Ladkani (1):
      ipv4: ip_do_fragment: Preserve skb_iif during fragmentation

Steffen Maier (1):
      scsi: zfcp: reduce flood of fcrscn1 trace records on multi-element RS=
CN

Sven Van Asbroeck (1):
      iio: adc: xilinx: fix potential use-after-free on remove

Tetsuo Handa (1):
      NFS: Forbid setting AF_INET6 to "struct sockaddr_in"->sin_family.

Tobin C. Harding (1):
      bridge: Fix error path for kobject_init_and_add()

Varun Prakash (1):
      scsi: csiostor: fix missing data copy in csio_scsi_err_handler()

Vinod Koul (1):
      net: stmmac: move stmmac_check_ether_addr() to driver probe

Vitaly Kuznetsov (1):
      KVM: x86: avoid misreporting level-triggered irqs as edge-triggered i=
n tracing

Wen Yang (1):
      net: ibm: fix possible object reference leak

Willem de Bruijn (2):
      ipv6: invert flowlabel sharing check in process and user mode
      packet: validate msg_namelen in send directly

Xie XiuQi (1):
      sched/numa: Fix a possible divide-by-zero

Young Xiao (1):
      Bluetooth: hidp: fix buffer overflow

YueHaibing (2):
      fs/proc/proc_sysctl.c: Fix a NULL pointer dereference
      packet: Fix error path in packet_init

raymond pang (1):
      libata: fix using DMA buffers on stack


--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzdfEoACgkQONu9yGCS
aT41bA/5AZDbZ8wovwOmHBMNn6q01Gl9C2lkpZME+aLIxSJUl+uQ1wk7+7WFnyoB
TCC7hjzTFQCdJ4CoDSUASVRcAVw+Kys11PlcOpH7vAmJp/ELkarWgUWrj+3s+pIq
4JRMlJmeMRgEnlf4vfkC+KXb0N2JzEWtgBS6lf0McpVlO3FbwoGfVaD23wKAIAey
/jqEqKGELRdSY0xk13NrCPvIKySltgRgmKswOQA7n7XH8B6tZpr6WELhD+BL6jtm
JeStRi4Y9OilQnhUrTsoTM24k0yQQg+Fd3Nu8vlaar5bzMajz+rIEGr26Qm55Ci4
nSrQJhkrSSdHnywo//hu9yV9iRzBkzd5a2KdAW7157QnKouDmBonwBljysKU412q
Wuu/88wf2Ba3cuxvj44Cyn+epEPylIen/canMLjPwpf60bJ0Xh9MsTdfdyp5tQ78
Sr30+0UVYymSRFRkctrWM/sULRH6T+DjqZCp2EmJfNpVh+1fs7POAIpNgrRyrQCC
eOwTR51TLL9z+B5O3PmWbKmt/bmkI1xxnjRUCx+WyRA8fxhswwA0ftYnMv1GxL55
OQmsuYbjEDuI/yaMfdUFAe14KOyVYKMeb+DiOuIGcvMjWWN0p+3XBK1IsO5ykHx4
0F9vS9+fm9F+torixS42IogjIpwH5DvuGKQogMBq329xvevjIvk=
=z7FW
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
