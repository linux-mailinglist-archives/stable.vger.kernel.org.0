Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5E15B9012
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 23:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiINVZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 17:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiINVZ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 17:25:26 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12CC6DFA3;
        Wed, 14 Sep 2022 14:25:25 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id m9so12764322qvv.7;
        Wed, 14 Sep 2022 14:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=pJpdXWnudHrRP4ACimi1TW0yqy4ZvRDvJ2MS67CS3d8=;
        b=HMPHVKxvJFGeLm1RCCYOZG7kt1Q1AM6ftx1TuFZu/XcVZvfOZSnNIQ5zbp70QBE6Sb
         +Dl5FNPQM/hOrBf4Xb+u+dNi22NonDTp1bZVCKw7xv9uoK4kO5FGqD1bRdpk6cCcDpEZ
         +1xb6miK9cq3MYaKkNObyBOWIS8N/6601xjU7ynggwIpSUNJmIT9lDmr4VWjP53/88z6
         jsr/fVKJnSOr+15pptHnBbrd3yQx1ywVMSUllaqY5Q5Vua2+Ar2KnAip+ajdbNkZS8NP
         zTKSGCl5/H1aAnJxlPnLNzQOKQ/K+cqBowarevmLkTFGtQh3Sz3QiBn7b0McPVEIvXXd
         //Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=pJpdXWnudHrRP4ACimi1TW0yqy4ZvRDvJ2MS67CS3d8=;
        b=a0DBnKUYEWoKQwG5rAb/+Jrk3H5yvfk4/wMTsBteafrQ04/MWn6nE8lE8/thTKj/3j
         Z1vKYx5S8Qnos2Bdldg/G5i7MwWELLrJKw8MsZtg1w5ozaZa9Y1ubzzsYqM4udbNOb9a
         HRSdaAwvXlJMFM0RkLCo8i9T3p6AmyrbjDAogyCgFVZBo/5kOdQf14VXZtuTYvrmzLhu
         pHXH7EofzstkDJm5+x3TJh8YehqSRvd1fu2WXxJMF1a9JaXFyj45OMGcwz4OIQbEAetm
         7ogdGVgDuFvk7ZgtG4FFNgXQVGay3HfUzKbOwr4my2/dPxYjwcB3uJLgoG3PBglBxtv2
         fC2w==
X-Gm-Message-State: ACgBeo2XV/MA6pBWrTZ+UxYID7OfeuthsUlmFhPFL/xFvDqa5hIJCydW
        dmWH6stHgpr2jYGtgX3o+kuAMjwtrg0=
X-Google-Smtp-Source: AA6agR5aX+Lky3rBHcN/nHs5PtfoGQgPjOP58Fmnsdm2utIbHEmI4XuuIziXpkQzE17wmW7mMl46UQ==
X-Received: by 2002:a0c:b2de:0:b0:499:363f:222f with SMTP id d30-20020a0cb2de000000b00499363f222fmr34180880qvf.73.1663190724827;
        Wed, 14 Sep 2022 14:25:24 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x19-20020a05620a449300b006b95f832aebsm2782815qkp.96.2022.09.14.14.25.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 14:25:24 -0700 (PDT)
Message-ID: <6335baf2-0c7c-7b95-5190-76aa3d6aa410@gmail.com>
Date:   Wed, 14 Sep 2022 14:24:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.19 000/192] 5.19.9-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220913140410.043243217@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/13/22 07:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.9 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
