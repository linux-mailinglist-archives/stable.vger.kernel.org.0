Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294E8621F80
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 23:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiKHWrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 17:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiKHWrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 17:47:41 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DCB60372;
        Tue,  8 Nov 2022 14:47:39 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id i12so11245425qvs.2;
        Tue, 08 Nov 2022 14:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3jWuZn7uWZydd8/5r56XQ/y5s0uIUxkwchKoJD4NASI=;
        b=bE6Iv2jhT1ZvOAS8p1frKu33Nk7xNjMlQGW0iOK3Q+tg4f9J/XmF8nI57LTvEEiC/E
         455bx8GjbmZko+4XeEhekp3oqHcLj1+OpwZe8QcdWqwJr7MCEdTfdtv3wsbG/ivRC5iA
         jmzrzlF2SN8lLZktciByZz+6/KwUkOE3ps6VrThE//ffh0dPfGZrBghjwF4SwtMmNZsq
         4X2gTM5ZeeGX+BjmW0nz2/5q+Gf75lLOfNNx6vDtHWbDDom3tMx7AoyEo+ofBfAJCCFC
         9RAJAlLYzOpJ1SQ2dpyahpJ/5f8uGpEH/R+N0VLUGknMch26fFO9GoD+ApX3+63rX1gi
         wSJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3jWuZn7uWZydd8/5r56XQ/y5s0uIUxkwchKoJD4NASI=;
        b=ASsPPLpzPRGAllA6HllZ9XwfN0umWlcuyeMFrbnTKW0kHT8sx2g53waOLXtEvem9Qs
         ic+mMrZkmMQVFbvLQN1UENQYAC5VhwuKoGpZEnLV9Yjd37XD87T3+2AajH8cEetPIJRi
         kiHel83BB0i+RFmv+whbgZPSOpOGaRLXLdPjwStp/3bISggkGqMFSsBAMF1IJgQUzeAV
         GGXMpW9nL293zk8++EgZtJw6h2znEnWuMOzG/U9a1odOytfTwIO4KFBU7y5pmbI3EeCZ
         y/W2uT6VSaYydRb4w0BjDiZU+KtRgGkkub64bAwF7GEEY+QIyP3JhHH9SY06tdx8swwF
         KP7A==
X-Gm-Message-State: ACrzQf3Hzp96JDZzWlGirsNHI+CqV62lIEWB4sDWnQJcBWu2F9Dns8nl
        JVjWCffNS77F62dfKvyYL/YyqNfnC/Q=
X-Google-Smtp-Source: AMsMyM7uvDTRqvqA6qiUJWB7a4pIGEIubDi/bAN1bO5JgUl0p0xRdlan70O4tLw+9PHlDv4zGGyyqA==
X-Received: by 2002:ad4:5b81:0:b0:4bb:837e:5473 with SMTP id 1-20020ad45b81000000b004bb837e5473mr53428389qvp.46.1667947659071;
        Tue, 08 Nov 2022 14:47:39 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id c22-20020ac87d96000000b003a5416da03csm8969434qtd.96.2022.11.08.14.47.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 14:47:38 -0800 (PST)
Message-ID: <434806b7-bfac-650e-04f2-ce72ba825bf7@gmail.com>
Date:   Tue, 8 Nov 2022 14:47:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.0 000/197] 6.0.8-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221108133354.787209461@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
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



On 11/8/2022 5:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.8 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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

