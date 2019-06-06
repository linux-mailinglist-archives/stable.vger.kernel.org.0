Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85D3F3752A
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 15:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbfFFN0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 09:26:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58718 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfFFN0K (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 09:26:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x56DNd4R038667;
        Thu, 6 Jun 2019 13:26:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=+Mmlxdj1V1YMOrnR4VkSM4eNX0rGFDdXYJljRNOAD7U=;
 b=IImgjTpu4sPpuL9Q1RMaJQZxNk52Ww4kdzwLOqwFlDiiSJZYYfMAs0wi/8VRZZqd0fOa
 JkUyyF5Ts8Ec5FSCkXH5Cng7Y7rC5OZYZEQCB1CFVkCXP1B33xpTfSQh3TUlOUPT5Aho
 lbqyG1Ln11ZYSck/urswGU71r7gVROjWn7dygebRJV04MN1ZyqNhqAHSVwFEGH1Mq8IP
 g/NaTIpD7TJ+fBzbB1wGjSwAzrXETfa1LDWpah6jC+9QkKJYESqsgoQWXrLlP1wcgmZj
 txUOiUYGmIDIlfd5AZ4IaZvvCW3NXsHaqx069OJdv3YwOm5D/cl+lswqhZOg8+wgYNDF 2g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2sugstree1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 13:26:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x56DN71T070621;
        Thu, 6 Jun 2019 13:24:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2swnharfy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 13:24:07 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x56DO6Tk001707;
        Thu, 6 Jun 2019 13:24:06 GMT
Received: from anon-dhcp-171.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Jun 2019 06:24:06 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH RFC] svcrdma: Ignore source port when computing DRC hash
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20190606130804.19EE32070B@mail.kernel.org>
Date:   Thu, 6 Jun 2019 09:24:04 -0400
Cc:     linux-rdma@vger.kernel.org,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BD1CF3FF-887A-4204-AE3F-D48D51442E70@oracle.com>
References: <20190605121518.2150.26479.stgit@klimt.1015granger.net>
 <20190606130804.19EE32070B@mail.kernel.org>
To:     Sasha Levin <sashal@kernel.org>
X-Mailer: Apple Mail (2.3445.104.11)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9279 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906060096
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9279 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906060096
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Jun 6, 2019, at 9:08 AM, Sasha Levin <sashal@kernel.org> wrote:
>=20
> Hi,
>=20
> [This is an automated email]
>=20
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: =
all
>=20
> The bot has tested the following trees: v5.1.7, v5.0.21, v4.19.48, =
v4.14.123, v4.9.180, v4.4.180.
>=20
> v5.1.7: Build OK!
> v5.0.21: Build OK!
> v4.19.48: Build OK!
> v4.14.123: Build OK!
> v4.9.180: Build failed! Errors:
>    net/sunrpc/xprtrdma/svc_rdma_transport.c:712:2: error: implicit =
declaration of function =E2=80=98rpc_set_port=E2=80=99; did you mean =
=E2=80=98rpc_net_ns=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>=20
> v4.4.180: Build failed! Errors:
>    net/sunrpc/xprtrdma/svc_rdma_transport.c:635:2: error: implicit =
declaration of function =E2=80=98rpc_set_port=E2=80=99; did you mean =
=E2=80=98rpc_net_ns=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>=20
>=20
> How should we proceed with this patch?

If the review completes without objection, I will resubmit
this patch with an updated Cc: . Thanks for testing!

--
Chuck Lever



