Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8341DD121
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 23:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506146AbfJRVXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 17:23:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40258 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727508AbfJRVXa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 17:23:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9ILABR6058338;
        Fri, 18 Oct 2019 21:23:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=OLasn9jnCtjh59yUq16ttOcSdkeRuAFpSA/vo/81j2U=;
 b=XB7SoyPiH1W/J8Muv9++DVU8/I4eLdn/x8Ju4UbfdU2AADZCX07wDImEk9rBv9tFU+K7
 JiKcnnNEMFGLbr2Lg5uu2Mr0iACT3b/XOQgNpyM7l9xlibnttjEgg2EoqeYyhiR7u1t+
 3Cur8BrAJGObnyC0xTKXY7GKn+KJX/5jzICqPXmvovnAivEfiYCa9myELX5TLTBW2bzM
 4na5nnANjeiVdHBt0w7ynz7ZMMeV0FOqd95C9ZAq1hSRL5ma0PSYZBN+Bay4zyTsIE57
 xTUIVaoaj2wz1/vnQJwbGGF42CKh6/YslYCz8uXa2jFHSygoEIIpAPyG+fs1Xoff7DpF fA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vq0q466xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 21:23:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9ILDe6G179703;
        Fri, 18 Oct 2019 21:23:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vq0dyhk6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 21:23:12 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9ILN2ii002667;
        Fri, 18 Oct 2019 21:23:05 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Oct 2019 21:23:02 +0000
To:     James Smart <james.smart@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Martin George <martin.george@netapp.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Hannes Reinecke <hare@suse.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] lpfc: remove left-over BUILD_NVME defines
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191017150019.75769-1-hare@suse.de> <yq1eezake0f.fsf@oracle.com>
        <0e739a86-a462-9d44-9ef9-24a4488c0d87@broadcom.com>
Date:   Fri, 18 Oct 2019 17:22:59 -0400
In-Reply-To: <0e739a86-a462-9d44-9ef9-24a4488c0d87@broadcom.com> (James
        Smart's message of "Fri, 18 Oct 2019 09:36:02 -0700")
Message-ID: <yq1zhhxhhos.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9414 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=849
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910180187
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9414 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=931 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910180187
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


James,

> I assume that 5.4/scsi-fixes will get merged into 5.4 pre-release,

Yes.

> and that the stable tree will rebase to pick it up ?

stable/master is tracking Linus until final release.

If you want the stats issue fixed in 5.3, it's best to wait for Hannes'
commit to be merged by Linus. You can then request a stable backport.

-- 
Martin K. Petersen	Oracle Linux Engineering
