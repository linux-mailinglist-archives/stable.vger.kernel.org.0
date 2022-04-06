Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E276B4F6E27
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 01:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbiDFXEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 19:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235387AbiDFXEr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 19:04:47 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4FAAC066;
        Wed,  6 Apr 2022 16:02:49 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id n9so3294575plc.4;
        Wed, 06 Apr 2022 16:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=of84ggpToYZhGQ1nZc9dGJOUUyvolterQrxSu9zb1EA=;
        b=iOpdDefhnXGTy87N1C1gVfpAm5QdywJ/5ovEZVjjyjwH6MLaSUq6+K5005RcZ96Nsh
         EYExtp0yr/+1k+7hpOTg/nS4JgSp3Cv3P0buIhCY21LFInv5jTbNdR61iaOFhgM+Acsz
         JAKK7V2Eyt5MPxxapPubY/TTQeKYHkTF9z8BDMBhQjixuN3LFzXXSfESIwCRC3kC57pg
         BQF5AaLjRiZOFU4haSajhiNdqmf8cxbmU08nOadjoknQjq8hl12FTZIbLlHZ5NEXj6lm
         JQI8wEjD8tuhqGjagMfyGg9tvNzzCiUwsmbRFEAHTQJ+J9Iy6VUoYr28CtZ1oR36MVx2
         PwHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=of84ggpToYZhGQ1nZc9dGJOUUyvolterQrxSu9zb1EA=;
        b=XBDSy7m+PUFdqrdIpOuv2W7XOB1Auw/4/5ub8x3X0pccRC/NPWcUXbREIF03JEuLiG
         8GhQmv0UoTDd1reB0nhbPJ03PVKSXDjGaXptSN0sjHUPC1cK5l/OoLZVLZH2vCX/a5Wb
         qoVo9IJxbbPDCROUQSPZpSJeI5hX8eSp2WLvdq+IEGsVikklwrcDs7AwbyMdwZzCcUK+
         eot9XiPKIKKSSsU+Wim32eBM39WlzYuaCLzTJiuYcatLTtqNWJ93iFecZOhMMmr/IT+a
         fzQ8X6S6nxHuJK8/F7/pFevCoxDbAh25cZCE9hVEyzRbqfON9Ur/Xc/E8oAcKmnFeeSB
         EkMw==
X-Gm-Message-State: AOAM531ZcSdcGjOU85rIYV9qKN+o1Zp5I26qKB2Lrbivmi9jqbDylyHU
        awVinC2pbDyr3SPlG5nXvF4=
X-Google-Smtp-Source: ABdhPJzlxb1AnRNf+mM1KPrcoE9icfIDw5dAGfHnW32hxRIWRI8366eeoLHApMabeljUHyBc4dAGzg==
X-Received: by 2002:a17:90a:3e0e:b0:1c7:ca0e:a11 with SMTP id j14-20020a17090a3e0e00b001c7ca0e0a11mr12497816pjc.19.1649286169325;
        Wed, 06 Apr 2022 16:02:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x24-20020aa79ad8000000b004fde026f4b2sm16603940pfp.199.2022.04.06.16.02.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 16:02:48 -0700 (PDT)
Message-ID: <ef1ae390-d3e6-e442-5f5e-16f411c3ad30@gmail.com>
Date:   Wed, 6 Apr 2022 16:02:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.10 000/597] 5.10.110-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220406133013.264188813@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220406133013.264188813@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/6/22 06:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 597 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.110-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
