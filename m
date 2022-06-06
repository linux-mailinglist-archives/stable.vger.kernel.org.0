Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305AA53E38B
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiFFHEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbiFFHEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:04:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E8717E02;
        Mon,  6 Jun 2022 00:04:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7999D61138;
        Mon,  6 Jun 2022 07:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A11C34115;
        Mon,  6 Jun 2022 07:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654499049;
        bh=pgX5xFKB+jPr/wjc4vXQxvrglUgBi3H+PtZOqmf+TKw=;
        h=From:To:Cc:Subject:Date:From;
        b=lyjYSM5fZWELTBNyIvTHfnLDscZFYlFQzyIw+rx1eLMwHurOtJM31baK63JcvqezI
         52/rXsJhxF/Z7mF5fiXttww14r0u9g3nErAuDJeoucP159PqK4nFaKqIXgEdaBw4Nd
         eicNEmhqLsf1335K6C8vy7t5PBGilSSVD65pSliU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.317
Date:   Mon,  6 Jun 2022 09:04:06 +0200
Message-Id: <1654499046230243@kroah.com>
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

I'm announcing the release of the 4.9.317 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 +-
 block/bio.c                              |    2 +-
 drivers/char/tpm/tpm_ibmvtpm.c           |    1 +
 drivers/gpu/drm/i915/intel_pm.c          |    2 +-
 drivers/i2c/busses/i2c-thunderx-pcidrv.c |    1 +
 drivers/md/dm-crypt.c                    |   15 +++++++++++----
 drivers/md/dm-stats.c                    |    8 ++++++++
 drivers/md/dm-verity-target.c            |    1 +
 fs/exec.c                                |   17 +++++++++++++++++
 fs/nfsd/nfs4state.c                      |   12 ++++--------
 lib/assoc_array.c                        |    8 ++++++++
 net/core/filter.c                        |    4 ++--
 net/key/af_key.c                         |    6 +++---
 13 files changed, 59 insertions(+), 20 deletions(-)

Chuck Lever (1):
      NFSD: Fix possible sleep during nfsd4_release_lockowner()

Greg Kroah-Hartman (1):
      Linux 4.9.317

Gustavo A. R. Silva (1):
      drm/i915: Fix -Wstringop-overflow warning in call to intel_read_wm_latency()

Haimin Zhang (1):
      block-map: add __GFP_ZERO flag for alloc_page in function bio_copy_kern

Kees Cook (1):
      exec: Force single empty string when argv is empty

Liu Jian (1):
      bpf: Enlarge offset check value to INT_MAX in bpf_skb_{load,store}_bytes

Mikulas Patocka (2):
      dm crypt: make printing of the key constant-time
      dm stats: add cond_resched when looping over entries

Piyush Malgujar (1):
      drivers: i2c: thunderx: Allow driver to work with ACPI defined TWSI controllers

Sarthak Kukreti (1):
      dm verity: set DM_TARGET_IMMUTABLE feature flag

Stephen Brennan (1):
      assoc_array: Fix BUG_ON during garbage collect

Thomas Bartschies (1):
      net: af_key: check encryption module availability consistency

Xiu Jianfeng (1):
      tpm: ibmvtpm: Correct the return value in tpm_ibmvtpm_probe()

