Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D3753CEA9
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345007AbiFCRp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345164AbiFCRoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:44:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203365536F;
        Fri,  3 Jun 2022 10:42:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89C1761B4A;
        Fri,  3 Jun 2022 17:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62272C3411F;
        Fri,  3 Jun 2022 17:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278167;
        bh=EyFDE0xUZG7DOuFDJyWZYeJL2SCmWYYiBxsMT6Q3gGs=;
        h=From:To:Cc:Subject:Date:From;
        b=oGq/m6YejDewcSyTjPw9WQ/jOCEb3csEVcpqJ2kMrD0SHhUIji+q4pPtA7RWF2PCF
         gQe57LE+d5796HNANYSnKbh2Pp8nWnoggA1h/oWuxtZxDa+VpstLF+78CeoQMJCJv6
         CR9UEg4XgQwZh8h/xkHc/HIiYpwiL6dQ8aFSZQ18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.19 00/30] 4.19.246-rc1 review
Date:   Fri,  3 Jun 2022 19:39:28 +0200
Message-Id: <20220603173815.088143764@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.246-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.246-rc1
X-KernelTest-Deadline: 2022-06-05T17:38+00:00
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

This is the start of the stable review cycle for the 4.19.246 release.
There are 30 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.246-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.246-rc1

Liu Jian <liujian56@huawei.com>
    bpf: Enlarge offset check value to INT_MAX in bpf_skb_{load,store}_bytes

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix possible sleep during nfsd4_release_lockowner()

Akira Yokosawa <akiyks@gmail.com>
    docs: submitting-patches: Fix crossref to 'The canonical patch format'

Xiu Jianfeng <xiujianfeng@huawei.com>
    tpm: ibmvtpm: Correct the return value in tpm_ibmvtpm_probe()

Stefan Mahnke-Hartmann <stefan.mahnke-hartmann@infineon.com>
    tpm: Fix buffer access in tpm2_get_tpm_pt()

Marek Maślanka <mm@semihalf.com>
    HID: multitouch: Add support for Google Whiskers Touchpad

Sarthak Kukreti <sarthakkukreti@google.com>
    dm verity: set DM_TARGET_IMMUTABLE feature flag

Mikulas Patocka <mpatocka@redhat.com>
    dm stats: add cond_resched when looping over entries

Mikulas Patocka <mpatocka@redhat.com>
    dm crypt: make printing of the key constant-time

Dan Carpenter <dan.carpenter@oracle.com>
    dm integrity: fix error code in dm_integrity_ctr()

Sultan Alsawaf <sultan@kerneltoast.com>
    zsmalloc: fix races between asynchronous zspage free and page migration

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: re-fetch conntrack after insertion

Kees Cook <keescook@chromium.org>
    exec: Force single empty string when argv is empty

Haimin Zhang <tcs.kernel@gmail.com>
    block-map: add __GFP_ZERO flag for alloc_page in function bio_copy_kern

Gustavo A. R. Silva <gustavoars@kernel.org>
    drm/i915: Fix -Wstringop-overflow warning in call to intel_read_wm_latency()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tests bp_account: Make global variable static

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf bench: Share some global variables to fix build with gcc 10

Ben Hutchings <ben@decadent.org.uk>
    libtraceevent: Fix build with binutils 2.35

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    cfg80211: set custom regdomain after wiphy registration

Stephen Brennan <stephen.s.brennan@oracle.com>
    assoc_array: Fix BUG_ON during garbage collect

Piyush Malgujar <pmalgujar@marvell.com>
    drivers: i2c: thunderx: Allow driver to work with ACPI defined TWSI controllers

Mika Westerberg <mika.westerberg@linux.intel.com>
    i2c: ismt: Provide a DMA buffer for Interrupt Cause Logging

Joel Stanley <joel@jms.id.au>
    net: ftgmac100: Disable hardware checksum on AST2600

Thomas Bartschies <thomas.bartschies@cvk.de>
    net: af_key: check encryption module availability consistency

Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
    ACPI: sysfs: Fix BERT error region memory mapping

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ACPI: sysfs: Make sparse happy about address space in use

Willy Tarreau <w@1wt.eu>
    secure_seq: use the 64 bits of the siphash for port offset calculation

Eric Dumazet <edumazet@google.com>
    tcp: change source port randomizarion at connect() time

Denis Efremov (Oracle) <efremov@linux.com>
    staging: rtl8723bs: prevent ->Ssid overflow in rtw_wx_set_scan()

Thomas Gleixner <tglx@linutronix.de>
    x86/pci/xen: Disable PCI/MSI[-X] masking for XEN_HVM guests


-------------

Diffstat:

 Documentation/process/submitting-patches.rst   |  2 +-
 Makefile                                       |  4 +--
 arch/x86/pci/xen.c                             |  5 ++++
 block/bio.c                                    |  2 +-
 drivers/acpi/sysfs.c                           | 23 +++++++++++-----
 drivers/char/tpm/tpm2-cmd.c                    | 11 +++++++-
 drivers/char/tpm/tpm_ibmvtpm.c                 |  1 +
 drivers/gpu/drm/i915/intel_pm.c                |  2 +-
 drivers/hid/hid-multitouch.c                   |  3 +++
 drivers/i2c/busses/i2c-ismt.c                  | 14 ++++++++++
 drivers/i2c/busses/i2c-thunderx-pcidrv.c       |  1 +
 drivers/md/dm-crypt.c                          | 14 +++++++---
 drivers/md/dm-integrity.c                      |  2 --
 drivers/md/dm-stats.c                          |  8 ++++++
 drivers/md/dm-verity-target.c                  |  1 +
 drivers/net/ethernet/faraday/ftgmac100.c       |  5 ++++
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c |  6 +++--
 fs/exec.c                                      | 17 ++++++++++++
 fs/nfsd/nfs4state.c                            | 12 +++------
 include/net/inet_hashtables.h                  |  2 +-
 include/net/netfilter/nf_conntrack_core.h      |  7 ++++-
 include/net/secure_seq.h                       |  4 +--
 lib/assoc_array.c                              |  8 ++++++
 mm/zsmalloc.c                                  | 37 +++++++++++++++++++++++---
 net/core/filter.c                              |  4 +--
 net/core/secure_seq.c                          |  4 +--
 net/ipv4/inet_hashtables.c                     | 28 ++++++++++++++-----
 net/ipv6/inet6_hashtables.c                    |  4 +--
 net/key/af_key.c                               |  6 ++---
 net/wireless/core.c                            |  7 ++---
 net/wireless/reg.c                             |  1 +
 tools/lib/traceevent/Makefile                  |  2 +-
 tools/perf/bench/bench.h                       |  4 +++
 tools/perf/bench/futex-hash.c                  | 12 ++++-----
 tools/perf/bench/futex-lock-pi.c               | 11 ++++----
 tools/perf/tests/bp_account.c                  |  2 +-
 36 files changed, 209 insertions(+), 67 deletions(-)


