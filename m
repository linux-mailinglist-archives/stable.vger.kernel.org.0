Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9574E5BC080
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 01:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiIRXOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Sep 2022 19:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiIRXOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Sep 2022 19:14:41 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9695FFE;
        Sun, 18 Sep 2022 16:14:41 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id z9so9282719qvn.9;
        Sun, 18 Sep 2022 16:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date;
        bh=jzQ7mEK2fVOhiWHENt8aHj8m18py3+AhxtaCeE/IDeY=;
        b=QBcKkQWYzM+NoKZkTgsToOzUlDqoOGrZVxtm6UWFJVMGK3+4A/Jm8bMwQkGp9bCqu3
         ZyT8rhUOoAVXn0d8baIUpgIs9gd8JjCQDhd7pl5OUF9GG6gmToelw8xsjSuJyAfvxQEl
         fnk/BWbUcMEfoWkrIRLRcqXfEF42ICap5pieIGxUNCG0mLjMRKx9GGgSQtMvUdRM2TJ1
         QBwQYF6v9ygkfZpAwUKQR1aLd7YVF+yXndRBEmU8hPZNEDvTjDG4ndyFJzztZMAfJIe5
         yKe/IKzr8R/r6LtO0W/BH8Yh+hz9FEsTqtgHu3H1P+Ykeavj0khTxgRceOIqZolQ1oqi
         Sieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=jzQ7mEK2fVOhiWHENt8aHj8m18py3+AhxtaCeE/IDeY=;
        b=PcK/r3hOtN00ITmq1D0z/bUp+Y4TVS0VbaMlmMKTPMpYJZkCw7PEsxK8F3hKR0YOwq
         pyGLkN2pCkSANpcIuBMwiPFgLIT9D9dPsNdd8YkQDRk+DQeh4Oud011Lm0rIP9MVL/S9
         VBX95hhB9M0Zp0d2m3Co5CwhWropTc0tOl4VKG5+G5pYdBW5mclCziIUfj8rWGLqDBJv
         lCLmqkzviY3IELyTCTQrG1Dm5ECY1tC0DU24magNtejtVk0nAbPAe3xJu61rOOnU8XES
         WT+XPzb9mqqpNZZN+gzGowD/ihjey7mvmkTc+XcKYTNazx2wI+/Y1SwTRDJXoZHYiZh4
         xWeA==
X-Gm-Message-State: ACrzQf2rWBGiKpE719jviwXoSoCF1jOTXLfL73+CP9d4+/FDCbhJCl6L
        G0DyPS6AhjgGM5TxkUlqV6s=
X-Google-Smtp-Source: AMsMyM70U0XaOzC29eA8jbq3QoZjALGQPHgq+06Uz6CUIQQH594yrrm6QRQXKWVBMDUtR6LEuJYP5Q==
X-Received: by 2002:a05:6214:27e4:b0:4ac:a631:f551 with SMTP id jt4-20020a05621427e400b004aca631f551mr12486238qvb.12.1663542880187;
        Sun, 18 Sep 2022 16:14:40 -0700 (PDT)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id y4-20020a379604000000b006bbe6e89bdcsm10737556qkd.31.2022.09.18.16.14.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 16:14:39 -0700 (PDT)
Message-ID: <f578fd31-f5d4-013b-88c6-a17f7c3888f5@gmail.com>
Date:   Sun, 18 Sep 2022 16:14:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.4 00/14] 5.4.214-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220916100443.123226979@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220916100443.123226979@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/16/2022 3:08 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.214 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Sep 2022 10:04:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.214-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

