Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21879BF0BA
	for <lists+stable@lfdr.de>; Thu, 26 Sep 2019 13:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbfIZLBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Sep 2019 07:01:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31146 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725870AbfIZLBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Sep 2019 07:01:01 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8QAwp2T088896
        for <stable@vger.kernel.org>; Thu, 26 Sep 2019 07:01:00 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v8sxx6rfj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 26 Sep 2019 07:01:00 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <maier@linux.ibm.com>;
        Thu, 26 Sep 2019 12:00:58 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 26 Sep 2019 12:00:56 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8QB0sUN19529884
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 11:00:54 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C666A4059;
        Thu, 26 Sep 2019 11:00:54 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EA52A4053;
        Thu, 26 Sep 2019 11:00:54 +0000 (GMT)
Received: from oc4120165700.ibm.com (unknown [9.152.96.183])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 26 Sep 2019 11:00:54 +0000 (GMT)
Subject: Re: [PATCH] zfcp: fix reaction on bit error theshold notification
 with adapter close
To:     Sasha Levin <sashal@kernel.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>
References: <20190924160616.15301-1-maier@linux.ibm.com>
 <20190925224305.00183208C3@mail.kernel.org>
From:   Steffen Maier <maier@linux.ibm.com>
Date:   Thu, 26 Sep 2019 13:00:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190925224305.00183208C3@mail.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19092611-0008-0000-0000-0000031B4CA5
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19092611-0009-0000-0000-00004A39E7AD
Message-Id: <77d90d91-68a3-187e-7d5a-114f02a05dea@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-26_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909260104
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/26/19 12:43 AM, Sasha Levin wrote:
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 1da177e4c3f4 Linux-2.6.12-rc2.
> 
> The bot has tested the following trees: v5.3.1, v5.2.17, v4.19.75, v4.14.146, v4.9.194, v4.4.194.
> 
> v5.3.1: Build OK!
> v5.2.17: Build OK!
> v4.19.75: Build OK!
> v4.14.146: Failed to apply! Possible dependencies:
>      75492a51568b ("s390/scsi: Convert timers to use timer_setup()")
> 
> v4.9.194: Failed to apply! Possible dependencies:
>      75492a51568b ("s390/scsi: Convert timers to use timer_setup()")
>      bc46427e807e ("scsi: zfcp: use setup_timer instead of init_timer")
> 
> v4.4.194: Failed to apply! Possible dependencies:
>      75492a51568b ("s390/scsi: Convert timers to use timer_setup()")
>      bc46427e807e ("scsi: zfcp: use setup_timer instead of init_timer")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

It's sufficient to have the fix in those more recent stable trees where it 
applies (and builds). My fixes tag formally indicates since when it was at 
least broken but I don't expect all stable or longterm kernels to get the fix. 
If I happen to find out we need the fix in a kernel where it does not apply, 
I'll send a backport to stable when the time is right.


Showing the possible dependencies is awesome!


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z Development

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Matthias Hartmann
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

