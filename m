Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6543F4E297D
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243098AbiCUOFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348808AbiCUODA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:03:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40459BB0AF;
        Mon, 21 Mar 2022 06:59:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33725612B4;
        Mon, 21 Mar 2022 13:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCC9C340F4;
        Mon, 21 Mar 2022 13:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871162;
        bh=uIUkZdntBR9X1c85x447nY92nPfuVGYkI6fX78SLkPs=;
        h=From:To:Cc:Subject:Date:From;
        b=oh44SsV8TvjK01bMBu2CV2+PFQxJLsoCur/qL64UNrONabFYLlAfRnmolxkmnDRqO
         vD5ki5rjp6loyYCbbBXoNrQEVdXW1VdvTTRUBQXXrqtiHPFy3HcjS3qlgH2bsiJqoI
         GLNkMu+C8UKtcGSc4we2utmV8bYgkUpteDRRUb1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/30] 5.10.108-rc1 review
Date:   Mon, 21 Mar 2022 14:52:30 +0100
Message-Id: <20220321133219.643490199@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.108-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.108-rc1
X-KernelTest-Deadline: 2022-03-23T13:32+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.108 release.
There are 30 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.108-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.108-rc1

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "selftests/bpf: Add test for bpf_timer overwriting crash"

Steffen Klassert <steffen.klassert@secunet.com>
    esp: Fix possible buffer overflow in ESP transformation

Fabio Estevam <festevam@denx.de>
    smsc95xx: Ignore -ENODEV errors when device is unplugged

Markus Reichl <m.reichl@fivetechno.de>
    net: usb: Correct reset handling of smsc95xx

Martyn Welch <martyn.welch@collabora.com>
    net: usb: Correct PHY handling of smsc95xx

Michael Petlan <mpetlan@redhat.com>
    perf symbols: Fix symbol size calculation condition

Pavel Skripkin <paskripkin@gmail.com>
    Input: aiptek - properly check endpoint type

Matt Lupfer <mlupfer@ddn.com>
    scsi: mpt3sas: Page fault in reply q processing

Alan Stern <stern@rowland.harvard.edu>
    usb: usbtmc: Fix bug in pipe direction for control transfers

Alan Stern <stern@rowland.harvard.edu>
    usb: gadget: Fix use-after-free bug by not setting udc->dev.driver

Dan Carpenter <dan.carpenter@oracle.com>
    usb: gadget: rndis: prevent integer overflow in rndis_set_response()

Arnd Bergmann <arnd@arndb.de>
    arm64: fix clang warning about TRAMP_VALIAS

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix backwards compatibility with single-chain tc-flower offload

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: skip invalid partial checksums

Manish Chopra <manishc@marvell.com>
    bnx2x: fix built-in kernel driver load failure

Juerg Haefliger <juerg.haefliger@canonical.com>
    net: phy: mscc: Add MODULE_FIRMWARE macros

Miaoqian Lin <linmq006@gmail.com>
    net: dsa: Add missing of_node_put() in dsa_port_parse_of

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    net: handle ARPHRD_PIMREG in dev_is_mac_header_xmit()

Marek Vasut <marex@denx.de>
    drm/panel: simple: Fix Innolux G070Y2-L01 BPP settings

Christoph Niedermaier <cniedermaier@dh-electronics.com>
    drm/imx: parallel-display: Remove bus flags check in imx_pd_bridge_atomic_check()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    hv_netvsc: Add check for kvmalloc_array

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    atm: eni: Add check for dma_map_single

Eric Dumazet <edumazet@google.com>
    net/packet: fix slab-out-of-bounds access in packet_recvmsg()

Kurt Cancemi <kurt@x64architecture.com>
    net: phy: marvell: Fix invalid comparison in the resume and suspend functions

Sabrina Dubroca <sd@queasysnail.net>
    esp6: fix check on ipv6_skip_exthdr's return value

Jiyong Park <jiyong@google.com>
    vsock: each transport cycles only on its own sockets

Randy Dunlap <rdunlap@infradead.org>
    efi: fix return value of __setup handlers

Guo Ziliang <guo.ziliang@zte.com.cn>
    mm: swap: get rid of livelock in swapin readahead

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix crash when initialize filecheck kobj fails

Brian Masney <bmasney@redhat.com>
    crypto: qcom-rng - ensure buffer for generate is completely filled


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm64/include/asm/vectors.h                   |  4 +-
 drivers/atm/eni.c                                  |  2 +
 drivers/crypto/qcom-rng.c                          | 17 +++--
 drivers/firmware/efi/apple-properties.c            |  2 +-
 drivers/firmware/efi/efi.c                         |  2 +-
 drivers/gpu/drm/imx/parallel-display.c             |  8 --
 drivers/gpu/drm/panel/panel-simple.c               |  2 +-
 drivers/input/tablet/aiptek.c                      | 10 +--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |  2 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    | 28 ++++---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   | 15 +---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  6 +-
 drivers/net/ethernet/mscc/ocelot_flower.c          | 16 +++-
 drivers/net/hyperv/netvsc_drv.c                    |  3 +
 drivers/net/phy/marvell.c                          |  8 +-
 drivers/net/phy/mscc/mscc_main.c                   |  3 +
 drivers/net/usb/smsc95xx.c                         | 86 ++++++++++++----------
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  5 +-
 drivers/usb/class/usbtmc.c                         | 13 +++-
 drivers/usb/gadget/function/rndis.c                |  1 +
 drivers/usb/gadget/udc/core.c                      |  3 -
 drivers/vhost/vsock.c                              |  3 +-
 fs/ocfs2/super.c                                   | 22 +++---
 include/linux/if_arp.h                             |  1 +
 include/net/af_vsock.h                             |  3 +-
 include/net/esp.h                                  |  2 +
 include/net/sock.h                                 |  1 +
 mm/swap_state.c                                    |  2 +-
 net/dsa/dsa2.c                                     |  1 +
 net/ipv4/esp4.c                                    |  5 ++
 net/ipv6/esp6.c                                    |  8 +-
 net/packet/af_packet.c                             | 11 ++-
 net/vmw_vsock/af_vsock.c                           |  9 ++-
 net/vmw_vsock/virtio_transport.c                   |  7 +-
 net/vmw_vsock/vmci_transport.c                     |  5 +-
 tools/perf/util/symbol.c                           |  2 +-
 .../testing/selftests/bpf/prog_tests/timer_crash.c | 32 --------
 tools/testing/selftests/bpf/progs/timer_crash.c    | 54 --------------
 39 files changed, 192 insertions(+), 216 deletions(-)


