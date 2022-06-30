Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3949562636
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 00:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiF3Wpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 18:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiF3Wp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 18:45:29 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2A339B89;
        Thu, 30 Jun 2022 15:45:25 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y141so747901pfb.7;
        Thu, 30 Jun 2022 15:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=d2Le8GYzMMXfWm1MDYrQmH8a3H1DVnn1YOlf/fGcI74=;
        b=QPXqC3VZTyjJAFAXpp5fXrCzKCPj7wWW6OpPV6RoYPHzImTJf7n+pCf3+bZv94W4Wc
         mA9sy9plH1KOTAD2Mq+6biOW/ICwWsZzx7YTd61s2PfrUaFyI401U92vEp011J5m30HN
         nkMcHZ9iIMaePmkOb2gb1shWhRbg9NmmR0M4ixpijrdJQ7RlLLykwk+c8jB/GSyefx80
         oxCBbtcauzZ5+yP+M5sFRgp1XcNVGwIjvT4yA9Zo0vGxlN0kCcx7SupZ1Ep3Dgy1mXt7
         BFsFcsDD375tPD3ashGqPxmC4zhEbyHkyBvgcfIR8qDJ4towjQdXVozj/ih4AR0Fl+CV
         uGGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=d2Le8GYzMMXfWm1MDYrQmH8a3H1DVnn1YOlf/fGcI74=;
        b=OL8Kr84z2iJwCDpk8ea7ccIHy+Nid05A9Dt5t8LUZlSNL6pPq0i7Mp8gpP/NO7i/xr
         eRwowSwzXjRZf0Ph7U3xU5cUozb+eSiOePVYAVTCJ5WOOiohGR+42m2RrRkj67F75/Na
         8o/uYMdRx1MdvI1vPYlDcORRrb0YG9i7SWybzVbt3C9FQWrjUw/jFgpJFd8JNk9brDFp
         K+J3CIAOOj3OeE8Lfmis0AQamuhqVNiptYebbBnY2N5U35lIfQeqrpmrWjE2ZPTci+Cf
         RS+2NVX0KCrZSU80ldujpszBKGq4zXm2mBrjGp8uV2/9UKq2z9pBZNfScSpvk2P26v74
         P5eg==
X-Gm-Message-State: AJIora9QtHdcQQHpo5GnX6R4khfFdSJ9eHgDqLT9pesDFgnzlM3hvIcH
        QnRejYBojBqAhzjhvQMIlW4=
X-Google-Smtp-Source: AGRyM1sAFsoUEHiPpMSeK5451kdYi9XpRlRWj21X4ZZXw2t51Nokgv3YR1LPYEolThrw1H12Uzi2/w==
X-Received: by 2002:a05:6a00:10d4:b0:522:9215:c399 with SMTP id d20-20020a056a0010d400b005229215c399mr16658748pfu.18.1656629124828;
        Thu, 30 Jun 2022 15:45:24 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id o9-20020a63e349000000b0040cf934a1a0sm13917025pgj.28.2022.06.30.15.45.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 15:45:24 -0700 (PDT)
Message-ID: <fe77e6ab-2a8d-1669-b790-e1da8d4f053c@gmail.com>
Date:   Thu, 30 Jun 2022 15:45:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.4 00/16] 5.4.203-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220630133230.936488203@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220630133230.936488203@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
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



On 6/30/2022 6:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.203 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.203-rc1.gz
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
