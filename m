Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E6A315267
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 16:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhBIPJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 10:09:36 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18858 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230471AbhBIPJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 10:09:34 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 119F5aar176174;
        Tue, 9 Feb 2021 10:08:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=references : from : to :
 cc : subject : in-reply-to : date : message-id : mime-version :
 content-type; s=pp1; bh=8T5q1IPHHnSAQXIhtWIJzipHgDJgeF4dTv3Vm6hNG/A=;
 b=liKey9vbv/cZ0GifvYo/V99ZCad6fUQfIktQKSAeNWRYMIApGh4MEf2rL/fL6uk2S5pw
 Rgj3Q+giUfYZdNatMKKZG+TnTeAATvlEbuSNeDgZ9P+CsmjAOjySdr+ncq14+05h9kYC
 uk2SlNNtvALbJxREo8LVGzJqNCSNU6MBOzTDAhIsO/JcMiIKBU7Alox8MxFYS93fdY4P
 45vrtcwHLd7djOGoqZvrz87hKXmfcg3qy7arPCglAOoE8rmJJSbUgLoqDuq7UVcLKDsA
 7yRRlo5gDpSnJUWhZ4ZRHy54YwFLd3zu2xcfoo+mvftG1zv9sFzGWfNStPpC6brw2RyC WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36kuyqj1xd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 10:08:46 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 119F6CFq180583;
        Tue, 9 Feb 2021 10:08:35 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36kuyqj0pd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 10:08:35 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 119F3Q97010827;
        Tue, 9 Feb 2021 15:08:02 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma05wdc.us.ibm.com with ESMTP id 36hjr979a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 15:08:02 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 119F81GA9568646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Feb 2021 15:08:01 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5510AC05E;
        Tue,  9 Feb 2021 15:08:01 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 726A8AC059;
        Tue,  9 Feb 2021 15:07:59 +0000 (GMT)
Received: from manicouagan.localdomain (unknown [9.80.214.244])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTPS;
        Tue,  9 Feb 2021 15:07:59 +0000 (GMT)
References: <20210208145818.395353822@linuxfoundation.org>
 <20210208145820.464727041@linuxfoundation.org>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Thiago Jung Bauermann <bauerman@linux.ibm.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Roman Gushchin <guro@fb.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Hocko <mhocko@kernel.org>,
        Rik van Riel <riel@surriel.com>,
        Wonhyuk Yang <vvghjk1234@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 051/120] memblock: do not start bottom-up
 allocations with kernel_end
In-reply-to: <20210208145820.464727041@linuxfoundation.org>
Date:   Tue, 09 Feb 2021 12:07:57 -0300
Message-ID: <875z31th2q.fsf@manicouagan.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_03:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 mlxlogscore=673 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 clxscore=1011 impostorscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090079
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> From: Roman Gushchin <guro@fb.com>
>
> [ Upstream commit 2dcb3964544177c51853a210b6ad400de78ef17d ]
>
> With kaslr the kernel image is placed at a random place, so starting the
> bottom-up allocation with the kernel_end can result in an allocation
> failure and a warning like this one:

Not sure if this is ready for stable yet (including stable branches 4.19
and 5.4), since it seems to uncover latent bugs in x86 early memory
reservation. I asked about this issue here:

https://lore.kernel.org/lkml/87ft26yuwg.fsf@manicouagan.localdomain/

-- 
Thiago Jung Bauermann
IBM Linux Technology Center
