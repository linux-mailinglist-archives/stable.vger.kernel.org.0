Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067FE519D83
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 13:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348449AbiEDLFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 07:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234082AbiEDLFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 07:05:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B993717E24;
        Wed,  4 May 2022 04:01:31 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 244ASn2i032651;
        Wed, 4 May 2022 11:01:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1ag1YfXg3EBO7Or3ScbArxB8G7BzI6staQN620kU86g=;
 b=ZZZruooGfLSzS36cVOPx8r/toTIR3mHbyJeLZjix3AZABSUW4/4KiTzm+lyapvGwpWI7
 EH8PDiQLwxpT/0oZO60Zo2f/8YCfjpu3pwUDvcpSvIAN7HxW+BjUeAdlEuYBUnrs7vp6
 wrd39OVNuNUL+Z3KnggzhqV+V0d77hETFjBFYQs6m67ieaYOXoaYhybC45bTCIJh4yF0
 JatRpdBv2ZhXesaKjmoeuCBagt0cZptcULRKTCUQDx9bNhq2SMy0cL6Sb9mPCCU56xV3
 IAyJPIYwtesMNipNnGD500godmgSN4/85TqpKXDaHAb6T51LcGIJVjfcqnuvF4CJBxyf mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fuqs0gkb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 11:01:23 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 244AV6x7007803;
        Wed, 4 May 2022 11:01:23 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fuqs0gkad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 11:01:23 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 244AwlOl001521;
        Wed, 4 May 2022 11:01:21 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3frvr8wgtd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 11:01:21 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 244AlxZI50594048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 May 2022 10:47:59 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E00742049;
        Wed,  4 May 2022 11:01:19 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA8F842042;
        Wed,  4 May 2022 11:01:18 +0000 (GMT)
Received: from [9.145.14.176] (unknown [9.145.14.176])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  4 May 2022 11:01:18 +0000 (GMT)
Message-ID: <f498f098-8b87-26bd-9967-2315bbc231f3@linux.ibm.com>
Date:   Wed, 4 May 2022 13:01:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v2] powerpc/rtas: Keep MSR[RI] set when calling RTAS
Content-Language: en-US
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>
References: <20220401140634.65726-1-ldufour@linux.ibm.com>
 <87r15aveny.fsf@mpe.ellerman.id.au>
 <c33a2be3-d4b7-9b3b-c980-552f5de081be@linux.ibm.com>
 <87ee19vnwe.fsf@mpe.ellerman.id.au>
From:   Laurent Dufour <ldufour@linux.ibm.com>
In-Reply-To: <87ee19vnwe.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9miYMbhLlVrMRbdzZN77mC4eIDD1F5m-
X-Proofpoint-GUID: rhI7oEMXt52f1caDX5UlztzBXFTj78Qx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-04_03,2022-05-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=958
 lowpriorityscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 spamscore=0 phishscore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205040070
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/05/2022, 07:59:29, Michael Ellerman wrote:
> Laurent Dufour <ldufour@linux.ibm.com> writes:
>> On 03/05/2022, 17:06:41, Michael Ellerman wrote:
>>> Laurent Dufour <ldufour@linux.ibm.com> writes:
> ...
>>>> diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
>>>> index 1f42aabbbab3..d7775b8c8853 100644
>>>> --- a/arch/powerpc/kernel/rtas.c
>>>> +++ b/arch/powerpc/kernel/rtas.c
>>>> @@ -49,6 +49,11 @@ void enter_rtas(unsigned long);
>>>>  
>>>>  static inline void do_enter_rtas(unsigned long args)
>>>>  {
>>>> +	unsigned long msr;
>>>> +
>>>> +	msr = mfmsr();
>>>> +	BUG_ON(!(msr & MSR_RI));
>>>
>>> I'm not sure about this.
>>>
>>> We call RTAS in some low-level places, so if we ever hit this BUG_ON
>>> then it might cause us to crash badly, or recursively BUG.
>>>
>>> A WARN_ON_ONCE() might be safer?
>>
>> I'm afraid a BUG_ON is required here. Since MSR[RI] is set on RTAS exit so
>> if it was not set when calling RTAS, that's a real issue and should
>> generate unexpected behaviour.
>>
>> Do you have places in mind where RTAS could be called with !MSR[RI]?
> 
> The main one I can think of is if someone is using
> CONFIG_UDBG_RTAS_CONSOLE, then udbg_rtascon_putc() is wired up as
> udbg_putc() and that might be called from anywhere, including xmon.
> 
> There's also RTAS calls in low-level xics interrupt code, that might get
> called during panic/crash.
> 
> I don't expect any of those places to be called with MSR[RI] unset, but
> I'm worried that if we're already crashing and for some reason MSR[RI]
> is unset, then that BUG_ON will just make things worse.
> 
> eg. imagine taking a BUG_ON() for every character we try to print as
> part of an oops.
> 
> Admittedly CONFIG_UDBG_RTAS_CONSOLE is old and probably not used much
> anymore, but I'm still a bit paranoid :)

I think you're right to be paranoid :)

This part of code can be really sensitive.
I boot a kernel built with CONFIG_UDBG_RTAS_CONSOLE, xmon is working fine,
but I cannot pretend this is covering all the RTAS call cases.

My hope with BUG_ON() is to raise the issue, as soon as possible, so it can
be addressed during the test phase.
