Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08AC524900D
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 23:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHRVZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 17:25:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55260 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725554AbgHRVZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 17:25:53 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07IL1b70131726;
        Tue, 18 Aug 2020 17:25:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uGKVjuTepox1hkrUJadKQr8jHUclT1lem8qgj9dAFzw=;
 b=IGXtA00L6tHnq/lwmVRXGz9cgjmnKztMwy9aYgJPPxcVO/PPEz9PtJFOnr/ISLtYaqzP
 e54XGty8hGJa3bn50skV2CubqYzQ359PSKKg4kgx7aij1XPtumY2qZ0zJi35gbJO8Kve
 2kmMqXTtwg4Uzp5MSGKXAYxow6JtRfk37lCdOzc/5ilS7YYu4ESgLvk5BkxUEtd89HFE
 LApxpD+7CZnw1aJKj9l1FVUM9DPKlqBrGSw+md3lXbIPuqBXv/k/aXL/SzDR5xdtBQR0
 LJLjtlc3+ZmYJ9MVoqcq6tZ0YHYdW+FUC+R1TqSqk70Zd2UM2eVgwifpsmMbMTMcJxK3 Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304rtmhb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 17:25:51 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07IL1doR131812;
        Tue, 18 Aug 2020 17:25:51 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304rtmhas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 17:25:50 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07ILOl5c025601;
        Tue, 18 Aug 2020 21:25:49 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01wdc.us.ibm.com with ESMTP id 3304tkex9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 21:25:49 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07ILPm8N66650466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 21:25:48 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB1FA6E052;
        Tue, 18 Aug 2020 21:25:48 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B4856E050;
        Tue, 18 Aug 2020 21:25:48 +0000 (GMT)
Received: from sbct-3.pok.ibm.com (unknown [9.47.158.153])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 18 Aug 2020 21:25:48 +0000 (GMT)
Subject: Re: FAILED: patch "[PATCH] tpm: Unify the mismatching TPM space
 buffer sizes" failed to apply to 4.14-stable tree
From:   Stefan Berger <stefanb@linux.ibm.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        gregkh@linuxfoundation.org
Cc:     jsnitsel@redhat.com, stable@vger.kernel.org
References: <1597659249143217@kroah.com>
 <20200818153602.GA137059@linux.intel.com>
 <2f57d860-95b8-f4cb-8f3a-2e5078dbc566@linux.ibm.com>
Message-ID: <b77e0d7d-a11e-0edb-224c-91dcf8057a63@linux.ibm.com>
Date:   Tue, 18 Aug 2020 17:25:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <2f57d860-95b8-f4cb-8f3a-2e5078dbc566@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_14:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=0 phishscore=0 spamscore=0
 impostorscore=0 adultscore=0 mlxscore=0 clxscore=1015 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180144
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/18/20 2:54 PM, Stefan Berger wrote:
> On 8/18/20 11:36 AM, Jarkko Sakkinen wrote:
>> Stefan, are you concerned of not having this in 4.14 and 4.19?
>
> Yes. The problematic scenario is when libtpms  is updated to a version 
> (future v0.8.0) that supports 3072 bit RSA keys and software inside a 
> VM is using /dev/tpmrm0 and things start failing because of this. My 
> hope would be that the distro run inside the VM has a way forward and 
> the long term stable kernels seem to help here. Because of this 
> scenario I have to delay the release of libtpms v0.8.0 for several 
> months.
>
I just ported it to 4.19.139 and will try to do the port to 4.14.191++ 
as well. I will post it here once I ran some (basic) tests with it.

    Stefan


