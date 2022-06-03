Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FEB53CED8
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345164AbiFCRsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345313AbiFCRsI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:48:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F7557990;
        Fri,  3 Jun 2022 10:44:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6284B82430;
        Fri,  3 Jun 2022 17:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A67C385A9;
        Fri,  3 Jun 2022 17:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278283;
        bh=keifXvPOW2D2M6WpotsSbcFrFyPMScCtfbT7qOIzvGQ=;
        h=From:To:Cc:Subject:Date:From;
        b=VsvLVsYhicxw912OLsM2yjFrVK/Iu1QOF2sYBcoNpHk44gbG3wYhdlqAlWI8cly2s
         +iq5GlvdnGf8i2/kD0Z+8B/Am099zj+Kv6y6pUGdT1Lh130fjfKBlI7MFeAt7b3FTr
         ThKYY+NJXsSEFFEEzgDzoUf21Tzh3+KCnftdGtPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/34] 5.4.197-rc1 review
Date:   Fri,  3 Jun 2022 19:42:56 +0200
Message-Id: <20220603173815.990072516@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.197-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.197-rc1
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

This is the start of the stable review cycle for the 5.4.197 release.
There are 34 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.197-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.197-rc1

Liu Jian <liujian56@huawei.com>
    bpf: Enlarge offset check value to INT_MAX in bpf_skb_{load,store}_bytes

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix possible sleep during nfsd4_release_lockowner()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Memory allocation failures are not server fatal errors

Akira Yokosawa <akiyks@gmail.com>
    docs: submitting-patches: Fix crossref to 'The canonical patch format'

Xiu Jianfeng <xiujianfeng@huawei.com>
    tpm: ibmvtpm: Correct the return value in tpm_ibmvtpm_probe()

Stefan Mahnke-Hartmann <stefan.mahnke-hartmann@infineon.com>
    tpm: Fix buffer access in tpm2_get_tpm_pt()

Marek Maślanka <mm@semihalf.com>
    HID: multitouch: Add support for Google Whiskers Touchpad

Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
    raid5: introduce MD_BROKEN

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

Vitaly Chikunov <vt@altlinux.org>
    crypto: ecrdsa - Fix incorrect use of vli_cmp

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: re-fetch conntrack after insertion

Kees Cook <keescook@chromium.org>
    exec: Force single empty string when argv is empty

Gustavo A. R. Silva <gustavoars@kernel.org>
    drm/i915: Fix -Wstringop-overflow warning in call to intel_read_wm_latency()

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

IotaHydrae <writeforever@foxmail.com>
    pinctrl: sunxi: fix f1c100s uart2 function

Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
    ACPI: sysfs: Fix BERT error region memory mapping

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ACPI: sysfs: Make sparse happy about address space in use

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vim2m: initialize the media device earlier

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: vim2m: Register video device after setting up internals

Willy Tarreau <w@1wt.eu>
    secure_seq: use the 64 bits of the siphash for port offset calculation

Eric Dumazet <edumazet@google.com>
    tcp: change source port randomizarion at connect() time

Dmitry Mastykin <dmastykin@astralinux.ru>
    Input: goodix - fix spurious key release events

Denis Efremov (Oracle) <efremov@linux.com>
    staging: rtl8723bs: prevent ->Ssid overflow in rtw_wx_set_scan()

Thomas Gleixner <tglx@linutronix.de>
    x86/pci/xen: Disable PCI/MSI[-X] masking for XEN_HVM guests

Daniel Thompson <daniel.thompson@linaro.org>
    lockdown: also lock down previous kgdb use


-------------

Diffstat:

 Documentation/process/submitting-patches.rst   |  2 +-
 Makefile                                       |  4 +-
 arch/x86/pci/xen.c                             |  5 +++
 crypto/ecrdsa.c                                |  8 ++--
 drivers/acpi/sysfs.c                           | 23 +++++++---
 drivers/char/tpm/tpm2-cmd.c                    | 11 ++++-
 drivers/char/tpm/tpm_ibmvtpm.c                 |  1 +
 drivers/gpu/drm/i915/intel_pm.c                |  2 +-
 drivers/hid/hid-multitouch.c                   |  3 ++
 drivers/i2c/busses/i2c-ismt.c                  | 14 ++++++
 drivers/i2c/busses/i2c-thunderx-pcidrv.c       |  1 +
 drivers/input/touchscreen/goodix.c             |  2 +-
 drivers/md/dm-crypt.c                          | 14 ++++--
 drivers/md/dm-integrity.c                      |  2 -
 drivers/md/dm-stats.c                          |  8 ++++
 drivers/md/dm-verity-target.c                  |  1 +
 drivers/md/raid5.c                             | 47 +++++++++----------
 drivers/media/platform/vim2m.c                 | 22 +++++----
 drivers/net/ethernet/faraday/ftgmac100.c       |  5 +++
 drivers/pinctrl/sunxi/pinctrl-suniv-f1c100s.c  |  2 +-
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c |  6 ++-
 fs/exec.c                                      | 25 ++++++++++-
 fs/nfs/internal.h                              |  1 +
 fs/nfsd/nfs4state.c                            | 12 ++---
 include/linux/security.h                       |  2 +
 include/net/inet_hashtables.h                  |  2 +-
 include/net/netfilter/nf_conntrack_core.h      |  7 ++-
 include/net/secure_seq.h                       |  4 +-
 kernel/debug/debug_core.c                      | 24 ++++++++++
 kernel/debug/kdb/kdb_main.c                    | 62 ++++++++++++++++++++++++--
 lib/assoc_array.c                              |  8 ++++
 mm/zsmalloc.c                                  | 37 +++++++++++++--
 net/core/filter.c                              |  4 +-
 net/core/secure_seq.c                          |  4 +-
 net/ipv4/inet_hashtables.c                     | 28 +++++++++---
 net/ipv6/inet6_hashtables.c                    |  4 +-
 net/key/af_key.c                               |  6 +--
 net/wireless/core.c                            |  8 ++--
 net/wireless/reg.c                             |  1 +
 security/lockdown/lockdown.c                   |  2 +
 40 files changed, 327 insertions(+), 97 deletions(-)


