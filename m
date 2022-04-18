Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89C650554C
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241079AbiDRNLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239696AbiDRNFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:05:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124F420F73;
        Mon, 18 Apr 2022 05:46:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A29D960FB6;
        Mon, 18 Apr 2022 12:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDC5C385A7;
        Mon, 18 Apr 2022 12:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286003;
        bh=rdVpADfyBNxl/+AyT3aBrtWFN62gbyQxxv4XkXkKf2U=;
        h=From:To:Cc:Subject:Date:From;
        b=G08K/LSWNU3n5tce5NWFz7epoANbraR442LDC48PzQ+iF0kgPAnD2E84xOl/6qLtm
         7BMqWQdHTzVrf2DRnN4ecEb0Pd0EM8B8AnC+v93NxClb+wDnXspeyW25pdwDXBCBne
         uIKIb2m8JTGP4GXyABdqOGN3VjIMtRnYpeFexK6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.19 00/32] 4.19.239-rc1 review
Date:   Mon, 18 Apr 2022 14:13:40 +0200
Message-Id: <20220418121127.127656835@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.239-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.239-rc1
X-KernelTest-Deadline: 2022-04-20T12:11+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.239 release.
There are 32 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.239-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.239-rc1

Martin Povišer <povik+lin@cutebit.org>
    i2c: pasemi: Wait for write xfers to finish

Nadav Amit <namit@vmware.com>
    smp: Fix offline cpu check in flush_smp_call_function_queue()

Nathan Chancellor <nathan@kernel.org>
    ARM: davinci: da850-evm: Avoid NULL pointer dereference

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ipv6: fix panic when forwarding a pkt with no in6 dev

Fabio M. De Francesco <fmdefrancesco@gmail.com>
    ALSA: pcm: Test for "silence" field in struct "pcm_format_data"

Tim Crawford <tcrawford@system76.com>
    ALSA: hda/realtek: Add quirk for Clevo PD50PNT

Jason A. Donenfeld <Jason@zx2c4.com>
    gcc-plugins: latent_entropy: use /dev/urandom

Oliver Upton <oupton@google.com>
    KVM: Don't create VM debugfs files outside of the VM directory

Patrick Wang <patrick.wang.shcn@gmail.com>
    mm: kmemleak: take a full lowmem check in kmemleak_*_phys()

Juergen Gross <jgross@suse.com>
    mm, page_alloc: fix build_zonerefs_node()

Duoming Zhou <duoming@zju.edu.cn>
    drivers: net: slip: fix NPD bug in sl_tx_timeout()

Alexey Galakhov <agalakhov@gmail.com>
    scsi: mvsas: Add PCI ID of RocketRaid 2640

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Fix allocate_mst_payload assert on resume

Joey Gouly <joey.gouly@arm.com>
    arm64: alternatives: mark patch_alternative() as `noinstr`

Leo Ruan <tingquan.ruan@cn.bosch.com>
    gpu: ipu-v3: Fix dev_dbg frequency output

Christian Lamparter <chunkeey@gmail.com>
    ata: libata-core: Disable READ LOG DMA EXT for Samsung 840 EVOs

Randy Dunlap <rdunlap@infradead.org>
    net: micrel: fix KS8851_MLL Kconfig

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: ibmvscsis: Increase INITIAL_SRP_LIMIT to 1024

Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
    scsi: target: tcmu: Fix possible page UAF

Michael Kelley <mikelley@microsoft.com>
    Drivers: hv: vmbus: Prevent load re-ordering when reading ring buffer

QintaoShen <unSimple1993@163.com>
    drm/amdkfd: Check for potential null return of kmalloc_array()

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd: Add USBC connector ID

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    cifs: potential buffer overflow in handling symlinks

Lin Ma <linma@zju.edu.cn>
    nfc: nci: add flush_workqueue to prevent uaf

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    testing/selftests/mqueue: Fix mq_perf_tests to free the allocated cpu set

Petr Malat <oss@malat.biz>
    sctp: Initialize daddr on peeled off socket

Dinh Nguyen <dinguyen@kernel.org>
    net: ethernet: stmmac: fix altr_tse_pcs function when using a fixed-link

Vadim Pasternak <vadimp@nvidia.com>
    mlxsw: i2c: Fix initialization error flow

Linus Torvalds <torvalds@linux-foundation.org>
    gpiolib: acpi: use correct format characters

Guillaume Nault <gnault@redhat.com>
    veth: Ensure eth header is in skb's linear part

Vlad Buslov <vladbu@nvidia.com>
    net/sched: flower: fix parsing of ethertype following VLAN header

Miaoqian Lin <linmq006@gmail.com>
    memory: atmel-ebi: Fix missing of_node_put in atmel_ebi_probe


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/mach-davinci/board-da850-evm.c            |  4 +-
 arch/arm64/kernel/alternative.c                    |  6 +--
 drivers/ata/libata-core.c                          |  3 ++
 drivers/gpio/gpiolib-acpi.c                        |  4 +-
 drivers/gpu/drm/amd/amdgpu/ObjectID.h              |  1 +
 drivers/gpu/drm/amd/amdkfd/kfd_events.c            |  2 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  3 +-
 drivers/gpu/ipu-v3/ipu-di.c                        |  5 ++-
 drivers/hv/ring_buffer.c                           | 11 +++++-
 drivers/i2c/busses/i2c-pasemi.c                    |  6 +++
 drivers/memory/atmel-ebi.c                         | 23 ++++++++---
 drivers/net/ethernet/mellanox/mlxsw/i2c.c          |  1 +
 drivers/net/ethernet/micrel/Kconfig                |  1 +
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c |  8 ----
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h |  4 ++
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    | 13 +++----
 drivers/net/slip/slip.c                            |  2 +-
 drivers/net/veth.c                                 |  2 +-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c           |  2 +-
 drivers/scsi/mvsas/mv_init.c                       |  1 +
 drivers/target/target_core_user.c                  |  3 +-
 fs/cifs/link.c                                     |  3 ++
 include/net/flow_dissector.h                       |  2 +
 kernel/smp.c                                       |  2 +-
 mm/kmemleak.c                                      |  8 ++--
 mm/page_alloc.c                                    |  2 +-
 net/core/flow_dissector.c                          |  1 +
 net/ipv6/ip6_output.c                              |  2 +-
 net/nfc/nci/core.c                                 |  4 ++
 net/sched/cls_flower.c                             | 18 ++++++---
 net/sctp/socket.c                                  |  2 +-
 scripts/gcc-plugins/latent_entropy_plugin.c        | 44 +++++++++++++---------
 sound/core/pcm_misc.c                              |  2 +-
 sound/pci/hda/patch_realtek.c                      |  1 +
 tools/testing/selftests/mqueue/mq_perf_tests.c     | 25 ++++++++----
 virt/kvm/kvm_main.c                                |  8 +++-
 37 files changed, 155 insertions(+), 78 deletions(-)


