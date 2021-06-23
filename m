Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355E73B22CC
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 23:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhFWVye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 17:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhFWVye (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 17:54:34 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FD3C061574
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 14:52:15 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id g19-20020a9d12930000b0290457fde18ad0so3494676otg.1
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 14:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=iVR+r8HQzHy5O1PM3xuhDev5J423vni/zudDC3lGKRA=;
        b=EG9QhisGSkIyRlGd0ho0fRwwVKFGIxVGsLiI5HBWq8GVel79P0+h/9e99TacyZo4xZ
         yn8IiihrOIQ2a2kVtg+yi+BEJ+R/c3AxHk6BndYBSDJH8Fc6FagDygS//H5imHzWAE4j
         6iGr40xvkPuJKb74WPLlbjzv1dNKqTLcDcpsZbv44oe8xB1IZzvqcO6hH5R6uAJvUJ5/
         nXB25PWpQyutrDyBzjys02Py1EfVCipR6AvV2JFeagXa9noVHxuX/Ebuw0EtAnPtZh4o
         GAkQa+/QFelxaEvJR9pn8S/ocEV1f4DV6+sQ4HCratOFafCX1aHwcyEJGoMDNTbX3f7E
         OHGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=iVR+r8HQzHy5O1PM3xuhDev5J423vni/zudDC3lGKRA=;
        b=gHWVDaXuP1G4aWT9C+EG0YVLB5U9GENxc2IVCOwmH8ZfBsgjq87B926EN73rD4nGbI
         pl0XH4RNxToffT7leJDxly6Rc4qtjl0DWXykWb+K8c+IDUfzZSv1V9AMn+IKQ3L9CLFv
         utUOfQmN3m23wu9Am+bgbsMQQVqS8wLzoeyahrkOqceXME39lR6xbCsOEzMSmVzwtU9m
         +PosE3QtnZEvcLp6xec/1SLmHzNynW7n7H319BhC7F41JXKfA6iFaMT2rs6/i+ksfNSM
         7yo5S787LvBXzWiFKG3OifDB9iLRd2aOGiFDecIjxSnLXCFDbavhHJH/YIPabEBKSmzq
         F8EQ==
X-Gm-Message-State: AOAM53158W9FmzPBrK+CmqKUH/TAm8BXq7T7A9epFhRf4elpxmOrzvVp
        CdaQAxOTf4PRwvbrvbqEJShJvg==
X-Google-Smtp-Source: ABdhPJxflcsHu8fwZdAeCQ3bnPwVapqayk3LmseexRXxzeGSYZSSRHrwozNwFPCUnKy2hsnZmxPv7w==
X-Received: by 2002:a05:6830:23a3:: with SMTP id m3mr1762573ots.142.1624485134978;
        Wed, 23 Jun 2021 14:52:14 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id d136sm235027oib.4.2021.06.23.14.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 14:52:14 -0700 (PDT)
Date:   Wed, 23 Jun 2021 14:52:01 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.anvils
To:     Andrew Morton <akpm@linux-foundation.org>
cc:     Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <shy828301@gmail.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Xu Yu <xuyu@linux.alibaba.com>, Jue Wang <juew@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: mm/thp commits: please wait a few days
In-Reply-To: <20210623134642.2927395a89b1d07bab620a20@linux-foundation.org>
Message-ID: <c2bf7b2-a2d9-95a1-e322-4cf4b8613e9@google.com>
References: <88937026-b998-8d9b-7a23-ff24576491f4@google.com> <YMrU4FRkrQ7AVo5d@kroah.com> <YNNMGjoMajhPNyiK@kroah.com> <ca4d4e0-531-3373-c6ee-a33d379a557c@google.com> <20210623134642.2927395a89b1d07bab620a20@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 23 Jun 2021, Andrew Morton wrote:
> On Wed, 23 Jun 2021 09:44:14 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:
> 
> > > Any word on this?
> > 
> > I have a "matrix" of what's needed ready, but I'm still waiting on
> > "I expect some more to follow in a few days time (thanks Andrew)":
> > I believe akpm does still intend to send them in to Linus for 5.13
> > this week, but they've not gone yet.
> 
> I'm planning on sending these:
> 
> mm-page_vma_mapped_walk-use-page-for-pvmw-page.patch
> mm-page_vma_mapped_walk-settle-pagehuge-on-entry.patch
> mm-page_vma_mapped_walk-use-pmde-for-pvmw-pmd.patch
> mm-page_vma_mapped_walk-prettify-pvmw_migration-block.patch
> mm-page_vma_mapped_walk-crossing-page-table-boundary.patch
> mm-page_vma_mapped_walk-add-a-level-of-indentation.patch
> mm-page_vma_mapped_walk-add-a-level-of-indentation-fix.patch

I expect you'll fold that^ one into the previous before sending.

> mm-page_vma_mapped_walk-use-goto-instead-of-while-1.patch
> mm-page_vma_mapped_walk-get-vma_address_end-earlier.patch
> mm-thp-fix-page_vma_mapped_walk-if-thp-mapped-by-ptes.patch
> mm-thp-another-pvmw_sync-fix-in-page_vma_mapped_walk.patch

mmotm's series shows
mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page.patch
mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page-fix.patch
in the same "mainline-later" grouping, reviewed by Matthew,
acked by tglx, so I was hoping you'd send that along too.

> 
> Linuswards tomorrow.  Is that OK?

That's great, thanks Andrew.  Then when they appear in Linus's tree,
I'll complete my notes and tarball, and mail GregKH in reply here.

Hugh
