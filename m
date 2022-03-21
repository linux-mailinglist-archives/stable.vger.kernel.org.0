Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D2D4E2F07
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 18:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351849AbiCUR2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 13:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347382AbiCUR2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 13:28:45 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACD8184B67;
        Mon, 21 Mar 2022 10:27:19 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id mj15-20020a17090b368f00b001c637aa358eso16969817pjb.0;
        Mon, 21 Mar 2022 10:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=Lu4ciz8L4V39hpIzjAidyBeE83VuDrlnh+7vkkMs+Yo=;
        b=Y27Pf18eS/UcO0f2cpaNCIi7t8/+h36UrY8w+NGuIq0UIC9NagnNBBhX8ZXj6iwFY1
         Z85yy+E4KAu44raainughwtzoKsfl2k6/7U/xdrcvIPuA/Y4VzGTMGQArK9asuTgekGM
         Kz/5FkvfJ8l+JQAzj7beKNkoAJe26e6rIbdODipopQYtens2wCECMyfK4mPHWzN7B2CX
         HsRuYHoj1df5dY2E/NrgoTvwDnOmrApXTdDZIU2S2V6LfgWEKAHu+koLxen+O1eASr8u
         AJlfBRZA8AOM8agLsrBAIeadgrr3WP5EfsXqCPfV6st7Q5OjdZOsH0p2y4iUYdjgqr0m
         xXgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=Lu4ciz8L4V39hpIzjAidyBeE83VuDrlnh+7vkkMs+Yo=;
        b=P6n5+u0KO31fFnHNMEbBRjJoBD97p6kp+z6DY0heFxzoOKA7FG5JXAyxjDV1nNeNle
         l1V4T89DVhtoj1f2TTp/nENZuH+Pwe+BPz143XITtpKRd0jp2Qz210vnwmGeKWPCWQTA
         q7GWJMjXxVqGwps0xFdnTnQpVTbgcAjzFUqUnxT9Jnh0ekXLvcdcj7TR2B0Hox1Q8Zjo
         DvDXftFy3X6R/n5GECdwsHJ1CZaQweaRZND9eiNwGO2cFCXg4YiuH7LhwtbQ+gWOuK4g
         BGDnwh68JJNpsYF+YonHnE3ny7yAE4Mg5u4oeEYm1qOhfIIwo82KZGUMsjop6rYfLcln
         PUfA==
X-Gm-Message-State: AOAM5302GO7rYljvYKT1h/VasX4mTfYKsprK+PcyOfmXvZ5lxMvZpX+d
        2KsiY9uljpE2aGPlBahiL28=
X-Google-Smtp-Source: ABdhPJyw7C0YN+YSFSwMBG5CwUugxSG2+T8aL84h7uoGczRFi+kDUQooYZkQxSHlpE/6s44w7/6DwQ==
X-Received: by 2002:a17:90a:1b6e:b0:1c6:168e:11e7 with SMTP id q101-20020a17090a1b6e00b001c6168e11e7mr197376pjq.136.1647883638931;
        Mon, 21 Mar 2022 10:27:18 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 16-20020a17090a199000b001bf4b1b268bsm73422pji.44.2022.03.21.10.27.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 10:27:18 -0700 (PDT)
Message-ID: <59ddb0f0-a48a-ff7b-eea3-560c1e9120a1@gmail.com>
Date:   Mon, 21 Mar 2022 10:27:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 4.9 00/16] 4.9.308-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220321133216.648316863@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220321133216.648316863@linuxfoundation.org>
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



On 3/21/2022 6:51 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.308 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.308-rc1.gz
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

