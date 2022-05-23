Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F89531DE0
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 23:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbiEWVgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 17:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbiEWVgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 17:36:46 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25553C73B
        for <stable@vger.kernel.org>; Mon, 23 May 2022 14:36:45 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id i66so19337720oia.11
        for <stable@vger.kernel.org>; Mon, 23 May 2022 14:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5PXgNGMVQ03wD10HW0ODeUPXFFSUhfWvCLJDJaSifzI=;
        b=Wc2ud+hfto1tZJNBjYwroz9rvpQaWSVbxAT/ANS+fUZCCyX+TW2QEOeZKDFDpz3AHe
         nE33PU+TtUoW+FzoEEguzJYZFuoEWmFVdgMuRowf+Dke4pP2NkRlAWZlzqpCuAHxRRaX
         qhRfBpUjDU+IrNoXmPR+GoEq4SR0z1+uFlm2Dhgj9dQS+70A8bdD/6hvU7ucRggujFp1
         WezAMAp+4rD6pkGe6cNBxC5LbY1qhZVdG9GLOwx7CYUkiDtpLsAGXg6U9sIKhmQV5Mz3
         EAZ316uDSmT/Wv/dNOM6fIHPXIK4V9PGKSI/tEqrQBxNG48dXNb4I1oh9IpCGao/I3Fp
         btdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5PXgNGMVQ03wD10HW0ODeUPXFFSUhfWvCLJDJaSifzI=;
        b=Ra/XowTrIvqCyi8+i8KfopF0jpMgP/gi07Q+Y3YlA9PjeHMNp1TK1/KNQEq6ZXKKnL
         P9BV25xO5LbhmgBMmipjAhJCOMN8E7p9n8MwVRpbpswyNee1ttwEgxeDRrXJPtZrSN+x
         oTvRYO+t9zONF8DGY1g18jiJzBd+PCMofZvTmKpDcfX26dK1NxHx20TUBYR+5ddZSqYI
         M7OeBYy23IE5g+DKi5HcHGRwJJvzXHAJm/Z8R1rMFOtDZq5yezjpxqA5px9KpTzVH1s9
         3nQyNGwDbM2wG+90arX8kJPN43dk1ha2EqmDG46KkCynSY84D4umP7PstcMOJfDMLfm/
         VVMA==
X-Gm-Message-State: AOAM532ApmCmXnQGhoB3OruJHs83yhcwR/YwvGLDQh19nU7lXTlgPQIb
        0E41+OikuH1HK+hY/XGAPyrjsg==
X-Google-Smtp-Source: ABdhPJx740sKz+aBf/+ZKsc4vVJLCR1ToRU5oYT2RRenmIb/jss2FeJ78YuP7RoXAOIH7XlM/sHibw==
X-Received: by 2002:aca:428a:0:b0:326:4b9d:7272 with SMTP id p132-20020aca428a000000b003264b9d7272mr640267oia.30.1653341805002;
        Mon, 23 May 2022 14:36:45 -0700 (PDT)
Received: from [192.168.17.16] ([187.192.91.72])
        by smtp.gmail.com with ESMTPSA id e125-20020aca3783000000b0032b7788af61sm494498oia.41.2022.05.23.14.36.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 14:36:44 -0700 (PDT)
Message-ID: <18a4a99f-e72a-1578-d6e5-8f5bb4ec4897@linaro.org>
Date:   Mon, 23 May 2022 16:36:39 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 5.10 00/97] 5.10.118-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220523165812.244140613@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20220523165812.244140613@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 23/05/22 12:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.118 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.118-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We see a build failure with Perf on x86_64 and i386, with bisection pointing to:

> Kan Liang <kan.liang@linux.intel.com>
>      perf regs x86: Fix arch__intr_reg_mask() for the hybrid platform

The error message is:

   arch/x86/util/perf_regs.c:13:10: fatal error: ../../../util/pmu-hybrid.h: No such file or directory
      13 | #include "../../../util/pmu-hybrid.h"
         |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   compilation terminated.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Greetings!

Daniel Díaz
daniel.diaz@linaro.org
