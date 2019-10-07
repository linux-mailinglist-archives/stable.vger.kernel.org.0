Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F61FCEEED
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 00:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729465AbfJGWOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 18:14:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37062 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728654AbfJGWOI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 18:14:08 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x97LwWjW140478;
        Mon, 7 Oct 2019 18:13:05 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vg9h81far-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Oct 2019 18:13:04 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x97MAt9w016380;
        Mon, 7 Oct 2019 22:13:03 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 2vejt6meww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Oct 2019 22:13:03 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x97MD2VT58065340
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Oct 2019 22:13:02 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A58AC60B2;
        Mon,  7 Oct 2019 22:13:02 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF4BFC60B7;
        Mon,  7 Oct 2019 22:13:01 +0000 (GMT)
Received: from [9.2.202.93] (unknown [9.2.202.93])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  7 Oct 2019 22:13:01 +0000 (GMT)
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "Safford, David (GE Global Research, US)" <david.safford@ge.com>
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190926171601.30404-1-jarkko.sakkinen@linux.intel.com>
 <1570024819.4999.119.camel@linux.ibm.com>
 <20191003114119.GF8933@linux.intel.com>
 <1570107752.4421.183.camel@linux.ibm.com>
 <20191003175854.GB19679@linux.intel.com>
 <1570128827.5046.19.camel@linux.ibm.com>
 <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A22E@ALPMBAPA12.e2k.ad.ge.com>
 <20191004182711.GC6945@linux.intel.com>
 <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A38B@ALPMBAPA12.e2k.ad.ge.com>
 <20191007000520.GA17116@linux.intel.com>
From:   Ken Goldman <kgold@linux.ibm.com>
Message-ID: <59b88042-9c56-c891-f75e-7c0719eb5ff9@linux.ibm.com>
Date:   Mon, 7 Oct 2019 18:13:01 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191007000520.GA17116@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-07_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=882 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910070196
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The TPM library specification states that the TPM must comply with NIST 
SP800-90 A.

https://trustedcomputinggroup.org/membership/certification/tpm-certified-products/

shows that the TPMs get third party certification, Common Criteria EAL 4+.

While it's theoretically possible that an attacker could compromise
both the TPM vendors and the evaluation agencies, we do have EAL 4+ 
assurance against both 1 and 2.

On 10/6/2019 8:05 PM, Jarkko Sakkinen wrote:
> 
> Kernel has the random number generator for two reasons:
> 
> 1. To protect against bugs in hwrng's.
> 2. To protect against deliberate backdoors in hwrng's.
> 
> How TPM RNG is guaranteed to protect against both 1 and 2?

