Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3E75729E4
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 01:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234130AbiGLX0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 19:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbiGLX0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 19:26:17 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FCBBBD10;
        Tue, 12 Jul 2022 16:26:17 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id o18so8933134pgu.9;
        Tue, 12 Jul 2022 16:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eI24J4ChaVZR0gULHqMoCFMyNBNbGxZS2LCNofyhVxs=;
        b=mVB1nqzoohacCx2NJCNhc5ly+MEc+XGd8KdQyArYNG5pRR2NALHhfKQ6YqxlsA3vT2
         557vFHlumuWgzTEpx6a1rhXPrF6OFcPANsKblWQgER0cn5DXyPQrYGym+cgsgNi7p8RZ
         2e9mIxt30l5TzbOG2LhIauzYP6t4xkARttqTC9M2IRaHGl2IuN6CNey2cSvWCrJTT70O
         i4GQ5gF3szL3tUSqg9MpVq+sjhrILMPxcoRIZfY30360QcjBXdwT+gUvdqO2MYyN0jKD
         j3s3fhGJywuaG4RZccKx28OGaB325it5gUkDJ3BXrgh+uonvb5cT3k+fdXF4y01GpeB4
         trGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eI24J4ChaVZR0gULHqMoCFMyNBNbGxZS2LCNofyhVxs=;
        b=5NB0nvzZi5R68OMMkDeARlcBCcXbz/VQEps1ERCgcL5Qpok7hxJ5BrfZgcBT36GeUR
         827I0/tUp8Pan5wMfbzUm7t/XxEJgTaPD+DixvRDLnD2wdzHsx71Oo/8hWS8wS79IGgD
         TFbKUz8NH6qzdqBkMkRW04fiItiZcGA2LSRuWIU+rrWq3yl+EYuVPWnsjfsV3weralLz
         AIFgtfHTsfqZLw6ZDDXWIuN8P5uJ2R7zhpKyzK5xHYK3IVNelFvWN3MdMLhggNwNAlpT
         EAC0mVtmwsq4e14Vh+o+l37yFWIyhOww+RsYVhKkMhJLyoBLGdoQuxIdQWuR+ao3EzEh
         26GA==
X-Gm-Message-State: AJIora/d9M/2hDD4WNUBMquz09W3u6mAUJrT91FKAnAmfsJ+cHr4xjOx
        NXknvXgCh9+XJGZ9TuVjvCI=
X-Google-Smtp-Source: AGRyM1tq3Q7vIq/a3BrKfQRriuC5poQUIs4bVhc+maWzVOjf/IVVZ8OAKAIpXaCXqd7Iw00L0RqW0w==
X-Received: by 2002:a05:6a00:1992:b0:527:c201:ef52 with SMTP id d18-20020a056a00199200b00527c201ef52mr522582pfl.59.1657668376174;
        Tue, 12 Jul 2022 16:26:16 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t10-20020a65554a000000b004126f1e48f4sm6706791pgr.20.2022.07.12.16.26.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 16:26:15 -0700 (PDT)
Message-ID: <e3ed8fc7-e036-a1b9-8f73-e4be403f09d3@gmail.com>
Date:   Tue, 12 Jul 2022 16:25:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220712183238.844813653@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220712183238.844813653@linuxfoundation.org>
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

On 7/12/22 11:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.55 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.55-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
