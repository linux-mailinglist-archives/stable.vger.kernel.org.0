Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE22E518A68
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 18:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239858AbiECQvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 12:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239852AbiECQve (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 12:51:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2323F3969F;
        Tue,  3 May 2022 09:48:01 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 243GjgMr003403;
        Tue, 3 May 2022 16:47:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CxVsWtTvFkYal173lcotmZNmg84/NZG0ajF0yqrAyQI=;
 b=ExADnrR2O80MeWVSBUVg7ZXHTnl8hCtGbKukI3kGivcX2jh/x+uMavdFMMidyhKCVVgy
 xWy0rp0d0DScy1EUhwZ1BCktg0HvzGUMdn/v9iB18nVjcXiUx2GddwEC4RdCfmXRaU31
 23OKu2z8ia+20KkERevScWLbeuGNR1j4KCT4dLGFg6gvNhG5ap2mdVRHSDxhznr4Ony3
 23tYg6Ggee6UPsVYlIP+zLJ0xpRGMPei0TzUAZwsP+09PvCho416WY+VA/E47kA1xtD+
 5H/MyjkNKLxJq63/dXZRjES5C50VSW2DRV2z3afe8yzaZoSAmsmtac89NtCvhMiWoQ+m 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fu86v80s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 May 2022 16:47:54 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 243GlsdR011678;
        Tue, 3 May 2022 16:47:54 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fu86v80rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 May 2022 16:47:54 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 243GWLkc020534;
        Tue, 3 May 2022 16:47:51 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3fscdk2xhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 May 2022 16:47:51 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 243Glnaw55378326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 May 2022 16:47:49 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7593A4051;
        Tue,  3 May 2022 16:47:48 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5ADCA404D;
        Tue,  3 May 2022 16:47:48 +0000 (GMT)
Received: from [9.145.187.31] (unknown [9.145.187.31])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 May 2022 16:47:48 +0000 (GMT)
Message-ID: <60195753-93fc-ced7-c250-da65c05508af@linux.ibm.com>
Date:   Tue, 3 May 2022 18:47:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v2] powerpc/rtas: Keep MSR[RI] set when calling RTAS
Content-Language: en-US
To:     Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>
References: <20220401140634.65726-1-ldufour@linux.ibm.com>
 <87r15aveny.fsf@mpe.ellerman.id.au> <87levia8wy.fsf@linux.ibm.com>
From:   Laurent Dufour <ldufour@linux.ibm.com>
In-Reply-To: <87levia8wy.fsf@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HEqTFP_YAgNxXj63s2ag0XDrOL6IrJ-2
X-Proofpoint-ORIG-GUID: 8UGGQGk9pWhzfZpD1bl5k9xjZx7Y_Ib_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-03_07,2022-05-02_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205030110
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/05/2022, 18:16:29, Fabiano Rosas wrote:
> Michael Ellerman <mpe@ellerman.id.au> writes:
> 
>>> diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
>>> index 9581906b5ee9..65cb14b56f8d 100644
>>> --- a/arch/powerpc/kernel/entry_64.S
>>> +++ b/arch/powerpc/kernel/entry_64.S
>>> @@ -330,22 +330,18 @@ _GLOBAL(enter_rtas)
>>>  	clrldi	r4,r4,2			/* convert to realmode address */
>>>         	mtlr	r4
>>>  
>>> -	li	r0,0
>>> -	ori	r0,r0,MSR_EE|MSR_SE|MSR_BE|MSR_RI
>>> -	andc	r0,r6,r0
>>> -	
>>> -        li      r9,1
>>> -        rldicr  r9,r9,MSR_SF_LG,(63-MSR_SF_LG)
>>> -	ori	r9,r9,MSR_IR|MSR_DR|MSR_FE0|MSR_FE1|MSR_FP|MSR_RI|MSR_LE
>>> -	andc	r6,r0,r9
>>  
>> One advantage of the old method is it can adapt to new MSR bits being
>> set by the kernel.
>>
>> For example we used to use RTAS on powernv, and this code didn't need
>> updating to cater to MSR_HV being set. We will probably never use RTAS
>> on bare-metal again, so that's OK.
>>
>> But your change might break secure virtual machines, because it clears
>> MSR_S whereas the old code didn't. I think SVMs did use RTAS, but I
>> don't know whether it matters if it's called with MSR_S set or not?
>>
>> Not sure if anyone will remember, or has a working setup they can test.
>> Maybe for now we just copy MSR_S from the kernel MSR the way the
>> current code does.
> 
> Would the kernel even be able to change the bit? I think only urfid can
> clear MSR_S.

That's a good point, thanks Fabiano!

The POWER ISA programming note about MSR[S] is explicit:
"MSR[S] can be set to 1 only by the System Call instruction and some
interrupts. It can be set to 0 only by urfid."

Since RTAS is entered using rfid, MSR[S] should remain whatever is the
value in SRR1.

And that's what POWER ISA is saying about the rfid instruction, in the
synopsis of the instruction the bit 41 of the resulting MSR (aka MSR[S]) is
not impacted.

So there is no need to take care of this MSR bit in our code, but for sure,
this should be well commented.

Michael, do you agree?

Cheers,
Laurent.
