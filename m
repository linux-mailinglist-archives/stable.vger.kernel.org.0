Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7716B55E23D
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239862AbiF0RFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 13:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235591AbiF0RFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 13:05:51 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA3A15FCA;
        Mon, 27 Jun 2022 10:05:51 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id v126so5498609pgv.11;
        Mon, 27 Jun 2022 10:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0R3AduDYroJAGIiiG+Jh2DNO0iwsy6h8YXWYMHiE2eY=;
        b=MKdMCghlWquFbSuyyxcpMdFy9I0feANtk93K2OdCz6GM+pAmL+leesdHI+0g7knVZP
         lzxkAYQpmFV3kLiR+f3XtEHCG94ZDLOapgTaySDwafZKUfP//NIGF6g1PT3YOwluFYL2
         goRS90C2h22ikl0ymaoBjR/LfCWs0MgvLFhWj/Hdvpkn12nY0xLYhF/cyOL0LnMP/w+4
         L0qJj3barAaz6e/7f2liqIv3p4NfLVAI2ODO7SL6UenM3xcCju83xIfyi8ZyOgXHviwv
         9qXDmWAT8MhoCK78aKqB7VsfcDJko0QgCmERm0niuxnnaxpj1uO3kqrJO21FT0AU70yO
         aF6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0R3AduDYroJAGIiiG+Jh2DNO0iwsy6h8YXWYMHiE2eY=;
        b=D1CNBRPzyRLG6dhGjPgx25ecf8GoTQh/zL/SyP4h6P+I4Epl+BtNpXUFASelzyzqf4
         jZnjmqTobDjskhpoHJE4c9RcnNHlimgzocd30f4bHNCHaNuvYME/b+EQivYKYB9dLiQ0
         yjGeiEkmd2+pBlkKZC4sqaTnxL2aRxqJqZUhnR6yjFWDguHcAjjeHKZptBURXVvyDIZx
         bTPqHIbfahfKF5pRD0tCb6rNlkSwINT8lNt7vCVLU8Ep2OcLRcD1SuoWPjVPD7NkpjDb
         Vzf7x+6P0ioKZ2z5o/N1nBazbre6mzh95+oEG9lspVTLf3WkbHu0rWY5lfxLQRNgUirq
         RbvA==
X-Gm-Message-State: AJIora+UE/NlEfygsWao/sSHewSYYnBkoyUAiWVOCvx2KXVI9+DM+xpT
        1vMbMqFdeSHU+FRR8BmVBZE=
X-Google-Smtp-Source: AGRyM1ubAUvmFXEhWZqdNB95qxL4EobJyWkUmGM9ChHCf65q4HXVSp2kT9cFotQSLqPDhwIdynfjpA==
X-Received: by 2002:a63:e64f:0:b0:40d:e79f:8b73 with SMTP id p15-20020a63e64f000000b0040de79f8b73mr6806285pgj.243.1656349550489;
        Mon, 27 Jun 2022 10:05:50 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u27-20020a62d45b000000b0050dc7628148sm7624190pfl.34.2022.06.27.10.05.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 10:05:50 -0700 (PDT)
Message-ID: <388dbcd0-8e65-3c7f-0f08-f55f59eb7097@gmail.com>
Date:   Mon, 27 Jun 2022 10:05:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.10 000/102] 5.10.127-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220627111933.455024953@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
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

On 6/27/22 04:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.127 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.127-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>

There is however a section warning generated which is already reported 
in the 5.4 stable queue discussion:

WARNING: vmlinux.o(___ksymtab+drm_fb_helper_modinit+0x0): Section 
mismatch in reference from the variable __ksymtab_drm_fb_helper_modinit 
to the function .init.text:drm_fb_helper_modinit()
The symbol drm_fb_helper_modinit is exported and annotated __init
Fix this by removing the __init annotation of drm_fb_helper_modinit or 
drop the export.
-- 
Florian
