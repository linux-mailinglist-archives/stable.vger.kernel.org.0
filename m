Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A25A2F7918
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732576AbhAOMbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:31:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:37058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727700AbhAOMbU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:31:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2D60236FB;
        Fri, 15 Jan 2021 12:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713797;
        bh=ZFIyyunQqDw20/DH0NFeOcsXXInaOgujlJLJwmFfQ9M=;
        h=From:To:Cc:Subject:Date:From;
        b=DQI4/JwUK8XPDLRKXrwibrVQJqWWNO5rhKYVw3ax/L3oQD4XA8WCzil/L/aOJsH9i
         Y8d9j2AfUkrjBhtI33s0ze9grkCRh7wJSI18nx2cYAoHIesSyLRcnIMAsobcdKv9zI
         ouLD8irPVuLajIF/Ccc2QBjudg5F2BbKkgDYvTYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 4.4 00/18] 4.4.252-rc1 review
Date:   Fri, 15 Jan 2021 13:27:28 +0100
Message-Id: <20210115121955.112329537@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.252-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.252-rc1
X-KernelTest-Deadline: 2021-01-17T12:19+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.252 release.
There are 18 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.252-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.252-rc1

Vasily Averin <vvs@virtuozzo.com>
    net: drop bogus skb with CHECKSUM_PARTIAL and offset beyond end of trimmed packet

Ming Lei <ming.lei@redhat.com>
    block: fix use-after-free in disk_part_iter_next

Dinghao Liu <dinghao.liu@zju.edu.cn>
    iommu/intel: Fix memleak in intel_irq_remapping_alloc

Arnd Bergmann <arnd@arndb.de>
    block: rsxx: select CONFIG_CRC32

Arnd Bergmann <arnd@arndb.de>
    wil6210: select CONFIG_CRC32

Colin Ian King <colin.king@canonical.com>
    cpufreq: powernow-k8: pass policy rather than use cpufreq_cpu_get()

Lukas Wunner <lukas@wunner.de>
    spi: pxa2xx: Fix use-after-free on unbind

Richard Weinberger <richard@nod.at>
    ubifs: wbuf: Don't leak kernel memory to flash

Nick Desaulniers <ndesaulniers@google.com>
    vmlinux.lds.h: Add PGO and AutoFDO input sections

Florian Westphal <fw@strlen.de>
    net: fix pmtu check in nopmtudisc mode

Florian Westphal <fw@strlen.de>
    net: ip: always refragment ip defragmented packets

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    powerpc: Fix incorrect stw{, ux, u, x} instructions in __set_pte_at

David Disseldorp <ddiss@suse.de>
    scsi: target: Fix XCOPY NAA identifier lookup

Mike Christie <mchristi@redhat.com>
    xcopy: loop over devices using idr helper

David Disseldorp <ddiss@suse.de>
    target: use XCOPY segment descriptor CSCD IDs

David Disseldorp <ddiss@suse.de>
    target: simplify XCOPY wwn->se_dev lookup helper

David Disseldorp <ddiss@suse.de>
    target: bounds check XCOPY segment descriptor list

David Disseldorp <ddiss@suse.de>
    target: add XCOPY target/segment desc sense codes


-------------

Diffstat:

 Makefile                                 |   4 +-
 arch/powerpc/include/asm/pgtable.h       |   4 +-
 block/genhd.c                            |   9 +-
 drivers/block/Kconfig                    |   1 +
 drivers/cpufreq/powernow-k8.c            |   9 +-
 drivers/iommu/intel_irq_remapping.c      |   2 +
 drivers/net/wireless/ath/wil6210/Kconfig |   1 +
 drivers/spi/spi-pxa2xx.c                 |   3 +-
 drivers/target/target_core_transport.c   |  24 ++++
 drivers/target/target_core_xcopy.c       | 220 +++++++++++++++++++------------
 drivers/target/target_core_xcopy.h       |   1 +
 fs/ubifs/io.c                            |  13 +-
 include/asm-generic/vmlinux.lds.h        |   5 +-
 include/target/target_core_base.h        |   4 +
 net/core/skbuff.c                        |   6 +
 net/ipv4/ip_output.c                     |   2 +-
 net/ipv4/ip_tunnel.c                     |  10 +-
 17 files changed, 209 insertions(+), 109 deletions(-)


