Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7433B1463CB
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 09:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgAWIqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 03:46:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:56444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgAWIqQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 03:46:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1675B2087E;
        Thu, 23 Jan 2020 08:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579769175;
        bh=2YvS1X41ZmSXw9anfA1oDTtw0UUbvQ0n9qUdv0r1+/o=;
        h=Date:From:To:Cc:Subject:From;
        b=e95o5MAsEjkSjRVZfFDi8aG3SR1QYPhuAgPzpzD/dY3oqokFFuOfqYp+IAI/9ViRD
         swNtT350rDNb5MTo31KZXbbvAVolBo9SnOQkI5SHR89y9o5CVOXjjOyGRX/4T/D56U
         2gl31lY2S0DUCwgsnWpURQf4x+k2cz2J+pNDv1uE=
Date:   Thu, 23 Jan 2020 09:46:13 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.167
Message-ID: <20200123084613.GA435306@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.167 kernel.

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

 Makefile                                                   |    2=20
 arch/arm/boot/dts/am571x-idk.dts                           |    2=20
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi          |    8=20
 arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dts |    4=20
 arch/arm64/boot/dts/arm/juno-base.dtsi                     |    1=20
 arch/x86/boot/compressed/head_64.S                         |    5=20
 arch/x86/kernel/cpu/intel_rdt.c                            |    2=20
 block/blk-settings.c                                       |    2=20
 drivers/block/xen-blkfront.c                               |    4=20
 drivers/clk/clk.c                                          |   10=20
 drivers/iio/industrialio-buffer.c                          |    6=20
 drivers/md/dm-snap-persistent.c                            |    2=20
 drivers/md/raid0.c                                         |    2=20
 drivers/message/fusion/mptctl.c                            |  213 +++-----=
-----
 drivers/net/ethernet/hisilicon/hns/hns_enet.c              |    4=20
 drivers/net/ethernet/stmicro/stmmac/common.h               |    5=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c          |    4=20
 drivers/net/hyperv/rndis_filter.c                          |    2=20
 drivers/net/macvlan.c                                      |    5=20
 drivers/net/usb/lan78xx.c                                  |    1=20
 drivers/net/usb/r8152.c                                    |    3=20
 drivers/net/wan/fsl_ucc_hdlc.c                             |    2=20
 drivers/net/wireless/st/cw1200/fwio.c                      |    6=20
 drivers/nfc/pn533/usb.c                                    |    2=20
 drivers/ptp/ptp_clock.c                                    |    4=20
 drivers/scsi/bnx2i/bnx2i_iscsi.c                           |    2=20
 drivers/scsi/esas2r/esas2r_flash.c                         |    1=20
 drivers/scsi/fnic/vnic_dev.c                               |   20 -
 drivers/scsi/qla2xxx/qla_init.c                            |    6=20
 drivers/scsi/qla2xxx/qla_isr.c                             |    6=20
 drivers/scsi/qla4xxx/ql4_mbx.c                             |    3=20
 drivers/scsi/scsi_trace.c                                  |  113 ++----
 drivers/target/target_core_fabric_lib.c                    |    2=20
 drivers/usb/core/hub.c                                     |    1=20
 drivers/usb/serial/ch341.c                                 |    6=20
 drivers/usb/serial/io_edgeport.c                           |   33 +-
 drivers/usb/serial/keyspan.c                               |    4=20
 drivers/usb/serial/opticon.c                               |    2=20
 drivers/usb/serial/option.c                                |    6=20
 drivers/usb/serial/quatech2.c                              |    6=20
 drivers/usb/serial/usb-serial-simple.c                     |    2=20
 drivers/usb/serial/usb-serial.c                            |    3=20
 firmware/Makefile                                          |    2=20
 fs/btrfs/qgroup.c                                          |    6=20
 fs/reiserfs/xattr.c                                        |    8=20
 include/dt-bindings/reset/amlogic,meson8b-reset.h          |    6=20
 include/linux/blkdev.h                                     |    8=20
 include/linux/regulator/ab8500.h                           |    2=20
 kernel/ptrace.c                                            |   15=20
 kernel/time/tick-sched.c                                   |   14=20
 mm/huge_memory.c                                           |   38 +-
 mm/page-writeback.c                                        |    4=20
 mm/shmem.c                                                 |    7=20
 net/batman-adv/distributed-arp-table.c                     |    4=20
 net/dsa/tag_qca.c                                          |    3=20
 net/ipv4/netfilter/arp_tables.c                            |   19 -
 net/ipv4/tcp_input.c                                       |    7=20
 net/netfilter/ipset/ip_set_bitmap_gen.h                    |    2=20
 net/wireless/rdev-ops.h                                    |    4=20
 net/wireless/util.c                                        |    2=20
 sound/core/seq/seq_timer.c                                 |   14=20
 sound/soc/codecs/msm8916-wcd-analog.c                      |    4=20
 tools/perf/builtin-report.c                                |    5=20
 tools/perf/util/hist.h                                     |    4=20
 tools/perf/util/probe-finder.c                             |   32 -
 65 files changed, 319 insertions(+), 408 deletions(-)

Alexander Lobakin (1):
      net: dsa: tag_qca: fix doubled Tx statistics

Ard Biesheuvel (1):
      x86/efistub: Disable paging at mixed mode entry

Arnd Bergmann (1):
      scsi: fnic: fix invalid stack access

Bart Van Assche (2):
      scsi: target: core: Fix a pr_debug() argument
      scsi: core: scsi_trace: Use get_unaligned_be*()

Bharath Vedartham (1):
      mm/huge_memory.c: make __thp_get_unmapped_area static

Christian Brauner (1):
      ptrace: reintroduce usage of subjective credentials in ptrace_has_cap=
()

Christian Hewitt (1):
      arm64: dts: meson-gxl-s905x-khadas-vim: fix gpio-keys-polled node

Colin Ian King (1):
      net/wan/fsl_ucc_hdlc: fix out of bounds write on array utdm_info

Cong Wang (1):
      netfilter: fix a use-after-free in mtype_destroy()

Dan Carpenter (3):
      scsi: mptfusion: Fix double fetch bug in ioctl
      cw1200: Fix a signedness bug in cw1200_load_firmware()
      scsi: esas2r: unlock on error in esas2r_nvram_read_direct()

Dinh Nguyen (1):
      arm64: dts: agilex/stratix10: fix pmu interrupt numbers

Eric Dumazet (3):
      macvlan: use skb_reset_mac_header() in macvlan_queue_xmit()
      net: usb: lan78xx: limit size of local TSO packets
      tick/sched: Annotate lockless access to last_jiffies_update

Felix Fietkau (1):
      cfg80211: fix page refcount issue in A-MSDU decap

Florian Westphal (1):
      netfilter: arp_tables: init netns pointer in xt_tgdtor_param struct

Greg Kroah-Hartman (1):
      Linux 4.14.167

Guenter Roeck (1):
      clk: Don't try to enable critical clocks if prepare failed

Huacai Chen (1):
      scsi: qla2xxx: Fix qla2x00_request_irqs() for MSI

Jari Ruusu (1):
      Fix built-in early-load Intel microcode alignment

Jeff Mahoney (1):
      reiserfs: fix handling of -EOPNOTSUPP in reiserfs_for_each_xattr

Jer=F3nimo Borque (1):
      USB: serial: simple: Add Motorola Solutions TETRA MTP3xxx and MTP85xx

Jin Yao (1):
      perf report: Fix incorrectly added dimensions as switch perf data file

Johan Hovold (9):
      USB: serial: opticon: fix control-message timeouts
      USB: serial: suppress driver bind attributes
      USB: serial: ch341: handle unbound port at reset_resume
      USB: serial: io_edgeport: add missing active-port sanity check
      USB: serial: keyspan: handle unbound ports
      USB: serial: quatech2: handle unbound ports
      USB: serial: io_edgeport: handle unbound ports on URB completion
      NFC: pn533: fix bulk-message timeout
      r8152: add missing endpoint sanity check

Johannes Berg (1):
      cfg80211: check for set_wiphy_params

Johannes Thumshirn (1):
      btrfs: fix memory leak in qgroup accounting

John Ogness (1):
      USB: serial: io_edgeport: use irqsave() in USB's complete callback

Jose Abreu (2):
      net: stmmac: 16KB buffer must be 16 byte aligned
      net: stmmac: Enable 16KB buffer size

Keiya Nobuta (1):
      usb: core: hub: Improved device recognition on remote wakeup

Kirill A. Shutemov (2):
      mm/shmem.c: thp, shmem: fix conflict of above-47bit hint address and =
PMD alignment
      mm/huge_memory.c: thp: fix conflict of above-47bit hint address and P=
MD alignment

Kishon Vijay Abraham I (1):
      ARM: dts: am571x-idk: Fix gpios property to have the correct gpio num=
ber

Kristian Evensen (1):
      USB: serial: option: Add support for Quectel RM500Q

Lars M=F6llendorf (1):
      iio: buffer: align the size of scan bytes to size of the largest elem=
ent

Martin Blumenstingl (1):
      dt-bindings: reset: meson8b: fix duplicate reset IDs

Martin Wilck (1):
      scsi: qla2xxx: fix rports not being mark as lost in sync fabric scan

Masami Hiramatsu (1):
      perf probe: Fix wrong address verification

Mikulas Patocka (1):
      block: fix an integer overflow in logical block size

Mohammed Gamal (1):
      hv_netvsc: Fix memory leak when removing rndis device

Nathan Chancellor (1):
      xen/blkfront: Adjust indentation in xlvbd_alloc_gendisk

Pan Bian (2):
      scsi: qla4xxx: fix double free bug
      scsi: bnx2i: fix potential use after free

Pengcheng Yang (1):
      tcp: fix marked lost packets not being retransmitted

Qian Cai (1):
      x86/resctrl: Fix an imbalance in domain_remove_cpu()

Reinhard Speyerer (1):
      USB: serial: option: add support for Quectel RM500Q in QDL mode

Stephan Gerhold (2):
      ASoC: msm8916-wcd-analog: Fix selected events for MIC BIAS External1
      regulator: ab8500: Remove SYSCLKREQ from enum ab8505_regulator_id

Sudeep Holla (1):
      Revert "arm64: dts: juno: add dma-ranges property"

Sven Eckelmann (1):
      batman-adv: Fix DAT candidate selection on little endian systems

Takashi Iwai (1):
      ALSA: seq: Fix racy access for queue timer in proc read

Vladis Dronov (1):
      ptp: free ptp device pin descriptors properly

Wen Yang (1):
      mm/page-writeback.c: avoid potential division by zero in wb_min_max_r=
atio()

Yonglong Liu (1):
      net: hns: fix soft lockup when there is not enough memory

Yuya Fujita (1):
      perf hists: Fix variable name's inconsistency in hists__for_each() ma=
cro


--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4pXVUACgkQONu9yGCS
aT6suA/7B5xUakepKMSEu7yfy397KbtfZOqM5dBvU41YcgCmDSx0o9JAnyX0dbHA
DzoXqN3e2ZrvRPhrGfCpjYo2l1MsGphVsquRGWvYRwHT6RjbvjlutSKlDbdvyoO7
XmLQ3JSCl7Q38iL8+FRg+Y7dE/8uI6aVWHeMiTLlxMVL2dg2wAHxPtR5uhCXUQi0
gAswfJ1q5oi8UjUs3B9scRhu38M+DXdzTrXD4w+CEe0IdZyXHpTIQbRqv/lkYyez
LwH2fAfHcBFyzth/W0YRK6XxVaigejisePHhARIATwKYILgIaeBNSRxSI3x+Z1Rv
LvZ4zNvd/RLW5NO6qwjysyj4Sn8pt6RAJs8gOKG1Ts9zRghIJEUy2n1p4Z9JrMlf
/Q+oRlyr6TxslJ81qj7K27Q8SzK7X+NEMr0aOkCyhV0Z7q1yAjKUkzPzTqQFhLDR
gcSZWPDvM/hbQrDRBiKKFLq9angv9IhcZvP1AGNbIRPPHZbWrdR+oc3zBKLrNnZy
J2ICQPSBib272RJHi3Vk3GM8ULgvInrR/E5tl+WCBrVl+IK8ytTRr1EKbH0fgaXq
gpe+gbWDigf3RrXzyGk5gnk5XubRAjXoe7KWd6nT7PDgaiIPQTslHUs4UMbmNIfF
GCsNUlvdcMwoKjCMmLu0jmwhj3p2EUbpyhYynAdKMkktwBjvjwo=
=tB04
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
