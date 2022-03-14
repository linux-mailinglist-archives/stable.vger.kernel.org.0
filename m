Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2FA54D8F9D
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 23:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235691AbiCNWjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 18:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233496AbiCNWjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 18:39:07 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4DDC74;
        Mon, 14 Mar 2022 15:37:56 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d19so9206877pfv.7;
        Mon, 14 Mar 2022 15:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C8LcqXYv2d6TyKUPlL/qOZl9TfZYtkYhdjajuosFY3E=;
        b=JuB2VIr8pefdcnujTbWRv086iPZEe36szxsUIT0tQJa2Y0NPMPA6B4Qfs1XkIKuRN+
         /IT+RAaYk7Kf960Y09v2H6q1kyUINtUxhoF1I8YUI4Or/i00iTfWIcllreJnuxmPIKuJ
         eWYLMpsZr5O9vSAnIaXOXfAOeiJtp1+gR/S8dNEuB+bHdDRdIy3KdNYOuGwAIGO0MFqN
         TIA6T3yr/n/CHxTqNx9hYrvj8NRf8wEaezbh1o7g36fUHYxrznJLEuo7DMFHzjQoXEMF
         R32Asj/G0/jgtDBijO8rKCOWD47UThSZPNRotlOed+WyM7Hg6qru946eJIZAA+UGcefR
         SLYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C8LcqXYv2d6TyKUPlL/qOZl9TfZYtkYhdjajuosFY3E=;
        b=GKuMSZY4cJHlO86iBLkbVICPW7LI5M47Rzc6dqjKdcSc7fuWH5GEqDaQmheHB+87RC
         N4UC2hICXsCWi06gaa7CDdqrIFGWHdxAfd0MVRVjdgpqafGihNBR3kJFiwMznQgNjOaB
         cVN1njkm6DgAFAw4CkTJpfShiX8rZwaSjXese+ha+IRjNCnuk7MDQ2kVKqvSJgrLBt8u
         pVoJvK/OwHScIU+FKIjpwCtevySvDWSB1PZdvRBB6sPwatDD0qsuUIvFwfQg1UwRI+DY
         0NpgQ8ZVEJfc99/yTPsdnNXao7yc79l4dAVUgf16trweuXGpdBDOtqIWOcNQnUQreE29
         /tog==
X-Gm-Message-State: AOAM531Lmjm18wQrC5Di+CEgaqiJW+cAtvLNwWaBhe+Ul90aBwUmx4Rb
        H+FUnZDH8Y20DM2/U9FbFak=
X-Google-Smtp-Source: ABdhPJytdfMLeRTAink5+nyAaWp5guDOHo5Xkv8G2R16hrLpIW45Mdo0V+2UXT9ToaT4LJLc6/ishQ==
X-Received: by 2002:a63:e744:0:b0:370:25a8:bfed with SMTP id j4-20020a63e744000000b0037025a8bfedmr22459649pgk.432.1647297476382;
        Mon, 14 Mar 2022 15:37:56 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id pc13-20020a17090b3b8d00b001c62a846311sm530973pjb.6.2022.03.14.15.37.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 15:37:55 -0700 (PDT)
Subject: Re: [PATCH 5.15 000/110] 5.15.29-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220314112743.029192918@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a2d22a97-0b0f-b69f-c969-2edf2a4f62ff@gmail.com>
Date:   Mon, 14 Mar 2022 15:37:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/14/22 4:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.29 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.29-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
