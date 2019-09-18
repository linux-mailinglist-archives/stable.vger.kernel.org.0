Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31101B6237
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 13:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbfIRL0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 07:26:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46258 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730065AbfIRL0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 07:26:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IBNoqe146870;
        Wed, 18 Sep 2019 11:26:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=HWlhLi9iPsMBLr+je8pNhoJSs7q0Qb60SYxIVKtsnPU=;
 b=GDFug7GGzN5titq5nHn7hUMIpDOJ8hPTF9cBdWi/TOGQWvNKiaIHwXmljS2Y48a11ERZ
 tDkkumwi4nsJyEW8gg3s4unyzOJVwKjidjwjBk+PNZ753Hge9vMcS56GiPMVW4yAXwag
 y7QBb++LtEWoOWorzDEV6qE387lGMAaQfPtozuCaVLzQRUVXqVoo8eVkoEdEY6E+2rnp
 cM3Srsl/N58OhREXl+4NLJjoJcM8gXlh4202cWCWnSsxuFTKcaKFwGdItmILK7aav0g5
 Sco1lozer+spP0QZ/Z78+OTtNZTfdPUGypMlQy4rkq7QOt8fxaonUN9BzP1M8FlOO8Rk yQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v385du481-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 11:26:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IBOIJQ119055;
        Wed, 18 Sep 2019 11:26:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2v37mmds71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 11:26:26 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8IBQNJs002222;
        Wed, 18 Sep 2019 11:26:23 GMT
Received: from dhcp-10-172-157-168.no.oracle.com (/10.172.157.168)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 04:26:23 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: Stable branches missing ed7a01fd3fd7
From:   =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
In-Reply-To: <20190918111037.GE1894362@kroah.com>
Date:   Wed, 18 Sep 2019 13:26:20 +0200
Cc:     stable-commits@vger.kernel.org, stable@vger.kernel.org,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <2BED7C73-DB59-4002-86E6-296BABE5248E@oracle.com>
References: <880A1006-BF84-4691-8EE1-8E6D111BF09F@oracle.com>
 <20190918111037.GE1894362@kroah.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3445.104.11)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9383 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=841
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9383 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=916 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909180115
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On 18 Sep 2019, at 13:10, Greg Kroah-Hartman =
<gregkh@linuxfoundation.org> wrote:
>=20
> On Wed, Sep 18, 2019 at 11:17:59AM +0200, H=C3=A5kon Bugge wrote:
>> Hi Greg,
>>=20
>>=20
>> Commit 00313983cda6 ("RDMA/nldev: provide detailed CM_ID =
information") is in the following stable releases:
>>=20
>>  stable/linux-4.17.y
>>  stable/linux-4.18.y
>>  stable/linux-4.19.y
>>  stable/linux-4.20.y
>>  stable/linux-5.0.y
>>  stable/linux-5.1.y
>>  stable/linux-5.2.y
>>  stable/linux-5.3.y
>>  stable/master
>=20
> It was part of the 4.17 release, so yes, of course it is in all later
> releases.
>=20
>> It has a potential for a big leak of task_struct's, and if the case =
is hit, the number of task_struct entries in /proc/slabinfo increases =
rapidly.
>>=20
>> The fix, ed7a01fd3fd7 ("RDMA/restrack: Release task struct which was =
hold by CM_ID object"), is in the following stable releases:
>>=20
>>  stable/linux-4.20.y
>>  stable/linux-5.0.y
>>  stable/linux-5.1.y
>>  stable/linux-5.2.y
>>  stable/linux-5.3.y
>>  stable/master
>=20
> It was part of the 4.20 release, so yes, it will be in all releases
> newer than that.
>=20
>> Hence, this commit needs to be included in 4-17..4.19.
>=20
> Given there is only one "active" kernel branch you are looking at =
here,
> that means it should only go into 4.19.y, right?

Yes, you are right. I should have read the collateral first, =
kernel.org/releases.html :-)


Thxs, H=C3=A5kon


