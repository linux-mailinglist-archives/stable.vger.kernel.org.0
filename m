Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8433E3751AB
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 11:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbhEFJlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 05:41:15 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56066 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbhEFJlO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 05:41:14 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1469Nv35144833;
        Thu, 6 May 2021 09:39:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5irk9gSaHYvOafywfiaQ6O0umB/nPBxDjaFdRajuYDU=;
 b=A+akp7mDTpAw4Lqf1hIJU4NAciwDVJfqpQGqDy8Y+jfZRehv1jYZHZBqRHYu+47zkqaE
 4yOvUpr4Bk7FZIw2VHchDBRuAwdOtnMgX1JBzb3Y5cAatsqKNwajIMM2V+bywJT9at6R
 6aKRG1+89pJjNSub5B/CG8JsDlgNuhN/x3X2qdjkmW9gmp4n3NpkvE8b3yvcPZIbR0Rx
 7uVi1d6Yj70Fm4+GoesDWvFRUYI94jlbTiml+RqzCt0vgHHRSCHjY6SA0+iG6zA5hHgP
 uv3Sxn8Qajn9gVNdC218THA+RziUuHjJRIhZ6Tp0vrgRuPeiNnYQ+yeMqrH/bhUKZlr3 nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38begjcc9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 May 2021 09:39:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1469QaiK002604;
        Thu, 6 May 2021 09:39:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 38bebkyncc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 May 2021 09:39:50 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1469doGp056382;
        Thu, 6 May 2021 09:39:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 38bebkync5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 May 2021 09:39:50 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1469dmdG006037;
        Thu, 6 May 2021 09:39:48 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 May 2021 02:39:47 -0700
Date:   Thu, 6 May 2021 12:39:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: handling Fixes tags on rebased trees
Message-ID: <20210506083905.GB1922@kadam>
References: <20210504184635.GT21598@kadam>
 <yq1h7jijnxu.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1h7jijnxu.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: ugBN8cNEYjLTb2DhBcF1MJYhU7fK0aeE
X-Proofpoint-ORIG-GUID: ugBN8cNEYjLTb2DhBcF1MJYhU7fK0aeE
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9975 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 malwarescore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2105060065
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It turns that rebasing without updating the Fixes tag is sort of common.
I wrote a script to find the invalid tags from the last month and have
include the output below.  Two of the patches are in -mm and presumably
Andrew is going fold the Fixes commit into the original commit when
these are sent upstream so those aren't a real issue.

We could probably try catching rebased trees when they are merged in
linux-next?  I'll play with this and see if it works.  But we're going
to end up missing some.  Maybe we need a file with a mapping of rebased
hashes which has something like:

28252e08649f 0df68ce4c26a ("iscv: Prepare ptdump for vm layout dynamic addresses")
42ae341756da d338ae6ff2d8 ("userfaultfd: add minor fault registration mode")

regards,
dan carpenter

#!/usr/bin/perl

open HASHES, '-|', 'git log --since="1 month ago" --grep="Fixes:" --pretty=format:"%h"' or die $@;

my $hash;
while (defined($hash = <HASHES>)) {
    chomp($hash);
    my @commit_msg=`git show --pretty="%b" -s $hash`;

    foreach my $line (@commit_msg) {
        if ($line =~ /^Fixes: ([0-9a-f]*?) /) {
            my $fix_hash = $1;
            if (system("git merge-base --is-ancestor $fix_hash linux-next")) {
                print "$hash $line";
            }
        }
    }
}
close HASHES;

Here is the output, of invalid fixes tag in the last month.

28252e08649f Fixes: e9efb21fe352 ("riscv: Prepare ptdump for vm layout dynamic addresses")
42ae341756da Fixes: f2bf15fb0969 ("userfaultfd: add minor fault registration mode")
eda5613016da Fixes: 5b109cc1cdcc ("hugetlb/userfaultfd: forbid huge pmd sharing when uffd enabled")
85021fe9d800 Fixes: 1ace37b873c2 ("drm/amdgpu/display: Implement functions to let DC allocate GPU memory")
caa93d9bd2d7 Fixes: 855b35ea96c4 ("usb: common: move function's kerneldoc next to its definition")
0f66f043d0dc Fixes: cabcebc31de4 ("cifsd: introduce SMB3 kernel server")
3ada5c1c27ca Fixes: 788b6f45c1d2 ("cifsd: add server-side procedures for SMB3")
0e672f306a28 Fixes: 6788fa154546 ("veth: allow enabling NAPI even without XDP")
aec00aa04b11 Fixes: 830027e2cb55 ("KEYS: trusted: Add generic trusted keys framework")
ef32e0513a13 Fixes: 67982dfa59de ("usb: cdns3: imx: add power lost support for system resume")

