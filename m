Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188FE5523A1
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 20:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238101AbiFTSNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 14:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245084AbiFTSNR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 14:13:17 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D9611144;
        Mon, 20 Jun 2022 11:13:17 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id t3-20020a17090a510300b001ea87ef9a3dso11019049pjh.4;
        Mon, 20 Jun 2022 11:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2N02FiZrvhil8aNgdzMkYh6Kly8KvSddHHesGtF5gOc=;
        b=ULqWw1MMKofjcyKFpKb5/DYOgKCJm4uttZFNlW5PaizQPD5C5Av/xpDk8MzWDkCZl/
         mlEqYfa/IPahqxOjhBKAgbxh9PqTq6wndUUc7cMjWmLe+tSUSpmUBARAympWw+ZH1kko
         KgJI2th52ggH3QI9rq+AUlaucb855vV+Oy+Q9WiEkLniU5W/PJUYL+OL4Eojs7070/pT
         5WJD6NABIwB5ytTBK+pQsSowq8ijnrSu1/5w+QftCw54ec+Af9hcBdSDNzYx8npeZwP0
         Fc6V02KJCDyayxMXHT6hJfSRvYWACjsAZWFeN0c6hhuBMr89kCdHf+rZoEObvbkx3Ssu
         AvGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2N02FiZrvhil8aNgdzMkYh6Kly8KvSddHHesGtF5gOc=;
        b=AafJv5Yb+UlIaxTlKJVkhW9Zv14+Gu4boWYLSru6+86y5OqyoRLZGJF+rWfJj1GyKk
         Iv/LwVQcxvfFLmxjAnvqA3ihwHg584RI+PfEz1nPwqI4xy46G+vyq3Ev/uZr6MruytRo
         sxGJMrrMT48ogRIhCNRlKHu7M4dnXDRls/N6NySTCIXkWUAlMB+Y1q7GZrv3XtqjbwtZ
         ZFhHXizaC25K92OW/abbDcAdnIjIwjUL4kO/gt11dmVhK7dr/Ghd3+l1Kc0CPwAizPdW
         mc1OKsAJKNqYCjBVn4z8t8eP0YHx59fOwW0Y3svjoRZ4KPyfTka+gb3z1Te6LzepsmEV
         Uddg==
X-Gm-Message-State: AJIora/+Y324FJm+aDbNRX+tJHbbuT/FAJBjYS22/P7YQXo8HkUnVsMV
        NBOOJTQE3OIDfdo5+28QGN0=
X-Google-Smtp-Source: AGRyM1tLH3VbvNoP4gutzqUaZkRK0Uo5KSu6f/9va5xR6Nn5EiIpvVbQOnPAZg1zZ977Id8haI4liw==
X-Received: by 2002:a17:90b:4f4a:b0:1e6:9bc5:277c with SMTP id pj10-20020a17090b4f4a00b001e69bc5277cmr39105189pjb.43.1655748796506;
        Mon, 20 Jun 2022 11:13:16 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u123-20020a626081000000b00522d329e36esm9786271pfb.140.2022.06.20.11.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jun 2022 11:13:15 -0700 (PDT)
Message-ID: <469e833f-d234-0dba-6526-4f9c9645e49e@gmail.com>
Date:   Mon, 20 Jun 2022 11:13:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.15 000/106] 5.15.49-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220620124724.380838401@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
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
> This is the start of the stable review cycle for the 5.15.49 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.49-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
