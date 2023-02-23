Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289696A12CA
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 23:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjBWWZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 17:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBWWZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 17:25:46 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C69A1969B;
        Thu, 23 Feb 2023 14:25:46 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id z20-20020a17090a8b9400b002372d7f823eso807608pjn.4;
        Thu, 23 Feb 2023 14:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rjj3snMpxZB2TRf050gHgvkyriwKTyczDaG6fgrNL/c=;
        b=bVHd1RSNG5SuUmtpJ0EPODD/jURN/Khhs6pYxikjWpkwxBOHWujluJ3ZskB8bygbth
         PFr8gRn3hbG8JoisOn9r9ZHFF9t/54QDTEx7unR3E1r1EGa3htXMarBzmcFnVOLLsRrj
         obIZzkeeFH+3fPnjii1089Y1an1l4bTFiVDVQgYM6mWuRG+nJOxAPafuqD/Zrz1I1who
         e4VEL9ir7Qh/oPwZSOrCkz7yImlNa9xTACmKshxGeRg3CsEJWb6Rz55ZgnrewjlC5YaK
         LSv1VgnhkB8qwBu4zXqhk7tF7slEE9YSxu5w2f+H2Ia5mwIcSAx5SR6AMRoJ/j3Q959H
         61lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rjj3snMpxZB2TRf050gHgvkyriwKTyczDaG6fgrNL/c=;
        b=pG3Hmo6XwBMA1zDg+8x8BrM28iDKP00vTBPe1uBErK1cr7B8Nei/AkJ+/CTOMHqeWc
         ZAyPTAXNFLWdfLew1bOIe2MHXOfbcmRiFw1wlo9k5jr01sx7n7E+bzZTWotL9Z1FfO1k
         MnCgShR20mSGJE91a+KN8uNAcQyzl5swqunboD0iCwYsF7Q0G3icY7QhlNxrAl3UFzXr
         vekYtJq97F9FDtkXFWg2dwKqWnHRCftA3fHZSDqdsCDwreiLsOze7qSLYNrTSn6x1M1b
         KBF2d9blXTMvf7niajCVQhYe63fJmKlG+V/LWe0uZ+OgMHVBPQG6oe8CQ0SISoupzBef
         aEYg==
X-Gm-Message-State: AO0yUKXS5Wy14QJ7NOJlqRdj1KDtmGML5vZgdg568K9kZF5tIU3LUprx
        Jp0/GTtunssm9XI//xq89UU=
X-Google-Smtp-Source: AK7set/pU1PTFiTw6yudCDS+Er13fStt9pnicY4aT3l0MFg815gT5EYNWEtUXWxCPRcjymPiOnT/YQ==
X-Received: by 2002:a17:90a:199:b0:234:b23:ead3 with SMTP id 25-20020a17090a019900b002340b23ead3mr14228561pjc.3.1677191145493;
        Thu, 23 Feb 2023 14:25:45 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ji10-20020a170903324a00b00198f256a192sm7862497plb.171.2023.02.23.14.25.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 14:25:44 -0800 (PST)
Message-ID: <b24ddcf2-0f9d-f96a-7a6a-8bdbc0904600@gmail.com>
Date:   Thu, 23 Feb 2023 14:25:42 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.2 00/12] 6.2.1-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230223141539.893173089@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230223141539.893173089@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/23/23 06:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.1-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

