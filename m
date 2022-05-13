Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF59526468
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380898AbiEMObi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381278AbiEMObP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:31:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BAE1AB7B4;
        Fri, 13 May 2022 07:29:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5CECB82F64;
        Fri, 13 May 2022 14:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01DEC34100;
        Fri, 13 May 2022 14:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452146;
        bh=z9GmZZIrI8Ekfpz76cjKYYfFFX50TIWlwptiScaqNsM=;
        h=From:To:Cc:Subject:Date:From;
        b=mOGRKufGLiBolgimhTpskiR3XPlvJKrp6cAf14Zr2etUI93gmAXf3d12AAdl6jUDB
         ikcvMmTH5owSndhxseT9Y+OKwp8RoiyxhjB9E2XYIu8N67IV8EeuHIxqMypSzlGV6M
         JW3j3aaq16TNAevsgrA+VGWh62iEvvBCzK/7Il1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.17 00/12] 5.17.8-rc1 review
Date:   Fri, 13 May 2022 16:24:00 +0200
Message-Id: <20220513142228.651822943@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.17.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.17.8-rc1
X-KernelTest-Deadline: 2022-05-15T14:22+00:00
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

This is the start of the stable review cycle for the 5.17.8 release.
There are 12 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.17.8-rc1

Peter Xu <peterx@redhat.com>
    mm: fix invalid page pointer returned with FOLL_PIN gups

Huang Ying <ying.huang@intel.com>
    mm,migrate: fix establishing demotion target

Miaohe Lin <linmiaohe@huawei.com>
    mm/mlock: fix potential imbalanced rlimit ucounts adjustment

Naoya Horiguchi <naoya.horiguchi@nec.com>
    mm/hwpoison: fix error page recovered but reported "not recovered"

Muchun Song <songmuchun@bytedance.com>
    mm: userfaultfd: fix missing cache flush in mcopy_atomic_pte() and __mcopy_atomic()

Muchun Song <songmuchun@bytedance.com>
    mm: shmem: fix missing cache flush in shmem_mfill_atomic_pte()

Muchun Song <songmuchun@bytedance.com>
    mm: hugetlb: fix missing cache flush in hugetlb_mcopy_atomic_pte()

Muchun Song <songmuchun@bytedance.com>
    mm: hugetlb: fix missing cache flush in copy_huge_page_from_user()

Muchun Song <songmuchun@bytedance.com>
    mm: fix missing cache flush for all tail pages of compound page

Jan Kara <jack@suse.cz>
    udf: Avoid using stale lengthOfImpUse

Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
    rfkill: uapi: fix RFKILL_IOCTL_MAX_SIZE ioctl request definition

Itay Iellin <ieitayie@gmail.com>
    Bluetooth: Fix the creation of hdev->name


-------------

Diffstat:

 Makefile                         |  4 ++--
 fs/udf/namei.c                   |  8 ++++----
 include/net/bluetooth/hci_core.h |  3 +++
 include/uapi/linux/rfkill.h      |  2 +-
 mm/gup.c                         |  2 +-
 mm/hugetlb.c                     |  3 ++-
 mm/memory-failure.c              |  4 +++-
 mm/memory.c                      |  2 ++
 mm/migrate.c                     | 14 ++++++++++----
 mm/mlock.c                       |  1 +
 mm/shmem.c                       |  4 +++-
 mm/userfaultfd.c                 |  3 +++
 net/bluetooth/hci_core.c         |  6 +++---
 13 files changed, 38 insertions(+), 18 deletions(-)


