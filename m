Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B71D1505D78
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 19:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346985AbiDRRYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 13:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242820AbiDRRYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 13:24:45 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90586338BC;
        Mon, 18 Apr 2022 10:22:06 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 2so13523794pjw.2;
        Mon, 18 Apr 2022 10:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=F0iRw3VgQscT6/0XFHxVh7cgsAmiEmZpweYGGHzkE3c=;
        b=Vnc0dolzjhTYH+RUXDVsGRBcl3ihr+wXgH1YYpgicBJ6ojt04pBZxtqpY9GC2kzHCN
         HoaEO77m/1nvx96MegKE+ctwSCP8m2gKgrhNj2zUZgnDQJIC2EaO6U3WivH8DVq6fqp3
         RuJ7eAH+sakFgGO3vT7yyc1MCTcG+veIyWwLsgM5lbC2je92JHW/noAdXV/wC534Xw7R
         y2lyZWLQzPtVVfzL/viNyJ+A9k5K53kx7pXvUPpMEwVcFs9LxgyCkX2qHQtu4dYrxKQI
         EK5s2TjSlbv0c3gmVYaIrWjBpOBafuZ/iNS4C1DjnpNkO5FitrSguzKMyKGhW2ZUBejh
         p1sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=F0iRw3VgQscT6/0XFHxVh7cgsAmiEmZpweYGGHzkE3c=;
        b=jc6U6jq6qnRzDfEgZZwtbotj6l8wxDMQZ3m8CdE2YBXhoCdpybTj0Ns2O0MTC0b/1s
         hvlcs1p7OAv4dBqNXO5dNKkNKN48zJqmJYIEbGp88OePUDPMhtWRGT3+J0pZa+PcFDA5
         eQLqdUGBw/yEWJlQFh27aBbzlj/9WWGGYe9DgLy7ECkie0xHiHlk9k1AruLZSIRPDY4y
         hwRb95Ap12lNHM4Ot3mwqamO5t+peTfi0jNk8uEtKa1G3HlkSrzyqEUoqW0p79HmECsn
         sLCVKfQzHCd8WM/yHufoSafJkM5Jz40l5OOjVkSHz3UGHBu0qVEOFplCHx8xIG4VUrGr
         Gtuw==
X-Gm-Message-State: AOAM532iaImQxZF9Vb4r+aXoMh7xE4amhvGu6MxS0lRqR8q1QAHboDQt
        lRo8gjgdXxRIBpIDTLvixDU=
X-Google-Smtp-Source: ABdhPJx+DqNOjCvlY1CVI4tjfVPfe5BuPrfNf+ircXuy8BT0iwtFFea5fHiIiUoZY3+TBuvXKHG8BA==
X-Received: by 2002:a17:903:2281:b0:158:e95e:e0a9 with SMTP id b1-20020a170903228100b00158e95ee0a9mr11148558plh.157.1650302526031;
        Mon, 18 Apr 2022 10:22:06 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id br10-20020a17090b0f0a00b001cd4fb89d38sm17054891pjb.9.2022.04.18.10.22.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 10:22:05 -0700 (PDT)
Message-ID: <e4c167f7-bdbb-cf88-fcdc-fc0b07488b40@gmail.com>
Date:   Mon, 18 Apr 2022 10:22:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 4.9 000/218] 4.9.311-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220418121158.636999985@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/18/2022 5:11 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.311 release.
> There are 218 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.311-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
