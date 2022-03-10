Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D034D52F3
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 21:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244568AbiCJUPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 15:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244559AbiCJUPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 15:15:23 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C857EAC8A;
        Thu, 10 Mar 2022 12:14:21 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id m22so6301484pja.0;
        Thu, 10 Mar 2022 12:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZXqShG6xq/RA6sHyYooe5EJG7PRsERkEwkvzvU/W3+U=;
        b=Crm9iZNRQgsjsSwUom0YtoxjeFhJmTQAeR/NQokWJwj/+N+7OyKxVZ8ukD1jYV+zca
         aR2P6RHau/wXts13jPexcZ5Th9KFIQPO54N4V5av6mk+XFp7nte/yDGE76duo1nDyvvp
         0g1hNcIQuwaG0IHV4AbTNpTeKfouAmI/jS1KIqXIP5RvUuaTaBfyZqcdjspao2eTViMP
         WsUHKHavR475SEdQsdR1Yv9ZTs8wVidPvyPyFj47HsvHS1EV3Tk6bRrtUYz/iPJKabuG
         /0cS/u5VtBIcAH4d5EB+hFLf06mBtNuHyaEHg2uVjKbKh3C9+v82rTiD+f0cUSS4pj3V
         QwQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZXqShG6xq/RA6sHyYooe5EJG7PRsERkEwkvzvU/W3+U=;
        b=yZxLuZ3VyZnAmgLnrEZoJb8olVHRdYwZStAbMwLBZ27x2bOzgWwBxlWnw4yiOEpoY6
         4/F04BMnjUeceyHRN7bHTTMLLe/RI1jaBI9SfMwgTT3qcc2z1HStXM6QHyFOFH/cKnVz
         5Onr2bBmm5pLoptGiehL0opWAcA/KJ+/jEChyCftJqL6K90FmF+F8ECEqrIiOSaONYsn
         8gxlhUT03ehQ0HX/zV4MhG/RICiiMdL0eKWkrg1AdACeZd8uprEKxBipDGnF5Oi/LT5W
         juojRVLNZRBwlhkRjhs+uDYjUT3rRl71Xts7YNywdvl77UT+uVuAyyDewxvhywIbtlt+
         LC/w==
X-Gm-Message-State: AOAM5306VyZ3RKon7gD6JP20C8EuGNJvtRaws0DggZKfyLiVn9BNJpZP
        22Hp9Z66gLKBV99m57gSbSY=
X-Google-Smtp-Source: ABdhPJxap/TGIsIrwGMN64fsLt+GoUq3Z5PBNXBwnvboLYKV4vkILre1uF4WhOcyNwz3FYNAMx8/ng==
X-Received: by 2002:a17:90a:1f08:b0:1bc:1b9f:9368 with SMTP id u8-20020a17090a1f0800b001bc1b9f9368mr6990796pja.63.1646943260518;
        Thu, 10 Mar 2022 12:14:20 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id pj13-20020a17090b4f4d00b001bf2ff56430sm11505590pjb.30.2022.03.10.12.14.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 12:14:19 -0800 (PST)
Subject: Re: [PATCH 4.9 00/38] 4.9.306-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220310140808.136149678@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <780a1c8d-e072-e083-2ca6-88eacff92ac7@gmail.com>
Date:   Thu, 10 Mar 2022 12:14:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220310140808.136149678@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
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

On 3/10/22 6:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.306 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.306-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
