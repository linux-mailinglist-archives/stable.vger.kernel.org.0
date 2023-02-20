Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE87969CE01
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbjBTNzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232549AbjBTNzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:55:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496C218B39;
        Mon, 20 Feb 2023 05:55:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8DA260B74;
        Mon, 20 Feb 2023 13:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF96C433EF;
        Mon, 20 Feb 2023 13:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901299;
        bh=S9eSiboNIUNFUy9vp39Db14YgsWLqJVBe8cxrk+YMzQ=;
        h=From:To:Cc:Subject:Date:From;
        b=N10laeuSCF2SQUxfqggj7D/IW6tx0Tlah2NVMEx0xEpVA6nIiREzZBtUn7mxHmCkT
         XQ3tWg8t7xubEECLCiEtqFP8mN9Z7O44m2IvUMVxCqys4MlI3tOm55KHmBVEA8ubCF
         XLs9YjxNQ1Pw8hrl4o8G4o47+1tjIVNnBsXbeUvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.10 00/57] 5.10.169-rc1 review
Date:   Mon, 20 Feb 2023 14:36:08 +0100
Message-Id: <20230220133549.360169435@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.169-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.169-rc1
X-KernelTest-Deadline: 2023-02-22T13:35+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.169 release.
There are 57 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.169-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.169-rc1

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    nvmem: core: fix return value

Dan Carpenter <error27@gmail.com>
    net: sched: sch: Fix off by one in htb_activate_prios()

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: hda-dai: fix possible stream_tag leak

Thomas Gleixner <tglx@linutronix.de>
    alarmtimer: Prevent starvation by small intervals and SIG_IGN

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    kvm: initialize all of the kvm_debugregs structure before sending it to userspace

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: tcindex: search key must be 16 bits

Natalia Petrova <n.petrova@fintech.ru>
    i40e: Add checking for null for nlmsg_find_attr()

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: act_ctinfo: use percpu stats

Baowen Zheng <baowen.zheng@corigine.com>
    flow_offload: fill flags to action structure

Matt Roper <matthew.d.roper@intel.com>
    drm/i915/gen11: Wa_1408615072/Wa_1407596294 should be on GT list

Raviteja Goud Talla <ravitejax.goud.talla@intel.com>
    drm/i915/gen11: Moving WAs to icl_gt_workarounds_init()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix underflow in second superblock position calculations

Guillaume Nault <gnault@redhat.com>
    ipv6: Fix tcp socket connection with DSCP.

Guillaume Nault <gnault@redhat.com>
    ipv6: Fix datagram socket connection with DSCP.

Jason Xing <kernelxing@tencent.com>
    ixgbe: add double of VLAN header when computing the max MTU

Jakub Kicinski <kuba@kernel.org>
    net: mpls: fix stale pointer if allocation fails during device rename

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    net: stmmac: Restrict warning on disabling DMA store and fwd mode

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix mqprio and XDP ring checking logic

Johannes Zink <j.zink@pengutronix.de>
    net: stmmac: fix order of dwmac5 FlexPPS parametrization sequence

Hangyu Hua <hbh25y@gmail.com>
    net: openvswitch: fix possible memory leak in ovs_meter_cmd_set()

Miko Larsson <mikoxyzzz@gmail.com>
    net/usb: kalmia: Don't pass act_len in usb_bulk_msg error path

Kuniyuki Iwashima <kuniyu@amazon.com>
    dccp/tcp: Avoid negative sk_forward_alloc by ipv6_pinfo.pktoptions.

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: tcindex: update imperfect hash filters respecting rcu

Pietro Borrello <borrello@diag.uniroma1.it>
    sctp: sctp_sock_filter(): avoid list_entry() on possibly empty list

Rafał Miłecki <rafal@milecki.pl>
    net: bgmac: fix BCM5358 support by setting correct flags

Jason Xing <kernelxing@tencent.com>
    i40e: add double of VLAN header when computing the max MTU

Jason Xing <kernelxing@tencent.com>
    ixgbe: allow to increase MTU to 3K with XDP enabled

Andrew Morton <akpm@linux-foundation.org>
    revert "squashfs: harden sanity check in squashfs_read_xattr_id_table"

Felix Riemann <felix.riemann@sma.de>
    net: Fix unwanted sign extension in netdev_stats_to_stats64()

Aaron Thompson <dev@aaront.org>
    Revert "mm: Always release pages to the buddy allocator in memblock_free_late()."

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: check for undefined shift on 32 bit architectures

Munehisa Kamata <kamatam@amazon.com>
    sched/psi: Fix use-after-free in ep_remove_wait_queue()

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - fixed wrong gpio assigned

Bo Liu <bo.liu@senarytech.com>
    ALSA: hda/conexant: add a new hda codec SN6180

Yang Yingliang <yangyingliang@huawei.com>
    mmc: mmc_spi: fix error handling in mmc_spi_probe()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: sdio: fix possible resource leaks in some error paths

Paul Cercueil <paul@crapouillou.net>
    mmc: jz4740: Work around bug on JZ4760(B)

Florian Westphal <fw@strlen.de>
    netfilter: nft_tproxy: restrict to prerouting hook

Amir Goldstein <amir73il@gmail.com>
    ovl: remove privs in ovl_fallocate()

Amir Goldstein <amir73il@gmail.com>
    ovl: remove privs in ovl_copyfile()

Sumanth Korikkar <sumanthk@linux.ibm.com>
    s390/signal: fix endless loop in do_signal

Seth Jenkins <sethjenkins@google.com>
    aio: fix mremap after fork null-deref

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    nvmem: core: fix registration vs use race

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    nvmem: core: fix cleanup after dev_set_name()

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    nvmem: core: remove nvmem_config wp_gpio

Gaosheng Cui <cuigaosheng1@huawei.com>
    nvmem: core: add error handling for dev_set_name

Hans de Goede <hdegoede@redhat.com>
    platform/x86: touchscreen_dmi: Add Chuwi Vi8 (CWI501) DMI match

Amit Engel <Amit.Engel@dell.com>
    nvme-fc: fix a missing queue put in nvmet_fc_ls_create_association

Vasily Gorbik <gor@linux.ibm.com>
    s390/decompressor: specify __decompress() buf len to avoid overflow

Kees Cook <keescook@chromium.org>
    net: sched: sch: Bounds check priority

Andrey Konovalov <andrey.konovalov@linaro.org>
    net: stmmac: do not stop RX_CLK in Rx LPI state for qcs404 SoC

Hyunwoo Kim <v4bel@theori.io>
    net/rose: Fix to not accept on connected socket

Shunsuke Mie <mie@igel.co.jp>
    tools/virtio: fix the vringh test for virtio ring changes

Arnd Bergmann <arnd@arndb.de>
    ASoC: cs42l56: fix DT probe

Cezary Rojewski <cezary.rojewski@intel.com>
    ALSA: hda: Do not unset preset when cleaning up codec

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: Verify copy_register_state() preserves parent/live fields

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_rt5682: always set dpcm_capture for amplifiers


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/s390/boot/compressed/decompressor.c           |  2 +-
 arch/s390/kernel/signal.c                          |  2 +-
 arch/x86/kvm/x86.c                                 |  3 +-
 drivers/gpu/drm/i915/gt/intel_workarounds.c        | 32 ++++++++--------
 drivers/mmc/core/sdio_bus.c                        | 17 +++++++--
 drivers/mmc/core/sdio_cis.c                        | 12 ------
 drivers/mmc/host/jz4740_mmc.c                      | 10 +++++
 drivers/mmc/host/mmc_spi.c                         |  8 ++--
 drivers/net/ethernet/broadcom/bgmac-bcma.c         |  6 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  8 +++-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |  2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      | 28 ++++++++------
 .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c    |  2 +
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c       |  3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  3 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  2 +-
 drivers/net/usb/kalmia.c                           |  8 ++--
 drivers/nvme/target/fc.c                           |  4 +-
 drivers/nvmem/core.c                               | 43 +++++++++++-----------
 drivers/platform/x86/touchscreen_dmi.c             |  9 +++++
 fs/aio.c                                           |  4 ++
 fs/nilfs2/ioctl.c                                  |  7 ++++
 fs/nilfs2/super.c                                  |  9 +++++
 fs/nilfs2/the_nilfs.c                              |  8 +++-
 fs/overlayfs/file.c                                | 28 ++++++++++++--
 fs/squashfs/xattr_id.c                             |  2 +-
 include/linux/hugetlb.h                            |  5 ++-
 include/linux/nvmem-provider.h                     |  2 -
 include/linux/stmmac.h                             |  1 +
 include/net/sock.h                                 | 13 +++++++
 kernel/sched/psi.c                                 |  7 ++--
 kernel/time/alarmtimer.c                           | 33 +++++++++++++++--
 mm/memblock.c                                      |  8 +---
 net/core/dev.c                                     |  2 +-
 net/dccp/ipv6.c                                    |  7 +---
 net/ipv6/datagram.c                                |  2 +-
 net/ipv6/tcp_ipv6.c                                | 11 ++----
 net/mpls/af_mpls.c                                 |  4 ++
 net/netfilter/nft_tproxy.c                         |  8 ++++
 net/openvswitch/meter.c                            |  4 +-
 net/rose/af_rose.c                                 |  8 ++++
 net/sched/act_bpf.c                                |  2 +-
 net/sched/act_connmark.c                           |  2 +-
 net/sched/act_ctinfo.c                             |  6 +--
 net/sched/act_gate.c                               |  2 +-
 net/sched/act_ife.c                                |  2 +-
 net/sched/act_ipt.c                                |  2 +-
 net/sched/act_mpls.c                               |  2 +-
 net/sched/act_nat.c                                |  2 +-
 net/sched/act_pedit.c                              |  2 +-
 net/sched/act_police.c                             |  2 +-
 net/sched/act_sample.c                             |  2 +-
 net/sched/act_simple.c                             |  2 +-
 net/sched/act_skbedit.c                            |  2 +-
 net/sched/act_skbmod.c                             |  2 +-
 net/sched/cls_tcindex.c                            | 34 +++++++++++++++--
 net/sched/sch_htb.c                                |  5 ++-
 net/sctp/diag.c                                    |  4 +-
 sound/pci/hda/hda_bind.c                           |  2 +
 sound/pci/hda/hda_codec.c                          |  1 -
 sound/pci/hda/patch_conexant.c                     |  1 +
 sound/pci/hda/patch_realtek.c                      |  2 +-
 sound/soc/codecs/cs42l56.c                         |  6 ---
 sound/soc/intel/boards/sof_rt5682.c                |  3 ++
 sound/soc/sof/intel/hda-dai.c                      |  8 ++--
 .../selftests/bpf/verifier/search_pruning.c        | 36 ++++++++++++++++++
 tools/virtio/linux/bug.h                           |  8 ++--
 tools/virtio/linux/build_bug.h                     |  7 ++++
 tools/virtio/linux/cpumask.h                       |  7 ++++
 tools/virtio/linux/gfp.h                           |  7 ++++
 tools/virtio/linux/kernel.h                        |  1 +
 tools/virtio/linux/kmsan.h                         | 12 ++++++
 tools/virtio/linux/scatterlist.h                   |  1 +
 tools/virtio/linux/topology.h                      |  7 ++++
 76 files changed, 404 insertions(+), 165 deletions(-)


