Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7EB1CA007
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 03:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgEHBTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 21:19:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49678 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbgEHBTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 21:19:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0481DGPx117909;
        Fri, 8 May 2020 01:18:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=AGZ///fS0m5w20Fqfh+I54Gq/fVyTBEN4HLztdE+ISs=;
 b=hAqUK078GW0Ymbj+1UqNc8lBF+9AJh9Mo8fiIBEyc4pK7nwzARTIJKdkyA+hmBomKbym
 EodbxvLU2tPcRnRMQN0MzLlYE6JGs80iwTMhWl1SZozd1qUzt9NaCG+Q7ZEEX/WNOBze
 13rNJ+F/v/KYhzU1j3D0aKV4KYO0KihohSX6njL7KODKb/cBWOwzfjS+HFqDecxoEnYW
 aRCI8VS/ZS+wfFlEq7FKC60072IUSL/Xv43hzIIHlZWrZNkQH56NEUvktlCXVSNbnjXg
 y14BNFFGQ+afK3CpUnaRwlAhWi2hvThl+huNcQWXodarl77nX63W9dmCCdm/o/lNEbD2 vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30vtepghva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 01:18:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0481FrSK123056;
        Fri, 8 May 2020 01:16:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30vtdxs6us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 01:16:58 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0481GlB8015047;
        Fri, 8 May 2020 01:16:47 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 18:16:47 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        stable@vger.kernel.org, himanshu.madhani@oracle.com,
        njavali@marvell.com
Subject: Re: [PATCH] scsi: qla2xxx: Do not log message when reading port speed via sysfs
Date:   Thu,  7 May 2020 21:16:44 -0400
Message-Id: <158890041329.32359.10571833651773278265.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504175416.15417-1-emilne@redhat.com>
References: <20200504175416.15417-1-emilne@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=879 phishscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 impostorscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 mlxlogscore=926 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005080008
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 4 May 2020 13:54:16 -0400, Ewan D. Milne wrote:

> Calling ql_log() inside qla2x00_port_speed_show() is causing messages
> to be output to the console for no particularly good reason.  The sysfs
> read routine should just return the information to userspace.  The only
> reason to log a message is when the port speed actually changes, and
> this already occurs elsewhere.

Applied to 5.7/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Do not log message when reading port speed via sysfs
      https://git.kernel.org/mkp/scsi/c/0f3b2f3fb5dc

-- 
Martin K. Petersen	Oracle Linux Engineering
