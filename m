Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18112993A2
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 18:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1775633AbgJZRVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 13:21:09 -0400
Received: from nautica.notk.org ([91.121.71.147]:35229 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1775598AbgJZRVI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 13:21:08 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2020 13:21:06 EDT
Received: by nautica.notk.org (Postfix, from userid 1001)
        id CD1BFC009; Mon, 26 Oct 2020 18:14:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=codewreck.org; s=2;
        t=1603732465; bh=k+Wgzjav+6/NLtxHMAhXa+c0i5J8LiGwvoX4SQgDuIM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=36ySKFXIu8EOdz4pHiZMhFpfhulw6/kpyKUaUlsF03SPPgyzR5z3w2Hh+ODya4gcG
         f1o6seAenlkngQy4dueVtxStxjTxXli5CV5xYQIWKgdO+wp+KdBSvAVCtZhROk8RvX
         0UIkbhn39BD0qO7sXVudUHVLy8uoOZ3/Lwau59TNJWcYn/ds/8a5x9Sa5WHZbKbfIo
         nGpifs9wJ1KmOviqBozVFTLUgVG2CF87eLO5A/i/84r0YZQiMTZDo7h2U9MFgfyxQc
         VXIg+F/IdyNJ8PO93My3tgSWYV4g/I/20FekHrlUfHX/ACmic1SV8/f8ZjWk3SNGlV
         BglvIky8H/hrw==
Date:   Mon, 26 Oct 2020 18:14:10 +0100
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, ericvh@gmail.com, lucho@ionkov.net,
        viro@zeniv.linux.org.uk, jlayton@kernel.org, idryomov@gmail.com,
        mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-btrfs@vger.kernel.org, clm@fb.com, josef@toxicpanda.com,
        dsterba@suse.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/7] 9P: Cast to loff_t before multiplying
Message-ID: <20201026171410.GA31121@nautica>
References: <20201004180428.14494-1-willy@infradead.org>
 <20201004180428.14494-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201004180428.14494-2-willy@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Matthew Wilcox (Oracle) wrote on Sun, Oct 04, 2020:
> On 32-bit systems, this multiplication will overflow for files larger
> than 4GB.
> 
> Cc: stable@vger.kernel.org
> Fixes: fb89b45cdfdc ("9P: introduction of a new cache=mmap model.")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

I realize I hadn't sent a mail -- FWIW this 9p patch has been merged,
thanks!
-- 
Dominique
