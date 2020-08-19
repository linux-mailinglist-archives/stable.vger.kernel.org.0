Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426B424A385
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 17:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbgHSPtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 11:49:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33268 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726636AbgHSPtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 11:49:07 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JFW0EJ098082;
        Wed, 19 Aug 2020 11:49:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mrCz55JbBGosTYnHvBkbJJ/5pUPRY2oUXKxdGhFYxrw=;
 b=lMhsIKV+m2yuTjeBdgYZgUx5h0PNh6A6kPoj+blIm4KPPowXA4Lcw6aXtiT/o2pZRk7v
 +nmabHMivcY6a6jTD0VGxynFbWoINzFN2jEshgcsdBUcpAfed9KSqEw+8d++eHi0jGMs
 Tn1GfxuG7oCBgr4jwhPfx6MpXc+qwurGHFd4b1jp+NBLlcWeqQfNg1q4+JvP8cHCnaFW
 bkufT0W1C/NJtFVZ5R1TEciGj3JVhJx1RzLcp3RiHrVfU+SZBnzsCOzK7qlM/4vH0Faz
 X9qItW2tNBwTo42nPEt5lcR4XfCgrplXe5r+/rxH+fefPuf7gEZxQjx9iQ6t6ecJo7E3 zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3313kxqt4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 11:49:07 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07JFa2Ii111471;
        Wed, 19 Aug 2020 11:49:06 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3313kxqt46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 11:49:06 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07JFZiFi012349;
        Wed, 19 Aug 2020 15:49:05 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 3304ccrdnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 15:49:05 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07JFn4mX54591914
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 15:49:04 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9F23112062;
        Wed, 19 Aug 2020 15:49:04 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAA2F112061;
        Wed, 19 Aug 2020 15:49:04 +0000 (GMT)
Received: from sbct-3.pok.ibm.com (unknown [9.47.158.153])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 19 Aug 2020 15:49:04 +0000 (GMT)
Subject: Re: FAILED: patch "[PATCH] tpm: Unify the mismatching TPM space
 buffer sizes" failed to apply to 4.14-stable tree
From:   Stefan Berger <stefanb@linux.ibm.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        gregkh@linuxfoundation.org
Cc:     jsnitsel@redhat.com, stable@vger.kernel.org
References: <1597659249143217@kroah.com>
 <20200818153602.GA137059@linux.intel.com>
 <2f57d860-95b8-f4cb-8f3a-2e5078dbc566@linux.ibm.com>
 <b77e0d7d-a11e-0edb-224c-91dcf8057a63@linux.ibm.com>
Message-ID: <9ed444e7-3866-b132-f0a7-995c29e5d4ba@linux.ibm.com>
Date:   Wed, 19 Aug 2020 11:49:04 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <b77e0d7d-a11e-0edb-224c-91dcf8057a63@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_08:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 clxscore=1015
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190131
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/18/20 5:25 PM, Stefan Berger wrote:
> On 8/18/20 2:54 PM, Stefan Berger wrote:
>> On 8/18/20 11:36 AM, Jarkko Sakkinen wrote:
>>> Stefan, are you concerned of not having this in 4.14 and 4.19?
>>
>> Yes. The problematic scenario is when libtpms  is updated to a 
>> version (future v0.8.0) that supports 3072 bit RSA keys and software 
>> inside a VM is using /dev/tpmrm0 and things start failing because of 
>> this. My hope would be that the distro run inside the VM has a way 
>> forward and the long term stable kernels seem to help here. Because 
>> of this scenario I have to delay the release of libtpms v0.8.0 for 
>> several months.
>>
> I just ported it to 4.19.139 and will try to do the port to 4.14.191++ 
> as well. I will post it here once I ran some (basic) tests with it.

The porting is done and I tested the changes. The problem on these 
kernel versions is that I cannot recreate the problem (inside a VM).

On a host with libtpms-0.8.0 (tip of master) running a VM with attached 
vTPM and the guest running kernel 5.6.18-300.fc2 the following command 
line just hangs:

echo test | clevis encrypt tpm2 '{"key":"rsa"}' | clevis decrypt


dmesg shows:

tpm tpm0: tpm2_save_context: out of backing store

tpm2_commit_space: error -12


On these 4.14 and 4.19 kernels the expected output of 'test' just 
appears on the screen. The context swapping behavior seems to be different.

Though based on the benefits of the larger buffer size that may prevent 
unnecessary problems, if context swapping somehow kicks in, we should 
apply the patches there as well.

    Stefan


