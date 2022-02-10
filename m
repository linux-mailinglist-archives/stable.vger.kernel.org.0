Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF834B1461
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 18:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245173AbiBJRhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 12:37:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240449AbiBJRhP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 12:37:15 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AFAF03;
        Thu, 10 Feb 2022 09:37:16 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id d187so11475160pfa.10;
        Thu, 10 Feb 2022 09:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j9chVedjPveRS2egNejZPxBiCg/i8KLfGe+nH/dm594=;
        b=b/mYvT3TaftybpPKjycoZcETyoiur0ClFuh04DeTKACYPTRehG3RpJR5aE9kgbjhEt
         sJp9Vrm8kEf1VSeAItyjMnGGgqu+G0MqsEcWDUmymh4Eg+8ZXXX6MAJcgt2gUeefob/H
         7zT0Wtee3k6xsQpCIXP3EjuNwZGmlC8+KjyhBtZYOLJpUSNUZjDKAHxmJBtPXG8QzYdH
         NRpiiAHbdlqN+GZ/BtQxrbS/UYuyXWdXvXEn/58DiCc5oQ6MD8I7Klm198dSsRHvdyIL
         +uKYNPHqEuko9u1IWFUhnKsFr7B0NhgveCOxv7X635rzcbQll0MeW9pxYxsdKs51/2oa
         vfIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j9chVedjPveRS2egNejZPxBiCg/i8KLfGe+nH/dm594=;
        b=Z7XpU9Nv1Zqq7ljKwM5REHgIZLmiwZzelOBMOWo0+mjgPEDpDUoST3yrSjgVa59lnI
         iSxJQydjkLy8Xx6AomsbhE8ohirI+HKZW8GlMf9T+MhygNSHK1ORBJ7GNwqOKCg132xW
         Ste9DrHTn0VqfyIid250w3PByzgpDVdaPNtf/5LUkDYfFxBH1rcP9qpNRuIfEyXh92tV
         5MXs7v3vbydiHLj+c/eKtsONZV/qLL/mULi/FAc2lOLmknzZPOzlxjnPRq+vUmXPKp0h
         ZhX/u7YYdLpKIh4oLcPjINK73QpYVEScdOkkTS8z6sad0L6moTE1Tr1jJgBUeYUmioSs
         PKRA==
X-Gm-Message-State: AOAM5305SZlGx6dlevmgXU+TIpfIkEvQoMBQrZP80HK7CSLW3BaKrb74
        tBk3RZzCDSmfrCwR81rvUvI=
X-Google-Smtp-Source: ABdhPJyz/IBTD0t5tBW0miqVPUmA8MzME/0u33MwkywpiaL9uVeHgC2Biaq6P85yAX1hbe1oKcpxbA==
X-Received: by 2002:a63:2a45:: with SMTP id q66mr6956953pgq.484.1644514635682;
        Thu, 10 Feb 2022 09:37:15 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f30sm9574952pgf.7.2022.02.10.09.37.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 09:37:15 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.10 0/3] 5.10.100-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220209191248.892853405@linuxfoundation.org>
Message-ID: <5ef8faf0-dc42-2313-efca-17030e24c4c2@gmail.com>
Date:   Thu, 10 Feb 2022 09:37:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220209191248.892853405@linuxfoundation.org>
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



On 2/9/2022 11:14 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.100 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.100-rc1.gz
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

