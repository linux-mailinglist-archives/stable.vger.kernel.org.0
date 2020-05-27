Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCCA91E47A9
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 17:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729647AbgE0Pgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 11:36:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726782AbgE0Pgg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 11:36:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11808212CC;
        Wed, 27 May 2020 15:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590593795;
        bh=cecSALLvBvJ1FggwUep/fAFTiMxMgusJVUf4MRrCPbA=;
        h=Subject:To:Cc:From:Date:From;
        b=bmXJ1LHFvbrTllI/hYe+PeWAm0gF5Fnsv4tedxfXok/xNqTdpsDmvuiDbpy4SeWJU
         SMpTf8h92hKjQCmEyucYFQlC5dXwrZgGKOpgq4B0WBRjai9hAXgPxolwyWAB51+inf
         TOjDj6IJhMdAnjVCinKYOT6Jk+GSF4axLQuG2K2c=
Subject: Linux 4.9.225
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Wed, 27 May 2020 17:36:28 +0200
Message-ID: <15905937881675@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.225 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/networking/l2tp.txt                   |    8 
 Makefile                                            |    2 
 arch/arm/include/asm/futex.h                        |    9 
 arch/arm64/kernel/machine_kexec.c                   |    3 
 drivers/base/component.c                            |    8 
 drivers/dma/tegra210-adma.c                         |    2 
 drivers/hid/hid-ids.h                               |    1 
 drivers/hid/hid-multitouch.c                        |    3 
 drivers/i2c/i2c-dev.c                               |   48 +--
 drivers/i2c/muxes/i2c-demux-pinctrl.c               |    1 
 drivers/iio/dac/vf610_dac.c                         |    1 
 drivers/iommu/amd_iommu_init.c                      |    9 
 drivers/misc/mei/client.c                           |    2 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c     |   13 
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c |    6 
 drivers/net/ethernet/intel/igb/igb_main.c           |    4 
 drivers/net/gtp.c                                   |    9 
 drivers/nvdimm/btt.c                                |    8 
 drivers/platform/x86/alienware-wmi.c                |   17 -
 drivers/platform/x86/asus-nb-wmi.c                  |   24 +
 drivers/rapidio/devices/rio_mport_cdev.c            |    5 
 drivers/staging/greybus/uart.c                      |    4 
 drivers/staging/iio/accel/sca3000_ring.c            |    2 
 drivers/staging/iio/resolver/ad2s1210.c             |   17 -
 drivers/usb/core/message.c                          |    4 
 drivers/watchdog/watchdog_dev.c                     |   67 +---
 fs/ceph/caps.c                                      |    1 
 fs/configfs/dir.c                                   |    1 
 fs/file.c                                           |    2 
 fs/gfs2/glock.c                                     |    3 
 include/linux/net.h                                 |    3 
 include/linux/padata.h                              |   13 
 include/uapi/linux/if_pppol2tp.h                    |   13 
 include/uapi/linux/l2tp.h                           |   17 +
 kernel/padata.c                                     |   88 ++---
 lib/Makefile                                        |    2 
 net/l2tp/l2tp_core.c                                |  174 +++--------
 net/l2tp/l2tp_core.h                                |   46 +-
 net/l2tp/l2tp_eth.c                                 |  216 ++++++++-----
 net/l2tp/l2tp_netlink.c                             |   79 ++---
 net/l2tp/l2tp_ppp.c                                 |  309 +++++++++++---------
 net/socket.c                                        |   46 ++
 scripts/gcc-plugins/Makefile                        |    1 
 scripts/gcc-plugins/gcc-common.h                    |    4 
 security/integrity/evm/evm_crypto.c                 |    2 
 security/integrity/ima/ima_fs.c                     |    3 
 sound/core/pcm_lib.c                                |    1 
 47 files changed, 733 insertions(+), 568 deletions(-)

Al Viro (1):
      fix multiplication overflow in copy_fdtable()

Alan Stern (1):
      USB: core: Fix misleading driver bug report

Alexander Monakov (1):
      iommu/amd: Fix over-read of ACPI UID from IVRS table

Alexander Usyskin (1):
      mei: release me_cl object reference

Arjun Vynipadath (2):
      cxgb4: free mac_hlist properly
      cxgb4/cxgb4vf: Fix mac_hlist initialization and free

Arnd Bergmann (1):
      ubsan: build ubsan.c more conservatively

Asbjørn Sloth Tønnesen (3):
      net: l2tp: export debug flags to UAPI
      net: l2tp: deprecate PPPOL2TP_MSG_* in favour of L2TP_MSG_*
      net: l2tp: ppp: change PPPOL2TP_MSG_* => L2TP_MSG_*

Bob Peterson (1):
      Revert "gfs2: Don't demote a glock until its revokes are written"

Brent Lu (1):
      ALSA: pcm: fix incorrect hw_base increase

Cao jin (1):
      igb: use igb_adapter->io_addr instead of e1000_hw->hw_addr

Christoph Hellwig (1):
      arm64: fix the flush_icache_range arguments in machine_kexec

Christophe JAILLET (4):
      i2c: mux: demux-pinctrl: Fix an error handling path in 'i2c_demux_pinctrl_probe()'
      dmaengine: tegra210-adma: Fix an error handling path in 'tegra_adma_probe()'
      iio: dac: vf610: Fix an error handling path in 'vf610_dac_probe()'
      iio: sca3000: Remove an erroneous 'get_device()'

Colin Ian King (1):
      platform/x86: alienware-wmi: fix kfree on potentially uninitialized pointer

Daniel Jordan (2):
      padata: initialize pd->cpu with effective cpumask
      padata: purge get_cpu and reorder_via_wq from padata_do_serial

Dragos Bogdan (1):
      staging: iio: ad2s1210: Fix SPI reading

Frédéric Pierret (fepitre) (1):
      gcc-common.h: Update for GCC 10

Greg Kroah-Hartman (1):
      Linux 4.9.225

Guillaume Nault (17):
      l2tp: remove useless duplicate session detection in l2tp_netlink
      l2tp: remove l2tp_session_find()
      l2tp: define parameters of l2tp_session_get*() as "const"
      l2tp: define parameters of l2tp_tunnel_find*() as "const"
      l2tp: initialise session's refcount before making it reachable
      l2tp: hold tunnel while looking up sessions in l2tp_netlink
      l2tp: hold tunnel while processing genl delete command
      l2tp: hold tunnel while handling genl tunnel updates
      l2tp: hold tunnel while handling genl TUNNEL_GET commands
      l2tp: hold tunnel used while creating sessions with netlink
      l2tp: prevent creation of sessions on terminated tunnels
      l2tp: pass tunnel pointer to ->session_create()
      l2tp: fix l2tp_eth module loading
      l2tp: don't register sessions in l2tp_session_create()
      l2tp: initialise l2tp_eth sessions before registering them
      l2tp: protect sock pointer of struct pppol2tp_session with RCU
      l2tp: initialise PPP sessions before registering them

Hans de Goede (1):
      platform/x86: asus-nb-wmi: Do not load on Asus T100TA and T200TA

Herbert Xu (1):
      padata: Replace delayed timer with immediate workqueue in padata_reorder

James Hilliard (1):
      component: Silence bind error on -EPROBE_DEFER

Jason A. Donenfeld (1):
      padata: get_next is never NULL

John Hubbard (1):
      rapidio: fix an error in get_user_pages_fast() error handling

Kevin Hao (2):
      i2c: dev: Fix the race between the release of i2c_dev and cdev
      watchdog: Fix the race between the release of watchdog_core_data and cdev

Mathias Krause (3):
      padata: ensure the reorder timer callback runs on the correct CPU
      padata: ensure padata_do_serial() runs on the correct CPU
      padata: set cpu_index of unused CPUs to -1

Oscar Carter (1):
      staging: greybus: Fix uninitialized scalar variable

Peter Zijlstra (1):
      x86/uaccess, ubsan: Fix UBSAN vs. SMAP

R. Parameswaran (3):
      New kernel function to get IP overhead on a socket.
      L2TP:Adjust intf MTU, add underlay L3, L2 hdrs.
      l2tp: device MTU setup, tunnel socket needs a lock

Roberto Sassu (2):
      evm: Check also if *tfm is an error pointer in init_desc()
      ima: Fix return value of ima_write_policy()

Sebastian Reichel (1):
      HID: multitouch: add eGalaxTouch P80H84 support

Thomas Gleixner (1):
      ARM: futex: Address build warning

Tobias Klauser (1):
      padata: Remove unused but set variables

Vishal Verma (1):
      libnvdimm/btt: Remove unnecessary code in btt_freelist_init

Wu Bo (1):
      ceph: fix double unlock in handle_cap_export()

Xiyu Yang (1):
      configfs: fix config_item refcnt leak in configfs_rmdir()

Yoshiyuki Kurauchi (1):
      gtp: set NLM_F_MULTI flag in gtp_genl_dump_pdp()

