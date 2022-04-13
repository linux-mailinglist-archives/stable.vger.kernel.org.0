Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6664FF18E
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 10:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbiDMIRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 04:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbiDMIRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 04:17:31 -0400
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964F22B257;
        Wed, 13 Apr 2022 01:15:09 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id c6so1400382edn.8;
        Wed, 13 Apr 2022 01:15:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=b7OQFtb9IzWFEdMg9Jf8xDohElrELNGGJBR/v407gy8=;
        b=XH4AdsB0ZFCHn0dtJtAKfQgx7xoT41Kx5c6QSJCn59haIT045RVT0+q8WavA4Loesc
         /rGVZWYv/m6fG2Vb4/QkFNgcjFyU3ZmrOPk4mpf3Be7Afq4TJfJeoIet2uUzDBz2zEaR
         5qDfuXjYO9NqQD7xKzR1tYDWraWjtcA8WSjh0NeMSaK9RfNt/bnyN8ph8upDfHaDuhU5
         DkkocTPjb4zW8scCzDWXoi6BpDoxGlV2eFLRZxIlhKk1t3Sl9cTV35WurxA1DPi7VYBo
         GpzCWbJNUczuyiWEzdFuyNSUYXfwpLPZ+HE8/7M3c3AjxjBsC1r1RCY3bX0RDJAY3vAT
         g1BQ==
X-Gm-Message-State: AOAM5301q/Tc70eX9UMOqTsYSWsoWmyUFxtRyXHRmFuQftDNxErTCYP4
        NFKR2eR7B22X3zJyK+qcwfM=
X-Google-Smtp-Source: ABdhPJxv6o1vsteFSQJfJ0Yq/pgVOnRcb21T+mXiiCwTTENujzJfHBQji3hJ1MPj5jXTTzejRE9xmg==
X-Received: by 2002:aa7:c054:0:b0:41d:5276:a6c4 with SMTP id k20-20020aa7c054000000b0041d5276a6c4mr24586410edo.109.1649837708049;
        Wed, 13 Apr 2022 01:15:08 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id bl24-20020a170906c25800b006e809b6bf89sm9258472ejb.221.2022.04.13.01.15.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 01:15:07 -0700 (PDT)
Message-ID: <6e0c47bc-51ed-2d23-1f39-af0a2c091d03@kernel.org>
Date:   Wed, 13 Apr 2022 10:15:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.17 000/343] 5.17.3-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220412062951.095765152@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12. 04. 22, 8:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.3 release.
> There are 343 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Apr 2022 06:28:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.

openSUSE configs¹⁾ all green.

Tested-by: Jiri Slaby <jirislaby@kernel.org>

¹⁾ armv6hl armv7hl arm64 i386 ppc64 ppc64le riscv64 s390x x86_64

-- 
js
suse labs
