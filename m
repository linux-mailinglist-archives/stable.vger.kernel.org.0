Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D2C29F154
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 17:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgJ2QZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 12:25:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60102 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725784AbgJ2QYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 12:24:08 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09TG2gqL004783;
        Thu, 29 Oct 2020 12:24:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ASrz/z9De3AZhoeW8eWtUWWv7pwrP18vZYRZR8qsK5s=;
 b=qjOUOzgsCR0lLvAHiyl45LOmC3TVcioIt3tkzQyIzx1j8s8sHD/T9LSKWRk7qCaz9ftd
 M5CTDY1ltjPfARfgISku1EydLH6xJmHoNU5B3f0iaVumeX22WCg0X8iQM8ARVn2LAxBu
 mGwFUPyemRdHv+5nNaZ1fQU6D9r2wWO/NUXnXJ+5fHYU+aXimuyu3EYjpMlXZ9eFaz8P
 r4wZjbNYySSaW+ggLX/OVTSPhs8c6ZVxks5NQT32ufFkOmygQyHcbkZ3tmDnMwRzUjHq
 cQlAQx16BnVoXcx9yI65p8Aom7GxbzFzY8WgUuNVrxBXkfneS5A0CUg8qe2LekTI9dYJ vw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34dcqgsbk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Oct 2020 12:24:01 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09TG8Yki023491;
        Thu, 29 Oct 2020 16:23:56 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 34e56qu54u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Oct 2020 16:23:56 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09TGNsR930278116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 16:23:54 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2B87A4040;
        Thu, 29 Oct 2020 16:23:53 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4CE9A404D;
        Thu, 29 Oct 2020 16:23:52 +0000 (GMT)
Received: from [9.85.83.179] (unknown [9.85.83.179])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 29 Oct 2020 16:23:52 +0000 (GMT)
Subject: Re: v4.4.y broken by "Fix race while processing OPAL dump"
To:     Kamal Mostafa <kamal@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        stable <stable@vger.kernel.org>
References: <20201029150259.30375-1-kamal@canonical.com>
From:   Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Message-ID: <7d12bc74-b737-9ed0-cb48-e394c96e1dcd@linux.vnet.ibm.com>
Date:   Thu, 29 Oct 2020 21:53:52 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201029150259.30375-1-kamal@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-29_08:2020-10-29,2020-10-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 phishscore=0 suspectscore=0 mlxlogscore=950 malwarescore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1011 adultscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010290112
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/29/20 8:32 PM, Kamal Mostafa wrote:
> Hi-
> 
> This commit from v4.4.241 breaks the v4.4.y build for powerpc:
> 
> 217f139551c0 powerpc/powernv/dump: Fix race while processing OPAL dump
> 
> Like this:
> 
> .../arch/powerpc/platforms/powernv/opal-dump.c:409:7: error: void value not ignored as it ought to be
>    dump = create_dump_obj(dump_id, dump_size, dump_type);
>         ^
> 
> 
> The commit descriptions says:
> 
> "... the return value of create_dump_obj() function isn't being used today ..."
> 
> But that's only true for kernels >= v4.19, because they carry this commit:
> 
> b29336c0e178 powerpc/powernv/opal-dump : Use IRQ_HANDLED instead of numbers in interrupt handler
> 
> In v4.4 process_dump(), the only caller of create_dump_obj(), still tries to
> use the return value (see the error above).
> 
> 
> Applying "b29336c0e178 powerpc/powernv/opal-dump : Use IRQ_HANDLED ..." to
> v4.4.y fixes the problem.


Makes sense. Can you please pick above commit as well?

-Vasant
