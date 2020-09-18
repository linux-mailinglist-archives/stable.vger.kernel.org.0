Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A753026FF88
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 16:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIROFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 10:05:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27602 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726392AbgIROFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Sep 2020 10:05:30 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08IE33Vb188245;
        Fri, 18 Sep 2020 10:05:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gHWdIy/8IDcCwJX15zmNuiSysfUY/kf6zvdJBmsQv5c=;
 b=GHhZhM61FWWyOwgfSMm7wpp2QTTV7t5SDQ9CtzR8RPIqnZgTluvzxQ6rKur/No6yGauy
 Q5EkSvPGPS5gkNStZ437yApKNIEWwEd1IuG/NoMqS25mKrIuLapMq0tm2stDe4AYoLcN
 jw95LTfvtjdvGRvAoLFzehE8iJv+iW5oBpT7U69SCAsZibGSaCHI+/kbMQWv+IIgk2ch
 Y9DWTXMBiDJ1vCFBkTLff+LJYc20z+6ntUP26tZvj1Q0+bIIyBnuJ9Co0PrsNTAi0hf+
 Q8daGVvNh0XrmOh5kE0GIrGNGS+UH181OzyS/dDYkCBWsQC/ZaZ6A/0n9Pu/Y++Fsc2a UQ== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33mx72g90h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 10:05:24 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08IE3BIX014217;
        Fri, 18 Sep 2020 14:05:21 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 33mq9mg6r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 14:05:21 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08IE3jNE19399124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 14:03:45 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78D27A405B;
        Fri, 18 Sep 2020 14:05:19 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61DFDA4051;
        Fri, 18 Sep 2020 14:05:18 +0000 (GMT)
Received: from [9.199.45.180] (unknown [9.199.45.180])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 18 Sep 2020 14:05:18 +0000 (GMT)
Subject: Re: [PATCH AUTOSEL 5.4 105/330] ext4: make dioread_nolock the default
To:     Sasha Levin <sashal@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
References: <20200918020110.2063155-1-sashal@kernel.org>
 <20200918020110.2063155-105-sashal@kernel.org>
From:   Ritesh Harjani <riteshh@linux.ibm.com>
Message-ID: <3c7d6caf-00eb-d627-902d-a80f145ea4ce@linux.ibm.com>
Date:   Fri, 18 Sep 2020 19:35:17 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200918020110.2063155-105-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-18_14:2020-09-16,2020-09-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=836
 lowpriorityscore=0 mlxscore=0 impostorscore=0 bulkscore=0 phishscore=0
 clxscore=1031 malwarescore=0 priorityscore=1501 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180110
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Sasha,

On 9/18/20 7:27 AM, Sasha Levin wrote:
> From: Theodore Ts'o <tytso@mit.edu>
> 
> [ Upstream commit 244adf6426ee31a83f397b700d964cff12a247d3 ]
> 
> This fixes the direct I/O versus writeback race which can reveal stale
> data, and it improves the tail latency of commits on slow devices.
> 
> Link: https://lore.kernel.org/r/20200125022254.1101588-1-tytso@mit.edu
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I see that the subjected patch is being taken into many different stable
trees. I remember there was a fixes patch on top of this[1].
Below thread[1] has more details. Just wanted to point this one out.
Please ignore if already taken.

[1]: https://www.spinics.net/lists/linux-ext4/msg72219.html

-ritesh
