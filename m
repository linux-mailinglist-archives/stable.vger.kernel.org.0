Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4740B65DDFA
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 22:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbjADVFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 16:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239756AbjADVFE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 16:05:04 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED251A223;
        Wed,  4 Jan 2023 13:05:03 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id c124so37964303ybb.13;
        Wed, 04 Jan 2023 13:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/XU5THAQUA1jHs+rNaxTxSOMF8VC0zT6pdz99GRigoI=;
        b=QNQTAlWqkTt7pXMEjr5dKggBdONYZsm54uq3wxNmYaLB5KtSX1WuSpQU7+0yHf+VhO
         lOy4yiKsv1vTPQPTfwOgMS8NWZF2kL92ITX9drJkQSTp63e6/ZiXbCuis0W6oiqdQ55F
         SH/4c77fM4TG1VRYaKmr+QKKfbVYSp337iyTRZA5iDNAIMnbA1xzQUKuJQBq4mt4OMGd
         6rsluWnpvT9+/XDFg37MdUkAvfRnQND/QNpYPd20YcQzDMkMUrrCYHN9sZxUmcI6PWXD
         8V+qDMAndrAIUihwe1V77kC01V1fKUVrzVB2la1pDeYdFeMqTeLKzLvTUUctHsvP7koK
         dqXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/XU5THAQUA1jHs+rNaxTxSOMF8VC0zT6pdz99GRigoI=;
        b=bH70D24Bk1REu8kfldGqoJh16J1rZOkchArIJLWKKaXkNPHdqV7fp93JZMhJM/GkoL
         +CFIQR4Kg3XJukeIpD83EjzDCLfMh69WA2nOG4YDNwScqi64Bauo5OCbQOiD+JmsRnCw
         hpPmhzKjzZgVn1sGquoLiEskftupOjsv1YOXO4hYxsEio3s3LS+aLb1e8U/KzxyMIQie
         VYxMFyeKl+y4eosAtJKDOcOFhbciOr4FshTn9x/6hBkSGr2QVxw37Q3Uc8WUzfJOxI2b
         KjhxBagdd4fZwAjc3tjcsIJObn2zPCAMbgnk+6NY+Ypkqy0dmGdTf0sPAHhTvwZytgJY
         Snvg==
X-Gm-Message-State: AFqh2krSMRbDdXvxOnis+iINKCp+JNd1nJdAgijEcoD6h3b5O7txk65E
        oyvRjKpDEnEotAIDjkxc9H4=
X-Google-Smtp-Source: AMrXdXvTw9QO/IAB66eho0erA4De+DdNxfVRIzOiORrFOjGYCjAASAEiJauOSRN9xVOyTgiK+2OAUg==
X-Received: by 2002:a25:7753:0:b0:746:3cdd:33a5 with SMTP id s80-20020a257753000000b007463cdd33a5mr46934846ybc.0.1672866302716;
        Wed, 04 Jan 2023 13:05:02 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h19-20020a05620a245300b006f9e103260dsm24653195qkn.91.2023.01.04.13.05.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 13:05:02 -0800 (PST)
Message-ID: <eee5c4fe-1dba-5fe6-478a-52abb37e7358@gmail.com>
Date:   Wed, 4 Jan 2023 13:04:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 000/207] 6.1.4-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230104160511.905925875@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/4/23 08:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.4 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

