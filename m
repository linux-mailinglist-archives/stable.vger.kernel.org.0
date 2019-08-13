Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 168F18BBFF
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 16:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbfHMOuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 10:50:12 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45086 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729539AbfHMOuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Aug 2019 10:50:12 -0400
Received: by mail-pl1-f196.google.com with SMTP id y8so7271546plr.12;
        Tue, 13 Aug 2019 07:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ObYq/CLC0BV6eCojV+5ukG6UAlWq/hZaNsfxGqT0Mhs=;
        b=G7rnBLBvRHTZgAhwUoEpDYUuvS3JeIxVhLJnLv5ZXle23Njd5q3H59OmeKnQuSvm6N
         h6lVeCaQl6j9OjlF5JrrMqo9okZnpaCoKCQP5Kcys61k6p1O7dH7MNfAEob2TgpweH5F
         FPdPiei9MGtMzBCZZKsfHGZ6IyGb0B9DtbqezzECS9RMJ0U8ljy6B/kd/9vjKccjvxxH
         mPJeTy7H5f7900wKRZxmBulJwFCrNuHPV5oCZ761MXfR3qJy+LEEmQyQKtgYMvZhZxfX
         2Q7Q17ixK3Wd0Y+oK2BFfB18r9JRjhSJAqKDoPGtwjQUDs4RO9PLOunyZmz2WV3gBidH
         8K7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ObYq/CLC0BV6eCojV+5ukG6UAlWq/hZaNsfxGqT0Mhs=;
        b=Y3LldHj2eh+WVls/DIv/OfUTX0xoGG0DhUn2RMO1pMFnI+oJrin450nbglnZJYnFsb
         FpVumeZ5Ny1kV/Yn95guqh8plD07EzbBGtPjDfyfmhyCeb48yHaelthYevLnvE/7aTYs
         q/QdlrS/JlfhC6iTHqgSUuhvM0tQSnZxWaQeF+tHrE0ht0vSGPU2t8++vrkEqWFE45gb
         B0ayIuTBvrTMs7FHz6jfxA6bZUgZLXtbrSmnBOVSALU5qHFweTdNSVdsn8iTbARFzCey
         q9mE0UQbucZR1Dcx0nf6azTkvThPxgv41AcUVX+p8AcEQN6qQFMRwHn0mXaU20rEbUW3
         Jnbg==
X-Gm-Message-State: APjAAAWOi2yRRFpqJUrLrQLRHolhuzbSSghs6VB5m6YcHuYA/6uGdDZt
        XqylUTcxGpEDmkWHsVQJkqQ=
X-Google-Smtp-Source: APXvYqxrro07yFDEhOucQv1mo0rPbt8q7c/V/S+86YyTC8+yJxwwgLxrZWBTD6Jy+8thDmYt6IeLeQ==
X-Received: by 2002:a17:902:a58c:: with SMTP id az12mr9464335plb.129.1565707805416;
        Tue, 13 Aug 2019 07:50:05 -0700 (PDT)
Received: from Gentoo ([103.231.90.170])
        by smtp.gmail.com with ESMTPSA id b123sm19891703pfg.64.2019.08.13.07.49.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 07:50:04 -0700 (PDT)
Date:   Tue, 13 Aug 2019 20:19:49 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 3.16.72
Message-ID: <20190813144944.GA5049@Gentoo>
References: <41c24fa324ac0b4ea1077a79458bb488c86f6d49.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <41c24fa324ac0b4ea1077a79458bb488c86f6d49.camel@decadent.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Thanks, a bunch Ben :)


On 14:35 Tue 13 Aug 2019, Ben Hutchings wrote:
>I'm announcing the release of the 3.16.72 kernel.
>
>All users of the 3.16 kernel series should upgrade.
>
>The updated 3.16.y git tree can be found at:
>        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git linux-3.16.y
>and can be browsed at the normal kernel.org git web browser:
>        https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.g=
it
>
>The diff from 3.16.71 is attached to this message.
>
>Ben.
>
>------------
>
> Documentation/kernel-parameters.txt              |   5 +
> Documentation/siphash.txt                        | 100 ++++++++++
> Documentation/usb/power-management.txt           |  14 +-
> Documentation/virtual/kvm/api.txt                |  16 +-
> MAINTAINERS                                      |   7 +
> Makefile                                         |   2 +-
> arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi     |   1 +
> arch/arm/mach-imx/cpuidle-imx6q.c                |  27 +--
> arch/mips/kernel/scall64-o32.S                   |   2 +-
> arch/powerpc/include/asm/vdso_datapage.h         |   8 +-
> arch/powerpc/kernel/signal_32.c                  |   3 +
> arch/powerpc/kernel/signal_64.c                  |   5 +
> arch/powerpc/kernel/vdso32/gettimeofday.S        |   2 +-
> arch/powerpc/kernel/vdso64/gettimeofday.S        |   2 +-
> arch/x86/include/asm/calling.h                   |  18 ++
> arch/x86/include/asm/cpufeatures.h               |  41 ++--
> arch/x86/include/asm/kvm_host.h                  |  13 +-
> arch/x86/include/asm/xen/hypercall.h             |   3 +
> arch/x86/kernel/cpu/bugs.c                       | 105 +++++++++-
> arch/x86/kernel/cpu/common.c                     |  42 ++--
> arch/x86/kernel/entry_64.S                       |  73 +++++--
> arch/x86/kernel/kprobes/core.c                   |  48 ++++-
> arch/x86/kernel/process.c                        |   8 +-
> arch/x86/kvm/cpuid.c                             |   5 +
> arch/x86/kvm/mmu.c                               |  13 +-
> arch/x86/kvm/mmu.h                               |   2 +-
> arch/x86/kvm/vmx.c                               |  15 --
> arch/x86/kvm/x86.c                               |  18 +-
> arch/xtensa/kernel/stacktrace.c                  |   6 +-
> block/bio.c                                      |   5 +-
> drivers/acpi/acpica/nsobject.c                   |   4 +
> drivers/block/floppy.c                           |  32 +++-
> drivers/block/xsysace.c                          |   2 +
> drivers/bluetooth/hci_ath.c                      |   3 +
> drivers/bluetooth/hci_ldisc.c                    |   9 +
> drivers/bluetooth/hci_uart.h                     |   1 +
> drivers/gpio/gpio-adnp.c                         |   6 +-
> drivers/iio/adc/ad_sigma_delta.c                 |   1 +
> drivers/iio/adc/at91_adc.c                       |  28 +--
> drivers/iio/dac/mcp4725.c                        |   1 +
> drivers/iio/industrialio-buffer.c                |   6 +-
> drivers/iio/industrialio-core.c                  |   4 +-
> drivers/infiniband/hw/mlx4/alias_GUID.c          |   2 +-
> drivers/input/tablet/gtco.c                      |  20 +-
> drivers/iommu/amd_iommu_init.c                   |   2 +-
> drivers/iommu/intel-iommu.c                      |   3 +
> drivers/md/dm-table.c                            |  39 ++++
> drivers/md/dm.c                                  |  31 ++-
> drivers/media/usb/tlg2300/pd-common.h            |   2 +-
> drivers/mtd/chips/cfi_cmdset_0002.c              |   6 +-
> drivers/net/ethernet/3com/3c515.c                |   2 +-
> drivers/net/ethernet/8390/mac8390.c              |  37 ++--
> drivers/net/ethernet/neterion/vxge/vxge-config.c |   1 +
> drivers/net/macvtap.c                            |   3 -
> drivers/net/phy/phy_device.c                     |   5 +-
> drivers/net/ppp/pptp.c                           |   2 +-
> drivers/net/slip/slhc.c                          |   2 +-
> drivers/net/team/team.c                          |   6 +
> drivers/net/tun.c                                |   6 +-
> drivers/net/wireless/rt2x00/rt2x00.h             |   1 -
> drivers/net/wireless/rt2x00/rt2x00mac.c          |  10 -
> drivers/net/wireless/rt2x00/rt2x00queue.c        |  15 +-
> drivers/pci/quirks.c                             |   2 +
> drivers/s390/scsi/zfcp_erp.c                     |  17 ++
> drivers/s390/scsi/zfcp_ext.h                     |   2 +
> drivers/s390/scsi/zfcp_scsi.c                    |   4 +
> drivers/scsi/libsas/sas_expander.c               |   9 +-
> drivers/staging/comedi/drivers/vmk80xx.c         |   8 +-
> drivers/staging/iio/meter/ade7854.c              |   2 +-
> drivers/staging/rtl8712/rtl8712_cmd.c            |  10 +-
> drivers/staging/rtl8712/rtl8712_cmd.h            |   2 +-
> drivers/staging/speakup/speakup_soft.c           |  12 +-
> drivers/staging/speakup/spk_priv.h               |   1 +
> drivers/staging/speakup/synth.c                  |   6 +
> drivers/staging/usbip/stub_rx.c                  |  12 +-
> drivers/staging/usbip/usbip_common.h             |   7 +
> drivers/tty/serial/atmel_serial.c                |   4 +
> drivers/tty/serial/max310x.c                     |   2 +
> drivers/tty/serial/mxs-auart.c                   |   4 +
> drivers/tty/serial/sh-sci.c                      |  12 +-
> drivers/usb/core/driver.c                        |  13 --
> drivers/usb/core/message.c                       |   4 +-
> drivers/usb/host/xhci-hub.c                      |  19 +-
> drivers/usb/host/xhci.h                          |   8 +
> drivers/usb/misc/yurex.c                         |   1 +
> drivers/usb/serial/cp210x.c                      |   1 +
> drivers/usb/serial/ftdi_sio.c                    |   2 +
> drivers/usb/serial/ftdi_sio_ids.h                |   4 +-
> drivers/usb/serial/mos7720.c                     |   4 +-
> drivers/usb/storage/realtek_cr.c                 |  13 +-
> drivers/vhost/net.c                              |  31 +--
> drivers/vhost/scsi.c                             |  15 +-
> drivers/vhost/vhost.c                            |  20 +-
> drivers/vhost/vhost.h                            |   6 +-
> drivers/w1/masters/ds2490.c                      |   6 +-
> drivers/xen/balloon.c                            |  16 +-
> fs/afs/fsclient.c                                |   6 +-
> fs/btrfs/compression.c                           |  18 ++
> fs/btrfs/compression.h                           |   1 +
> fs/btrfs/props.c                                 |   5 +-
> fs/ceph/dir.c                                    |   6 +-
> fs/cifs/cifsglob.h                               |   2 +
> fs/cifs/file.c                                   |  30 ++-
> fs/cifs/inode.c                                  |   4 +
> fs/cifs/misc.c                                   |  25 ++-
> fs/cifs/smb2misc.c                               |   6 +-
> fs/cifs/smb2ops.c                                |   2 +
> fs/ext4/file.c                                   |   2 +-
> fs/ext4/resize.c                                 |  11 +-
> fs/lockd/host.c                                  |   3 +-
> fs/proc/meminfo.c                                |  34 +---
> fs/proc/proc_sysctl.c                            |   7 +-
> fs/udf/truncate.c                                |   3 +
> fs/ufs/util.h                                    |   2 +-
> include/linux/kprobes.h                          |   1 +
> include/linux/lockdep.h                          |  15 ++
> include/linux/mm.h                               |   1 +
> include/linux/siphash.h                          |  90 +++++++++
> include/linux/string.h                           |   3 +
> include/linux/usb.h                              |   2 -
> include/net/ip.h                                 |  12 +-
> include/net/ipv6.h                               |   4 +-
> include/net/netfilter/nf_conntrack.h             |   2 +
> include/net/netns/ipv4.h                         |   2 +
> include/net/sctp/checksum.h                      |   2 +-
> kernel/events/core.c                             |   2 +
> kernel/futex.c                                   |   4 +
> kernel/sched/fair.c                              |  35 +++-
> kernel/trace/ftrace.c                            |   5 +-
> kernel/trace/ring_buffer.c                       |   2 +-
> lib/Kconfig.debug                                |  10 +
> lib/Makefile                                     |   3 +-
> lib/siphash.c                                    | 232 ++++++++++++++++++=
+++++
> lib/string.c                                     |  20 ++
> lib/test_siphash.c                               | 131 +++++++++++++
> mm/page_alloc.c                                  |  43 +++++
> mm/vmstat.c                                      |   5 -
> net/batman-adv/bridge_loop_avoidance.c           |  16 +-
> net/batman-adv/translation-table.c               |  32 +++-
> net/bridge/br_multicast.c                        |   4 +-
> net/bridge/br_netfilter.c                        |   3 +
> net/bridge/netfilter/ebtables.c                  |   3 +-
> net/core/net-sysfs.c                             |   6 +-
> net/dccp/feat.c                                  |   7 +-
> net/dccp/ipv6.c                                  |   4 +-
> net/ipv4/igmp.c                                  |   4 +-
> net/ipv4/ip_output.c                             |   7 +-
> net/ipv4/ip_tunnel_core.c                        |   3 +-
> net/ipv4/ipmr.c                                  |   7 +-
> net/ipv4/raw.c                                   |   2 +-
> net/ipv4/route.c                                 |  16 +-
> net/ipv4/xfrm4_mode_tunnel.c                     |   2 +-
> net/ipv4/xfrm4_policy.c                          |  60 ++++--
> net/ipv6/ip6_flowlabel.c                         |  24 ++-
> net/ipv6/ip6_output.c                            |  23 +--
> net/ipv6/ip6mr.c                                 |  11 +-
> net/ipv6/output_core.c                           |  53 +++++-
> net/ipv6/tcp_ipv6.c                              |   8 +-
> net/ipv6/udp_offload.c                           |   6 +
> net/ipv6/xfrm6_tunnel.c                          |   4 +
> net/l2tp/l2tp_core.c                             |  10 +-
> net/mac80211/debugfs_netdev.c                    |   2 +-
> net/netfilter/ipvs/ip_vs_xmit.c                  |   5 +-
> net/netfilter/nf_conntrack_core.c                |  36 ++++
> net/netfilter/nf_conntrack_netlink.c             |  34 +++-
> net/packet/af_packet.c                           |  37 ++--
> net/rose/rose_loopback.c                         |  34 ++--
> net/sunrpc/cache.c                               |   3 +
> net/tipc/sysctl.c                                |   4 +-
> net/xfrm/xfrm_user.c                             |   2 +-
> security/device_cgroup.c                         |   2 +-
> sound/core/init.c                                |  18 +-
> sound/core/oss/pcm_oss.c                         |  43 +++--
> sound/core/pcm_native.c                          |   9 +-
> sound/core/rawmidi.c                             |   2 +
> sound/core/seq/oss/seq_oss_synth.c               |   7 +-
> sound/core/seq/seq_clientmgr.c                   |   6 +-
> tools/lib/traceevent/event-parse.c               |   2 +-
> tools/perf/tests/evsel-tp-sched.c                |   1 +
> virt/kvm/kvm_main.c                              |   3 +
> 180 files changed, 1973 insertions(+), 565 deletions(-)
>
>Aditya Pakki (1):
>      serial: max310x: Fix to avoid potential NULL pointer dereference
>
>Al Viro (1):
>      ufs: fix braino in ufs_get_inode_gid() for solaris UFS flavour
>
>Alan Stern (4):
>      USB: core: Fix unterminated string returned by usb_string()
>      USB: core: Fix bug caused by duplicate interface PM usage counter
>      USB: yurex: Fix protection fault after device removal
>      USB: w1 ds2490: Fix bug caused by improper use of altsetting array
>
>Anand Jain (1):
>      btrfs: prop: fix vanished compression property after failed set
>
>Andre Przywara (1):
>      PCI: Add function 1 DMA alias quirk for Marvell 9170 SATA controller
>
>Andy Lutomirski (2):
>      x86/asm/entry/64: Disentangle error_entry/exit gsbase/ebx/usermode c=
ode
>      x86/entry/64: Really create an error-entry-from-usermode code path
>
>Arnd Bergmann (1):
>      3c515: fix integer overflow warning
>
>Aurelien Aptel (1):
>      CIFS: keep FileInfo handle live during oplock break
>
>Aurelien Jarno (1):
>      MIPS: scall64-o32: Fix indirect syscall number load
>
>Axel Lin (1):
>      gpio: adnp: Fix testing wrong value in adnp_gpio_direction_input
>
>Ben Gardon (1):
>      kvm: mmu: Fix overflow on kvm mmu page limit calculation
>
>Ben Hutchings (3):
>      x86: cpufeatures: Renumber feature word 7
>      Revert "inet: update the IP ID generation algorithm to higher standa=
rds."
>      Linux 3.16.72
>
>Changbin Du (1):
>      perf tests: Fix a memory leak in test__perf_evsel__tp_sched_test()
>
>Chen Jie (1):
>      futex: Ensure that futex address is aligned in handle_futex_death()
>
>Christophe Leroy (1):
>      powerpc/vdso32: fix CLOCK_MONOTONIC on PPC64
>
>Colin Ian King (1):
>      vxge: fix return of a free'd memblock on a failed dma mapping
>
>Dan Carpenter (2):
>      staging: rtl8712: uninitialized memory in read_bbreg_hdl()
>      xen: Prevent buffer overflow in privcmd ioctl
>
>David Howells (1):
>      afs: Fix StoreData op marshalling
>
>Denis Efremov (4):
>      floppy: fix div-by-zero in setup_format_params
>      floppy: fix out-of-bounds read in next_valid_format
>      floppy: fix invalid pointer dereference in drive_name
>      floppy: fix out-of-bounds read in copy_buffer
>
>Dragos Bogdan (1):
>      iio: ad_sigma_delta: select channel when reading register
>
>Eric Dumazet (7):
>      tcp: do not use ipv6 header for ipv4 flow
>      dccp: do not use ipv6 header for ipv4 flow
>      net/rose: fix unbound loop in rose_loopback_timer()
>      l2tp: use rcu_dereference_sk_user_data() in l2tp_udp_encap_recv()
>      ipv6/flowlabel: wait rcu grace period before put_pid()
>      l2ip: fix possible use-after-free
>      inet: switch IP ID generator to siphash
>
>Erik Schmauss (1):
>      ACPICA: Namespace: remove address node from global list after method=
 termination
>
>Fabrice Gasnier (1):
>      iio: core: fix a possible circular locking dependency
>
>Finn Thain (1):
>      mac8390: Fix mmio access size probe
>
>Florian Westphal (2):
>      netfilter: ebtables: CONFIG_COMPAT: drop a bogus WARN_ON
>      netfilter: ctnetlink: don't use conntrack/expect object addresses as=
 id
>
>Frank Sorenson (1):
>      cifs: do not attempt cifs operation on smb2+ rename error
>
>Frederic Weisbecker (1):
>      locking/lockdep: Add IRQs disabled/enabled assertion APIs: lockdep_a=
ssert_irqs_enabled()/disabled()
>
>Geert Uytterhoeven (1):
>      net: mac8390: Use standard memcpy_{from,to}io()
>
>Georg Ottinger (1):
>      iio: adc: at91: disable adc channel interrupt in timeout case
>
>George McCollister (1):
>      USB: serial: ftdi_sio: add additional NovaTech products
>
>Grant Hernandez (1):
>      Input: gtco - bounds check collection indent level
>
>Greg Kroah-Hartman (1):
>      USB: serial: cp210x: add new device id
>
>Guenter Roeck (1):
>      xsysace: Fix error handling in ace_setup
>
>Gustavo A. R. Silva (2):
>      ALSA: rawmidi: Fix potential Spectre v1 vulnerability
>      ALSA: seq: oss: Fix Spectre v1 vulnerability
>
>Hangbin Liu (1):
>      team: fix possible recursive locking when add slaves
>
>Hannes Frederic Sowa (3):
>      ipv4: hash net ptr into fragmentation bucket selection
>      ipv4: ip_tunnel: use net namespace from rtable not socket
>      ipv6: hash net ptr into fragmentation bucket selection
>
>Heiner Kallweit (1):
>      net: phy: don't clear BMCR in genphy_soft_reset
>
>Hoan Nguyen An (1):
>      serial: sh-sci: Fix setting SCSCR_TIE while transferring data
>
>Ian Abbott (2):
>      staging: comedi: vmk80xx: Fix use of uninitialized semaphore
>      staging: comedi: vmk80xx: Fix possible double-free of ->usb_rx_buf
>
>Igor Redko (1):
>      mm/page_alloc.c: calculate 'available' memory in a separate function
>
>Ilya Dryomov (1):
>      dm table: propagate BDI_CAP_STABLE_WRITES to fix sporadic checksum e=
rrors
>
>Jack Morgenstein (1):
>      IB/mlx4: Fix race condition between catas error reset and aliasguid =
flows
>
>Jan Kara (1):
>      udf: Fix crash on IO error during truncate
>
>Jann Horn (1):
>      device_cgroup: fix RCU imbalance in error case
>
>Jason A. Donenfeld (1):
>      siphash: add cryptographically secure PRF
>
>Jason Wang (4):
>      vhost_net: introduce vhost_exceeds_weight()
>      vhost: introduce vhost_exceeds_weight()
>      vhost_net: fix possible infinite loop
>      vhost: scsi: add weight support
>
>Jason Yan (1):
>      scsi: libsas: fix a race condition when smp task timeout
>
>Jean-Francois Dagenais (1):
>      iio: dac: mcp4725: add missing powerdown bits in store eeprom
>
>Jeff Layton (1):
>      ceph: ensure d_name stability in ceph_dentry_hash()
>
>Jie Liu (1):
>      tipc: set sysctl_tipc_rmem and named_timeout right range
>
>Jim Mattson (1):
>      kvm: x86: IA32_ARCH_CAPABILITIES is always supported
>
>Joerg Roedel (1):
>      iommu/amd: Set exclusion range correctly
>
>Johannes Berg (1):
>      mac80211: don't attempt to rename ERR_PTR() debugfs dirs
>
>Johannes Thumshirn (1):
>      btrfs: correctly validate compression type
>
>Johannes Weiner (1):
>      proc: meminfo: estimate available memory more conservatively
>
>Josh Poimboeuf (3):
>      x86/speculation: Prepare entry code for Spectre v1 swapgs mitigations
>      x86/speculation: Enable Spectre v1 swapgs mitigations
>      x86/entry/64: Use JMP instead of JMPQ
>
>Juergen Gross (1):
>      xen: let alloc_xenballooned_pages() fail if not enough memory free
>
>J=C3=A9r=C3=B4me Glisse (1):
>      block: do not leak memory in bio_copy_user_iov()
>
>Kangjie Lu (2):
>      tty: atmel_serial: fix a potential NULL pointer dereference
>      tty: mxs-auart: fix a potential NULL pointer dereference
>
>Kohji Okuno (1):
>      ARM: imx6q: cpuidle: fix bug that CPU might not wake up at expected =
time
>
>Konstantin Khlebnikov (1):
>      mm/vmstat.c: fix /proc/vmstat format for CONFIG_DEBUG_TLBFLUSH=3Dy C=
ONFIG_SMP=3Dn
>
>Lars-Peter Clausen (1):
>      iio: Fix scan mask selection
>
>Leonard Pollak (1):
>      Staging: iio: meter: fixed typo
>
>Lin Yi (1):
>      USB: serial: mos7720: fix mos_parport refcount imbalance on error pa=
th
>
>Linus Torvalds (1):
>      slip: make slhc_free() silently accept an error pointer
>
>Liu Jian (1):
>      mtd: cfi: fix deadloop in cfi_cmdset_0002.c do_write_buffer
>
>Lu Baolu (1):
>      iommu/vt-d: Check capability before disabling protected memory
>
>Lukas Czerner (2):
>      ext4: fix data corruption caused by unaligned direct AIO
>      ext4: add missing brelse() in add_new_gdb_meta_bg()
>
>Malte Leip (1):
>      usb: usbip: fix isoc packet num validation in get_pipe
>
>Marco Felsch (1):
>      ARM: dts: pfla02: increase phy reset duration
>
>Markus Elfring (1):
>      iio: Use kmalloc_array() in iio_scan_mask_set()
>
>Masami Hiramatsu (3):
>      x86/kprobes: Verify stack frame on kretprobe
>      kprobes: Mark ftrace mcount handler functions nokprobe
>      x86/kprobes: Avoid kretprobe recursion bug
>
>Mathias Nyman (1):
>      xhci: Don't let USB3 ports stuck in polling state prevent suspend
>
>Max Filippov (1):
>      xtensa: fix return_address
>
>Mel Gorman (1):
>      sched/fair: Do not re-read ->h_load_next during hierarchical load ca=
lculation
>
>Michael Ellerman (1):
>      powerpc/vdso64: Fix CLOCK_MONOTONIC inconsistencies across Y2038
>
>Michael Neuling (1):
>      powerpc/tm: Fix oops on sigreturn on systems without TM
>
>Mike Snitzer (1):
>      dm: disable DISCARD if the underlying storage no longer supports it
>
>NeilBrown (2):
>      NFS: fix mount/umount race in nlmclnt.
>      sunrpc: don't mark uninitialised items as VALID.
>
>Nick Desaulniers (1):
>      lib/string.c: implement a basic bcmp
>
>Nikolay Aleksandrov (1):
>      net: bridge: multicast: use rcu to access port list from br_multicas=
t_start_querier
>
>Paolo Abeni (1):
>      vhost_net: use packet weight for rx handler, too
>
>Peter Zijlstra (1):
>      trace: Fix preempt_enable_no_resched() abuse
>
>Phil Auld (1):
>      sched/fair: Limit sched_cfs_period_timer() loop to avoid hard lockup
>
>Rikard Falkeborn (1):
>      tools lib traceevent: Fix missing equality check for strcmp
>
>Ronnie Sahlberg (1):
>      cifs: fix handle leak in smb2_query_symlink()
>
>Sabrina Dubroca (1):
>      ipv6: call ipv6_proxy_select_ident instead of ipv6_select_ident in u=
dp6_ufo_fragment
>
>Samuel Thibault (1):
>      staging: speakup_soft: Fix alternate speech with other synths
>
>Sean Christopherson (2):
>      KVM: Reject device ioctls from processes other than the VM's creator
>      KVM: x86: Emulate MSR_IA32_ARCH_CAPABILITIES on AMD hosts
>
>Steffen Klassert (3):
>      xfrm4: Fix header checks in _decode_session4.
>      xfrm4: Reload skb header pointers after calling pskb_may_pull.
>      xfrm4: Fix uninitialized memory read in _decode_session4
>
>Steffen Maier (2):
>      scsi: zfcp: fix rport unblock if deleted SCSI devices on Scsi_Host
>      scsi: zfcp: fix scsi_eh host reset with port_forced ERP for non-NPIV=
 FCP devices
>
>Stephane Eranian (1):
>      perf/core: Restore mmap record type correctly
>
>Su Yanjun (1):
>      xfrm6_tunnel: Fix potential panic when unloading xfrm6_tunnel module
>
>Sven Eckelmann (3):
>      batman-adv: Reduce claim hash refcnt only for removed entry
>      batman-adv: Reduce tt_local hash refcnt only for removed entry
>      batman-adv: Reduce tt_global hash refcnt only for removed entry
>
>Takashi Iwai (3):
>      ALSA: pcm: Fix possible OOB access in PCM oss plugins
>      ALSA: pcm: Don't suspend stream in unrecoverable PCM state
>      ALSA: core: Fix card races between register and disconnect
>
>Thomas Gleixner (2):
>      x86/speculation: Prevent deadlock on ssb_state::lock
>      x86/speculation/swapgs: Exclude ATOMs from speculation through SWAPGS
>
>Vijayakumar Durai (1):
>      rt2x00: do not increment sequence number while re-transmitting
>
>Vlad Yasevich (4):
>      ipv6: Select fragment id during UFO segmentation if not set.
>      Revert "drivers/net, ipv6: Select IPv6 fragment idents for virtio UF=
O packets"
>      ipv6: Fix fragment id assignment on LE arches.
>      ipv6: Make __ipv6_select_ident static
>
>Vladis Dronov (1):
>      Bluetooth: hci_uart: check for missing tty operations
>
>Wanpeng Li (1):
>      x86/entry/64: Fix context tracking state warning when load_gs_index =
fails
>
>Willem de Bruijn (3):
>      ipv6: invert flowlabel sharing check in process and user mode
>      packet: in recvmsg msg_name return at least sizeof sockaddr_ll
>      packet: validate msg_namelen in send directly
>
>Xie XiuQi (1):
>      sched/numa: Fix a possible divide-by-zero
>
>Xin Long (3):
>      ipv6: check sk sk_type and protocol early in ip_mroute_set/getsockopt
>      netfilter: bridge: set skb transport_header before entering NF_INET_=
PRE_ROUTING
>      sctp: get sctphdr by offset in sctp_compute_cksum
>
>YueHaibing (5):
>      xfrm: policy: Fix out-of-bound array accesses in __xfrm_policy_unlink
>      net-sysfs: call dev_hold if kobject_init_and_add success
>      fs/proc/proc_sysctl.c: fix NULL pointer dereference in put_links
>      dccp: Fix memleak in __feat_register_sp
>      fs/proc/proc_sysctl.c: Fix a NULL pointer dereference
>
>Zubin Mithra (1):
>      ALSA: seq: Fix OOB-reads from strlcpy
>
>haibinzhang(=E5=BC=A0=E6=B5=B7=E6=96=8C) (1):
>      vhost-net: set packet weight of tx polling to 2 * vq size
>
>--=20
>Ben Hutchings
>When in doubt, use brute force. - Ken Thompson
>
>

>diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-pa=
rameters.txt
>index 67a21b2ef3e4..2fe0b85b693d 100644
>--- a/Documentation/kernel-parameters.txt
>+++ b/Documentation/kernel-parameters.txt
>@@ -1917,6 +1917,7 @@ bytes respectively. Such letter suffixes can also be=
 entirely omitted.
> 				improves system performance, but it may also
> 				expose users to several CPU vulnerabilities.
> 				Equivalent to: nopti [X86]
>+					       nospectre_v1 [X86]
> 					       nospectre_v2 [X86]
> 					       spectre_v2_user=3Doff [X86]
> 					       spec_store_bypass_disable=3Doff [X86]
>@@ -2215,6 +2216,10 @@ bytes respectively. Such letter suffixes can also b=
e entirely omitted.
> 			register save and restore. The kernel will only save
> 			legacy floating-point registers on task switch.
>=20
>+	nospectre_v1	[X86] Disable mitigations for Spectre Variant 1
>+			(bounds check bypass). With this option data leaks are
>+			possible in the system.
>+
> 	nospectre_v2	[X86] Disable all mitigations for the Spectre variant 2
> 			(indirect branch prediction) vulnerability. System may
> 			allow data leaks with this option, which is equivalent
>diff --git a/Documentation/siphash.txt b/Documentation/siphash.txt
>new file mode 100644
>index 000000000000..e8e6ddbbaab4
>--- /dev/null
>+++ b/Documentation/siphash.txt
>@@ -0,0 +1,100 @@
>+         SipHash - a short input PRF
>+-----------------------------------------------
>+Written by Jason A. Donenfeld <jason@zx2c4.com>
>+
>+SipHash is a cryptographically secure PRF -- a keyed hash function -- that
>+performs very well for short inputs, hence the name. It was designed by
>+cryptographers Daniel J. Bernstein and Jean-Philippe Aumasson. It is inte=
nded
>+as a replacement for some uses of: `jhash`, `md5_transform`, `sha_transfo=
rm`,
>+and so forth.
>+
>+SipHash takes a secret key filled with randomly generated numbers and eit=
her
>+an input buffer or several input integers. It spits out an integer that is
>+indistinguishable from random. You may then use that integer as part of s=
ecure
>+sequence numbers, secure cookies, or mask it off for use in a hash table.
>+
>+1. Generating a key
>+
>+Keys should always be generated from a cryptographically secure source of
>+random numbers, either using get_random_bytes or get_random_once:
>+
>+siphash_key_t key;
>+get_random_bytes(&key, sizeof(key));
>+
>+If you're not deriving your key from here, you're doing it wrong.
>+
>+2. Using the functions
>+
>+There are two variants of the function, one that takes a list of integers=
, and
>+one that takes a buffer:
>+
>+u64 siphash(const void *data, size_t len, const siphash_key_t *key);
>+
>+And:
>+
>+u64 siphash_1u64(u64, const siphash_key_t *key);
>+u64 siphash_2u64(u64, u64, const siphash_key_t *key);
>+u64 siphash_3u64(u64, u64, u64, const siphash_key_t *key);
>+u64 siphash_4u64(u64, u64, u64, u64, const siphash_key_t *key);
>+u64 siphash_1u32(u32, const siphash_key_t *key);
>+u64 siphash_2u32(u32, u32, const siphash_key_t *key);
>+u64 siphash_3u32(u32, u32, u32, const siphash_key_t *key);
>+u64 siphash_4u32(u32, u32, u32, u32, const siphash_key_t *key);
>+
>+If you pass the generic siphash function something of a constant length, =
it
>+will constant fold at compile-time and automatically choose one of the
>+optimized functions.
>+
>+3. Hashtable key function usage:
>+
>+struct some_hashtable {
>+	DECLARE_HASHTABLE(hashtable, 8);
>+	siphash_key_t key;
>+};
>+
>+void init_hashtable(struct some_hashtable *table)
>+{
>+	get_random_bytes(&table->key, sizeof(table->key));
>+}
>+
>+static inline hlist_head *some_hashtable_bucket(struct some_hashtable *ta=
ble, struct interesting_input *input)
>+{
>+	return &table->hashtable[siphash(input, sizeof(*input), &table->key) & (=
HASH_SIZE(table->hashtable) - 1)];
>+}
>+
>+You may then iterate like usual over the returned hash bucket.
>+
>+4. Security
>+
>+SipHash has a very high security margin, with its 128-bit key. So long as=
 the
>+key is kept secret, it is impossible for an attacker to guess the outputs=
 of
>+the function, even if being able to observe many outputs, since 2^128 out=
puts
>+is significant.
>+
>+Linux implements the "2-4" variant of SipHash.
>+
>+5. Struct-passing Pitfalls
>+
>+Often times the XuY functions will not be large enough, and instead you'll
>+want to pass a pre-filled struct to siphash. When doing this, it's import=
ant
>+to always ensure the struct has no padding holes. The easiest way to do t=
his
>+is to simply arrange the members of the struct in descending order of siz=
e,
>+and to use offsetendof() instead of sizeof() for getting the size. For
>+performance reasons, if possible, it's probably a good thing to align the
>+struct to the right boundary. Here's an example:
>+
>+const struct {
>+	struct in6_addr saddr;
>+	u32 counter;
>+	u16 dport;
>+} __aligned(SIPHASH_ALIGNMENT) combined =3D {
>+	.saddr =3D *(struct in6_addr *)saddr,
>+	.counter =3D counter,
>+	.dport =3D dport
>+};
>+u64 h =3D siphash(&combined, offsetofend(typeof(combined), dport), &secre=
t);
>+
>+6. Resources
>+
>+Read the SipHash paper if you're interested in learning more:
>+https://131002.net/siphash/siphash.pdf
>diff --git a/Documentation/usb/power-management.txt b/Documentation/usb/po=
wer-management.txt
>index 1392b61d6ebe..3073ea800389 100644
>--- a/Documentation/usb/power-management.txt
>+++ b/Documentation/usb/power-management.txt
>@@ -345,11 +345,15 @@ autosuspend the interface's device.  When the usage =
counter is =3D 0
> then the interface is considered to be idle, and the kernel may
> autosuspend the device.
>=20
>-Drivers need not be concerned about balancing changes to the usage
>-counter; the USB core will undo any remaining "get"s when a driver
>-is unbound from its interface.  As a corollary, drivers must not call
>-any of the usb_autopm_* functions after their disconnect() routine has
>-returned.
>+Drivers must be careful to balance their overall changes to the usage
>+counter.  Unbalanced "get"s will remain in effect when a driver is
>+unbound from its interface, preventing the device from going into
>+runtime suspend should the interface be bound to a driver again.  On
>+the other hand, drivers are allowed to achieve this balance by calling
>+the usb_autopm_* functions even after their disconnect routine
>+has returned -- say from within a work-queue routine -- provided they
>+retain an active reference to the interface (via usb_get_intf and
>+usb_put_intf).
>=20
> Drivers using the async routines are responsible for their own
> synchronization and mutual exclusion.
>diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm=
/api.txt
>index e86da4377402..fcafeed97244 100644
>--- a/Documentation/virtual/kvm/api.txt
>+++ b/Documentation/virtual/kvm/api.txt
>@@ -13,7 +13,7 @@ of a virtual machine.  The ioctls belong to three classes
>=20
>  - VM ioctls: These query and set attributes that affect an entire virtual
>    machine, for example memory layout.  In addition a VM ioctl is used to
>-   create virtual cpus (vcpus).
>+   create virtual cpus (vcpus) and devices.
>=20
>    Only run VM ioctls from the same process (address space) that was used
>    to create the VM.
>@@ -24,6 +24,11 @@ of a virtual machine.  The ioctls belong to three class=
es
>    Only run vcpu ioctls from the same thread that was used to create the
>    vcpu.
>=20
>+ - device ioctls: These query and set attributes that control the operati=
on
>+   of a single device.
>+
>+   device ioctls must be issued from the same process (address space) that
>+   was used to create the VM.
>=20
> 2. File descriptors
> -------------------
>@@ -32,10 +37,11 @@ The kvm API is centered around file descriptors.  An i=
nitial
> open("/dev/kvm") obtains a handle to the kvm subsystem; this handle
> can be used to issue system ioctls.  A KVM_CREATE_VM ioctl on this
> handle will create a VM file descriptor which can be used to issue VM
>-ioctls.  A KVM_CREATE_VCPU ioctl on a VM fd will create a virtual cpu
>-and return a file descriptor pointing to it.  Finally, ioctls on a vcpu
>-fd can be used to control the vcpu, including the important task of
>-actually running guest code.
>+ioctls.  A KVM_CREATE_VCPU or KVM_CREATE_DEVICE ioctl on a VM fd will
>+create a virtual cpu or device and return a file descriptor pointing to
>+the new resource.  Finally, ioctls on a vcpu or device fd can be used
>+to control the vcpu or device.  For vcpus, this includes the important
>+task of actually running guest code.
>=20
> In general file descriptors can be migrated among processes by means
> of fork() and the SCM_RIGHTS facility of unix domain socket.  These
>diff --git a/MAINTAINERS b/MAINTAINERS
>index b2a5243e9d0b..61dbb398b540 100644
>--- a/MAINTAINERS
>+++ b/MAINTAINERS
>@@ -8188,6 +8188,13 @@ F:	arch/arm/mach-s3c24xx/mach-bast.c
> F:	arch/arm/mach-s3c24xx/bast-ide.c
> F:	arch/arm/mach-s3c24xx/bast-irq.c
>=20
>+SIPHASH PRF ROUTINES
>+M:	Jason A. Donenfeld <Jason@zx2c4.com>
>+S:	Maintained
>+F:	lib/siphash.c
>+F:	lib/test_siphash.c
>+F:	include/linux/siphash.h
>+
> TI DAVINCI MACHINE SUPPORT
> M:	Sekhar Nori <nsekhar@ti.com>
> M:	Kevin Hilman <khilman@deeprootsystems.com>
>diff --git a/Makefile b/Makefile
>index c2c6a3580e8a..e2d6e0b9f22d 100644
>--- a/Makefile
>+++ b/Makefile
>@@ -1,6 +1,6 @@
> VERSION =3D 3
> PATCHLEVEL =3D 16
>-SUBLEVEL =3D 71
>+SUBLEVEL =3D 72
> EXTRAVERSION =3D
> NAME =3D Museum of Fishiegoodies
>=20
>diff --git a/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi b/arch/arm/boot/=
dts/imx6qdl-phytec-pfla02.dtsi
>index 50c7718cb84e..0214e1199a06 100644
>--- a/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
>+++ b/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
>@@ -302,6 +302,7 @@
> 	pinctrl-names =3D "default";
> 	pinctrl-0 =3D <&pinctrl_enet>;
> 	phy-mode =3D "rgmii";
>+	phy-reset-duration =3D <10>; /* in msecs */
> 	phy-reset-gpios =3D <&gpio3 23 GPIO_ACTIVE_LOW>;
> 	status =3D "disabled";
> };
>diff --git a/arch/arm/mach-imx/cpuidle-imx6q.c b/arch/arm/mach-imx/cpuidle=
-imx6q.c
>index 6bcae0479049..e338a6d23b77 100644
>--- a/arch/arm/mach-imx/cpuidle-imx6q.c
>+++ b/arch/arm/mach-imx/cpuidle-imx6q.c
>@@ -14,30 +14,23 @@
> #include "common.h"
> #include "cpuidle.h"
>=20
>-static atomic_t master =3D ATOMIC_INIT(0);
>-static DEFINE_SPINLOCK(master_lock);
>+static int num_idle_cpus =3D 0;
>+static DEFINE_SPINLOCK(cpuidle_lock);
>=20
> static int imx6q_enter_wait(struct cpuidle_device *dev,
> 			    struct cpuidle_driver *drv, int index)
> {
>-	if (atomic_inc_return(&master) =3D=3D num_online_cpus()) {
>-		/*
>-		 * With this lock, we prevent other cpu to exit and enter
>-		 * this function again and become the master.
>-		 */
>-		if (!spin_trylock(&master_lock))
>-			goto idle;
>+	spin_lock(&cpuidle_lock);
>+	if (++num_idle_cpus =3D=3D num_online_cpus())
> 		imx6q_set_lpm(WAIT_UNCLOCKED);
>-		cpu_do_idle();
>-		imx6q_set_lpm(WAIT_CLOCKED);
>-		spin_unlock(&master_lock);
>-		goto done;
>-	}
>+	spin_unlock(&cpuidle_lock);
>=20
>-idle:
> 	cpu_do_idle();
>-done:
>-	atomic_dec(&master);
>+
>+	spin_lock(&cpuidle_lock);
>+	if (num_idle_cpus-- =3D=3D num_online_cpus())
>+		imx6q_set_lpm(WAIT_CLOCKED);
>+	spin_unlock(&cpuidle_lock);
>=20
> 	return index;
> }
>diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32=
=2ES
>index 37361502d63b..ff9987fd5fd0 100644
>--- a/arch/mips/kernel/scall64-o32.S
>+++ b/arch/mips/kernel/scall64-o32.S
>@@ -124,7 +124,7 @@ NESTED(handle_sys, PT_SIZE, sp)
> 	subu	t1, v0,  __NR_O32_Linux
> 	move	a1, v0
> 	bnez	t1, 1f /* __NR_syscall at offset 0 */
>-	lw	a1, PT_R4(sp) /* Arg1 for __NR_syscall case */
>+	ld	a1, PT_R4(sp) /* Arg1 for __NR_syscall case */
> 	.set	pop
>=20
> 1:	jal	syscall_trace_enter
>diff --git a/arch/powerpc/include/asm/vdso_datapage.h b/arch/powerpc/inclu=
de/asm/vdso_datapage.h
>index b73a8199f161..1e0ee59c8276 100644
>--- a/arch/powerpc/include/asm/vdso_datapage.h
>+++ b/arch/powerpc/include/asm/vdso_datapage.h
>@@ -82,10 +82,10 @@ struct vdso_data {
> 	__u32 icache_block_size;		/* L1 i-cache block size     */
> 	__u32 dcache_log_block_size;		/* L1 d-cache log block size */
> 	__u32 icache_log_block_size;		/* L1 i-cache log block size */
>-	__s32 wtom_clock_sec;			/* Wall to monotonic clock */
>-	__s32 wtom_clock_nsec;
>-	struct timespec stamp_xtime;	/* xtime as at tb_orig_stamp */
>-	__u32 stamp_sec_fraction;	/* fractional seconds of stamp_xtime */
>+	__u32 stamp_sec_fraction;		/* fractional seconds of stamp_xtime */
>+	__s32 wtom_clock_nsec;			/* Wall to monotonic clock nsec */
>+	__s64 wtom_clock_sec;			/* Wall to monotonic clock sec */
>+	struct timespec stamp_xtime;		/* xtime as at tb_orig_stamp */
>    	__u32 syscall_map_64[SYSCALL_MAP_SIZE]; /* map of syscalls  */
>    	__u32 syscall_map_32[SYSCALL_MAP_SIZE]; /* map of syscalls */
> };
>diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_=
32.c
>index e7e8c4db2651..90d1d10eff05 100644
>--- a/arch/powerpc/kernel/signal_32.c
>+++ b/arch/powerpc/kernel/signal_32.c
>@@ -1274,6 +1274,9 @@ long sys_rt_sigreturn(int r3, int r4, int r5, int r6=
, int r7, int r8,
> 			goto bad;
>=20
> 		if (MSR_TM_ACTIVE(msr_hi<<32)) {
>+			/* Trying to start TM on non TM system */
>+			if (!cpu_has_feature(CPU_FTR_TM))
>+				goto bad;
> 			/* We only recheckpoint on return if we're
> 			 * transaction.
> 			 */
>diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_=
64.c
>index 0bcae29336c0..5437dae4f12f 100644
>--- a/arch/powerpc/kernel/signal_64.c
>+++ b/arch/powerpc/kernel/signal_64.c
>@@ -702,6 +702,11 @@ int sys_rt_sigreturn(unsigned long r3, unsigned long =
r4, unsigned long r5,
> 	if (MSR_TM_ACTIVE(msr)) {
> 		/* We recheckpoint on return. */
> 		struct ucontext __user *uc_transact;
>+
>+		/* Trying to start TM on non TM system */
>+		if (!cpu_has_feature(CPU_FTR_TM))
>+			goto badframe;
>+
> 		if (__get_user(uc_transact, &uc->uc_link))
> 			goto badframe;
> 		if (restore_tm_sigcontexts(regs, &uc->uc_mcontext,
>diff --git a/arch/powerpc/kernel/vdso32/gettimeofday.S b/arch/powerpc/kern=
el/vdso32/gettimeofday.S
>index 6b2b69616e77..8bacb8721961 100644
>--- a/arch/powerpc/kernel/vdso32/gettimeofday.S
>+++ b/arch/powerpc/kernel/vdso32/gettimeofday.S
>@@ -98,7 +98,7 @@ V_FUNCTION_BEGIN(__kernel_clock_gettime)
> 	 * can be used, r7 contains NSEC_PER_SEC.
> 	 */
>=20
>-	lwz	r5,WTOM_CLOCK_SEC(r9)
>+	lwz	r5,(WTOM_CLOCK_SEC+LOPART)(r9)
> 	lwz	r6,WTOM_CLOCK_NSEC(r9)
>=20
> 	/* We now have our offset in r5,r6. We create a fake dependency
>diff --git a/arch/powerpc/kernel/vdso64/gettimeofday.S b/arch/powerpc/kern=
el/vdso64/gettimeofday.S
>index 382021324883..6a6a8495bd55 100644
>--- a/arch/powerpc/kernel/vdso64/gettimeofday.S
>+++ b/arch/powerpc/kernel/vdso64/gettimeofday.S
>@@ -85,7 +85,7 @@ V_FUNCTION_BEGIN(__kernel_clock_gettime)
> 	 * At this point, r4,r5 contain our sec/nsec values.
> 	 */
>=20
>-	lwa	r6,WTOM_CLOCK_SEC(r3)
>+	ld	r6,WTOM_CLOCK_SEC(r3)
> 	lwa	r9,WTOM_CLOCK_NSEC(r3)
>=20
> 	/* We now have our result in r6,r9. We create a fake dependency
>diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling=
=2Eh
>index cb4c73bfeb48..129e29721835 100644
>--- a/arch/x86/include/asm/calling.h
>+++ b/arch/x86/include/asm/calling.h
>@@ -47,6 +47,7 @@ For 32-bit we have the following conventions - kernel is=
 built with
> */
>=20
> #include <asm/dwarf2.h>
>+#include <asm/cpufeatures.h>
>=20
> #ifdef CONFIG_X86_64
>=20
>@@ -195,6 +196,23 @@ For 32-bit we have the following conventions - kernel=
 is built with
> 	.byte 0xf1
> 	.endm
>=20
>+/*
>+ * Mitigate Spectre v1 for conditional swapgs code paths.
>+ *
>+ * FENCE_SWAPGS_USER_ENTRY is used in the user entry swapgs code path, to
>+ * prevent a speculative swapgs when coming from kernel space.
>+ *
>+ * FENCE_SWAPGS_KERNEL_ENTRY is used in the kernel entry non-swapgs code =
path,
>+ * to prevent the swapgs from getting speculatively skipped when coming f=
rom
>+ * user space.
>+ */
>+.macro FENCE_SWAPGS_USER_ENTRY
>+	ALTERNATIVE "", "lfence", X86_FEATURE_FENCE_SWAPGS_USER
>+.endm
>+.macro FENCE_SWAPGS_KERNEL_ENTRY
>+	ALTERNATIVE "", "lfence", X86_FEATURE_FENCE_SWAPGS_KERNEL
>+.endm
>+
> #else /* CONFIG_X86_64 */
>=20
> /*
>diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpu=
features.h
>index 99137cbe34b8..ba48ab887acf 100644
>--- a/arch/x86/include/asm/cpufeatures.h
>+++ b/arch/x86/include/asm/cpufeatures.h
>@@ -177,29 +177,33 @@
> #define X86_FEATURE_ARAT	( 7*32+ 1) /* Always Running APIC Timer */
> #define X86_FEATURE_CPB		( 7*32+ 2) /* AMD Core Performance Boost */
> #define X86_FEATURE_EPB		( 7*32+ 3) /* IA32_ENERGY_PERF_BIAS support */
>-#define X86_FEATURE_XSAVEOPT	( 7*32+ 4) /* Optimized Xsave */
>+#define X86_FEATURE_INVPCID_SINGLE ( 7*32+4) /* Effectively INVPCID && CR=
4.PCIDE=3D1 */
> #define X86_FEATURE_PLN		( 7*32+ 5) /* Intel Power Limit Notification */
> #define X86_FEATURE_PTS		( 7*32+ 6) /* Intel Package Thermal Status */
> #define X86_FEATURE_DTHERM	( 7*32+ 7) /* Digital Thermal Sensor */
> #define X86_FEATURE_HW_PSTATE	( 7*32+ 8) /* AMD HW-PState */
> #define X86_FEATURE_PROC_FEEDBACK ( 7*32+ 9) /* AMD ProcFeedbackInterface=
 */
>-#define X86_FEATURE_INVPCID_SINGLE ( 7*32+10) /* Effectively INVPCID && C=
R4.PCIDE=3D1 */
>-#define X86_FEATURE_RSB_CTXSW	( 7*32+11) /* "" Fill RSB on context switch=
es */
>-#define X86_FEATURE_USE_IBPB	( 7*32+12) /* "" Indirect Branch Prediction =
Barrier enabled */
>-#define X86_FEATURE_USE_IBRS_FW ( 7*32+13) /* "" Use IBRS during runtime =
firmware calls */
>-#define X86_FEATURE_SPEC_STORE_BYPASS_DISABLE ( 7*32+14) /* "" Disable Sp=
eculative Store Bypass. */
>-#define X86_FEATURE_LS_CFG_SSBD	( 7*32+15) /* "" AMD SSBD implementation =
*/
>-#define X86_FEATURE_IBRS	( 7*32+16) /* Indirect Branch Restricted Specula=
tion */
>-#define X86_FEATURE_IBPB	( 7*32+17) /* Indirect Branch Prediction Barrier=
 */
>-#define X86_FEATURE_STIBP	( 7*32+18) /* Single Thread Indirect Branch Pre=
dictors */
>-#define X86_FEATURE_MSR_SPEC_CTRL ( 7*32+19) /* "" MSR SPEC_CTRL is imple=
mented */
>-#define X86_FEATURE_SSBD	( 7*32+20) /* Speculative Store Bypass Disable */
>-#define X86_FEATURE_ZEN		( 7*32+21) /* "" CPU is AMD family 0x17 (Zen) */
>-#define X86_FEATURE_L1TF_PTEINV	( 7*32+22) /* "" L1TF workaround PTE inve=
rsion */
>-#define X86_FEATURE_IBRS_ENHANCED ( 7*32+23) /* Enhanced IBRS */
>-#define X86_FEATURE_RETPOLINE	( 7*32+29) /* "" Generic Retpoline mitigati=
on for Spectre variant 2 */
>-#define X86_FEATURE_RETPOLINE_AMD ( 7*32+30) /* "" AMD Retpoline mitigati=
on for Spectre variant 2 */
>-/* Because the ALTERNATIVE scheme is for members of the X86_FEATURE club.=
=2E. */
>+#define X86_FEATURE_FENCE_SWAPGS_USER	( 7*32+10) /* "" LFENCE in user ent=
ry SWAPGS path */
>+#define X86_FEATURE_FENCE_SWAPGS_KERNEL	( 7*32+11) /* "" LFENCE in kernel=
 entry SWAPGS path */
>+#define X86_FEATURE_RETPOLINE	( 7*32+12) /* "" Generic Retpoline mitigati=
on for Spectre variant 2 */
>+#define X86_FEATURE_RETPOLINE_AMD ( 7*32+13) /* "" AMD Retpoline mitigati=
on for Spectre variant 2 */
>+
>+#define X86_FEATURE_XSAVEOPT	( 7*32+15) /* Optimized Xsave */
>+#define X86_FEATURE_MSR_SPEC_CTRL ( 7*32+16) /* "" MSR SPEC_CTRL is imple=
mented */
>+#define X86_FEATURE_SSBD	( 7*32+17) /* Speculative Store Bypass Disable */
>+
>+#define X86_FEATURE_RSB_CTXSW	( 7*32+19) /* "" Fill RSB on context switch=
es */
>+
>+#define X86_FEATURE_USE_IBPB	( 7*32+21) /* "" Indirect Branch Prediction =
Barrier enabled */
>+#define X86_FEATURE_USE_IBRS_FW ( 7*32+22) /* "" Use IBRS during runtime =
firmware calls */
>+#define X86_FEATURE_SPEC_STORE_BYPASS_DISABLE ( 7*32+23) /* "" Disable Sp=
eculative Store Bypass. */
>+#define X86_FEATURE_LS_CFG_SSBD	( 7*32+24) /* "" AMD SSBD implementation =
*/
>+#define X86_FEATURE_IBRS	( 7*32+25) /* Indirect Branch Restricted Specula=
tion */
>+#define X86_FEATURE_IBPB	( 7*32+26) /* Indirect Branch Prediction Barrier=
 */
>+#define X86_FEATURE_STIBP	( 7*32+27) /* Single Thread Indirect Branch Pre=
dictors */
>+#define X86_FEATURE_ZEN		( 7*32+28) /* "" CPU is AMD family 0x17 (Zen) */
>+#define X86_FEATURE_L1TF_PTEINV	( 7*32+29) /* "" L1TF workaround PTE inve=
rsion */
>+#define X86_FEATURE_IBRS_ENHANCED ( 7*32+30) /* Enhanced IBRS */
> #define X86_FEATURE_KAISER	( 7*32+31) /* CONFIG_PAGE_TABLE_ISOLATION w/o =
nokaiser */
>=20
> /* Virtualization flags: Linux defined, word 8 */
>@@ -274,5 +278,6 @@
> #define X86_BUG_L1TF		X86_BUG(9) /* CPU is affected by L1 Terminal Fault =
*/
> #define X86_BUG_MDS		X86_BUG(10) /* CPU is affected by Microarchitectural=
 data sampling */
> #define X86_BUG_MSBDS_ONLY	X86_BUG(11) /* CPU is only affected by the  MS=
DBS variant of BUG_MDS */
>+#define X86_BUG_SWAPGS		X86_BUG(12) /* CPU is affected by speculation thr=
ough SWAPGS */
>=20
> #endif /* _ASM_X86_CPUFEATURES_H */
>diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_ho=
st.h
>index e9eae4fbdde2..92a9ba2595b3 100644
>--- a/arch/x86/include/asm/kvm_host.h
>+++ b/arch/x86/include/asm/kvm_host.h
>@@ -88,7 +88,7 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_g=
fn, int level)
> #define IOPL_SHIFT 12
>=20
> #define KVM_PERMILLE_MMU_PAGES 20
>-#define KVM_MIN_ALLOC_MMU_PAGES 64
>+#define KVM_MIN_ALLOC_MMU_PAGES 64UL
> #define KVM_MMU_HASH_SHIFT 10
> #define KVM_NUM_MMU_PAGES (1 << KVM_MMU_HASH_SHIFT)
> #define KVM_MIN_FREE_MMU_PAGES 5
>@@ -363,6 +363,7 @@ struct kvm_vcpu_arch {
> 	int mp_state;
> 	u64 ia32_misc_enable_msr;
> 	bool tpr_access_reporting;
>+	u64 arch_capabilities;
>=20
> 	/*
> 	 * Paging state of the vcpu
>@@ -551,9 +552,9 @@ struct kvm_apic_map {
> };
>=20
> struct kvm_arch {
>-	unsigned int n_used_mmu_pages;
>-	unsigned int n_requested_mmu_pages;
>-	unsigned int n_max_mmu_pages;
>+	unsigned long n_used_mmu_pages;
>+	unsigned long n_requested_mmu_pages;
>+	unsigned long n_max_mmu_pages;
> 	unsigned int indirect_shadow_pages;
> 	unsigned long mmu_valid_gen;
> 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
>@@ -809,8 +810,8 @@ void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
> 				     gfn_t gfn_offset, unsigned long mask);
> void kvm_mmu_zap_all(struct kvm *kvm);
> void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm);
>-unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm);
>-void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pa=
ges);
>+unsigned long kvm_mmu_calculate_mmu_pages(struct kvm *kvm);
>+void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_p=
ages);
>=20
> int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long=
 cr3);
>=20
>diff --git a/arch/x86/include/asm/xen/hypercall.h b/arch/x86/include/asm/x=
en/hypercall.h
>index da45f9fc1913..5876b28f9331 100644
>--- a/arch/x86/include/asm/xen/hypercall.h
>+++ b/arch/x86/include/asm/xen/hypercall.h
>@@ -215,6 +215,9 @@ privcmd_call(unsigned call,
> 	__HYPERCALL_DECLS;
> 	__HYPERCALL_5ARG(a1, a2, a3, a4, a5);
>=20
>+	if (call >=3D PAGE_SIZE / sizeof(hypercall_page[0]))
>+		return -EINVAL;
>+
> 	stac();
> 	asm volatile(CALL_NOSPEC
> 		     : __HYPERCALL_5PARAM
>diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
>index e325029ff01a..f9e23ee19bcb 100644
>--- a/arch/x86/kernel/cpu/bugs.c
>+++ b/arch/x86/kernel/cpu/bugs.c
>@@ -30,6 +30,7 @@
> #include <asm/intel-family.h>
> #include <asm/e820.h>
>=20
>+static void __init spectre_v1_select_mitigation(void);
> static void __init spectre_v2_select_mitigation(void);
> static void __init ssb_select_mitigation(void);
> static void __init l1tf_select_mitigation(void);
>@@ -148,17 +149,11 @@ void __init check_bugs(void)
> 	if (boot_cpu_has(X86_FEATURE_STIBP))
> 		x86_spec_ctrl_mask |=3D SPEC_CTRL_STIBP;
>=20
>-	/* Select the proper spectre mitigation before patching alternatives */
>+	/* Select the proper CPU mitigations before patching alternatives: */
>+	spectre_v1_select_mitigation();
> 	spectre_v2_select_mitigation();
>-
>-	/*
>-	 * Select proper mitigation for any exposure to the Speculative Store
>-	 * Bypass vulnerability.
>-	 */
> 	ssb_select_mitigation();
>-
> 	l1tf_select_mitigation();
>-
> 	mds_select_mitigation();
>=20
> 	arch_smt_update();
>@@ -317,6 +312,98 @@ static int __init mds_cmdline(char *str)
> }
> early_param("mds", mds_cmdline);
>=20
>+#undef pr_fmt
>+#define pr_fmt(fmt)     "Spectre V1 : " fmt
>+
>+enum spectre_v1_mitigation {
>+	SPECTRE_V1_MITIGATION_NONE,
>+	SPECTRE_V1_MITIGATION_AUTO,
>+};
>+
>+static enum spectre_v1_mitigation spectre_v1_mitigation =3D
>+	SPECTRE_V1_MITIGATION_AUTO;
>+
>+static const char * const spectre_v1_strings[] =3D {
>+	[SPECTRE_V1_MITIGATION_NONE] =3D "Vulnerable: __user pointer sanitizatio=
n and usercopy barriers only; no swapgs barriers",
>+	[SPECTRE_V1_MITIGATION_AUTO] =3D "Mitigation: usercopy/swapgs barriers a=
nd __user pointer sanitization",
>+};
>+
>+/*
>+ * Does SMAP provide full mitigation against speculative kernel access to
>+ * userspace?
>+ */
>+static bool smap_works_speculatively(void)
>+{
>+	if (!boot_cpu_has(X86_FEATURE_SMAP))
>+		return false;
>+
>+	/*
>+	 * On CPUs which are vulnerable to Meltdown, SMAP does not
>+	 * prevent speculative access to user data in the L1 cache.
>+	 * Consider SMAP to be non-functional as a mitigation on these
>+	 * CPUs.
>+	 */
>+	if (boot_cpu_has(X86_BUG_CPU_MELTDOWN))
>+		return false;
>+
>+	return true;
>+}
>+
>+static void __init spectre_v1_select_mitigation(void)
>+{
>+	if (!boot_cpu_has_bug(X86_BUG_SPECTRE_V1) || cpu_mitigations_off()) {
>+		spectre_v1_mitigation =3D SPECTRE_V1_MITIGATION_NONE;
>+		return;
>+	}
>+
>+	if (spectre_v1_mitigation =3D=3D SPECTRE_V1_MITIGATION_AUTO) {
>+		/*
>+		 * With Spectre v1, a user can speculatively control either
>+		 * path of a conditional swapgs with a user-controlled GS
>+		 * value.  The mitigation is to add lfences to both code paths.
>+		 *
>+		 * If FSGSBASE is enabled, the user can put a kernel address in
>+		 * GS, in which case SMAP provides no protection.
>+		 *
>+		 * [ NOTE: Don't check for X86_FEATURE_FSGSBASE until the
>+		 *	   FSGSBASE enablement patches have been merged. ]
>+		 *
>+		 * If FSGSBASE is disabled, the user can only put a user space
>+		 * address in GS.  That makes an attack harder, but still
>+		 * possible if there's no SMAP protection.
>+		 */
>+		if (!smap_works_speculatively()) {
>+			/*
>+			 * Mitigation can be provided from SWAPGS itself or
>+			 * PTI as the CR3 write in the Meltdown mitigation
>+			 * is serializing.
>+			 *
>+			 * If neither is there, mitigate with an LFENCE to
>+			 * stop speculation through swapgs.
>+			 */
>+			if (boot_cpu_has_bug(X86_BUG_SWAPGS) &&
>+			    !boot_cpu_has(X86_FEATURE_KAISER))
>+				setup_force_cpu_cap(X86_FEATURE_FENCE_SWAPGS_USER);
>+
>+			/*
>+			 * Enable lfences in the kernel entry (non-swapgs)
>+			 * paths, to prevent user entry from speculatively
>+			 * skipping swapgs.
>+			 */
>+			setup_force_cpu_cap(X86_FEATURE_FENCE_SWAPGS_KERNEL);
>+		}
>+	}
>+
>+	pr_info("%s\n", spectre_v1_strings[spectre_v1_mitigation]);
>+}
>+
>+static int __init nospectre_v1_cmdline(char *str)
>+{
>+	spectre_v1_mitigation =3D SPECTRE_V1_MITIGATION_NONE;
>+	return 0;
>+}
>+early_param("nospectre_v1", nospectre_v1_cmdline);
>+
> #undef pr_fmt
> #define pr_fmt(fmt)     "Spectre V2 : " fmt
>=20
>@@ -1210,7 +1297,7 @@ static ssize_t cpu_show_common(struct device *dev, s=
truct device_attribute *attr
> 		break;
>=20
> 	case X86_BUG_SPECTRE_V1:
>-		return sprintf(buf, "Mitigation: __user pointer sanitization\n");
>+		return sprintf(buf, "%s\n", spectre_v1_strings[spectre_v1_mitigation]);
>=20
> 	case X86_BUG_SPECTRE_V2:
> 		return sprintf(buf, "%s%s%s%s%s%s\n", spectre_v2_strings[spectre_v2_ena=
bled],
>diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
>index 9d4638d437de..337fcac8c8a0 100644
>--- a/arch/x86/kernel/cpu/common.c
>+++ b/arch/x86/kernel/cpu/common.c
>@@ -813,6 +813,7 @@ static void identify_cpu_without_cpuid(struct cpuinfo_=
x86 *c)
> #define NO_L1TF		BIT(3)
> #define NO_MDS		BIT(4)
> #define MSBDS_ONLY	BIT(5)
>+#define NO_SWAPGS	BIT(6)
>=20
> #define VULNWL(_vendor, _family, _model, _whitelist)	\
> 	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
>@@ -836,29 +837,37 @@ static const __initconst struct x86_cpu_id cpu_vuln_=
whitelist[] =3D {
> 	VULNWL_INTEL(ATOM_BONNELL,		NO_SPECULATION),
> 	VULNWL_INTEL(ATOM_BONNELL_MID,		NO_SPECULATION),
>=20
>-	VULNWL_INTEL(ATOM_SILVERMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY),
>-	VULNWL_INTEL(ATOM_SILVERMONT_X,		NO_SSB | NO_L1TF | MSBDS_ONLY),
>-	VULNWL_INTEL(ATOM_SILVERMONT_MID,	NO_SSB | NO_L1TF | MSBDS_ONLY),
>-	VULNWL_INTEL(ATOM_AIRMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY),
>-	VULNWL_INTEL(XEON_PHI_KNL,		NO_SSB | NO_L1TF | MSBDS_ONLY),
>-	VULNWL_INTEL(XEON_PHI_KNM,		NO_SSB | NO_L1TF | MSBDS_ONLY),
>+	VULNWL_INTEL(ATOM_SILVERMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS=
),
>+	VULNWL_INTEL(ATOM_SILVERMONT_X,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAP=
GS),
>+	VULNWL_INTEL(ATOM_SILVERMONT_MID,	NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWA=
PGS),
>+	VULNWL_INTEL(ATOM_AIRMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
>+	VULNWL_INTEL(XEON_PHI_KNL,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
>+	VULNWL_INTEL(XEON_PHI_KNM,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
>=20
> 	VULNWL_INTEL(CORE_YONAH,		NO_SSB),
>=20
>-	VULNWL_INTEL(ATOM_AIRMONT_MID,		NO_L1TF | MSBDS_ONLY),
>+	VULNWL_INTEL(ATOM_AIRMONT_MID,		NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
>=20
>-	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF),
>-	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF),
>-	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF),
>+	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS),
>+	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF | NO_SWAPGS),
>+	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS),
>+
>+	/*
>+	 * Technically, swapgs isn't serializing on AMD (despite it previously
>+	 * being documented as such in the APM).  But according to AMD, %gs is
>+	 * updated non-speculatively, and the issuing of %gs-relative memory
>+	 * operands will be blocked until the %gs update completes, which is
>+	 * good enough for our purposes.
>+	 */
>=20
> 	/* AMD Family 0xf - 0x12 */
>-	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS),
>-	VULNWL_AMD(0x10,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS),
>-	VULNWL_AMD(0x11,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS),
>-	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS),
>+	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS),
>+	VULNWL_AMD(0x10,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS),
>+	VULNWL_AMD(0x11,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS),
>+	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS),
>=20
> 	/* FAMILY_ANY must be last, otherwise 0x0f - 0x12 matches won't work */
>-	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS),
>+	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS),
> 	{}
> };
>=20
>@@ -895,6 +904,9 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86=
 *c)
> 			setup_force_cpu_bug(X86_BUG_MSBDS_ONLY);
> 	}
>=20
>+	if (!cpu_matches(NO_SWAPGS))
>+		setup_force_cpu_bug(X86_BUG_SWAPGS);
>+
> 	if (cpu_matches(NO_MELTDOWN))
> 		return;
>=20
>diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
>index 6e5feb342ee4..467069f38f21 100644
>--- a/arch/x86/kernel/entry_64.S
>+++ b/arch/x86/kernel/entry_64.S
>@@ -265,14 +265,19 @@ ENDPROC(native_usergs_sysret64)
> 	testl $3, CS-RBP(%rsi)
> 	je 1f
> 	SWAPGS
>+	FENCE_SWAPGS_USER_ENTRY
> 	SWITCH_KERNEL_CR3
>+	jmp	2f
>+1:
>+	FENCE_SWAPGS_KERNEL_ENTRY
>+2:
> 	/*
> 	 * irq_count is used to check if a CPU is already on an interrupt stack
> 	 * or not. While this is essentially redundant with preempt_count it is
> 	 * a little cheaper to use a separate counter in the PDA (short of
> 	 * moving irq_enter into assembly, which would be too much work)
> 	 */
>-1:	incl PER_CPU_VAR(irq_count)
>+	incl PER_CPU_VAR(irq_count)
> 	cmovzq PER_CPU_VAR(irq_stack_ptr),%rsp
> 	CFI_DEF_CFA_REGISTER	rsi
>=20
>@@ -337,6 +342,13 @@ ENTRY(save_paranoid)
> 	movq	%rax, %cr3
> 2:
> #endif
>+	/*
>+	 * The above doesn't do an unconditional CR3 write, even in the PTI
>+	 * case.  So do an lfence to prevent GS speculation, regardless of
>+	 * whether PTI is enabled.
>+	 */
>+	FENCE_SWAPGS_KERNEL_ENTRY
>+
> 	ret
> 	CFI_ENDPROC
> END(save_paranoid)
>@@ -1445,10 +1457,27 @@ ENTRY(error_entry)
> 	 */
> 	SWITCH_KERNEL_CR3
> 	testl $3,CS+8(%rsp)
>-	je error_kernelspace
>-error_swapgs:
>+	jz	.Lerror_kernelspace
>+
>+	/*
>+	 * We entered from user mode or we're pretending to have entered
>+	 * from user mode due to an IRET fault.
>+	 */
> 	SWAPGS
>-error_sti:
>+	FENCE_SWAPGS_USER_ENTRY
>+
>+.Lerror_entry_from_usermode_after_swapgs:
>+	/*
>+	 * We need to tell lockdep that IRQs are off.  We can't do this until
>+	 * we fix gsbase, and we should do it before enter_from_user_mode
>+	 * (which can take locks).
>+	 */
>+	TRACE_IRQS_OFF
>+	ret
>+
>+.Lerror_entry_done_lfence:
>+	FENCE_SWAPGS_KERNEL_ENTRY
>+.Lerror_entry_done:
> 	TRACE_IRQS_OFF
> 	ret
>=20
>@@ -1458,28 +1487,46 @@ ENTRY(error_entry)
>  * truncated RIP for IRET exceptions returning to compat mode. Check
>  * for these here too.
>  */
>-error_kernelspace:
>+.Lerror_kernelspace:
> 	leaq native_irq_return_iret(%rip),%rcx
> 	cmpq %rcx,RIP+8(%rsp)
>-	je error_bad_iret
>+	je	.Lerror_bad_iret
> 	movl %ecx,%eax	/* zero extend */
> 	cmpq %rax,RIP+8(%rsp)
>-	je bstep_iret
>+	je	.Lbstep_iret
> 	cmpq $gs_change,RIP+8(%rsp)
>-	je error_swapgs
>-	jmp error_sti
>+	jne	.Lerror_entry_done_lfence
>+
>+	/*
>+	 * hack: gs_change can fail with user gsbase.  If this happens, fix up
>+	 * gsbase and proceed.  We'll fix up the exception and land in
>+	 * gs_change's error handler with kernel gsbase.
>+	 */
>+	SWAPGS
>+	FENCE_SWAPGS_USER_ENTRY
>+	jmp .Lerror_entry_done
>=20
>-bstep_iret:
>+.Lbstep_iret:
> 	/* Fix truncated RIP */
> 	movq %rcx,RIP+8(%rsp)
> 	/* fall through */
>=20
>-error_bad_iret:
>+.Lerror_bad_iret:
>+	/*
>+	 * We came from an IRET to user mode, so we have user gsbase.
>+	 * Switch to kernel gsbase:
>+	 */
> 	SWAPGS
>+	FENCE_SWAPGS_USER_ENTRY
>+
>+	/*
>+	 * Pretend that the exception came from user mode: set up pt_regs
>+	 * as if we faulted immediately after IRET.
>+	 */
> 	mov %rsp,%rdi
> 	call fixup_bad_iret
> 	mov %rax,%rsp
>-	jmp error_sti
>+	jmp	.Lerror_entry_from_usermode_after_swapgs
> 	CFI_ENDPROC
> END(error_entry)
>=20
>@@ -1579,6 +1626,7 @@ ENTRY(nmi)
> 	 * to switch CR3 here.
> 	 */
> 	cld
>+	FENCE_SWAPGS_USER_ENTRY
> 	movq	%rsp, %rdx
> 	movq	PER_CPU_VAR(kernel_stack), %rsp
> 	addq	$KERNEL_STACK_OFFSET, %rsp
>@@ -1624,6 +1672,7 @@ ENTRY(nmi)
> 	movq	%rax, %cr3
> 2:
> #endif
>+	FENCE_SWAPGS_KERNEL_ENTRY
> 	call	do_nmi
>=20
> #ifdef CONFIG_PAGE_TABLE_ISOLATION
>diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core=
=2Ec
>index 608f18c62412..cb6657f35f41 100644
>--- a/arch/x86/kernel/kprobes/core.c
>+++ b/arch/x86/kernel/kprobes/core.c
>@@ -494,6 +494,7 @@ void arch_prepare_kretprobe(struct kretprobe_instance =
*ri, struct pt_regs *regs)
> 	unsigned long *sara =3D stack_addr(regs);
>=20
> 	ri->ret_addr =3D (kprobe_opcode_t *) *sara;
>+	ri->fp =3D sara;
>=20
> 	/* Replace the return addr with trampoline addr */
> 	*sara =3D (unsigned long) &kretprobe_trampoline;
>@@ -685,26 +686,48 @@ static void __used kretprobe_trampoline_holder(void)
> NOKPROBE_SYMBOL(kretprobe_trampoline_holder);
> NOKPROBE_SYMBOL(kretprobe_trampoline);
>=20
>+static struct kprobe kretprobe_kprobe =3D {
>+	.addr =3D (void *)kretprobe_trampoline,
>+};
>+
> /*
>  * Called from kretprobe_trampoline
>  */
> __visible __used void *trampoline_handler(struct pt_regs *regs)
> {
>+	struct kprobe_ctlblk *kcb;
> 	struct kretprobe_instance *ri =3D NULL;
> 	struct hlist_head *head, empty_rp;
> 	struct hlist_node *tmp;
> 	unsigned long flags, orig_ret_address =3D 0;
> 	unsigned long trampoline_address =3D (unsigned long)&kretprobe_trampolin=
e;
> 	kprobe_opcode_t *correct_ret_addr =3D NULL;
>+	void *frame_pointer;
>+	bool skipped =3D false;
>+
>+	preempt_disable();
>+
>+	/*
>+	 * Set a dummy kprobe for avoiding kretprobe recursion.
>+	 * Since kretprobe never run in kprobe handler, kprobe must not
>+	 * be running at this point.
>+	 */
>+	kcb =3D get_kprobe_ctlblk();
>+	__this_cpu_write(current_kprobe, &kretprobe_kprobe);
>+	kcb->kprobe_status =3D KPROBE_HIT_ACTIVE;
>=20
> 	INIT_HLIST_HEAD(&empty_rp);
> 	kretprobe_hash_lock(current, &head, &flags);
> 	/* fixup registers */
> #ifdef CONFIG_X86_64
> 	regs->cs =3D __KERNEL_CS;
>+	/* On x86-64, we use pt_regs->sp for return address holder. */
>+	frame_pointer =3D &regs->sp;
> #else
> 	regs->cs =3D __KERNEL_CS | get_kernel_rpl();
> 	regs->gs =3D 0;
>+	/* On x86-32, we use pt_regs->flags for return address holder. */
>+	frame_pointer =3D &regs->flags;
> #endif
> 	regs->ip =3D trampoline_address;
> 	regs->orig_ax =3D ~0UL;
>@@ -726,8 +749,25 @@ __visible __used void *trampoline_handler(struct pt_r=
egs *regs)
> 		if (ri->task !=3D current)
> 			/* another task is sharing our hash bucket */
> 			continue;
>+		/*
>+		 * Return probes must be pushed on this hash list correct
>+		 * order (same as return order) so that it can be poped
>+		 * correctly. However, if we find it is pushed it incorrect
>+		 * order, this means we find a function which should not be
>+		 * probed, because the wrong order entry is pushed on the
>+		 * path of processing other kretprobe itself.
>+		 */
>+		if (ri->fp !=3D frame_pointer) {
>+			if (!skipped)
>+				pr_warn("kretprobe is stacked incorrectly. Trying to fixup.\n");
>+			skipped =3D true;
>+			continue;
>+		}
>=20
> 		orig_ret_address =3D (unsigned long)ri->ret_addr;
>+		if (skipped)
>+			pr_warn("%ps must be blacklisted because of incorrect kretprobe order\=
n",
>+				ri->rp->kp.addr);
>=20
> 		if (orig_ret_address !=3D trampoline_address)
> 			/*
>@@ -745,14 +785,15 @@ __visible __used void *trampoline_handler(struct pt_=
regs *regs)
> 		if (ri->task !=3D current)
> 			/* another task is sharing our hash bucket */
> 			continue;
>+		if (ri->fp !=3D frame_pointer)
>+			continue;
>=20
> 		orig_ret_address =3D (unsigned long)ri->ret_addr;
> 		if (ri->rp && ri->rp->handler) {
> 			__this_cpu_write(current_kprobe, &ri->rp->kp);
>-			get_kprobe_ctlblk()->kprobe_status =3D KPROBE_HIT_ACTIVE;
> 			ri->ret_addr =3D correct_ret_addr;
> 			ri->rp->handler(ri, regs);
>-			__this_cpu_write(current_kprobe, NULL);
>+			__this_cpu_write(current_kprobe, &kretprobe_kprobe);
> 		}
>=20
> 		recycle_rp_inst(ri, &empty_rp);
>@@ -768,6 +809,9 @@ __visible __used void *trampoline_handler(struct pt_re=
gs *regs)
>=20
> 	kretprobe_hash_unlock(current, &flags);
>=20
>+	__this_cpu_write(current_kprobe, NULL);
>+	preempt_enable();
>+
> 	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
> 		hlist_del(&ri->hlist);
> 		kfree(ri);
>diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
>index 074510b5ea77..feca78bf2a6b 100644
>--- a/arch/x86/kernel/process.c
>+++ b/arch/x86/kernel/process.c
>@@ -351,6 +351,8 @@ static __always_inline void __speculation_ctrl_update(=
unsigned long tifp,
> 	u64 msr =3D x86_spec_ctrl_base;
> 	bool updmsr =3D false;
>=20
>+	lockdep_assert_irqs_disabled();
>+
> 	/*
> 	 * If TIF_SSBD is different, select the proper mitigation
> 	 * method. Note that if SSBD mitigation is disabled or permanentely
>@@ -402,10 +404,12 @@ static unsigned long speculation_ctrl_update_tif(str=
uct task_struct *tsk)
>=20
> void speculation_ctrl_update(unsigned long tif)
> {
>+	unsigned long flags;
>+
> 	/* Forced update. Make sure all relevant TIF flags are different */
>-	preempt_disable();
>+	local_irq_save(flags);
> 	__speculation_ctrl_update(~tif, tif);
>-	preempt_enable();
>+	local_irq_restore(flags);
> }
>=20
> /* Called from seccomp/prctl update */
>diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>index 95cd58cdee99..6531ffcb174b 100644
>--- a/arch/x86/kvm/cpuid.c
>+++ b/arch/x86/kvm/cpuid.c
>@@ -395,6 +395,11 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_ent=
ry2 *entry, u32 function,
> 			entry->ebx |=3D F(TSC_ADJUST);
> 			entry->edx &=3D kvm_cpuid_7_0_edx_x86_features;
> 			cpuid_mask(&entry->edx, 10);
>+			/*
>+			 * We emulate ARCH_CAPABILITIES in software even
>+			 * if the host doesn't support it.
>+			 */
>+			entry->edx |=3D F(ARCH_CAPABILITIES);
> 		} else {
> 			entry->ebx =3D 0;
> 			entry->edx =3D 0;
>diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>index c81ccc0d8da0..886fb53b4604 100644
>--- a/arch/x86/kvm/mmu.c
>+++ b/arch/x86/kvm/mmu.c
>@@ -1492,7 +1492,7 @@ static int is_empty_shadow_page(u64 *spt)
>  * aggregate version in order to make the slab shrinker
>  * faster
>  */
>-static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
>+static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, unsigned long =
nr)
> {
> 	kvm->arch.n_used_mmu_pages +=3D nr;
> 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
>@@ -2207,7 +2207,7 @@ static bool prepare_zap_oldest_mmu_page(struct kvm *=
kvm,
>  * Changing the number of mmu pages allocated to the vm
>  * Note: if goal_nr_mmu_pages is too small, you will get dead lock
>  */
>-void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int goal_nr_mmu_p=
ages)
>+void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long goal_nr_mmu_=
pages)
> {
> 	LIST_HEAD(invalid_list);
>=20
>@@ -4505,10 +4505,10 @@ int kvm_mmu_module_init(void)
> /*
>  * Caculate mmu pages needed for kvm.
>  */
>-unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm)
>+unsigned long kvm_mmu_calculate_mmu_pages(struct kvm *kvm)
> {
>-	unsigned int nr_mmu_pages;
>-	unsigned int  nr_pages =3D 0;
>+	unsigned long nr_mmu_pages;
>+	unsigned long nr_pages =3D 0;
> 	struct kvm_memslots *slots;
> 	struct kvm_memory_slot *memslot;
>=20
>@@ -4518,8 +4518,7 @@ unsigned int kvm_mmu_calculate_mmu_pages(struct kvm =
*kvm)
> 		nr_pages +=3D memslot->npages;
>=20
> 	nr_mmu_pages =3D nr_pages * KVM_PERMILLE_MMU_PAGES / 1000;
>-	nr_mmu_pages =3D max(nr_mmu_pages,
>-			(unsigned int) KVM_MIN_ALLOC_MMU_PAGES);
>+	nr_mmu_pages =3D max(nr_mmu_pages, KVM_MIN_ALLOC_MMU_PAGES);
>=20
> 	return nr_mmu_pages;
> }
>diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>index 58b2f51fdfdc..f3dc8f614512 100644
>--- a/arch/x86/kvm/mmu.h
>+++ b/arch/x86/kvm/mmu.h
>@@ -81,7 +81,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, stru=
ct kvm_mmu *context,
> 		bool execonly);
> bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
>=20
>-static inline unsigned int kvm_mmu_available_pages(struct kvm *kvm)
>+static inline unsigned long kvm_mmu_available_pages(struct kvm *kvm)
> {
> 	if (kvm->arch.n_max_mmu_pages > kvm->arch.n_used_mmu_pages)
> 		return kvm->arch.n_max_mmu_pages -
>diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>index bd6b883f3075..00dd9ea13c22 100644
>--- a/arch/x86/kvm/vmx.c
>+++ b/arch/x86/kvm/vmx.c
>@@ -433,7 +433,6 @@ struct vcpu_vmx {
> 	u64 		      msr_guest_kernel_gs_base;
> #endif
>=20
>-	u64 		      arch_capabilities;
> 	u64 		      spec_ctrl;
>=20
> 	u32 vm_entry_controls_shadow;
>@@ -2481,12 +2480,6 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struc=
t msr_data *msr_info)
>=20
> 		msr_info->data =3D to_vmx(vcpu)->spec_ctrl;
> 		break;
>-	case MSR_IA32_ARCH_CAPABILITIES:
>-		if (!msr_info->host_initiated &&
>-		    !guest_cpuid_has_arch_capabilities(vcpu))
>-			return 1;
>-		msr_info->data =3D to_vmx(vcpu)->arch_capabilities;
>-		break;
> 	case MSR_IA32_SYSENTER_CS:
> 		msr_info->data =3D vmcs_read32(GUEST_SYSENTER_CS);
> 		break;
>@@ -2636,11 +2629,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struc=
t msr_data *msr_info)
> 		vmx_disable_intercept_for_msr(vmx->vmcs01.msr_bitmap, MSR_IA32_PRED_CMD,
> 					      MSR_TYPE_W);
> 		break;
>-	case MSR_IA32_ARCH_CAPABILITIES:
>-		if (!msr_info->host_initiated)
>-			return 1;
>-		vmx->arch_capabilities =3D data;
>-		break;
> 	case MSR_IA32_CR_PAT:
> 		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {
> 			if (!kvm_mtrr_valid(vcpu, MSR_IA32_CR_PAT, data))
>@@ -4583,9 +4571,6 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
> 		++vmx->nmsrs;
> 	}
>=20
>-	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
>-		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, vmx->arch_capabilities);
>-
> 	vm_exit_controls_init(vmx, vmcs_config.vmexit_ctrl);
>=20
> 	/* 22.2.1, 20.8.1 */
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index cab3ca9d3f03..2c0f1ea119d6 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -2089,6 +2089,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struc=
t msr_data *msr_info)
> 	case MSR_F15H_EX_CFG:
> 		break;
>=20
>+	case MSR_IA32_ARCH_CAPABILITIES:
>+		if (!msr_info->host_initiated)
>+			return 1;
>+		vcpu->arch.arch_capabilities =3D data;
>+		break;
> 	case MSR_EFER:
> 		return set_efer(vcpu, data);
> 	case MSR_K7_HWCR:
>@@ -2479,6 +2484,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struc=
t msr_data *msr_info)
> 	case MSR_IA32_UCODE_REV:
> 		msr_info->data =3D 0x100000000ULL;
> 		break;
>+	case MSR_IA32_ARCH_CAPABILITIES:
>+		if (!msr_info->host_initiated &&
>+		    !guest_cpuid_has_arch_capabilities(vcpu))
>+			return 1;
>+		msr_info->data =3D vcpu->arch.arch_capabilities;
>+		break;
> 	case MSR_MTRRcap:
> 		msr_info->data =3D 0x500 | KVM_NR_VAR_MTRR;
> 		break;
>@@ -3518,7 +3529,7 @@ static int kvm_vm_ioctl_set_identity_map_addr(struct=
 kvm *kvm,
> }
>=20
> static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
>-					  u32 kvm_nr_mmu_pages)
>+					 unsigned long kvm_nr_mmu_pages)
> {
> 	if (kvm_nr_mmu_pages < KVM_MIN_ALLOC_MMU_PAGES)
> 		return -EINVAL;
>@@ -3532,7 +3543,7 @@ static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm =
*kvm,
> 	return 0;
> }
>=20
>-static int kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
>+static unsigned long kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
> {
> 	return kvm->arch.n_max_mmu_pages;
> }
>@@ -6957,6 +6968,9 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
> {
> 	int r;
>=20
>+	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
>+		rdmsrl(MSR_IA32_ARCH_CAPABILITIES,
>+		       vcpu->arch.arch_capabilities);
> 	vcpu->arch.mtrr_state.have_fixed =3D 1;
> 	r =3D vcpu_load(vcpu);
> 	if (r)
>diff --git a/arch/xtensa/kernel/stacktrace.c b/arch/xtensa/kernel/stacktra=
ce.c
>index 7d2c317bd98b..922525c0d25c 100644
>--- a/arch/xtensa/kernel/stacktrace.c
>+++ b/arch/xtensa/kernel/stacktrace.c
>@@ -107,10 +107,14 @@ static int return_address_cb(struct stackframe *fram=
e, void *data)
> 	return 1;
> }
>=20
>+/*
>+ * level =3D=3D 0 is for the return address from the caller of this funct=
ion,
>+ * not from this function itself.
>+ */
> unsigned long return_address(unsigned level)
> {
> 	struct return_addr_data r =3D {
>-		.skip =3D level + 1,
>+		.skip =3D level,
> 	};
> 	walk_stackframe(stack_pointer(NULL), return_address_cb, &r);
> 	return r.addr;
>diff --git a/block/bio.c b/block/bio.c
>index 4218dab2bb47..3163dac6735d 100644
>--- a/block/bio.c
>+++ b/block/bio.c
>@@ -1216,8 +1216,11 @@ struct bio *bio_copy_user_iov(struct request_queue =
*q,
> 			}
> 		}
>=20
>-		if (bio_add_pc_page(q, bio, page, bytes, offset) < bytes)
>+		if (bio_add_pc_page(q, bio, page, bytes, offset) < bytes) {
>+			if (!map_data)
>+				__free_page(page);
> 			break;
>+		}
>=20
> 		len -=3D bytes;
> 		offset =3D 0;
>diff --git a/drivers/acpi/acpica/nsobject.c b/drivers/acpi/acpica/nsobject=
=2Ec
>index f1ea8e56cd87..7abcfa6b055c 100644
>--- a/drivers/acpi/acpica/nsobject.c
>+++ b/drivers/acpi/acpica/nsobject.c
>@@ -222,6 +222,10 @@ void acpi_ns_detach_object(struct acpi_namespace_node=
 *node)
> 		}
> 	}
>=20
>+	if (obj_desc->common.type =3D=3D ACPI_TYPE_REGION) {
>+		acpi_ut_remove_address_range(obj_desc->region.space_id, node);
>+	}
>+
> 	/* Clear the Node entry in all cases */
>=20
> 	node->object =3D NULL;
>diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
>index df51673d6591..3999b8c6a09d 100644
>--- a/drivers/block/floppy.c
>+++ b/drivers/block/floppy.c
>@@ -2113,6 +2113,9 @@ static void setup_format_params(int track)
> 	raw_cmd->kernel_data =3D floppy_track_buffer;
> 	raw_cmd->length =3D 4 * F_SECT_PER_TRACK;
>=20
>+	if (!F_SECT_PER_TRACK)
>+		return;
>+
> 	/* allow for about 30ms for data transport per track */
> 	head_shift =3D (F_SECT_PER_TRACK + 5) / 6;
>=20
>@@ -3233,8 +3236,12 @@ static int set_geometry(unsigned int cmd, struct fl=
oppy_struct *g,
> 	int cnt;
>=20
> 	/* sanity checking for parameters. */
>-	if (g->sect <=3D 0 ||
>-	    g->head <=3D 0 ||
>+	if ((int)g->sect <=3D 0 ||
>+	    (int)g->head <=3D 0 ||
>+	    /* check for overflow in max_sector */
>+	    (int)(g->sect * g->head) <=3D 0 ||
>+	    /* check for zero in F_SECT_PER_TRACK */
>+	    (unsigned char)((g->sect << 2) >> FD_SIZECODE(g)) =3D=3D 0 ||
> 	    g->track <=3D 0 || g->track > UDP->tracks >> STRETCH(g) ||
> 	    /* check if reserved bits are set */
> 	    (g->stretch & ~(FD_STRETCH | FD_SWAPSIDES | FD_SECTBASEMASK)) !=3D 0)
>@@ -3378,6 +3385,24 @@ static int fd_getgeo(struct block_device *bdev, str=
uct hd_geometry *geo)
> 	return 0;
> }
>=20
>+static bool valid_floppy_drive_params(const short autodetect[8],
>+		int native_format)
>+{
>+	size_t floppy_type_size =3D ARRAY_SIZE(floppy_type);
>+	size_t i =3D 0;
>+
>+	for (i =3D 0; i < 8; ++i) {
>+		if (autodetect[i] < 0 ||
>+		    autodetect[i] >=3D floppy_type_size)
>+			return false;
>+	}
>+
>+	if (native_format < 0 || native_format >=3D floppy_type_size)
>+		return false;
>+
>+	return true;
>+}
>+
> static int fd_locked_ioctl(struct block_device *bdev, fmode_t mode, unsig=
ned int cmd,
> 		    unsigned long param)
> {
>@@ -3504,6 +3529,9 @@ static int fd_locked_ioctl(struct block_device *bdev=
, fmode_t mode, unsigned int
> 		SUPBOUND(size, strlen((const char *)outparam) + 1);
> 		break;
> 	case FDSETDRVPRM:
>+		if (!valid_floppy_drive_params(inparam.dp.autodetect,
>+				inparam.dp.native_format))
>+			return -EINVAL;
> 		*UDP =3D inparam.dp;
> 		break;
> 	case FDGETDRVPRM:
>diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
>index ab3ea62e5dfc..f98a9207ec7e 100644
>--- a/drivers/block/xsysace.c
>+++ b/drivers/block/xsysace.c
>@@ -1062,6 +1062,8 @@ static int ace_setup(struct ace_device *ace)
> 	return 0;
>=20
> err_read:
>+	/* prevent double queue cleanup */
>+	ace->gd->queue =3D NULL;
> 	put_disk(ace->gd);
> err_alloc_disk:
> 	blk_cleanup_queue(ace->queue);
>diff --git a/drivers/bluetooth/hci_ath.c b/drivers/bluetooth/hci_ath.c
>index 0bc8a6a6a148..353ed68db711 100644
>--- a/drivers/bluetooth/hci_ath.c
>+++ b/drivers/bluetooth/hci_ath.c
>@@ -112,6 +112,9 @@ static int ath_open(struct hci_uart *hu)
>=20
> 	BT_DBG("hu %p", hu);
>=20
>+	if (!hci_uart_has_flow_control(hu))
>+		return -EOPNOTSUPP;
>+
> 	ath =3D kzalloc(sizeof(*ath), GFP_KERNEL);
> 	if (!ath)
> 		return -ENOMEM;
>diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
>index e00f8f5b5c8e..9ad437053e22 100644
>--- a/drivers/bluetooth/hci_ldisc.c
>+++ b/drivers/bluetooth/hci_ldisc.c
>@@ -261,6 +261,15 @@ static int hci_uart_send_frame(struct hci_dev *hdev, =
struct sk_buff *skb)
> 	return 0;
> }
>=20
>+/* Check the underlying device or tty has flow control support */
>+bool hci_uart_has_flow_control(struct hci_uart *hu)
>+{
>+	if (hu->tty->driver->ops->tiocmget && hu->tty->driver->ops->tiocmset)
>+		return true;
>+
>+	return false;
>+}
>+
> /* ------ LDISC part ------ */
> /* hci_uart_tty_open
>  *
>diff --git a/drivers/bluetooth/hci_uart.h b/drivers/bluetooth/hci_uart.h
>index 12df101ca942..58e0bb8c041b 100644
>--- a/drivers/bluetooth/hci_uart.h
>+++ b/drivers/bluetooth/hci_uart.h
>@@ -90,6 +90,7 @@ int hci_uart_register_proto(struct hci_uart_proto *p);
> int hci_uart_unregister_proto(struct hci_uart_proto *p);
> int hci_uart_tx_wakeup(struct hci_uart *hu);
> int hci_uart_init_ready(struct hci_uart *hu);
>+bool hci_uart_has_flow_control(struct hci_uart *hu);
>=20
> #ifdef CONFIG_BT_HCIUART_H4
> int h4_init(void);
>diff --git a/drivers/gpio/gpio-adnp.c b/drivers/gpio/gpio-adnp.c
>index b2239d678d01..f2c092676e01 100644
>--- a/drivers/gpio/gpio-adnp.c
>+++ b/drivers/gpio/gpio-adnp.c
>@@ -140,8 +140,10 @@ static int adnp_gpio_direction_input(struct gpio_chip=
 *chip, unsigned offset)
> 	if (err < 0)
> 		goto out;
>=20
>-	if (err & BIT(pos))
>-		err =3D -EACCES;
>+	if (value & BIT(pos)) {
>+		err =3D -EPERM;
>+		goto out;
>+	}
>=20
> 	err =3D 0;
>=20
>diff --git a/drivers/iio/adc/ad_sigma_delta.c b/drivers/iio/adc/ad_sigma_d=
elta.c
>index dbcea7941059..3837cbdaf100 100644
>--- a/drivers/iio/adc/ad_sigma_delta.c
>+++ b/drivers/iio/adc/ad_sigma_delta.c
>@@ -121,6 +121,7 @@ static int ad_sd_read_reg_raw(struct ad_sigma_delta *s=
igma_delta,
> 	if (sigma_delta->info->has_registers) {
> 		data[0] =3D reg << sigma_delta->info->addr_shift;
> 		data[0] |=3D sigma_delta->info->read_mask;
>+		data[0] |=3D sigma_delta->comm;
> 		spi_message_add_tail(&t[0], &m);
> 	}
> 	spi_message_add_tail(&t[1], &m);
>diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
>index 10d5ec213091..2f7ad2538cec 100644
>--- a/drivers/iio/adc/at91_adc.c
>+++ b/drivers/iio/adc/at91_adc.c
>@@ -702,23 +702,29 @@ static int at91_adc_read_raw(struct iio_dev *idev,
> 		ret =3D wait_event_interruptible_timeout(st->wq_data_avail,
> 						       st->done,
> 						       msecs_to_jiffies(1000));
>-		if (ret =3D=3D 0)
>-			ret =3D -ETIMEDOUT;
>-		if (ret < 0) {
>-			mutex_unlock(&st->lock);
>-			return ret;
>-		}
>-
>-		*val =3D st->last_value;
>=20
>+		/* Disable interrupts, regardless if adc conversion was
>+		 * successful or not
>+		 */
> 		at91_adc_writel(st, AT91_ADC_CHDR,
> 				AT91_ADC_CH(chan->channel));
> 		at91_adc_writel(st, AT91_ADC_IDR, BIT(chan->channel));
>=20
>-		st->last_value =3D 0;
>-		st->done =3D false;
>+		if (ret > 0) {
>+			/* a valid conversion took place */
>+			*val =3D st->last_value;
>+			st->last_value =3D 0;
>+			st->done =3D false;
>+			ret =3D IIO_VAL_INT;
>+		} else if (ret =3D=3D 0) {
>+			/* conversion timeout */
>+			dev_err(&idev->dev, "ADC Channel %d timeout.\n",
>+				chan->channel);
>+			ret =3D -ETIMEDOUT;
>+		}
>+
> 		mutex_unlock(&st->lock);
>-		return IIO_VAL_INT;
>+		return ret;
>=20
> 	case IIO_CHAN_INFO_SCALE:
> 		*val =3D st->vref_mv;
>diff --git a/drivers/iio/dac/mcp4725.c b/drivers/iio/dac/mcp4725.c
>index b4dde8315210..89f695a958e9 100644
>--- a/drivers/iio/dac/mcp4725.c
>+++ b/drivers/iio/dac/mcp4725.c
>@@ -86,6 +86,7 @@ static ssize_t mcp4725_store_eeprom(struct device *dev,
> 		return 0;
>=20
> 	inoutbuf[0] =3D 0x60; /* write EEPROM */
>+	inoutbuf[0] |=3D data->powerdown ? ((data->powerdown_mode + 1) << 1) : 0;
> 	inoutbuf[1] =3D data->dac_value >> 4;
> 	inoutbuf[2] =3D (data->dac_value & 0xf) << 4;
>=20
>diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-=
buffer.c
>index 7562531ebf0e..77b19ca8b763 100644
>--- a/drivers/iio/industrialio-buffer.c
>+++ b/drivers/iio/industrialio-buffer.c
>@@ -836,10 +836,8 @@ int iio_scan_mask_set(struct iio_dev *indio_dev,
> 	const unsigned long *mask;
> 	unsigned long *trialmask;
>=20
>-	trialmask =3D kmalloc(sizeof(*trialmask)*
>-			    BITS_TO_LONGS(indio_dev->masklength),
>-			    GFP_KERNEL);
>-
>+	trialmask =3D kcalloc(BITS_TO_LONGS(indio_dev->masklength),
>+			    sizeof(*trialmask), GFP_KERNEL);
> 	if (trialmask =3D=3D NULL)
> 		return -ENOMEM;
> 	if (!indio_dev->masklength) {
>diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-co=
re.c
>index 4d1b400ed260..5ea56edcdf42 100644
>--- a/drivers/iio/industrialio-core.c
>+++ b/drivers/iio/industrialio-core.c
>@@ -1195,12 +1195,12 @@ EXPORT_SYMBOL(iio_device_register);
>  **/
> void iio_device_unregister(struct iio_dev *indio_dev)
> {
>-	mutex_lock(&indio_dev->info_exist_lock);
>-
> 	device_del(&indio_dev->dev);
>=20
> 	if (indio_dev->chrdev.dev)
> 		cdev_del(&indio_dev->chrdev);
>+
>+	mutex_lock(&indio_dev->info_exist_lock);
> 	iio_device_unregister_debugfs(indio_dev);
>=20
> 	iio_disable_all_buffers(indio_dev);
>diff --git a/drivers/infiniband/hw/mlx4/alias_GUID.c b/drivers/infiniband/=
hw/mlx4/alias_GUID.c
>index 0eb141c41416..fb60229bf191 100644
>--- a/drivers/infiniband/hw/mlx4/alias_GUID.c
>+++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
>@@ -579,8 +579,8 @@ void mlx4_ib_destroy_alias_guid_service(struct mlx4_ib=
_dev *dev)
> 	unsigned long flags;
>=20
> 	for (i =3D 0 ; i < dev->num_ports; i++) {
>-		cancel_delayed_work(&dev->sriov.alias_guid.ports_guid[i].alias_guid_wor=
k);
> 		det =3D &sriov->alias_guid.ports_guid[i];
>+		cancel_delayed_work_sync(&det->alias_guid_work);
> 		spin_lock_irqsave(&sriov->alias_guid.ag_work_lock, flags);
> 		while (!list_empty(&det->cb_list)) {
> 			cb_ctx =3D list_entry(det->cb_list.next,
>diff --git a/drivers/input/tablet/gtco.c b/drivers/input/tablet/gtco.c
>index fe1ab5067b5d..cf3af3a3297a 100644
>--- a/drivers/input/tablet/gtco.c
>+++ b/drivers/input/tablet/gtco.c
>@@ -78,6 +78,7 @@ Scott Hill shill@gtcocalcomp.com
>=20
> /* Max size of a single report */
> #define REPORT_MAX_SIZE       10
>+#define MAX_COLLECTION_LEVELS  10
>=20
>=20
> /* Bitmask whether pen is in range */
>@@ -224,8 +225,7 @@ static void parse_hid_report_descriptor(struct gtco *d=
evice, char * report,
> 	char  maintype =3D 'x';
> 	char  globtype[12];
> 	int   indent =3D 0;
>-	char  indentstr[10] =3D "";
>-
>+	char  indentstr[MAX_COLLECTION_LEVELS + 1] =3D { 0 };
>=20
> 	dev_dbg(ddev, "=3D=3D=3D=3D=3D=3D>>>>>>PARSE<<<<<<=3D=3D=3D=3D=3D=3D\n");
>=20
>@@ -351,6 +351,13 @@ static void parse_hid_report_descriptor(struct gtco *=
device, char * report,
> 			case TAG_MAIN_COL_START:
> 				maintype =3D 'S';
>=20
>+				if (indent =3D=3D MAX_COLLECTION_LEVELS) {
>+					dev_err(ddev, "Collection level %d would exceed limit of %d\n",
>+						indent + 1,
>+						MAX_COLLECTION_LEVELS);
>+					break;
>+				}
>+
> 				if (data =3D=3D 0) {
> 					dev_dbg(ddev, "=3D=3D=3D=3D=3D=3D>>>>>> Physical\n");
> 					strcpy(globtype, "Physical");
>@@ -370,8 +377,15 @@ static void parse_hid_report_descriptor(struct gtco *=
device, char * report,
> 				break;
>=20
> 			case TAG_MAIN_COL_END:
>-				dev_dbg(ddev, "<<<<<<=3D=3D=3D=3D=3D=3D\n");
> 				maintype =3D 'E';
>+
>+				if (indent =3D=3D 0) {
>+					dev_err(ddev, "Collection level already at zero\n");
>+					break;
>+				}
>+
>+				dev_dbg(ddev, "<<<<<<=3D=3D=3D=3D=3D=3D\n");
>+
> 				indent--;
> 				for (x =3D 0; x < indent; x++)
> 					indentstr[x] =3D '-';
>diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init=
=2Ec
>index 48b726f4ad48..006f4f9a3170 100644
>--- a/drivers/iommu/amd_iommu_init.c
>+++ b/drivers/iommu/amd_iommu_init.c
>@@ -293,7 +293,7 @@ static void iommu_write_l2(struct amd_iommu *iommu, u8=
 address, u32 val)
> static void iommu_set_exclusion_range(struct amd_iommu *iommu)
> {
> 	u64 start =3D iommu->exclusion_start & PAGE_MASK;
>-	u64 limit =3D (start + iommu->exclusion_length) & PAGE_MASK;
>+	u64 limit =3D (start + iommu->exclusion_length - 1) & PAGE_MASK;
> 	u64 entry;
>=20
> 	if (!iommu->exclusion_start)
>diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
>index b60eb1cca150..c2a44d2ca5b6 100644
>--- a/drivers/iommu/intel-iommu.c
>+++ b/drivers/iommu/intel-iommu.c
>@@ -1394,6 +1394,9 @@ static void iommu_disable_protect_mem_regions(struct=
 intel_iommu *iommu)
> 	u32 pmen;
> 	unsigned long flags;
>=20
>+	if (!cap_plmr(iommu->cap) && !cap_phmr(iommu->cap))
>+		return;
>+
> 	raw_spin_lock_irqsave(&iommu->register_lock, flags);
> 	pmen =3D readl(iommu->reg + DMAR_PMEN_REG);
> 	pmen &=3D ~DMA_PMEN_EPM;
>diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>index f5f1837dfa5b..b010f9600d87 100644
>--- a/drivers/md/dm-table.c
>+++ b/drivers/md/dm-table.c
>@@ -1432,6 +1432,36 @@ static bool dm_table_supports_write_same(struct dm_=
table *t)
> 	return true;
> }
>=20
>+static int device_requires_stable_pages(struct dm_target *ti,
>+					struct dm_dev *dev, sector_t start,
>+					sector_t len, void *data)
>+{
>+	struct request_queue *q =3D bdev_get_queue(dev->bdev);
>+
>+	return q && bdi_cap_stable_pages_required(&q->backing_dev_info);
>+}
>+
>+/*
>+ * If any underlying device requires stable pages, a table must require
>+ * them as well.  Only targets that support iterate_devices are considere=
d:
>+ * don't want error, zero, etc to require stable pages.
>+ */
>+static bool dm_table_requires_stable_pages(struct dm_table *t)
>+{
>+	struct dm_target *ti;
>+	unsigned i;
>+
>+	for (i =3D 0; i < dm_table_get_num_targets(t); i++) {
>+		ti =3D dm_table_get_target(t, i);
>+
>+		if (ti->type->iterate_devices &&
>+		    ti->type->iterate_devices(ti, device_requires_stable_pages, NULL))
>+			return true;
>+	}
>+
>+	return false;
>+}
>+
> void dm_table_set_restrictions(struct dm_table *t, struct request_queue *=
q,
> 			       struct queue_limits *limits)
> {
>@@ -1473,6 +1503,15 @@ void dm_table_set_restrictions(struct dm_table *t, =
struct request_queue *q,
>=20
> 	dm_table_set_integrity(t);
>=20
>+	/*
>+	 * Some devices don't use blk_integrity but still want stable pages
>+	 * because they do their own checksumming.
>+	 */
>+	if (dm_table_requires_stable_pages(t))
>+		q->backing_dev_info.capabilities |=3D BDI_CAP_STABLE_WRITES;
>+	else
>+		q->backing_dev_info.capabilities &=3D ~BDI_CAP_STABLE_WRITES;
>+
> 	/*
> 	 * Determine whether or not this queue's I/O timings contribute
> 	 * to the entropy pool, Only request-based targets use this.
>diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>index 043ad8d8d700..30ae713aecf8 100644
>--- a/drivers/md/dm.c
>+++ b/drivers/md/dm.c
>@@ -756,6 +756,15 @@ static void dec_pending(struct dm_io *io, int error)
> 	}
> }
>=20
>+static void disable_discard(struct mapped_device *md)
>+{
>+	struct queue_limits *limits =3D dm_get_queue_limits(md);
>+
>+	/* device doesn't really support DISCARD, disable it */
>+	limits->max_discard_sectors =3D 0;
>+	queue_flag_clear(QUEUE_FLAG_DISCARD, md->queue);
>+}
>+
> static void disable_write_same(struct mapped_device *md)
> {
> 	struct queue_limits *limits =3D dm_get_queue_limits(md);
>@@ -792,9 +801,14 @@ static void clone_endio(struct bio *bio, int error)
> 		}
> 	}
>=20
>-	if (unlikely(r =3D=3D -EREMOTEIO && (bio->bi_rw & REQ_WRITE_SAME) &&
>-		     !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors))
>-		disable_write_same(md);
>+	if (unlikely(r =3D=3D -EREMOTEIO)) {
>+		if (bio->bi_rw & REQ_DISCARD &&
>+		    !bdev_get_queue(bio->bi_bdev)->limits.max_discard_sectors)
>+			disable_discard(md);
>+		else if (bio->bi_rw & REQ_WRITE_SAME &&
>+			 !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors)
>+ 			disable_write_same(md);
>+	}
>=20
> 	free_tio(md, tio);
> 	dec_pending(io, error);
>@@ -996,9 +1010,14 @@ static void dm_done(struct request *clone, int error=
, bool mapped)
> 			r =3D rq_end_io(tio->ti, clone, error, &tio->info);
> 	}
>=20
>-	if (unlikely(r =3D=3D -EREMOTEIO && (clone->cmd_flags & REQ_WRITE_SAME) =
&&
>-		     !clone->q->limits.max_write_same_sectors))
>-		disable_write_same(tio->md);
>+	if (unlikely(r =3D=3D -EREMOTEIO)) {
>+		if (clone->cmd_flags & REQ_DISCARD &&
>+		    !clone->q->limits.max_discard_sectors)
>+			disable_discard(tio->md);
>+		else if (clone->cmd_flags & REQ_WRITE_SAME &&
>+			 !clone->q->limits.max_write_same_sectors)
>+			disable_write_same(tio->md);
>+	}
>=20
> 	if (r <=3D 0)
> 		/* The target wants to complete the I/O */
>diff --git a/drivers/media/usb/tlg2300/pd-common.h b/drivers/media/usb/tlg=
2300/pd-common.h
>index 9e23ad32d2fe..562a58886ca2 100644
>--- a/drivers/media/usb/tlg2300/pd-common.h
>+++ b/drivers/media/usb/tlg2300/pd-common.h
>@@ -257,7 +257,7 @@ void set_debug_mode(struct video_device *vfd, int debu=
g_mode);
> #else
> #define in_hibernation(pd) (0)
> #endif
>-#define get_pm_count(p) (atomic_read(&(p)->interface->pm_usage_cnt))
>+#define get_pm_count(p) (atomic_read(&(p)->interface->dev.power.usage_cou=
nt))
>=20
> #define log(a, ...) printk(KERN_DEBUG "\t[ %s : %.3d ] "a"\n", \
> 				__func__, __LINE__,  ## __VA_ARGS__)
>diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_c=
mdset_0002.c
>index 92303daf44dc..40047a2f4696 100644
>--- a/drivers/mtd/chips/cfi_cmdset_0002.c
>+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
>@@ -1538,7 +1538,11 @@ static int __xipram do_write_buffer(struct map_info=
 *map, struct flchip *chip,
> 			continue;
> 		}
>=20
>-		if (time_after(jiffies, timeo) && !chip_ready(map, adr))
>+		/*
>+		 * We check "time_after" and "!chip_good" before checking "chip_good" t=
o avoid
>+		 * the failure due to scheduling.
>+		 */
>+		if (time_after(jiffies, timeo) && !chip_good(map, adr, datum))
> 			break;
>=20
> 		if (chip_good(map, adr, datum)) {
>diff --git a/drivers/net/ethernet/3com/3c515.c b/drivers/net/ethernet/3com=
/3c515.c
>index 94c656f5a05d..d4552e2c7189 100644
>--- a/drivers/net/ethernet/3com/3c515.c
>+++ b/drivers/net/ethernet/3com/3c515.c
>@@ -1524,7 +1524,7 @@ static void update_stats(int ioaddr, struct net_devi=
ce *dev)
> static void set_rx_mode(struct net_device *dev)
> {
> 	int ioaddr =3D dev->base_addr;
>-	short new_mode;
>+	unsigned short new_mode;
>=20
> 	if (dev->flags & IFF_PROMISC) {
> 		if (corkscrew_debug > 3)
>diff --git a/drivers/net/ethernet/8390/mac8390.c b/drivers/net/ethernet/83=
90/mac8390.c
>index 90e825e8abfe..02beb18942d2 100644
>--- a/drivers/net/ethernet/8390/mac8390.c
>+++ b/drivers/net/ethernet/8390/mac8390.c
>@@ -153,11 +153,6 @@ static void dayna_block_input(struct net_device *dev,=
 int count,
> static void dayna_block_output(struct net_device *dev, int count,
> 			       const unsigned char *buf, int start_page);
>=20
>-#define memcpy_fromio(a, b, c)	memcpy((a), (void *)(b), (c))
>-#define memcpy_toio(a, b, c)	memcpy((void *)(a), (b), (c))
>-
>-#define memcmp_withio(a, b, c)	memcmp((a), (void *)(b), (c))
>-
> /* Slow Sane (16-bit chunk memory read/write) Cabletron uses this */
> static void slow_sane_get_8390_hdr(struct net_device *dev,
> 				   struct e8390_pkt_hdr *hdr, int ring_page);
>@@ -244,19 +239,26 @@ static enum mac8390_type __init mac8390_ident(struct=
 nubus_dev *dev)
>=20
> static enum mac8390_access __init mac8390_testio(volatile unsigned long m=
embase)
> {
>-	unsigned long outdata =3D 0xA5A0B5B0;
>-	unsigned long indata =3D  0x00000000;
>+	u32 outdata =3D 0xA5A0B5B0;
>+	u32 indata =3D 0;
>+
> 	/* Try writing 32 bits */
>-	memcpy_toio(membase, &outdata, 4);
>-	/* Now compare them */
>-	if (memcmp_withio(&outdata, membase, 4) =3D=3D 0)
>+	nubus_writel(outdata, membase);
>+	/* Now read it back */
>+	indata =3D nubus_readl(membase);
>+	if (outdata =3D=3D indata)
> 		return ACCESS_32;
>+
>+	outdata =3D 0xC5C0D5D0;
>+	indata =3D 0;
>+
> 	/* Write 16 bit output */
> 	word_memcpy_tocard(membase, &outdata, 4);
> 	/* Now read it back */
> 	word_memcpy_fromcard(&indata, membase, 4);
> 	if (outdata =3D=3D indata)
> 		return ACCESS_16;
>+
> 	return ACCESS_UNKNOWN;
> }
>=20
>@@ -742,7 +744,7 @@ static void sane_get_8390_hdr(struct net_device *dev,
> 			      struct e8390_pkt_hdr *hdr, int ring_page)
> {
> 	unsigned long hdr_start =3D (ring_page - WD_START_PG)<<8;
>-	memcpy_fromio(hdr, dev->mem_start + hdr_start, 4);
>+	memcpy_fromio(hdr, (void __iomem *)dev->mem_start + hdr_start, 4);
> 	/* Fix endianness */
> 	hdr->count =3D swab16(hdr->count);
> }
>@@ -756,13 +758,16 @@ static void sane_block_input(struct net_device *dev,=
 int count,
> 	if (xfer_start + count > ei_status.rmem_end) {
> 		/* We must wrap the input move. */
> 		int semi_count =3D ei_status.rmem_end - xfer_start;
>-		memcpy_fromio(skb->data, dev->mem_start + xfer_base,
>+		memcpy_fromio(skb->data,
>+			      (void __iomem *)dev->mem_start + xfer_base,
> 			      semi_count);
> 		count -=3D semi_count;
>-		memcpy_fromio(skb->data + semi_count, ei_status.rmem_start,
>-			      count);
>+		memcpy_fromio(skb->data + semi_count,
>+			      (void __iomem *)ei_status.rmem_start, count);
> 	} else {
>-		memcpy_fromio(skb->data, dev->mem_start + xfer_base, count);
>+		memcpy_fromio(skb->data,
>+			      (void __iomem *)dev->mem_start + xfer_base,
>+			      count);
> 	}
> }
>=20
>@@ -771,7 +776,7 @@ static void sane_block_output(struct net_device *dev, =
int count,
> {
> 	long shmem =3D (start_page - WD_START_PG)<<8;
>=20
>-	memcpy_toio(dev->mem_start + shmem, buf, count);
>+	memcpy_toio((void __iomem *)dev->mem_start + shmem, buf, count);
> }
>=20
> /* dayna block input/output */
>diff --git a/drivers/net/ethernet/neterion/vxge/vxge-config.c b/drivers/ne=
t/ethernet/neterion/vxge/vxge-config.c
>index 4332ebbd7162..39f4b38fd068 100644
>--- a/drivers/net/ethernet/neterion/vxge/vxge-config.c
>+++ b/drivers/net/ethernet/neterion/vxge/vxge-config.c
>@@ -2381,6 +2381,7 @@ static void *__vxge_hw_blockpool_malloc(struct __vxg=
e_hw_device *devh, u32 size,
> 			vxge_os_dma_free(devh->pdev, memblock,
> 				&dma_object->acc_handle);
> 			status =3D VXGE_HW_ERR_OUT_OF_MEMORY;
>+			memblock =3D NULL;
> 			goto exit;
> 		}
>=20
>diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
>index 47eba38ae526..75cc676a3239 100644
>--- a/drivers/net/macvtap.c
>+++ b/drivers/net/macvtap.c
>@@ -16,7 +16,6 @@
> #include <linux/idr.h>
> #include <linux/fs.h>
>=20
>-#include <net/ipv6.h>
> #include <net/net_namespace.h>
> #include <net/rtnetlink.h>
> #include <net/sock.h>
>@@ -571,8 +570,6 @@ static int macvtap_skb_from_vnet_hdr(struct sk_buff *s=
kb,
> 			break;
> 		case VIRTIO_NET_HDR_GSO_UDP:
> 			gso_type =3D SKB_GSO_UDP;
>-			if (skb->protocol =3D=3D htons(ETH_P_IPV6))
>-				ipv6_proxy_select_ident(skb);
> 			break;
> 		default:
> 			return -EINVAL;
>diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>index 7a6d2f8c5201..77fcb1bd81bc 100644
>--- a/drivers/net/phy/phy_device.c
>+++ b/drivers/net/phy/phy_device.c
>@@ -1072,7 +1072,10 @@ int genphy_soft_reset(struct phy_device *phydev)
> {
> 	int ret;
>=20
>-	ret =3D phy_write(phydev, MII_BMCR, BMCR_RESET);
>+	ret =3D phy_read(phydev, MII_BMCR);
>+	if (ret < 0)
>+		return ret;
>+	ret =3D phy_write(phydev, MII_BMCR, ret | BMCR_RESET);
> 	if (ret < 0)
> 		return ret;
>=20
>diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
>index 5dd0fe1635b9..a97b20773508 100644
>--- a/drivers/net/ppp/pptp.c
>+++ b/drivers/net/ppp/pptp.c
>@@ -284,7 +284,7 @@ static int pptp_xmit(struct ppp_channel *chan, struct =
sk_buff *skb)
> 	nf_reset(skb);
>=20
> 	skb->ip_summed =3D CHECKSUM_NONE;
>-	ip_select_ident(skb, NULL);
>+	ip_select_ident(sock_net(sk), skb, NULL);
> 	ip_send_check(iph);
>=20
> 	ip_local_out(skb);
>diff --git a/drivers/net/slip/slhc.c b/drivers/net/slip/slhc.c
>index b52eabc168a0..f8234b5439f5 100644
>--- a/drivers/net/slip/slhc.c
>+++ b/drivers/net/slip/slhc.c
>@@ -153,7 +153,7 @@ slhc_init(int rslots, int tslots)
> void
> slhc_free(struct slcompress *comp)
> {
>-	if ( comp =3D=3D NULLSLCOMPR )
>+	if ( IS_ERR_OR_NULL(comp) )
> 		return;
>=20
> 	if ( comp->tstate !=3D NULLSLSTATE )
>diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
>index d6511041c766..8d408cd7c170 100644
>--- a/drivers/net/team/team.c
>+++ b/drivers/net/team/team.c
>@@ -1116,6 +1116,12 @@ static int team_port_add(struct team *team, struct =
net_device *port_dev)
> 		return -EINVAL;
> 	}
>=20
>+	if (netdev_has_upper_dev(dev, port_dev)) {
>+		netdev_err(dev, "Device %s is already an upper device of the team inter=
face\n",
>+			   portname);
>+		return -EBUSY;
>+	}
>+
> 	if (port_dev->features & NETIF_F_VLAN_CHALLENGED &&
> 	    vlan_uses_dev(dev)) {
> 		netdev_err(dev, "Device %s is VLAN challenged and team device has VLAN =
set up\n",
>diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>index 48ac45f26fa3..1bbcb278e6df 100644
>--- a/drivers/net/tun.c
>+++ b/drivers/net/tun.c
>@@ -65,7 +65,6 @@
> #include <linux/nsproxy.h>
> #include <linux/virtio_net.h>
> #include <linux/rcupdate.h>
>-#include <net/ipv6.h>
> #include <net/net_namespace.h>
> #include <net/netns/generic.h>
> #include <net/rtnetlink.h>
>@@ -1143,8 +1142,6 @@ static ssize_t tun_get_user(struct tun_struct *tun, =
struct tun_file *tfile,
> 		break;
> 	}
>=20
>-	skb_reset_network_header(skb);
>-
> 	if (gso.gso_type !=3D VIRTIO_NET_HDR_GSO_NONE) {
> 		pr_debug("GSO!\n");
> 		switch (gso.gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
>@@ -1156,8 +1153,6 @@ static ssize_t tun_get_user(struct tun_struct *tun, =
struct tun_file *tfile,
> 			break;
> 		case VIRTIO_NET_HDR_GSO_UDP:
> 			skb_shinfo(skb)->gso_type =3D SKB_GSO_UDP;
>-			if (skb->protocol =3D=3D htons(ETH_P_IPV6))
>-				ipv6_proxy_select_ident(skb);
> 			break;
> 		default:
> 			tun->dev->stats.rx_frame_errors++;
>@@ -1187,6 +1182,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, =
struct tun_file *tfile,
> 		skb_shinfo(skb)->tx_flags |=3D SKBTX_SHARED_FRAG;
> 	}
>=20
>+	skb_reset_network_header(skb);
> 	skb_probe_transport_header(skb, 0);
>=20
> 	rxhash =3D skb_get_hash(skb);
>diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/r=
t2x00/rt2x00.h
>index d13f25cd70d5..91aebb03841e 100644
>--- a/drivers/net/wireless/rt2x00/rt2x00.h
>+++ b/drivers/net/wireless/rt2x00/rt2x00.h
>@@ -666,7 +666,6 @@ enum rt2x00_state_flags {
> 	CONFIG_CHANNEL_HT40,
> 	CONFIG_POWERSAVING,
> 	CONFIG_HT_DISABLED,
>-	CONFIG_QOS_DISABLED,
>=20
> 	/*
> 	 * Mark we currently are sequentially reading TX_STA_FIFO register
>diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireles=
s/rt2x00/rt2x00mac.c
>index 004dff9b962d..e7c152dd0bef 100644
>--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
>+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
>@@ -682,18 +682,8 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *=
hw,
> 			rt2x00dev->intf_associated--;
>=20
> 		rt2x00leds_led_assoc(rt2x00dev, !!rt2x00dev->intf_associated);
>-
>-		clear_bit(CONFIG_QOS_DISABLED, &rt2x00dev->flags);
> 	}
>=20
>-	/*
>-	 * Check for access point which do not support 802.11e . We have to
>-	 * generate data frames sequence number in S/W for such AP, because
>-	 * of H/W bug.
>-	 */
>-	if (changes & BSS_CHANGED_QOS && !bss_conf->qos)
>-		set_bit(CONFIG_QOS_DISABLED, &rt2x00dev->flags);
>-
> 	/*
> 	 * When the erp information has changed, we should perform
> 	 * additional configuration steps. For all other changes we are done.
>diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wirel=
ess/rt2x00/rt2x00queue.c
>index 22d49d575d3f..8705092a052e 100644
>--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
>+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
>@@ -201,15 +201,18 @@ static void rt2x00queue_create_tx_descriptor_seq(str=
uct rt2x00_dev *rt2x00dev,
> 	if (!test_bit(REQUIRE_SW_SEQNO, &rt2x00dev->cap_flags)) {
> 		/*
> 		 * rt2800 has a H/W (or F/W) bug, device incorrectly increase
>-		 * seqno on retransmited data (non-QOS) frames. To workaround
>-		 * the problem let's generate seqno in software if QOS is
>-		 * disabled.
>+		 * seqno on retransmitted data (non-QOS) and management frames.
>+		 * To workaround the problem let's generate seqno in software.
>+		 * Except for beacons which are transmitted periodically by H/W
>+		 * hence hardware has to assign seqno for them.
> 		 */
>-		if (test_bit(CONFIG_QOS_DISABLED, &rt2x00dev->flags))
>-			__clear_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags);
>-		else
>+	    	if (ieee80211_is_beacon(hdr->frame_control)) {
>+			__set_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags);
> 			/* H/W will generate sequence number */
> 			return;
>+		}
>+
>+		__clear_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags);
> 	}
>=20
> 	/*
>diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
>index f5d1f51101cf..57cc4e7d2bbc 100644
>--- a/drivers/pci/quirks.c
>+++ b/drivers/pci/quirks.c
>@@ -3514,6 +3514,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, =
0x9123,
> /* https://bugzilla.kernel.org/show_bug.cgi?id=3D42679#c14 */
> DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9130,
> 			 quirk_dma_func1_alias);
>+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9170,
>+			 quirk_dma_func1_alias);
> /* https://bugzilla.kernel.org/show_bug.cgi?id=3D42679#c47 + c57 */
> DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9172,
> 			 quirk_dma_func1_alias);
>diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
>index 21a6f6d76bbb..3a62c049696e 100644
>--- a/drivers/s390/scsi/zfcp_erp.c
>+++ b/drivers/s390/scsi/zfcp_erp.c
>@@ -652,6 +652,20 @@ static void zfcp_erp_strategy_memwait(struct zfcp_erp=
_action *erp_action)
> 	add_timer(&erp_action->timer);
> }
>=20
>+void zfcp_erp_port_forced_reopen_all(struct zfcp_adapter *adapter,
>+				     int clear, char *dbftag)
>+{
>+	unsigned long flags;
>+	struct zfcp_port *port;
>+
>+	write_lock_irqsave(&adapter->erp_lock, flags);
>+	read_lock(&adapter->port_list_lock);
>+	list_for_each_entry(port, &adapter->port_list, list)
>+		_zfcp_erp_port_forced_reopen(port, clear, dbftag);
>+	read_unlock(&adapter->port_list_lock);
>+	write_unlock_irqrestore(&adapter->erp_lock, flags);
>+}
>+
> static void _zfcp_erp_port_reopen_all(struct zfcp_adapter *adapter,
> 				      int clear, char *id)
> {
>@@ -1313,6 +1327,9 @@ static void zfcp_erp_try_rport_unblock(struct zfcp_p=
ort *port)
> 		struct zfcp_scsi_dev *zsdev =3D sdev_to_zfcp(sdev);
> 		int lun_status;
>=20
>+		if (sdev->sdev_state =3D=3D SDEV_DEL ||
>+		    sdev->sdev_state =3D=3D SDEV_CANCEL)
>+			continue;
> 		if (zsdev->port !=3D port)
> 			continue;
> 		/* LUN under port of interest */
>diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
>index c5023d6811a8..cfe2a3b2d3b2 100644
>--- a/drivers/s390/scsi/zfcp_ext.h
>+++ b/drivers/s390/scsi/zfcp_ext.h
>@@ -68,6 +68,8 @@ extern void zfcp_erp_clear_port_status(struct zfcp_port =
*, u32);
> extern int  zfcp_erp_port_reopen(struct zfcp_port *, int, char *);
> extern void zfcp_erp_port_shutdown(struct zfcp_port *, int, char *);
> extern void zfcp_erp_port_forced_reopen(struct zfcp_port *, int, char *);
>+extern void zfcp_erp_port_forced_reopen_all(struct zfcp_adapter *adapter,
>+					    int clear, char *dbftag);
> extern void zfcp_erp_set_lun_status(struct scsi_device *, u32);
> extern void zfcp_erp_clear_lun_status(struct scsi_device *, u32);
> extern void zfcp_erp_lun_reopen(struct scsi_device *, int, char *);
>diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
>index f213786fe96c..9e9f0ad00bef 100644
>--- a/drivers/s390/scsi/zfcp_scsi.c
>+++ b/drivers/s390/scsi/zfcp_scsi.c
>@@ -347,6 +347,10 @@ static int zfcp_scsi_eh_host_reset_handler(struct scs=
i_cmnd *scpnt)
> 	struct zfcp_adapter *adapter =3D zfcp_sdev->port->adapter;
> 	int ret =3D SUCCESS, fc_ret;
>=20
>+	if (!(adapter->connection_features & FSF_FEATURE_NPIV_MODE)) {
>+		zfcp_erp_port_forced_reopen_all(adapter, 0, "schrh_p");
>+		zfcp_erp_wait(adapter);
>+	}
> 	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
> 	zfcp_erp_wait(adapter);
> 	fc_ret =3D fc_block_scsi_eh(scpnt);
>diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_=
expander.c
>index 7d5d66edae87..65826111d996 100644
>--- a/drivers/scsi/libsas/sas_expander.c
>+++ b/drivers/scsi/libsas/sas_expander.c
>@@ -47,17 +47,16 @@ static void smp_task_timedout(unsigned long _task)
> 	unsigned long flags;
>=20
> 	spin_lock_irqsave(&task->task_state_lock, flags);
>-	if (!(task->task_state_flags & SAS_TASK_STATE_DONE))
>+	if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
> 		task->task_state_flags |=3D SAS_TASK_STATE_ABORTED;
>+		complete(&task->slow_task->completion);
>+	}
> 	spin_unlock_irqrestore(&task->task_state_lock, flags);
>-
>-	complete(&task->slow_task->completion);
> }
>=20
> static void smp_task_done(struct sas_task *task)
> {
>-	if (!del_timer(&task->slow_task->timer))
>-		return;
>+	del_timer(&task->slow_task->timer);
> 	complete(&task->slow_task->completion);
> }
>=20
>diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/co=
medi/drivers/vmk80xx.c
>index 0adf3cffddb0..87b6e1aa107a 100644
>--- a/drivers/staging/comedi/drivers/vmk80xx.c
>+++ b/drivers/staging/comedi/drivers/vmk80xx.c
>@@ -757,10 +757,8 @@ static int vmk80xx_alloc_usb_buffers(struct comedi_de=
vice *dev)
>=20
> 	size =3D le16_to_cpu(devpriv->ep_tx->wMaxPacketSize);
> 	devpriv->usb_tx_buf =3D kzalloc(size, GFP_KERNEL);
>-	if (!devpriv->usb_tx_buf) {
>-		kfree(devpriv->usb_rx_buf);
>+	if (!devpriv->usb_tx_buf)
> 		return -ENOMEM;
>-	}
>=20
> 	return 0;
> }
>@@ -872,6 +870,8 @@ static int vmk80xx_auto_attach(struct comedi_device *d=
ev,
>=20
> 	devpriv->model =3D boardinfo->model;
>=20
>+	sema_init(&devpriv->limit_sem, 8);
>+
> 	ret =3D vmk80xx_find_usb_endpoints(dev);
> 	if (ret)
> 		return ret;
>@@ -880,8 +880,6 @@ static int vmk80xx_auto_attach(struct comedi_device *d=
ev,
> 	if (ret)
> 		return ret;
>=20
>-	sema_init(&devpriv->limit_sem, 8);
>-
> 	usb_set_intfdata(intf, devpriv);
>=20
> 	if (devpriv->model =3D=3D VMK8061_MODEL) {
>diff --git a/drivers/staging/iio/meter/ade7854.c b/drivers/staging/iio/met=
er/ade7854.c
>index bcfdb650c2c5..c318e263c1bb 100644
>--- a/drivers/staging/iio/meter/ade7854.c
>+++ b/drivers/staging/iio/meter/ade7854.c
>@@ -269,7 +269,7 @@ static IIO_DEV_ATTR_VPEAK(S_IWUSR | S_IRUGO,
> static IIO_DEV_ATTR_IPEAK(S_IWUSR | S_IRUGO,
> 		ade7854_read_32bit,
> 		ade7854_write_32bit,
>-		ADE7854_VPEAK);
>+		ADE7854_IPEAK);
> static IIO_DEV_ATTR_APHCAL(S_IWUSR | S_IRUGO,
> 		ade7854_read_16bit,
> 		ade7854_write_16bit,
>diff --git a/drivers/staging/rtl8712/rtl8712_cmd.c b/drivers/staging/rtl87=
12/rtl8712_cmd.c
>index 8ca7d7e68dca..2a0225900d89 100644
>--- a/drivers/staging/rtl8712/rtl8712_cmd.c
>+++ b/drivers/staging/rtl8712/rtl8712_cmd.c
>@@ -155,19 +155,11 @@ static u8 write_macreg_hdl(struct _adapter *padapter=
, u8 *pbuf)
>=20
> static u8 read_bbreg_hdl(struct _adapter *padapter, u8 *pbuf)
> {
>-	u32 val;
>-	void (*pcmd_callback)(struct _adapter *dev, struct cmd_obj	*pcmd);
> 	struct readBB_parm *prdbbparm;
> 	struct cmd_obj *pcmd  =3D (struct cmd_obj *)pbuf;
>=20
> 	prdbbparm =3D (struct readBB_parm *)pcmd->parmbuf;
>-	if (pcmd->rsp && pcmd->rspsz > 0)
>-		memcpy(pcmd->rsp, (u8 *)&val, pcmd->rspsz);
>-	pcmd_callback =3D cmd_callback[pcmd->cmdcode].callback;
>-	if (pcmd_callback =3D=3D NULL)
>-		r8712_free_cmd_obj(pcmd);
>-	else
>-		pcmd_callback(padapter, pcmd);
>+	r8712_free_cmd_obj(pcmd);
> 	return H2C_SUCCESS;
> }
>=20
>diff --git a/drivers/staging/rtl8712/rtl8712_cmd.h b/drivers/staging/rtl87=
12/rtl8712_cmd.h
>index 039ab3e97172..efa2fc98907f 100644
>--- a/drivers/staging/rtl8712/rtl8712_cmd.h
>+++ b/drivers/staging/rtl8712/rtl8712_cmd.h
>@@ -152,7 +152,7 @@ enum rtl8712_h2c_cmd {
> static struct _cmd_callback	cmd_callback[] =3D {
> 	{GEN_CMD_CODE(_Read_MACREG), NULL}, /*0*/
> 	{GEN_CMD_CODE(_Write_MACREG), NULL},
>-	{GEN_CMD_CODE(_Read_BBREG), &r8712_getbbrfreg_cmdrsp_callback},
>+	{GEN_CMD_CODE(_Read_BBREG), NULL},
> 	{GEN_CMD_CODE(_Write_BBREG), NULL},
> 	{GEN_CMD_CODE(_Read_RFREG), &r8712_getbbrfreg_cmdrsp_callback},
> 	{GEN_CMD_CODE(_Write_RFREG), NULL}, /*5*/
>diff --git a/drivers/staging/speakup/speakup_soft.c b/drivers/staging/spea=
kup/speakup_soft.c
>index 9ed726509261..c5bf6b1aa80e 100644
>--- a/drivers/staging/speakup/speakup_soft.c
>+++ b/drivers/staging/speakup/speakup_soft.c
>@@ -213,10 +213,13 @@ static ssize_t softsynth_read(struct file *fp, char =
__user *buf, size_t count,
> 	DEFINE_WAIT(wait);
>=20
> 	spin_lock_irqsave(&speakup_info.spinlock, flags);
>+	synth_soft.alive =3D 1;
> 	while (1) {
> 		prepare_to_wait(&speakup_event, &wait, TASK_INTERRUPTIBLE);
>-		if (!synth_buffer_empty() || speakup_info.flushing)
>-			break;
>+		if (synth_current() =3D=3D &synth_soft) {
>+			if (!synth_buffer_empty() || speakup_info.flushing)
>+				break;
>+		}
> 		spin_unlock_irqrestore(&speakup_info.spinlock, flags);
> 		if (fp->f_flags & O_NONBLOCK) {
> 			finish_wait(&speakup_event, &wait);
>@@ -234,6 +237,8 @@ static ssize_t softsynth_read(struct file *fp, char __=
user *buf, size_t count,
> 	cp =3D buf;
> 	init =3D get_initstring();
> 	while (chars_sent < count) {
>+		if (synth_current() !=3D &synth_soft)
>+			break;
> 		if (speakup_info.flushing) {
> 			speakup_info.flushing =3D 0;
> 			ch =3D '\x18';
>@@ -286,7 +291,8 @@ static unsigned int softsynth_poll(struct file *fp,
> 	poll_wait(fp, &speakup_event, wait);
>=20
> 	spin_lock_irqsave(&speakup_info.spinlock, flags);
>-	if (!synth_buffer_empty() || speakup_info.flushing)
>+	if (synth_current() =3D=3D &synth_soft &&
>+	    (!synth_buffer_empty() || speakup_info.flushing))
> 		ret =3D POLLIN | POLLRDNORM;
> 	spin_unlock_irqrestore(&speakup_info.spinlock, flags);
> 	return ret;
>diff --git a/drivers/staging/speakup/spk_priv.h b/drivers/staging/speakup/=
spk_priv.h
>index 637ba6760ec0..b669021455dd 100644
>--- a/drivers/staging/speakup/spk_priv.h
>+++ b/drivers/staging/speakup/spk_priv.h
>@@ -72,6 +72,7 @@ extern int synth_request_region(u_long, u_long);
> extern int synth_release_region(u_long, u_long);
> extern int synth_add(struct spk_synth *in_synth);
> extern void synth_remove(struct spk_synth *in_synth);
>+struct spk_synth *synth_current(void);
>=20
> extern struct speakup_info_t speakup_info;
>=20
>diff --git a/drivers/staging/speakup/synth.c b/drivers/staging/speakup/syn=
th.c
>index 172cf62b1aaf..1219089af4b5 100644
>--- a/drivers/staging/speakup/synth.c
>+++ b/drivers/staging/speakup/synth.c
>@@ -475,4 +475,10 @@ void synth_remove(struct spk_synth *in_synth)
> }
> EXPORT_SYMBOL_GPL(synth_remove);
>=20
>+struct spk_synth *synth_current(void)
>+{
>+	return synth;
>+}
>+EXPORT_SYMBOL_GPL(synth_current);
>+
> short spk_punc_masks[] =3D { 0, SOME, MOST, PUNC, PUNC|B_SYM };
>diff --git a/drivers/staging/usbip/stub_rx.c b/drivers/staging/usbip/stub_=
rx.c
>index 2ed1118d3d8b..7f10bc79a719 100644
>--- a/drivers/staging/usbip/stub_rx.c
>+++ b/drivers/staging/usbip/stub_rx.c
>@@ -375,16 +375,10 @@ static int get_pipe(struct stub_device *sdev, struct=
 usbip_header *pdu)
> 	}
>=20
> 	if (usb_endpoint_xfer_isoc(epd)) {
>-		/* validate packet size and number of packets */
>-		unsigned int maxp, packets, bytes;
>-
>-		maxp =3D usb_endpoint_maxp(epd);
>-		maxp *=3D usb_endpoint_maxp_mult(epd);
>-		bytes =3D pdu->u.cmd_submit.transfer_buffer_length;
>-		packets =3D DIV_ROUND_UP(bytes, maxp);
>-
>+		/* validate number of packets */
> 		if (pdu->u.cmd_submit.number_of_packets < 0 ||
>-		    pdu->u.cmd_submit.number_of_packets > packets) {
>+		    pdu->u.cmd_submit.number_of_packets >
>+		    USBIP_MAX_ISO_PACKETS) {
> 			dev_err(&sdev->udev->dev,
> 				"CMD_SUBMIT: isoc invalid num packets %d\n",
> 				pdu->u.cmd_submit.number_of_packets);
>diff --git a/drivers/staging/usbip/usbip_common.h b/drivers/staging/usbip/=
usbip_common.h
>index 58787c49fb68..8b358911563b 100644
>--- a/drivers/staging/usbip/usbip_common.h
>+++ b/drivers/staging/usbip/usbip_common.h
>@@ -134,6 +134,13 @@ extern struct device_attribute dev_attr_usbip_debug;
> #define USBIP_DIR_OUT	0x00
> #define USBIP_DIR_IN	0x01
>=20
>+/*
>+ * Arbitrary limit for the maximum number of isochronous packets in an UR=
B,
>+ * compare for example the uhci_submit_isochronous function in
>+ * drivers/usb/host/uhci-q.c
>+ */
>+#define USBIP_MAX_ISO_PACKETS 1024
>+
> /**
>  * struct usbip_header_basic - data pertinent to every request
>  * @command: the usbip request type
>diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_=
serial.c
>index bc1c68c926bd..d8676716467b 100644
>--- a/drivers/tty/serial/atmel_serial.c
>+++ b/drivers/tty/serial/atmel_serial.c
>@@ -1045,6 +1045,10 @@ static int atmel_prepare_rx_dma(struct uart_port *p=
ort)
> 				sg_dma_len(&atmel_port->sg_rx)/2,
> 				DMA_DEV_TO_MEM,
> 				DMA_PREP_INTERRUPT);
>+	if (!desc) {
>+		dev_err(port->dev, "Preparing DMA cyclic failed\n");
>+		goto chan_err;
>+	}
> 	desc->callback =3D atmel_complete_rx_dma;
> 	desc->callback_param =3D port;
> 	atmel_port->desc_rx =3D desc;
>diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
>index ba285cd45b59..8ccab7cf437c 100644
>--- a/drivers/tty/serial/max310x.c
>+++ b/drivers/tty/serial/max310x.c
>@@ -1324,6 +1324,8 @@ static int max310x_spi_probe(struct spi_device *spi)
> 	if (spi->dev.of_node) {
> 		const struct of_device_id *of_id =3D
> 			of_match_device(max310x_dt_ids, &spi->dev);
>+		if (!of_id)
>+			return -ENODEV;
>=20
> 		devtype =3D (struct max310x_devtype *)of_id->data;
> 	} else {
>diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart=
=2Ec
>index 8f6d6b5a2eeb..acacce37ec66 100644
>--- a/drivers/tty/serial/mxs-auart.c
>+++ b/drivers/tty/serial/mxs-auart.c
>@@ -1075,6 +1075,10 @@ static int mxs_auart_probe(struct platform_device *=
pdev)
>=20
> 	s->port.mapbase =3D r->start;
> 	s->port.membase =3D ioremap(r->start, resource_size(r));
>+	if (!s->port.membase) {
>+		ret =3D -ENOMEM;
>+		goto out_free_clk;
>+	}
> 	s->port.ops =3D &mxs_auart_ops;
> 	s->port.iotype =3D UPIO_MEM;
> 	s->port.fifosize =3D MXS_AUART_FIFO_SIZE;
>diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
>index e2224213111c..0dc1d1ac4a9a 100644
>--- a/drivers/tty/serial/sh-sci.c
>+++ b/drivers/tty/serial/sh-sci.c
>@@ -633,19 +633,9 @@ static void sci_transmit_chars(struct uart_port *port)
>=20
> 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
> 		uart_write_wakeup(port);
>-	if (uart_circ_empty(xmit)) {
>+	if (uart_circ_empty(xmit))
> 		sci_stop_tx(port);
>-	} else {
>-		ctrl =3D serial_port_in(port, SCSCR);
>-
>-		if (port->type !=3D PORT_SCI) {
>-			serial_port_in(port, SCxSR); /* Dummy read */
>-			serial_port_out(port, SCxSR, SCxSR_TDxE_CLEAR(port));
>-		}
>=20
>-		ctrl |=3D SCSCR_TIE;
>-		serial_port_out(port, SCSCR, ctrl);
>-	}
> }
>=20
> /* On SH3, SCIF may read end-of-break as a space->mark char */
>diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
>index d002c23af6f4..71dfbff5839d 100644
>--- a/drivers/usb/core/driver.c
>+++ b/drivers/usb/core/driver.c
>@@ -483,11 +483,6 @@ static int usb_unbind_interface(struct device *dev)
> 		pm_runtime_disable(dev);
> 	pm_runtime_set_suspended(dev);
>=20
>-	/* Undo any residual pm_autopm_get_interface_* calls */
>-	for (r =3D atomic_read(&intf->pm_usage_cnt); r > 0; --r)
>-		usb_autopm_put_interface_no_suspend(intf);
>-	atomic_set(&intf->pm_usage_cnt, 0);
>-
> 	if (!error)
> 		usb_autosuspend_device(udev);
>=20
>@@ -1638,7 +1633,6 @@ void usb_autopm_put_interface(struct usb_interface *=
intf)
> 	int			status;
>=20
> 	usb_mark_last_busy(udev);
>-	atomic_dec(&intf->pm_usage_cnt);
> 	status =3D pm_runtime_put_sync(&intf->dev);
> 	dev_vdbg(&intf->dev, "%s: cnt %d -> %d\n",
> 			__func__, atomic_read(&intf->dev.power.usage_count),
>@@ -1667,7 +1661,6 @@ void usb_autopm_put_interface_async(struct usb_inter=
face *intf)
> 	int			status;
>=20
> 	usb_mark_last_busy(udev);
>-	atomic_dec(&intf->pm_usage_cnt);
> 	status =3D pm_runtime_put(&intf->dev);
> 	dev_vdbg(&intf->dev, "%s: cnt %d -> %d\n",
> 			__func__, atomic_read(&intf->dev.power.usage_count),
>@@ -1689,7 +1682,6 @@ void usb_autopm_put_interface_no_suspend(struct usb_=
interface *intf)
> 	struct usb_device	*udev =3D interface_to_usbdev(intf);
>=20
> 	usb_mark_last_busy(udev);
>-	atomic_dec(&intf->pm_usage_cnt);
> 	pm_runtime_put_noidle(&intf->dev);
> }
> EXPORT_SYMBOL_GPL(usb_autopm_put_interface_no_suspend);
>@@ -1720,8 +1712,6 @@ int usb_autopm_get_interface(struct usb_interface *i=
ntf)
> 	status =3D pm_runtime_get_sync(&intf->dev);
> 	if (status < 0)
> 		pm_runtime_put_sync(&intf->dev);
>-	else
>-		atomic_inc(&intf->pm_usage_cnt);
> 	dev_vdbg(&intf->dev, "%s: cnt %d -> %d\n",
> 			__func__, atomic_read(&intf->dev.power.usage_count),
> 			status);
>@@ -1755,8 +1745,6 @@ int usb_autopm_get_interface_async(struct usb_interf=
ace *intf)
> 	status =3D pm_runtime_get(&intf->dev);
> 	if (status < 0 && status !=3D -EINPROGRESS)
> 		pm_runtime_put_noidle(&intf->dev);
>-	else
>-		atomic_inc(&intf->pm_usage_cnt);
> 	dev_vdbg(&intf->dev, "%s: cnt %d -> %d\n",
> 			__func__, atomic_read(&intf->dev.power.usage_count),
> 			status);
>@@ -1780,7 +1768,6 @@ void usb_autopm_get_interface_no_resume(struct usb_i=
nterface *intf)
> 	struct usb_device	*udev =3D interface_to_usbdev(intf);
>=20
> 	usb_mark_last_busy(udev);
>-	atomic_inc(&intf->pm_usage_cnt);
> 	pm_runtime_get_noresume(&intf->dev);
> }
> EXPORT_SYMBOL_GPL(usb_autopm_get_interface_no_resume);
>diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
>index 6af648c307b7..f7019c7e9bc5 100644
>--- a/drivers/usb/core/message.c
>+++ b/drivers/usb/core/message.c
>@@ -822,9 +822,11 @@ int usb_string(struct usb_device *dev, int index, cha=
r *buf, size_t size)
>=20
> 	if (dev->state =3D=3D USB_STATE_SUSPENDED)
> 		return -EHOSTUNREACH;
>-	if (size <=3D 0 || !buf || !index)
>+	if (size <=3D 0 || !buf)
> 		return -EINVAL;
> 	buf[0] =3D 0;
>+	if (index <=3D 0 || index >=3D 256)
>+		return -EINVAL;
> 	tbuf =3D kmalloc(256, GFP_NOIO);
> 	if (!tbuf)
> 		return -ENOMEM;
>diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
>index fd697bba07ff..dc3270e48dfb 100644
>--- a/drivers/usb/host/xhci-hub.c
>+++ b/drivers/usb/host/xhci-hub.c
>@@ -1199,20 +1199,25 @@ int xhci_bus_suspend(struct usb_hcd *hcd)
> 	port_index =3D max_ports;
> 	while (port_index--) {
> 		u32 t1, t2;
>-
>+		int retries =3D 10;
>+retry:
> 		t1 =3D readl(port_array[port_index]);
> 		t2 =3D xhci_port_state_to_neutral(t1);
> 		portsc_buf[port_index] =3D 0;
>=20
>-		/* Bail out if a USB3 port has a new device in link training */
>-		if ((hcd->speed >=3D HCD_USB3) &&
>+		/*
>+		 * Give a USB3 port in link training time to finish, but don't
>+		 * prevent suspend as port might be stuck
>+		 */
>+		if ((hcd->speed >=3D HCD_USB3) && retries-- &&
> 		    (t1 & PORT_PLS_MASK) =3D=3D XDEV_POLLING) {
>-			bus_state->bus_suspended =3D 0;
> 			spin_unlock_irqrestore(&xhci->lock, flags);
>-			xhci_dbg(xhci, "Bus suspend bailout, port in polling\n");
>-			return -EBUSY;
>+			msleep(XHCI_PORT_POLLING_LFPS_TIME);
>+			spin_lock_irqsave(&xhci->lock, flags);
>+			xhci_dbg(xhci, "port %d polling in bus suspend, waiting\n",
>+				 port_index);
>+			goto retry;
> 		}
>-
> 		/* suspend ports in U0, or bail out for new connect changes */
> 		if ((t1 & PORT_PE) && (t1 & PORT_PLS_MASK) =3D=3D XDEV_U0) {
> 			if ((t1 & PORT_CSC) && wake_enabled) {
>diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
>index feb702516470..bd191fbfdf40 100644
>--- a/drivers/usb/host/xhci.h
>+++ b/drivers/usb/host/xhci.h
>@@ -413,6 +413,14 @@ struct xhci_op_regs {
>  */
> #define XHCI_DEFAULT_BESL	4
>=20
>+/*
>+ * USB3 specification define a 360ms tPollingLFPSTiemout for USB3 ports
>+ * to complete link training. usually link trainig completes much faster
>+ * so check status 10 times with 36ms sleep in places we need to wait for
>+ * polling to complete.
>+ */
>+#define XHCI_PORT_POLLING_LFPS_TIME  36
>+
> /**
>  * struct xhci_intr_reg - Interrupt Register Set
>  * @irq_pending:	IMAN - Interrupt Management Register.  Used to enable
>diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
>index 3114c8d061e9..1c9d08157708 100644
>--- a/drivers/usb/misc/yurex.c
>+++ b/drivers/usb/misc/yurex.c
>@@ -332,6 +332,7 @@ static void yurex_disconnect(struct usb_interface *int=
erface)
> 	usb_deregister_dev(interface, &yurex_class);
>=20
> 	/* prevent more I/O from starting */
>+	usb_poison_urb(dev->urb);
> 	mutex_lock(&dev->io_mutex);
> 	dev->interface =3D NULL;
> 	mutex_unlock(&dev->io_mutex);
>diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
>index b60dac48587c..3e22dd294879 100644
>--- a/drivers/usb/serial/cp210x.c
>+++ b/drivers/usb/serial/cp210x.c
>@@ -76,6 +76,7 @@ static const struct usb_device_id id_table[] =3D {
> 	{ USB_DEVICE(0x10C4, 0x804E) }, /* Software Bisque Paramount ME build-in=
 converter */
> 	{ USB_DEVICE(0x10C4, 0x8053) }, /* Enfora EDG1228 */
> 	{ USB_DEVICE(0x10C4, 0x8054) }, /* Enfora GSM2228 */
>+	{ USB_DEVICE(0x10C4, 0x8056) }, /* Lorenz Messtechnik devices */
> 	{ USB_DEVICE(0x10C4, 0x8066) }, /* Argussoft In-System Programmer */
> 	{ USB_DEVICE(0x10C4, 0x806F) }, /* IMS USB to RS422 Converter Cable */
> 	{ USB_DEVICE(0x10C4, 0x807A) }, /* Crumb128 board */
>diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
>index aa2bec8687fd..3f89153bc122 100644
>--- a/drivers/usb/serial/ftdi_sio.c
>+++ b/drivers/usb/serial/ftdi_sio.c
>@@ -617,6 +617,8 @@ static const struct usb_device_id id_table_combined[] =
=3D {
> 		.driver_info =3D (kernel_ulong_t)&ftdi_jtag_quirk },
> 	{ USB_DEVICE(FTDI_VID, FTDI_NT_ORIONLXM_PID),
> 		.driver_info =3D (kernel_ulong_t)&ftdi_jtag_quirk },
>+	{ USB_DEVICE(FTDI_VID, FTDI_NT_ORIONLX_PLUS_PID) },
>+	{ USB_DEVICE(FTDI_VID, FTDI_NT_ORION_IO_PID) },
> 	{ USB_DEVICE(FTDI_VID, FTDI_SYNAPSE_SS200_PID) },
> 	{ USB_DEVICE(FTDI_VID, FTDI_CUSTOMWARE_MINIPLEX_PID) },
> 	{ USB_DEVICE(FTDI_VID, FTDI_CUSTOMWARE_MINIPLEX2_PID) },
>diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_s=
io_ids.h
>index ecc2424eb8e0..5258cec99219 100644
>--- a/drivers/usb/serial/ftdi_sio_ids.h
>+++ b/drivers/usb/serial/ftdi_sio_ids.h
>@@ -566,7 +566,9 @@
> /*
>  * NovaTech product ids (FTDI_VID)
>  */
>-#define FTDI_NT_ORIONLXM_PID	0x7c90	/* OrionLXm Substation Automation Pla=
tform */
>+#define FTDI_NT_ORIONLXM_PID		0x7c90	/* OrionLXm Substation Automation Pl=
atform */
>+#define FTDI_NT_ORIONLX_PLUS_PID	0x7c91	/* OrionLX+ Substation Automation=
 Platform */
>+#define FTDI_NT_ORION_IO_PID		0x7c92	/* Orion I/O */
>=20
> /*
>  * Synapse Wireless product ids (FTDI_VID)
>diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
>index 56c4f6d074ca..454898c4a137 100644
>--- a/drivers/usb/serial/mos7720.c
>+++ b/drivers/usb/serial/mos7720.c
>@@ -362,8 +362,6 @@ static int write_parport_reg_nonblock(struct mos7715_p=
arport *mos_parport,
> 	if (!urbtrack)
> 		return -ENOMEM;
>=20
>-	kref_get(&mos_parport->ref_count);
>-	urbtrack->mos_parport =3D mos_parport;
> 	urbtrack->urb =3D usb_alloc_urb(0, GFP_ATOMIC);
> 	if (!urbtrack->urb) {
> 		kfree(urbtrack);
>@@ -384,6 +382,8 @@ static int write_parport_reg_nonblock(struct mos7715_p=
arport *mos_parport,
> 			     usb_sndctrlpipe(usbdev, 0),
> 			     (unsigned char *)urbtrack->setup,
> 			     NULL, 0, async_complete, urbtrack);
>+	kref_get(&mos_parport->ref_count);
>+	urbtrack->mos_parport =3D mos_parport;
> 	kref_init(&urbtrack->ref_count);
> 	INIT_LIST_HEAD(&urbtrack->urblist_entry);
>=20
>diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realte=
k_cr.c
>index 281be56d5648..56bfef517f68 100644
>--- a/drivers/usb/storage/realtek_cr.c
>+++ b/drivers/usb/storage/realtek_cr.c
>@@ -767,18 +767,16 @@ static void rts51x_suspend_timer_fn(unsigned long da=
ta)
> 		break;
> 	case RTS51X_STAT_IDLE:
> 	case RTS51X_STAT_SS:
>-		usb_stor_dbg(us, "RTS51X_STAT_SS, intf->pm_usage_cnt:%d, power.usage:%d=
\n",
>-			     atomic_read(&us->pusb_intf->pm_usage_cnt),
>+		usb_stor_dbg(us, "RTS51X_STAT_SS, power.usage:%d\n",
> 			     atomic_read(&us->pusb_intf->dev.power.usage_count));
>=20
>-		if (atomic_read(&us->pusb_intf->pm_usage_cnt) > 0) {
>+		if (atomic_read(&us->pusb_intf->dev.power.usage_count) > 0) {
> 			usb_stor_dbg(us, "Ready to enter SS state\n");
> 			rts51x_set_stat(chip, RTS51X_STAT_SS);
> 			/* ignore mass storage interface's children */
> 			pm_suspend_ignore_children(&us->pusb_intf->dev, true);
> 			usb_autopm_put_interface_async(us->pusb_intf);
>-			usb_stor_dbg(us, "RTS51X_STAT_SS 01, intf->pm_usage_cnt:%d, power.usag=
e:%d\n",
>-				     atomic_read(&us->pusb_intf->pm_usage_cnt),
>+			usb_stor_dbg(us, "RTS51X_STAT_SS 01, power.usage:%d\n",
> 				     atomic_read(&us->pusb_intf->dev.power.usage_count));
> 		}
> 		break;
>@@ -811,11 +809,10 @@ static void rts51x_invoke_transport(struct scsi_cmnd=
 *srb, struct us_data *us)
> 	int ret;
>=20
> 	if (working_scsi(srb)) {
>-		usb_stor_dbg(us, "working scsi, intf->pm_usage_cnt:%d, power.usage:%d\n=
",
>-			     atomic_read(&us->pusb_intf->pm_usage_cnt),
>+		usb_stor_dbg(us, "working scsi, power.usage:%d\n",
> 			     atomic_read(&us->pusb_intf->dev.power.usage_count));
>=20
>-		if (atomic_read(&us->pusb_intf->pm_usage_cnt) <=3D 0) {
>+		if (atomic_read(&us->pusb_intf->dev.power.usage_count) <=3D 0) {
> 			ret =3D usb_autopm_get_interface(us->pusb_intf);
> 			usb_stor_dbg(us, "working scsi, ret=3D%d\n", ret);
> 		}
>diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
>index f544cfaa0a10..3f16c299263f 100644
>--- a/drivers/vhost/net.c
>+++ b/drivers/vhost/net.c
>@@ -39,6 +39,12 @@ MODULE_PARM_DESC(experimental_zcopytx, "Enable Zero Cop=
y TX;"
>  * Using this limit prevents one virtqueue from starving others. */
> #define VHOST_NET_WEIGHT 0x80000
>=20
>+/* Max number of packets transferred before requeueing the job.
>+ * Using this limit prevents one virtqueue from starving others with small
>+ * pkts.
>+ */
>+#define VHOST_NET_PKT_WEIGHT 256
>+
> /* MAX number of TX used buffers for outstanding zerocopy */
> #define VHOST_MAX_PEND 128
> #define VHOST_GOODCOPY_LEN 256
>@@ -351,6 +357,7 @@ static void handle_tx(struct vhost_net *net)
> 	struct socket *sock;
> 	struct vhost_net_ubuf_ref *uninitialized_var(ubufs);
> 	bool zcopy, zcopy_used;
>+	int sent_pkts =3D 0;
>=20
> 	mutex_lock(&vq->mutex);
> 	sock =3D vq->private_data;
>@@ -362,7 +369,7 @@ static void handle_tx(struct vhost_net *net)
> 	hdr_size =3D nvq->vhost_hlen;
> 	zcopy =3D nvq->ubufs;
>=20
>-	for (;;) {
>+	do {
> 		/* Release DMAs done buffers first */
> 		if (zcopy)
> 			vhost_zerocopy_signal_used(net, vq);
>@@ -450,11 +457,7 @@ static void handle_tx(struct vhost_net *net)
> 			vhost_zerocopy_signal_used(net, vq);
> 		total_len +=3D len;
> 		vhost_net_tx_packet(net);
>-		if (unlikely(total_len >=3D VHOST_NET_WEIGHT)) {
>-			vhost_poll_queue(&vq->poll);
>-			break;
>-		}
>-	}
>+	} while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
> out:
> 	mutex_unlock(&vq->mutex);
> }
>@@ -575,6 +578,7 @@ static void handle_rx(struct vhost_net *net)
> 	size_t vhost_hlen, sock_hlen;
> 	size_t vhost_len, sock_len;
> 	struct socket *sock;
>+	int recv_pkts =3D 0;
>=20
> 	mutex_lock(&vq->mutex);
> 	sock =3D vq->private_data;
>@@ -589,7 +593,10 @@ static void handle_rx(struct vhost_net *net)
> 		vq->log : NULL;
> 	mergeable =3D vhost_has_feature(vq, VIRTIO_NET_F_MRG_RXBUF);
>=20
>-	while ((sock_len =3D peek_head_len(sock->sk))) {
>+	do {
>+		sock_len =3D peek_head_len(sock->sk);
>+		if (!sock_len)
>+			break;
> 		sock_len +=3D sock_hlen;
> 		vhost_len =3D sock_len + vhost_hlen;
> 		headcount =3D get_rx_bufs(vq, vq->heads, vhost_len,
>@@ -659,11 +666,8 @@ static void handle_rx(struct vhost_net *net)
> 		if (unlikely(vq_log))
> 			vhost_log_write(vq, vq_log, log, vhost_len);
> 		total_len +=3D vhost_len;
>-		if (unlikely(total_len >=3D VHOST_NET_WEIGHT)) {
>-			vhost_poll_queue(&vq->poll);
>-			break;
>-		}
>-	}
>+	} while (likely(!vhost_exceeds_weight(vq, ++recv_pkts, total_len)));
>+
> out:
> 	mutex_unlock(&vq->mutex);
> }
>@@ -732,7 +736,8 @@ static int vhost_net_open(struct inode *inode, struct =
file *f)
> 		n->vqs[i].vhost_hlen =3D 0;
> 		n->vqs[i].sock_hlen =3D 0;
> 	}
>-	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX);
>+	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
>+		       VHOST_NET_PKT_WEIGHT, VHOST_NET_WEIGHT);
>=20
> 	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, POLLOUT, dev);
> 	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, POLLIN, dev);
>diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
>index 0dfb3fd6e836..498de4bfcd60 100644
>--- a/drivers/vhost/scsi.c
>+++ b/drivers/vhost/scsi.c
>@@ -60,6 +60,12 @@
> #define TCM_VHOST_PREALLOC_UPAGES 2048
> #define TCM_VHOST_PREALLOC_PROT_SGLS 512
>=20
>+/* Max number of requests before requeueing the job.
>+ * Using this limit prevents one virtqueue from starving others with
>+ * request.
>+ */
>+#define VHOST_SCSI_WEIGHT 256
>+
> struct vhost_scsi_inflight {
> 	/* Wait for the flush operation to finish */
> 	struct completion comp;
>@@ -992,7 +998,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vho=
st_virtqueue *vq)
> 	u64 tag;
> 	u32 exp_data_len, data_first, data_num, data_direction, prot_first;
> 	unsigned out, in, i;
>-	int head, ret, data_niov, prot_niov, prot_bytes;
>+	int head, ret, data_niov, prot_niov, prot_bytes, c =3D 0;
> 	size_t req_size;
> 	u16 lun;
> 	u8 *target, *lunp, task_attr;
>@@ -1010,7 +1016,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct v=
host_virtqueue *vq)
>=20
> 	vhost_disable_notify(&vs->dev, vq);
>=20
>-	for (;;) {
>+	do {
> 		head =3D vhost_get_vq_desc(vq, vq->iov,
> 					ARRAY_SIZE(vq->iov), &out, &in,
> 					NULL, NULL);
>@@ -1213,7 +1219,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct v=
host_virtqueue *vq)
> 		 */
> 		INIT_WORK(&cmd->work, tcm_vhost_submission_work);
> 		queue_work(tcm_vhost_workqueue, &cmd->work);
>-	}
>+	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
>=20
> 	mutex_unlock(&vq->mutex);
> 	return;
>@@ -1576,7 +1582,8 @@ static int vhost_scsi_open(struct inode *inode, stru=
ct file *f)
> 		vqs[i] =3D &vs->vqs[i].vq;
> 		vs->vqs[i].vq.handle_kick =3D vhost_scsi_handle_kick;
> 	}
>-	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ);
>+	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ,
>+		       VHOST_SCSI_WEIGHT, 0);
>=20
> 	tcm_vhost_init_inflight(vs, NULL);
>=20
>diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>index 337e1d04871f..48507ef0542a 100644
>--- a/drivers/vhost/vhost.c
>+++ b/drivers/vhost/vhost.c
>@@ -292,8 +292,24 @@ static void vhost_dev_free_iovecs(struct vhost_dev *d=
ev)
> 		vhost_vq_free_iovecs(dev->vqs[i]);
> }
>=20
>+bool vhost_exceeds_weight(struct vhost_virtqueue *vq,
>+			  int pkts, int total_len)
>+{
>+	struct vhost_dev *dev =3D vq->dev;
>+
>+	if ((dev->byte_weight && total_len >=3D dev->byte_weight) ||
>+	    pkts >=3D dev->weight) {
>+		vhost_poll_queue(&vq->poll);
>+		return true;
>+	}
>+
>+	return false;
>+}
>+EXPORT_SYMBOL_GPL(vhost_exceeds_weight);
>+
> void vhost_dev_init(struct vhost_dev *dev,
>-		    struct vhost_virtqueue **vqs, int nvqs)
>+		    struct vhost_virtqueue **vqs, int nvqs,
>+		    int weight, int byte_weight)
> {
> 	struct vhost_virtqueue *vq;
> 	int i;
>@@ -308,6 +324,8 @@ void vhost_dev_init(struct vhost_dev *dev,
> 	spin_lock_init(&dev->work_lock);
> 	INIT_LIST_HEAD(&dev->work_list);
> 	dev->worker =3D NULL;
>+	dev->weight =3D weight;
>+	dev->byte_weight =3D byte_weight;
>=20
> 	for (i =3D 0; i < dev->nvqs; ++i) {
> 		vq =3D dev->vqs[i];
>diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
>index 3eda654b8f5a..6c4c8aade233 100644
>--- a/drivers/vhost/vhost.h
>+++ b/drivers/vhost/vhost.h
>@@ -123,9 +123,13 @@ struct vhost_dev {
> 	spinlock_t work_lock;
> 	struct list_head work_list;
> 	struct task_struct *worker;
>+	int weight;
>+	int byte_weight;
> };
>=20
>-void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs, int=
 nvqs);
>+bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total=
_len);
>+void vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs,
>+		    int nvqs, int weight, int byte_weight);
> long vhost_dev_set_owner(struct vhost_dev *dev);
> bool vhost_dev_has_owner(struct vhost_dev *dev);
> long vhost_dev_check_owner(struct vhost_dev *);
>diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
>index 176b88fa694c..ed420aa9216b 100644
>--- a/drivers/w1/masters/ds2490.c
>+++ b/drivers/w1/masters/ds2490.c
>@@ -1041,15 +1041,15 @@ static int ds_probe(struct usb_interface *intf,
> 	/* alternative 3, 1ms interrupt (greatly speeds search), 64 byte bulk */
> 	alt =3D 3;
> 	err =3D usb_set_interface(dev->udev,
>-		intf->altsetting[alt].desc.bInterfaceNumber, alt);
>+		intf->cur_altsetting->desc.bInterfaceNumber, alt);
> 	if (err) {
> 		dev_err(&dev->udev->dev, "Failed to set alternative setting %d "
> 			"for %d interface: err=3D%d.\n", alt,
>-			intf->altsetting[alt].desc.bInterfaceNumber, err);
>+			intf->cur_altsetting->desc.bInterfaceNumber, err);
> 		goto err_out_clear;
> 	}
>=20
>-	iface_desc =3D &intf->altsetting[alt];
>+	iface_desc =3D intf->cur_altsetting;
> 	if (iface_desc->desc.bNumEndpoints !=3D NUM_EP-1) {
> 		printk(KERN_INFO "Num endpoints=3D%d. It is not DS9490R.\n", iface_desc=
->desc.bNumEndpoints);
> 		err =3D -EINVAL;
>diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
>index 8db7abb6ef5a..cdb055207753 100644
>--- a/drivers/xen/balloon.c
>+++ b/drivers/xen/balloon.c
>@@ -502,8 +502,15 @@ static void balloon_process(struct work_struct *work)
> 				state =3D reserve_additional_memory(credit);
> 		}
>=20
>-		if (credit < 0)
>-			state =3D decrease_reservation(-credit, GFP_BALLOON);
>+		if (credit < 0) {
>+			long n_pages;
>+
>+			n_pages =3D min(-credit, si_mem_available());
>+			state =3D decrease_reservation(n_pages, GFP_BALLOON);
>+			if (state =3D=3D BP_DONE && n_pages !=3D -credit &&
>+			    n_pages < totalreserve_pages)
>+				state =3D BP_EAGAIN;
>+		}
>=20
> 		state =3D update_schedule(state);
>=20
>@@ -561,6 +568,9 @@ int alloc_xenballooned_pages(int nr_pages, struct page=
 **pages, bool highmem)
> 			enum bp_state st;
> 			if (page)
> 				balloon_append(page);
>+			if (si_mem_available() < nr_pages)
>+				return -ENOMEM;
>+
> 			st =3D decrease_reservation(nr_pages - pgno,
> 					highmem ? GFP_HIGHUSER : GFP_USER);
> 			if (st !=3D BP_DONE)
>@@ -692,7 +702,7 @@ static int __init balloon_init(void)
> 	balloon_stats.schedule_delay =3D 1;
> 	balloon_stats.max_schedule_delay =3D 32;
> 	balloon_stats.retry_count =3D 1;
>-	balloon_stats.max_retry_count =3D RETRY_UNLIMITED;
>+	balloon_stats.max_retry_count =3D 4;
>=20
> #ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
> 	balloon_stats.hotplug_pages =3D 0;
>diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
>index c2e930ec2888..696db173e26f 100644
>--- a/fs/afs/fsclient.c
>+++ b/fs/afs/fsclient.c
>@@ -1382,8 +1382,8 @@ static int afs_fs_setattr_size64(struct afs_server *=
server, struct key *key,
>=20
> 	xdr_encode_AFS_StoreStatus(&bp, attr);
>=20
>-	*bp++ =3D 0;				/* position of start of write */
>-	*bp++ =3D 0;
>+	*bp++ =3D htonl(attr->ia_size >> 32);	/* position of start of write */
>+	*bp++ =3D htonl((u32) attr->ia_size);
> 	*bp++ =3D 0;				/* size of write */
> 	*bp++ =3D 0;
> 	*bp++ =3D htonl(attr->ia_size >> 32);	/* new file length */
>@@ -1433,7 +1433,7 @@ static int afs_fs_setattr_size(struct afs_server *se=
rver, struct key *key,
>=20
> 	xdr_encode_AFS_StoreStatus(&bp, attr);
>=20
>-	*bp++ =3D 0;				/* position of start of write */
>+	*bp++ =3D htonl(attr->ia_size);		/* position of start of write */
> 	*bp++ =3D 0;				/* size of write */
> 	*bp++ =3D htonl(attr->ia_size);		/* new file length */
>=20
>diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
>index 6db91cdbd92d..6a02cb3e5650 100644
>--- a/fs/btrfs/compression.c
>+++ b/fs/btrfs/compression.c
>@@ -42,6 +42,8 @@
> #include "extent_io.h"
> #include "extent_map.h"
>=20
>+static const char* const btrfs_compress_types[] =3D { "", "zlib", "lzo" };
>+
> struct compressed_bio {
> 	/* number of bios pending for this compressed extent */
> 	atomic_t pending_bios;
>@@ -81,6 +83,22 @@ struct compressed_bio {
> 	u32 sums;
> };
>=20
>+bool btrfs_compress_is_valid_type(const char *str, size_t len)
>+{
>+	int i;
>+
>+	for (i =3D 1; i < ARRAY_SIZE(btrfs_compress_types); i++) {
>+		size_t comp_len =3D strlen(btrfs_compress_types[i]);
>+
>+		if (len < comp_len)
>+			continue;
>+
>+		if (!strncmp(btrfs_compress_types[i], str, comp_len))
>+			return true;
>+	}
>+	return false;
>+}
>+
> static int btrfs_decompress_biovec(int type, struct page **pages_in,
> 				   u64 disk_start, struct bio_vec *bvec,
> 				   int vcnt, size_t srclen);
>diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
>index d181f70caae0..5f15b34d88f7 100644
>--- a/fs/btrfs/compression.h
>+++ b/fs/btrfs/compression.h
>@@ -80,4 +80,5 @@ struct btrfs_compress_op {
> extern struct btrfs_compress_op btrfs_zlib_compress;
> extern struct btrfs_compress_op btrfs_lzo_compress;
>=20
>+bool btrfs_compress_is_valid_type(const char *str, size_t len);
> #endif
>diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
>index 129b1dd28527..8b041d83533a 100644
>--- a/fs/btrfs/props.c
>+++ b/fs/btrfs/props.c
>@@ -22,6 +22,7 @@
> #include "hash.h"
> #include "transaction.h"
> #include "xattr.h"
>+#include "compression.h"
>=20
> #define BTRFS_PROP_HANDLERS_HT_BITS 8
> static DEFINE_HASHTABLE(prop_handlers_ht, BTRFS_PROP_HANDLERS_HT_BITS);
>@@ -378,9 +379,7 @@ int btrfs_subvol_inherit_props(struct btrfs_trans_hand=
le *trans,
>=20
> static int prop_compression_validate(const char *value, size_t len)
> {
>-	if (!strncmp("lzo", value, len))
>-		return 0;
>-	else if (!strncmp("zlib", value, len))
>+	if (btrfs_compress_is_valid_type(value, len))
> 		return 0;
>=20
> 	return -EINVAL;
>diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>index 5e2005030f54..bdda508cc85d 100644
>--- a/fs/ceph/dir.c
>+++ b/fs/ceph/dir.c
>@@ -1327,6 +1327,7 @@ void ceph_dentry_lru_del(struct dentry *dn)
> unsigned ceph_dentry_hash(struct inode *dir, struct dentry *dn)
> {
> 	struct ceph_inode_info *dci =3D ceph_inode(dir);
>+	unsigned hash;
>=20
> 	switch (dci->i_dir_layout.dl_dir_hash) {
> 	case 0:	/* for backward compat */
>@@ -1334,8 +1335,11 @@ unsigned ceph_dentry_hash(struct inode *dir, struct=
 dentry *dn)
> 		return dn->d_name.hash;
>=20
> 	default:
>-		return ceph_str_hash(dci->i_dir_layout.dl_dir_hash,
>+		spin_lock(&dn->d_lock);
>+		hash =3D ceph_str_hash(dci->i_dir_layout.dl_dir_hash,
> 				     dn->d_name.name, dn->d_name.len);
>+		spin_unlock(&dn->d_lock);
>+		return hash;
> 	}
> }
>=20
>diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>index 23f5cb1ee904..ff85c3129e9d 100644
>--- a/fs/cifs/cifsglob.h
>+++ b/fs/cifs/cifsglob.h
>@@ -1092,6 +1092,7 @@ cifsFileInfo_get_locked(struct cifsFileInfo *cifs_fi=
le)
> }
>=20
> struct cifsFileInfo *cifsFileInfo_get(struct cifsFileInfo *cifs_file);
>+void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_h=
dlr);
> void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
>=20
> #define CIFS_CACHE_READ_FLG	1
>@@ -1579,6 +1580,7 @@ GLOBAL_EXTERN spinlock_t gidsidlock;
> #endif /* CONFIG_CIFS_ACL */
>=20
> void cifs_oplock_break(struct work_struct *work);
>+void cifs_queue_oplock_break(struct cifsFileInfo *cfile);
>=20
> extern const struct slow_work_ops cifs_oplock_break_ops;
> extern struct workqueue_struct *cifsiod_wq;
>diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>index 4b8870f889e3..9b3d28b79329 100644
>--- a/fs/cifs/file.c
>+++ b/fs/cifs/file.c
>@@ -359,12 +359,30 @@ cifsFileInfo_get(struct cifsFileInfo *cifs_file)
> 	return cifs_file;
> }
>=20
>-/*
>- * Release a reference on the file private data. This may involve closing
>- * the filehandle out on the server. Must be called without holding
>- * tcon->open_file_lock and cifs_file->file_info_lock.
>+/**
>+ * cifsFileInfo_put - release a reference of file priv data
>+ *
>+ * Always potentially wait for oplock handler. See _cifsFileInfo_put().
>  */
> void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>+{
>+	_cifsFileInfo_put(cifs_file, true);
>+}
>+
>+/**
>+ * _cifsFileInfo_put - release a reference of file priv data
>+ *
>+ * This may involve closing the filehandle @cifs_file out on the
>+ * server. Must be called without holding tcon->open_file_lock and
>+ * cifs_file->file_info_lock.
>+ *
>+ * If @wait_for_oplock_handler is true and we are releasing the last
>+ * reference, wait for any running oplock break handler of the file
>+ * and cancel any pending one. If calling this function from the
>+ * oplock break handler, you need to pass false.
>+ *
>+ */
>+void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_h=
andler)
> {
> 	struct inode *inode =3D cifs_file->dentry->d_inode;
> 	struct cifs_tcon *tcon =3D tlink_tcon(cifs_file->tlink);
>@@ -412,7 +430,8 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>=20
> 	spin_unlock(&tcon->open_file_lock);
>=20
>-	oplock_break_cancelled =3D cancel_work_sync(&cifs_file->oplock_break);
>+	oplock_break_cancelled =3D wait_oplock_handler ?
>+		cancel_work_sync(&cifs_file->oplock_break) : false;
>=20
> 	if (!tcon->need_reconnect && !cifs_file->invalidHandle) {
> 		struct TCP_Server_Info *server =3D tcon->ses->server;
>@@ -3701,6 +3720,7 @@ void cifs_oplock_break(struct work_struct *work)
> 							     cinode);
> 		cifs_dbg(FYI, "Oplock release rc =3D %d\n", rc);
> 	}
>+	_cifsFileInfo_put(cfile, false /* do not wait for ourself */);
> 	cifs_done_oplock_break(cinode);
> }
>=20
>diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>index 09ca7c978700..f681091ec3db 100644
>--- a/fs/cifs/inode.c
>+++ b/fs/cifs/inode.c
>@@ -1627,6 +1627,10 @@ cifs_do_rename(const unsigned int xid, struct dentr=
y *from_dentry,
> 	if (rc =3D=3D 0 || rc !=3D -EBUSY)
> 		goto do_rename_exit;
>=20
>+	/* Don't fall back to using SMB on SMB 2+ mount */
>+	if (server->vals->protocol_id !=3D 0)
>+		goto do_rename_exit;
>+
> 	/* open-file renames don't work across directories */
> 	if (to_dentry->d_parent !=3D from_dentry->d_parent)
> 		goto do_rename_exit;
>diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
>index f03fecafc5d5..debc26b95cd7 100644
>--- a/fs/cifs/misc.c
>+++ b/fs/cifs/misc.c
>@@ -477,8 +477,7 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_=
Info *srv)
> 					   CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
> 					   &pCifsInode->flags);
>=20
>-				queue_work(cifsoplockd_wq,
>-					   &netfile->oplock_break);
>+				cifs_queue_oplock_break(netfile);
> 				netfile->oplock_break_cancelled =3D false;
>=20
> 				spin_unlock(&tcon->open_file_lock);
>@@ -610,6 +609,28 @@ void cifs_put_writer(struct cifsInodeInfo *cinode)
> 	spin_unlock(&cinode->writers_lock);
> }
>=20
>+/**
>+ * cifs_queue_oplock_break - queue the oplock break handler for cfile
>+ *
>+ * This function is called from the demultiplex thread when it
>+ * receives an oplock break for @cfile.
>+ *
>+ * Assumes the tcon->open_file_lock is held.
>+ * Assumes cfile->file_info_lock is NOT held.
>+ */
>+void cifs_queue_oplock_break(struct cifsFileInfo *cfile)
>+{
>+	/*
>+	 * Bump the handle refcount now while we hold the
>+	 * open_file_lock to enforce the validity of it for the oplock
>+	 * break handler. The matching put is done at the end of the
>+	 * handler.
>+	 */
>+	cifsFileInfo_get(cfile);
>+
>+	queue_work(cifsoplockd_wq, &cfile->oplock_break);
>+}
>+
> void cifs_done_oplock_break(struct cifsInodeInfo *cinode)
> {
> 	clear_bit(CIFS_INODE_PENDING_OPLOCK_BREAK, &cinode->flags);
>diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
>index 1485ab8c2d65..f80fcc6921ee 100644
>--- a/fs/cifs/smb2misc.c
>+++ b/fs/cifs/smb2misc.c
>@@ -458,7 +458,7 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb=
2_lease_break *rsp,
> 			clear_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
> 				  &cinode->flags);
>=20
>-		queue_work(cifsoplockd_wq, &cfile->oplock_break);
>+		cifs_queue_oplock_break(cfile);
> 		kfree(lw);
> 		return true;
> 	}
>@@ -602,8 +602,8 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Se=
rver_Info *server)
> 					   CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
> 					   &cinode->flags);
> 				spin_unlock(&cfile->file_info_lock);
>-				queue_work(cifsoplockd_wq,
>-					   &cfile->oplock_break);
>+
>+				cifs_queue_oplock_break(cfile);
>=20
> 				spin_unlock(&tcon->open_file_lock);
> 				spin_unlock(&cifs_tcp_ses_lock);
>diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
>index 376ccd96127f..d95a547cf94e 100644
>--- a/fs/cifs/smb2ops.c
>+++ b/fs/cifs/smb2ops.c
>@@ -906,6 +906,8 @@ smb2_query_symlink(const unsigned int xid, struct cifs=
_tcon *tcon,
>=20
> 	rc =3D SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, &err_buf);
>=20
>+	if (!rc)
>+		SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
> 	if (!rc || !err_buf) {
> 		kfree(utf16_path);
> 		return -ENOENT;
>diff --git a/fs/ext4/file.c b/fs/ext4/file.c
>index 40c86790109e..201f683bea89 100644
>--- a/fs/ext4/file.c
>+++ b/fs/ext4/file.c
>@@ -79,7 +79,7 @@ ext4_unaligned_aio(struct inode *inode, struct iov_iter =
*from, loff_t pos)
> 	struct super_block *sb =3D inode->i_sb;
> 	int blockmask =3D sb->s_blocksize - 1;
>=20
>-	if (pos >=3D i_size_read(inode))
>+	if (pos >=3D ALIGN(i_size_read(inode), sb->s_blocksize))
> 		return 0;
>=20
> 	if ((pos | iov_iter_alignment(from)) & blockmask)
>diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
>index 80c3f1ed1afa..63597cd0265c 100644
>--- a/fs/ext4/resize.c
>+++ b/fs/ext4/resize.c
>@@ -908,11 +908,18 @@ static int add_new_gdb_meta_bg(struct super_block *s=
b,
> 	memcpy(n_group_desc, o_group_desc,
> 	       EXT4_SB(sb)->s_gdb_count * sizeof(struct buffer_head *));
> 	n_group_desc[gdb_num] =3D gdb_bh;
>+
>+	BUFFER_TRACE(gdb_bh, "get_write_access");
>+	err =3D ext4_journal_get_write_access(handle, gdb_bh);
>+	if (err) {
>+		kvfree(n_group_desc);
>+		brelse(gdb_bh);
>+		return err;
>+	}
>+
> 	EXT4_SB(sb)->s_group_desc =3D n_group_desc;
> 	EXT4_SB(sb)->s_gdb_count++;
> 	ext4_kvfree(o_group_desc);
>-	BUFFER_TRACE(gdb_bh, "get_write_access");
>-	err =3D ext4_journal_get_write_access(handle, gdb_bh);
> 	return err;
> }
>=20
>diff --git a/fs/lockd/host.c b/fs/lockd/host.c
>index b31117c12102..6f12147a2fea 100644
>--- a/fs/lockd/host.c
>+++ b/fs/lockd/host.c
>@@ -288,12 +288,11 @@ void nlmclnt_release_host(struct nlm_host *host)
>=20
> 	WARN_ON_ONCE(host->h_server);
>=20
>-	if (atomic_dec_and_test(&host->h_count)) {
>+	if (atomic_dec_and_mutex_lock(&host->h_count, &nlm_host_mutex)) {
> 		WARN_ON_ONCE(!list_empty(&host->h_lockowners));
> 		WARN_ON_ONCE(!list_empty(&host->h_granted));
> 		WARN_ON_ONCE(!list_empty(&host->h_reclaim));
>=20
>-		mutex_lock(&nlm_host_mutex);
> 		nlm_destroy_host_locked(host);
> 		mutex_unlock(&nlm_host_mutex);
> 	}
>diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
>index 7445af0b1aa3..a0bc66039269 100644
>--- a/fs/proc/meminfo.c
>+++ b/fs/proc/meminfo.c
>@@ -27,10 +27,7 @@ static int meminfo_proc_show(struct seq_file *m, void *=
v)
> 	struct vmalloc_info vmi;
> 	long cached;
> 	long available;
>-	unsigned long pagecache;
>-	unsigned long wmark_low =3D 0;
> 	unsigned long pages[NR_LRU_LISTS];
>-	struct zone *zone;
> 	int lru;
>=20
> /*
>@@ -51,36 +48,7 @@ static int meminfo_proc_show(struct seq_file *m, void *=
v)
> 	for (lru =3D LRU_BASE; lru < NR_LRU_LISTS; lru++)
> 		pages[lru] =3D global_page_state(NR_LRU_BASE + lru);
>=20
>-	for_each_zone(zone)
>-		wmark_low +=3D zone->watermark[WMARK_LOW];
>-
>-	/*
>-	 * Estimate the amount of memory available for userspace allocations,
>-	 * without causing swapping.
>-	 *
>-	 * Free memory cannot be taken below the low watermark, before the
>-	 * system starts swapping.
>-	 */
>-	available =3D i.freeram - wmark_low;
>-
>-	/*
>-	 * Not all the page cache can be freed, otherwise the system will
>-	 * start swapping. Assume at least half of the page cache, or the
>-	 * low watermark worth of cache, needs to stay.
>-	 */
>-	pagecache =3D pages[LRU_ACTIVE_FILE] + pages[LRU_INACTIVE_FILE];
>-	pagecache -=3D min(pagecache / 2, wmark_low);
>-	available +=3D pagecache;
>-
>-	/*
>-	 * Part of the reclaimable slab consists of items that are in use,
>-	 * and cannot be freed. Cap this estimate at the low watermark.
>-	 */
>-	available +=3D global_page_state(NR_SLAB_RECLAIMABLE) -
>-		     min(global_page_state(NR_SLAB_RECLAIMABLE) / 2, wmark_low);
>-
>-	if (available < 0)
>-		available =3D 0;
>+	available =3D si_mem_available();
>=20
> 	/*
> 	 * Tagged format, for easy grepping and expansion.
>diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
>index bfb8e8d588b8..eb7067de78db 100644
>--- a/fs/proc/proc_sysctl.c
>+++ b/fs/proc/proc_sysctl.c
>@@ -1550,8 +1550,11 @@ static void drop_sysctl_table(struct ctl_table_head=
er *header)
> 	if (--header->nreg)
> 		return;
>=20
>-	put_links(header);
>-	start_unregistering(header);
>+	if (parent) {
>+		put_links(header);
>+		start_unregistering(header);
>+	}
>+
> 	if (!--header->count)
> 		kfree_rcu(header, rcu);
>=20
>diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
>index 8a9657d7f7c6..8df2632a2966 100644
>--- a/fs/udf/truncate.c
>+++ b/fs/udf/truncate.c
>@@ -261,6 +261,9 @@ void udf_truncate_extents(struct inode *inode)
> 			epos.block =3D eloc;
> 			epos.bh =3D udf_tread(sb,
> 					udf_get_lb_pblock(sb, &eloc, 0));
>+			/* Error reading indirect block? */
>+			if (!epos.bh)
>+				return;
> 			if (elen)
> 				indirect_ext_len =3D
> 					(elen + sb->s_blocksize - 1) >>
>diff --git a/fs/ufs/util.h b/fs/ufs/util.h
>index 3f9463f8cf2f..f877d5cadd98 100644
>--- a/fs/ufs/util.h
>+++ b/fs/ufs/util.h
>@@ -228,7 +228,7 @@ ufs_get_inode_gid(struct super_block *sb, struct ufs_i=
node *inode)
> 	case UFS_UID_44BSD:
> 		return fs32_to_cpu(sb, inode->ui_u3.ui_44.ui_gid);
> 	case UFS_UID_EFT:
>-		if (inode->ui_u1.oldids.ui_suid =3D=3D 0xFFFF)
>+		if (inode->ui_u1.oldids.ui_sgid =3D=3D 0xFFFF)
> 			return fs32_to_cpu(sb, inode->ui_u3.ui_sun.ui_gid);
> 		/* Fall through */
> 	default:
>diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
>index 8c0ff78ff45a..83fac3e091c2 100644
>--- a/include/linux/kprobes.h
>+++ b/include/linux/kprobes.h
>@@ -197,6 +197,7 @@ struct kretprobe_instance {
> 	struct kretprobe *rp;
> 	kprobe_opcode_t *ret_addr;
> 	struct task_struct *task;
>+	void *fp;
> 	char data[0];
> };
>=20
>diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
>index 64c7425afbce..f2bca5a77851 100644
>--- a/include/linux/lockdep.h
>+++ b/include/linux/lockdep.h
>@@ -525,9 +525,24 @@ do {									\
> 	lock_acquire(&(lock)->dep_map, 0, 0, 1, 1, NULL, _THIS_IP_);	\
> 	lock_release(&(lock)->dep_map, 0, _THIS_IP_);			\
> } while (0)
>+
>+#define lockdep_assert_irqs_enabled()	do {				\
>+		WARN_ONCE(debug_locks && !current->lockdep_recursion &&	\
>+			  !current->hardirqs_enabled,			\
>+			  "IRQs not enabled as expected\n");		\
>+	} while (0)
>+
>+#define lockdep_assert_irqs_disabled()	do {				\
>+		WARN_ONCE(debug_locks && !current->lockdep_recursion &&	\
>+			  current->hardirqs_enabled,			\
>+			  "IRQs not disabled as expected\n");		\
>+	} while (0)
>+
> #else
> # define might_lock(lock) do { } while (0)
> # define might_lock_read(lock) do { } while (0)
>+# define lockdep_assert_irqs_enabled() do { } while (0)
>+# define lockdep_assert_irqs_disabled() do { } while (0)
> #endif
>=20
> #ifdef CONFIG_PROVE_RCU
>diff --git a/include/linux/mm.h b/include/linux/mm.h
>index a576467cd4a5..e67e12641b63 100644
>--- a/include/linux/mm.h
>+++ b/include/linux/mm.h
>@@ -1699,6 +1699,7 @@ extern int __meminit init_per_zone_wmark_min(void);
> extern void mem_init(void);
> extern void __init mmap_init(void);
> extern void show_mem(unsigned int flags);
>+extern long si_mem_available(void);
> extern void si_meminfo(struct sysinfo * val);
> extern void si_meminfo_node(struct sysinfo *val, int nid);
>=20
>diff --git a/include/linux/siphash.h b/include/linux/siphash.h
>new file mode 100644
>index 000000000000..c8c7ae2e687b
>--- /dev/null
>+++ b/include/linux/siphash.h
>@@ -0,0 +1,90 @@
>+/* Copyright (C) 2016 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Re=
served.
>+ *
>+ * This file is provided under a dual BSD/GPLv2 license.
>+ *
>+ * SipHash: a fast short-input PRF
>+ * https://131002.net/siphash/
>+ *
>+ * This implementation is specifically for SipHash2-4.
>+ */
>+
>+#ifndef _LINUX_SIPHASH_H
>+#define _LINUX_SIPHASH_H
>+
>+#include <linux/types.h>
>+#include <linux/kernel.h>
>+
>+#define SIPHASH_ALIGNMENT __alignof__(u64)
>+typedef struct {
>+	u64 key[2];
>+} siphash_key_t;
>+
>+static inline bool siphash_key_is_zero(const siphash_key_t *key)
>+{
>+	return !(key->key[0] | key->key[1]);
>+}
>+
>+u64 __siphash_aligned(const void *data, size_t len, const siphash_key_t *=
key);
>+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>+u64 __siphash_unaligned(const void *data, size_t len, const siphash_key_t=
 *key);
>+#endif
>+
>+u64 siphash_1u64(const u64 a, const siphash_key_t *key);
>+u64 siphash_2u64(const u64 a, const u64 b, const siphash_key_t *key);
>+u64 siphash_3u64(const u64 a, const u64 b, const u64 c,
>+		 const siphash_key_t *key);
>+u64 siphash_4u64(const u64 a, const u64 b, const u64 c, const u64 d,
>+		 const siphash_key_t *key);
>+u64 siphash_1u32(const u32 a, const siphash_key_t *key);
>+u64 siphash_3u32(const u32 a, const u32 b, const u32 c,
>+		 const siphash_key_t *key);
>+
>+static inline u64 siphash_2u32(const u32 a, const u32 b,
>+			       const siphash_key_t *key)
>+{
>+	return siphash_1u64((u64)b << 32 | a, key);
>+}
>+static inline u64 siphash_4u32(const u32 a, const u32 b, const u32 c,
>+			       const u32 d, const siphash_key_t *key)
>+{
>+	return siphash_2u64((u64)b << 32 | a, (u64)d << 32 | c, key);
>+}
>+
>+
>+static inline u64 ___siphash_aligned(const __le64 *data, size_t len,
>+				     const siphash_key_t *key)
>+{
>+	if (__builtin_constant_p(len) && len =3D=3D 4)
>+		return siphash_1u32(le32_to_cpup((const __le32 *)data), key);
>+	if (__builtin_constant_p(len) && len =3D=3D 8)
>+		return siphash_1u64(le64_to_cpu(data[0]), key);
>+	if (__builtin_constant_p(len) && len =3D=3D 16)
>+		return siphash_2u64(le64_to_cpu(data[0]), le64_to_cpu(data[1]),
>+				    key);
>+	if (__builtin_constant_p(len) && len =3D=3D 24)
>+		return siphash_3u64(le64_to_cpu(data[0]), le64_to_cpu(data[1]),
>+				    le64_to_cpu(data[2]), key);
>+	if (__builtin_constant_p(len) && len =3D=3D 32)
>+		return siphash_4u64(le64_to_cpu(data[0]), le64_to_cpu(data[1]),
>+				    le64_to_cpu(data[2]), le64_to_cpu(data[3]),
>+				    key);
>+	return __siphash_aligned(data, len, key);
>+}
>+
>+/**
>+ * siphash - compute 64-bit siphash PRF value
>+ * @data: buffer to hash
>+ * @size: size of @data
>+ * @key: the siphash key
>+ */
>+static inline u64 siphash(const void *data, size_t len,
>+			  const siphash_key_t *key)
>+{
>+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>+	if (!IS_ALIGNED((unsigned long)data, SIPHASH_ALIGNMENT))
>+		return __siphash_unaligned(data, len, key);
>+#endif
>+	return ___siphash_aligned(data, len, key);
>+}
>+
>+#endif /* _LINUX_SIPHASH_H */
>diff --git a/include/linux/string.h b/include/linux/string.h
>index dd71dd08a840..85491dd76903 100644
>--- a/include/linux/string.h
>+++ b/include/linux/string.h
>@@ -113,6 +113,9 @@ extern void * memscan(void *,int,__kernel_size_t);
> #ifndef __HAVE_ARCH_MEMCMP
> extern int memcmp(const void *,const void *,__kernel_size_t);
> #endif
>+#ifndef __HAVE_ARCH_BCMP
>+extern int bcmp(const void *,const void *,__kernel_size_t);
>+#endif
> #ifndef __HAVE_ARCH_MEMCHR
> extern void * memchr(const void *,int,__kernel_size_t);
> #endif
>diff --git a/include/linux/usb.h b/include/linux/usb.h
>index a53e036b2252..64a39f02a5f6 100644
>--- a/include/linux/usb.h
>+++ b/include/linux/usb.h
>@@ -125,7 +125,6 @@ enum usb_interface_condition {
>  * @dev: driver model's view of this device
>  * @usb_dev: if an interface is bound to the USB major, this will point
>  *	to the sysfs representation for that device.
>- * @pm_usage_cnt: PM usage counter for this interface
>  * @reset_ws: Used for scheduling resets from atomic context.
>  * @reset_running: set to 1 if the interface is currently running a
>  *      queued reset so that usb_cancel_queued_reset() doesn't try to
>@@ -186,7 +185,6 @@ struct usb_interface {
>=20
> 	struct device dev;		/* interface specific device info */
> 	struct device *usb_dev;
>-	atomic_t pm_usage_cnt;		/* usage counter for autosuspend */
> 	struct work_struct reset_ws;	/* for resets in atomic context */
> };
> #define	to_usb_interface(d) container_of(d, struct usb_interface, dev)
>diff --git a/include/net/ip.h b/include/net/ip.h
>index 27dd9826e05d..8ec53320c902 100644
>--- a/include/net/ip.h
>+++ b/include/net/ip.h
>@@ -319,9 +319,10 @@ static inline unsigned int ip_skb_dst_mtu(const struc=
t sk_buff *skb)
> }
>=20
> u32 ip_idents_reserve(u32 hash, int segs);
>-void __ip_select_ident(struct iphdr *iph, int segs);
>+void __ip_select_ident(struct net *net, struct iphdr *iph, int segs);
>=20
>-static inline void ip_select_ident_segs(struct sk_buff *skb, struct sock =
*sk, int segs)
>+static inline void ip_select_ident_segs(struct net *net, struct sk_buff *=
skb,
>+					struct sock *sk, int segs)
> {
> 	struct iphdr *iph =3D ip_hdr(skb);
>=20
>@@ -338,13 +339,14 @@ static inline void ip_select_ident_segs(struct sk_bu=
ff *skb, struct sock *sk, in
> 			iph->id =3D 0;
> 		}
> 	} else {
>-		__ip_select_ident(iph, segs);
>+		__ip_select_ident(net, iph, segs);
> 	}
> }
>=20
>-static inline void ip_select_ident(struct sk_buff *skb, struct sock *sk)
>+static inline void ip_select_ident(struct net *net, struct sk_buff *skb,
>+				   struct sock *sk)
> {
>-	ip_select_ident_segs(skb, sk, 1);
>+	ip_select_ident_segs(net, skb, sk, 1);
> }
>=20
> static inline __wsum inet_compute_pseudo(struct sk_buff *skb, int proto)
>diff --git a/include/net/ipv6.h b/include/net/ipv6.h
>index c30ba46ef2f0..c4e455f4bfe6 100644
>--- a/include/net/ipv6.h
>+++ b/include/net/ipv6.h
>@@ -688,7 +688,9 @@ static inline int ipv6_addr_diff(const struct in6_addr=
 *a1, const struct in6_add
> 	return __ipv6_addr_diff(a1, a2, sizeof(struct in6_addr));
> }
>=20
>-void ipv6_proxy_select_ident(struct sk_buff *skb);
>+void ipv6_select_ident(struct net *net, struct frag_hdr *fhdr,
>+		       struct rt6_info *rt);
>+void ipv6_proxy_select_ident(struct net *net, struct sk_buff *skb);
>=20
> int ip6_dst_hoplimit(struct dst_entry *dst);
>=20
>diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/=
nf_conntrack.h
>index 5c53572b5f0d..3b66e31a7819 100644
>--- a/include/net/netfilter/nf_conntrack.h
>+++ b/include/net/netfilter/nf_conntrack.h
>@@ -289,6 +289,8 @@ void init_nf_conntrack_hash_rnd(void);
>=20
> void nf_conntrack_tmpl_insert(struct net *net, struct nf_conn *tmpl);
>=20
>+u32 nf_ct_get_id(const struct nf_conn *ct);
>+
> #define NF_CT_STAT_INC(net, count)	  __this_cpu_inc((net)->ct.stat->count)
> #define NF_CT_STAT_INC_ATOMIC(net, count) this_cpu_inc((net)->ct.stat->co=
unt)
>=20
>diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
>index 80a1c572b9a0..213f53d4f6b2 100644
>--- a/include/net/netns/ipv4.h
>+++ b/include/net/netns/ipv4.h
>@@ -7,6 +7,7 @@
>=20
> #include <linux/uidgid.h>
> #include <net/inet_frag.h>
>+#include <linux/siphash.h>
>=20
> struct tcpm_hash_bucket;
> struct ctl_table_header;
>@@ -98,5 +99,6 @@ struct netns_ipv4 {
> #endif
> #endif
> 	atomic_t	rt_genid;
>+	siphash_key_t	ip_id_key;
> };
> #endif
>diff --git a/include/net/sctp/checksum.h b/include/net/sctp/checksum.h
>index 32ee65a30aff..1c6e6c0766ca 100644
>--- a/include/net/sctp/checksum.h
>+++ b/include/net/sctp/checksum.h
>@@ -61,7 +61,7 @@ static inline __wsum sctp_csum_combine(__wsum csum, __ws=
um csum2,
> static inline __le32 sctp_compute_cksum(const struct sk_buff *skb,
> 					unsigned int offset)
> {
>-	struct sctphdr *sh =3D sctp_hdr(skb);
>+	struct sctphdr *sh =3D (struct sctphdr *)(skb->data + offset);
> 	const struct skb_checksum_ops ops =3D {
> 		.update  =3D sctp_csum_update,
> 		.combine =3D sctp_csum_combine,
>diff --git a/kernel/events/core.c b/kernel/events/core.c
>index e8be52939ed1..3beed0ea98d9 100644
>--- a/kernel/events/core.c
>+++ b/kernel/events/core.c
>@@ -5445,6 +5445,7 @@ static void perf_event_mmap_output(struct perf_event=
 *event,
> 	struct perf_output_handle handle;
> 	struct perf_sample_data sample;
> 	int size =3D mmap_event->event_id.header.size;
>+	u32 type =3D mmap_event->event_id.header.type;
> 	int ret;
>=20
> 	if (!perf_event_mmap_match(event, data))
>@@ -5488,6 +5489,7 @@ static void perf_event_mmap_output(struct perf_event=
 *event,
> 	perf_output_end(&handle);
> out:
> 	mmap_event->event_id.header.size =3D size;
>+	mmap_event->event_id.header.type =3D type;
> }
>=20
> static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
>diff --git a/kernel/futex.c b/kernel/futex.c
>index 0ee2f54d74fb..99679c0040cc 100644
>--- a/kernel/futex.c
>+++ b/kernel/futex.c
>@@ -2909,6 +2909,10 @@ int handle_futex_death(u32 __user *uaddr, struct ta=
sk_struct *curr, int pi)
> {
> 	u32 uval, uninitialized_var(nval), mval;
>=20
>+	/* Futex address must be 32bit aligned */
>+	if ((((unsigned long)uaddr) % sizeof(*uaddr)) !=3D 0)
>+		return -1;
>+
> retry:
> 	if (get_user(uval, uaddr))
> 		return -1;
>diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>index 328410652be6..f967ff776e5b 100644
>--- a/kernel/sched/fair.c
>+++ b/kernel/sched/fair.c
>@@ -1503,6 +1503,10 @@ static u64 numa_get_avg_runtime(struct task_struct =
*p, u64 *period)
> 	if (p->last_task_numa_placement) {
> 		delta =3D runtime - p->last_sum_exec_runtime;
> 		*period =3D now - p->last_task_numa_placement;
>+
>+		/* Avoid time going backwards, prevent potential divide error: */
>+		if (unlikely((s64)*period < 0))
>+			*period =3D 0;
> 	} else {
> 		delta =3D p->se.avg.runnable_avg_sum;
> 		*period =3D p->se.avg.runnable_avg_period;
>@@ -3704,6 +3708,8 @@ static enum hrtimer_restart sched_cfs_slack_timer(st=
ruct hrtimer *timer)
> 	return HRTIMER_NORESTART;
> }
>=20
>+extern const u64 max_cfs_quota_period;
>+
> static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
> {
> 	struct cfs_bandwidth *cfs_b =3D
>@@ -3711,6 +3717,7 @@ static enum hrtimer_restart sched_cfs_period_timer(s=
truct hrtimer *timer)
> 	ktime_t now;
> 	int overrun;
> 	int idle =3D 0;
>+	int count =3D 0;
>=20
> 	raw_spin_lock(&cfs_b->lock);
> 	for (;;) {
>@@ -3720,6 +3727,28 @@ static enum hrtimer_restart sched_cfs_period_timer(=
struct hrtimer *timer)
> 		if (!overrun)
> 			break;
>=20
>+		if (++count > 3) {
>+			u64 new, old =3D ktime_to_ns(cfs_b->period);
>+
>+			new =3D (old * 147) / 128; /* ~115% */
>+			new =3D min(new, max_cfs_quota_period);
>+
>+			cfs_b->period =3D ns_to_ktime(new);
>+
>+			/* since max is 1s, this is limited to 1e9^2, which fits in u64 */
>+			cfs_b->quota *=3D new;
>+			cfs_b->quota =3D div64_u64(cfs_b->quota, old);
>+
>+			pr_warn_ratelimited(
>+	"cfs_period_timer[cpu%d]: period too short, scaling up (new cfs_period_u=
s %lld, cfs_quota_us =3D %lld)\n",
>+				smp_processor_id(),
>+				div_u64(new, NSEC_PER_USEC),
>+				div_u64(cfs_b->quota, NSEC_PER_USEC));
>+
>+			/* reset count so we don't come right back in here */
>+			count =3D 0;
>+		}
>+
> 		idle =3D do_sched_cfs_period_timer(cfs_b, overrun);
> 	}
> 	raw_spin_unlock(&cfs_b->lock);
>@@ -5487,10 +5516,10 @@ static void update_cfs_rq_h_load(struct cfs_rq *cf=
s_rq)
> 	if (cfs_rq->last_h_load_update =3D=3D now)
> 		return;
>=20
>-	cfs_rq->h_load_next =3D NULL;
>+	ACCESS_ONCE(cfs_rq->h_load_next) =3D NULL;
> 	for_each_sched_entity(se) {
> 		cfs_rq =3D cfs_rq_of(se);
>-		cfs_rq->h_load_next =3D se;
>+		ACCESS_ONCE(cfs_rq->h_load_next) =3D se;
> 		if (cfs_rq->last_h_load_update =3D=3D now)
> 			break;
> 	}
>@@ -5500,7 +5529,7 @@ static void update_cfs_rq_h_load(struct cfs_rq *cfs_=
rq)
> 		cfs_rq->last_h_load_update =3D now;
> 	}
>=20
>-	while ((se =3D cfs_rq->h_load_next) !=3D NULL) {
>+	while ((se =3D ACCESS_ONCE(cfs_rq->h_load_next)) !=3D NULL) {
> 		load =3D cfs_rq->h_load;
> 		load =3D div64_ul(load * se->avg.load_avg_contrib,
> 				cfs_rq->runnable_load_avg + 1);
>diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
>index 8ee705e1d472..c59d43d54d32 100644
>--- a/kernel/trace/ftrace.c
>+++ b/kernel/trace/ftrace.c
>@@ -32,6 +32,7 @@
> #include <linux/list.h>
> #include <linux/hash.h>
> #include <linux/rcupdate.h>
>+#include <linux/kprobes.h>
>=20
> #include <trace/events/sched.h>
>=20
>@@ -4508,7 +4509,7 @@ static struct ftrace_ops control_ops =3D {
> 	INIT_OPS_HASH(control_ops)
> };
>=20
>-static inline void
>+static nokprobe_inline void
> __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
> 		       struct ftrace_ops *ignored, struct pt_regs *regs)
> {
>@@ -4561,11 +4562,13 @@ static void ftrace_ops_list_func(unsigned long ip,=
 unsigned long parent_ip,
> {
> 	__ftrace_ops_list_func(ip, parent_ip, NULL, regs);
> }
>+NOKPROBE_SYMBOL(ftrace_ops_list_func);
> #else
> static void ftrace_ops_no_ops(unsigned long ip, unsigned long parent_ip)
> {
> 	__ftrace_ops_list_func(ip, parent_ip, NULL, NULL);
> }
>+NOKPROBE_SYMBOL(ftrace_ops_no_ops);
> #endif
>=20
> static void clear_ftrace_swapper(void)
>diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
>index 107e8ce1a87e..89d99ccb1617 100644
>--- a/kernel/trace/ring_buffer.c
>+++ b/kernel/trace/ring_buffer.c
>@@ -729,7 +729,7 @@ u64 ring_buffer_time_stamp(struct ring_buffer *buffer,=
 int cpu)
>=20
> 	preempt_disable_notrace();
> 	time =3D rb_time_stamp(buffer);
>-	preempt_enable_no_resched_notrace();
>+	preempt_enable_notrace();
>=20
> 	return time;
> }
>diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
>index 7a638aa3545b..3678fc124dc1 100644
>--- a/lib/Kconfig.debug
>+++ b/lib/Kconfig.debug
>@@ -1550,6 +1550,16 @@ config TEST_STRING_HELPERS
> config TEST_KSTRTOX
> 	tristate "Test kstrto*() family of functions at runtime"
>=20
>+config TEST_HASH
>+	tristate "Perform selftest on hash functions"
>+	default n
>+	help
>+	  Enable this option to test the kernel's siphash (<linux/siphash.h>)
>+	  hash functions on boot (or module load).
>+
>+	  This is intended to help people writing architecture-specific
>+	  optimized versions.  If unsure, say N.
>+
> endmenu # runtime tests
>=20
> config PROVIDE_OHCI1394_DMA_INIT
>diff --git a/lib/Makefile b/lib/Makefile
>index ba967a19edba..31a4389ff179 100644
>--- a/lib/Makefile
>+++ b/lib/Makefile
>@@ -26,10 +26,11 @@ obj-y +=3D bcd.o div64.o sort.o parser.o halfmd4.o deb=
ug_locks.o random32.o \
> 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
> 	 gcd.o lcm.o list_sort.o uuid.o flex_array.o iovec.o clz_ctz.o \
> 	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o \
>-	 percpu-refcount.o percpu_ida.o hash.o
>+	 percpu-refcount.o percpu_ida.o hash.o siphash.o
> obj-y +=3D string_helpers.o
> obj-$(CONFIG_TEST_STRING_HELPERS) +=3D test-string_helpers.o
> obj-y +=3D kstrtox.o
>+obj-$(CONFIG_TEST_HASH) +=3D test_siphash.o
> obj-$(CONFIG_TEST_KSTRTOX) +=3D test-kstrtox.o
> obj-$(CONFIG_TEST_MODULE) +=3D test_module.o
> obj-$(CONFIG_TEST_USER_COPY) +=3D test_user_copy.o
>diff --git a/lib/siphash.c b/lib/siphash.c
>new file mode 100644
>index 000000000000..c43cf406e71b
>--- /dev/null
>+++ b/lib/siphash.c
>@@ -0,0 +1,232 @@
>+/* Copyright (C) 2016 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Re=
served.
>+ *
>+ * This file is provided under a dual BSD/GPLv2 license.
>+ *
>+ * SipHash: a fast short-input PRF
>+ * https://131002.net/siphash/
>+ *
>+ * This implementation is specifically for SipHash2-4.
>+ */
>+
>+#include <linux/siphash.h>
>+#include <asm/unaligned.h>
>+
>+#if defined(CONFIG_DCACHE_WORD_ACCESS) && BITS_PER_LONG =3D=3D 64
>+#include <linux/dcache.h>
>+#include <asm/word-at-a-time.h>
>+#endif
>+
>+#define SIPROUND \
>+	do { \
>+	v0 +=3D v1; v1 =3D rol64(v1, 13); v1 ^=3D v0; v0 =3D rol64(v0, 32); \
>+	v2 +=3D v3; v3 =3D rol64(v3, 16); v3 ^=3D v2; \
>+	v0 +=3D v3; v3 =3D rol64(v3, 21); v3 ^=3D v0; \
>+	v2 +=3D v1; v1 =3D rol64(v1, 17); v1 ^=3D v2; v2 =3D rol64(v2, 32); \
>+	} while (0)
>+
>+#define PREAMBLE(len) \
>+	u64 v0 =3D 0x736f6d6570736575ULL; \
>+	u64 v1 =3D 0x646f72616e646f6dULL; \
>+	u64 v2 =3D 0x6c7967656e657261ULL; \
>+	u64 v3 =3D 0x7465646279746573ULL; \
>+	u64 b =3D ((u64)(len)) << 56; \
>+	v3 ^=3D key->key[1]; \
>+	v2 ^=3D key->key[0]; \
>+	v1 ^=3D key->key[1]; \
>+	v0 ^=3D key->key[0];
>+
>+#define POSTAMBLE \
>+	v3 ^=3D b; \
>+	SIPROUND; \
>+	SIPROUND; \
>+	v0 ^=3D b; \
>+	v2 ^=3D 0xff; \
>+	SIPROUND; \
>+	SIPROUND; \
>+	SIPROUND; \
>+	SIPROUND; \
>+	return (v0 ^ v1) ^ (v2 ^ v3);
>+
>+u64 __siphash_aligned(const void *data, size_t len, const siphash_key_t *=
key)
>+{
>+	const u8 *end =3D data + len - (len % sizeof(u64));
>+	const u8 left =3D len & (sizeof(u64) - 1);
>+	u64 m;
>+	PREAMBLE(len)
>+	for (; data !=3D end; data +=3D sizeof(u64)) {
>+		m =3D le64_to_cpup(data);
>+		v3 ^=3D m;
>+		SIPROUND;
>+		SIPROUND;
>+		v0 ^=3D m;
>+	}
>+#if defined(CONFIG_DCACHE_WORD_ACCESS) && BITS_PER_LONG =3D=3D 64
>+	if (left)
>+		b |=3D le64_to_cpu((__force __le64)(load_unaligned_zeropad(data) &
>+						  bytemask_from_count(left)));
>+#else
>+	switch (left) {
>+	case 7: b |=3D ((u64)end[6]) << 48;
>+	case 6: b |=3D ((u64)end[5]) << 40;
>+	case 5: b |=3D ((u64)end[4]) << 32;
>+	case 4: b |=3D le32_to_cpup(data); break;
>+	case 3: b |=3D ((u64)end[2]) << 16;
>+	case 2: b |=3D le16_to_cpup(data); break;
>+	case 1: b |=3D end[0];
>+	}
>+#endif
>+	POSTAMBLE
>+}
>+EXPORT_SYMBOL(__siphash_aligned);
>+
>+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>+u64 __siphash_unaligned(const void *data, size_t len, const siphash_key_t=
 *key)
>+{
>+	const u8 *end =3D data + len - (len % sizeof(u64));
>+	const u8 left =3D len & (sizeof(u64) - 1);
>+	u64 m;
>+	PREAMBLE(len)
>+	for (; data !=3D end; data +=3D sizeof(u64)) {
>+		m =3D get_unaligned_le64(data);
>+		v3 ^=3D m;
>+		SIPROUND;
>+		SIPROUND;
>+		v0 ^=3D m;
>+	}
>+#if defined(CONFIG_DCACHE_WORD_ACCESS) && BITS_PER_LONG =3D=3D 64
>+	if (left)
>+		b |=3D le64_to_cpu((__force __le64)(load_unaligned_zeropad(data) &
>+						  bytemask_from_count(left)));
>+#else
>+	switch (left) {
>+	case 7: b |=3D ((u64)end[6]) << 48;
>+	case 6: b |=3D ((u64)end[5]) << 40;
>+	case 5: b |=3D ((u64)end[4]) << 32;
>+	case 4: b |=3D get_unaligned_le32(end); break;
>+	case 3: b |=3D ((u64)end[2]) << 16;
>+	case 2: b |=3D get_unaligned_le16(end); break;
>+	case 1: b |=3D end[0];
>+	}
>+#endif
>+	POSTAMBLE
>+}
>+EXPORT_SYMBOL(__siphash_unaligned);
>+#endif
>+
>+/**
>+ * siphash_1u64 - compute 64-bit siphash PRF value of a u64
>+ * @first: first u64
>+ * @key: the siphash key
>+ */
>+u64 siphash_1u64(const u64 first, const siphash_key_t *key)
>+{
>+	PREAMBLE(8)
>+	v3 ^=3D first;
>+	SIPROUND;
>+	SIPROUND;
>+	v0 ^=3D first;
>+	POSTAMBLE
>+}
>+EXPORT_SYMBOL(siphash_1u64);
>+
>+/**
>+ * siphash_2u64 - compute 64-bit siphash PRF value of 2 u64
>+ * @first: first u64
>+ * @second: second u64
>+ * @key: the siphash key
>+ */
>+u64 siphash_2u64(const u64 first, const u64 second, const siphash_key_t *=
key)
>+{
>+	PREAMBLE(16)
>+	v3 ^=3D first;
>+	SIPROUND;
>+	SIPROUND;
>+	v0 ^=3D first;
>+	v3 ^=3D second;
>+	SIPROUND;
>+	SIPROUND;
>+	v0 ^=3D second;
>+	POSTAMBLE
>+}
>+EXPORT_SYMBOL(siphash_2u64);
>+
>+/**
>+ * siphash_3u64 - compute 64-bit siphash PRF value of 3 u64
>+ * @first: first u64
>+ * @second: second u64
>+ * @third: third u64
>+ * @key: the siphash key
>+ */
>+u64 siphash_3u64(const u64 first, const u64 second, const u64 third,
>+		 const siphash_key_t *key)
>+{
>+	PREAMBLE(24)
>+	v3 ^=3D first;
>+	SIPROUND;
>+	SIPROUND;
>+	v0 ^=3D first;
>+	v3 ^=3D second;
>+	SIPROUND;
>+	SIPROUND;
>+	v0 ^=3D second;
>+	v3 ^=3D third;
>+	SIPROUND;
>+	SIPROUND;
>+	v0 ^=3D third;
>+	POSTAMBLE
>+}
>+EXPORT_SYMBOL(siphash_3u64);
>+
>+/**
>+ * siphash_4u64 - compute 64-bit siphash PRF value of 4 u64
>+ * @first: first u64
>+ * @second: second u64
>+ * @third: third u64
>+ * @forth: forth u64
>+ * @key: the siphash key
>+ */
>+u64 siphash_4u64(const u64 first, const u64 second, const u64 third,
>+		 const u64 forth, const siphash_key_t *key)
>+{
>+	PREAMBLE(32)
>+	v3 ^=3D first;
>+	SIPROUND;
>+	SIPROUND;
>+	v0 ^=3D first;
>+	v3 ^=3D second;
>+	SIPROUND;
>+	SIPROUND;
>+	v0 ^=3D second;
>+	v3 ^=3D third;
>+	SIPROUND;
>+	SIPROUND;
>+	v0 ^=3D third;
>+	v3 ^=3D forth;
>+	SIPROUND;
>+	SIPROUND;
>+	v0 ^=3D forth;
>+	POSTAMBLE
>+}
>+EXPORT_SYMBOL(siphash_4u64);
>+
>+u64 siphash_1u32(const u32 first, const siphash_key_t *key)
>+{
>+	PREAMBLE(4)
>+	b |=3D first;
>+	POSTAMBLE
>+}
>+EXPORT_SYMBOL(siphash_1u32);
>+
>+u64 siphash_3u32(const u32 first, const u32 second, const u32 third,
>+		 const siphash_key_t *key)
>+{
>+	u64 combined =3D (u64)second << 32 | first;
>+	PREAMBLE(12)
>+	v3 ^=3D combined;
>+	SIPROUND;
>+	SIPROUND;
>+	v0 ^=3D combined;
>+	b |=3D third;
>+	POSTAMBLE
>+}
>+EXPORT_SYMBOL(siphash_3u32);
>diff --git a/lib/string.c b/lib/string.c
>index 80e8bdb60538..94928426f511 100644
>--- a/lib/string.c
>+++ b/lib/string.c
>@@ -776,6 +776,26 @@ __visible int memcmp(const void *cs, const void *ct, =
size_t count)
> EXPORT_SYMBOL(memcmp);
> #endif
>=20
>+#ifndef __HAVE_ARCH_BCMP
>+/**
>+ * bcmp - returns 0 if and only if the buffers have identical contents.
>+ * @a: pointer to first buffer.
>+ * @b: pointer to second buffer.
>+ * @len: size of buffers.
>+ *
>+ * The sign or magnitude of a non-zero return value has no particular
>+ * meaning, and architectures may implement their own more efficient bcmp=
(). So
>+ * while this particular implementation is a simple (tail) call to memcmp=
, do
>+ * not rely on anything but whether the return value is zero or non-zero.
>+ */
>+#undef bcmp
>+int bcmp(const void *a, const void *b, size_t len)
>+{
>+	return memcmp(a, b, len);
>+}
>+EXPORT_SYMBOL(bcmp);
>+#endif
>+
> #ifndef __HAVE_ARCH_MEMSCAN
> /**
>  * memscan - Find a character in an area of memory.
>diff --git a/lib/test_siphash.c b/lib/test_siphash.c
>new file mode 100644
>index 000000000000..d972acfc15e4
>--- /dev/null
>+++ b/lib/test_siphash.c
>@@ -0,0 +1,131 @@
>+/* Test cases for siphash.c
>+ *
>+ * Copyright (C) 2016 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Re=
served.
>+ *
>+ * This file is provided under a dual BSD/GPLv2 license.
>+ *
>+ * SipHash: a fast short-input PRF
>+ * https://131002.net/siphash/
>+ *
>+ * This implementation is specifically for SipHash2-4.
>+ */
>+
>+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>+
>+#include <linux/siphash.h>
>+#include <linux/kernel.h>
>+#include <linux/string.h>
>+#include <linux/errno.h>
>+#include <linux/module.h>
>+
>+/* Test vectors taken from official reference source available at:
>+ *     https://131002.net/siphash/siphash24.c
>+ */
>+
>+static const siphash_key_t test_key_siphash =3D
>+	{{ 0x0706050403020100ULL, 0x0f0e0d0c0b0a0908ULL }};
>+
>+static const u64 test_vectors_siphash[64] =3D {
>+	0x726fdb47dd0e0e31ULL, 0x74f839c593dc67fdULL, 0x0d6c8009d9a94f5aULL,
>+	0x85676696d7fb7e2dULL, 0xcf2794e0277187b7ULL, 0x18765564cd99a68dULL,
>+	0xcbc9466e58fee3ceULL, 0xab0200f58b01d137ULL, 0x93f5f5799a932462ULL,
>+	0x9e0082df0ba9e4b0ULL, 0x7a5dbbc594ddb9f3ULL, 0xf4b32f46226bada7ULL,
>+	0x751e8fbc860ee5fbULL, 0x14ea5627c0843d90ULL, 0xf723ca908e7af2eeULL,
>+	0xa129ca6149be45e5ULL, 0x3f2acc7f57c29bdbULL, 0x699ae9f52cbe4794ULL,
>+	0x4bc1b3f0968dd39cULL, 0xbb6dc91da77961bdULL, 0xbed65cf21aa2ee98ULL,
>+	0xd0f2cbb02e3b67c7ULL, 0x93536795e3a33e88ULL, 0xa80c038ccd5ccec8ULL,
>+	0xb8ad50c6f649af94ULL, 0xbce192de8a85b8eaULL, 0x17d835b85bbb15f3ULL,
>+	0x2f2e6163076bcfadULL, 0xde4daaaca71dc9a5ULL, 0xa6a2506687956571ULL,
>+	0xad87a3535c49ef28ULL, 0x32d892fad841c342ULL, 0x7127512f72f27cceULL,
>+	0xa7f32346f95978e3ULL, 0x12e0b01abb051238ULL, 0x15e034d40fa197aeULL,
>+	0x314dffbe0815a3b4ULL, 0x027990f029623981ULL, 0xcadcd4e59ef40c4dULL,
>+	0x9abfd8766a33735cULL, 0x0e3ea96b5304a7d0ULL, 0xad0c42d6fc585992ULL,
>+	0x187306c89bc215a9ULL, 0xd4a60abcf3792b95ULL, 0xf935451de4f21df2ULL,
>+	0xa9538f0419755787ULL, 0xdb9acddff56ca510ULL, 0xd06c98cd5c0975ebULL,
>+	0xe612a3cb9ecba951ULL, 0xc766e62cfcadaf96ULL, 0xee64435a9752fe72ULL,
>+	0xa192d576b245165aULL, 0x0a8787bf8ecb74b2ULL, 0x81b3e73d20b49b6fULL,
>+	0x7fa8220ba3b2eceaULL, 0x245731c13ca42499ULL, 0xb78dbfaf3a8d83bdULL,
>+	0xea1ad565322a1a0bULL, 0x60e61c23a3795013ULL, 0x6606d7e446282b93ULL,
>+	0x6ca4ecb15c5f91e1ULL, 0x9f626da15c9625f3ULL, 0xe51b38608ef25f57ULL,
>+	0x958a324ceb064572ULL
>+};
>+
>+static int __init siphash_test_init(void)
>+{
>+	u8 in[64] __aligned(SIPHASH_ALIGNMENT);
>+	u8 in_unaligned[65] __aligned(SIPHASH_ALIGNMENT);
>+	u8 i;
>+	int ret =3D 0;
>+
>+	for (i =3D 0; i < 64; ++i) {
>+		in[i] =3D i;
>+		in_unaligned[i + 1] =3D i;
>+		if (siphash(in, i, &test_key_siphash) !=3D
>+						test_vectors_siphash[i]) {
>+			pr_info("siphash self-test aligned %u: FAIL\n", i + 1);
>+			ret =3D -EINVAL;
>+		}
>+		if (siphash(in_unaligned + 1, i, &test_key_siphash) !=3D
>+						test_vectors_siphash[i]) {
>+			pr_info("siphash self-test unaligned %u: FAIL\n", i + 1);
>+			ret =3D -EINVAL;
>+		}
>+	}
>+	if (siphash_1u64(0x0706050403020100ULL, &test_key_siphash) !=3D
>+						test_vectors_siphash[8]) {
>+		pr_info("siphash self-test 1u64: FAIL\n");
>+		ret =3D -EINVAL;
>+	}
>+	if (siphash_2u64(0x0706050403020100ULL, 0x0f0e0d0c0b0a0908ULL,
>+			 &test_key_siphash) !=3D test_vectors_siphash[16]) {
>+		pr_info("siphash self-test 2u64: FAIL\n");
>+		ret =3D -EINVAL;
>+	}
>+	if (siphash_3u64(0x0706050403020100ULL, 0x0f0e0d0c0b0a0908ULL,
>+			 0x1716151413121110ULL, &test_key_siphash) !=3D
>+						test_vectors_siphash[24]) {
>+		pr_info("siphash self-test 3u64: FAIL\n");
>+		ret =3D -EINVAL;
>+	}
>+	if (siphash_4u64(0x0706050403020100ULL, 0x0f0e0d0c0b0a0908ULL,
>+			 0x1716151413121110ULL, 0x1f1e1d1c1b1a1918ULL,
>+			 &test_key_siphash) !=3D test_vectors_siphash[32]) {
>+		pr_info("siphash self-test 4u64: FAIL\n");
>+		ret =3D -EINVAL;
>+	}
>+	if (siphash_1u32(0x03020100U, &test_key_siphash) !=3D
>+						test_vectors_siphash[4]) {
>+		pr_info("siphash self-test 1u32: FAIL\n");
>+		ret =3D -EINVAL;
>+	}
>+	if (siphash_2u32(0x03020100U, 0x07060504U, &test_key_siphash) !=3D
>+						test_vectors_siphash[8]) {
>+		pr_info("siphash self-test 2u32: FAIL\n");
>+		ret =3D -EINVAL;
>+	}
>+	if (siphash_3u32(0x03020100U, 0x07060504U,
>+			 0x0b0a0908U, &test_key_siphash) !=3D
>+						test_vectors_siphash[12]) {
>+		pr_info("siphash self-test 3u32: FAIL\n");
>+		ret =3D -EINVAL;
>+	}
>+	if (siphash_4u32(0x03020100U, 0x07060504U,
>+			 0x0b0a0908U, 0x0f0e0d0cU, &test_key_siphash) !=3D
>+						test_vectors_siphash[16]) {
>+		pr_info("siphash self-test 4u32: FAIL\n");
>+		ret =3D -EINVAL;
>+	}
>+	if (!ret)
>+		pr_info("self-tests: pass\n");
>+	return ret;
>+}
>+
>+static void __exit siphash_test_exit(void)
>+{
>+}
>+
>+module_init(siphash_test_init);
>+module_exit(siphash_test_exit);
>+
>+MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
>+MODULE_LICENSE("Dual BSD/GPL");
>diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>index 7a783dc67305..b491f75f7491 100644
>--- a/mm/page_alloc.c
>+++ b/mm/page_alloc.c
>@@ -3072,6 +3072,49 @@ static inline void show_node(struct zone *zone)
> 		printk("Node %d ", zone_to_nid(zone));
> }
>=20
>+long si_mem_available(void)
>+{
>+	long available;
>+	unsigned long pagecache;
>+	unsigned long wmark_low =3D 0;
>+	unsigned long pages[NR_LRU_LISTS];
>+	struct zone *zone;
>+	int lru;
>+
>+	for (lru =3D LRU_BASE; lru < NR_LRU_LISTS; lru++)
>+		pages[lru] =3D global_page_state(NR_LRU_BASE + lru);
>+
>+	for_each_zone(zone)
>+		wmark_low +=3D zone->watermark[WMARK_LOW];
>+
>+	/*
>+	 * Estimate the amount of memory available for userspace allocations,
>+	 * without causing swapping.
>+	 */
>+	available =3D global_page_state(NR_FREE_PAGES) - totalreserve_pages;
>+
>+	/*
>+	 * Not all the page cache can be freed, otherwise the system will
>+	 * start swapping. Assume at least half of the page cache, or the
>+	 * low watermark worth of cache, needs to stay.
>+	 */
>+	pagecache =3D pages[LRU_ACTIVE_FILE] + pages[LRU_INACTIVE_FILE];
>+	pagecache -=3D min(pagecache / 2, wmark_low);
>+	available +=3D pagecache;
>+
>+	/*
>+	 * Part of the reclaimable slab consists of items that are in use,
>+	 * and cannot be freed. Cap this estimate at the low watermark.
>+	 */
>+	available +=3D global_page_state(NR_SLAB_RECLAIMABLE) -
>+		     min(global_page_state(NR_SLAB_RECLAIMABLE) / 2, wmark_low);
>+
>+	if (available < 0)
>+		available =3D 0;
>+	return available;
>+}
>+EXPORT_SYMBOL_GPL(si_mem_available);
>+
> void si_meminfo(struct sysinfo *val)
> {
> 	val->totalram =3D totalram_pages;
>diff --git a/mm/vmstat.c b/mm/vmstat.c
>index ae3c911843fa..8272a99dce41 100644
>--- a/mm/vmstat.c
>+++ b/mm/vmstat.c
>@@ -861,13 +861,8 @@ const char * const vmstat_text[] =3D {
> 	"thp_zero_page_alloc_failed",
> #endif
> #ifdef CONFIG_DEBUG_TLBFLUSH
>-#ifdef CONFIG_SMP
> 	"nr_tlb_remote_flush",
> 	"nr_tlb_remote_flush_received",
>-#else
>-	"", /* nr_tlb_remote_flush */
>-	"", /* nr_tlb_remote_flush_received */
>-#endif /* CONFIG_SMP */
> 	"nr_tlb_local_flush_all",
> 	"nr_tlb_local_flush_one",
> #endif /* CONFIG_DEBUG_TLBFLUSH */
>diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridg=
e_loop_avoidance.c
>index 335401d6351c..2a1611e65904 100644
>--- a/net/batman-adv/bridge_loop_avoidance.c
>+++ b/net/batman-adv/bridge_loop_avoidance.c
>@@ -677,6 +677,8 @@ static void batadv_bla_del_claim(struct batadv_priv *b=
at_priv,
> 				 const uint8_t *mac, const unsigned short vid)
> {
> 	struct batadv_bla_claim search_claim, *claim;
>+	struct batadv_bla_claim *claim_removed_entry;
>+	struct hlist_node *claim_removed_node;
>=20
> 	ether_addr_copy(search_claim.addr, mac);
> 	search_claim.vid =3D vid;
>@@ -687,10 +689,18 @@ static void batadv_bla_del_claim(struct batadv_priv =
*bat_priv,
> 	batadv_dbg(BATADV_DBG_BLA, bat_priv, "bla_del_claim(): %pM, vid %d\n",
> 		   mac, BATADV_PRINT_VID(vid));
>=20
>-	batadv_hash_remove(bat_priv->bla.claim_hash, batadv_compare_claim,
>-			   batadv_choose_claim, claim);
>-	batadv_claim_free_ref(claim); /* reference from the hash is gone */
>+	claim_removed_node =3D batadv_hash_remove(bat_priv->bla.claim_hash,
>+						batadv_compare_claim,
>+						batadv_choose_claim, claim);
>+	if (!claim_removed_node)
>+		goto free_claim;
>=20
>+	/* reference from the hash is gone */
>+	claim_removed_entry =3D hlist_entry(claim_removed_node,
>+					  struct batadv_bla_claim, hash_entry);
>+	batadv_claim_free_ref(claim_removed_entry);
>+
>+free_claim:
> 	/* don't need the reference from hash_find() anymore */
> 	batadv_claim_free_ref(claim);
> }
>diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translati=
on-table.c
>index c9ac7d948a21..422d54f6a243 100644
>--- a/net/batman-adv/translation-table.c
>+++ b/net/batman-adv/translation-table.c
>@@ -483,14 +483,26 @@ static void batadv_tt_global_free(struct batadv_priv=
 *bat_priv,
> 				  struct batadv_tt_global_entry *tt_global,
> 				  const char *message)
> {
>+	struct batadv_tt_global_entry *tt_removed_entry;
>+	struct hlist_node *tt_removed_node;
>+
> 	batadv_dbg(BATADV_DBG_TT, bat_priv,
> 		   "Deleting global tt entry %pM (vid: %d): %s\n",
> 		   tt_global->common.addr,
> 		   BATADV_PRINT_VID(tt_global->common.vid), message);
>=20
>-	batadv_hash_remove(bat_priv->tt.global_hash, batadv_compare_tt,
>-			   batadv_choose_tt, &tt_global->common);
>-	batadv_tt_global_entry_free_ref(tt_global);
>+	tt_removed_node =3D batadv_hash_remove(bat_priv->tt.global_hash,
>+					     batadv_compare_tt,
>+					     batadv_choose_tt,
>+					     &tt_global->common);
>+	if (!tt_removed_node)
>+		return;
>+
>+	/* drop reference of remove hash entry */
>+	tt_removed_entry =3D hlist_entry(tt_removed_node,
>+				       struct batadv_tt_global_entry,
>+				       common.hash_entry);
>+	batadv_tt_global_entry_free_ref(tt_removed_entry);
> }
>=20
> /**
>@@ -1021,9 +1033,10 @@ uint16_t batadv_tt_local_remove(struct batadv_priv =
*bat_priv,
> 				const uint8_t *addr, unsigned short vid,
> 				const char *message, bool roaming)
> {
>+	struct batadv_tt_local_entry *tt_removed_entry;
> 	struct batadv_tt_local_entry *tt_local_entry;
> 	uint16_t flags, curr_flags =3D BATADV_NO_FLAGS;
>-	void *tt_entry_exists;
>+	struct hlist_node *tt_removed_node;
>=20
> 	tt_local_entry =3D batadv_tt_local_hash_find(bat_priv, addr, vid);
> 	if (!tt_local_entry)
>@@ -1052,15 +1065,18 @@ uint16_t batadv_tt_local_remove(struct batadv_priv=
 *bat_priv,
> 	 */
> 	batadv_tt_local_event(bat_priv, tt_local_entry, BATADV_TT_CLIENT_DEL);
>=20
>-	tt_entry_exists =3D batadv_hash_remove(bat_priv->tt.local_hash,
>+	tt_removed_node =3D batadv_hash_remove(bat_priv->tt.local_hash,
> 					     batadv_compare_tt,
> 					     batadv_choose_tt,
> 					     &tt_local_entry->common);
>-	if (!tt_entry_exists)
>+	if (!tt_removed_node)
> 		goto out;
>=20
>-	/* extra call to free the local tt entry */
>-	batadv_tt_local_entry_free_ref(tt_local_entry);
>+	/* drop reference of remove hash entry */
>+	tt_removed_entry =3D hlist_entry(tt_removed_node,
>+				       struct batadv_tt_local_entry,
>+				       common.hash_entry);
>+	batadv_tt_local_entry_free_ref(tt_removed_entry);
>=20
> out:
> 	if (tt_local_entry)
>diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
>index 3c594185de36..7725dd99fdc6 100644
>--- a/net/bridge/br_multicast.c
>+++ b/net/bridge/br_multicast.c
>@@ -2036,7 +2036,8 @@ static void br_multicast_start_querier(struct net_br=
idge *br,
>=20
> 	__br_multicast_open(br, query);
>=20
>-	list_for_each_entry(port, &br->port_list, list) {
>+	rcu_read_lock();
>+	list_for_each_entry_rcu(port, &br->port_list, list) {
> 		if (port->state =3D=3D BR_STATE_DISABLED ||
> 		    port->state =3D=3D BR_STATE_BLOCKING)
> 			continue;
>@@ -2048,6 +2049,7 @@ static void br_multicast_start_querier(struct net_br=
idge *br,
> 			br_multicast_enable(&port->ip6_own_query);
> #endif
> 	}
>+	rcu_read_unlock();
> }
>=20
> int br_multicast_toggle(struct net_bridge *br, unsigned long val)
>diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
>index 2cf4e30ac41a..7ddb8b322556 100644
>--- a/net/bridge/br_netfilter.c
>+++ b/net/bridge/br_netfilter.c
>@@ -659,6 +659,8 @@ static unsigned int br_nf_pre_routing_ipv6(const struc=
t nf_hook_ops *ops,
> 		return NF_DROP;
>=20
> 	skb->protocol =3D htons(ETH_P_IPV6);
>+	skb->transport_header =3D skb->network_header + sizeof(struct ipv6hdr);
>+
> 	NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING, skb, skb->dev, NULL,
> 		br_nf_pre_routing_finish_ipv6);
>=20
>@@ -715,6 +717,7 @@ static unsigned int br_nf_pre_routing(const struct nf_=
hook_ops *ops,
> 		return NF_DROP;
> 	store_orig_dstaddr(skb);
> 	skb->protocol =3D htons(ETH_P_IP);
>+	skb->transport_header =3D skb->network_header + ip_hdr(skb)->ihl * 4;
>=20
> 	NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING, skb, skb->dev, NULL,
> 		br_nf_pre_routing_finish);
>diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtabl=
es.c
>index 2df71bc7959d..75929f9bd4e6 100644
>--- a/net/bridge/netfilter/ebtables.c
>+++ b/net/bridge/netfilter/ebtables.c
>@@ -2011,7 +2011,8 @@ static int ebt_size_mwt(struct compat_ebt_entry_mwt =
*match32,
> 		if (match_kern)
> 			match_kern->match_size =3D ret;
>=20
>-		if (WARN_ON(type =3D=3D EBT_COMPAT_TARGET && size_left))
>+		/* rule should have no remaining data after target */
>+		if (type =3D=3D EBT_COMPAT_TARGET && size_left)
> 			return -EINVAL;
>=20
> 		match32 =3D (struct compat_ebt_entry_mwt *) buf;
>diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
>index cd332d0fa930..7550d098e3b7 100644
>--- a/net/core/net-sysfs.c
>+++ b/net/core/net-sysfs.c
>@@ -788,6 +788,8 @@ static int rx_queue_add_kobject(struct net_device *net=
, int index)
> 	if (error)
> 		return error;
>=20
>+	dev_hold(queue->dev);
>+
> 	if (net->sysfs_rx_queue_group) {
> 		error =3D sysfs_create_group(kobj, net->sysfs_rx_queue_group);
> 		if (error) {
>@@ -797,7 +799,6 @@ static int rx_queue_add_kobject(struct net_device *net=
, int index)
> 	}
>=20
> 	kobject_uevent(kobj, KOBJ_ADD);
>-	dev_hold(queue->dev);
>=20
> 	return error;
> }
>@@ -1146,6 +1147,8 @@ static int netdev_queue_add_kobject(struct net_devic=
e *net, int index)
> 	if (error)
> 		return error;
>=20
>+	dev_hold(queue->dev);
>+
> #ifdef CONFIG_BQL
> 	error =3D sysfs_create_group(kobj, &dql_group);
> 	if (error) {
>@@ -1155,7 +1158,6 @@ static int netdev_queue_add_kobject(struct net_devic=
e *net, int index)
> #endif
>=20
> 	kobject_uevent(kobj, KOBJ_ADD);
>-	dev_hold(queue->dev);
>=20
> 	return 0;
> }
>diff --git a/net/dccp/feat.c b/net/dccp/feat.c
>index 9733ddbc96cb..fa99d53f29e5 100644
>--- a/net/dccp/feat.c
>+++ b/net/dccp/feat.c
>@@ -738,7 +738,12 @@ static int __feat_register_sp(struct list_head *fn, u=
8 feat, u8 is_local,
> 	if (dccp_feat_clone_sp_val(&fval, sp_val, sp_len))
> 		return -ENOMEM;
>=20
>-	return dccp_feat_push_change(fn, feat, is_local, mandatory, &fval);
>+	if (dccp_feat_push_change(fn, feat, is_local, mandatory, &fval)) {
>+		kfree(fval.sp.vec);
>+		return -ENOMEM;
>+	}
>+
>+	return 0;
> }
>=20
> /**
>diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
>index 30455bf91b18..c3ed865d262f 100644
>--- a/net/dccp/ipv6.c
>+++ b/net/dccp/ipv6.c
>@@ -491,8 +491,8 @@ static struct sock *dccp_v6_request_recv_sock(struct s=
ock *sk,
> 		newnp->ipv6_mc_list =3D NULL;
> 		newnp->ipv6_ac_list =3D NULL;
> 		newnp->ipv6_fl_list =3D NULL;
>-		newnp->mcast_oif   =3D inet6_iif(skb);
>-		newnp->mcast_hops  =3D ipv6_hdr(skb)->hop_limit;
>+		newnp->mcast_oif   =3D inet_iif(skb);
>+		newnp->mcast_hops  =3D ip_hdr(skb)->ttl;
>=20
> 		/*
> 		 * No need to charge this sock to the relevant IPv6 refcnt debug socks =
count
>diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
>index 48444c4c3c51..680ce5f4fb65 100644
>--- a/net/ipv4/igmp.c
>+++ b/net/ipv4/igmp.c
>@@ -395,7 +395,7 @@ static struct sk_buff *igmpv3_newpack(struct net_devic=
e *dev, unsigned int mtu)
>=20
> 	pip->protocol =3D IPPROTO_IGMP;
> 	pip->tot_len  =3D 0;	/* filled in later */
>-	ip_select_ident(skb, NULL);
>+	ip_select_ident(net, skb, NULL);
> 	((u8 *)&pip[1])[0] =3D IPOPT_RA;
> 	((u8 *)&pip[1])[1] =3D 4;
> 	((u8 *)&pip[1])[2] =3D 0;
>@@ -739,7 +739,7 @@ static int igmp_send_report(struct in_device *in_dev, =
struct ip_mc_list *pmc,
> 	iph->daddr    =3D dst;
> 	iph->saddr    =3D fl4.saddr;
> 	iph->protocol =3D IPPROTO_IGMP;
>-	ip_select_ident(skb, NULL);
>+	ip_select_ident(net, skb, NULL);
> 	((u8 *)&iph[1])[0] =3D IPOPT_RA;
> 	((u8 *)&iph[1])[1] =3D 4;
> 	((u8 *)&iph[1])[2] =3D 0;
>diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
>index 109eddf0248a..2a05dfc9a35e 100644
>--- a/net/ipv4/ip_output.c
>+++ b/net/ipv4/ip_output.c
>@@ -150,7 +150,7 @@ int ip_build_and_send_pkt(struct sk_buff *skb, struct =
sock *sk,
> 	iph->daddr    =3D (opt && opt->opt.srr ? opt->opt.faddr : daddr);
> 	iph->saddr    =3D saddr;
> 	iph->protocol =3D sk->sk_protocol;
>-	ip_select_ident(skb, sk);
>+	ip_select_ident(sock_net(sk), skb, sk);
>=20
> 	if (opt && opt->opt.optlen) {
> 		iph->ihl +=3D opt->opt.optlen>>2;
>@@ -432,7 +432,8 @@ int ip_queue_xmit(struct sock *sk, struct sk_buff *skb=
, struct flowi *fl)
> 		ip_options_build(skb, &inet_opt->opt, inet->inet_daddr, rt, 0);
> 	}
>=20
>-	ip_select_ident_segs(skb, sk, skb_shinfo(skb)->gso_segs ?: 1);
>+	ip_select_ident_segs(sock_net(sk), skb, sk,
>+			     skb_shinfo(skb)->gso_segs ?: 1);
>=20
> 	/* TODO : should we use skb->sk here instead of sk ? */
> 	skb->priority =3D sk->sk_priority;
>@@ -1385,7 +1386,7 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
> 	iph->ttl =3D ttl;
> 	iph->protocol =3D sk->sk_protocol;
> 	ip_copy_addrs(iph, fl4);
>-	ip_select_ident(skb, sk);
>+	ip_select_ident(net, skb, sk);
>=20
> 	if (opt) {
> 		iph->ihl +=3D opt->optlen>>2;
>diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
>index 88c386cf7d85..ce63ab21b6cd 100644
>--- a/net/ipv4/ip_tunnel_core.c
>+++ b/net/ipv4/ip_tunnel_core.c
>@@ -74,7 +74,8 @@ int iptunnel_xmit(struct sock *sk, struct rtable *rt, st=
ruct sk_buff *skb,
> 	iph->daddr	=3D	dst;
> 	iph->saddr	=3D	src;
> 	iph->ttl	=3D	ttl;
>-	__ip_select_ident(iph, skb_shinfo(skb)->gso_segs ?: 1);
>+	__ip_select_ident(dev_net(rt->dst.dev), iph,
>+			  skb_shinfo(skb)->gso_segs ?: 1);
>=20
> 	err =3D ip_local_out_sk(sk, skb);
> 	if (unlikely(net_xmit_eval(err)))
>diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
>index 643ec0bb80a5..5859c0f5bd41 100644
>--- a/net/ipv4/ipmr.c
>+++ b/net/ipv4/ipmr.c
>@@ -1647,7 +1647,8 @@ static struct notifier_block ip_mr_notifier =3D {
>  *	important for multicast video.
>  */
>=20
>-static void ip_encap(struct sk_buff *skb, __be32 saddr, __be32 daddr)
>+static void ip_encap(struct net *net, struct sk_buff *skb,
>+		     __be32 saddr, __be32 daddr)
> {
> 	struct iphdr *iph;
> 	const struct iphdr *old_iph =3D ip_hdr(skb);
>@@ -1666,7 +1667,7 @@ static void ip_encap(struct sk_buff *skb, __be32 sad=
dr, __be32 daddr)
> 	iph->protocol	=3D	IPPROTO_IPIP;
> 	iph->ihl	=3D	5;
> 	iph->tot_len	=3D	htons(skb->len);
>-	ip_select_ident(skb, NULL);
>+	ip_select_ident(net, skb, NULL);
> 	ip_send_check(iph);
>=20
> 	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
>@@ -1763,7 +1764,7 @@ static void ipmr_queue_xmit(struct net *net, struct =
mr_table *mrt,
> 	 * What do we do with netfilter? -- RR
> 	 */
> 	if (vif->flags & VIFF_TUNNEL) {
>-		ip_encap(skb, vif->local, vif->remote);
>+		ip_encap(net, skb, vif->local, vif->remote);
> 		/* FIXME: extra output firewall step used to be here. --RR */
> 		vif->dev->stats.tx_packets++;
> 		vif->dev->stats.tx_bytes +=3D skb->len;
>diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
>index e43a585abb35..04700c745ca0 100644
>--- a/net/ipv4/raw.c
>+++ b/net/ipv4/raw.c
>@@ -399,7 +399,7 @@ static int raw_send_hdrinc(struct sock *sk, struct flo=
wi4 *fl4,
> 		iph->check   =3D 0;
> 		iph->tot_len =3D htons(length);
> 		if (!iph->id)
>-			ip_select_ident(skb, NULL);
>+			ip_select_ident(net, skb, NULL);
>=20
> 		iph->check =3D ip_fast_csum((unsigned char *)iph, iph->ihl);
> 	}
>diff --git a/net/ipv4/route.c b/net/ipv4/route.c
>index 660848116761..858596c80e0e 100644
>--- a/net/ipv4/route.c
>+++ b/net/ipv4/route.c
>@@ -484,19 +484,19 @@ u32 ip_idents_reserve(u32 hash, int segs)
> }
> EXPORT_SYMBOL(ip_idents_reserve);
>=20
>-void __ip_select_ident(struct iphdr *iph, int segs)
>+void __ip_select_ident(struct net *net, struct iphdr *iph, int segs)
> {
>-	static u32 ip_idents_hashrnd __read_mostly;
>-	static u32 ip_idents_hashrnd_extra __read_mostly;
> 	u32 hash, id;
>=20
>-	net_get_random_once(&ip_idents_hashrnd, sizeof(ip_idents_hashrnd));
>-	net_get_random_once(&ip_idents_hashrnd_extra, sizeof(ip_idents_hashrnd_e=
xtra));
>+	/* Note the following code is not safe, but this is okay. */
>+	if (unlikely(siphash_key_is_zero(&net->ipv4.ip_id_key)))
>+		get_random_bytes(&net->ipv4.ip_id_key,
>+				 sizeof(net->ipv4.ip_id_key));
>=20
>-	hash =3D jhash_3words((__force u32)iph->daddr,
>+	hash =3D siphash_3u32((__force u32)iph->daddr,
> 			    (__force u32)iph->saddr,
>-			    iph->protocol ^ ip_idents_hashrnd_extra,
>-			    ip_idents_hashrnd);
>+			    iph->protocol,
>+			    &net->ipv4.ip_id_key);
> 	id =3D ip_idents_reserve(hash, segs);
> 	iph->id =3D htons(id);
> }
>diff --git a/net/ipv4/xfrm4_mode_tunnel.c b/net/ipv4/xfrm4_mode_tunnel.c
>index 91771a7c802f..35feda676464 100644
>--- a/net/ipv4/xfrm4_mode_tunnel.c
>+++ b/net/ipv4/xfrm4_mode_tunnel.c
>@@ -63,7 +63,7 @@ static int xfrm4_mode_tunnel_output(struct xfrm_state *x=
, struct sk_buff *skb)
>=20
> 	top_iph->saddr =3D x->props.saddr.a4;
> 	top_iph->daddr =3D x->id.daddr.a4;
>-	ip_select_ident(skb, NULL);
>+	ip_select_ident(dev_net(dst->dev), skb, NULL);
>=20
> 	return 0;
> }
>diff --git a/net/ipv4/xfrm4_policy.c b/net/ipv4/xfrm4_policy.c
>index 3a4c1f93023a..1b99e1406186 100644
>--- a/net/ipv4/xfrm4_policy.c
>+++ b/net/ipv4/xfrm4_policy.c
>@@ -103,7 +103,8 @@ static void
> _decode_session4(struct sk_buff *skb, struct flowi *fl, int reverse)
> {
> 	const struct iphdr *iph =3D ip_hdr(skb);
>-	u8 *xprth =3D skb_network_header(skb) + iph->ihl * 4;
>+	int ihl =3D iph->ihl;
>+	u8 *xprth =3D skb_network_header(skb) + ihl * 4;
> 	struct flowi4 *fl4 =3D &fl->u.ip4;
> 	int oif =3D 0;
>=20
>@@ -114,6 +115,11 @@ _decode_session4(struct sk_buff *skb, struct flowi *f=
l, int reverse)
> 	fl4->flowi4_mark =3D skb->mark;
> 	fl4->flowi4_oif =3D reverse ? skb->skb_iif : oif;
>=20
>+	fl4->flowi4_proto =3D iph->protocol;
>+	fl4->daddr =3D reverse ? iph->saddr : iph->daddr;
>+	fl4->saddr =3D reverse ? iph->daddr : iph->saddr;
>+	fl4->flowi4_tos =3D iph->tos;
>+
> 	if (!ip_is_fragment(iph)) {
> 		switch (iph->protocol) {
> 		case IPPROTO_UDP:
>@@ -123,7 +129,10 @@ _decode_session4(struct sk_buff *skb, struct flowi *f=
l, int reverse)
> 		case IPPROTO_DCCP:
> 			if (xprth + 4 < skb->data ||
> 			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
>-				__be16 *ports =3D (__be16 *)xprth;
>+				__be16 *ports;
>+
>+				xprth =3D skb_network_header(skb) + ihl * 4;
>+				ports =3D (__be16 *)xprth;
>=20
> 				fl4->fl4_sport =3D ports[!!reverse];
> 				fl4->fl4_dport =3D ports[!reverse];
>@@ -131,8 +140,12 @@ _decode_session4(struct sk_buff *skb, struct flowi *f=
l, int reverse)
> 			break;
>=20
> 		case IPPROTO_ICMP:
>-			if (pskb_may_pull(skb, xprth + 2 - skb->data)) {
>-				u8 *icmp =3D xprth;
>+			if (xprth + 2 < skb->data ||
>+			    pskb_may_pull(skb, xprth + 2 - skb->data)) {
>+				u8 *icmp;
>+
>+				xprth =3D skb_network_header(skb) + ihl * 4;
>+				icmp =3D xprth;
>=20
> 				fl4->fl4_icmp_type =3D icmp[0];
> 				fl4->fl4_icmp_code =3D icmp[1];
>@@ -140,33 +153,50 @@ _decode_session4(struct sk_buff *skb, struct flowi *=
fl, int reverse)
> 			break;
>=20
> 		case IPPROTO_ESP:
>-			if (pskb_may_pull(skb, xprth + 4 - skb->data)) {
>-				__be32 *ehdr =3D (__be32 *)xprth;
>+			if (xprth + 4 < skb->data ||
>+			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
>+				__be32 *ehdr;
>+
>+				xprth =3D skb_network_header(skb) + ihl * 4;
>+				ehdr =3D (__be32 *)xprth;
>=20
> 				fl4->fl4_ipsec_spi =3D ehdr[0];
> 			}
> 			break;
>=20
> 		case IPPROTO_AH:
>-			if (pskb_may_pull(skb, xprth + 8 - skb->data)) {
>-				__be32 *ah_hdr =3D (__be32 *)xprth;
>+			if (xprth + 8 < skb->data ||
>+			    pskb_may_pull(skb, xprth + 8 - skb->data)) {
>+				__be32 *ah_hdr;
>+
>+				xprth =3D skb_network_header(skb) + ihl * 4;
>+				ah_hdr =3D (__be32 *)xprth;
>=20
> 				fl4->fl4_ipsec_spi =3D ah_hdr[1];
> 			}
> 			break;
>=20
> 		case IPPROTO_COMP:
>-			if (pskb_may_pull(skb, xprth + 4 - skb->data)) {
>-				__be16 *ipcomp_hdr =3D (__be16 *)xprth;
>+			if (xprth + 4 < skb->data ||
>+			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
>+				__be16 *ipcomp_hdr;
>+
>+				xprth =3D skb_network_header(skb) + ihl * 4;
>+				ipcomp_hdr =3D (__be16 *)xprth;
>=20
> 				fl4->fl4_ipsec_spi =3D htonl(ntohs(ipcomp_hdr[1]));
> 			}
> 			break;
>=20
> 		case IPPROTO_GRE:
>-			if (pskb_may_pull(skb, xprth + 12 - skb->data)) {
>-				__be16 *greflags =3D (__be16 *)xprth;
>-				__be32 *gre_hdr =3D (__be32 *)xprth;
>+			if (xprth + 12 < skb->data ||
>+			    pskb_may_pull(skb, xprth + 12 - skb->data)) {
>+				__be16 *greflags;
>+				__be32 *gre_hdr;
>+
>+				xprth =3D skb_network_header(skb) + ihl * 4;
>+				greflags =3D (__be16 *)xprth;
>+				gre_hdr =3D (__be32 *)xprth;
>=20
> 				if (greflags[0] & GRE_KEY) {
> 					if (greflags[0] & GRE_CSUM)
>@@ -181,10 +211,6 @@ _decode_session4(struct sk_buff *skb, struct flowi *f=
l, int reverse)
> 			break;
> 		}
> 	}
>-	fl4->flowi4_proto =3D iph->protocol;
>-	fl4->daddr =3D reverse ? iph->saddr : iph->daddr;
>-	fl4->saddr =3D reverse ? iph->daddr : iph->saddr;
>-	fl4->flowi4_tos =3D iph->tos;
> }
>=20
> static inline int xfrm4_garbage_collect(struct dst_ops *ops)
>diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
>index f40ba684d69b..d8e8008aa7a4 100644
>--- a/net/ipv6/ip6_flowlabel.c
>+++ b/net/ipv6/ip6_flowlabel.c
>@@ -94,16 +94,22 @@ static struct ip6_flowlabel *fl_lookup(struct net *net=
, __be32 label)
> 	return fl;
> }
>=20
>+static void fl_free_rcu(struct rcu_head *head)
>+{
>+	struct ip6_flowlabel *fl =3D container_of(head, struct ip6_flowlabel, rc=
u);
>+
>+	if (fl->share =3D=3D IPV6_FL_S_PROCESS)
>+		put_pid(fl->owner.pid);
>+	release_net(fl->fl_net);
>+	kfree(fl->opt);
>+	kfree(fl);
>+}
>+
>=20
> static void fl_free(struct ip6_flowlabel *fl)
> {
>-	if (fl) {
>-		if (fl->share =3D=3D IPV6_FL_S_PROCESS)
>-			put_pid(fl->owner.pid);
>-		release_net(fl->fl_net);
>-		kfree(fl->opt);
>-		kfree_rcu(fl, rcu);
>-	}
>+	if (fl)
>+		call_rcu(&fl->rcu, fl_free_rcu);
> }
>=20
> static void fl_release(struct ip6_flowlabel *fl)
>@@ -630,9 +636,9 @@ int ipv6_flowlabel_opt(struct sock *sk, char __user *o=
ptval, int optlen)
> 				if (fl1->share =3D=3D IPV6_FL_S_EXCL ||
> 				    fl1->share !=3D fl->share ||
> 				    ((fl1->share =3D=3D IPV6_FL_S_PROCESS) &&
>-				     (fl1->owner.pid =3D=3D fl->owner.pid)) ||
>+				     (fl1->owner.pid !=3D fl->owner.pid)) ||
> 				    ((fl1->share =3D=3D IPV6_FL_S_USER) &&
>-				     uid_eq(fl1->owner.uid, fl->owner.uid)))
>+				     !uid_eq(fl1->owner.uid, fl->owner.uid)))
> 					goto release;
>=20
> 				err =3D -ENOMEM;
>diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
>index bb98cde51476..1e68db035daf 100644
>--- a/net/ipv6/ip6_output.c
>+++ b/net/ipv6/ip6_output.c
>@@ -538,23 +538,6 @@ static void ip6_copy_metadata(struct sk_buff *to, str=
uct sk_buff *from)
> 	skb_copy_secmark(to, from);
> }
>=20
>-static void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
>-{
>-	static u32 ip6_idents_hashrnd __read_mostly;
>-	static u32 ip6_idents_hashrnd_extra __read_mostly;
>-	u32 hash, id;
>-
>-	net_get_random_once(&ip6_idents_hashrnd, sizeof(ip6_idents_hashrnd));
>-	net_get_random_once(&ip6_idents_hashrnd_extra, sizeof(ip6_idents_hashrnd=
_extra));
>-
>-	hash =3D __ipv6_addr_jhash(&rt->rt6i_dst.addr, ip6_idents_hashrnd);
>-	hash =3D __ipv6_addr_jhash(&rt->rt6i_src.addr, hash);
>-	hash =3D jhash_1word(hash, ip6_idents_hashrnd_extra);
>-
>-	id =3D ip_idents_reserve(hash, 1);
>-	fhdr->identification =3D htonl(id);
>-}
>-
> int ip6_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
> {
> 	struct sk_buff *frag;
>@@ -649,7 +632,7 @@ int ip6_fragment(struct sk_buff *skb, int (*output)(st=
ruct sk_buff *))
> 		skb_reset_network_header(skb);
> 		memcpy(skb_network_header(skb), tmp_hdr, hlen);
>=20
>-		ipv6_select_ident(fh, rt);
>+		ipv6_select_ident(net, fh, rt);
> 		fh->nexthdr =3D nexthdr;
> 		fh->reserved =3D 0;
> 		fh->frag_off =3D htons(IP6_MF);
>@@ -802,7 +785,7 @@ int ip6_fragment(struct sk_buff *skb, int (*output)(st=
ruct sk_buff *))
> 		fh->nexthdr =3D nexthdr;
> 		fh->reserved =3D 0;
> 		if (!frag_id) {
>-			ipv6_select_ident(fh, rt);
>+			ipv6_select_ident(net, fh, rt);
> 			frag_id =3D fh->identification;
> 		} else
> 			fh->identification =3D frag_id;
>@@ -1096,7 +1079,7 @@ static inline int ip6_ufo_append_data(struct sock *s=
k,
> 	skb_shinfo(skb)->gso_size =3D (mtu - fragheaderlen -
> 				     sizeof(struct frag_hdr)) & ~7;
> 	skb_shinfo(skb)->gso_type =3D SKB_GSO_UDP;
>-	ipv6_select_ident(&fhdr, rt);
>+	ipv6_select_ident(sock_net(sk), &fhdr, rt);
> 	skb_shinfo(skb)->ip6_frag_id =3D fhdr.identification;
>=20
> append:
>diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
>index 42978998534c..5733b05558a5 100644
>--- a/net/ipv6/ip6mr.c
>+++ b/net/ipv6/ip6mr.c
>@@ -1662,6 +1662,10 @@ int ip6_mroute_setsockopt(struct sock *sk, int optn=
ame, char __user *optval, uns
> 	struct net *net =3D sock_net(sk);
> 	struct mr6_table *mrt;
>=20
>+	if (sk->sk_type !=3D SOCK_RAW ||
>+	    inet_sk(sk)->inet_num !=3D IPPROTO_ICMPV6)
>+		return -EOPNOTSUPP;
>+
> 	mrt =3D ip6mr_get_table(net, raw6_sk(sk)->ip6mr_table ? : RT6_TABLE_DFLT=
);
> 	if (mrt =3D=3D NULL)
> 		return -ENOENT;
>@@ -1673,9 +1677,6 @@ int ip6_mroute_setsockopt(struct sock *sk, int optna=
me, char __user *optval, uns
>=20
> 	switch (optname) {
> 	case MRT6_INIT:
>-		if (sk->sk_type !=3D SOCK_RAW ||
>-		    inet_sk(sk)->inet_num !=3D IPPROTO_ICMPV6)
>-			return -EOPNOTSUPP;
> 		if (optlen < sizeof(int))
> 			return -EINVAL;
>=20
>@@ -1812,6 +1813,10 @@ int ip6_mroute_getsockopt(struct sock *sk, int optn=
ame, char __user *optval,
> 	struct net *net =3D sock_net(sk);
> 	struct mr6_table *mrt;
>=20
>+	if (sk->sk_type !=3D SOCK_RAW ||
>+	    inet_sk(sk)->inet_num !=3D IPPROTO_ICMPV6)
>+		return -EOPNOTSUPP;
>+
> 	mrt =3D ip6mr_get_table(net, raw6_sk(sk)->ip6mr_table ? : RT6_TABLE_DFLT=
);
> 	if (mrt =3D=3D NULL)
> 		return -ENOENT;
>diff --git a/net/ipv6/output_core.c b/net/ipv6/output_core.c
>index e32c1ff35f78..a8274abad231 100644
>--- a/net/ipv6/output_core.c
>+++ b/net/ipv6/output_core.c
>@@ -9,6 +9,36 @@
> #include <net/addrconf.h>
> #include <net/secure_seq.h>
>=20
>+static u32 __ipv6_select_ident(struct net *net,
>+			       struct in6_addr *dst, struct in6_addr *src)
>+{
>+	const struct {
>+		struct in6_addr dst;
>+		struct in6_addr src;
>+	} __aligned(SIPHASH_ALIGNMENT) combined =3D {
>+		.dst =3D *dst,
>+		.src =3D *src,
>+	};
>+	u32 hash, id;
>+
>+	/* Note the following code is not safe, but this is okay. */
>+	if (unlikely(siphash_key_is_zero(&net->ipv4.ip_id_key)))
>+		get_random_bytes(&net->ipv4.ip_id_key,
>+				 sizeof(net->ipv4.ip_id_key));
>+
>+	hash =3D siphash(&combined, sizeof(combined), &net->ipv4.ip_id_key);
>+
>+	/* Treat id of 0 as unset and if we get 0 back from ip_idents_reserve,
>+	 * set the hight order instead thus minimizing possible future
>+	 * collisions.
>+	 */
>+	id =3D ip_idents_reserve(hash, 1);
>+	if (unlikely(!id))
>+		id =3D 1 << 31;
>+
>+	return id;
>+}
>+
> /* This function exists only for tap drivers that must support broken
>  * clients requesting UFO without specifying an IPv6 fragment ID.
>  *
>@@ -17,12 +47,11 @@
>  *
>  * The network header must be set before calling this.
>  */
>-void ipv6_proxy_select_ident(struct sk_buff *skb)
>+void ipv6_proxy_select_ident(struct net *net, struct sk_buff *skb)
> {
>-	static u32 ip6_proxy_idents_hashrnd __read_mostly;
> 	struct in6_addr buf[2];
> 	struct in6_addr *addrs;
>-	u32 hash, id;
>+	u32 id;
>=20
> 	addrs =3D skb_header_pointer(skb,
> 				   skb_network_offset(skb) +
>@@ -31,17 +60,21 @@ void ipv6_proxy_select_ident(struct sk_buff *skb)
> 	if (!addrs)
> 		return;
>=20
>-	net_get_random_once(&ip6_proxy_idents_hashrnd,
>-			    sizeof(ip6_proxy_idents_hashrnd));
>-
>-	hash =3D __ipv6_addr_jhash(&addrs[1], ip6_proxy_idents_hashrnd);
>-	hash =3D __ipv6_addr_jhash(&addrs[0], hash);
>-
>-	id =3D ip_idents_reserve(hash, 1);
>+	id =3D __ipv6_select_ident(net, &addrs[1], &addrs[0]);
> 	skb_shinfo(skb)->ip6_frag_id =3D htonl(id);
> }
> EXPORT_SYMBOL_GPL(ipv6_proxy_select_ident);
>=20
>+void ipv6_select_ident(struct net *net, struct frag_hdr *fhdr,
>+		       struct rt6_info *rt)
>+{
>+	u32 id;
>+
>+	id =3D __ipv6_select_ident(net, &rt->rt6i_dst.addr, &rt->rt6i_src.addr);
>+	fhdr->identification =3D htonl(id);
>+}
>+EXPORT_SYMBOL(ipv6_select_ident);
>+
> int ip6_find_1stfragopt(struct sk_buff *skb, u8 **nexthdr)
> {
> 	unsigned int offset =3D sizeof(struct ipv6hdr);
>diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
>index 70a0f92cbbc0..4370371e0aa6 100644
>--- a/net/ipv6/tcp_ipv6.c
>+++ b/net/ipv6/tcp_ipv6.c
>@@ -1183,11 +1183,11 @@ static struct sock *tcp_v6_syn_recv_sock(struct so=
ck *sk, struct sk_buff *skb,
> 		newnp->ipv6_fl_list =3D NULL;
> 		newnp->pktoptions  =3D NULL;
> 		newnp->opt	   =3D NULL;
>-		newnp->mcast_oif   =3D inet6_iif(skb);
>-		newnp->mcast_hops  =3D ipv6_hdr(skb)->hop_limit;
>-		newnp->rcv_flowinfo =3D ip6_flowinfo(ipv6_hdr(skb));
>+		newnp->mcast_oif   =3D inet_iif(skb);
>+		newnp->mcast_hops  =3D ip_hdr(skb)->ttl;
>+		newnp->rcv_flowinfo =3D 0;
> 		if (np->repflow)
>-			newnp->flow_label =3D ip6_flowlabel(ipv6_hdr(skb));
>+			newnp->flow_label =3D 0;
>=20
> 		/*
> 		 * No need to charge this sock to the relevant IPv6 refcnt debug socks =
count
>diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
>index fa9ea1a72f99..28d02353743f 100644
>--- a/net/ipv6/udp_offload.c
>+++ b/net/ipv6/udp_offload.c
>@@ -75,6 +75,10 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff=
 *skb,
>=20
> 		skb_shinfo(skb)->gso_segs =3D DIV_ROUND_UP(skb->len, mss);
>=20
>+		/* Set the IPv6 fragment id if not set yet */
>+		if (!skb_shinfo(skb)->ip6_frag_id)
>+			ipv6_proxy_select_ident(dev_net(skb->dev), skb);
>+
> 		segs =3D NULL;
> 		goto out;
> 	}
>@@ -120,6 +124,8 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buf=
f *skb,
> 		fptr =3D (struct frag_hdr *)(skb_network_header(skb) + unfrag_ip6hlen);
> 		fptr->nexthdr =3D nexthdr;
> 		fptr->reserved =3D 0;
>+		if (!skb_shinfo(skb)->ip6_frag_id)
>+			ipv6_proxy_select_ident(dev_net(skb->dev), skb);
> 		fptr->identification =3D skb_shinfo(skb)->ip6_frag_id;
>=20
> 		/* Fragment the skb. ipv6 header and the remaining fields of the
>diff --git a/net/ipv6/xfrm6_tunnel.c b/net/ipv6/xfrm6_tunnel.c
>index 1c66465a42dd..f1491b0004cd 100644
>--- a/net/ipv6/xfrm6_tunnel.c
>+++ b/net/ipv6/xfrm6_tunnel.c
>@@ -390,6 +390,10 @@ static void __exit xfrm6_tunnel_fini(void)
> 	xfrm6_tunnel_deregister(&xfrm6_tunnel_handler, AF_INET6);
> 	xfrm_unregister_type(&xfrm6_tunnel_type, AF_INET6);
> 	unregister_pernet_subsys(&xfrm6_tunnel_net_ops);
>+	/* Someone maybe has gotten the xfrm6_tunnel_spi.
>+	 * So need to wait it.
>+	 */
>+	rcu_barrier();
> 	kmem_cache_destroy(xfrm6_tunnel_spi_kmem);
> }
>=20
>diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
>index 661252aeb7e0..c8b5c8c355b4 100644
>--- a/net/l2tp/l2tp_core.c
>+++ b/net/l2tp/l2tp_core.c
>@@ -217,8 +217,8 @@ struct l2tp_tunnel *l2tp_tunnel_get(const struct net *=
net, u32 tunnel_id)
>=20
> 	rcu_read_lock_bh();
> 	list_for_each_entry_rcu(tunnel, &pn->l2tp_tunnel_list, list) {
>-		if (tunnel->tunnel_id =3D=3D tunnel_id) {
>-			l2tp_tunnel_inc_refcount(tunnel);
>+		if (tunnel->tunnel_id =3D=3D tunnel_id &&
>+		    atomic_inc_not_zero(&tunnel->ref_count)) {
> 			rcu_read_unlock_bh();
>=20
> 			return tunnel;
>@@ -238,8 +238,8 @@ struct l2tp_tunnel *l2tp_tunnel_get_nth(const struct n=
et *net, int nth)
>=20
> 	rcu_read_lock_bh();
> 	list_for_each_entry_rcu(tunnel, &pn->l2tp_tunnel_list, list) {
>-		if (++count > nth) {
>-			l2tp_tunnel_inc_refcount(tunnel);
>+		if (++count > nth &&
>+		    atomic_inc_not_zero(&tunnel->ref_count)) {
> 			rcu_read_unlock_bh();
> 			return tunnel;
> 		}
>@@ -997,7 +997,7 @@ int l2tp_udp_encap_recv(struct sock *sk, struct sk_buf=
f *skb)
> {
> 	struct l2tp_tunnel *tunnel;
>=20
>-	tunnel =3D l2tp_tunnel(sk);
>+	tunnel =3D rcu_dereference_sk_user_data(sk);
> 	if (tunnel =3D=3D NULL)
> 		goto pass_up;
>=20
>diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
>index 1ab5e1a51c98..607d8fdd5e68 100644
>--- a/net/mac80211/debugfs_netdev.c
>+++ b/net/mac80211/debugfs_netdev.c
>@@ -735,7 +735,7 @@ void ieee80211_debugfs_rename_netdev(struct ieee80211_=
sub_if_data *sdata)
>=20
> 	dir =3D sdata->vif.debugfs_dir;
>=20
>-	if (!dir)
>+	if (IS_ERR_OR_NULL(dir))
> 		return;
>=20
> 	sprintf(buf, "netdev:%s", sdata->name);
>diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xm=
it.c
>index 7abd786d9d89..44fa945ed6b4 100644
>--- a/net/netfilter/ipvs/ip_vs_xmit.c
>+++ b/net/netfilter/ipvs/ip_vs_xmit.c
>@@ -813,7 +813,8 @@ int
> ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
> 		  struct ip_vs_protocol *pp, struct ip_vs_iphdr *ipvsh)
> {
>-	struct netns_ipvs *ipvs =3D net_ipvs(skb_net(skb));
>+	struct net *net =3D skb_net(skb);
>+	struct netns_ipvs *ipvs =3D net_ipvs(net);
> 	struct rtable *rt;			/* Route to the other host */
> 	__be32 saddr;				/* Source for tunnel */
> 	struct net_device *tdev;		/* Device to other host */
>@@ -882,7 +883,7 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_co=
nn *cp,
> 	iph->daddr		=3D	cp->daddr.ip;
> 	iph->saddr		=3D	saddr;
> 	iph->ttl		=3D	old_iph->ttl;
>-	ip_select_ident(skb, NULL);
>+	ip_select_ident(net, skb, NULL);
>=20
> 	/* Another hack: avoid icmp_send in ip_fragment */
> 	skb->ignore_df =3D 1;
>diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrac=
k_core.c
>index cdd47388723b..170681b21d25 100644
>--- a/net/netfilter/nf_conntrack_core.c
>+++ b/net/netfilter/nf_conntrack_core.c
>@@ -23,6 +23,7 @@
> #include <linux/slab.h>
> #include <linux/random.h>
> #include <linux/jhash.h>
>+#include <linux/siphash.h>
> #include <linux/err.h>
> #include <linux/percpu.h>
> #include <linux/moduleparam.h>
>@@ -52,6 +53,7 @@
> #include <net/netfilter/nf_nat.h>
> #include <net/netfilter/nf_nat_core.h>
> #include <net/netfilter/nf_nat_helper.h>
>+#include <net/netns/hash.h>
>=20
> #define NF_CONNTRACK_VERSION	"0.5.0"
>=20
>@@ -232,6 +234,40 @@ nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
> }
> EXPORT_SYMBOL_GPL(nf_ct_invert_tuple);
>=20
>+/* Generate a almost-unique pseudo-id for a given conntrack.
>+ *
>+ * intentionally doesn't re-use any of the seeds used for hash
>+ * table location, we assume id gets exposed to userspace.
>+ *
>+ * Following nf_conn items do not change throughout lifetime
>+ * of the nf_conn after it has been committed to main hash table:
>+ *
>+ * 1. nf_conn address
>+ * 2. nf_conn->ext address
>+ * 3. nf_conn->master address (normally NULL)
>+ * 4. tuple
>+ * 5. the associated net namespace
>+ */
>+u32 nf_ct_get_id(const struct nf_conn *ct)
>+{
>+	static __read_mostly siphash_key_t ct_id_seed;
>+	unsigned long a, b, c, d;
>+
>+	net_get_random_once(&ct_id_seed, sizeof(ct_id_seed));
>+
>+	a =3D (unsigned long)ct;
>+	b =3D (unsigned long)ct->master ^ net_hash_mix(nf_ct_net(ct));
>+	c =3D (unsigned long)ct->ext;
>+	d =3D (unsigned long)siphash(&ct->tuplehash, sizeof(ct->tuplehash),
>+				   &ct_id_seed);
>+#ifdef CONFIG_64BIT
>+	return siphash_4u64((u64)a, (u64)b, (u64)c, (u64)d, &ct_id_seed);
>+#else
>+	return siphash_4u32((u32)a, (u32)b, (u32)c, (u32)d, &ct_id_seed);
>+#endif
>+}
>+EXPORT_SYMBOL_GPL(nf_ct_get_id);
>+
> static void
> clean_from_lists(struct nf_conn *ct)
> {
>diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_connt=
rack_netlink.c
>index faa736bae869..b9bf8b0f4ec1 100644
>--- a/net/netfilter/nf_conntrack_netlink.c
>+++ b/net/netfilter/nf_conntrack_netlink.c
>@@ -29,6 +29,7 @@
> #include <linux/spinlock.h>
> #include <linux/interrupt.h>
> #include <linux/slab.h>
>+#include <linux/siphash.h>
>=20
> #include <linux/netfilter.h>
> #include <net/netlink.h>
>@@ -435,7 +436,9 @@ ctnetlink_dump_ct_seq_adj(struct sk_buff *skb, const s=
truct nf_conn *ct)
> static inline int
> ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
> {
>-	if (nla_put_be32(skb, CTA_ID, htonl((unsigned long)ct)))
>+	__be32 id =3D (__force __be32)nf_ct_get_id(ct);
>+
>+	if (nla_put_be32(skb, CTA_ID, id))
> 		goto nla_put_failure;
> 	return 0;
>=20
>@@ -1047,8 +1050,9 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk=
_buff *skb,
> 	ct =3D nf_ct_tuplehash_to_ctrack(h);
>=20
> 	if (cda[CTA_ID]) {
>-		u_int32_t id =3D ntohl(nla_get_be32(cda[CTA_ID]));
>-		if (id !=3D (u32)(unsigned long)ct) {
>+		__be32 id =3D nla_get_be32(cda[CTA_ID]);
>+
>+		if (id !=3D (__force __be32)nf_ct_get_id(ct)) {
> 			nf_ct_put(ct);
> 			return -ENOENT;
> 		}
>@@ -2321,6 +2325,25 @@ ctnetlink_exp_dump_mask(struct sk_buff *skb,
>=20
> static const union nf_inet_addr any_addr;
>=20
>+static __be32 nf_expect_get_id(const struct nf_conntrack_expect *exp)
>+{
>+	static __read_mostly siphash_key_t exp_id_seed;
>+	unsigned long a, b, c, d;
>+
>+	net_get_random_once(&exp_id_seed, sizeof(exp_id_seed));
>+
>+	a =3D (unsigned long)exp;
>+	b =3D (unsigned long)exp->helper;
>+	c =3D (unsigned long)exp->master;
>+	d =3D (unsigned long)siphash(&exp->tuple, sizeof(exp->tuple), &exp_id_se=
ed);
>+
>+#ifdef CONFIG_64BIT
>+	return (__force __be32)siphash_4u64((u64)a, (u64)b, (u64)c, (u64)d, &exp=
_id_seed);
>+#else
>+	return (__force __be32)siphash_4u32((u32)a, (u32)b, (u32)c, (u32)d, &exp=
_id_seed);
>+#endif
>+}
>+
> static int
> ctnetlink_exp_dump_expect(struct sk_buff *skb,
> 			  const struct nf_conntrack_expect *exp)
>@@ -2368,7 +2391,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
> 	}
> #endif
> 	if (nla_put_be32(skb, CTA_EXPECT_TIMEOUT, htonl(timeout)) ||
>-	    nla_put_be32(skb, CTA_EXPECT_ID, htonl((unsigned long)exp)) ||
>+	    nla_put_be32(skb, CTA_EXPECT_ID, nf_expect_get_id(exp)) ||
> 	    nla_put_be32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags)) ||
> 	    nla_put_be32(skb, CTA_EXPECT_CLASS, htonl(exp->class)))
> 		goto nla_put_failure;
>@@ -2664,7 +2687,8 @@ ctnetlink_get_expect(struct sock *ctnl, struct sk_bu=
ff *skb,
>=20
> 	if (cda[CTA_EXPECT_ID]) {
> 		__be32 id =3D nla_get_be32(cda[CTA_EXPECT_ID]);
>-		if (ntohl(id) !=3D (u32)(unsigned long)exp) {
>+
>+		if (id !=3D nf_expect_get_id(exp)) {
> 			nf_ct_expect_put(exp);
> 			return -ENOENT;
> 		}
>diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
>index 20a844788443..0777d98d3dec 100644
>--- a/net/packet/af_packet.c
>+++ b/net/packet/af_packet.c
>@@ -2278,8 +2278,8 @@ static int tpacket_snd(struct packet_sock *po, struc=
t msghdr *msg)
> 	void *ph;
> 	DECLARE_SOCKADDR(struct sockaddr_ll *, saddr, msg->msg_name);
> 	bool need_wait =3D !(msg->msg_flags & MSG_DONTWAIT);
>+	unsigned char *addr =3D NULL;
> 	int tp_len, size_max;
>-	unsigned char *addr;
> 	int len_sum =3D 0;
> 	int status =3D TP_STATUS_AVAILABLE;
> 	int hlen, tlen;
>@@ -2289,7 +2289,6 @@ static int tpacket_snd(struct packet_sock *po, struc=
t msghdr *msg)
> 	if (likely(saddr =3D=3D NULL)) {
> 		dev	=3D packet_cached_dev_get(po);
> 		proto	=3D po->num;
>-		addr	=3D NULL;
> 	} else {
> 		err =3D -EINVAL;
> 		if (msg->msg_namelen < sizeof(struct sockaddr_ll))
>@@ -2299,10 +2298,13 @@ static int tpacket_snd(struct packet_sock *po, str=
uct msghdr *msg)
> 						sll_addr)))
> 			goto out;
> 		proto	=3D saddr->sll_protocol;
>-		addr	=3D saddr->sll_halen ? saddr->sll_addr : NULL;
> 		dev =3D dev_get_by_index(sock_net(&po->sk), saddr->sll_ifindex);
>-		if (addr && dev && saddr->sll_halen < dev->addr_len)
>-			goto out_put;
>+		if (po->sk.sk_socket->type =3D=3D SOCK_DGRAM) {
>+			if (dev && msg->msg_namelen < dev->addr_len +
>+				   offsetof(struct sockaddr_ll, sll_addr))
>+				goto out_put;
>+			addr =3D saddr->sll_addr;
>+		}
> 	}
>=20
> 	err =3D -ENXIO;
>@@ -2435,7 +2437,7 @@ static int packet_snd(struct socket *sock, struct ms=
ghdr *msg, size_t len)
> 	struct sk_buff *skb;
> 	struct net_device *dev;
> 	__be16 proto;
>-	unsigned char *addr;
>+	unsigned char *addr =3D NULL;
> 	int err, reserve =3D 0;
> 	struct virtio_net_hdr vnet_hdr =3D { 0 };
> 	int offset =3D 0;
>@@ -2453,7 +2455,6 @@ static int packet_snd(struct socket *sock, struct ms=
ghdr *msg, size_t len)
> 	if (likely(saddr =3D=3D NULL)) {
> 		dev	=3D packet_cached_dev_get(po);
> 		proto	=3D po->num;
>-		addr	=3D NULL;
> 	} else {
> 		err =3D -EINVAL;
> 		if (msg->msg_namelen < sizeof(struct sockaddr_ll))
>@@ -2461,10 +2462,13 @@ static int packet_snd(struct socket *sock, struct =
msghdr *msg, size_t len)
> 		if (msg->msg_namelen < (saddr->sll_halen + offsetof(struct sockaddr_ll,=
 sll_addr)))
> 			goto out;
> 		proto	=3D saddr->sll_protocol;
>-		addr	=3D saddr->sll_halen ? saddr->sll_addr : NULL;
> 		dev =3D dev_get_by_index(sock_net(sk), saddr->sll_ifindex);
>-		if (addr && dev && saddr->sll_halen < dev->addr_len)
>-			goto out_unlock;
>+		if (sock->type =3D=3D SOCK_DGRAM) {
>+			if (dev && msg->msg_namelen < dev->addr_len +
>+				   offsetof(struct sockaddr_ll, sll_addr))
>+				goto out_unlock;
>+			addr =3D saddr->sll_addr;
>+		}
> 	}
>=20
> 	err =3D -ENXIO;
>@@ -3027,19 +3031,28 @@ static int packet_recvmsg(struct kiocb *iocb, stru=
ct socket *sock,
> 	sock_recv_ts_and_drops(msg, sk, skb);
>=20
> 	if (msg->msg_name) {
>+		int copy_len;
>+
> 		/* If the address length field is there to be filled
> 		 * in, we fill it in now.
> 		 */
> 		if (sock->type =3D=3D SOCK_PACKET) {
> 			__sockaddr_check_size(sizeof(struct sockaddr_pkt));
> 			msg->msg_namelen =3D sizeof(struct sockaddr_pkt);
>+			copy_len =3D msg->msg_namelen;
> 		} else {
> 			struct sockaddr_ll *sll =3D &PACKET_SKB_CB(skb)->sa.ll;
> 			msg->msg_namelen =3D sll->sll_halen +
> 				offsetof(struct sockaddr_ll, sll_addr);
>+			copy_len =3D msg->msg_namelen;
>+			if (msg->msg_namelen < sizeof(struct sockaddr_ll)) {
>+				memset(msg->msg_name +
>+				       offsetof(struct sockaddr_ll, sll_addr),
>+				       0, sizeof(sll->sll_addr));
>+				msg->msg_namelen =3D sizeof(struct sockaddr_ll);
>+			}
> 		}
>-		memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa,
>-		       msg->msg_namelen);
>+		memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa, copy_len);
> 	}
>=20
> 	if (pkt_sk(sk)->auxdata) {
>diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
>index 344456206b70..d5199b25b821 100644
>--- a/net/rose/rose_loopback.c
>+++ b/net/rose/rose_loopback.c
>@@ -16,15 +16,19 @@
> #include <linux/init.h>
>=20
> static struct sk_buff_head loopback_queue;
>+#define ROSE_LOOPBACK_LIMIT 1000
> static struct timer_list loopback_timer;
>=20
> static void rose_set_loopback_timer(void);
>+static void rose_loopback_timer(unsigned long);
>=20
> void rose_loopback_init(void)
> {
> 	skb_queue_head_init(&loopback_queue);
>=20
> 	init_timer(&loopback_timer);
>+	loopback_timer.data     =3D 0;
>+	loopback_timer.function =3D &rose_loopback_timer;
> }
>=20
> static int rose_loopback_running(void)
>@@ -34,33 +38,27 @@ static int rose_loopback_running(void)
>=20
> int rose_loopback_queue(struct sk_buff *skb, struct rose_neigh *neigh)
> {
>-	struct sk_buff *skbn;
>-
>-	skbn =3D skb_clone(skb, GFP_ATOMIC);
>+	struct sk_buff *skbn =3D NULL;
>=20
>-	kfree_skb(skb);
>+	if (skb_queue_len(&loopback_queue) < ROSE_LOOPBACK_LIMIT)
>+		skbn =3D skb_clone(skb, GFP_ATOMIC);
>=20
>-	if (skbn !=3D NULL) {
>+	if (skbn) {
>+		consume_skb(skb);
> 		skb_queue_tail(&loopback_queue, skbn);
>=20
> 		if (!rose_loopback_running())
> 			rose_set_loopback_timer();
>+	} else {
>+		kfree_skb(skb);
> 	}
>=20
> 	return 1;
> }
>=20
>-static void rose_loopback_timer(unsigned long);
>-
> static void rose_set_loopback_timer(void)
> {
>-	del_timer(&loopback_timer);
>-
>-	loopback_timer.data     =3D 0;
>-	loopback_timer.function =3D &rose_loopback_timer;
>-	loopback_timer.expires  =3D jiffies + 10;
>-
>-	add_timer(&loopback_timer);
>+	mod_timer(&loopback_timer, jiffies + 10);
> }
>=20
> static void rose_loopback_timer(unsigned long param)
>@@ -71,8 +69,12 @@ static void rose_loopback_timer(unsigned long param)
> 	struct sock *sk;
> 	unsigned short frametype;
> 	unsigned int lci_i, lci_o;
>+	int count;
>=20
>-	while ((skb =3D skb_dequeue(&loopback_queue)) !=3D NULL) {
>+	for (count =3D 0; count < ROSE_LOOPBACK_LIMIT; count++) {
>+		skb =3D skb_dequeue(&loopback_queue);
>+		if (!skb)
>+			return;
> 		if (skb->len < ROSE_MIN_LEN) {
> 			kfree_skb(skb);
> 			continue;
>@@ -109,6 +111,8 @@ static void rose_loopback_timer(unsigned long param)
> 			kfree_skb(skb);
> 		}
> 	}
>+	if (!skb_queue_empty(&loopback_queue))
>+		mod_timer(&loopback_timer, jiffies + 1);
> }
>=20
> void __exit rose_loopback_clear(void)
>diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
>index cdfa7f4c0a59..4a5598a42cd6 100644
>--- a/net/sunrpc/cache.c
>+++ b/net/sunrpc/cache.c
>@@ -50,6 +50,7 @@ static void cache_init(struct cache_head *h)
> 	h->last_refresh =3D now;
> }
>=20
>+static inline int cache_is_valid(struct cache_head *h);
> static void cache_fresh_locked(struct cache_head *head, time_t expiry);
> static void cache_fresh_unlocked(struct cache_head *head,
> 				struct cache_detail *detail);
>@@ -98,6 +99,8 @@ struct cache_head *sunrpc_cache_lookup(struct cache_deta=
il *detail,
> 				*hp =3D tmp->next;
> 				tmp->next =3D NULL;
> 				detail->entries --;
>+				if (cache_is_valid(tmp) =3D=3D -EAGAIN)
>+					set_bit(CACHE_NEGATIVE, &tmp->flags);
> 				cache_fresh_locked(tmp, 0);
> 				freeme =3D tmp;
> 				break;
>diff --git a/net/tipc/sysctl.c b/net/tipc/sysctl.c
>index f3fef93325a8..a4125b069833 100644
>--- a/net/tipc/sysctl.c
>+++ b/net/tipc/sysctl.c
>@@ -37,6 +37,7 @@
>=20
> #include <linux/sysctl.h>
>=20
>+static int one =3D 1;
> static struct ctl_table_header *tipc_ctl_hdr;
>=20
> static struct ctl_table tipc_table[] =3D {
>@@ -45,7 +46,8 @@ static struct ctl_table tipc_table[] =3D {
> 		.data		=3D &sysctl_tipc_rmem,
> 		.maxlen		=3D sizeof(sysctl_tipc_rmem),
> 		.mode		=3D 0644,
>-		.proc_handler	=3D proc_dointvec,
>+		.proc_handler	=3D proc_dointvec_minmax,
>+		.extra1         =3D &one,
> 	},
> 	{}
> };
>diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
>index 62fbbdc58566..b0f84a040f32 100644
>--- a/net/xfrm/xfrm_user.c
>+++ b/net/xfrm/xfrm_user.c
>@@ -1255,7 +1255,7 @@ static int verify_newpolicy_info(struct xfrm_userpol=
icy_info *p)
> 	ret =3D verify_policy_dir(p->dir);
> 	if (ret)
> 		return ret;
>-	if (p->index && ((p->index & XFRM_POLICY_MAX) !=3D p->dir))
>+	if (p->index && (xfrm_policy_id2dir(p->index) !=3D p->dir))
> 		return -EINVAL;
>=20
> 	return 0;
>diff --git a/security/device_cgroup.c b/security/device_cgroup.c
>index d9d69e6930ed..8fee5f7be4f1 100644
>--- a/security/device_cgroup.c
>+++ b/security/device_cgroup.c
>@@ -568,7 +568,7 @@ static int propagate_exception(struct dev_cgroup *devc=
g_root,
> 		    devcg->behavior =3D=3D DEVCG_DEFAULT_ALLOW) {
> 			rc =3D dev_exception_add(devcg, ex);
> 			if (rc)
>-				break;
>+				return rc;
> 		} else {
> 			/*
> 			 * in the other possible cases:
>diff --git a/sound/core/init.c b/sound/core/init.c
>index 7bdfd19e24a8..e0d04b91d561 100644
>--- a/sound/core/init.c
>+++ b/sound/core/init.c
>@@ -389,14 +389,7 @@ int snd_card_disconnect(struct snd_card *card)
> 	card->shutdown =3D 1;
> 	spin_unlock(&card->files_lock);
>=20
>-	/* phase 1: disable fops (user space) operations for ALSA API */
>-	mutex_lock(&snd_card_mutex);
>-	snd_cards[card->number] =3D NULL;
>-	clear_bit(card->number, snd_cards_lock);
>-	mutex_unlock(&snd_card_mutex);
>-=09
>-	/* phase 2: replace file->f_op with special dummy operations */
>-=09
>+	/* replace file->f_op with special dummy operations */
> 	spin_lock(&card->files_lock);
> 	list_for_each_entry(mfile, &card->files_list, list) {
> 		/* it's critical part, use endless loop */
>@@ -412,7 +405,7 @@ int snd_card_disconnect(struct snd_card *card)
> 	}
> 	spin_unlock(&card->files_lock);=09
>=20
>-	/* phase 3: notify all connected devices about disconnection */
>+	/* notify all connected devices about disconnection */
> 	/* at this point, they cannot respond to any calls except release() */
>=20
> #if IS_ENABLED(CONFIG_SND_MIXER_OSS)
>@@ -430,6 +423,13 @@ int snd_card_disconnect(struct snd_card *card)
> 		device_del(&card->card_dev);
> 		card->registered =3D false;
> 	}
>+
>+	/* disable fops (user space) operations for ALSA API */
>+	mutex_lock(&snd_card_mutex);
>+	snd_cards[card->number] =3D NULL;
>+	clear_bit(card->number, snd_cards_lock);
>+	mutex_unlock(&snd_card_mutex);
>+
> #ifdef CONFIG_PM
> 	wake_up(&card->power_sleep);
> #endif
>diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
>index 41bae2baea71..f853b62befa1 100644
>--- a/sound/core/oss/pcm_oss.c
>+++ b/sound/core/oss/pcm_oss.c
>@@ -951,6 +951,28 @@ static int snd_pcm_oss_change_params_locked(struct sn=
d_pcm_substream *substream)
> 	oss_frame_size =3D snd_pcm_format_physical_width(params_format(params)) *
> 			 params_channels(params) / 8;
>=20
>+	err =3D snd_pcm_oss_period_size(substream, params, sparams);
>+	if (err < 0)
>+		goto failure;
>+
>+	n =3D snd_pcm_plug_slave_size(substream, runtime->oss.period_bytes / oss=
_frame_size);
>+	err =3D snd_pcm_hw_param_near(substream, sparams, SNDRV_PCM_HW_PARAM_PER=
IOD_SIZE, n, NULL);
>+	if (err < 0)
>+		goto failure;
>+
>+	err =3D snd_pcm_hw_param_near(substream, sparams, SNDRV_PCM_HW_PARAM_PER=
IODS,
>+				     runtime->oss.periods, NULL);
>+	if (err < 0)
>+		goto failure;
>+
>+	snd_pcm_kernel_ioctl(substream, SNDRV_PCM_IOCTL_DROP, NULL);
>+
>+	err =3D snd_pcm_kernel_ioctl(substream, SNDRV_PCM_IOCTL_HW_PARAMS, spara=
ms);
>+	if (err < 0) {
>+		pcm_dbg(substream->pcm, "HW_PARAMS failed: %i\n", err);
>+		goto failure;
>+	}
>+
> #ifdef CONFIG_SND_PCM_OSS_PLUGINS
> 	snd_pcm_oss_plugin_clear(substream);
> 	if (!direct) {
>@@ -985,27 +1007,6 @@ static int snd_pcm_oss_change_params_locked(struct s=
nd_pcm_substream *substream)
> 	}
> #endif
>=20
>-	err =3D snd_pcm_oss_period_size(substream, params, sparams);
>-	if (err < 0)
>-		goto failure;
>-
>-	n =3D snd_pcm_plug_slave_size(substream, runtime->oss.period_bytes / oss=
_frame_size);
>-	err =3D snd_pcm_hw_param_near(substream, sparams, SNDRV_PCM_HW_PARAM_PER=
IOD_SIZE, n, NULL);
>-	if (err < 0)
>-		goto failure;
>-
>-	err =3D snd_pcm_hw_param_near(substream, sparams, SNDRV_PCM_HW_PARAM_PER=
IODS,
>-				     runtime->oss.periods, NULL);
>-	if (err < 0)
>-		goto failure;
>-
>-	snd_pcm_kernel_ioctl(substream, SNDRV_PCM_IOCTL_DROP, NULL);
>-
>-	if ((err =3D snd_pcm_kernel_ioctl(substream, SNDRV_PCM_IOCTL_HW_PARAMS, =
sparams)) < 0) {
>-		pcm_dbg(substream->pcm, "HW_PARAMS failed: %i\n", err);
>-		goto failure;
>-	}
>-
> 	memset(sw_params, 0, sizeof(*sw_params));
> 	if (runtime->oss.trigger) {
> 		sw_params->start_threshold =3D 1;
>diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
>index 7c407ab2d82a..a0ee065a9f8c 100644
>--- a/sound/core/pcm_native.c
>+++ b/sound/core/pcm_native.c
>@@ -1063,8 +1063,15 @@ static int snd_pcm_pause(struct snd_pcm_substream *=
substream, int push)
> static int snd_pcm_pre_suspend(struct snd_pcm_substream *substream, int s=
tate)
> {
> 	struct snd_pcm_runtime *runtime =3D substream->runtime;
>-	if (runtime->status->state =3D=3D SNDRV_PCM_STATE_SUSPENDED)
>+	switch (runtime->status->state) {
>+	case SNDRV_PCM_STATE_SUSPENDED:
> 		return -EBUSY;
>+	/* unresumable PCM state; return -EBUSY for skipping suspend */
>+	case SNDRV_PCM_STATE_OPEN:
>+	case SNDRV_PCM_STATE_SETUP:
>+	case SNDRV_PCM_STATE_DISCONNECTED:
>+		return -EBUSY;
>+	}
> 	runtime->trigger_master =3D substream;
> 	return 0;
> }
>diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
>index 2bd5b8524181..09e05c0b59a1 100644
>--- a/sound/core/rawmidi.c
>+++ b/sound/core/rawmidi.c
>@@ -29,6 +29,7 @@
> #include <linux/mutex.h>
> #include <linux/module.h>
> #include <linux/delay.h>
>+#include <linux/nospec.h>
> #include <sound/rawmidi.h>
> #include <sound/info.h>
> #include <sound/control.h>
>@@ -601,6 +602,7 @@ static int __snd_rawmidi_info_select(struct snd_card *=
card,
> 		return -ENXIO;
> 	if (info->stream < 0 || info->stream > 1)
> 		return -EINVAL;
>+	info->stream =3D array_index_nospec(info->stream, 2);
> 	pstr =3D &rmidi->streams[info->stream];
> 	if (pstr->substream_count =3D=3D 0)
> 		return -ENOENT;
>diff --git a/sound/core/seq/oss/seq_oss_synth.c b/sound/core/seq/oss/seq_o=
ss_synth.c
>index 8bf5335d953b..6ab2de7695d8 100644
>--- a/sound/core/seq/oss/seq_oss_synth.c
>+++ b/sound/core/seq/oss/seq_oss_synth.c
>@@ -617,13 +617,14 @@ int
> snd_seq_oss_synth_make_info(struct seq_oss_devinfo *dp, int dev, struct s=
ynth_info *inf)
> {
> 	struct seq_oss_synth *rec;
>+	struct seq_oss_synthinfo *info =3D get_synthinfo_nospec(dp, dev);
>=20
>-	if (dev < 0 || dev >=3D dp->max_synthdev)
>+	if (!info)
> 		return -ENXIO;
>=20
>-	if (dp->synths[dev].is_midi) {
>+	if (info->is_midi) {
> 		struct midi_info minf;
>-		snd_seq_oss_midi_make_info(dp, dp->synths[dev].midi_mapped, &minf);
>+		snd_seq_oss_midi_make_info(dp, info->midi_mapped, &minf);
> 		inf->synth_type =3D SYNTH_TYPE_MIDI;
> 		inf->synth_subtype =3D 0;
> 		inf->nr_voices =3D 16;
>diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr=
=2Ec
>index 60fb2c708d75..f6396e012a0f 100644
>--- a/sound/core/seq/seq_clientmgr.c
>+++ b/sound/core/seq/seq_clientmgr.c
>@@ -1249,7 +1249,7 @@ static int snd_seq_ioctl_set_client_info(struct snd_=
seq_client *client,
>=20
> 	/* fill the info fields */
> 	if (client_info.name[0])
>-		strlcpy(client->name, client_info.name, sizeof(client->name));
>+		strscpy(client->name, client_info.name, sizeof(client->name));
>=20
> 	client->filter =3D client_info.filter;
> 	client->event_lost =3D client_info.event_lost;
>@@ -1564,7 +1564,7 @@ static int snd_seq_ioctl_create_queue(struct snd_seq=
_client *client,
> 	/* set queue name */
> 	if (! info.name[0])
> 		snprintf(info.name, sizeof(info.name), "Queue-%d", q->queue);
>-	strlcpy(q->name, info.name, sizeof(q->name));
>+	strscpy(q->name, info.name, sizeof(q->name));
> 	queuefree(q);
>=20
> 	if (copy_to_user(arg, &info, sizeof(info)))
>@@ -1642,7 +1642,7 @@ static int snd_seq_ioctl_set_queue_info(struct snd_s=
eq_client *client,
> 		queuefree(q);
> 		return -EPERM;
> 	}
>-	strlcpy(q->name, info.name, sizeof(q->name));
>+	strscpy(q->name, info.name, sizeof(q->name));
> 	queuefree(q);
>=20
> 	return 0;
>diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/eve=
nt-parse.c
>index 95b2df232d71..383aaaebad6c 100644
>--- a/tools/lib/traceevent/event-parse.c
>+++ b/tools/lib/traceevent/event-parse.c
>@@ -2065,7 +2065,7 @@ eval_type_str(unsigned long long val, const char *ty=
pe, int pointer)
> 		return val & 0xffffffff;
>=20
> 	if (strcmp(type, "u64") =3D=3D 0 ||
>-	    strcmp(type, "s64"))
>+	    strcmp(type, "s64") =3D=3D 0)
> 		return val;
>=20
> 	if (strcmp(type, "s8") =3D=3D 0)
>diff --git a/tools/perf/tests/evsel-tp-sched.c b/tools/perf/tests/evsel-tp=
-sched.c
>index c81bd9a31db7..fd3a453a21cf 100644
>--- a/tools/perf/tests/evsel-tp-sched.c
>+++ b/tools/perf/tests/evsel-tp-sched.c
>@@ -77,5 +77,6 @@ int test__perf_evsel__tp_sched_test(void)
> 	if (perf_evsel__test_field(evsel, "target_cpu", 4, true))
> 		ret =3D -1;
>=20
>+	perf_evsel__delete(evsel);
> 	return ret;
> }
>diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>index ad0c85a63c80..cc0b4c5f5c72 100644
>--- a/virt/kvm/kvm_main.c
>+++ b/virt/kvm/kvm_main.c
>@@ -2240,6 +2240,9 @@ static long kvm_device_ioctl(struct file *filp, unsi=
gned int ioctl,
> {
> 	struct kvm_device *dev =3D filp->private_data;
>=20
>+	if (dev->kvm->mm !=3D current->mm)
>+		return -EIO;
>+
> 	switch (ioctl) {
> 	case KVM_SET_DEVICE_ATTR:
> 		return kvm_device_ioctl_attr(dev, dev->ops->set_attr, arg);
>=0D



--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl1SzgQACgkQsjqdtxFL
KRUsvQf8CMnbD1jUdZ10gF4rJCffjVXDj2yhVMGGEVG3r0EQ/7d2Qd+RuMIL8mpq
OB9pySE/q8yr3p6Sb8NIZE2KPYtSmPO1ocqo/utbCffgWffa0KFCb7c3KVwaM00r
xnytCwAvetD0oCHLedgdvrl1FwizfiajRwCKLJqIqpKJzzAxVkOLM814puMi0y/S
7H8F5xO2tSBHc18kmTdR+8H4AvaVHYpbDa+BfvWb4fwPaYAT9WW1/qvccxgjZa+i
Q302MFNN5NKOdVx2zgXhhGQS0uV9QCFUpbe6s0eV8N7dGMfe+fc0SVK7ZYsshdtE
avR1/yMsal31Q5WHmSzHzaaX83zfqw==
=/ee5
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
