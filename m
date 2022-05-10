Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07FFD522350
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 20:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241934AbiEJSL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 14:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242075AbiEJSL4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 14:11:56 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1A41EE;
        Tue, 10 May 2022 11:07:47 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id l11so9694575pgt.13;
        Tue, 10 May 2022 11:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/nf6uIVcjppeutxxDowilb8C/GDQ1nfk+JMAW5ceVus=;
        b=e7evLJy2tX7KxA5hB9ZRVtChgA4w1Chtaf8YOnsQwLetUxG1fuazPi3etv0ZkJcTtC
         niTU6OIu8Q2TwLWHnWBf/LIc1nkk0Cw6xHD6dH/PNssp3LcAe9qS5Jcc5IJspwL6y5GL
         JY0XqjN5sU5ualI5Dqp1BuzAckzdmVe+/BS2iF+R03Khmqy5JQMvsCT39pJ16jdrGHA7
         cw7W+epe4D5ZeDmVkEE49qQlfGnSFwF+d7vKCpAfTDCgHIRqXZGoJ077y6Ikc0Q6kT13
         ixaFh8w7op9zhPZTvYHZjCvb8DliT+Wuy02yZm95Ca+56IL6tpfb5Nj2DhycUsv4Bljx
         qIzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/nf6uIVcjppeutxxDowilb8C/GDQ1nfk+JMAW5ceVus=;
        b=e4Kv/G0sOurn9MaJcwAZml60iba+UU5i9VJ0cpoIUge4g5uw8cht+FldXMfZRzjKUm
         Fh2RCpZgx1qz1fxwda2O8eDuSqCKsNIUwWosLLhuAN82xfiOeFDEjLFL9wujohPdnX/X
         iKjTM4Z0XSvokTkAcFu+oWDYpydTb2PBOcQR94cy3QRZzctVS1IEP6Qm+ozMrseifPBs
         tALIkDZKXUhjUUyXojchzl0JpLiF2S8sJHsVTncz5snhJ2c8jLzzcOF6EwpP4bYAa0jk
         Ajj0Zrq0r2kwgdXMjHTHln4aQYrawPnKEReIkfuIxRsPhTnr9fZ4GSl5vx7A8plDK/QF
         P1iQ==
X-Gm-Message-State: AOAM532eInuE/G8suaJs1Cu8BxAGWg2ECREcjS3aPy4airg8H6b5qYj+
        WAvLP2sVkVHPj1eADQPyUwTdZS/bfe8=
X-Google-Smtp-Source: ABdhPJypro59zbet7Buwqj5FQVKZ0fwVm7W9acHH1sCs2IbZ8obnpcXwecZCQ8IRy3V/7ptR94WCTg==
X-Received: by 2002:aa7:82d9:0:b0:4fa:2c7f:41e with SMTP id f25-20020aa782d9000000b004fa2c7f041emr21623163pfn.1.1652206066524;
        Tue, 10 May 2022 11:07:46 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 72-20020a62164b000000b0050dc76281c7sm10992704pfw.161.2022.05.10.11.07.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 11:07:46 -0700 (PDT)
Message-ID: <16bcda04-72c1-2c9a-ae24-b5ee59df6286@gmail.com>
Date:   Tue, 10 May 2022 11:07:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 5.17 000/140] 5.17.7-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220510130741.600270947@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/10/22 06:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.7 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
