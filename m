Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E18A1F3149
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 03:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388196AbgFIBHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 21:07:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58926 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbgFIBHl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 21:07:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0590uv8R173360;
        Tue, 9 Jun 2020 01:07:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=IpEVVM0bj8zg9b7eJM0DwMCx4bTSNKHFjqpG8b9CCvg=;
 b=jw6AFzibkdY0HIZu9DeavIDwExXpfTitqONPy/3YBycUFPgWq9HZddTXr+1ixVcYgvUO
 bIeANndRdJ1dt2sYAj2brqgKI49ReS2ovmcUgUgHj/E+a6IiVgmFgnnrGb6vo8fi7Ijo
 ovAiA7c9mIfAenoc0QEKa0rv1JvvWSptfQLHeM+uEVbiGXke8uonm5Tuup7AuoWp8p7R
 uyr4QsHX08tVE9+lVztidOBlRwGAD1DLzOyfDMJSyy2bX0fjKBH55D/H9tjb0y2tilCB
 YxyfR+gqU3Wd9rZCcoU6fYz14S8TVkHkDGoaW+BkB9BU2lMJa8x8XXy/A1fY0sqtAc1w Jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31g3smsqvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 09 Jun 2020 01:07:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05913fGU016868;
        Tue, 9 Jun 2020 01:07:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31gn2vx6cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jun 2020 01:07:29 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05917TFM022951;
        Tue, 9 Jun 2020 01:07:29 GMT
Received: from localhost (/10.159.129.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jun 2020 18:07:28 -0700
Date:   Mon, 8 Jun 2020 18:07:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.7 244/274] xfs: force writes to delalloc
 regions to unwritten
Message-ID: <20200609010727.GN1334206@magnolia>
References: <20200608230607.3361041-1-sashal@kernel.org>
 <20200608230607.3361041-244-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608230607.3361041-244-sashal@kernel.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006090005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=1
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1031 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006090004
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 08, 2020 at 07:05:37PM -0400, Sasha Levin wrote:
> From: "Darrick J. Wong" <darrick.wong@oracle.com>
> 
> [ Upstream commit a5949d3faedf492fa7863b914da408047ab46eb0 ]
> 
> When writing to a delalloc region in the data fork, commit the new
> allocations (of the da reservation) as unwritten so that the mappings
> are only marked written once writeback completes successfully.  This
> fixes the problem of stale data exposure if the system goes down during
> targeted writeback of a specific region of a file, as tested by
> generic/042.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Err, this doesn't have a Fixes: tag attached to it.  Does it pass
fstests?  Because it doesn't look like you've pulled in "xfs: don't fail
unwritten extent conversion on writeback due to edquot", which is needed
to avoid regressing fstests...

...waitaminute, that whole series lacks Fixes: tags because it wasn't
considered a good enough candidate for automatic backport.

Ummm, does the autosel fstests driver turn on quotas? ;)

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index fda13cd7add0..f8fe83c9348d 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4193,17 +4193,7 @@ xfs_bmapi_allocate(
>  	bma->got.br_blockcount = bma->length;
>  	bma->got.br_state = XFS_EXT_NORM;
>  
> -	/*
> -	 * In the data fork, a wasdelay extent has been initialized, so
> -	 * shouldn't be flagged as unwritten.
> -	 *
> -	 * For the cow fork, however, we convert delalloc reservations
> -	 * (extents allocated for speculative preallocation) to
> -	 * allocated unwritten extents, and only convert the unwritten
> -	 * extents to real extents when we're about to write the data.
> -	 */
> -	if ((!bma->wasdel || (bma->flags & XFS_BMAPI_COWFORK)) &&
> -	    (bma->flags & XFS_BMAPI_PREALLOC))
> +	if (bma->flags & XFS_BMAPI_PREALLOC)
>  		bma->got.br_state = XFS_EXT_UNWRITTEN;
>  
>  	if (bma->wasdel)
> @@ -4611,8 +4601,23 @@ xfs_bmapi_convert_delalloc(
>  	bma.offset = bma.got.br_startoff;
>  	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLEN);
>  	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
> +
> +	/*
> +	 * When we're converting the delalloc reservations backing dirty pages
> +	 * in the page cache, we must be careful about how we create the new
> +	 * extents:
> +	 *
> +	 * New CoW fork extents are created unwritten, turned into real extents
> +	 * when we're about to write the data to disk, and mapped into the data
> +	 * fork after the write finishes.  End of story.
> +	 *
> +	 * New data fork extents must be mapped in as unwritten and converted
> +	 * to real extents after the write succeeds to avoid exposing stale
> +	 * disk contents if we crash.
> +	 */
> +	bma.flags = XFS_BMAPI_PREALLOC;
>  	if (whichfork == XFS_COW_FORK)
> -		bma.flags = XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
> +		bma.flags |= XFS_BMAPI_COWFORK;
>  
>  	if (!xfs_iext_peek_prev_extent(ifp, &bma.icur, &bma.prev))
>  		bma.prev.br_startoff = NULLFILEOFF;
> -- 
> 2.25.1
> 
