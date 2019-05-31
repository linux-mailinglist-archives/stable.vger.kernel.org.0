Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA1031071
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 16:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfEaOo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 10:44:58 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51032 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfEaOo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 10:44:57 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4VEiI7M135718;
        Fri, 31 May 2019 14:44:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : in-reply-to :
 references : mime-version : content-type : content-transfer-encoding :
 subject : to : cc : from : message-id; s=corp-2018-07-02;
 bh=2Om5stwDArQ6nGqOb7I9JAkeWMfEhcwW5B4qI7FOiB0=;
 b=cLRCeCwZnlsUocnqR6QzeNTw/ws6EKRiVDGt5QG90Hn/e4KTVGWKirkrucWPvBhFQUvU
 v2Ar9cbIhR0DQteupVsa3sD9gytEUUrem5p0dvpG45c/auWqrWM9jKusfY4jekJ93mPM
 yVU3FV1gKzN4vsWQan5e9Vgx85Gd9wQA6aQQlL84DNBFSEHv9Ld/W9P34Psv3faIHBkz
 tvhl6unPvXR/vg/aPQKcZbYPdRJzzyIWTasj6fIVTo6MESGnsA1rnkdLj49ZQAll+Tj8
 yHdJnQAdKrCaso0uk8lLbIvcYujnVdOybEm18+d0Ml+IVaKBURzuOhPzyk/5UHMOzLjp 7w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2spu7dxyqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 May 2019 14:44:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4VEiTu6146225;
        Fri, 31 May 2019 14:44:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2su61fgc4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 May 2019 14:44:47 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4VEiitL032333;
        Fri, 31 May 2019 14:44:44 GMT
Received: from galaxy-s9.lan (/209.6.36.129)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 31 May 2019 07:44:43 -0700
Date:   Fri, 31 May 2019 10:44:39 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <ba37b50c-c0ac-5af4-441b-a2d4eda81255@suse.com>
References: <20190503150401.15904-1-roger.pau@citrix.com> <f4b944e8-6678-a921-e2b2-aaeb00c0d5e1@suse.com> <ba37b50c-c0ac-5af4-441b-a2d4eda81255@suse.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Xen-devel] [PATCH] xen-blkfront: switch kcalloc to kvcalloc for large array allocation
To:     Juergen Gross <jgross@suse.com>,
        Roger Pau Monne <roger.pau@citrix.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
CC:     Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org, linux-block@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Message-ID: <63D28830-5450-41F5-AC6E-3D5FDE1F80B7@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9273 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905310093
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9273 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905310093
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On May 31, 2019 10:41:16 AM EDT, Juergen Gross <jgross@suse=2Ecom> wrote:
>On 06/05/2019 10:11, Juergen Gross wrote:
>> On 03/05/2019 17:04, Roger Pau Monne wrote:
>>> There's no reason to request physically contiguous memory for those
>>> allocations=2E
>>>
>>> Reported-by: Ian Jackson <ian=2Ejackson@citrix=2Ecom>
>>> Signed-off-by: Roger Pau Monn=C3=A9 <roger=2Epau@citrix=2Ecom>
>>=20
>> Reviewed-by: Juergen Gross <jgross@suse=2Ecom>
>
>Jens, are you going to tkae this patch or should I carry it through the
>Xen tree?

Usually I ended up picking them (and then asking Jens to git pull into his=
 branch) but if you want to handle them that would be much easier!

(And if so, please add Acked-by on them from me)=2E
>
>
>Juergen

