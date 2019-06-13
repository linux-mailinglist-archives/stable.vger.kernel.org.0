Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8ABB446DD
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbfFMQzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:55:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55924 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730029AbfFMCMb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 22:12:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5D2928O019486;
        Thu, 13 Jun 2019 02:12:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=eUa9QD44rGFa3SXeWkCq2ilBvEjjv+Vs5jEPU9xYibs=;
 b=K6Xa33zCQIZ6nUTNZHdD0hc5LtaMWVeQ2qdUnSh0v5UZu+rL63vLGCpJMn0vf9nTLBo0
 brpL+v6QbZHJwGzkRrjGTykM9vhZhXji7P0TgV3CsnrKjhXJtYRagf4memtZ/cnIjP9+
 md7p/IaR3bR9DtyfmZN+yWCQTvV5Ma161Q46yZ4PCmeQa6B6fNUWNB+oYyKNiG/9zz3E
 iIXMkAcA+2YEsYT9/OxoE6zbHdMdHS5YsvyZvrz9uZJ5Rb8ZjyyCeVX8dbX8YTD4FQ5W
 qzlKpy9l2NNsCZhofcPzGuND6J8B9Zisto6sTIW4Dyi3g/VOKyjFrbDMfFk/bDj5Fkld Bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2t05nqxp4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jun 2019 02:12:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5D299Yj051134;
        Thu, 13 Jun 2019 02:10:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2t04j07mjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jun 2019 02:10:22 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5D2AJBO020322;
        Thu, 13 Jun 2019 02:10:21 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Jun 2019 19:10:19 -0700
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, linux-ide@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] libata: Extend quirks for the ST1000LM024 drives with NOLPM quirk
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190611143259.28647-1-hdegoede@redhat.com>
        <yq1d0jjeaj6.fsf@oracle.com>
        <be8260f7-cb3c-36b1-22d7-edc6b2657512@redhat.com>
Date:   Wed, 12 Jun 2019 22:10:17 -0400
In-Reply-To: <be8260f7-cb3c-36b1-22d7-edc6b2657512@redhat.com> (Hans de
        Goede's message of "Wed, 12 Jun 2019 07:33:00 +0200")
Message-ID: <yq1pnni1bhy.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9286 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=625
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906130016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9286 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=688 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906130016
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hans,

> Dropping the firmware version sounds reasonable to me. Do you want me to
> send a follow-up patch doing this?

Sure, that'd be great.

-- 
Martin K. Petersen	Oracle Linux Engineering
