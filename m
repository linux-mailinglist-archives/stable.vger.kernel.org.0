Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE704B5C10
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 22:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiBNVDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 16:03:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiBNVDk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 16:03:40 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD1EF8BBF;
        Mon, 14 Feb 2022 13:03:32 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id p10so10704134pfo.12;
        Mon, 14 Feb 2022 13:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Wj4WGwMqPVQKZu8zhmymyTgFJvhq0FOFAzV3VPaCu00=;
        b=HfGCoORaO/ySEdyF600sBz3jOA2A6BUbSezFyu/1ZDvzN53ZdoCN5glKd1Kwwrirk5
         FagPjZQzpmsX8Ah7AZzxGM42kbA8wddhZwgE9mZN3zpP0fNO+zZNKOG4P+fH972BElvt
         kOZ6xHzO5zp1RAF1WfdiHNjaL5YhXbfOIooYe9wFHa0nJcmcay2sy4Rn4/YUw/6hK3+w
         fER7ylEY0r6sBC5VLUlQ9Itxxoho2zWdbHs4YbJYPhM7+OcPP+KfrNiqROxbZpNhOtjU
         8uPj/C0B0I/3B2pIRhWmU0Hcbn4PtVXtlczWBEXc+bLRauXcj1tfRqSp5h5MiPRuEAEE
         UWwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Wj4WGwMqPVQKZu8zhmymyTgFJvhq0FOFAzV3VPaCu00=;
        b=iyExrfMUBDVNm73nk0/jKs9rf/KsD352HIgmeZoCIEAR2Hy4fLKtVa1PB4PlDhSnjj
         RyZRcHBnM3+NPMrHy8YC5BlNFJZA2xjrhVnSLRNrW3eQ+ze/17GN5QG1KSAkQAM8Kuyh
         62jqu8oYCTH5+vnl75JCkJUbmSCBh/nADk4Sf2e2CaJNuY7Z8u4PoFq3UTpFf79nzNDz
         8KK9q5KrSCymZiqjJSCy7+dcJo5DhKNPORkRvwQmTs/b6UdwNRAf5KuG3ZWF/e/my0GP
         1fjKRyD8SIi4chLfPYPUyW5RmN9cJVoAaLKLtanByigPONAckNT1EiSF1h0jQw8nTHIU
         3dsA==
X-Gm-Message-State: AOAM533iJSDgFwy/ReUTGIXW0JqcR7K0fzGIZUKQMt7Xio92ZJ9tUsdo
        4BEIDLhXhg3nJaqPXq31prtZNV6bAdg=
X-Google-Smtp-Source: ABdhPJxYanPj40Iq/7eR2B5rmokfCDO3YI+/xoYmGzQ7veUnF2srakKEJoDn32raO2PimNGZY4ymJQ==
X-Received: by 2002:a05:6a00:b85:: with SMTP id g5mr841297pfj.27.1644871010657;
        Mon, 14 Feb 2022 12:36:50 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 142sm29901059pfy.11.2022.02.14.12.36.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 12:36:50 -0800 (PST)
Subject: Re: [PATCH 5.10 000/116] 5.10.101-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220214092458.668376521@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a9e9d19c-8fed-4e1c-00ae-032c329fcb35@gmail.com>
Date:   Mon, 14 Feb 2022 12:36:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
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

On 2/14/22 1:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.101 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.101-rc1.gz
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
