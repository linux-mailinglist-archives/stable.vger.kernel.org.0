Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281BF4D54A9
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 23:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241859AbiCJWhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 17:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240182AbiCJWhj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 17:37:39 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04544BE1E8;
        Thu, 10 Mar 2022 14:36:37 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id h5so4784366plf.7;
        Thu, 10 Mar 2022 14:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=33M5anzT4Ii+wzmo4FVpoDH/Pf5wsZ6Vn05tTCP4sGE=;
        b=czaA9ofrpr/Dsn97afRKl/I12l0EZPvjBfVdKKOTrjttkrDz4tem3vs0eNnDeFCJc9
         4hdq+bdmYGGYdUJorewfhxnMO8u5gAiF/bFFoRvPfLIFjWoQb3IaWpgJJTowfMP1F+bc
         x0OeizMr+oEy2hINSS4LOcwBZY6yDcXzyR0LpqaiaXCcSr5CckcDF1FYdhwsRgSvUsSG
         zb289SPwkTE828VxHiWzuM4+6Alr/JxiIbyuMc4P2I0Uj70OGEpTII85NXbp5yk0O7T/
         flkt0zL6ErjT1FFGmpx2CZPzbblpHbdV2IlLT+XCODqHaLNZ1bMGZYnBV2Xqk0HeQY0O
         Uerw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=33M5anzT4Ii+wzmo4FVpoDH/Pf5wsZ6Vn05tTCP4sGE=;
        b=SvLQ7nIiyKAneGALz9Sd3hIe543nIqzw0h47zmZhpkQQMl64klqIRTIhS5QTKFzxlB
         dGMRbp3RGp4R/UJe1IDQsDBPTlMxM+uwEcGApeuFa1vduCZplAZTV6OnqKwns6955hmb
         4Na5urz/FCTyk/Ev7OET6lEpM3d4K1cSJW/dRF9yG6nyafGv91CV2P9vLQnWpziQNuBI
         heZ8xvr9D3hFIT4cpV/wjHwB/JUoiRnroDaHi8tyABylEGOZfpIBFhou8QNbowZlF8IP
         gzPw30cjcDvGH3SlbB15AUBwDjzO/sB+//YemGuVcOCnCrgVZ8omYG9dPjDZye8ebpr9
         O77w==
X-Gm-Message-State: AOAM533/UF9eDFUd3eIP84ATyloCGRKF9Z3VheQvZjKqHxuRE6jUynRN
        1UFjEPTe8Qj/7AcuLfqO3yE=
X-Google-Smtp-Source: ABdhPJwTmQFYlAa8Pg3+y019BZ7d+Wf0NutKwC5DTu0vlHDp5nIh2JFJmXgfzorRwHBZZEGmJJLG6w==
X-Received: by 2002:a17:902:bc83:b0:149:b26a:b9c8 with SMTP id bb3-20020a170902bc8300b00149b26ab9c8mr7234286plb.143.1646951796517;
        Thu, 10 Mar 2022 14:36:36 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i11-20020a056a00004b00b004f6907b2cd3sm8087021pfk.122.2022.03.10.14.36.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 14:36:35 -0800 (PST)
Subject: Re: [PATCH 5.10 00/58] 5.10.105-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220310140812.869208747@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <242732a1-3fa2-8f8e-f25d-725464869426@gmail.com>
Date:   Thu, 10 Mar 2022 14:36:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220310140812.869208747@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
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

On 3/10/22 6:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.105 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.105-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
