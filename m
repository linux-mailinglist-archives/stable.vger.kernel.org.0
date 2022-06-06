Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1338B53E315
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiFFHFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiFFHEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:04:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543B223BED;
        Mon,  6 Jun 2022 00:04:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD66FB80CB0;
        Mon,  6 Jun 2022 07:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CC2C385A9;
        Mon,  6 Jun 2022 07:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654499080;
        bh=zdB6C2ZqnIFNz93BahnxxSQvMRvKrfIeng0EwQ2KYAU=;
        h=From:To:Cc:Subject:Date:From;
        b=qatzPIKtrWzX6prryFW4ks82HgON1+TvATwJQVyXR5AU+k56ciytVy7zGyNRmkEXB
         OC7zxYPPdZBIeSSYHAh4iRkCuJEhXgMv8ikvc6wjSQRFoP95QC70Mp7rqcEXO9qc/O
         kbcV4D46S6xB7/oVUWuj3y09y9F/SbfrRp/ogTp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.197
Date:   Mon,  6 Jun 2022 09:04:36 +0200
Message-Id: <1654499076146246@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

I'm announcing the release of the 5.4.197 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/process/submitting-patches.rst   |    2 
 Makefile                                       |    2 
 arch/x86/pci/xen.c                             |    5 ++
 crypto/ecrdsa.c                                |    8 +--
 drivers/acpi/sysfs.c                           |   23 ++++++---
 drivers/char/tpm/tpm2-cmd.c                    |   11 ++++
 drivers/char/tpm/tpm_ibmvtpm.c                 |    1 
 drivers/gpu/drm/i915/intel_pm.c                |    2 
 drivers/hid/hid-multitouch.c                   |    3 +
 drivers/i2c/busses/i2c-ismt.c                  |   14 +++++
 drivers/i2c/busses/i2c-thunderx-pcidrv.c       |    1 
 drivers/input/touchscreen/goodix.c             |    2 
 drivers/md/dm-crypt.c                          |   14 ++++-
 drivers/md/dm-integrity.c                      |    2 
 drivers/md/dm-stats.c                          |    8 +++
 drivers/md/dm-verity-target.c                  |    1 
 drivers/md/raid5.c                             |   47 ++++++++----------
 drivers/media/platform/vim2m.c                 |   22 +++++---
 drivers/net/ethernet/faraday/ftgmac100.c       |    5 ++
 drivers/pinctrl/sunxi/pinctrl-suniv-f1c100s.c  |    2 
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c |    6 +-
 fs/exec.c                                      |   25 +++++++++-
 fs/nfs/internal.h                              |    1 
 fs/nfsd/nfs4state.c                            |   12 +---
 include/linux/security.h                       |    2 
 include/net/inet_hashtables.h                  |    2 
 include/net/netfilter/nf_conntrack_core.h      |    7 ++
 include/net/secure_seq.h                       |    4 -
 kernel/debug/debug_core.c                      |   24 +++++++++
 kernel/debug/kdb/kdb_main.c                    |   62 +++++++++++++++++++++++--
 lib/assoc_array.c                              |    8 +++
 mm/zsmalloc.c                                  |   37 +++++++++++++-
 net/core/filter.c                              |    4 -
 net/core/secure_seq.c                          |    4 -
 net/ipv4/inet_hashtables.c                     |   28 ++++++++---
 net/ipv6/inet6_hashtables.c                    |    4 -
 net/key/af_key.c                               |    6 +-
 net/wireless/core.c                            |    8 +--
 net/wireless/reg.c                             |    1 
 security/lockdown/lockdown.c                   |    2 
 40 files changed, 326 insertions(+), 96 deletions(-)

Akira Yokosawa (1):
      docs: submitting-patches: Fix crossref to 'The canonical patch format'

Andy Shevchenko (1):
      ACPI: sysfs: Make sparse happy about address space in use

Chuck Lever (1):
      NFSD: Fix possible sleep during nfsd4_release_lockowner()

Dan Carpenter (1):
      dm integrity: fix error code in dm_integrity_ctr()

Daniel Thompson (1):
      lockdown: also lock down previous kgdb use

Denis Efremov (Oracle) (1):
      staging: rtl8723bs: prevent ->Ssid overflow in rtw_wx_set_scan()

Dmitry Mastykin (1):
      Input: goodix - fix spurious key release events

Eric Dumazet (1):
      tcp: change source port randomizarion at connect() time

Florian Westphal (1):
      netfilter: conntrack: re-fetch conntrack after insertion

Greg Kroah-Hartman (1):
      Linux 5.4.197

Gustavo A. R. Silva (1):
      drm/i915: Fix -Wstringop-overflow warning in call to intel_read_wm_latency()

Hans Verkuil (1):
      media: vim2m: initialize the media device earlier

IotaHydrae (1):
      pinctrl: sunxi: fix f1c100s uart2 function

Joel Stanley (1):
      net: ftgmac100: Disable hardware checksum on AST2600

Kees Cook (1):
      exec: Force single empty string when argv is empty

Liu Jian (1):
      bpf: Enlarge offset check value to INT_MAX in bpf_skb_{load,store}_bytes

Lorenzo Pieralisi (1):
      ACPI: sysfs: Fix BERT error region memory mapping

Marek Maślanka (1):
      HID: multitouch: Add support for Google Whiskers Touchpad

Mariusz Tkaczyk (1):
      raid5: introduce MD_BROKEN

Mika Westerberg (1):
      i2c: ismt: Provide a DMA buffer for Interrupt Cause Logging

Mikulas Patocka (2):
      dm crypt: make printing of the key constant-time
      dm stats: add cond_resched when looping over entries

Miri Korenblit (1):
      cfg80211: set custom regdomain after wiphy registration

Piyush Malgujar (1):
      drivers: i2c: thunderx: Allow driver to work with ACPI defined TWSI controllers

Sakari Ailus (1):
      media: vim2m: Register video device after setting up internals

Sarthak Kukreti (1):
      dm verity: set DM_TARGET_IMMUTABLE feature flag

Stefan Mahnke-Hartmann (1):
      tpm: Fix buffer access in tpm2_get_tpm_pt()

Stephen Brennan (1):
      assoc_array: Fix BUG_ON during garbage collect

Sultan Alsawaf (1):
      zsmalloc: fix races between asynchronous zspage free and page migration

Thomas Bartschies (1):
      net: af_key: check encryption module availability consistency

Thomas Gleixner (1):
      x86/pci/xen: Disable PCI/MSI[-X] masking for XEN_HVM guests

Trond Myklebust (1):
      NFS: Memory allocation failures are not server fatal errors

Vitaly Chikunov (1):
      crypto: ecrdsa - Fix incorrect use of vli_cmp

Willy Tarreau (1):
      secure_seq: use the 64 bits of the siphash for port offset calculation

Xiu Jianfeng (1):
      tpm: ibmvtpm: Correct the return value in tpm_ibmvtpm_probe()

