Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58B2B4BEFE9
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 04:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239715AbiBVDOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 22:14:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239621AbiBVDOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 22:14:02 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E64DE88;
        Mon, 21 Feb 2022 19:13:38 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id y11so10579818pfi.11;
        Mon, 21 Feb 2022 19:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dIqoPHxY0fMmhlHV0unYZLqkT6KG34R2cScl211p6NE=;
        b=eeyGK533iufI/lfufYF6NCRrQMSKt+8TQiIrG3pUK8uY5g6OEgx8p0pef0YQ1jZ1Mt
         koxZMHPgRcTIpj8qgvu0fSF/DepEmiEuVIsgpbzE4TNjuG8y0/ijILG8ubEvsh7NsbVE
         zGSL7eK6+Rwtm1baf9ecWTBKWqolaUJSuIYxitb30BnWPKb6uy5Yf0StXy+dZ35/J/Ii
         6lH2FeKuSV6eSLrHMfgtkCjsxSzwF38squcrtxPL73rFph50fLKPZhGsnsRqCeslLhPs
         vrz2s0HaeWm/qDqjD2/YdVjCqPF2JOBxUHgrmf/3blnu5xge48+7wJB/9olgDRGlfA+8
         dyZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dIqoPHxY0fMmhlHV0unYZLqkT6KG34R2cScl211p6NE=;
        b=GVWAB+oLhWLYtcmH/P15NT0xru2W4jXxm7tU14xwlh7lXUeB05KNUPClX6ye7i37A8
         DD9NIMmzC32GCnSt+XlO9M7wFQQOcSM7v3nTorzQ4O2wXWrOCLjBxtkGRtFgSH0pH6J/
         Wzz34/K/8Oy/g/pMLX8vyUs8uHXeNM35YkBTQcBTxERx5lUSJgIdaWVyicthCOAGcg/n
         UXUhDzkURbASt7tlbOFxlNshNNjMJIJEpUUJ8HaDMycMc8rE2Lm0HXobYpjEek9PWj18
         PnG2gK85Q0OUDswZ9uFe3If6NuqXRC8kNMdm5nwgrlHd1pJzXwRek1SVa7ZW51uoMhZu
         lmVQ==
X-Gm-Message-State: AOAM532TmPwqFYA1HTiA26Eu4S+e2grb260u7vpnWZ3DKG7vlaRlndW1
        cJYBJQcKsogmbfRVkzKuyrc=
X-Google-Smtp-Source: ABdhPJw/6iSUndkgfm3aeKRdL2WQbtdxUkB1Hg3Nr8Z/ynakvkyQhV3DzHE9bOW7J4dVBILnJZq55Q==
X-Received: by 2002:a63:d252:0:b0:363:271c:fe63 with SMTP id t18-20020a63d252000000b00363271cfe63mr18450444pgi.524.1645499617606;
        Mon, 21 Feb 2022 19:13:37 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id y12sm14182578pfi.49.2022.02.21.19.13.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 19:13:36 -0800 (PST)
Message-ID: <937be4e5-6737-bb27-dc37-f0b7acc14582@gmail.com>
Date:   Mon, 21 Feb 2022 19:13:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 4.9 00/33] 4.9.303-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220221084908.568970525@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220221084908.568970525@linuxfoundation.org>
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



On 2/21/2022 12:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.303 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.303-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
