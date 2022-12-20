Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426F76519D9
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 05:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbiLTECP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 23:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233118AbiLTEBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 23:01:22 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999C7389B
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 20:01:16 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id 17so11090798pll.0
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 20:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3i7/epIg3s+Kg1aMbgN7iVzAn5rV9ORpLJbbqj4cTkw=;
        b=yDnv1q8deLFxHxBQNOIR/iufCtokHzMiD1MzZapj25LREJBioDi20wFFxr6jfLaKWo
         7uVB/HDXY0kbxexXHnLj1I1cvVe8f8LjBQnhubnsOLFa90yep2eNTLKrYYrp2ag9WjyN
         fNVLpBcX+Do3+G6w1lldnJb8pHbiJZJBWwaaMcJ+mB9suLe7QAQs9/TrJ1NAcnYp4H65
         R1OM6Ou+FyvXBu/gjOXebVI4gR+yAEc3G+mSfPTQzVfoQJYMkcK8uB5z1jLlEKxRjv+X
         MRoUuthRnZ9Ge1ZA6zkVnEEfJ302ExHTm2Jy/39Kfh/Oq72YCu9PD2oizMD/QOM/5ON9
         8UAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3i7/epIg3s+Kg1aMbgN7iVzAn5rV9ORpLJbbqj4cTkw=;
        b=5MT/2SABbUH2QC8DPlfScoD3wr0FZzZoJjTaqKOcWGcUEomO3wFMySCISoQjTnV6qQ
         9D5v6JeE2RP5NHTOh/EMPhhVx6yY1Nu5elMSZJ2xIcZpv1+mOy+RzpfMyvgJOt6teWfP
         FUJ+hK55Q3KT3dbzMCwPfKL7G+K4piwt5UOOLi6YxqLqFw4ucomgUYyBVNN6Os4KtKaN
         0Kc6Eo2I+nGnwT8KZQlmFgSmTFVW0EOUOBiwSL6MWptdRAKBBdMlWKBKjuSXPt/+tLnE
         pvIC/hcETPKCLnAH6rwMBpTdV4JQ6aVc9ojM1UN5tI0dvmQqDmedYjybeq992PndYR8/
         R36Q==
X-Gm-Message-State: ANoB5pk+LCXAlY8T0b5Tgg35cWveP5KUgCawBhuIKpeE8O+S0oHfoj7U
        TAJ4zI7mc4lmxAyc3a4YBgHY5A==
X-Google-Smtp-Source: AA0mqf63Bp0La3N1p3vEbRqVZRTRw6skueolslB9+Rk3feMRmvq/+KAqiFRLkqu92YSXrsqnI5uzZw==
X-Received: by 2002:a17:902:e193:b0:189:8002:1996 with SMTP id y19-20020a170902e19300b0018980021996mr38673719pla.35.1671508876105;
        Mon, 19 Dec 2022 20:01:16 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902cecb00b0018980f14ecfsm8070483plg.115.2022.12.19.20.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 20:01:15 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p7ToW-00AZBS-Ui; Tue, 20 Dec 2022 15:01:12 +1100
Date:   Tue, 20 Dec 2022 15:01:12 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>, hch@infradead.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.1 13/16] iomap: write iomap validity checks
Message-ID: <20221220040112.GG1971568@dread.disaster.area>
References: <20221220012053.1222101-1-sashal@kernel.org>
 <20221220012053.1222101-13-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220012053.1222101-13-sashal@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 19, 2022 at 08:20:50PM -0500, Sasha Levin wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> [ Upstream commit d7b64041164ca177170191d2ad775da074ab2926 ]
> 
> A recent multithreaded write data corruption has been uncovered in
> the iomap write code. The core of the problem is partial folio
> writes can be flushed to disk while a new racing write can map it
> and fill the rest of the page:
> 
> writeback			new write
> 
> allocate blocks
>   blocks are unwritten
> submit IO
> .....
> 				map blocks
> 				iomap indicates UNWRITTEN range
> 				loop {
> 				  lock folio
> 				  copyin data
> .....
> IO completes
>   runs unwritten extent conv
>     blocks are marked written
> 				  <iomap now stale>
> 				  get next folio
> 				}
> 
> Now add memory pressure such that memory reclaim evicts the
> partially written folio that has already been written to disk.
> 
> When the new write finally gets to the last partial page of the new
> write, it does not find it in cache, so it instantiates a new page,
> sees the iomap is unwritten, and zeros the part of the page that
> it does not have data from. This overwrites the data on disk that
> was originally written.
> 
> The full description of the corruption mechanism can be found here:
> 
> https://lore.kernel.org/linux-xfs/20220817093627.GZ3600936@dread.disaster.area/
> 
> To solve this problem, we need to check whether the iomap is still
> valid after we lock each folio during the write. We have to do it
> after we lock the page so that we don't end up with state changes
> occurring while we wait for the folio to be locked.
> 
> Hence we need a mechanism to be able to check that the cached iomap
> is still valid (similar to what we already do in buffered
> writeback), and we need a way for ->begin_write to back out and
> tell the high level iomap iterator that we need to remap the
> remaining write range.
> 
> The iomap needs to grow some storage for the validity cookie that
> the filesystem provides to travel with the iomap. XFS, in
> particular, also needs to know some more information about what the
> iomap maps (attribute extents rather than file data extents) to for
> the validity cookie to cover all the types of iomaps we might need
> to validate.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This commit is not a standalone backport candidate. It is a pure
infrastructure change that does nothing by itself except to add more
code that won't get executed. There are another 7-8 patches that
need to be backported along with this patch to fix the data
corruption that is mentioned in this commit.

I'd stronly suggest that you leave this whole series of commits to
the XFS LTS maintainers to backport if they so choose to - randomly
backporting commits from the middle of the series only makes their
job more complex....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
