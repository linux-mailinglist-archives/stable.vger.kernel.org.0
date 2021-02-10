Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A89316CA1
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 18:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhBJR26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 12:28:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26524 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232107AbhBJR25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 12:28:57 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11AHCJtK028363;
        Wed, 10 Feb 2021 12:27:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=jAhH+RYwYlrxGzHNekfUXPMbLIQjGPrR85OXciJb3wI=;
 b=NYgw1QYuq3o8j5qGADRMceXntV35aPf2D99Lp/8bAnzzB/REE3Sa3xmwL+XSFtYQfvje
 FldBoHDC2LaAhvHO41+aGbQWwyULT/D0GKoFtdeTCT7PqDfJms8N1QfGJodH+N0e2bfJ
 fIAxAzOk6uYeLFwp+Ff7jfDRQUItEA1VAimwELX05GW9vZ8y4H4kHAwUPxfIFfEByCiB
 DQEXBlnUuCHCHYimwH4Qc/Hqo9at2iFVA4SCc6Bp8xzKsArYm9uJpmQwNXBp9OJZl8HO
 G/F8xYQDDYCbIHPZ8xCmbLd1jAVjC6bm9B3ln4E8fRvH1efR/8nsCULdPfJ3MM7S00xV CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36mkp58gk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 12:27:58 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11AHEYW9042809;
        Wed, 10 Feb 2021 12:27:58 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36mkp58gje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 12:27:57 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11AHRuCS004643;
        Wed, 10 Feb 2021 17:27:56 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 36hjr8am4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 17:27:55 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11AHRgRl27525476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 17:27:42 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A866D11C05B;
        Wed, 10 Feb 2021 17:27:52 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E842111C04A;
        Wed, 10 Feb 2021 17:27:51 +0000 (GMT)
Received: from osiris (unknown [9.171.5.38])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 10 Feb 2021 17:27:51 +0000 (GMT)
Date:   Wed, 10 Feb 2021 18:27:50 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <YCQXllnwOtTaak6g@osiris>
References: <20210209134115.4d933d446165cd0ed8977b03@linux-foundation.org>
 <20210209214217.gRa4Jmu1g%akpm@linux-foundation.org>
 <CAHk-=wiDt_eJvfrr-dCXq3eZ+ZmVTD2-rM2pcxBk4d-FM3h-bw@mail.gmail.com>
 <YCPgzb1PhtvfUh9y@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCPgzb1PhtvfUh9y@osiris>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_06:2021-02-10,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=836 mlxscore=0
 clxscore=1015 impostorscore=0 suspectscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100153
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 10, 2021 at 02:34:08PM +0100, Heiko Carstens wrote:
> diff --git a/include/linux/types.h b/include/linux/types.h
> index a147977602b5..1e9d0a2c1dba 100644
> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -14,7 +14,7 @@ typedef u32 __kernel_dev_t;
>  
>  typedef __kernel_fd_set		fd_set;
>  typedef __kernel_dev_t		dev_t;
> -typedef __kernel_ino_t		ino_t;
> +typedef __kernel_ulong_t	ino_t;
>  typedef __kernel_mode_t		mode_t;
>  typedef unsigned short		umode_t;
>  typedef u32			nlink_t;
> @@ -189,7 +189,11 @@ struct hlist_node {
>  
>  struct ustat {
>  	__kernel_daddr_t	f_tfree;
> -	__kernel_ino_t		f_tinode;
> +#ifdef ARCH_HAS_32BIT_F_TINODE
> +	unsigned int		f_tinode;
> +#else
> +	unsigned long		f_tinode;
> +#endif

Of course that should have been CONFIG_ARCH_32BIT_USTAT_F_TINODE in
order to not break the existing ABI for alpha and s390.
