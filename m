Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2564ADA9E
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 14:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357622AbiBHN7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 08:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358099AbiBHN7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 08:59:33 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35415C03FECE;
        Tue,  8 Feb 2022 05:59:32 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id c192so12241242wma.4;
        Tue, 08 Feb 2022 05:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r0hF5ZRTXwpGB8Z1rBOeeLEYfkPvVonZLdA9UEgNhqw=;
        b=Bbw7NflQ70eSn3rN/iwnYlv4e9SlAWz2F2aTCUkdUQ9R4xLmM8bAqPzKWLtPeSeNro
         ed2YrKex4bkyihHBsXcUZUrjh0iwbHue6ae0L2FuiIkmcABet21PLQZpV7WuZxDQcy/o
         JtFeGJMMkvP6FH9hj3SbvHuYQxGuScvy9Tex0YIO+yPhinoOrscHeXgrZbzEei8I36r2
         DNSrQjSPf8SN0Ua8jjrfxc7QNXzCWaT3vXcFtzpVVqzEvgySFNKW/EtMaRx3oBGCNcTM
         0CVV/RQ3iREmDcxs0KRP1Xw2dyNrQ81IYpdiLz4iNeBehQYHmmEvubkbunvgOV5Vf4TZ
         Lrrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r0hF5ZRTXwpGB8Z1rBOeeLEYfkPvVonZLdA9UEgNhqw=;
        b=eJND3yRoZMVvlgn+aQ9HgDMaLVTbl9Zdbfe6H0vtcI33x67i4tCmAp/IiAS/5w/MVX
         65CVflxIU9agp+yDN7ZvoX9WRJsNoEnQTPl+9s9gQ6KIU3Zfh1CNy2Jn1kQm/IStM06U
         HdTwniB6ib1Ymy00KJyiyIC9OIN+NaXMgFeiNNvOBGKnUxNzYfOQ5lp+dcD1jMdEyTYx
         WUKxMV9YhBQr0NGLQablTstR7XmVKxOEx7aqJLmTUQP9B+IUpb4wQvLIonjDf7rHO0vo
         jdOpNHBxneZ4bYrEn9fjdzt8rLtUUbGoLELFl46ysH3JOC593guEn03TPW0TVm2/94hS
         k7yg==
X-Gm-Message-State: AOAM53396DuIz2LD6QqeTyKd9nv98c/XmFz6KL1fQFLQGHt00DPenQ47
        9FX8kxyf28swkD1vjf4GqXg=
X-Google-Smtp-Source: ABdhPJwJwtce+XPvjrqhfnhiTU3vMRDenSOoJG/GpYYWqoF1cJa4dzHMh0DbY5X5r2yRl6ozoGncgw==
X-Received: by 2002:a05:600c:3b9b:: with SMTP id n27mr1143539wms.14.1644328770736;
        Tue, 08 Feb 2022 05:59:30 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id x5sm3205272wrv.63.2022.02.08.05.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 05:59:30 -0800 (PST)
Date:   Tue, 8 Feb 2022 13:59:28 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/44] 5.4.178-rc1 review
Message-ID: <YgJ3QCc/ZPPd9HHx@debian>
References: <20220207103753.155627314@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207103753.155627314@linuxfoundation.org>
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

On Mon, Feb 07, 2022 at 12:06:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.178 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 65 configs -> no new failure
arm (gcc version 11.2.1 20220121): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/723


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

