Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D5A24B9B9
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbgHTLyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:54:04 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25645 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730749AbgHTLtb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 07:49:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597924167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9saac307wOKfkkuwU6eXgFAqSu4oqXrr/wJpcDGuHPE=;
        b=fRLGzk05uVsMuEPZ4LIR3C1cLic7LGfKtPtghvorYK1ztmzhxJOl1tNf9Y1czPIeaZPdCX
        f2pE9q8so5dEpOQkIRkc2h7O8vaQy+TnYe7FAeLduc9YuepnXG4IJBX0sxNRJA3wCCQDQV
        Z1S5cbG61iWqFbsUfR1Hej08bkgzwBU=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-oPMS4CnXNr2oA6WiB_CH_w-1; Thu, 20 Aug 2020 07:49:24 -0400
X-MC-Unique: oPMS4CnXNr2oA6WiB_CH_w-1
Received: by mail-pj1-f69.google.com with SMTP id cp23so1069463pjb.9
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 04:49:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9saac307wOKfkkuwU6eXgFAqSu4oqXrr/wJpcDGuHPE=;
        b=uXVXwKIo25jbinQoKuiwfcfuMYWsoK1sScmIupY0cmJtwkqbEGqyrn15PMKmfE+R5w
         W6mbMH+ikdXL445SS6HdL9XNgPBPRVYc1+30MXkTdEqsx4tlS9FkEybf1zM+iYfIJgjF
         rb0ZFNssIDgxdZfq88qDVmA44jsblQfzoEzo9uJ2q1EuClyauYlXXBIxI1MpyTG7lzuF
         qd46KlZfuWDoFq9nRnGGFGzH3jfaV0u90QAGbUUhH+Y7YTacc16hoOiRo02wvFbII/9T
         /KJBtYLVeiT2WU0wd+b2rrO9r2YCxjZTOEvmOHfKy0ioNQAuLNmUCGZ3Qk5uGGTh6jpZ
         rkJA==
X-Gm-Message-State: AOAM533NwzEzSMAxzuwxkNUNMXelRQEYMi5/+wMRu//w97tBMYJfmZtD
        XCOLR/we+xVdPDG67owlDiyjdTNmrt2HR+QkL6bgsC5SbHpGovjPWsbmTrbHdXFc6JyiYnar0Bu
        8WhovrHEGp0SdN2XW
X-Received: by 2002:a17:90a:fca:: with SMTP id 68mr2139387pjz.12.1597924163749;
        Thu, 20 Aug 2020 04:49:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxBjLpZdhtO7F74YwmOts0pQqOWh6y/Tz0vd4MXLA4VdNuTc/QS10DWsZj7Ckm0QBRZGJGSRA==
X-Received: by 2002:a17:90a:fca:: with SMTP id 68mr2139363pjz.12.1597924163438;
        Thu, 20 Aug 2020 04:49:23 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b22sm2671768pfb.52.2020.08.20.04.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 04:49:23 -0700 (PDT)
Date:   Thu, 20 Aug 2020 19:49:11 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Rafael Aquini <aquini@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mm, THP, swap: fix allocating cluster for swapfile by
 mistake
Message-ID: <20200820114911.GA12068@xiangao.remote.csb>
References: <20200820045323.7809-1-hsiangkao@redhat.com>
 <20200820113448.GM17456@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820113448.GM17456@casper.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Matthew,

On Thu, Aug 20, 2020 at 12:34:48PM +0100, Matthew Wilcox wrote:
> On Thu, Aug 20, 2020 at 12:53:23PM +0800, Gao Xiang wrote:
> > SWP_FS is used to make swap_{read,write}page() go through
> > the filesystem, and it's only used for swap files over
> > NFS. So, !SWP_FS means non NFS for now, it could be either
> > file backed or device backed. Something similar goes with
> > legacy SWP_FILE.
> > 
> > So in order to achieve the goal of the original patch,
> > SWP_BLKDEV should be used instead.
> 
> This is clearly confusing.  I think we need to rename SWP_FS to SWP_FS_OPS.
> 
> More generally, the swap code seems insane.  I appreciate that it's an
> inherited design from over twenty-five years ago, and nobody wants to
> touch it, but it's crazy that it cares about how the filesystem has
> mapped file blocks to disk blocks.  I understand that the filesystem
> has to know not to allocate memory in order to free memory, but this
> is already something filesystems have to understand.  It's also useful
> for filesystems to know that this is data which has no meaning after a
> power cycle (so it doesn't need to be journalled or snapshotted or ...),
> but again, that's useful functionality which we could stand to present
> to userspace anyway.
> 
> I suppose the tricky thing about it is that working on the swap code is
> not as sexy as working on a filesystem, and doing the swap code right
> is essentially writing a filesystem, so everybody who's capable already
> has something better to do.

Yeah, I agree with your point. After looking into swap code a bit
(swapfile.c and swap.c), I think such code really needs to be
cleaned up... But I'm lack of motivation about this since I couldn't
guarantee to introduce some new regression and honestly I don't care
much about this piece of code.

Maybe some new projects based on this could help clean up that
as well. :)

Anyway, we really need a quick fix to avoid such FS corruption,
which looks dangerous on the consumer side.

> 
> Anyway, Gao, please can you submit a follow-on patch to rename SWP_FS?

Ok, anyway, that is another stuff and may need some other thread.
I will seek some time to send out a patch for further discussion later.

Thanks,
Gao Xiang

> 

