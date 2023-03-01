Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F11B6A73C1
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjCASsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjCASsy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:48:54 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BF436FE3
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:48:52 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id op8so9952424qvb.11
        for <stable@vger.kernel.org>; Wed, 01 Mar 2023 10:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6WiBSXa+E48qQYLm/lnScVBkZgoH3ONEJTiQuXIOskQ=;
        b=Bk7Ud611aQR5ZxIg2XFDfdz9bwBG0tQT87zZDFD9qQttXoomfg2yH+AlUwVKtMNtfE
         ohw6GkAbYvDUbCa4PAsgFNk5x7ViEox7Kw5xU378idA8ySHJpyWYzlZyr050/H97thR+
         RzrEmb7Sj7MYb0Zqtc2pAac06tiRKn8BF3FX5b24JI3VrS10L4xOkT95jrpkBcSScVST
         NTvbTG8CnZ0/A2LXceQhN2LY8vLIdspPSiSyim6K99JcwhE9hvz++o9C+iBkvudWl8cQ
         9VYy5dugs4RbJmGzGsM6aJNC+HBMGHiSv+/zBgfJBEVQsDD30+beVWeB3Caq29xuYtKS
         RdNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6WiBSXa+E48qQYLm/lnScVBkZgoH3ONEJTiQuXIOskQ=;
        b=lhbOESdMlwuFxT2jP11zSwpFPHiLGC0PcfXg7+R8XCBOK9A+Z2PwViN7gRHNkbxqX3
         dH75kkxJZ0ZYBC1wXxJ9FByc4gP7ZIfffQJeGTZrOFmRhM7tjbevtUbcPY7R6BisCupP
         ErYgzDlhoiSHvJQWczYCqLJsFZASoev1J323r0Y9yd9GX5/+zuALR101Pj2W8FgvLbFF
         DmhXydkiQNiQO4mBqEuq3Cvf3OzovKF7jC2x8jVuj5zhaE4C/c+9M1FDS92QfZCKQHYz
         rqnxma49umz1w/lDov/nvQ8ljxKkr0SSxYW/s4+h5bTGrlwjpti9MRz7b0RqPGX4UhI4
         RsHg==
X-Gm-Message-State: AO0yUKWsFg90VGoOj5bSp6xf3ZLfQRUaXb230hFhWtLbqFARm9dz6teY
        Rk0zarGBV+eGZ7JfesaX+TcIwQ==
X-Google-Smtp-Source: AK7set9Q32uKpAGHSv0HyLYBLlDB6Bd8twTYxngWaj1UeSvkamYBDRS6Teq/thgmKhRh2KboWK1nbA==
X-Received: by 2002:a05:6214:2a84:b0:56f:72c5:e085 with SMTP id jr4-20020a0562142a8400b0056f72c5e085mr11758973qvb.52.1677696531844;
        Wed, 01 Mar 2023 10:48:51 -0800 (PST)
Received: from ghost.leviathan.sladewatkins.net (pool-108-44-32-49.albyny.fios.verizon.net. [108.44.32.49])
        by smtp.gmail.com with ESMTPSA id s62-20020a372c41000000b0071eddd3bebbsm9296942qkh.81.2023.03.01.10.48.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 10:48:51 -0800 (PST)
Message-ID: <1b33663b-0418-77af-3417-dff4b869f4c1@sladewatkins.net>
Date:   Wed, 1 Mar 2023 13:48:49 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Slade Watkins <srw@sladewatkins.net>
Subject: Re: [PATCH 4.19 0/9] 4.19.275-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de
References: <20230301180650.395562988@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230301180650.395562988@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/23 13:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.275 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.275-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
4.19.275-rc1 compiled and booted on my x86_64 test system. No errors or
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Thanks,
-- Slade

