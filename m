Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4F546A7668
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 22:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjCAVuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 16:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjCAVuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 16:50:51 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBB255066;
        Wed,  1 Mar 2023 13:50:36 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id v11so11985287plz.8;
        Wed, 01 Mar 2023 13:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677707435;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CY/G8VL1j9svKq6UXUSNaPlCs+v3E+YYw2wZs/Qarhw=;
        b=KKKukoB/FejKMejFiidmTdPsUROFvlM6TbzAqQXHQP9iA7NMMMaOM/WuYsrJuTemvr
         QtEaSPXhlbxEYkhUa+uQdVegAUXo2ZQfwgL0+Gd6dEqfSufHLbDGG9D34fNvU1s2PIPU
         8w+HmXPRNVzVKW1VLNNh4lo1zLgAs0JiIM5H9oOHUOfwsJMaf312n/n/5dqZpm06tjYa
         QVqyLSJ62TGMi7ILn8RDvt5nYXu1erOp3CWQkFOfYmPvbs6KjM2IMN8+AuwByJqyYA4E
         TGyvSFuNoBThg3ZFXbOX75riN98LNHSDlUpq6sRhn+W+GfZdWpD45Hg4o9LpP/yRP1Qt
         Gm7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677707435;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CY/G8VL1j9svKq6UXUSNaPlCs+v3E+YYw2wZs/Qarhw=;
        b=nIZ9BkO+qQnSLtZzXloNgRIw0fO+vB/dU3GY1qqk4zzL/4gEWT41+i5kBNalsUc/io
         dzqgUiY7Q2uYtXxYfRspmT3UylmdFzsdFinKnjFmCRpu8kwI4ky+eW7LyP6QDf1I+y/C
         0m8Er3ktl/WB1nYMP7hlFwl03x74rXsXq5kFupkmjk41I3FUDASvQWaRGeoj2+yvUHVN
         WIn8VwLUVsfq0IvX7DgNK2k+1oyNTgzF3GVUMGnl4IQSXTmmq4K06uKrCFWXi2BzGblM
         hhmJxX1RS4Zkc+8204H177MeH/gOnhP2ddOKjKKHiMxyVbeT6KqYrJfcsaqqdYjfPHPm
         VTxQ==
X-Gm-Message-State: AO0yUKV7UM5ZpeyGLjinTqAvvl2RdU8dDf0pVshdIMAk6xZGoni0EiMg
        aB4UtW0ZdPWcCG34DHKtaHc=
X-Google-Smtp-Source: AK7set86T4W4m3qQ09dclQaqBWGByUWQ2bxyxzgNfkKg3sr6yZgUgKjoiTGlSoWT7cXVRWRdj4dZhw==
X-Received: by 2002:a05:6a20:8e18:b0:cd:9664:3d5a with SMTP id y24-20020a056a208e1800b000cd96643d5amr10531686pzj.22.1677707435576;
        Wed, 01 Mar 2023 13:50:35 -0800 (PST)
Received: from [10.69.40.170] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u8-20020a656708000000b005004919b31dsm7899513pgf.72.2023.03.01.13.50.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 13:50:34 -0800 (PST)
Message-ID: <ddd46923-fc25-504d-394e-2c883977aff8@gmail.com>
Date:   Wed, 1 Mar 2023 13:50:33 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 00/22] 5.15.97-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230301180652.658125575@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230301180652.658125575@linuxfoundation.org>
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



On 3/1/2023 10:08 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.97 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.97-rc1.gz
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

