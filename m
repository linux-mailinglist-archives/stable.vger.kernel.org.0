Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7259C650ADA
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 12:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbiLSLmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 06:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbiLSLmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 06:42:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42EA160E8;
        Mon, 19 Dec 2022 03:42:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9582360F0C;
        Mon, 19 Dec 2022 11:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F07C433EF;
        Mon, 19 Dec 2022 11:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671450140;
        bh=AhQPddo7DUvbGykumpvhYXC1w0GUI0nh0ZTZUYyrmsg=;
        h=From:To:Cc:Subject:Date:From;
        b=1365FOLfynNrnh0mpDExO1A7KnosbGzxEtTrS5Q6BSWDCVzKUxfCqVNEcOTkNfTju
         ZUSm9h2kTL2N+LbF+tN8+E/uKVt3Zby8ZI64gjXisZf7sJc8XPTIKZGTjz1pvPyQ8k
         zfQ6e9WK0vXsLNjpzH4yhlHr9uGgdv4QYCoOxEn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.228
Date:   Mon, 19 Dec 2022 12:42:15 +0100
Message-Id: <1671450135165176@kroah.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.228 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                 |    2 -
 arch/x86/kernel/cpu/mtrr/mtrr.c                          |    2 -
 arch/x86/kernel/smpboot.c                                |    1 
 block/partition-generic.c                                |    7 +++
 drivers/net/can/usb/mcba_usb.c                           |   10 +++--
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c |    3 +
 drivers/pinctrl/mediatek/mtk-eint.c                      |    9 +++-
 include/linux/can/platform/sja1000.h                     |    2 -
 include/linux/hugetlb.h                                  |    6 +--
 mm/gup.c                                                 |   13 ++++++
 mm/hugetlb.c                                             |   30 +++++++--------
 net/core/filter.c                                        |    2 +
 sound/soc/soc-ops.c                                      |    9 ++++
 13 files changed, 65 insertions(+), 31 deletions(-)

Baolin Wang (1):
      mm/hugetlb: fix races when looking up a CONT-PTE/PMD size hugetlb page

Charles Keepax (1):
      ASoC: ops: Correct bounds check for second channel on SX controls

Greg Kroah-Hartman (1):
      Linux 5.4.228

Heiko Schocher (1):
      can: sja1000: fix size of OCR_MODE_MASK define

Jialiang Wang (1):
      nfp: fix use-after-free in area_cache_get()

Lorenzo Colitti (1):
      net: bpf: Allow TC programs to call BPF_FUNC_skb_change_head

Mark Brown (1):
      ASoC: ops: Check bounds for second channel in snd_soc_put_volsw_sx()

Ming Lei (1):
      block: unhash blkdev part inode when the part is deleted

Paul E. McKenney (1):
      x86/smpboot: Move rcu_cpu_starting() earlier

Ricardo Ribalda (1):
      pinctrl: meditatek: Startup with the IRQs disabled

Yasushi SHOJI (1):
      can: mcba_usb: Fix termination command argument

