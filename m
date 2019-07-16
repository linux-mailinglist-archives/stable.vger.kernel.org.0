Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92EC76AAB0
	for <lists+stable@lfdr.de>; Tue, 16 Jul 2019 16:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbfGPOhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 10:37:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44500 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728470AbfGPOhB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jul 2019 10:37:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GEXYKY112082;
        Tue, 16 Jul 2019 14:36:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=V2oWdJ8eUUIozdtQGMQ4u30yDRDXe8sDJDgApZqAsIo=;
 b=j7OitLgR5srHJvmPcSkHMkYZL8yYygWpynrMFlq9G7Ge/Fd2A7/Dt45iFldpDyBAjnlX
 2dbFyZYvSqaALg+YJmTXW7C3E1d9GsBq1HmIrSrhxHLR+ILsoOkevdVxjwdrbop72eQn
 /hlmqtvA1vUtDHJ0puv7pU7WdxxASIR7t7nprBOFI0sP28ctF8LiLVEv68Gija66kIS2
 K+/udIql+A4Bmm4fCv9NjhQEa9Ct+dxDdMhlsK5F8tSV/EKdKM0YOudszY27Ogipaa6N
 ckJu0onJAub3+x0vddiAsEwBfp43uufi3iZaZQjlfM3KFkxDSrtWY+zObvhZpxGCO81A FQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2tq6qtn199-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 14:36:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GEXHsQ077106;
        Tue, 16 Jul 2019 14:36:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2tsctw6nex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 14:36:54 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6GEaqUb027419;
        Tue, 16 Jul 2019 14:36:53 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jul 2019 14:36:52 +0000
To:     Roman Mamedov <rm@romanrm.net>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: Re: [PATCH] libata: Disable queued TRIM for Samsung 860 series SSDs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190714224242.4689a874@natsu> <yq1y30z2ojx.fsf@oracle.com>
        <20190715224215.2186bc8e@natsu>
Date:   Tue, 16 Jul 2019 10:36:48 -0400
In-Reply-To: <20190715224215.2186bc8e@natsu> (Roman Mamedov's message of "Mon,
        15 Jul 2019 22:42:15 +0500")
Message-ID: <yq1blxu11xb.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=960
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907160179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907160179
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Roman,

> I do not have other Samsung (m)SATA models to verify. On the bugreport
> someone confirmed this to be an issue for them too. Let's try asking
> if they have the mSATA model too, and what firmware revision. Mine is
> RVT42B6Q and there were no updates available last time I checked.

I have an mSATA drive arriving today. I'll see if I can come up with a
suitable heuristic to distinguish between mSATA and the other form
factors.

-- 
Martin K. Petersen	Oracle Linux Engineering
