Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032701ED481
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 18:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgFCQrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 12:47:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52102 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgFCQrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 12:47:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 053GgA5G044467;
        Wed, 3 Jun 2020 16:46:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Eg9d6vacwIyrZevbw15FEW4vKynitEcnSkjB2tbgA34=;
 b=iUtQWrWBIfkbh8FuyDEDoR6Ir7vkopgagO62XoPuo8w0N3df+rfydYa04X9T9vVNyNyE
 PS5InCWFBfdQO9mwCr+HXQX3lPyJ7HlyU8a7eZcEEeER57b41K5WyGSn0TNqCKkHGKgt
 TPc6wMoK8dLUbvJrDExuDqSSH3s+xiau10UwRNoIDVNMJRWMYSP5TRy7wEm8H4XCyH5p
 XlyUi2FuFkMro4uf0p1kbjhN0WzxBpjPsSq5ppc3t+EgXN+T1aaY/bozI/GfnGN2JQkp
 2yiFL9LhRQfmTI5NNKTaSrXBAcU/JeSHUZ/O+9OuH+ZEWEjRnVHgsOCQTcXaKqwteqEu iw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31bewr2dmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 03 Jun 2020 16:46:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 053GhTHE068011;
        Wed, 3 Jun 2020 16:46:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31c12r5bc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jun 2020 16:46:52 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 053Gkpfb012874;
        Wed, 3 Jun 2020 16:46:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Jun 2020 09:46:50 -0700
Date:   Wed, 3 Jun 2020 09:46:49 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Siddharth Chandrasekaran <siddharth@embedjournal.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Siddharth Chandrasekaran <csiddharth@vmware.com>,
        srostedt@vmware.com, stable@vger.kernel.org, srivatsab@vmware.com,
        dchinner@redhat.com, srivatsa@csail.mit.edu
Subject: Re: [PATCH v2] Backport xfs security fix to 4.9 and 4.4 stable trees
Message-ID: <20200603164649.GL2162697@magnolia>
References: <cover.1589544531.git.csiddharth@vmware.com>
 <20200515152230.GA2599290@kroah.com>
 <20200515155838.GA9039@csiddharth-a01.vmware.com>
 <20200520091800.GA5069@csiddharth-a01.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520091800.GA5069@csiddharth-a01.vmware.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9641 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006030131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9641 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=0 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006030131
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 20, 2020 at 02:48:00PM +0530, Siddharth Chandrasekaran wrote:
> On Fri, May 15, 2020 at 09:28:38PM +0530, Siddharth Chandrasekaran wrote:
> > On Fri, May 15, 2020 at 05:22:30PM +0200, Greg KH wrote:
> > > On Fri, May 15, 2020 at 08:41:07PM +0530, Siddharth Chandrasekaran wrote:
> > > > Hello,
> > > >
> > > > Lack of proper validation that cached inodes are free during allocation can,
> > > > cause a crash in fs/xfs/xfs_icache.c (refer: CVE-2018-13093). To address this
> > > > issue, I'm backporting upstream commit [1] to 4.4 and 4.9 stable trees
> > > > (a backport of [1] to 4.14 already exists).
> > > >
> > > > Also, commit [1] references another commit [2] which added checks only to
> > > > xfs_iget_cache_miss(). In this patch, those checks have been moved into a
> > > > dedicated checker method and both xfs_iget_cache_miss() and
> > > > xfs_iget_cache_hit() are made to call that method. This code reorg in commit
> > > > [1], makes commit [2] redundant in the history of the 4.9 and 4.4 stable
> > > > trees. So commit [2] is not being backported.
> > > >
> > > > -- Sid
> > > >
> > > > [1]: afca6c5b2595 ("xfs: validate cached inodes are free when allocated")
> > > > [2]: ee457001ed6c ("xfs: catch inode allocation state mismatch corruption")
> > > >
> > > > change log:
> > > > v2:
> > > >  - Reword cover letter.
> > > >  - Fix accidental worong patch that got mailed.
> > > 
> > > As the XFS maintainers want to see xfstests pass with any changes made,
> > > have you done so for the 4.9 and 4.4 trees with this patch applied?
> > 
> > I haven't run them yet. I'll do so and get back with the results
> > shortly.
> > 
> Hi Greg,
> 
> I am having some issue setting up my xfstests testing environment. On a
> Ubuntu 20.04 LTS VM, I installed 4.9.223 kernel with this patch applied.
> Then cloned xfstests-dev repository from [1] and setup the test
> environment as explained in the top-level README file. After this, I did
> the following:
> 
>  - Added a new disk (/dev/sdb1) and created 2 partitions of (64 GB each).
>  - Formatted /dev/sdb1 to xfs and dropped a few kernel source tarballs
>    into to it.
>  - Copied local.config.example to local.config and modified it as:
> 	export TEST_DEV=/dev/sdb1
> 	export TEST_DIR=/mnt/t0
> 	export SCRATCH_DEV=/dev/sdb2
> 	export SCRATCH_MNT=/mnt/scratch
>  - Executed: sudo ./check -g all
> 
> When executing the tests, I observed multiple failures. In addition to
> test failures, the testing script just froze after executing some some
> test cases (more frequently test 269) when trying to perform a mount or

There are multiple "test 269"s.  generic/269? xfs/269?

> umount operation on either of the newly added partitions.
> 
> So I presumed the patch was buggy and reverted the change to re try the
> test. Interestingly, that too failed and produced similar results. dmesg
> is filled with xfs errors, with the most frequent being:
> 
>   XFS (dm-0): metadata I/O error: block 0x3 ("xfs_trans_read_buf_map") error 5 numblks 1
> 
> obviously, I must be doing something wrong; I can try to dig deeper
> figure it out myself but wanted to check with you first, if you can spot
> something obviously wrong in what I'm doing.

Dirty open secret of fstests: it's all A/B testing, where "A" involves
running fstests until you've established a baseline of which tests
actually pass on the base of your (4.4 and 4.9) kernels, and which tests
to exclude (e.g. "test 269") because they crash the kernel.

(Please do ask the xfs list about the ones that crash the kernel.)

You might also run the crashing tests on a recent linus release on the
off chance that the test is one of the ones that have been slowly fixed
over the intervening years but are too unwieldly/infrequently-hit of a
patchset to have been auto-backported to stable.

(The shutdown tests like xfs/057, generic/388, and generic/475 come to
mind here.)

Sorry for the slow response, I'm rather overwhelmed these days...

--D

> Thanks!
> 
> -- Sid.
> 
> [1]: https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
