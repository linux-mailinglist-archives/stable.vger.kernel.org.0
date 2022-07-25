Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A40B58036A
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 19:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbiGYRP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 13:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiGYRP0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 13:15:26 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636BF6380;
        Mon, 25 Jul 2022 10:15:25 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id ku18so11107234pjb.2;
        Mon, 25 Jul 2022 10:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=efOld1cAMlpibVUYxdt0+k6ABjB7KiaLuNzhS8ufSHM=;
        b=BRH+NjEbRo/NNCXoaNfFlVp9ZLh9jRlv8l9p9uqHwx+eI9DlYtzkcQaPFP2WkLuAvX
         SPIwLDPRGvgG5dx+X1yQ6p6SkrYHuTOJUpwl+/2fwtX1nw44x6UbXIyVEeUYVgttavMb
         ogsOTSPOAVcU/JtMg/q1AgEek7oNUZGeJZkhWQqj5zdWzWbUwiJRq1i/nvPbLskHIQ4W
         qxO3g35pIr2qBdXVVelulW0baRZ7LbGDeSOdRzAX1AXGqt5wrscQteUurWcU59Vrpo3P
         kgosvmNWLf5HBZQIp2c4YKwfB5DYR2cbxHJLzJ6x4qB7KYVfZ/3QLfF6oAdps2WCwlTs
         WX0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=efOld1cAMlpibVUYxdt0+k6ABjB7KiaLuNzhS8ufSHM=;
        b=bjbAjw1oZ/jlArfOoywzdF9919f/UeSW/jmAHuRVxaA/J4Qv9VUeWsK+5LBFUfgqHs
         5RihJpcA6lc1CijKt5R15Kx0p2hKMicsgVz8epT4h7RDTveeadfRB+l6GEfLmo1VapUC
         wWivggli8X4FytvQUgv0qaoOrhIgcrFa2AIES8U61oSOgMdlpoEG7qxH5Z1k+TXIfH9M
         tYW6n3mP8vEDgeCaKarPUpiYboKxXMIfAZ8FmYOjm6nXorFCP7n0RUQxddSeTQMBfHlq
         1bI6r4jNpbupjfkIAQv+fxOHp7qf7yfxaoX+1a5dA0BOHVunGCl3aaSTFotWL0xTyLW1
         1auQ==
X-Gm-Message-State: AJIora+ieYTglg11hY3rZhYqklbmTI4QR5aC63vt6CPEuWKM89WoVXGc
        4SFNwPYBOPENX2O3d4Y8fMc=
X-Google-Smtp-Source: AGRyM1vhKX2YLKP3Zs47Az0zWvQRrFBNJl3WhhfYF3n0Qkny3FWjFxe8ZxmZbmIVU7J07Vt56yD+Xw==
X-Received: by 2002:a17:903:1250:b0:16b:9866:c2f0 with SMTP id u16-20020a170903125000b0016b9866c2f0mr13547263plh.68.1658769324707;
        Mon, 25 Jul 2022 10:15:24 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u3-20020a17090341c300b0016c68b56be7sm3472378ple.158.2022.07.25.10.15.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jul 2022 10:15:24 -0700 (PDT)
Message-ID: <18246d4d-c902-b856-f671-27b666f830d7@gmail.com>
Date:   Mon, 25 Jul 2022 10:15:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 000/148] 5.10.133-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220723095224.302504400@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/23/22 02:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.133 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 25 Jul 2022 09:50:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.133-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
