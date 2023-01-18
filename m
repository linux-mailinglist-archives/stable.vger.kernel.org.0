Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECEF672660
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 19:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjARSLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 13:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbjARSKv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 13:10:51 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B5F5B45E;
        Wed, 18 Jan 2023 10:10:40 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id p24so37690514plw.11;
        Wed, 18 Jan 2023 10:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=E5zH3GBetx96dCsoZwnkPO6vR0i5RiVAVI6xw2JpxH4=;
        b=X79dGUbdJLmO78NITz9bxQ2PPcMmDREYzYKRxXfAIDnRhePe72ma2mNOi5Llu719NS
         1gCNDN/7Ba5xswCQ48zqOQwl7923ydE0YrmEQvo/7/QcC+dCqj9ISPJXmMUsvMGAjKqe
         jrCXLa8S4JvTFb5RO4bpC0/eLVKvCmOI6bFH46o4ijMKzDiHf+MzOjT2PGLvaZRz/rUn
         2cqAMfmzwwoZbsOvJA8BhMGMt9RGg25DBdQVtEp4JK9Koca2q8byXfPz+HOseNBfxAIK
         RRdjSeuEwVwyvs3OQ25SRbjs3rxbWLnjew0WCbuE5p7RvWuPuRtCXJoarF927XPFcDY/
         8v0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E5zH3GBetx96dCsoZwnkPO6vR0i5RiVAVI6xw2JpxH4=;
        b=KrlyIau5zQytKkxbOrMAMD0UdXa8a49lItZ3tXWBU9aeJjTTwZDPkfXwK8mgZxooO9
         aPT9X0mcX4k40zl49o2+oT5yYhIwuB1SK0Ckw/8JF/nlncQDMu2wotZ/k36CbyQb/L5I
         AwJ41p53JXyiN9UzSTV3ACFC/bJMBTVawli++WtNuztpdooZfv36xMGUJT4pz6V2kexQ
         RyekTV9BAKRKNAhcGYdVt3iFyZ+gKKHXKZ/BXEGsbTpXdlGY5CSaFLnPGuiayo5b0XHG
         +/J6ChLH9wzvuFUvu+Y3QcaSuIQsSu9/SwMQ0ZjVCfQZb3DTx5xDou+aIyaTkRt5XFMO
         7H3w==
X-Gm-Message-State: AFqh2kogHPttmkt1EOa26FxB2iwKrb1EkPCv4zhwsmTL633eGqp+/kyB
        wYlcjgg7+OE4qRIkR2umT6I=
X-Google-Smtp-Source: AMrXdXsbNyD+Ta/0C8GXROsqTuRCAkx0uBuYzjbvCb9UrFOckwt9AkSVIWFPYr2J1iBPBcC238jEPA==
X-Received: by 2002:a17:90a:3ee1:b0:225:c712:5df8 with SMTP id k88-20020a17090a3ee100b00225c7125df8mr7457734pjc.3.1674065439463;
        Wed, 18 Jan 2023 10:10:39 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x4-20020a17090a6b4400b00229934a0a6asm1636237pjl.4.2023.01.18.10.10.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 10:10:38 -0800 (PST)
Message-ID: <82bc97c8-c59b-8a71-0f1d-67837cce91ec@gmail.com>
Date:   Wed, 18 Jan 2023 10:10:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 00/86] 5.15.89-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230116154747.036911298@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/16/2023 7:50 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.89 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.89-rc1.gz
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

