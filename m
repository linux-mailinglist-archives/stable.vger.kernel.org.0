Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559B7643998
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 00:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbiLEXfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 18:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbiLEXe4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 18:34:56 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDAB1F9E4;
        Mon,  5 Dec 2022 15:34:38 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id r18so11830544pgr.12;
        Mon, 05 Dec 2022 15:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aHpH0koW71v/gNWUs8go+lrDnb52j7CWUOqHhEfGdM0=;
        b=gsFde3HUYz7Yz53ctyOl999WurTwkF6KGafYkT+A62Z1gxrY1M3n8F0zJACffptg62
         FEtd/PVbdC4SE1pg+noGbT7G03EIzyDfL9pXlRyeZzyvLgrcPScv66fHbwMSnfy8LnJ7
         xPmfAO8bmBTdAknl+sC8ORt21covOyMN1WlK2S+rLWk5JZEftu3R+QDR6EPYRn7738Gl
         V2i/0Eyyry6QRfBiJByQjg1/oeRsFBF+4Z12yI0MD/U2AepAwCei5Ung3HKHgXRGZSuK
         4ll5WYP3TRC4wMI0YG76VbBlejlUpC2ewsnDZnSuau7RWQBkFTBNIfH2VhrmP3260BPU
         KVkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aHpH0koW71v/gNWUs8go+lrDnb52j7CWUOqHhEfGdM0=;
        b=RHi8RCILDdF0HvzmDXxikHFlk4JlMpkSj2KGCGXJX+K/wfD8wDtwmd4wlneRhoybHR
         tE86y5gyXWhAlGy8unHO0MAma5Q9wcqQndTCtOVAEwLFN3kLFLwToe1LCNGhZHyJm4Vu
         o4PExK++qr0lZNJpXe1r1GMau1bSSGKlg2GkD0GhCpp7z2WbuIcVqqGJwoyZHeh/GZ2y
         H7JoqfanAajf7bHrWIMcGZh4cXzZJd8EN3Iqajflzm/6fsy45t2Zbu5IBlZ3TKgvLpAJ
         ObuBN8Yb6IjyTdz2sFhCmswKbpZquqcFNTFc+ahX5UN7HQiT/aTr70PMGMbGWjv/2dpj
         QlPA==
X-Gm-Message-State: ANoB5pnpNE+PKk6sKCm9HBo7cJc51ssR2j+Du1cMD5EGmEESh6zMG3pV
        vLzBpQeMhWB6GIhECXcC2i4=
X-Google-Smtp-Source: AA0mqf6PnUuIQY0pCVuIeDYd5kASTPnCO1yfcd8JTB7BhrHfxMM/jy0ZZDES+A9qQOwoeWjhtatNcA==
X-Received: by 2002:a05:6a00:1c8d:b0:56c:f87e:c662 with SMTP id y13-20020a056a001c8d00b0056cf87ec662mr68183904pfw.65.1670283277656;
        Mon, 05 Dec 2022 15:34:37 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a23-20020a621a17000000b0057630286100sm7952974pfa.164.2022.12.05.15.34.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 15:34:37 -0800 (PST)
Message-ID: <ae9f8db2-38a4-8410-6d94-222e8f48d8e4@gmail.com>
Date:   Mon, 5 Dec 2022 15:34:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/92] 5.10.158-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221205190803.464934752@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
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
> This is the start of the stable review cycle for the 5.10.158 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.158-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

