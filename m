Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0FF50F493
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345115AbiDZIgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345459AbiDZIei (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:34:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2F4762A7;
        Tue, 26 Apr 2022 01:27:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C2DA617F1;
        Tue, 26 Apr 2022 08:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DE0C385A0;
        Tue, 26 Apr 2022 08:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961642;
        bh=MNGf8KKRrccO2m1N3umqP+9t+hz1VnaZC4LlTS0eFyA=;
        h=From:To:Cc:Subject:Date:From;
        b=WlI69rQRoaEXU29nJvSwn8WPoyjaZ061VScu9rUnOlUFTc7AL7wOAzO8G8+10EuNp
         mnkRnStYrUP+OBVsjHkxGUHenrbW4seMwHzn+sRj+oRw8GlbMeZfBOyO/UDZuFdJet
         Im0Q0MADJhwQ+YrsahNeBRZwEBF/en1OR8JThHFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.19 00/53] 4.19.240-rc1 review
Date:   Tue, 26 Apr 2022 10:20:40 +0200
Message-Id: <20220426081735.651926456@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.240-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.240-rc1
X-KernelTest-Deadline: 2022-04-28T08:17+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.240 release.
There are 53 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.240-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.240-rc1

Marek Vasut <marex@denx.de>
    Revert "net: micrel: fix KS8851_MLL Kconfig"

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Fix UAF bugs in ax25 timers

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Fix NULL pointer dereferences in ax25 timers

Duoming Zhou <duoming@zju.edu.cn>
    ax25: fix NPD bug in ax25_disconnect

Duoming Zhou <duoming@zju.edu.cn>
    ax25: fix UAF bug in ax25_send_control()

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Fix refcount leaks caused by ax25_cb_del()

Duoming Zhou <duoming@zju.edu.cn>
    ax25: fix UAF bugs of net_device caused by rebinding operation

Duoming Zhou <duoming@zju.edu.cn>
    ax25: fix reference count leaks of ax25_dev

Duoming Zhou <duoming@zju.edu.cn>
    ax25: add refcount in ax25_dev to avoid UAF bugs

Khazhismel Kumykov <khazhy@google.com>
    block/compat_ioctl: fix range check in BLKGETSIZE

Lee Jones <lee.jones@linaro.org>
    staging: ion: Prevent incorrect reference counting behavour

Theodore Ts'o <tytso@mit.edu>
    ext4: force overhead calculation if the s_overhead_cluster makes no sense

Theodore Ts'o <tytso@mit.edu>
    ext4: fix overhead calculation to account for the reserved gdt blocks

Tadeusz Struk <tadeusz.struk@linaro.org>
    ext4: limit length to bitmap_maxbytes - blocksize in punch_hole

Ye Bin <yebin10@huawei.com>
    ext4: fix symlink file size not match to file content

Rob Herring <robh@kernel.org>
    arm_pmu: Validate single/group leader events

Sergey Matyukevich <sergey.matyukevich@synopsys.com>
    ARC: entry: fix syscall_trace_exit argument

Sasha Neftin <sasha.neftin@intel.com>
    e1000e: Fix possible overflow in LTR decoding

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    ASoC: soc-dapm: fix two incorrect uses of list iterator

Paolo Valerio <pvalerio@redhat.com>
    openvswitch: fix OOB access in reserve_sfa_size()

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Fix power9 event alternatives

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/panel/raspberrypi-touchscreen: Initialise the bridge in prepare

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/panel/raspberrypi-touchscreen: Avoid NULL deref if not initialised

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    dma: at_xdmac: fix a missing check on list iterator

Zheyu Ma <zheyuma97@gmail.com>
    ata: pata_marvell: Check the 'bmdma_addr' beforing reading

Mikulas Patocka <mpatocka@redhat.com>
    stat: fix inconsistency between struct stat and struct compat_stat

Tomas Melin <tomas.melin@vaisala.com>
    net: macb: Restart tx only if queue pointer is lagging

Xiaoke Wang <xkernel.wang@foxmail.com>
    drm/msm/mdp5: check the return of kzalloc()

Lv Ruyi <lv.ruyi@zte.com.cn>
    dpaa_eth: Fix missing of_node_put in dpaa_get_ts_info()

Borislav Petkov <bp@alien8.de>
    brcmfmac: sdio: Fix undefined behavior due to shift overflowing the constant

Borislav Petkov <bp@suse.de>
    mt76: Fix undefined behavior due to shift overflowing the constant

David Howells <dhowells@redhat.com>
    cifs: Check the IOCB_DIRECT flag, not O_DIRECT

Hongbin Wang <wh_bin@126.com>
    vxlan: fix error return code in vxlan_fdb_append

Borislav Petkov <bp@suse.de>
    ALSA: usb-audio: Fix undefined behavior due to shift overflowing the constant

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    platform/x86: samsung-laptop: Fix an unsigned comparison which can never be negative

Sameer Pujar <spujar@nvidia.com>
    reset: tegra-bpmp: Restore Handle errors in BPMP response

Kees Cook <keescook@chromium.org>
    ARM: vexpress/spc: Avoid negative array index when !SMP

Eric Dumazet <edumazet@google.com>
    netlink: reset network and mac headers in netlink_dump()

Eric Dumazet <edumazet@google.com>
    net/sched: cls_u32: fix possible leak in u32_init_knode()

Hangbin Liu <liuhangbin@gmail.com>
    net/packet: fix packet_sock xmit return value checking

David Howells <dhowells@redhat.com>
    rxrpc: Restore removed timer deletion

Miaoqian Lin <linmq006@gmail.com>
    dmaengine: imx-sdma: Fix error checking in sdma_event_remap

Miaoqian Lin <linmq006@gmail.com>
    ASoC: msm8916-wcd-digital: Check failure for devm_snd_soc_register_component

Mark Brown <broonie@kernel.org>
    ASoC: atmel: Remove system clock tree configuration for at91sam9g20ek

Kuniyuki Iwashima <kuniyu@amazon.co.jp>
    tcp: Fix potential use-after-free due to double kfree()

Ricardo Dias <rdias@singlestore.com>
    tcp: fix race condition when creating child sockets from syncookies

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Clear MIDI port active flag after draining

Bob Peterson <rpeterso@redhat.com>
    gfs2: assign rgrp glock before compute_bitstructs

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: fix memory corruption when tag_size is less than digest size

Hangyu Hua <hbh25y@gmail.com>
    can: usb_8dev: usb_8dev_start_xmit(): fix double dev_kfree_skb() in error path

Daniel Bristot de Oliveira <bristot@kernel.org>
    tracing: Dump stacktrace trigger to the corresponding instance

Xiongwei Song <sxwjean@gmail.com>
    mm: page_alloc: fix building error on -Werror=array-compare

Kees Cook <keescook@chromium.org>
    etherdevice: Adjust ether_addr* prototypes to silence -Wstringop-overead


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arc/kernel/entry.S                            |  1 +
 arch/arm/mach-vexpress/spc.c                       |  2 +-
 arch/powerpc/perf/power9-pmu.c                     |  8 +--
 arch/x86/include/asm/compat.h                      |  6 +-
 block/compat_ioctl.c                               |  2 +-
 drivers/ata/pata_marvell.c                         |  2 +
 drivers/dma/at_xdmac.c                             | 12 ++--
 drivers/dma/imx-sdma.c                             |  4 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c         |  3 +
 .../gpu/drm/panel/panel-raspberrypi-touchscreen.c  | 13 ++++-
 drivers/md/dm-integrity.c                          |  7 ++-
 drivers/net/can/usb/usb_8dev.c                     | 30 +++++-----
 drivers/net/ethernet/cadence/macb_main.c           |  8 +++
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |  8 ++-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |  4 +-
 drivers/net/ethernet/micrel/Kconfig                |  1 -
 drivers/net/vxlan.c                                |  4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_pci.c    |  2 +-
 drivers/perf/arm_pmu.c                             | 10 ++--
 drivers/platform/x86/samsung-laptop.c              |  2 -
 drivers/reset/tegra/reset-bpmp.c                   |  9 ++-
 drivers/staging/android/ion/ion.c                  |  3 +
 fs/cifs/cifsfs.c                                   |  2 +-
 fs/ext4/inode.c                                    | 11 +++-
 fs/ext4/page-io.c                                  |  4 +-
 fs/ext4/super.c                                    | 19 ++++--
 fs/gfs2/rgrp.c                                     |  9 +--
 fs/stat.c                                          | 19 +++---
 include/linux/etherdevice.h                        |  5 +-
 include/net/ax25.h                                 | 12 ++++
 include/net/inet_hashtables.h                      |  5 +-
 kernel/trace/trace_events_trigger.c                |  9 ++-
 mm/page_alloc.c                                    |  2 +-
 net/ax25/af_ax25.c                                 | 38 +++++++++---
 net/ax25/ax25_dev.c                                | 28 +++++++--
 net/ax25/ax25_route.c                              | 13 ++++-
 net/ax25/ax25_subr.c                               | 20 +++++--
 net/dccp/ipv4.c                                    |  2 +-
 net/dccp/ipv6.c                                    |  2 +-
 net/ipv4/inet_connection_sock.c                    |  2 +-
 net/ipv4/inet_hashtables.c                         | 68 +++++++++++++++++++---
 net/ipv4/tcp_ipv4.c                                | 13 ++++-
 net/ipv6/tcp_ipv6.c                                | 13 ++++-
 net/netlink/af_netlink.c                           |  7 +++
 net/openvswitch/flow_netlink.c                     |  2 +-
 net/packet/af_packet.c                             | 13 +++--
 net/rxrpc/net_ns.c                                 |  2 +
 net/sched/cls_u32.c                                |  8 +--
 sound/soc/atmel/sam9g20_wm8731.c                   | 61 -------------------
 sound/soc/codecs/msm8916-wcd-digital.c             |  9 ++-
 sound/soc/soc-dapm.c                               |  6 +-
 sound/usb/midi.c                                   |  1 +
 sound/usb/usbaudio.h                               |  2 +-
 55 files changed, 359 insertions(+), 195 deletions(-)


