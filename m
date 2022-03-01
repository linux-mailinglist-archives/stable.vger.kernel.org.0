Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA044C8ADC
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 12:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbiCALe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 06:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbiCALe5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 06:34:57 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DA656431;
        Tue,  1 Mar 2022 03:34:17 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id j17so20078106wrc.0;
        Tue, 01 Mar 2022 03:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZBTs8yQhzLScDXe6Y9uQleIUE1hgR0UMQ4RTciTM/j0=;
        b=C11BDtdmnhmm9/VHuB+LFTMpzAougHLBXBVXKkwdxHQ6RNgP0GhzsLV+CDQXzqFUlJ
         +1ERhP6GEUWLReDCPREtS0qTFbM7eWNBCYF/VVzw+qkrbdMJS8+QLa/VZgPQSuX6V5/k
         XrqT1M/tPc/Qt50w5mB24VIrXJQQJFlc6tKIMCIw5C8jl+JjYnXreI8zAavUO8LtDjJW
         H87v9EGmkEM1QQNBjw6/8Yop0SXKvv5gNz+LF7S+eRGNs65TRQf2SgZspT4LbfSTNZqb
         A6swKuvnbs/vhDOINu7MfIdH8LkE6H1N6PvkvMsThUJjkO/iiLWJMK5+n7zZXi0E8swU
         v7BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZBTs8yQhzLScDXe6Y9uQleIUE1hgR0UMQ4RTciTM/j0=;
        b=KUBw2IxGCKEUqUT3oI2aXlXdekgpWyXNy7AHOsNm1LgockkFF1oNjboyIbXMg9QCaJ
         rFJrunaIpSN1mRhSmvxrH5Ce6JSCugou3pwUp/hTU7vRYkfT5ocvd4hix7Grs27GPX7G
         BqFhyaB9hFNBAj47GeHxkml/AoaGVsYRbBGZ+jrlM1PXAtG33uVytKTfkRTROVjUzG3E
         4ptc1C8abas0v+FeORMA8HONSFRuyfvYZQs3AMeL9WtusiM+FaLftB52TvHJsTPs4+PI
         Otf3V+TniW/q5JtUFbHOy7cwj9m6SPCwtbMnGWnkUoZk1+TwOGeHG2I42wXGRL6t73IP
         gS1g==
X-Gm-Message-State: AOAM531kRKLZSZAPlOUyh7gBsjigv1KAz7NwT3MkE+8bpHI3zKfXL7LO
        SneGhX7j7nZahbdwPslh/g0=
X-Google-Smtp-Source: ABdhPJyP9/J9Wpjm1LwIAToYAbwmnedt6uZ7kF62yvSai93v/cUylF/Zsbw4xgJ8VFnIvocJakV7pQ==
X-Received: by 2002:adf:e3d0:0:b0:1ea:9be0:3162 with SMTP id k16-20020adfe3d0000000b001ea9be03162mr19636641wrm.205.1646134455657;
        Tue, 01 Mar 2022 03:34:15 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id s16-20020adfecd0000000b001e7be443a17sm19364302wro.27.2022.03.01.03.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 03:34:15 -0800 (PST)
Date:   Tue, 1 Mar 2022 11:34:13 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/53] 5.4.182-rc1 review
Message-ID: <Yh4EtQtg2GfHI3BN@debian>
References: <20220228172248.232273337@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228172248.232273337@linuxfoundation.org>
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

On Mon, Feb 28, 2022 at 06:23:58PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.182 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220213): 65 configs -> no failure
arm (gcc version 11.2.1 20220213): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220213): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220213): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/820


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

