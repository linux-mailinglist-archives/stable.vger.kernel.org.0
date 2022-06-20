Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 215A45522C3
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 19:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbiFTRbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 13:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbiFTRbi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 13:31:38 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4397192B2;
        Mon, 20 Jun 2022 10:31:37 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id p14so5149563pfh.6;
        Mon, 20 Jun 2022 10:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1bLgqvEEENgFKUoyFnVjLtWmBq98EqIomCusSe2yS1Y=;
        b=oQZp6BJwz75SgKPZozr/qgEkZS7Duw1LYftku/nK/zp+6KzoZwUlb0wLd8us6aPqeg
         ScKgamunEvRL3wesdw1/8bYaKuI+ZZMfrMHNLL1FLIDIl7zrPpueXEP9EIZ9ARoYiA8e
         r19GPvnsrtnmGG6B+8yCw2bw/FdC6B2oruJimqr+PvQx8i6l1/dyq5oNxV1WM6DyrSkV
         v4dwszTzkkFL7y6K0Mvje1wHpkdsf41v5PCHJjm7n8UMd+4kQuxNxViPygYS6O2YOo9c
         dxtBcYj0/KaSfmsvoVPNkNJbDYlQQISRAdmzc0uEtiFVv/FCtEVGKKrMS+bZyyN154eJ
         x96A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1bLgqvEEENgFKUoyFnVjLtWmBq98EqIomCusSe2yS1Y=;
        b=SEWleRcmSnu4W3vd/ObwHuSWsXxsJg8WpWQGXaaq2PjTU9aQ4ZE27/5XoKazXiUuAv
         ep5Z7siGDXlI0OTvchDaV5U0U3ghvC9LQuIU9H77b/YQ1yWFhTJVh+mif35rXhcIDGvh
         7gnWWjsAY/2YBz7LYPH6NRXumwI10Y5UgJ/NKZG532P8m/FMT8A1EUbN1mGJ/+9e9N+E
         A8vRIhBiYgp+HD1AJyLOh8pD7De99PjQSrRLKWJDN2Plso0wz9CPF8IOBTZi8tSBfcdq
         cmE9hwebwnouxvRpdaZc2lbYtGe+3+LWUq4ks0PzJR5neOjycQb7J1PuJtat3ROIJ3jD
         PcMw==
X-Gm-Message-State: AJIora9jw7vKw6v6Hyssu3StPnvT5Oki8ZcBEz4o7ud6tkudS3To4Z54
        6DbodmugF60Aby7U8ch5C4A=
X-Google-Smtp-Source: AGRyM1tWDGnQpGz0cXjZi00gcXj3IBEjyYEslYQUYPyp4qlX4AUpq8R2xQr8QTEJWQDff+Htf6+jgA==
X-Received: by 2002:a63:1a56:0:b0:405:28e3:e4fb with SMTP id a22-20020a631a56000000b0040528e3e4fbmr22939811pgm.16.1655746297171;
        Mon, 20 Jun 2022 10:31:37 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u5-20020a17090add4500b001df264610c4sm18627794pjv.0.2022.06.20.10.31.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jun 2022 10:31:36 -0700 (PDT)
Message-ID: <e1aecd67-0458-fcf8-a077-9ca7609c9abe@gmail.com>
Date:   Mon, 20 Jun 2022 10:31:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.10 00/84] 5.10.124-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220620124720.882450983@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
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

On 6/20/22 05:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.124 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.124-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
