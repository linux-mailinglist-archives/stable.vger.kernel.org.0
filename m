Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42F24B738A
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236586AbiBOPyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:54:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiBOPyD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:54:03 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C539E540;
        Tue, 15 Feb 2022 07:53:53 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id k127-20020a1ca185000000b0037bc4be8713so1777605wme.3;
        Tue, 15 Feb 2022 07:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wckGk5QuDOgE0Y4wSmC4c4PZOhukZc65ICGax+EiplY=;
        b=WeNzkXu4NZztvwM1Br+senu2o2P2CWK2XWlF7tps6rzwYbfOwalScEZhLzpyBe0KP2
         gjvWljNt+6a61e5wcAgIw8EtWGQvXJVALfhYI5CrEq3yIT+NMGJrzkKN6V+q4bXu/owG
         TLwO4axLINc6G7nRRN1pQ9GSMdBR4cKlP23UBcGv3u6iJUBWU2NeiWABpUdUbxK60bRL
         LOA+m6z+8JX1clFqrBM6hikxF4NIs3PKhOUWAr9ZWb9oS3P2ynwIVrK6JSdClNRfL+Mx
         dKHmH4ezIfy6++19w8AqEanJxEe6PzwThGJ9VoKHnvVWFpB3TRu2hsyroxXob7aX64jn
         C+GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wckGk5QuDOgE0Y4wSmC4c4PZOhukZc65ICGax+EiplY=;
        b=CIqBRiy6K7Alv0vBtInARc0So9ibES81JEcPm+OTZ08z3zs6bRRO3hSzXguKfrArXs
         2Wcbi/g7RvpPzfoUake/i+vJPvb8BX8wv2yTWN18NSLQvb/hymwuRal9WbsFeK0BcI74
         cCPes5qwL1hfNr8rnjL8HLFOvLJ9kLO6UqhaGBWbNSVYY79nUCcCgAYeNwt9KsV4XwUq
         Zw7wzl8B8KvjzFa8WJm3OaXgaSyGZO+lwCTZSrH6Bt0Yx14oOFmzrLEnhJUWnIwDv5Tl
         IgY09jieVT+euSZw3tb4OBsmV3HcgjJ+idQPhLmSfdqA91fwsxbo4WqQXD3svFW1FrcA
         tgRg==
X-Gm-Message-State: AOAM5319uxJOZxcINLUE90kvHTbGF43GqriGYFDVkp3v1jHo0zYgcuim
        Y94Sv5ijTchE1ly0414kMbM=
X-Google-Smtp-Source: ABdhPJxVwOUiHtbRJfd3vtUCCF74MO2va0zW7aOpRhIws7na2IEP/9qqa5G3qqPte6WnjWSyprDxLg==
X-Received: by 2002:a05:600c:10cc:: with SMTP id l12mr3563085wmd.34.1644940432272;
        Tue, 15 Feb 2022 07:53:52 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id l12sm15083880wmd.44.2022.02.15.07.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 07:53:51 -0800 (PST)
Date:   Tue, 15 Feb 2022 15:53:50 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/116] 5.10.101-rc1 review
Message-ID: <YgvMjsq2226JzzQW@debian>
References: <20220214092458.668376521@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Feb 14, 2022 at 10:24:59AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.101 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220213): 63 configs -> no new failure
arm (gcc version 11.2.1 20220213): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220213): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220213): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/763
[2]. https://openqa.qa.codethink.co.uk/tests/765


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

