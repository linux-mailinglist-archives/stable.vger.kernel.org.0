Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 433291A1C53
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 09:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgDHHJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 03:09:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45462 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725763AbgDHHJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 03:09:57 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03874cEg012077
        for <stable@vger.kernel.org>; Wed, 8 Apr 2020 03:09:56 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3091ykjk1e-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 08 Apr 2020 03:09:56 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <fbarrat@linux.ibm.com>;
        Wed, 8 Apr 2020 08:09:35 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 Apr 2020 08:09:32 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03879lG536700220
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Apr 2020 07:09:47 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CD2C42049;
        Wed,  8 Apr 2020 07:09:47 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47AB84204B;
        Wed,  8 Apr 2020 07:09:47 +0000 (GMT)
Received: from pic2.home (unknown [9.145.147.212])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Apr 2020 07:09:47 +0000 (GMT)
Subject: Re: [PATCH] cxl: Rework error message for incompatible slots
To:     Andrew Donnellan <ajd@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, christophe_lombard@fr.ibm.com
Cc:     stable@vger.kernel.org
References: <20200407115601.25453-1-fbarrat@linux.ibm.com>
 <9e4cab1e-aa93-981d-9576-d475c93bb2e7@linux.ibm.com>
From:   Frederic Barrat <fbarrat@linux.ibm.com>
Date:   Wed, 8 Apr 2020 09:09:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <9e4cab1e-aa93-981d-9576-d475c93bb2e7@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20040807-0008-0000-0000-0000036CAA71
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040807-0009-0000-0000-00004A8E46B1
Message-Id: <a7c7dc60-333a-bd20-8632-d1a962c4ef3f@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_10:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=859 bulkscore=0
 clxscore=1015 malwarescore=0 phishscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080052
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 08/04/2020 à 04:13, Andrew Donnellan a écrit :
> On 7/4/20 9:56 pm, Frederic Barrat wrote:
>> Improve the error message shown if a capi adapter is plugged on a
>> capi-incompatible slot directly under the PHB (no intermediate switch).
>>
>> Fixes: 5632874311db ("cxl: Add support for POWER9 DD2")
>> Cc: stable@vger.kernel.org # 4.14+
>> Signed-off-by: Frederic Barrat <fbarrat@linux.ibm.com>
> 
> Seems fine to me, not sure if it needs to go to stable but I suppose 
> this could be causing actual confusion out in the field?


Yes it does. The reason for this patch is it was hit by a customer.

   Fred


> Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>

