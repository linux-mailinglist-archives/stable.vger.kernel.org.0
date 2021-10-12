Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826D542AF03
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 23:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbhJLVfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 17:35:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29408 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233650AbhJLVe7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 17:34:59 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CL1dgC011071;
        Tue, 12 Oct 2021 17:32:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=JUnRMbIGiZ/Xgfaq8vaBDaKQTXKsUEmJEek4t7qGIxc=;
 b=caXNyOfFfo6II5Cd0Xp5WumawmpOBdU58ymeWU3Ri85+H6iYnNu+ZypYXkXKV+3re7j1
 4xSzFi/DpGfn+x5Zd1tDN1u8vXbfzIbIFL57NQXyfMVMMSrZOgokQs2IKx/8GD+QqkeT
 hMOMF5UcjsjfGx1I8dQFjMuRoOo75OoY2j3rLKChqE6ltCkNtLu2NTqeXDtlGQ8nHJEz
 av4LWYd4nCIY3hzRyBfYT1tXnL+vbu7j9xSQtd9Qrty1cw32DnOqmNJ7KtkFPGPCYq92
 WdsML7G/9HumU2pEhGNYVP8MAgD3/Pan/jibXq76aityrg1MhCCFYLjxD9RayJEDyIoV UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bnhwv8h2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 17:32:56 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19CL9sAX014573;
        Tue, 12 Oct 2021 17:32:56 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bnhwv8h28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 17:32:56 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19CLBXi3016650;
        Tue, 12 Oct 2021 21:32:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3bk2q9tqxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 21:32:54 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19CLWoDb64684474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 21:32:50 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7C5852050;
        Tue, 12 Oct 2021 21:32:50 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.29.112])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 92DCB5204E;
        Tue, 12 Oct 2021 21:32:49 +0000 (GMT)
Date:   Tue, 12 Oct 2021 23:32:47 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Vineeth Vijayan <vneethv@linux.ibm.com>
Cc:     Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, bfu@redhat.com,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [RFC PATCH 1/1]  s390/cio: make ccw_device_dma_* more robust
Message-ID: <20211012233247.63b7a22c.pasic@linux.ibm.com>
In-Reply-To: <13162b9e48402f306b3f50e6686d76a051138a75.camel@linux.ibm.com>
References: <20211011115955.2504529-1-pasic@linux.ibm.com>
        <13162b9e48402f306b3f50e6686d76a051138a75.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kOIB3Bxnl9-AZzRzMeaIwStca8mnSH-O
X-Proofpoint-GUID: 5PMIY8b15ryBHOAdWrvPTNqx85eaQTYB
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_06,2021-10-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 bulkscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 suspectscore=0 mlxlogscore=929 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120113
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 12 Oct 2021 15:36:36 +0200
Vineeth Vijayan <vneethv@linux.ibm.com> wrote:

> Looks good. Thanks.
> Acked-by: Vineeth Vijayan <vneethv@linux.ibm.com>

Can I convince you to upgrade to Reviewed-by?

> 
> Some minor questions below.
> 
> On Mon, 2021-10-11 at 13:59 +0200, Halil Pasic wrote:
> > Since commit 48720ba56891 ("virtio/s390: use DMA memory for ccw I/O
> > and
> > classic notifiers") we were supposed to make sure that
> > virtio_ccw_release_dev() completes before the ccw device and the
> > attached dma pool are torn down, but unfortunately we did
> > not.  Before
> > that commit it used to be OK to delay cleaning up the memory
> > allocated
> > by virtio-ccw indefinitely (which isn't really intuitive for guys
> > used
> > to destruction happens in reverse construction order), but now we
> > trigger a BUG_ON if the genpool is destroyed before all memory
> > allocated
> > form it.  
> allocated from it ?

Yes. And I think I should add "is deallocated." to the end as well,
because we don't destroy memory, we deallocate it ;)

> >  Which brings down the guest. We can observe this problem, when
> > unregister_virtio_device() does not give up the last reference to the
> > virtio_device (e.g. because a virtio-scsi attached scsi disk got
> > removed
> > without previously unmounting its previously mounted  partition).
> > 
> > To make sure that the genpool is only destroyed after all the
> > necessary
> > freeing is done let us take a reference on the ccw device on each
> > ccw_device_dma_zalloc() and give it up on each ccw_device_dma_free().
> > 
> > Actually there are multiple approaches to fixing the problem at hand
> > that can work. The upside of this one is that it is the safest one
> > while
> > remaining simple. We don't crash the guest even if the driver does
> > not
> > pair allocations and frees. The downside is the reference counting
> > overhead, that the reference counting for ccw devices becomes more
> > complex, in a sense that we need to pair the calls to the
> > aforementioned
> > functions for it to be correct, and that if we happen to leak, we
> > leak
> > more than necessary (the whole ccw device instead of just the
> > genpool).
> > 
> > Some alternatives to this approach are taking a reference in
> > virtio_ccw_online() and giving it up in virtio_ccw_release_dev() or
> > making sure virtio_ccw_release_dev() completes its work before
> > virtio_ccw_remove() returns. The downside of these approaches is that
> > these are less safe against programming errors.
> > 
> > Cc: <stable@vger.kernel.org> # v5.3
> > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > Fixes: 48720ba56891 ("virtio/s390: use DMA memory for ccw I/O and
> > classic notifiers")
> > Reported-by: bfu@redhat.com
> > 
> > ---
> > 
> > FYI I've proposed a different fix to this very same problem:
> > https://lore.kernel.org/lkml/20210915215742.1793314-1-pasic@linux.ibm.com/
> > 
> > This patch is more or less a result of that discussion.
> >   
> 

