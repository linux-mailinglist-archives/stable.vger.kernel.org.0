Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18FD05BCC10
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 14:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiISMn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 08:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiISMnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 08:43:25 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA761CFE4;
        Mon, 19 Sep 2022 05:43:22 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id e5so27969096pfl.2;
        Mon, 19 Sep 2022 05:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date;
        bh=IP0j0ndJY9k5kpn9lmfsG60MOm9vV96ZEqJCaXlu9nM=;
        b=CzqlqGC8Z3R/NiXrpCYhvWXmTIA5FFvnJka+A00kz0yL8ha06YAU7ugHBW0t+gQC3r
         oCRrKAjV9ucYNLvEDsgwhBsPgpEUJw8vZrCqCT6qnriB5gj0mFCBDu+VxD0y13/P/0f6
         Ui4Q7/Qug3189aH9vkZfgg/krUG8P7pJw4CgG2GzABnlTImaEBp7w+jnCZT8qTvc3Nd0
         obfPYDPgxBWbHRn/X/0q/Q+grrv7cDdyyloO3tenHTVNm+ePMnBVwLl3fBC2mLLfyw/s
         AvRsq3MWv3um2zGVoHiml995+uXK0zJf5KapHV0SXVCxQ4txSTdvnHh8RZOtHg6ZjWt2
         SlNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date;
        bh=IP0j0ndJY9k5kpn9lmfsG60MOm9vV96ZEqJCaXlu9nM=;
        b=o1SSODJiVKFs3wpTBUrn/xuOKaIx/n+A/df18hl5D21PBfDnqdJXP9sQvTcf8gqqT9
         ffxQXXMVGaxmc3z3i2kNhX7+w2y+TZaO2egNThKF+Ev/JZqzj4M8lpknbveVu1XkpJ7G
         6GuCLGJ36CJtA7RwdnWQkRePWb3tZhxAjR8UpsrMYyrxA8HRZMNLXaDjq0OTsPvGv7OT
         o4KtJRwjyDK9vJ+ArqcoEDriPS18atZoo5A/OjCxJBoF0WRmP0pIAETE5dotWSYXnHX1
         fw4yB64rUJmIVhjcxvzswbeaJCyhsRIPeTJyIkpHMHKhdjUggWVXeCJ4WOgTPVxfp/ZV
         wpNg==
X-Gm-Message-State: ACrzQf0IY0GCxx+R96e3x173/xjnFv1AONeQAaUzKU47B/CD0E37Fq9+
        wXHrajk/JHSXaGDSAQdn5RI=
X-Google-Smtp-Source: AMsMyM4PRxDeR1tQLw3owuXDFLwRGk+K71z9N2vCzxTXSvXbzi5cW+FWiRZ/JbSnXuD4FYF9smTDXw==
X-Received: by 2002:a63:5702:0:b0:42a:b77b:85b3 with SMTP id l2-20020a635702000000b0042ab77b85b3mr15103036pgb.263.1663591401731;
        Mon, 19 Sep 2022 05:43:21 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c19-20020a170902b69300b001785fa792f4sm11355636pls.243.2022.09.19.05.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 05:43:20 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <c8e268b3-2d7e-79d7-fee2-03cbd698636a@roeck-us.net>
Date:   Mon, 19 Sep 2022 05:43:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220916100445.354452396@linuxfoundation.org>
 <20220916135942.GA29693@duo.ucw.cz> <20220919103325.GA10942@duo.ucw.cz>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: 5.10.144 got more patches? was Re: [PATCH 5.10 00/24]
 5.10.144-rc1 review
In-Reply-To: <20220919103325.GA10942@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/19/22 03:33, Pavel Machek wrote:
> Hi!
> 
>>> This is the start of the stable review cycle for the 5.10.144 release.
>>> There are 24 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>
>> CIP testing did not find any problems here:
>>
>> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
>>
>> Tested-by: Pavel Machek (CIP) <pavel@denx.de>
> 
> And now I'm confused.
> 
> 5.10.144-rc1 was announced / tested, but now there's buch more patches
> in the queue, starting with
> 
>   |9843b839a 174974 .: 5.10| drm/msm/rd: Fix FIFO-full deadlock
>   |518b67da4 174974 .: 4.19| drm/msm/rd: Fix FIFO-full deadlock
>   |88eba3686 174974 .: 4.9| drm/msm/rd: Fix FIFO-full deadlock
> 

I don't see added commits, but one commit was dropped after the author
complained that it should not be applied to stable releases.

Guenter
