Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F83535E1F0
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 16:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239760AbhDMOyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 10:54:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19754 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240651AbhDMOxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 10:53:52 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13DEXBCF108900;
        Tue, 13 Apr 2021 10:53:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=RUbDQOyOM6w/W77Bif9IovyPB3ZoqwhzAym6d7MrA4I=;
 b=d7kyTPGih8hYm0w6pvJEk/gIF3tZQmnoh0UW2Om/Ykty0kevBPJRs7yUPbajZAKPXZ1/
 qrEalh4wZVioh+XXiy71bDLRYzTlTLL+PJwSPbhmht7EwNJKvIcZr/OKaABTdRJp8g0g
 qHQgkW1H0QpnKItHAZSFKwCP7CuZLuWaGrDg7OWqR5ODLyeCGXyqRSWPJq85hr+SB16u
 R95b7l9ZaiAhEaBkNMP6H1I+7/HU7LasW8M9BkOrYVqeCd1r8Dw8/CxFYjVt+Zqh6exg
 drCc3QQZlRHUCNH4EoEOEtqB0qNGQR0d/KgmUvorxaC48zAzXMd7wXTPy4Mbdsl27Ezt Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37wckq1qt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 10:53:23 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13DEYC4r112699;
        Tue, 13 Apr 2021 10:53:22 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37wckq1qry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 10:53:22 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13DEmVj4015631;
        Tue, 13 Apr 2021 14:53:21 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 37u3n8trx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 14:53:20 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13DErH4948628124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 14:53:18 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEC5352052;
        Tue, 13 Apr 2021 14:53:17 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.85.68.204])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 83C1A52063;
        Tue, 13 Apr 2021 14:53:15 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Tue, 13 Apr 2021 20:23:14 +0530
From:   Vaibhav Jain <vaibhav@linux.ibm.com>
To:     Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc:     linux-nvdimm <linux-nvdimm@lists.01.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>, stable@vger.kernel.org,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>
Subject: Re: [PATCH v3] libnvdimm/region: Update nvdimm_has_flush() to
 handle explicit 'flush' callbacks
In-Reply-To: <CAM9Jb+j6oVumXQ+zmYbQSvQ3UzLKT3V8XLq1SotVcwVuUwP09A@mail.gmail.com>
References: <20210408104622.943843-1-vaibhav@linux.ibm.com>
 <CAM9Jb+j6oVumXQ+zmYbQSvQ3UzLKT3V8XLq1SotVcwVuUwP09A@mail.gmail.com>
Date:   Tue, 13 Apr 2021 20:23:14 +0530
Message-ID: <87r1jejkx1.fsf@vajain21.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4hkap4u2iwZxsgd4l9HNfC8mDykwplO9
X-Proofpoint-GUID: CDcztDluuNg4FI6n_8V9WhnVV3cRE8NO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_08:2021-04-13,2021-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 mlxlogscore=902 spamscore=0
 bulkscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130104
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks Pankaj for looking into this patch,

Pankaj Gupta <pankaj.gupta.linux@gmail.com> writes:

> Hi Vaibhav,
>
>> In case a platform doesn't provide explicit flush-hints but provides an
>> explicit flush callback, then nvdimm_has_flush() still returns '0'
>> indicating that writes do not require flushing. This happens on PPC64
>> with patch at [1] applied, where 'deep_flush' of a region was denied
>> even though an explicit flush function was provided.
>>
>> Similar problem is also seen with virtio-pmem where the 'deep_flush'
>> sysfs attribute is not visible as in absence of any registered nvdimm,
>> 'nd_region->ndr_mappings == 0'.
>
> In case of async flush callback, do we still need "deep_flush" ?

'deep_flush' in libnvdimm (specifically 'deep_flush_store()')
anyways resorts to calling 'async_flush' callback if its defined. Which
makes sense to me since in absence of eADR, 'echo 1 > deep_flush' would
ensure that writes to pmem are now durable even if there is a sudden
power loss before cpu caches are flushed.

On non-nfit architectures the 'async_flush' callback should provide such
a guarantee, which can be triggered by user-space writing to the
'deep_flush' sysfs attr.

In absence of 'deep_flush' sysfs attr not sure how else can user-space
forcibly trigger async_flush callback for dev-dax char devices.

<snip>

-- 
Cheers
~ Vaibhav
