Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9EA13F99E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730202AbgAPTgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:36:53 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51748 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729285AbgAPTgx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 14:36:53 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GJSA7B103088;
        Thu, 16 Jan 2020 19:33:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=+3CiL8o4Ab1hWnW+Bk1R7PIglLbQpoWVfBDqitAc30E=;
 b=hjodwcHNG44e9KM05h9K83TmC2ixqR2EykHwMiDLJSgKuPJEnl4yzs62CSTa6754+8eP
 /ozW6kq4i4WUoMfzN9fb4rALlTuwRusdzplqAOPYxHMesCuCNYK9YM7edrQHZeckbldP
 2xmyHwwRxD70cpnpWucsSPbLhzLI4pm7SUEVsyV2KJk7yqsONTnIaUuH79iKfk4eWG8T
 6T2aQ9wYiBZsjVdd3GA2Vq1nLcloG0CQnZEPO93hG1VMKDeepdGP72Jd3h2aajioqXga
 Mg9JmC3qzuVUlwhLZddqjuWgS1Ld3vjk3Qr1KlB+3gVuNAcnvwYYisHSu1YoSjV+uW1d 3w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xf73yvnej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 19:33:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GJSwAN179955;
        Thu, 16 Jan 2020 19:33:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xhy23wdr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 19:33:02 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00GJX0Nm016627;
        Thu, 16 Jan 2020 19:33:00 GMT
Received: from bostrovs-us.us.oracle.com (/10.152.32.65)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 11:33:00 -0800
Subject: Re: [PATCH] xen/balloon: Support xend-based toolstack take two
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Cc:     Stefano Stabellini <sstabellini@kernel.org>, stable@vger.kernel.org
References: <20200116170004.14373-1-jgross@suse.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <dee2ba34-c39a-9729-8136-463c0daae9d6@oracle.com>
Date:   Thu, 16 Jan 2020 14:32:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200116170004.14373-1-jgross@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160156
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/16/20 12:00 PM, Juergen Gross wrote:
> Commit 3aa6c19d2f38be ("xen/balloon: Support xend-based toolstack")
> tried to fix a regression with running on rather ancient Xen versions.
> Unfortunately the fix was based on the assumption that xend would
> just use another Xenstore node, but in reality only some downstream
> versions of xend are doing that. The upstream xend does not write
> that Xenstore node at all, so the problem must be fixed in another
> way.
>
> The easiest way to achieve that is to fall back to the behavior before
> commit 5266b8e4445c ("xen: fix booting ballooned down hvm guest")
> in case the static memory maximum can't be read.
>
> Fixes: 3aa6c19d2f38be ("xen/balloon: Support xend-based toolstack")
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Cc: <stable@vger.kernel.org> # 4.13

Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>



