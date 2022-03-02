Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825954CA27F
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 11:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241134AbiCBKxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 05:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241165AbiCBKxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 05:53:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA6043ADD;
        Wed,  2 Mar 2022 02:52:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8242DB81F8A;
        Wed,  2 Mar 2022 10:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032F9C340F1;
        Wed,  2 Mar 2022 10:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646218367;
        bh=tKx1cS6+881ibmPgnjDVNdu4FTt8Pc4RQkJfnvvnon4=;
        h=From:To:Cc:Subject:Date:From;
        b=IMO1+2BAXpO2SVLsS8Gbj+/U7rzEFEMTbAXSOBmxolj9SKMpcJ8NIXRABjFY2tRhy
         u/rSlFakEsFWxY3h1oGzIBtRCfvW5Su9uewKIuywoex6ojcZriHvIFUPSlbmothu0L
         Na9pmLBC8jp7yWz2PP88ykuAjURnFkFI+YZIAnT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.182
Date:   Wed,  2 Mar 2022 11:52:42 +0100
Message-Id: <164621836372167@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.182 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                   |    2 
 arch/parisc/kernel/unaligned.c                             |   14 +-
 arch/x86/include/asm/fpu/internal.h                        |   13 +-
 arch/x86/kernel/process_32.c                               |    6 -
 arch/x86/kernel/process_64.c                               |    6 -
 drivers/ata/pata_hpt37x.c                                  |   14 ++
 drivers/clk/ingenic/jz4725b-cgu.c                          |    3 
 drivers/gpio/gpio-tegra186.c                               |   14 +-
 drivers/gpu/drm/amd/amdgpu/soc15.c                         |    5 
 drivers/gpu/drm/drm_edid.c                                 |    2 
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c             |   37 ++----
 drivers/iio/accel/bmc150-accel-core.c                      |    5 
 drivers/iio/accel/kxcjk-1013.c                             |    5 
 drivers/iio/accel/mma9551.c                                |    5 
 drivers/iio/accel/mma9553.c                                |    5 
 drivers/iio/adc/ad7124.c                                   |    2 
 drivers/iio/adc/men_z188_adc.c                             |    9 +
 drivers/iio/gyro/bmg160_core.c                             |    5 
 drivers/iio/imu/kmx61.c                                    |    5 
 drivers/iio/magnetometer/bmc150_magn.c                     |    5 
 drivers/infiniband/ulp/srp/ib_srp.c                        |    6 -
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c       |    2 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |    4 
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c          |    2 
 drivers/net/ethernet/microchip/lan743x_main.c              |   12 --
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c    |    4 
 drivers/net/ethernet/xilinx/ll_temac_main.c                |    2 
 drivers/net/usb/cdc_ether.c                                |   12 ++
 drivers/net/usb/sr9700.c                                   |    2 
 drivers/net/usb/zaurus.c                                   |   12 ++
 drivers/spi/spi-zynq-qspi.c                                |    3 
 drivers/tee/optee/core.c                                   |    8 +
 drivers/tee/optee/optee_private.h                          |    2 
 drivers/tee/optee/rpc.c                                    |    8 -
 drivers/tee/tee_core.c                                     |    6 -
 drivers/tty/n_gsm.c                                        |   11 +
 drivers/usb/dwc3/dwc3-pci.c                                |    4 
 drivers/usb/dwc3/gadget.c                                  |    2 
 drivers/usb/gadget/function/rndis.c                        |    8 +
 drivers/usb/gadget/function/rndis.h                        |    1 
 drivers/usb/gadget/udc/udc-xilinx.c                        |    6 +
 drivers/usb/host/xhci.c                                    |   28 +++-
 drivers/usb/serial/ch341.c                                 |    1 
 drivers/usb/serial/option.c                                |   12 ++
 drivers/vhost/vsock.c                                      |   21 ++-
 fs/configfs/dir.c                                          |   14 ++
 fs/file.c                                                  |   73 ++++++++++---
 fs/tracefs/inode.c                                         |    5 
 include/linux/tee_drv.h                                    |   14 ++
 include/net/checksum.h                                     |   46 ++++----
 include/net/netfilter/nf_tables.h                          |    2 
 include/net/netfilter/nf_tables_offload.h                  |    2 
 kernel/cgroup/cpuset.c                                     |    2 
 kernel/trace/trace_events_trigger.c                        |   52 ++++++++-
 mm/memblock.c                                              |   10 +
 net/core/filter.c                                          |    3 
 net/core/skbuff.c                                          |    4 
 net/ipv4/af_inet.c                                         |    5 
 net/ipv4/ping.c                                            |    1 
 net/ipv6/ip6_offload.c                                     |    2 
 net/netfilter/nf_tables_api.c                              |   13 +-
 net/netfilter/nf_tables_offload.c                          |    3 
 net/netfilter/nft_dup_netdev.c                             |    6 +
 net/netfilter/nft_fwd_netdev.c                             |    6 +
 net/netfilter/nft_immediate.c                              |   12 +-
 net/openvswitch/actions.c                                  |   46 ++++++--
 net/tipc/name_table.c                                      |    2 
 net/tipc/socket.c                                          |    2 
 tools/perf/util/data.c                                     |    7 -
 69 files changed, 494 insertions(+), 179 deletions(-)

Alexey Bayduraev (1):
      perf data: Fix double free in perf_session__delete()

Ariel Levkovich (1):
      net/mlx5: Fix wrong limitation of metadata match on ecpf

Bart Van Assche (1):
      RDMA/ib_srp: Fix a deadlock

Brian Geffon (1):
      x86/fpu: Correct pkru/xstate inconsistency

ChenXiaoSong (1):
      configfs: fix a race in configfs_{,un}register_subsystem()

Christophe JAILLET (2):
      nfp: flower: Fix a potential leak in nfp_tunnel_add_shared_mac()
      iio: adc: men_z188_adc: Fix a resource leak in an error handling path

Christophe Leroy (1):
      net: Force inlining of checksum functions in net/checksum.h

Cosmin Tanislav (1):
      iio: adc: ad7124: fix mask used for setting AIN_BUFP & AIN_BUFM bits

Daehwan Jung (1):
      usb: gadget: rndis: add spinlock for rndis response list

Dan Carpenter (1):
      tipc: Fix end of loop tests for list_for_each_entry()

Daniele Palmas (1):
      USB: serial: option: add Telit LE910R1 compositions

Dmytro Bagrii (1):
      Revert "USB: serial: ch341: add new Product ID for CH341A"

Eric Dumazet (1):
      net: __pskb_pull_tail() & pskb_carve_frag_list() drop_monitor friends

Evan Quan (1):
      drm/amdgpu: disable MMHUB PG for Picasso

Felix Maurer (1):
      bpf: Do not try bpf_msg_push_data with len 0

Florian Westphal (1):
      netfilter: nf_tables: fix memory leak during stateful obj update

Gal Pressman (1):
      net/mlx5e: Fix wrong return value on ioctl EEPROM query failure

Greg Kroah-Hartman (1):
      Linux 5.4.182

Hans de Goede (1):
      usb: dwc3: pci: Fix Bay Trail phy GPIO mappings

Heiner Kallweit (1):
      lan743x: fix deadlock in lan743x_phy_link_status_change()

Helge Deller (2):
      parisc/unaligned: Fix fldd and fstd unaligned handlers on 32-bit kernel
      parisc/unaligned: Fix ldw() and stw() unalignment handlers

Hongyu Xie (1):
      xhci: Prevent futile URB re-submissions due to incorrect return value.

Jens Wiklander (2):
      tee: export teedev_open() and teedev_close_context()
      optee: use driver internal tee_context for some rpc

Karol Herbst (1):
      Revert "drm/nouveau/pmu/gm200-: avoid touching PMU outside of DEVINIT/PREOS/ACR"

Linus Torvalds (1):
      fget: clarify and improve __fget_files() implementation

Maor Gottlieb (1):
      net/mlx5: Fix possible deadlock on rule deletion

Marc Zyngier (1):
      gpio: tegra186: Fix chip_data type confusion

Maxime Ripard (1):
      drm/edid: Always set RGB444

Miaohe Lin (1):
      memblock: use kfree() to release kmalloced memblock regions

Miaoqian Lin (1):
      iio: Fix error handling for PM

Oliver Neukum (2):
      sr9700: sanity check for packet length
      USB: zaurus: support another broken Zaurus

Pablo Neira Ayuso (1):
      netfilter: nf_tables_offload: incorrect flow offload action array size

Paul Blakey (1):
      openvswitch: Fix setting ipv6 fields causing hw csum failure

Puma Hsu (1):
      xhci: re-initialize the HC during resume if HCE was set

Sebastian Andrzej Siewior (1):
      usb: dwc3: gadget: Let the interrupt handler disable bottom halves.

Sergey Shtylyov (1):
      ata: pata_hpt37x: disable primary channel on HPT371

Siarhei Volkau (1):
      clk: jz4725b: fix mmc0 clock gating

Slark Xiao (1):
      USB: serial: option: add support for DW5829e

Stefano Garzarella (1):
      vhost/vsock: don't check owner in vhost_vsock_stop() while releasing

Steven Rostedt (Google) (2):
      tracing: Have traceon and traceoff trigger honor the instance
      tracefs: Set the group ownership in apply_options() not parse_options()

Szymon Heidrich (1):
      USB: gadget: validate endpoint index for xilinx udc

Tao Liu (1):
      gso: do not skip outer ip header in case of ipip and net_failover

Xiaoke Wang (1):
      net: ll_temac: check the return value of devm_kmalloc()

Xin Long (1):
      ping: remove pr_err from ping_lookup

Zhang Qiao (1):
      cgroup/cpuset: Fix a race between cpuset_attach() and cpu hotplug

Zhou Qingyang (1):
      spi: spi-zynq-qspi: Fix a NULL pointer dereference in zynq_qspi_exec_mem_op()

daniel.starke@siemens.com (3):
      tty: n_gsm: fix encoding of control signal octet bit DV
      tty: n_gsm: fix proper link termination after failed open
      tty: n_gsm: fix NULL pointer access due to DLCI release

