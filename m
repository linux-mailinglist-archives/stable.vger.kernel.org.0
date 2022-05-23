Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22C9531C4D
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239639AbiEWSco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 14:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240063AbiEWSbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 14:31:47 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F24A50E16;
        Mon, 23 May 2022 11:06:45 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id a9so12314078pgv.12;
        Mon, 23 May 2022 11:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6QK5Ggf9n0CfVz8Lb2SQFoXn/joTzIV25cpMh2WCObA=;
        b=EMdDEmOHwBk4hGi1iUd53cNOtOldCNgi4eZ/EWt+gIBM0jj4RqCTViNMh6Ho0rgyV0
         bQQHXcFQ3ZaZ3z9sGDzOU5ygznrjSsYkOeHqbfHU10kQl67vBdnH1LB7zyVr0+3Sfdpj
         XZguw7DkPwv5Ah0RkOOxB1LqE7mFweEKq7SooLrWsjVJ0LlgtdXr3K2hb2dfpgAo/HB2
         6A95AjQNZnLmxkdQT+Gpj7z3t1P57/1qcxj6GVFJQllcJwJTxMMe9W82RHa9BJbpO4/U
         MGnRYXXeEChAOhPzqJ8aUejFQeAaaRsgoYBFNMdxwymMY6Zacdp9vvqZcxPsT7q3Cf8V
         KswA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6QK5Ggf9n0CfVz8Lb2SQFoXn/joTzIV25cpMh2WCObA=;
        b=c+g5Bx2h6xKCFGPE5t1cbsI1gFri/8B5rsE3H/toTTNzwwhb3RHcgztLF+L6lckZc2
         B12x7GdCWNrzqRBm0okEBxzp0VlKH2aMNKe36s6BP2oXcAAzaFLf3Yo/mmqdRFDHwoe3
         TfMA6sRMB8a7lUaYuVYzJIGa+J3zjNCjrJCrSfnfkL5ghyKs6zepe4pdCIgDs9yWR5G4
         X1IeQlv58zARNb9b8P2bdcleFUMcrre/Fs17/rQhzH2WVyVw0FpLIOE+3wKd1Jdl5cQZ
         JnNtYVndQfeiWQHeO9a2soaL8QVMv+rzZmLNrZXIidFiY78a8PDCNPrrlGhIzp6TTwJy
         0aiw==
X-Gm-Message-State: AOAM5313x4GNzPCnCvgKTLf856nM/JuooFQcS7aKnB1czWavLzgjKBwg
        DGumu11QLarVJrimvMORfWk=
X-Google-Smtp-Source: ABdhPJzjf7GeOpqZD7J23t3F6aXzgBH3AoZ4PRkAOwzR1Tug2RPfUnzLzXCKGIC7toX/2WHqOB1biQ==
X-Received: by 2002:a63:2a94:0:b0:3f9:d9fa:6218 with SMTP id q142-20020a632a94000000b003f9d9fa6218mr12482914pgq.58.1653329204111;
        Mon, 23 May 2022 11:06:44 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l30-20020a637c5e000000b003c5e836eddasm4922059pgn.94.2022.05.23.11.06.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 11:06:43 -0700 (PDT)
Message-ID: <bb5e6267-9f50-7a00-e406-04f7dc85ed17@gmail.com>
Date:   Mon, 23 May 2022 11:06:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 5.4 00/68] 5.4.196-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220523165802.500642349@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/23/22 10:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.196 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.196-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
