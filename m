Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23C7215DEF
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 20:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729670AbgGFSGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 14:06:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53794 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729589AbgGFSGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jul 2020 14:06:17 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 066I2R9g134638;
        Mon, 6 Jul 2020 14:06:14 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32482k1nce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 14:06:14 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 066I45H8142786;
        Mon, 6 Jul 2020 14:06:13 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32482k1nbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 14:06:13 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 066I4ciB002848;
        Mon, 6 Jul 2020 18:06:12 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma05wdc.us.ibm.com with ESMTP id 322hd8se4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 18:06:12 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 066I6Bgq18547158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jul 2020 18:06:11 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 367CF78063;
        Mon,  6 Jul 2020 18:06:11 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4976978064;
        Mon,  6 Jul 2020 18:06:10 +0000 (GMT)
Received: from sbct-3.pok.ibm.com (unknown [9.47.158.153])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  6 Jul 2020 18:06:10 +0000 (GMT)
Subject: Re: [PATCH] tpm: Define TPM2_SPACE_BUFFER_SIZE to replace the use of
 PAGE_SIZE
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Alexey Klimov <aklimov@redhat.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20200702225603.293122-1-jarkko.sakkinen@linux.intel.com>
 <20200702235544.4o7dbgvlq3br2x7e@cantor>
 <20200704035615.GA157149@linux.intel.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
Message-ID: <4f93bca3-e5c2-1074-f273-628ed603c139@linux.ibm.com>
Date:   Mon, 6 Jul 2020 14:06:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200704035615.GA157149@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-06_15:2020-07-06,2020-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 phishscore=0 suspectscore=0 cotscore=-2147483648
 mlxlogscore=820 adultscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007060123
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/3/20 11:56 PM, Jarkko Sakkinen wrote:
> On Thu, Jul 02, 2020 at 04:55:44PM -0700, Jerry Snitselaar wrote:
>> On Fri Jul 03 20, Jarkko Sakkinen wrote:
>>> The size of the buffers for storing context's and sessions can vary from
>>> arch to arch as PAGE_SIZE can be anything between 4 kB and 256 kB (the
>>> maximum for PPC64). Define a fixed buffer size set to 16 kB. This should be
>>> enough for most use with three handles (that is how many we allow at the
>>> moment). Parametrize the buffer size while doing this, so that it is easier
>>> to revisit this later on if required.
>>>
>>> Reported-by: Stefan Berger <stefanb@linux.ibm.com>
>>> Cc: stable@vger.kernel.org
>>> Fixes: 745b361e989a ("tpm: infrastructure for TPM spaces")
>>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>> Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
> Thank you.
>
> Now only needs tested-by from Stefan.


Tested-by: Stefan Berger <stefanb@linux.ibm.com>


>
> /Jarkko


