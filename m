Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7779DF54DD
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387962AbfKHS4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:56:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:53564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732164AbfKHS4D (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:56:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E70632178F;
        Fri,  8 Nov 2019 18:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239362;
        bh=0jAsKdiJdwPpdCjhGpdl16rAFrkPufAApEspDAtLZDU=;
        h=From:To:Cc:Subject:Date:From;
        b=X8gQgSVRT+sDrbPtCeIflnf+GN/a1FV6mV+o3SeC57B/Qx5zwnScGhXCOaL1drqT+
         +tUy/rxJsjRaB51kAaqUw2Zy/53/0Vhm6bgnMMTMiPjjmuBN+lL9htnSEfixI8Z4WR
         w4xVJ6SqcTYqLY5L1phqbgi5eZwaGNIoj3OdUeaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.9 00/34] 4.9.200-stable review
Date:   Fri,  8 Nov 2019 19:50:07 +0100
Message-Id: <20191108174618.266472504@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.200-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.200-rc1
X-KernelTest-Deadline: 2019-11-10T17:46+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.200 release.
There are 34 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun 10 Nov 2019 05:42:11 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.200-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.200-rc1

Petr Vorel <pvorel@suse.cz>
    alarmtimer: Change remaining ENOTSUPP to EOPNOTSUPP

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    dmaengine: qcom: bam_dma: Fix resource leak

Eric Dumazet <edumazet@google.com>
    net/flow_dissector: switch to siphash

Seth Forshee <seth.forshee@canonical.com>
    kbuild: add -fcf-protection=none when using retpoline flags

Masahiro Yamada <yamada.masahiro@socionext.com>
    kbuild: use -fmacro-prefix-map to make __FILE__ a relative path

Kees Cook <keescook@chromium.org>
    Kbuild: make designated_init attribute fatal

Eric Dumazet <edumazet@google.com>
    inet: stop leaking jiffies on the wire

Eran Ben Elisha <eranbe@mellanox.com>
    net/mlx4_core: Dynamically set guaranteed amount of counters per VF

Xin Long <lucien.xin@gmail.com>
    vxlan: check tun_info options_len properly

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: reset 40nm EPHY on energy detect

Vivien Didelot <vivien.didelot@gmail.com>
    net: dsa: fix switch tree list

Eric Dumazet <edumazet@google.com>
    net: add READ_ONCE() annotation in __skb_wait_for_more_packets()

Wei Wang <weiwan@google.com>
    selftests: net: reuseport_dualstack: fix uninitalized parameter

zhanglin <zhang.lin16@zte.com.cn>
    net: Zeroing the structure ethtool_wolinfo in ethtool_get_wol()

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    net: hisilicon: Fix ping latency when deal with high throughput

Tejun Heo <tj@kernel.org>
    net: fix sk_page_frag() recursion from memory reclaim

Eric Dumazet <edumazet@google.com>
    dccp: do not leak jiffies on the wire

Dave Wysochanski <dwysocha@redhat.com>
    cifs: Fix cifsInodeInfo lock_sem deadlock when reconnect occurs

Jonas Gorski <jonas.gorski@gmail.com>
    MIPS: bmips: mark exception vectors as char arrays

Navid Emamdoost <navid.emamdoost@gmail.com>
    of: unittest: fix memory leak in unittest_data_add

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    scsi: target: core: Do not overwrite CDB byte 1

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ARM: davinci: dm365: Fix McBSP dma_slave_map entry

Yunfeng Ye <yeyunfeng@huawei.com>
    perf kmem: Fix memory leak in compact_gfp_flags()

Anson Huang <Anson.Huang@nxp.com>
    ARM: dts: imx7s: Correct GPT's ipg clock source

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    scsi: fix kconfig dependency warning related to 53C700_LE_ON_BE

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    scsi: sni_53c710: fix compilation error

Hannes Reinecke <hare@suse.com>
    scsi: scsi_dh_alua: handle RTPG sense code correctly during state transitions

Russell King <rmk+kernel@armlinux.org.uk>
    ARM: mm: fix alignment handler faults under memory pressure

Dan Carpenter <dan.carpenter@oracle.com>
    pinctrl: ns2: Fix off by one bugs in ns2_pinmux_enable()

Adam Ford <aford173@gmail.com>
    ARM: dts: logicpd-torpedo-som: Remove twl_keypad

Robin Murphy <robin.murphy@arm.com>
    ASoc: rockchip: i2s: Fix RPM imbalance

Stuart Henderson <stuarth@opensource.cirrus.com>
    ASoC: wm_adsp: Don't generate kcontrols without READ flags

Yizhuo <yzhai003@ucr.edu>
    regulator: pfuze100-regulator: Variable "val" in pfuze100_regulator_probe() could be uninitialized

Axel Lin <axel.lin@ingics.com>
    regulator: ti-abb: Fix timeout in ti_abb_wait_txdone/ti_abb_clear_all_txdone


-------------

Diffstat:

 Makefile                                           | 16 +++++++-
 arch/arm/boot/dts/imx7s.dtsi                       |  8 ++--
 arch/arm/boot/dts/logicpd-torpedo-som.dtsi         |  4 ++
 arch/arm/mach-davinci/dm365.c                      |  4 +-
 arch/arm/mm/alignment.c                            | 44 ++++++++++++++++----
 arch/mips/bcm63xx/prom.c                           |  2 +-
 arch/mips/include/asm/bmips.h                      | 10 ++---
 arch/mips/kernel/smp-bmips.c                       |  8 ++--
 drivers/dma/qcom/bam_dma.c                         | 14 +++++++
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  9 +++-
 drivers/net/ethernet/hisilicon/hip04_eth.c         | 15 ++++---
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  | 42 +++++++++++--------
 drivers/net/vxlan.c                                |  5 ++-
 drivers/of/unittest.c                              |  1 +
 drivers/pinctrl/bcm/pinctrl-ns2-mux.c              |  4 +-
 drivers/regulator/pfuze100-regulator.c             |  8 +++-
 drivers/regulator/ti-abb-regulator.c               | 26 ++++--------
 drivers/scsi/Kconfig                               |  2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c         | 21 +++++++---
 drivers/scsi/sni_53c710.c                          |  4 +-
 drivers/target/target_core_device.c                | 21 ----------
 fs/cifs/cifsglob.h                                 |  5 +++
 fs/cifs/cifsproto.h                                |  1 +
 fs/cifs/file.c                                     | 23 +++++++----
 fs/cifs/smb2file.c                                 |  2 +-
 include/linux/gfp.h                                | 23 +++++++++++
 include/linux/skbuff.h                             |  3 +-
 include/net/flow_dissector.h                       |  3 +-
 include/net/fq.h                                   |  2 +-
 include/net/fq_impl.h                              |  4 +-
 include/net/sock.h                                 | 11 +++--
 kernel/time/alarmtimer.c                           |  4 +-
 net/core/datagram.c                                |  2 +-
 net/core/ethtool.c                                 |  4 +-
 net/core/flow_dissector.c                          | 48 +++++++++-------------
 net/dccp/ipv4.c                                    |  4 +-
 net/dsa/dsa2.c                                     |  2 +-
 net/ipv4/datagram.c                                |  2 +-
 net/ipv4/tcp_ipv4.c                                |  4 +-
 net/sched/sch_fq_codel.c                           |  6 +--
 net/sched/sch_hhf.c                                |  8 ++--
 net/sched/sch_sfb.c                                | 13 +++---
 net/sched/sch_sfq.c                                | 14 ++++---
 net/sctp/socket.c                                  |  2 +-
 sound/soc/codecs/wm_adsp.c                         |  3 +-
 sound/soc/rockchip/rockchip_i2s.c                  |  2 +-
 tools/perf/builtin-kmem.c                          |  1 +
 tools/testing/selftests/net/reuseport_dualstack.c  |  3 +-
 48 files changed, 286 insertions(+), 181 deletions(-)


