Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B905C1F331E
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 06:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgFIE2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 00:28:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39230 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbgFIE2O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 00:28:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0594QkpE168999;
        Tue, 9 Jun 2020 04:28:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Jt2kiv390E1D+m0oPc+Qsbk4ZBhT+v1fnFnvl4GqKxQ=;
 b=H1O/0E9mi9Fs7ul0NstbE9S6I5duvQclMeEkZjuCm+M+u4KO4cjBVJs7Eks1sWHRW+eB
 p0/Xl8fHi2moN2zCczqy3mgHjRN2NOtqsiP8zYHQ9wQttnxFIvMxvrDwbSSIHEHFQwHa
 Qittgy3dIECCZhRLpcNHzvcgHcB3EdNj4yQxZVkBYMha32ZwFlDr7THBLEFRu7KfcrnZ
 PQOooJRgnd3QuHIoKTeJyfP0pSO+Uq5kIyHn6uc3Cxyb6YmbCU0sn83EubmkKW19SGeW
 vE4n1OZMoxJP7Yhm9qRbyn8veNf1F5xkwK38aU01J1Dg1J3Sib/Ewm7BZlVTJ09AP4SU 3Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31g33m2c56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 09 Jun 2020 04:28:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0594OJMY194136;
        Tue, 9 Jun 2020 04:28:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31gn24qvce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jun 2020 04:28:06 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0594S0JL026608;
        Tue, 9 Jun 2020 04:28:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jun 2020 21:27:59 -0700
Date:   Mon, 8 Jun 2020 21:27:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.7 244/274] xfs: force writes to delalloc
 regions to unwritten
Message-ID: <20200609042758.GQ1334206@magnolia>
References: <20200608230607.3361041-1-sashal@kernel.org>
 <20200608230607.3361041-244-sashal@kernel.org>
 <20200609010727.GN1334206@magnolia>
 <20200609021021.GU1407771@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609021021.GU1407771@sasha-vm>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006090032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 cotscore=-2147483648 malwarescore=0 phishscore=0 mlxscore=0 clxscore=1031
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006090033
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 08, 2020 at 10:10:21PM -0400, Sasha Levin wrote:
> On Mon, Jun 08, 2020 at 06:07:27PM -0700, Darrick J. Wong wrote:
> > On Mon, Jun 08, 2020 at 07:05:37PM -0400, Sasha Levin wrote:
> > > From: "Darrick J. Wong" <darrick.wong@oracle.com>
> > > 
> > > [ Upstream commit a5949d3faedf492fa7863b914da408047ab46eb0 ]
> > > 
> > > When writing to a delalloc region in the data fork, commit the new
> > > allocations (of the da reservation) as unwritten so that the mappings
> > > are only marked written once writeback completes successfully.  This
> > > fixes the problem of stale data exposure if the system goes down during
> > > targeted writeback of a specific region of a file, as tested by
> > > generic/042.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > Err, this doesn't have a Fixes: tag attached to it.  Does it pass
> > fstests?  Because it doesn't look like you've pulled in "xfs: don't fail
> > unwritten extent conversion on writeback due to edquot", which is needed
> > to avoid regressing fstests...
> > 
> > ...waitaminute, that whole series lacks Fixes: tags because it wasn't
> > considered a good enough candidate for automatic backport.
> 
> AUTOSEL doesn't look just at the Fixes tag :)
> 
> > Ummm, does the autosel fstests driver turn on quotas? ;)
> 
> Uh, apparently not :/ Is it okay to just enable it across all tests?

It should be at this point.

> While I go fix that up, would you rather drop the series, or pick up
> 1edd2c055dff ("xfs: don't fail unwritten extent conversion on writeback
> due to edquot")?`

Let's drop it for now, please.  There might be a few more tweaks needed
to get that bit just right.

--D

> -- 
> Thanks,
> Sasha
