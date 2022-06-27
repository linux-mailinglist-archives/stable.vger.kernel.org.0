Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8FB355CA17
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239171AbiF0Q1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 12:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239159AbiF0Q1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 12:27:33 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3485811A2D;
        Mon, 27 Jun 2022 09:27:33 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RGK3wG027561;
        Mon, 27 Jun 2022 16:27:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=1PkyyAKM5xUD6KWziWY3U/IdUhFROpTUkQhQxL4TtC8=;
 b=Mz+MBPtH8wCBXvMGO0LjPYwhTw4a5jU7cCUbih1rmandDTP/qaJgxab6fm410QxehgEv
 +foH7Xszbu2B4t+B8zmQdKZH1GHRANGTdVYG5DJuYZtb118ZsrPt2rm4GHWrfCkgDrQ2
 0OY3djgA/CIbl7RUHA5A4sbuWcUqjcfuUwejmi+n77R8rtYxrmIQ9ymIeR4pRcPVEEqT
 xODCVu4xsbqw02XHoN5hVwC0bIY9lwYDn8rfQ3N3ZF5fQ9tLwSOO9nasJsGXSQwingfz
 tT7mCV5kT7L4l97utV7GxF422laVZpTyzypbwje7+59LS5Xppm9u4dcZO14yhGJD/rkl aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gyfygr5md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 16:27:20 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25RGKxB4029995;
        Mon, 27 Jun 2022 16:27:19 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gyfygr5k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 16:27:19 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25RGKZ6h010006;
        Mon, 27 Jun 2022 16:27:17 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3gwsmhtfpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 16:27:17 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25RGREJo21758240
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jun 2022 16:27:14 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 513DCAE04D;
        Mon, 27 Jun 2022 16:27:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1B02AE045;
        Mon, 27 Jun 2022 16:27:13 +0000 (GMT)
Received: from osiris (unknown [9.145.37.145])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 27 Jun 2022 16:27:13 +0000 (GMT)
Date:   Mon, 27 Jun 2022 18:27:12 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Baoquan He <bhe@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH 5.18 112/181] vmcore: convert copy_oldmem_page() to take
 an iov_iter
Message-ID: <YrnaYJA675eGIy03@osiris>
References: <20220627111944.553492442@linuxfoundation.org>
 <20220627111947.945731832@linuxfoundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627111947.945731832@linuxfoundation.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jbHePuDC4TMKZpbthmx1x7fcFZdV-tAU
X-Proofpoint-ORIG-GUID: m4mSt00a8yX6nZiBMZZ5kaceg-UiLudF
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_06,2022-06-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 adultscore=0 clxscore=1011
 suspectscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206270068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 01:21:25PM +0200, Greg Kroah-Hartman wrote:
> From: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> [ Upstream commit 5d8de293c224896a4da99763fce4f9794308caf4 ]
> 
> Patch series "Convert vmcore to use an iov_iter", v5.
> 
> For some reason several people have been sending bad patches to fix
> compiler warnings in vmcore recently.  Here's how it should be done.
> Compile-tested only on x86.  As noted in the first patch, s390 should take
> this conversion a bit further, but I'm not inclined to do that work
> myself.
> 
> This patch (of 3):
> 
> Instead of passing in a 'buf' and 'userbuf' argument, pass in an iov_iter.
> s390 needs more work to pass the iov_iter down further, or refactor, but
> I'd be more comfortable if someone who can test on s390 did that work.
> 
> It's more convenient to convert the whole of read_from_oldmem() to take an
> iov_iter at the same time, so rename it to read_from_oldmem_iter() and add
> a temporary read_from_oldmem() wrapper that creates an iov_iter.
> 
> Link: https://lkml.kernel.org/r/20220408090636.560886-1-bhe@redhat.com
> Link: https://lkml.kernel.org/r/20220408090636.560886-2-bhe@redhat.com
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arm/kernel/crash_dump.c     | 27 +++-------------
>  arch/arm64/kernel/crash_dump.c   | 29 +++--------------
>  arch/ia64/kernel/crash_dump.c    | 32 +++----------------
>  arch/mips/kernel/crash_dump.c    | 27 +++-------------
>  arch/powerpc/kernel/crash_dump.c | 35 +++------------------
>  arch/riscv/kernel/crash_dump.c   | 26 +++------------
>  arch/s390/kernel/crash_dump.c    | 13 +++++---
>  arch/sh/kernel/crash_dump.c      | 29 +++--------------
>  arch/x86/kernel/crash_dump_32.c  | 29 +++--------------
>  arch/x86/kernel/crash_dump_64.c  | 41 +++++++-----------------
>  fs/proc/vmcore.c                 | 54 ++++++++++++++++++++------------
>  include/linux/crash_dump.h       |  9 +++---
>  12 files changed, 91 insertions(+), 260 deletions(-)

This one breaks s390. You would also need to apply the following two commits:

cc02e6e21aa5 ("s390/crash: add missing iterator advance in copy_oldmem_page()")
af2debd58bd7 ("s390/crash: make copy_oldmem_page() return number of bytes copied")
