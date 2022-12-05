Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A999B6439B1
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 00:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbiLEX4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 18:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiLEX4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 18:56:35 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6151D328;
        Mon,  5 Dec 2022 15:56:34 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id ay32so4589663qtb.11;
        Mon, 05 Dec 2022 15:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iIy0CU7yt4+X9mKqU8x+YEdNsjIIrmk6leKhWgrrnKg=;
        b=EuKe8P+/DODwiEjsue4QUosOKRNzQGiO4ljWrDWvTSjOYalJ1nodD5y2e1L/Krn+5o
         CjN3z3kwEyqqVk8EsBkuNjPmColYfJEKxUnTdD8bgBSl1c4SqHmo8lx57z1VI5RnZtHA
         RyeX7f9N3CiOOKikm4xC8i05FdjS0ucjR1t/GHocu2XYfPjZ6bGm1exzChbr0W2ccUem
         Y/Ys4qYob5fzRx9QuS1UAzchXpIfJZ3iSooau1xg3/0MLzK5TM4Um/FFNug0mq3v64vq
         B6Kc4SjieW6bKvC0e9ztGnu9szlc4vbpgBRDUxN8zAYD1Q0DYtWkzWhmdebp71Mny40/
         3H1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iIy0CU7yt4+X9mKqU8x+YEdNsjIIrmk6leKhWgrrnKg=;
        b=rkApJGfz6g6XvNd8ee2ssKBeHRiLo7HqSuZUJIR/AdwlbG2e0j1Qz3gBL4pT2a7VYD
         QO0Q2006Xr1ry2VEo5EMt7n7h3UDAZEHBAcD9lE5fKUg1YmUB7oSLEJRMEY4R7uMjR27
         vqszow2meN0Ns1R5BKujEAFWkFuXVEISXpt1pcdgKS2F3NajD92MkRBLuhJwDkzj3moM
         3YcNBe7VBWAQwp6vjywcT2tMF0EMkmJRa8SghC+cXkDgkUdtyxDoMHgp1bg8UZoH+/Gl
         XhAGyzkkHLGhbyM1hRb15lgMrb3ownw3IHXAWwJZhawWMvJJ8c84pWH+3/8Ua1MjIiqT
         UZNA==
X-Gm-Message-State: ANoB5pl4gs+aQTsW7+jzHFvwh3NSLt9Gf+IxwRA9bs3ESVPQKTDzcfeH
        UnwEVYtLw9YLEergtxHmAqM=
X-Google-Smtp-Source: AA0mqf7lMDNT73WkSKJf76e53D015ySK+agv0dvW9aOPQG/JfKsPXCUNiRAgDRYVRj7vCMUZXYNYjg==
X-Received: by 2002:ac8:75c2:0:b0:39c:e98b:ea12 with SMTP id z2-20020ac875c2000000b0039ce98bea12mr78450279qtq.151.1670284593552;
        Mon, 05 Dec 2022 15:56:33 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s22-20020a05620a0bd600b006fc3fa1f589sm13684026qki.114.2022.12.05.15.56.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 15:56:33 -0800 (PST)
Message-ID: <b4b89dcc-4e15-303c-1071-a0d103ca4d68@gmail.com>
Date:   Mon, 5 Dec 2022 15:56:30 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/120] 5.15.82-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221205190806.528972574@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/5/22 11:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.82-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

