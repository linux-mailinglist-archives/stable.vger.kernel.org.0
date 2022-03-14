Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406F94D80DE
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239041AbiCNLfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236577AbiCNLfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:35:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F773EAB6;
        Mon, 14 Mar 2022 04:34:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 403ADB80DB9;
        Mon, 14 Mar 2022 11:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438E3C340E9;
        Mon, 14 Mar 2022 11:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647257670;
        bh=5P1AInnTFtcNIO11S7NULQT4EovUwJSAepKTNAIVgWo=;
        h=From:To:Cc:Subject:Date:From;
        b=yUOBbt+roezK5QuMcgmJrYkdtkoP7i5giF3vWly8vlcimRjqH6dMBr1wWX3oVnzt0
         jgi6RbK+D3ij1R+0/uxMYUsgEEUld+RdYJn53a4sqpfcvmowoxjw6x/UbWdiaiX5Re
         vac5BNXp9MKSkA3fkllhEcKw70mju5/37rGIGGZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.9 00/20] 4.9.307-rc1 review
Date:   Mon, 14 Mar 2022 12:34:01 +0100
Message-Id: <20220314112730.388955049@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.307-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.307-rc1
X-KernelTest-Deadline: 2022-03-16T11:27+00:00
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

This is the start of the stable review cycle for the 4.9.307 release.
There are 20 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.307-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.307-rc1

Qu Wenruo <wqu@suse.com>
    btrfs: unlock newly allocated extent buffer after error

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: fix Thumb2 regression with Spectre BHB

Sven Eckelmann <sven@narfation.org>
    batman-adv: Don't expect inter-netns unique iflink indices

Sven Eckelmann <sven@narfation.org>
    batman-adv: Request iflink once in batadv-on-batadv check

James Morse <james.morse@arm.com>
    KVM: arm64: Reset PMC_EL0 to avoid a panic() on systems with no PMU

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

Miaoqian Lin <linmq006@gmail.com>
    ethernet: Fix error handling in xemaclite_of_probe

Tom Rix <trix@redhat.com>
    qed: return status of qed_iov_get_link

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: qlogic: check the return value of dma_alloc_coherent() in qed_vf_hw_prepare()


-------------

Diffstat:

 Makefile                                      |  4 ++--
 arch/arm/include/asm/spectre.h                |  6 ++++++
 arch/arm/kernel/entry-armv.S                  |  4 ++--
 arch/arm64/kvm/sys_regs.c                     |  4 +++-
 drivers/gpio/gpio-ts4900.c                    | 24 +++++++++++++++++++-----
 drivers/net/ethernet/nxp/lpc_eth.c            |  5 ++++-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c   | 18 +++++++++++-------
 drivers/net/ethernet/qlogic/qed/qed_vf.c      |  7 +++++++
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |  4 +++-
 drivers/net/xen-netback/xenbus.c              | 12 ++++--------
 drivers/nfc/port100.c                         |  2 ++
 drivers/staging/gdm724x/gdm_lte.c             |  5 +++--
 fs/btrfs/extent-tree.c                        |  1 +
 include/linux/mlx5/mlx5_ifc.h                 |  4 ++--
 kernel/trace/trace.c                          | 10 ++++++----
 net/ax25/af_ax25.c                            |  7 +++++++
 net/batman-adv/hard-interface.c               | 13 ++++++++-----
 net/core/net-sysfs.c                          |  2 +-
 net/sctp/sctp_diag.c                          |  9 +++------
 tools/testing/selftests/memfd/memfd_test.c    |  1 +
 20 files changed, 95 insertions(+), 47 deletions(-)


