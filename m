Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10634F9062
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 10:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiDHIKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 04:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiDHIKE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 04:10:04 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42022ED46;
        Fri,  8 Apr 2022 01:07:59 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id m16so7246740plx.3;
        Fri, 08 Apr 2022 01:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=B+JiRYo7agfKbKwTwituM6LMKiUxBumes3CKn2uzgf0=;
        b=JJJTySUjRqBxzXWshidv8Dq5SyZUleW8gXMDV+vAfOOGz1TgbhjhtGHmPtzMO47Qpt
         D17EodugP0xjW+fDLUTeAqNIh7wxWrkJk9tnTtoku4CdksjcFGiFtl6/vFpPv4SLsRCQ
         XwLPwJjhPygOMhL10asvUVQrA08+Ws9G2hMOSZVWz1CGJasgAbq3BZLlfOkJd+6dmszK
         GzenXbEwwAPgCrKyLvzWpXbA8tQl0FJCuWj+kh0YHFpqlCsGOqPIRROK+P9L7Pl1vqFx
         UJiwD/g17eywATi1MbpKpmQX0AzJm4SrHOMXmnl6ZSbyB/5T3qC2RoiAeZ/tHinsEALE
         LQKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=B+JiRYo7agfKbKwTwituM6LMKiUxBumes3CKn2uzgf0=;
        b=HKbMJIlBvChywdq0GJuwnR/QNTorp7zcRtfZZEwNj357rqJeVUEGjwwNOAxfAPZpup
         rAM6lJqS5EaJwNEOIAdIxkjdLedkt/PR0QNM9bsRFoE6kQ20nEgXfRC/+TytTS76Vjet
         rq1SLO9X1I7yAdGgxZ3hdVvsfgl64S4NnPni/eOtGYqihDn6iDX8wXvD2spVWbp4JTuZ
         B89Ezbg6NMUSxOLLHtQF4HYFYTVmvAjDJGgwdjrABlYCW81nLBSyf8H9DgQmhP6NAFGw
         FjVYawmbnQU46ICc6s4x5uwM/yP7OelfayExiWLRHwEjW7f6aXzY933FhQRvlOddoXUA
         IVGg==
X-Gm-Message-State: AOAM530ovevkrXGr6LCOL4rNbKKtF2F7epqbSe2tdqU3vK8VC/0QgLJw
        yyUYtNeeAUEELvf8G0kSQZs=
X-Google-Smtp-Source: ABdhPJwIjs98+5uVAX+yPTUno0WmRkBvkNTKFkKcwI6jy/kJk6HmmnH8qAo29RwLToJ11X0msq374w==
X-Received: by 2002:a17:90b:2242:b0:1c6:80e3:71b6 with SMTP id hk2-20020a17090b224200b001c680e371b6mr20340979pjb.152.1649405279225;
        Fri, 08 Apr 2022 01:07:59 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-82.three.co.id. [180.214.233.82])
        by smtp.gmail.com with ESMTPSA id 204-20020a6302d5000000b00385f29b02b2sm21412168pgc.50.2022.04.08.01.07.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 01:07:58 -0700 (PDT)
Message-ID: <374de447-0d28-6b85-6abc-687d9a444b66@gmail.com>
Date:   Fri, 8 Apr 2022 15:07:50 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.17 0000/1123] 5.17.2-rc2 review
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220406133122.897434068@linuxfoundation.org>
 <d12e1f2e-bcad-e7d5-5d14-e435340ffc2c@gmail.com>
In-Reply-To: <d12e1f2e-bcad-e7d5-5d14-e435340ffc2c@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/04/22 18.45, Bagas Sanjaya wrote:
> Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0).
> 
> Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
> 
> powerpc build (ps3_defconfig, gcc 11.2.0) returned error:
> 
>    CC [M]  arch/powerpc/kvm/book3s_hv.o
>    CC      kernel/kexec_file.o
> Cannot find symbol for section 11: .text.unlikely.
> kernel/kexec_file.o: failed
> make[1]: *** [scripts/Makefile.build:288: kernel/kexec_file.o] Error 1
> make[1]: *** Deleting file 'kernel/kexec_file.o'
> make: *** [Makefile:1831: kernel] Error 2
> 
> Reported-by: Bagas Sanjaya <bagasdotme@gmail.com>
> 

Oops, I didn't do make mrproper before powerpc build.

Now the powerpc build runs successfully.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
