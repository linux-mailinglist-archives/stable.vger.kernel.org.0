Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A411529854
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 05:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbiEQDix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 23:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiEQDiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 23:38:52 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E642C46667;
        Mon, 16 May 2022 20:38:51 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id a23-20020a17090acb9700b001df4e9f4870so1140743pju.1;
        Mon, 16 May 2022 20:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=j1LH341yIniJ4rqGd7AgQUaUDLGYBFu3ii/SlaNgQuQ=;
        b=K5NO9UsaiPRnVdZowuUHe25GTQNzSN4ZNDNd9UAyQ1HT8ytDvFoSTVc4wYdA/udZOJ
         MdQJZjs7j8hdJbcQbHN0ZP1Vq5MBYXzv/szTkwaxAjBBztdpX1RECOhUToHj9iMzX4f7
         5armpR4LKS33BrUQLfFZOjlNObl28uRYzPCUPwhOrhRz/yPE9cPO7rtUSSb9PXzZHJQb
         YEYScy8uiu7wizFUBoVKEUqhJbdix1+xzLQb94zE+G55KtYfm9six/KmyZAU0w2JnkI2
         aCR7W8fE0e+uGr1PYJpFp2Opy2/yAjbeHBqXZs4BepnC7QSk4IROEim3A0wtpe79as/d
         LR2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=j1LH341yIniJ4rqGd7AgQUaUDLGYBFu3ii/SlaNgQuQ=;
        b=6JYTAwIOV1UPqPk3hWQjFs9ajAzGk/6ZoupvY6Eqo/Jb1T9LbiVlr9pXXVEgGq6/ZA
         mvU1IiHFS15jBBYNkoChe1QOfOrmcSWx/LconOYjmgnjVdmvYOJxfNIaYJSEDaCNT6Cl
         LZziXwFSmevmNWXLuNBSk3iJrUPL34M0KWf0QMTUY83y4+t2DsMxwJKm3XJTaLRvOubw
         Q/pGaBXQmgvzccrTz6Dk6Pa8G9EKCyEtoBN+lsnhshlsdtvTUg0WJJ9AqV1CJnRaxLvW
         q9aPAPpaIqfuFX+dULud5EfKh/+Ku9FG2Vhj8OgIV2UG6ummfLz1nxDpXUDxCTOrmqHc
         Xx7g==
X-Gm-Message-State: AOAM531hIfCNsCv6wriKDL4pPB5csbIetJYN3jWfzOK/XhshKueC/451
        VtSbf0zUSLBBnTNaJt5yk3E=
X-Google-Smtp-Source: ABdhPJySNjPHbQqbEaw/ASfGGIRtO1/knPMJQFd1VNfrNjn0Psn31QAKwhMtPRwfmDfgDwGAuCP3tw==
X-Received: by 2002:a17:90b:48d1:b0:1df:4fc8:c2d7 with SMTP id li17-20020a17090b48d100b001df4fc8c2d7mr9345842pjb.45.1652758731390;
        Mon, 16 May 2022 20:38:51 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u18-20020a17090341d200b001616e19537esm3679843ple.213.2022.05.16.20.38.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 20:38:50 -0700 (PDT)
Message-ID: <0f4790f1-5c7d-3d6c-4044-8912b52c6d48@gmail.com>
Date:   Mon, 16 May 2022 20:38:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 5.10 00/66] 5.10.117-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220516193619.400083785@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220516193619.400083785@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/16/2022 12:36 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.117 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.117-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
