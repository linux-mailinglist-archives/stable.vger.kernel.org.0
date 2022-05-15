Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 174D5527952
	for <lists+stable@lfdr.de>; Sun, 15 May 2022 20:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237337AbiEOStF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 May 2022 14:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238260AbiEOSsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 May 2022 14:48:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E443913D74;
        Sun, 15 May 2022 11:47:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92C39B80E07;
        Sun, 15 May 2022 18:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D766C34117;
        Sun, 15 May 2022 18:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652640468;
        bh=h/9jBZ3KrPLVa1ajOkx+NSsoQ/g3aRNAPHXoiKiuchs=;
        h=From:To:Cc:Subject:Date:From;
        b=fIx8OuO6HyyOB3ZbcySzIWVR4TZIKcRT9y4ygCpefAuQMkrIM4wMs9XdBHI4PKvH+
         2eOCXhRyEYEPutwBWr7s0YtxqGrV+12MBRnb4nejMacDhIoVer5N7Kx6uluJKH6Oz5
         uBChRbPjAmEGCo+gpag8uLU6qX4yWBnWIIgi4wGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.17.8
Date:   Sun, 15 May 2022 20:47:34 +0200
Message-Id: <16526404542247@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.17.8 kernel.

All users of the 5.17 kernel series must upgrade.

The updated 5.17.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.17.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                         |    2 +-
 fs/udf/namei.c                   |    8 ++++----
 include/net/bluetooth/hci_core.h |    3 +++
 include/uapi/linux/rfkill.h      |    2 +-
 mm/gup.c                         |    2 +-
 mm/hugetlb.c                     |    3 ++-
 mm/memory-failure.c              |    4 +++-
 mm/memory.c                      |    2 ++
 mm/migrate.c                     |   14 ++++++++++----
 mm/mlock.c                       |    1 +
 mm/shmem.c                       |    4 +++-
 mm/userfaultfd.c                 |    3 +++
 net/bluetooth/hci_core.c         |    6 +++---
 13 files changed, 37 insertions(+), 17 deletions(-)

Gleb Fotengauer-Malinovskiy (1):
      rfkill: uapi: fix RFKILL_IOCTL_MAX_SIZE ioctl request definition

Greg Kroah-Hartman (1):
      Linux 5.17.8

Huang Ying (1):
      mm,migrate: fix establishing demotion target

Itay Iellin (1):
      Bluetooth: Fix the creation of hdev->name

Jan Kara (1):
      udf: Avoid using stale lengthOfImpUse

Miaohe Lin (1):
      mm/mlock: fix potential imbalanced rlimit ucounts adjustment

Muchun Song (5):
      mm: fix missing cache flush for all tail pages of compound page
      mm: hugetlb: fix missing cache flush in copy_huge_page_from_user()
      mm: hugetlb: fix missing cache flush in hugetlb_mcopy_atomic_pte()
      mm: shmem: fix missing cache flush in shmem_mfill_atomic_pte()
      mm: userfaultfd: fix missing cache flush in mcopy_atomic_pte() and __mcopy_atomic()

Naoya Horiguchi (1):
      mm/hwpoison: fix error page recovered but reported "not recovered"

Peter Xu (1):
      mm: fix invalid page pointer returned with FOLL_PIN gups

