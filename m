Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F065C659325
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 00:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbiL2XZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 18:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234153AbiL2XY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 18:24:58 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A1F17400
        for <stable@vger.kernel.org>; Thu, 29 Dec 2022 15:24:57 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id y4so10437082iof.0
        for <stable@vger.kernel.org>; Thu, 29 Dec 2022 15:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j5M1qEcQ5hCYalkUD046W/PZUv5GPJc2CtY9IYHcJB4=;
        b=GPNV4dpaVxP9zTf+BkpTVlxnIJ/f72GDPO6A4JPyT+83cUiqXMxxB35FAembUAsyUf
         +VDfmCVPAlHOOgLGnLRuxoY77abUw0MgvYh78toiFQmagMhrHiW2aFSm+Ed2AZFMXgWl
         RoUHeQ96WEfPDQXU8bTwrOX0Pg/sOL6774W7w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j5M1qEcQ5hCYalkUD046W/PZUv5GPJc2CtY9IYHcJB4=;
        b=ldfdKs7leWoHRtmBpBFTZNWKZ5jfEWvFAjTXaKS67e6Fryo9KdC5ojwwBdekrjl9zT
         b1wB7tg+rjEfgtxTkCnS0vP95jiXQ1mk+BWIon/1NKVEfsbDZJf4GMv7xI1HGkU+oF6s
         Wk7E//gIuexMJkRTewWpeXn1NOOKepnonuGLtPF9HCjUa+Bv4GdloiUX8DjsRyxPTxOk
         C6yTPtZgh1np+vhlomzB3+fE0BNd6nVVB/Hy2pKJQ89vfkTJkHg6TPLpgfZpRLqsiE/X
         AlBDNbJzPjXikmQQaqFQvBANWx6bA8EzkDst/eh2l7YS7CBlzeX2ZfR5OoonSts+PTuB
         fS8A==
X-Gm-Message-State: AFqh2kom4v1D9P1EuoNPV0nAFsphJHmMqz17oAcw4aBIL1l4Id5bjmdZ
        laa4iu9+YBy5E9ZmiHlEzNedaw==
X-Google-Smtp-Source: AMrXdXuPlOK6xinbIDs6LEugKfP+/pOjZA22v2dJAt+MghoMvVAdIGho0uLd2B7G4BnDyTOvic0f0Q==
X-Received: by 2002:a6b:410f:0:b0:6e2:d6ec:21f8 with SMTP id n15-20020a6b410f000000b006e2d6ec21f8mr4265883ioa.2.1672356297026;
        Thu, 29 Dec 2022 15:24:57 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id b2-20020a029582000000b0038308683a09sm6536106jai.143.2022.12.29.15.24.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Dec 2022 15:24:56 -0800 (PST)
Message-ID: <528f1b8f-927b-0c9f-8558-6d814aeca8f9@linuxfoundation.org>
Date:   Thu, 29 Dec 2022 16:24:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 0000/1073] 6.0.16-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/28/22 07:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1073 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
