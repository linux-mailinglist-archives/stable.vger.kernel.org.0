Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F234E7C7B
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiCYX7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 19:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiCYX7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 19:59:51 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5F94ECE8;
        Fri, 25 Mar 2022 16:58:14 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id c2so7660659pga.10;
        Fri, 25 Mar 2022 16:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HvxCf3iBrSFVUSs66FB91DG0UktB4J0Sg+YOQsWz7fk=;
        b=Sx3Tvz+cKw4R5zZC4XIRSWbNij144XsxY3qYemBIob0BO8WV89v5fijUFP1JT+45cT
         NMe/RM2tRaFK9TtUN5I/N6HL/Zl3B7yqShIjaNF2QDQPNbBamIWWiHzXOvR8pRJQ57VB
         3n0D4OICMTCF/cqgG9cEFqfGImU+pqrGmLTrpW2C5DqlIQBYnJGdoJ4i3CFaGwYxUkn7
         J9vRqBtKsh3Goh8w91yEqSaMkWFx5tykA95jbk/QTj84rt8Zzao7kFDBrKqyYrVq7Kqo
         z55xF5InST0F3q/k2nup7B4bb08DYZGEqTeo7D/R5oX9SIH+g8jkW+2yJ/a53zDqn9oM
         /LhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HvxCf3iBrSFVUSs66FB91DG0UktB4J0Sg+YOQsWz7fk=;
        b=ahTOSkdQtGLP6G0TjY6wq6Wv0GhKw1v9adYVo0dIEpJ0Rn6CTp3j8kKqIIOwYi0o7M
         hD+zmCxtlgWE5MCAHGrerRA1YfxYsMSJopkwgGDQAi4giRALrhefpFLXrk5XWmdhoJKw
         nP20B+LUToXQELp5b3xE346Z08Rk+D3EuOx6ADPAsQeWNAzZ+TeZagkqwysTIbVIv9K8
         UzDIlAEX4m9KOM2nEazbw4IUt1f0p93WYpR6aN4z23cosotf2L+U5o73YWD+ee1Z0Dv4
         FXwalvNmn/uS379/NzImCVc2chzdY5heAf6JjdxAqvDxNTWpteTvNTTD5abiLVnsHBt8
         0w/A==
X-Gm-Message-State: AOAM5320QuV5bWH5iOwdSLG+f4ULRqPacFEp617tIpKMtO3huH9hBEfI
        J0KslHgOpj90PKQwtrA5WI4=
X-Google-Smtp-Source: ABdhPJyvphW1Yu/OQG67MhyMMjYVw58/xuAHy9Sq3Jg35cthYi6mc1b0ZkypUTKNTbT78bfldJaz2A==
X-Received: by 2002:a62:38d1:0:b0:4fa:80ad:bf5e with SMTP id f200-20020a6238d1000000b004fa80adbf5emr12494004pfa.69.1648252693994;
        Fri, 25 Mar 2022 16:58:13 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id rm5-20020a17090b3ec500b001c7559762e9sm13793727pjb.20.2022.03.25.16.58.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 16:58:13 -0700 (PDT)
Message-ID: <17795ca5-fe40-1259-6b33-f1a09d6fcff2@gmail.com>
Date:   Fri, 25 Mar 2022 16:58:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.16 00/37] 5.16.18-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220325150420.046488912@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220325150420.046488912@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 3/25/22 08:14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.18 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
