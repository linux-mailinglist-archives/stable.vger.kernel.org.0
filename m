Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9D65F35DD
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 20:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiJCSuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 14:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJCSun (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 14:50:43 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D2543148;
        Mon,  3 Oct 2022 11:50:42 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id i3so7111989qkl.3;
        Mon, 03 Oct 2022 11:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=C68PVRfgf564BAw3r/LjM68/861FlCma1B1eciewfNo=;
        b=hv2cIQ+8CY+WIpuHGWH/mYzlY0YzE+kpT25FxXfl4dWKNfhNm9y/ehgzh4d9q66EE0
         AsWjk9hM3Y1GgvEqgBr5sN8tJS1+5fS2/ULR5yKFtcmzmGZXjWx+M5aE8b25Vtt4ZJaz
         mvTQdUPaeH9uAk0LmtIkUPHCiEySoszJT5Zz0H2gKb43+hGhBlE9N+IwreuH/Gve1WMe
         +PtmWNKBcYhUvflr7EbTBIr2ibsx9urrfjKpu0bF4SLkQYYiL/qvVKVd9Dr9T3YYpx51
         sngpw1y6bzNWte7ldvue9pjoxX4wt4AoRXIfX2k88QBVppbcc2SQ1TmkhZWawvNhdD4Q
         Astg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=C68PVRfgf564BAw3r/LjM68/861FlCma1B1eciewfNo=;
        b=UXn84PQAXgYJmNyuhTosDP3fKp57TczHP2FZWF/CDibitl8kx0f2vW4+lPr93tR0sN
         OG7crRzJaUKtCXQ27dBwz0SOHLP3E6k/1ei6EdyAPo7e5IfbYC38rEgAE8B5/C5G3Y1A
         4dhRTPHIpP+8lnUDfP8Tf1gZtWKiju9ax9zItu9R4KBv69rlLxXt2sITxAUyhSjRDmx9
         64R8nqwKzU5q3k5o2E/ud1md/b3yw7EUzKmQFrGFLQP1MRE0WkwcwoVKoCMK94RRQlxb
         a2wsLIxCv8XWZ6CqjB8yiifPL5K08syblVVx5MX5YaNj4W1zLWMlWy9iFR+tn6sm2y6u
         +hXQ==
X-Gm-Message-State: ACrzQf1+EiWXnSxcZ8QPO6BdxPUkrl8yo0LTtEuoafJyl0B6GkaboDLR
        SR+hJTxCb7EtY+foD4eS6wA=
X-Google-Smtp-Source: AMsMyM7K+n+CytAK8wQTFAehalUe/3ezQxYF8vHhOvHoJE1fr3/psiJWDfGv0LcMVRmlSQUENO0nqQ==
X-Received: by 2002:a37:c49:0:b0:6cc:43ac:a29a with SMTP id 70-20020a370c49000000b006cc43aca29amr14231392qkm.763.1664823041331;
        Mon, 03 Oct 2022 11:50:41 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bl11-20020a05620a1a8b00b006ce30a5f892sm11262069qkb.102.2022.10.03.11.50.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 11:50:40 -0700 (PDT)
Message-ID: <3bb2db3e-d761-bda3-5478-11e6991fa41c@gmail.com>
Date:   Mon, 3 Oct 2022 11:50:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.19 000/101] 5.19.13-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221003070724.490989164@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/3/22 00:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.13 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
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
