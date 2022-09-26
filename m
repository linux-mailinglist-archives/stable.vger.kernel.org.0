Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A3B5EB140
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 21:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiIZT0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 15:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiIZT0I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 15:26:08 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92425A146;
        Mon, 26 Sep 2022 12:26:04 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id a20so4745263qtw.10;
        Mon, 26 Sep 2022 12:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=l+Ylk9b//7nM5mTF/JCsuVNj5uiO0MLoAvHLsDMzYN4=;
        b=cI2ST1Qax8qktOIHjeYgTuoX4TzEN/mewsTIMufWIXGP+FntEEYpIOkgYvn8bQmuQj
         4B2qdr7KHg3LPJH/g93/9G46uch8bXMKMoj/X/gwKlnH5+lHhkblOHeyEU6OKm0T9DSQ
         Jq+1APPi0Vyp1ElmK7nKzW4eHOXrwaxnwvadiw6wxstOO+nhTIiuvqZsw9YwejckGBfb
         AAH7aXyatPmXAzwC49CJ6J20zPndpRvV3DEBdlrZWTx5c9Wo7jwXgpGPlxYt7aDme5mz
         Ynyg9eyA+RGaah++8Xha8Yjnk8Bar2nlysLYWYXTi1mnv1U5XYC6PbcaPaHjP6yfqg8L
         4tbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=l+Ylk9b//7nM5mTF/JCsuVNj5uiO0MLoAvHLsDMzYN4=;
        b=Xugal5Oj0AnR2/tcZ5ZjyVRYsWkZCY5fV6HesSkjnZyg9QFb54Ec/XCSYXSWX0KJiZ
         h+Hn4b5evssHUjbjCqfGKw0DelfAgPbr31/y6LxRPe+gw6QnOjkR49GFXbXtnB63HjFj
         v6JB1c43V4O5Q3ecnMRNo8pNSc1VbN7ReFZajYz3BxrBmk577WGQnYAvfpoOmLxVIexn
         PAMopQxjl+Ji0FVzvUXhYjYj8/FrgqEOUSY2mPlpxx2HQOrlspQYP1U+dtDuc+fkJiaD
         C65+79PFUx7DYX4Vm+AukvzSJQ415vK+3BRq+dIPQRmKVNNuV+oNLWPbQvXuv8hOZSxb
         ZVuA==
X-Gm-Message-State: ACrzQf3YoPNo8992ekMZqx2EFIgpR6zEszcbni1Be0Au/GK5uttqA7PS
        TgsW9TWALl84CpbyYi9KGVTfisjvK+Q=
X-Google-Smtp-Source: AMsMyM4ednUq3Wrdb4DnYp8vSxPsaz8T4EIMmDveQ/qAZnfYxXb2BI3+bXTgiQiJU7CNJAortNdQ1Q==
X-Received: by 2002:ac8:754c:0:b0:35c:caea:3e73 with SMTP id b12-20020ac8754c000000b0035ccaea3e73mr19696321qtr.504.1664220363879;
        Mon, 26 Sep 2022 12:26:03 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s9-20020a05622a018900b0035d43c82da8sm1613547qtw.80.2022.09.26.12.26.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 12:26:03 -0700 (PDT)
Message-ID: <36397608-ae17-5359-d3e2-4676aa9ecf97@gmail.com>
Date:   Mon, 26 Sep 2022 12:25:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 4.9 00/21] 4.9.330-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220926163533.310693334@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220926163533.310693334@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/26/22 09:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.330 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.330-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
