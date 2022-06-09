Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B4954439A
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 08:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbiFIGNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 02:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiFIGNB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 02:13:01 -0400
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF4936302;
        Wed,  8 Jun 2022 23:13:00 -0700 (PDT)
Received: by mail-ej1-f41.google.com with SMTP id y19so45414422ejq.6;
        Wed, 08 Jun 2022 23:13:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uenxBnmzX5nP05fED5GFTiUFsAaskSMTNeWhKePY7qQ=;
        b=nJRRzV2t3Y5/X4JVEPyRqa9eSyRFuNjvjWa4OUViToxRzY1MxqTionQ/AZSaMpYmI/
         c2vjW/anno2oT2wQoqcqZfu5HbqwyPZtZwb1Sk4TiNmAwqetSoYJoj1IUEUNbsGszQUM
         3KN/O6o0zYfnBUWaGPPIWO8uaVgPM+NVN95cEvyIV9g2sNxDFHLmcywQpwf51JEwzCox
         0557IuLAf+zAvjdsxYL6omzQlCKh0CjZ1UtSmWXTYSXgoqHiZO4zg73OvxR6v6HlpGjD
         NaMHCwuLna8vu/VJ79CKKXCmTtZwCt4GWQ7wo8itRiKEsmBG8XBz7WUIThdLudftN1iZ
         wXMA==
X-Gm-Message-State: AOAM532DltHTMyp7aNwu59dDJezkP6Ek8P5IJgiOcbayefeaszoScuRb
        rniOFg9NixB/9mMoV2UtapE=
X-Google-Smtp-Source: ABdhPJz7K8CMJOyO6WVb0QaA/pvjh1RDnjIBLOP6yt2mPCH2VopWQh8LhACk61TPMK1vWZ4A3KZqAw==
X-Received: by 2002:a17:906:64d6:b0:711:fca6:bc2b with SMTP id p22-20020a17090664d600b00711fca6bc2bmr4717295ejn.197.1654755178893;
        Wed, 08 Jun 2022 23:12:58 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id ft29-20020a170907801d00b0071145c2f494sm6407525ejc.27.2022.06.08.23.12.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 23:12:58 -0700 (PDT)
Message-ID: <5bdc97df-2543-2716-cfd3-34019ac84c96@kernel.org>
Date:   Thu, 9 Jun 2022 08:12:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5.18 000/879] 5.18.3-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220607165002.659942637@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07. 06. 22, 18:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.3 release.
> There are 879 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.

openSUSE configs¹⁾ all green.

Tested-by: Jiri Slaby <jirislaby@kernel.org>

¹⁾ armv6hl armv7hl arm64 i386 ppc64 ppc64le riscv64 s390x x86_64

-- 
js
suse labs
