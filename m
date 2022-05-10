Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611635221F7
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 19:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345076AbiEJRNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 13:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347777AbiEJRNK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 13:13:10 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A9F28F1CA;
        Tue, 10 May 2022 10:09:12 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 137so512568pgb.5;
        Tue, 10 May 2022 10:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/FpK6VScNnGdYvVWjfbMzCEvV0vnsdU5JraJWpdw6NQ=;
        b=eIG9LIjYEpODWbxl+jhEanYQZVc6sbNpOHCLTZ7YSnQVSYvLacc509tzjhqKa7hvdZ
         i8KEn1iXOBApxA7BNwgLa78lWo53C3AEeRC6j4KGlX0TzMAmqo4+WsxUfpApqrkbuwIq
         Y4sX7A0K4SVdZ9xy9L5ogEy98TztMb7Q3B4DVqrSayjbXJ6be6Dn3PIyCNPRLs/Xcfzr
         mdGeqeF8/CkKCG1gy0C4gb5boCqphciAB4UVfTwla68is0HVrXi2CdC6Tn9pQNB4CAtb
         XuO2U64kyT9P0NoTogMnGpVfv6UF7tUYtPtMna98Bg4Uaf7qqAupU/X7MYyzc5ybzSFu
         kMJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/FpK6VScNnGdYvVWjfbMzCEvV0vnsdU5JraJWpdw6NQ=;
        b=dhT6aRqP8di0kUFMCV5pbPDtwkex8x1FAU7syFw+2GJpjd2qWexwMgyXwkC6cP/i3V
         whHp2DxORRFSm5tmhdB7hZvQxL0EXcpHOlMOmCR9dn48x4JP9pGT77MRaMVqHzmOLNch
         VlIfbRbj9ToyirGiMrQ4+L9iuHB9LkupduVGessYNnxadKBYm7kwmB7jiAS4v9Bw6DEu
         xDSVJefAcXt4v30tMWBdrPoET5R54Ix7impqhuFSYkqv+nagpD0xJnEC5jyNIPYMt/u/
         ZvnUndL+VxBNyUQCRfmnzDb7Pj9Eo56JNv1yeXN2vbb0ztXKi1eqcpLPDV1tjK2lYlIk
         zC2g==
X-Gm-Message-State: AOAM5305m9CdnPwLAi7Kwoc20HprG/uA04dxspmClT03W8pl9JRdAoXA
        eyZPRYARpu8z9PvCgj3qe0+Yhph8j/A=
X-Google-Smtp-Source: ABdhPJxvpGKL00fHh2ZoGaduDxMqrIJ7gIOdWwSxH2XNiAeuJq/p4XeAcR3pfPqw/BSZJDG3COdBvg==
X-Received: by 2002:a63:e108:0:b0:3c6:6833:9192 with SMTP id z8-20020a63e108000000b003c668339192mr14372019pgh.616.1652202552337;
        Tue, 10 May 2022 10:09:12 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id gw19-20020a17090b0a5300b001cd4989ff60sm2179382pjb.39.2022.05.10.10.09.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 10:09:11 -0700 (PDT)
Message-ID: <9f3e807a-8011-8573-e663-39aeb36bf3f8@gmail.com>
Date:   Tue, 10 May 2022 10:09:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 5.4 00/52] 5.4.193-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220510130729.852544477@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220510130729.852544477@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/10/22 06:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.193 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.193-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
