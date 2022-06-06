Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1ECA53E29F
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbiFFHEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbiFFHE3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:04:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFBC1A380;
        Mon,  6 Jun 2022 00:04:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDCEFB80DEF;
        Mon,  6 Jun 2022 07:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45318C385A9;
        Mon,  6 Jun 2022 07:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654499064;
        bh=aX07lM66PLDET4+8ubDyt45glNWHe5r+e47AzA7S5yw=;
        h=From:To:Cc:Subject:Date:From;
        b=Cf3BXZZHVKfkeIdCBOJaS0ijXze9cEcmW7zDA+1FSf07D+wSjnsnYzbIsKSene0nR
         6bXRUjdjug5SI3Yoo3MHtmm9LSCfSVejvqc/AIjWQnITB8adZteKDzEzKRryF3PYV4
         Bs+TFdbSyx63Rm/hab3i0hLaHt7W2R3qGSwAyKzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.282
Date:   Mon,  6 Jun 2022 09:04:17 +0200
Message-Id: <165449905734191@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
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

I'm announcing the release of the 4.14.282 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/process/submitting-patches.rst   |    2 -
 Makefile                                       |    2 -
 arch/x86/pci/xen.c                             |    5 +++
 block/bio.c                                    |    2 -
 drivers/acpi/sysfs.c                           |   23 +++++++++++----
 drivers/char/tpm/tpm_ibmvtpm.c                 |    1 
 drivers/gpu/drm/i915/intel_pm.c                |    2 -
 drivers/i2c/busses/i2c-thunderx-pcidrv.c       |    1 
 drivers/md/dm-crypt.c                          |   14 +++++++--
 drivers/md/dm-integrity.c                      |    2 -
 drivers/md/dm-stats.c                          |    8 +++++
 drivers/md/dm-verity-target.c                  |    1 
 drivers/net/ethernet/faraday/ftgmac100.c       |    5 +++
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c |    6 ++--
 fs/exec.c                                      |   17 +++++++++++
 fs/nfsd/nfs4state.c                            |   12 ++------
 include/net/inet_hashtables.h                  |    2 -
 include/net/netfilter/nf_conntrack_core.h      |    7 ++++
 include/net/secure_seq.h                       |    4 +-
 lib/assoc_array.c                              |    8 +++++
 mm/zsmalloc.c                                  |   37 ++++++++++++++++++++++---
 net/core/filter.c                              |    4 +-
 net/core/secure_seq.c                          |    4 +-
 net/ipv4/inet_hashtables.c                     |   28 ++++++++++++++----
 net/ipv6/inet6_hashtables.c                    |    4 +-
 net/key/af_key.c                               |    6 ++--
 26 files changed, 159 insertions(+), 48 deletions(-)

Akira Yokosawa (1):
      docs: submitting-patches: Fix crossref to 'The canonical patch format'

Andy Shevchenko (1):
      ACPI: sysfs: Make sparse happy about address space in use

Chuck Lever (1):
      NFSD: Fix possible sleep during nfsd4_release_lockowner()

Dan Carpenter (1):
      dm integrity: fix error code in dm_integrity_ctr()

Denis Efremov (Oracle) (1):
      staging: rtl8723bs: prevent ->Ssid overflow in rtw_wx_set_scan()

Eric Dumazet (1):
      tcp: change source port randomizarion at connect() time

Florian Westphal (1):
      netfilter: conntrack: re-fetch conntrack after insertion

Greg Kroah-Hartman (1):
      Linux 4.14.282

Gustavo A. R. Silva (1):
      drm/i915: Fix -Wstringop-overflow warning in call to intel_read_wm_latency()

Haimin Zhang (1):
      block-map: add __GFP_ZERO flag for alloc_page in function bio_copy_kern

Joel Stanley (1):
      net: ftgmac100: Disable hardware checksum on AST2600

Kees Cook (1):
      exec: Force single empty string when argv is empty

Liu Jian (1):
      bpf: Enlarge offset check value to INT_MAX in bpf_skb_{load,store}_bytes

Lorenzo Pieralisi (1):
      ACPI: sysfs: Fix BERT error region memory mapping

Mikulas Patocka (2):
      dm crypt: make printing of the key constant-time
      dm stats: add cond_resched when looping over entries

Piyush Malgujar (1):
      drivers: i2c: thunderx: Allow driver to work with ACPI defined TWSI controllers

Sarthak Kukreti (1):
      dm verity: set DM_TARGET_IMMUTABLE feature flag

Stephen Brennan (1):
      assoc_array: Fix BUG_ON during garbage collect

Sultan Alsawaf (1):
      zsmalloc: fix races between asynchronous zspage free and page migration

Thomas Bartschies (1):
      net: af_key: check encryption module availability consistency

Thomas Gleixner (1):
      x86/pci/xen: Disable PCI/MSI[-X] masking for XEN_HVM guests

Willy Tarreau (1):
      secure_seq: use the 64 bits of the siphash for port offset calculation

Xiu Jianfeng (1):
      tpm: ibmvtpm: Correct the return value in tpm_ibmvtpm_probe()

