Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904C52CF187
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 17:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgLDQFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 11:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbgLDQFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 11:05:34 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6364C0613D1
        for <stable@vger.kernel.org>; Fri,  4 Dec 2020 08:04:53 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id v143so5862140qkb.2
        for <stable@vger.kernel.org>; Fri, 04 Dec 2020 08:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t0GCmJXgaqj4UXo3UFBFtaMB4ClFHGw5pCLgLGBtmZQ=;
        b=KLtoAV9IAem35cnxS9GOLj3tKU9CiXNaFVjcdnv/3irI1S7qPEmZMX6xJw6l2Vwz/g
         1M/f1B6XM+eJK1OkWwnXpczProXkASFPpuYD3mgAg50qImcxnaoLhYvUOssCAo+Blc33
         aaCV1NbtiAmavvO9eHpxXDG6gDPlt+zKqHBeQFui9gKIOzfBrbzSM28SeDqbzAQg0kAB
         nu+QQKP3iTlatfydG4ko6auwEpHf+uSbDYK/yCLVdZ0kY4TIwgBz60idtBjPY0q8EgRd
         m0EVSYVmzFeEULgbtQV4OFiLcVjlOv62xO7+D7SDgtFOLSMs4LJoFGmgZfW7CdsMhJVE
         f+dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t0GCmJXgaqj4UXo3UFBFtaMB4ClFHGw5pCLgLGBtmZQ=;
        b=FCJXEtNLFfLC2szX6mqQgDuW1g2aucsWoQikupblifqmNHT7xtHmrNdPAaABrOyeXv
         9IHcsLbAN50MKlbQHx5glCx/JeS07GL2RtvYL8eiseaa24pzPH3JFIZ55tBxGecK8OH9
         +fGgwiaM5Cj8mml/L6pxfoKDb0vAdIVLeSl+Z3TTdmM80/ljK34QU+Z18Mbb84eC0MAA
         vb0AEYSmxaow/Ff+8CYQiCPbVta1rlMMm3dleKXZaHinpX7Uk/fYkgsUfYlouQUF/EWB
         iPn7ckaqe/Pxe3HS281iyIqHb+3SSnyxPlihi9K43nTQg6ddNLfSGyjiKYgAlaCpSOFG
         IHXg==
X-Gm-Message-State: AOAM5335DVeINYNo2P+sr1nG1WdWqQefrrst57uwskLn4j/yxzs0moRw
        Ik7pov92WQq97V3yrM0NFLUD6g==
X-Google-Smtp-Source: ABdhPJxvFR4PO1GXMK5tgLDtHDnkm5Haqc/tcb8xV0C4LLeKYdLthYihVjco8s/ed2WrWilWaBRdpw==
X-Received: by 2002:a37:9d04:: with SMTP id g4mr9419563qke.358.1607097893205;
        Fri, 04 Dec 2020 08:04:53 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id r8sm5650266qtj.94.2020.12.04.08.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 08:04:52 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1klDZj-005vUb-9w; Fri, 04 Dec 2020 12:04:51 -0400
Date:   Fri, 4 Dec 2020 12:04:51 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     David Hildenbrand <david@redhat.com>,
        Liu Zixian <liuzixian4@huawei.com>, akpm@linux-foundation.org,
        linmiaohe@huawei.com, louhongxiang@huawei.com, linux-mm@kvack.org,
        hushiyuan@huawei.com, stable@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2] fix mmap return value when vma is merged after
 call_mmap()
Message-ID: <20201204160451.GC5487@ziepe.ca>
References: <20201203085350.22624-1-liuzixian4@huawei.com>
 <d59e9e5a-1d6e-e7dc-21ec-17777fe9f7a2@redhat.com>
 <20201204151028.GZ5487@ziepe.ca>
 <20201204152535.GP11935@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204152535.GP11935@casper.infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 04, 2020 at 03:25:35PM +0000, Matthew Wilcox wrote:

> This commit makes no sense.  I know it's eight years old, so maybe the
> device driver which did this has long been removed from the tree, but
> davem's comment was (iirc) related to a device driver for a graphics
> card that would 256MB-align the user address.  Another possibility is
> that userspace always asks for a 256MB-aligned address these days.

Presumably the latter, otherwise people would be complaining about the
WARN_ON.

With some grep I could only find this:

static int mc68x328fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
{
#ifndef MMU
        /* this is uClinux (no MMU) specific code */

        vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
        vma->vm_start = videomemory;

        return 0;
#else
        return -EINVAL;
#endif
}

So it does seem gone

> I don't understand why prev/rb_link/rb_parent would need to be changed
> in this case.  It's going to be inserted at the exact same location in
> the rbtree, just at a slightly shifted address.

If the driver adjust the address, and it doesn't collide with another
vma, and it doesn't change the tree position, then it could work

But if the driver radically changes the vm_start all bets are off and
you end up with an unsorted rb_tree at worst.

Banning drivers from adjusting the vm_start/end makes sense to me, at
least. How could a driver do this correctly anyhow?

Jason
