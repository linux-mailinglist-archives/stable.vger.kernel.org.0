Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD9760BB5A
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbiJXU4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234324AbiJXU4R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:56:17 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492893F1C4;
        Mon, 24 Oct 2022 12:02:19 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id f22so6186592qto.3;
        Mon, 24 Oct 2022 12:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CozUqg7YwpS4ovQKkqpk2bxWG5AUnh+8+yTOuh93bTc=;
        b=nmts/kPbn0fQAdVu8UHgAtSdo3CwiAQVp8RLTMLlgWMl/t7BLzzUnbOLxpQ6UAvaKp
         rvWsr46vUYxeI1oz9Bf5rj/7KcluvYR2HHVQGJIYGfSJY1slUvNHDrlgy2xNp3C9aC6C
         gaghq+LftAMYK6+BKQnCYl0LsBw5IndhGULEBNO85S7ZiFVCQFn9Cey6RDdC7eMtV7tz
         TSG9AzzEx/uNgdUfIc67mYg+BuVhf+bt+McMRZQqjje6xiXk7tJpg2hKxBulcq5x0/Pe
         zf2U/j82Envy/CjAEV69LNpYNbRnaJY7hRTYLcBtZJU6rMmfPx7juVYhgCl3i/LAFVOF
         0knQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CozUqg7YwpS4ovQKkqpk2bxWG5AUnh+8+yTOuh93bTc=;
        b=4h1ld7N25eD/B3uCe6ovo2WqvaSYPcDyig+rciOqMHmL3CDbAOlvzr0XMITOLGnbg2
         e4XCj5qc9lXAqlMDH0/8/D5HudWqq57D2IO6hJMf89uGPEuSmfzq7MnDbGigbPvO7ZjU
         GlmQAtGWzCXhTnvqlrBJ7aHwvQVIkiV3plw9OGJYLGTEEl+5tuzbaceqI6W7HnxiEZN5
         jYQ30uKwD268QNq2t//KNfClqK7S7ZGcRbZ8s/hucfAEblZog2on7QzAQrl1Nl5oxOqC
         y5Fy31Jhd3u3uhVF84zJH29Z8FEScAF53XR8zFiIpzFnzeLinbv9vzINzz1Ww9g1KCrO
         j4Rg==
X-Gm-Message-State: ACrzQf0fFcTKBRDXkTeqf1w7OWDMRMFyh24o6btr2jiDbkM2RVDBavpv
        Pom+aEnshbi9WTixcwea33k=
X-Google-Smtp-Source: AMsMyM5sMtUQwhK9RVN5TcIjvz2j0WuPXmFvh833LXBGzP/oBW+p1x54tY7t9xMn/UEDZy5hdzJSBw==
X-Received: by 2002:ac8:7d0b:0:b0:39d:90d:601b with SMTP id g11-20020ac87d0b000000b0039d090d601bmr21829872qtb.278.1666638102319;
        Mon, 24 Oct 2022 12:01:42 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k11-20020a05620a414b00b006ce9e880c6fsm448176qko.111.2022.10.24.12.01.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 12:01:41 -0700 (PDT)
Message-ID: <c8075805-2543-d46d-8b42-99c734603b36@gmail.com>
Date:   Mon, 24 Oct 2022 12:01:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.19 000/717] 5.19.17-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221022072415.034382448@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/22/22 00:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.17 release.
> There are 717 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Note, this will be the LAST 5.19.y kernel to be released.  Please move
> to the 6.0.y kernel branch at this point in time, as after this is
> released, this branch will be end-of-life.
> 
> Responses should be made by Mon, 24 Oct 2022 07:19:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
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

