Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E60319275
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 19:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhBKSqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 13:46:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47346 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229531AbhBKSqV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 13:46:21 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11BIWCPU020694;
        Thu, 11 Feb 2021 13:45:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=cUMcfW6W91iN2G3Yyw9CCdncpMUjks/XYXMIQxJ7sLk=;
 b=Qs+y4DgvPqlswCDkUjzc8WfyvGh11oZZhQsQRkXE0MgRIzuk9HD7l/ZxLTmecb2aEUHa
 SZKllg9U5pvDDXX/zl9seH4tWqhp2xP3peSbOsZiB8fj6yk6urAkr9gjq54xLbvtpPJN
 KlVICgE37OxKF2p8ONROhIktEkq949SEHKGIMpwwjYfjlwnzMiPeUIGWcXudpcfUU5et
 QQjk31b3a4KNu+t0qY2NyisMExsfx1gj+RRip3IyDpeH9qT4ynfY7ubJCQwDaYlnrrAF
 TJ8aEy3iMMQ792Vq08jrXtyLenVVLLt62Sp8ZFMlclsRQf1Ttby000Tn2b7d+1n9P4ss jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36n9wy8e0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 13:45:29 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11BIWQhE021590;
        Thu, 11 Feb 2021 13:45:29 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36n9wy8e07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 13:45:29 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11BIWkuB024862;
        Thu, 11 Feb 2021 18:45:27 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 36hjr8352g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 18:45:27 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11BIjOFf41550256
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 18:45:24 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 488E442041;
        Thu, 11 Feb 2021 18:45:24 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9168C4203F;
        Thu, 11 Feb 2021 18:45:23 +0000 (GMT)
Received: from osiris (unknown [9.171.6.148])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 11 Feb 2021 18:45:23 +0000 (GMT)
Date:   Thu, 11 Feb 2021 19:45:22 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Chris Down <chris@chrisdown.name>,
        Hugh Dickins <hughd@google.com>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Linux-MM <linux-mm@kvack.org>, Matt Turner <mattst88@gmail.com>,
        mm-commits@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Seth Forshee <seth.forshee@canonical.com>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Tuan Hoang1 <Tuan.Hoang1@ibm.com>
Subject: Re: [patch 09/14] tmpfs: disallow CONFIG_TMPFS_INODE64 on alpha
Message-ID: <YCV7QiyoweJwvN+m@osiris>
References: <20210209134115.4d933d446165cd0ed8977b03@linux-foundation.org>
 <20210209214217.gRa4Jmu1g%akpm@linux-foundation.org>
 <CAHk-=wiDt_eJvfrr-dCXq3eZ+ZmVTD2-rM2pcxBk4d-FM3h-bw@mail.gmail.com>
 <YCPgzb1PhtvfUh9y@osiris>
 <CAHk-=wghVA-6aNQz3rwr5VHmJAHkUvGyzKFpsEN1HPB5SL+aQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wghVA-6aNQz3rwr5VHmJAHkUvGyzKFpsEN1HPB5SL+aQA@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_07:2021-02-11,2021-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=877 mlxscore=0
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 clxscore=1015
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110146
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 10, 2021 at 11:17:10AM -0800, Linus Torvalds wrote:
> On Wed, Feb 10, 2021 at 5:39 AM Heiko Carstens <hca@linux.ibm.com> wrote:
> >
> > I couldn't spot any and also gave the patch below a try and my system
> > still boots without any errors.
> > So, as far as I can tell it _should_ be ok to change this.
> 
> So your patch (with the fix on top) looks sane to me.
> 
> I'm not entirely sure it is worth it, but the fact that we've had bugs
> wrt this before does seem to imply that we should do this.
> 
> I'd remove the __kernel_ino_t type entirely, but I wonder if user
> space might depend on it. I do find
> 
>    #ifndef __kernel_ino_t
>    typedef __kernel_ulong_t __kernel_ino_t;
>    #endif
> 
> in the GNU libc headers I have, but then I don't find any actual use
> of that, so it looks like it may be jyst a "we copied things for other
> reasons".
> 
> On the whole I think this would be the right thing to do, but I'm a
> bit worried that it's more pain that it might be worth.
> 
> Heiko, I think I'll leave this decision entirely to you. If you think
> it's worth it to avoid any possible future pain wrt this odd inode
> number thing for s390, just add it to the s390 tree with my ack.
> Because honestly, I think s390 is the only architecture that really
> cares by now.

So, yes. We will go to change this to hopefully avoid future
problems. The patch is supposed to be part of the next merge
window and converts both s390 and alpha, unless somebody objects.

After that has been merged I'll provide a follow-on patch which
enables TMPFS_INODE64 for alpha and s390 again, and yet another one
which removes __kernel_ino_t as suggested by you.
