Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEBE4EB07
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 16:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfFUOs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 10:48:58 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42099 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfFUOs6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 10:48:58 -0400
Received: by mail-qk1-f194.google.com with SMTP id b18so4579303qkc.9
        for <stable@vger.kernel.org>; Fri, 21 Jun 2019 07:48:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nadRpCTWQ1fnl50G7MBqdbCo9hRJb6q06h9KD67pVdk=;
        b=C3aWobkKCNdtBlNtyaaJmkK71TVcKoxwRi04hnLMm4jJaJpVmn5FcXnl5BktF/h0uS
         yQ7JuNcEkT4Aa71/Pz64sz5XJ9233NdS6DP652+jFhIBeL38ubifrjbALRRYHi7MjQIb
         TbKtEJWqaFqhMXyqpJVc1JcVqilme7eDwmXhrzY9FvK2xytWuWO5situHu7RrlkP2/D2
         Sakyn689CbRx9gNWSxhOGXIHht0r9zFrp5/HJKozPXisOq726ZrMfJEQqDPeIRdHgyT/
         4Cckk4OfvYInrrDnuj8LU+Ml6P/ixPp+cla4IklMjch7atPbp0eM1l4OPCaTrC+zQIt6
         RzQQ==
X-Gm-Message-State: APjAAAW+mrs0JCLeJSLtq3EiT6QVK6qnsx2JTD4DAx7B1Z18Batp92t+
        lXJcIAjfpnBV2QuYP8Kw2yjxInGJB8M=
X-Google-Smtp-Source: APXvYqyT9Mgc2R5Zs3om206kiFHoXVDCeDbt8gAAY7iuSENt6qN2MtafH0vxN1bROTP2Y14VTtSXBA==
X-Received: by 2002:a37:c81:: with SMTP id 123mr5796651qkm.412.1561128537125;
        Fri, 21 Jun 2019 07:48:57 -0700 (PDT)
Received: from [192.168.1.157] (pool-96-235-39-235.pitbpa.fios.verizon.net. [96.235.39.235])
        by smtp.gmail.com with ESMTPSA id d123sm1716008qkb.94.2019.06.21.07.48.56
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 07:48:56 -0700 (PDT)
Subject: Re: Request for 4.19.x backport (with conflicts)
To:     Heiko Carstens <heiko.carstens@de.ibm.com>
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        stable <stable@vger.kernel.org>,
        Major Hayden <mhayden@redhat.com>
References: <0fc1a3e6-59ef-6390-38c4-55e7c48bee78@redhat.com>
 <20190621131135.GB11296@osiris>
From:   Laura Abbott <labbott@redhat.com>
Message-ID: <99840513-9a7d-2c91-1e41-5355f88babcf@redhat.com>
Date:   Fri, 21 Jun 2019 10:48:56 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190621131135.GB11296@osiris>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/21/19 9:11 AM, Heiko Carstens wrote:
> Hello Laura,
> 
>> We're attempting to build stable kernels with gcc9. 4.19.x fails to build with
>> gcc9 as 146448524bdd ("s390/jump_label: Use "jdd" constraint on gcc9") is missing.
>> This doesn't apply cleanly to 4.19.x as it needs changes from 13ddb52c165b
>> ("s390/jump_label: Switch to relative references")
>>
>> Which is better, taking both 13ddb52c165b and 146448524bdd or doing
>> a backport of 146448524bdd?
> 
> I don't know which kernel version you are referring to exactly,
> however 4.19.53 from linux-stable does not contain the common code
> infrastructure for relative jump labels. The infrastructure was merged
> with 4.20: commit 50ff18ab497aa ("jump_label: Implement generic
> support for relative references").
> 
> Therefore a backport of only 146448524bdd seems to be the way to go.
> 

Ah okay, I didn't realize there was more needed, I was just looking at
the clean cherry-pick. I'm not sure how to do the backport, if you
give me the patch I can verify.

Thanks,
Laura
