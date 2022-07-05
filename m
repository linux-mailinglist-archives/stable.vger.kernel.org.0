Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927565676F2
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 20:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiGESz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 14:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiGESz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 14:55:26 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93DF1CB08;
        Tue,  5 Jul 2022 11:55:25 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id v6so9437014qkh.2;
        Tue, 05 Jul 2022 11:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=m5OR+vYvLk7fq/8PywhjYcdun4fEozhrDnSvUgt9T54=;
        b=l+7xCJLQ8WYZMwxdiYQzxDzGG0oxRp7AoAD7t/MaQAGG0+iG0E4/eewpSYzu4daFwQ
         XvtwcgP5uHu2iD5UFcgbPMcD+BKibK8Q+42z9JsWqLWo413S0tcliuYCs1yT4KUJQ5w2
         EoOWxiC1YO2rFyOvEO1vjfP1xYlAMIsgNw+1COjbQiGZLfnBd2A6kLQM9wd46tSu1umc
         kF5+7PXN+ivOGQ3+DoHFp3O/7im4Zhk8YPQsOvoKXnT1P9BUBuGYdGfFYzgrJe+kiCdy
         Mk6zpb1PI+hi9m9R7ozFp/yfYZJ8h47kdFbWof7FX1baUm2TALqirejSpM6r2oPbTuyC
         tM+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=m5OR+vYvLk7fq/8PywhjYcdun4fEozhrDnSvUgt9T54=;
        b=OpKk+BvBYudVhOEPAYxTSqE6DjnvQzHq7cG2RPaPMLooWyW6f43pzZlYwPpkaxgZTF
         N63KfBnEAxeuFj2AU4XQu0HgBFhQEMpnWC7sGQXKTMPRJxXcH0UmwDwqwjad033yivpM
         /aurbu3AqX+o+jRW5h1KGa9wU87LTXuBE4r2VuLm7EKkDPNG3I1yuUGfDMUQZjeUC14T
         dXfZeEuWxBSJVXC4wAys6T8/1WXRlrDgyJvHWVvHueuY+9a6MV1/HfnQ8ELE/RQdTc3e
         lNcg5U4PFVa+ZSV2IjSDlpe00AG+Mewkvmp3fIirDKqBFdnZr/ALjS4Lj3l28jU9v3IH
         yI7A==
X-Gm-Message-State: AJIora/NcqhGAYPiLy+S7QmmW/JDpSO5qfObSZ/nr5h/WHfLbGbo3SVi
        YYbvTkJD/Qy9yKvkngB3LgQ=
X-Google-Smtp-Source: AGRyM1u815lUoBe6Z3OZYbTAl4VS99Sdo58BNtbnafuZhzAD36HGDfiihPRaMznNPAgxAzTf+zlW5Q==
X-Received: by 2002:ae9:ec0a:0:b0:6b2:843e:9e59 with SMTP id h10-20020ae9ec0a000000b006b2843e9e59mr9236527qkg.366.1657047325020;
        Tue, 05 Jul 2022 11:55:25 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j17-20020a05620a289100b006a793bde241sm30729016qkp.63.2022.07.05.11.55.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 11:55:24 -0700 (PDT)
Message-ID: <c36a0389-240e-609c-cd33-cb07b4f34256@gmail.com>
Date:   Tue, 5 Jul 2022 11:55:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.18 000/102] 5.18.10-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220705115618.410217782@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
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

On 7/5/22 04:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.10 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
