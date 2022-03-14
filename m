Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5464D879A
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 16:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242000AbiCNPBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 11:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242132AbiCNPBa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 11:01:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF57434B8;
        Mon, 14 Mar 2022 08:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54E81B80E34;
        Mon, 14 Mar 2022 15:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA53BC340F4;
        Mon, 14 Mar 2022 15:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647270011;
        bh=JrElxTUVi3/YHD5BCmLNenP2Jn79tAdFcg9aru7ppBI=;
        h=From:To:Cc:Subject:Date:From;
        b=eRE4Dk5QAqguK2NszenvNPt1PbwFdev9+hVNfAO6/6IrA5AY8yILtOQpzdfUuOfC2
         eZu73S44WwRhqPTvQ0qNo/wZo9arci5ffTZgEqMaLe2Ccpgl0TKYTuKfVbWqZYR81g
         svfy8+2gNKyXQ+WhgpLWsmFLocVE0sMApnCDtAFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.14 00/22] 4.14.272-rc2 review
Date:   Mon, 14 Mar 2022 16:00:06 +0100
Message-Id: <20220314145907.257355309@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.272-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.272-rc2
X-KernelTest-Deadline: 2022-03-16T14:59+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.272 release.
There are 22 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 16 Mar 2022 14:58:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.272-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.272-rc2

Qu Wenruo <wqu@suse.com>
    btrfs: unlock newly allocated extent buffer after error

Josh Triplett <josh@joshtriplett.org>
    ext4: add check to prevent attempting to resize an fs with sparse_super2

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: fix Thumb2 regression with Spectre BHB

Michael S. Tsirkin <mst@redhat.com>
    virtio: acknowledge all features before access

Michael S. Tsirkin <mst@redhat.com>
    virtio: unexport virtio_finalize_features

Dan Carpenter <dan.carpenter@oracle.com>
    staging: gdm724x: fix use after free in gdm_lte_rx()

Randy Dunlap <rdunlap@infradead.org>
    ARM: Spectre-BHB: provide empty stub for non-config

Mike Kravetz <mike.kravetz@oracle.com>
    selftests/memfd: clean up mapping in mfd_fail_write

Sven Schnelle <svens@linux.ibm.com>
    tracing: Ensure trace buffer is at least 4096 bytes large

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    Revert "xen-netback: Check for hotplug-status existence before watching"

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    Revert "xen-netback: remove 'hotplug-status' once it has served its purpose"

suresh kumar <suresh2514@gmail.com>
    net-sysfs: add check for netdevice being present to speed_show

Eric Dumazet <edumazet@google.com>
    sctp: fix kernel-infoleak for SCTP sockets

Mark Featherston <mark@embeddedTS.com>
    gpio: ts4900: Do not set DAT and OE together

Pavel Skripkin <paskripkin@gmail.com>
    NFC: port100: fix use-after-free in port100_send_complete

Mohammad Kabat <mohammadkab@nvidia.com>
    net/mlx5: Fix size field in bufferx_reg struct

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Fix NULL pointer dereference in ax25_kill_by_device

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    net: ethernet: lpc_eth: Handle error for clk_enable

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    net: ethernet: ti: cpts: Handle error for clk_enable

Miaoqian Lin <linmq006@gmail.com>
    ethernet: Fix error handling in xemaclite_of_probe

Tom Rix <trix@redhat.com>
    qed: return status of qed_iov_get_link

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: qlogic: check the return value of dma_alloc_coherent() in qed_vf_hw_prepare()


-------------

Diffstat:

 Makefile                                      |  4 +--
 arch/arm/include/asm/spectre.h                |  6 ++++
 arch/arm/kernel/entry-armv.S                  |  4 +--
 drivers/gpio/gpio-ts4900.c                    | 24 ++++++++++++----
 drivers/net/ethernet/nxp/lpc_eth.c            |  5 +++-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c   | 18 +++++++-----
 drivers/net/ethernet/qlogic/qed/qed_vf.c      |  7 +++++
 drivers/net/ethernet/ti/cpts.c                |  4 ++-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |  4 ++-
 drivers/net/xen-netback/xenbus.c              | 13 ++++-----
 drivers/nfc/port100.c                         |  2 ++
 drivers/staging/gdm724x/gdm_lte.c             |  5 ++--
 drivers/virtio/virtio.c                       | 40 ++++++++++++++-------------
 fs/btrfs/extent-tree.c                        |  1 +
 fs/ext4/resize.c                              |  5 ++++
 include/linux/mlx5/mlx5_ifc.h                 |  4 +--
 include/linux/virtio.h                        |  1 -
 include/linux/virtio_config.h                 |  3 +-
 kernel/trace/trace.c                          | 10 ++++---
 net/ax25/af_ax25.c                            |  7 +++++
 net/core/net-sysfs.c                          |  2 +-
 net/sctp/sctp_diag.c                          |  9 ++----
 tools/testing/selftests/memfd/memfd_test.c    |  1 +
 23 files changed, 116 insertions(+), 63 deletions(-)


