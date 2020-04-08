Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB441A19D7
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 04:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgDHCNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 22:13:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25432 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726416AbgDHCNb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 22:13:31 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03822tkG038499
        for <stable@vger.kernel.org>; Tue, 7 Apr 2020 22:13:30 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30920a4n21-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 22:13:30 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <ajd@linux.ibm.com>;
        Wed, 8 Apr 2020 03:13:04 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 Apr 2020 03:13:03 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0382DNgS42205258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Apr 2020 02:13:23 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB4D952052;
        Wed,  8 Apr 2020 02:13:23 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 69F125204E;
        Wed,  8 Apr 2020 02:13:23 +0000 (GMT)
Received: from [9.206.210.25] (unknown [9.206.210.25])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by ozlabs.au.ibm.com (Postfix) with ESMTPSA id A7FD3A01DF;
        Wed,  8 Apr 2020 12:13:17 +1000 (AEST)
Subject: Re: [PATCH] cxl: Rework error message for incompatible slots
To:     Frederic Barrat <fbarrat@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, christophe_lombard@fr.ibm.com
Cc:     stable@vger.kernel.org
References: <20200407115601.25453-1-fbarrat@linux.ibm.com>
From:   Andrew Donnellan <ajd@linux.ibm.com>
Date:   Wed, 8 Apr 2020 12:13:21 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200407115601.25453-1-fbarrat@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20040802-4275-0000-0000-000003BBAFDC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040802-4276-0000-0000-000038D1125E
Message-Id: <9e4cab1e-aa93-981d-9576-d475c93bb2e7@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_10:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 mlxlogscore=691 adultscore=0 priorityscore=1501 clxscore=1011
 malwarescore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080012
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/4/20 9:56 pm, Frederic Barrat wrote:
> Improve the error message shown if a capi adapter is plugged on a
> capi-incompatible slot directly under the PHB (no intermediate switch).
> 
> Fixes: 5632874311db ("cxl: Add support for POWER9 DD2")
> Cc: stable@vger.kernel.org # 4.14+
> Signed-off-by: Frederic Barrat <fbarrat@linux.ibm.com>

Seems fine to me, not sure if it needs to go to stable but I suppose 
this could be causing actual confusion out in the field?

Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>


-- 
Andrew Donnellan              OzLabs, ADL Canberra
ajd@linux.ibm.com             IBM Australia Limited

