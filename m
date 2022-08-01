Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A125C587287
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 22:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234540AbiHAUxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 16:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234232AbiHAUxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 16:53:30 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0DC32452;
        Mon,  1 Aug 2022 13:53:29 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id e132so10688984pgc.5;
        Mon, 01 Aug 2022 13:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=DrRt3rmkEQEdaQFsMHB+bUVmGYUs4qBKiZq/F5t4yF8=;
        b=DPXa5ugFMKmBlYHqheM6/Cm121QkqcXN7HtFQM7SxU6XFGoZbVCXj5v7mm+tlA8Xgv
         KpjRpwcAIfAbyKcUODigw3bcYi3WCx2dp5c3GvcnxMGJq1rC4zhVLNBjF8Zn2K8YRJuH
         iwdhD4s78oz9nCtvZ3HE3g7RK2xZVvY6rxPELylwTZnAOhEzUiJvIFvSL9/VPKy2Yrpz
         lyyKs21XViNQDL+cPZPDfm7dcBg8uaiQPS5Xj1qHUmqpDwaSXKjSjX1HTmlmfFwxYKiz
         kvBGpwzcUThr47iaOs6x2AlujAohYuFuQbMZRF3utLVIzCHKq5r2Ev5t2cB85rkp4K9+
         ZrKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=DrRt3rmkEQEdaQFsMHB+bUVmGYUs4qBKiZq/F5t4yF8=;
        b=vafmFN2jDTnwzPly9cyuIn2W+dOc/XO7Ek1klLl0a1QES7sXbV6jKBF17tXJnMH2lN
         XJxQzMPRDN3xSchv3TRTiTBnDbEZBBY56rSXByQwyg04EmYCSzTJlrylHrj6kWnqgojc
         qaN5bjh+vZBMCA14rLztdBCniakiPmshzcrWH/Owipk1hpA4aXNOl4zhwsGV55uW4woX
         oX3kVZ9rDoYJGVn8CPJhSaQs29vAzqbE55od1i4rpwMmJkMicecEy/tm3zwQdmtdt/fh
         hcYHCwF7zDfo/k+ZJH2ByBWINfwtg4HichUnaWUkNJMhDhx9ELfHoy2JAYnklv2WS/BW
         YL5A==
X-Gm-Message-State: ACgBeo154hgw3Xdz3XcXf6nwUHIkv7i/pYj1mfxIenZ5LdBn4xGc8xyp
        VLkKbItw4E4yIRNnAS9v4Bv5Exx+218=
X-Google-Smtp-Source: AA6agR7GVr8r6zvwk7Ol6bNWawTHTSq6eMQTyAL5PDXZ6Warkjm3D4t8Juc7os34NcNXYEGTqHGqGw==
X-Received: by 2002:a05:6a00:2386:b0:52d:7472:208 with SMTP id f6-20020a056a00238600b0052d74720208mr6565937pfc.8.1659387209254;
        Mon, 01 Aug 2022 13:53:29 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x16-20020aa79410000000b0052d543b72cdsm3586319pfo.189.2022.08.01.13.53.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Aug 2022 13:53:28 -0700 (PDT)
Message-ID: <dd216056-def1-695c-028b-47a2f45ae13c@gmail.com>
Date:   Mon, 1 Aug 2022 13:53:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 00/65] 5.10.135-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220801114133.641770326@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
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

On 8/1/22 04:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.135 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.135-rc1.gz
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
