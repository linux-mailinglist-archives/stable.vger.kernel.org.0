Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05CFC35061C
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 20:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbhCaSPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 14:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234526AbhCaSPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Mar 2021 14:15:20 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1035C061574
        for <stable@vger.kernel.org>; Wed, 31 Mar 2021 11:15:17 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id e18so20594052wrt.6
        for <stable@vger.kernel.org>; Wed, 31 Mar 2021 11:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eA66IfwNLCvflZyaO4GLWcFCdnWN4ORiomGXqXfK2fI=;
        b=f1Ar6CrHVwvmPAM3/9xMSRkKbN4usB8LfM583KmVSNJXs0r9cwmW9stwOKoZwMrxBC
         8M90NIfDKnoSwcSiBxVfvwLjuz4IWvYeL1vFxRhKMDhJy6I/CtyXQDHWLF33EeEata6X
         Vi3odTlTawbhhkRC9Uy49cUyQLQlneOe1+Gor6WnNMINgZ3UD+UJIp/iYVsdaGRunxCw
         8/5ewEzObkstEaa9ST1but+pEE6GrBuM+tCgEoaMtfPcVJ/swYbM7F45HJ43j2bArRWg
         1OjhHJJFXK4zMoAnUEpJPxvr1NkIVWETfE9pNj6lDRs36zWNuAsqSW7gDAoMo5YZCzYf
         2ZZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eA66IfwNLCvflZyaO4GLWcFCdnWN4ORiomGXqXfK2fI=;
        b=eRSja4K5COKMwAEXeoOLrUqyPtDNP5SkIdyfwL5fJSH6ik+hPAdFJUdITIg/Dz6IyC
         e792C4BRlb0G3vmJwBR5jwgDLPvhw/uFBSh8q5B3KKh6x26gWO1KNwEJn3gUTEkDmVDz
         4PpcYjDJ5WQLW2V3px7fOCbu4WmBtkazyuhvaQ9C5GpH2dDpLebnfm08bnu1f7lLY+Di
         I/MDfq87xcK/We8vTnEh3CmZxrNpvCUujMorDQ8StyHhtbG2m9mTmlus1QBwGjBSDkT9
         Zkmd7rGFsUB+vMebmCINx0UruW9zcEdUn30nOeLNeFzICzPEnMytxq+Yi5q05F90pn8F
         FIgw==
X-Gm-Message-State: AOAM532fVKlwIIFaSsKoVODZBE+lx3zIVNcgdvEG1TjAUfbZ17pycOrp
        uBKmiebWSoSZb4Ypz+I2bAfTUQ==
X-Google-Smtp-Source: ABdhPJyyWfx/c+aqE54lTrl3dhisDbSZEmIFGt41YeVVb1gbg4eQ0gsUx3VoNGnZ5VsumWW6ywd2EQ==
X-Received: by 2002:adf:ba94:: with SMTP id p20mr5188220wrg.300.1617214516602;
        Wed, 31 Mar 2021 11:15:16 -0700 (PDT)
Received: from ?IPv6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id i4sm4661186wmq.12.2021.03.31.11.15.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 11:15:16 -0700 (PDT)
Subject: Re: [PATCH] powerpc/vdso: Separate vvar vma from vdso
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
References: <20210326191720.138155-1-dima@arista.com>
 <47623d02-eb29-0fcb-0cfd-a9c11c9fab02@csgroup.eu>
From:   Dmitry Safonov <dima@arista.com>
Message-ID: <8cd82b69-c8cc-8591-1f92-5c9400e00579@arista.com>
Date:   Wed, 31 Mar 2021 19:15:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <47623d02-eb29-0fcb-0cfd-a9c11c9fab02@csgroup.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/30/21 11:17 AM, Christophe Leroy wrote:
> 
> 
> Le 26/03/2021 à 20:17, Dmitry Safonov a écrit :
[..]
>> --- a/arch/powerpc/kernel/vdso.c
>> +++ b/arch/powerpc/kernel/vdso.c
>> @@ -55,10 +55,10 @@ static int vdso_mremap(const struct
>> vm_special_mapping *sm, struct vm_area_struc
>>   {
>>       unsigned long new_size = new_vma->vm_end - new_vma->vm_start;
>>   -    if (new_size != text_size + PAGE_SIZE)
>> +    if (new_size != text_size)
>>           return -EINVAL;
> 
> In ARM64 you have removed the above test in commit 871402e05b24cb56
> ("mm: forbid splitting special mappings"). Do we need to keep it here ?
> 
>>   -    current->mm->context.vdso = (void __user *)new_vma->vm_start +
>> PAGE_SIZE;
>> +    current->mm->context.vdso = (void __user *)new_vma->vm_start;
>>         return 0;
>>   }
> 

Yes, right you are, this can be dropped.

Thanks,
          Dmitry
