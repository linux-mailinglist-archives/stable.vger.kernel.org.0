Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8999E34C
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 15:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfD2NKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 09:10:36 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55627 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725838AbfD2NKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 09:10:36 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4DEBF22463;
        Mon, 29 Apr 2019 09:10:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 29 Apr 2019 09:10:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=+oZCS3bGOPxJRmLxXMuKtZgi3Q/
        MDu9vEL7d9KM3yxs=; b=jP7HGbPbiw4KwXETXv1K/sui578Xmy1gMoep49ZAVD5
        X/x95H3wy2JdkxNgRW025oOnUSVgFf8wL3mqkHmpHr9C0v4rz05dZxfD9IuLGo15
        +pWmPb6RNFCrSo+br5Z/6DlVDzTQt9s5eNh41c0m6949iZPdgDFCRNQHWpRmZMxC
        eqVqWfCWjnC2fB56YKOCB/ahEaqp/p5FrCvudndbPl9sy/4HOTHVAWygz28kllh0
        nIZpCQWnD+rWHBlc81HLfLJ6mI9NQ6XytqJuv2VmQvwHbZVCJ13aq9+4vTd2BCLD
        qX3RoQ3oWlu0oPyZS3iklrbYh6PntPTOqTy/QC8x7sQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+oZCS3
        bGOPxJRmLxXMuKtZgi3Q/MDu9vEL7d9KM3yxs=; b=dYDk4YaVr0zSmtyehGmEvb
        gtmFir7xncj8abxxEYmmGMYvWGsio8KJyYH9+ZeRhaewh1XRZTVYUPk2ugR9JU9q
        qKUHORp2YonUHIIBYJqXd7J48p0pu6k/IxiwyBQlJbyjOgv7GiFBFp/H1U4ZQg8b
        eouXvy9TawWCRd5h0Fc2yKSOM+FR0GUgSf1gcm6Q6FJUOb0mv9Rsh1cKZDBs6N9P
        mzaNgAADWJfeM7Syw4X1iRwuYCJWE1EBQKSXnMAfPyytDWt+UKOtpcS/fuQzN+Bs
        roz98TyxPtCB+XjHLk/UwmLszbUxjv9zH5RDl1ZSJm2s0t+nhGsjnr9V+mrycU3A
        ==
X-ME-Sender: <xms:yvfGXOAlBoDhoizwDtKm8WlWqMpnoaSYMQZ4dfsAUny2jhUeL9yB9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddriedvgdeiudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvghlrd
    horhhgnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:yvfGXFOsz0Amhj-ueGXe6UuCRrGkteSyY72H6KXiX4eFC9qJ20q3Pw>
    <xmx:yvfGXFfUsH1TbHJHUQHSbjhw43slvFuuyT_dhnX5PIjgTVeMHgbpfg>
    <xmx:yvfGXG6GCjP_E1rnZ8n3EZZ5XmU5Z-6A4ibvmmGekz2AW4ifNI38Yw>
    <xmx:y_fGXJfSmBaMy2u3KkI8zZPfpJWI-lfLIa0hCp-QRMbOAhwmKW9gbg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BC5BF103C8;
        Mon, 29 Apr 2019 09:10:33 -0400 (EDT)
Date:   Mon, 29 Apr 2019 15:10:31 +0200
From:   Greg KH <greg@kroah.com>
To:     Major Hayden <major@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2OIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.0
Message-ID: <20190429131031.GA27296@kroah.com>
References: <cki.25B0CF6A1D.51E5TGYFCX@redhat.com>
 <9b9124c8-faa1-5d31-0e7a-3b7c59d18b28@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b9124c8-faa1-5d31-0e7a-3b7c59d18b28@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 29, 2019 at 07:42:46AM -0500, Major Hayden wrote:
> On 4/29/19 7:38 AM, CKI Project wrote:
> > We ran automated tests on a patchset that was proposed for merging into this
> > kernel tree. The patches were applied to:
> > 
> >        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
> >             Commit: d3da1f09fff2 - Linux 5.0.10
> > 
> > The results of these automated tests are provided below.
> > 
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: FAILED
> > 
> > We attempted to compile the kernel for multiple architectures, but the compile
> > failed on one or more architectures:
> > 
> >              s390x: FAILED (see build-s390x.log.xz attachment)
> > 
> 
> We took another look at this one and the failure seems to be valid after retrying the build. The same issue cropped up both times:
> 
> > 00:02:54   CC [M]  drivers/infiniband/core/uverbs_cmd.o
> > 00:02:54 In file included from ./arch/s390/include/asm/page.h:180,
> > 00:02:54                  from ./arch/s390/include/asm/thread_info.h:26,
> > 00:02:54                  from ./include/linux/thread_info.h:38,
> > 00:02:54                  from ./arch/s390/include/asm/preempt.h:6,
> > 00:02:54                  from ./include/linux/preempt.h:78,
> > 00:02:54                  from ./include/linux/spinlock.h:51,
> > 00:02:54                  from ./include/linux/seqlock.h:36,
> > 00:02:54                  from ./include/linux/time.h:6,
> > 00:02:54                  from ./include/linux/stat.h:19,
> > 00:02:54                  from ./include/linux/module.h:10,
> > 00:02:54                  from drivers/infiniband/core/uverbs_main.c:37:
> > 00:02:54 drivers/infiniband/core/uverbs_main.c: In function 'rdma_umap_fault':
> > 00:02:54 drivers/infiniband/core/uverbs_main.c:897:28: error: 'struct vm_fault' has no member named 'vm_start'
> > 00:02:54    vmf->page = ZERO_PAGE(vmf->vm_start);
> > 00:02:54                             ^~
> > 00:02:54 ./include/asm-generic/memory_model.h:54:40: note: in definition of macro '__pfn_to_page'
> > 00:02:54  #define __pfn_to_page(pfn) (vmemmap + (pfn))
> > 00:02:54                                         ^~~
> > 00:02:54 ./arch/s390/include/asm/page.h:162:29: note: in expansion of macro '__pa'
> > 00:02:54  #define virt_to_pfn(kaddr) (__pa(kaddr) >> PAGE_SHIFT)
> > 00:02:54                              ^~~~
> > 00:02:54 ./arch/s390/include/asm/page.h:166:41: note: in expansion of macro 'virt_to_pfn'
> > 00:02:54  #define virt_to_page(kaddr) pfn_to_page(virt_to_pfn(kaddr))
> > 00:02:54                                          ^~~~~~~~~~~
> > 00:02:54 ./arch/s390/include/asm/pgtable.h:60:3: note: in expansion of macro 'virt_to_page'
> > 00:02:54   (virt_to_page((void *)(empty_zero_page + \
> > 00:02:54    ^~~~~~~~~~~~
> > 00:02:54 drivers/infiniband/core/uverbs_main.c:897:15: note: in expansion of macro 'ZERO_PAGE'
> > 00:02:54    vmf->page = ZERO_PAGE(vmf->vm_start);
> > 00:02:54                ^~~~~~~~~
> > 00:02:54 make[5]: *** [scripts/Makefile.build:277: drivers/infiniband/core/uverbs_main.o] Error 1
> > 00:02:54 make[5]: *** Waiting for unfinished jobs....
> We spotted this recently in mainline as well.

Yeah, a patch to fix this was just submitted upstream, hopefully it
lands soon, or I will pull this out of the tree.

thanks,

greg k-h
