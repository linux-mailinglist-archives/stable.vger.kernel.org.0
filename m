Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629C7422790
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbhJENRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:17:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40194 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234919AbhJENQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 09:16:59 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195D2d5B028113;
        Tue, 5 Oct 2021 09:15:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=YcPwMasfwF+F5ahJ5WUiC3dcoljqGw3M/9Y9awIfOA0=;
 b=hDaYgDrNnqdOmKN272Yp3HNg5pWFLfFS+Nm32rDLSjr3CT4lRAnshu4mGZr87Xell8sz
 j/iu1JXdLNF3UmnXKn9lZAnRtXLdBKoPL2bn2UkjuI7bDiX+3vKVyckd2+MezMqDtVS5
 AWl5Tqss49hqx4TrKts0acgtZSEwVVF9WmXiD5zbR4FiQNOjpC8hCPLxj8Sm+1Yj3SRL
 M9CsretfdTI065pc3rv0CHD7sr9NrrVNo+D8dIoHq2Z43h2AaB12oJePAAekVb/D10m6
 OrnyoalAYrWrltj9M5GzkLAYxFV5I3bEoAx4NmDaCn5Cu+zl7CVuAJFIp2XtRVloAQJy uw== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bgpgg1tet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:15:04 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 195DCcqg018081;
        Tue, 5 Oct 2021 13:15:02 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3bef29rfyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 13:15:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 195DEw5i6160978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 13:14:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0972A4C050;
        Tue,  5 Oct 2021 13:14:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B52934C044;
        Tue,  5 Oct 2021 13:14:57 +0000 (GMT)
Received: from osiris (unknown [9.145.46.219])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  5 Oct 2021 13:14:57 +0000 (GMT)
Date:   Tue, 5 Oct 2021 15:14:56 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     gor@linux.ibm.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] s390: Fix strrchr() implementation
Message-ID: <YVxP0OoUWQvhmqkq@osiris>
References: <20211005120836.60630-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005120836.60630-1-roberto.sassu@huawei.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YjunOCijn3D61qhYcCdGlBQ-H9CG-s0b
X-Proofpoint-GUID: YjunOCijn3D61qhYcCdGlBQ-H9CG-s0b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_02,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 clxscore=1011 impostorscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 adultscore=0 bulkscore=0 spamscore=0 mlxlogscore=856
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050078
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 05, 2021 at 02:08:36PM +0200, Roberto Sassu wrote:
> Fix two problems found in the strrchr() implementation for s390
> architectures: evaluate empty strings (return the string address instead of
> NULL, if '\0' is passed as second argument); evaluate the first character
> of non-empty strings (the current implementation stops at the second).
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Reported-by: Heiko Carstens <hca@linux.ibm.com> (incorrect behavior with empty strings)
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  arch/s390/lib/string.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)

Applied, thanks!
