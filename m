Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF884F7E48
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 13:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244934AbiDGLrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 07:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244931AbiDGLrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 07:47:15 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB043EDF11;
        Thu,  7 Apr 2022 04:45:12 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d15so4620059pll.10;
        Thu, 07 Apr 2022 04:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1Uc0BM32ZTi1+WjAOOFvA0Vn17NtYHSEPmAHlrLfRw8=;
        b=SiDPvvp8FkRM1URdWpiilu1tfaXdIrtRVOpqy580GzrRAsYXF5sy7QIQr9mZQ/bB/G
         EdX+6OmosuduFl+HkDAtH8GMA3y3b6GmV2bFP+lA6VpFmfomvrco+Wz816A9uqtMkisq
         knEhIDpUo1SlTCsr+/XnUnXGjyW9pxKKOHaHIICQRhcqWrtML8UW4cLm1ILjQ5l2i5D5
         leSU9gyyX+C/eI8dXGVBQ/faAlQkiF8rk5103Oy+0hoRWvHQxPu6CL2V2aruZbOECJRH
         WLtyfzWHHWizHNxLP/aKhJqyTtHQhrM9PCnBNqRy3Wo0NZsU1tuxlhTClbU8zfWF8CJ8
         u9yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1Uc0BM32ZTi1+WjAOOFvA0Vn17NtYHSEPmAHlrLfRw8=;
        b=mheuKOmAGaR0+TCCLL/wnhWdxc5Xp6wHtn13jWfK5lJgvZxP+iDkTZTsNSVVTMj1l0
         oql4naqvhGTLOuwu29OOGhUseZJbfgjMgVJLmTwIPOz2cZiXSCqqH6StstK3wc8u7pIV
         qd2dtxgP98IC2vXPwG0zATWFwDeIO74M4WuQawrRblE4wRfQQgnW0upj9XVjqacJN/WT
         qGf7jL/YlKn7ZZ9VjhN3rFKQPGAQe5Y4NB+M7qJ0nQfScmUEjQTDsC9qwfySgMZN14yi
         UXVBFA0rPw/K+1lLSJo4nSj2zLc5urNUSdgSQbCltDkg6THS2fAXolszBFm9gwAuwDns
         P1YQ==
X-Gm-Message-State: AOAM533XTsReAFzhOJeuCaslNz7lmOhkqfbp73lleMyGhQ2vKh2GELaU
        kHSteeyEkACYAOEnxV8ynFg=
X-Google-Smtp-Source: ABdhPJxFRfdRuSTt84Y2H6Vhjim23/auAT1jJhvor5XaPDPHnX2PadRDVaYbqCXfCx1V2qLWjssXiw==
X-Received: by 2002:a17:902:d4d0:b0:157:c14:12a6 with SMTP id o16-20020a170902d4d000b001570c1412a6mr1927195plg.165.1649331912460;
        Thu, 07 Apr 2022 04:45:12 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-65.three.co.id. [180.214.233.65])
        by smtp.gmail.com with ESMTPSA id bt18-20020a056a00439200b004faad3ae59esm21887761pfb.95.2022.04.07.04.45.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 04:45:12 -0700 (PDT)
Message-ID: <d12e1f2e-bcad-e7d5-5d14-e435340ffc2c@gmail.com>
Date:   Thu, 7 Apr 2022 18:45:06 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.17 0000/1123] 5.17.2-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220406133122.897434068@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220406133122.897434068@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/04/22 20.44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.2 release.
> There are 1123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

powerpc build (ps3_defconfig, gcc 11.2.0) returned error:

   CC [M]  arch/powerpc/kvm/book3s_hv.o
   CC      kernel/kexec_file.o
Cannot find symbol for section 11: .text.unlikely.
kernel/kexec_file.o: failed
make[1]: *** [scripts/Makefile.build:288: kernel/kexec_file.o] Error 1
make[1]: *** Deleting file 'kernel/kexec_file.o'
make: *** [Makefile:1831: kernel] Error 2

Reported-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
