Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9395511578
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 13:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbiD0LKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 07:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbiD0LJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 07:09:22 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EAE403FD;
        Wed, 27 Apr 2022 04:06:04 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id l16-20020a05600c1d1000b00394011013e8so752707wms.1;
        Wed, 27 Apr 2022 04:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9RwDixBgSb/XMoXlUTpq9dYnl7i1MQjOiSQxUvjUqGg=;
        b=XyRV+m0Lv/FmF/IbshnFURENCtvD11keeqsHX5JYBzjWWFx0zevZKvWFm797AF8t3o
         NF1z9b2M8F/TK1pEncITIdhv+5gEAMkCLFLTFVj73kw4gazV0hfpJ6y8GI6hAiV4gSeS
         zbWC+Nu9HGsJ90tDg1HBn/hQPiTvm3nqaREP3SD+Xztpb395syDtvark+8pQ6IdmTfoh
         zeejTNNlQc0NrMqFG812gmBG0JShR5RuKCikbRmU9hHgUZAYUnJ5eUovgUWGcnivipE6
         3lU9a5plvd8c2d2io1B5+cwaW2Y8iLSK5mfnCmOZ8kJ4WR1w4ShFh2ekyc4hGEAw2X68
         y6NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9RwDixBgSb/XMoXlUTpq9dYnl7i1MQjOiSQxUvjUqGg=;
        b=BRyqtma2BcRgjmH42sXaipbU++flkhiJOxBD4fjBNbKcBA96tMFfonjMH05cT/yrbe
         aXq5XqSevgLreBdxaoI4fmOFBn1sWULeFfn3JC46cXeuuIBOBOH0rAFKnf4Ns/2+Ib0S
         EZlLjsT77/QcTdYWUQVFRw4qrgzYigpou+xKCBYJ9pGQsARw2yL7oW88/p6qBYt8FNP8
         92BGR0mhMPza7wiJrz5biyw5gbgL27nV9q1QbsH+2qkkdQWypV08I2XRh4U5nQo5w6BQ
         tgm0tc6Gpt6USRORVD/jJOTvJnbqhdGf9mvlp0ERowycCqe8EmeLwtjnDpwpxgO02wcY
         HP8g==
X-Gm-Message-State: AOAM530kJq7MQNkvIGbpHNrhrD9JlEOdB5rOuT1N9qF2nEmNDGbards9
        MXGNOAmvItto11mlhBtb9J0=
X-Google-Smtp-Source: ABdhPJxQjv6ox2AVdSZkiONW/c9Wd7u1Cw0+G6teeUO9dWxu/UPDD7B6qW8Y3oU/OtIJxo5dzIKSEA==
X-Received: by 2002:a05:600c:a08:b0:392:a561:9542 with SMTP id z8-20020a05600c0a0800b00392a5619542mr25017257wmp.62.1651057562803;
        Wed, 27 Apr 2022 04:06:02 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id k11-20020a5d6d4b000000b0020599079f68sm13557633wri.106.2022.04.27.04.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 04:06:02 -0700 (PDT)
Date:   Wed, 27 Apr 2022 12:06:00 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/62] 5.4.191-rc1 review
Message-ID: <YmkjmDF4KPLvkqWK@debian>
References: <20220426081737.209637816@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426081737.209637816@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Apr 26, 2022 at 10:20:40AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.191 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220408): 65 configs -> no failure
arm (gcc version 11.2.1 20220408): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220408): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220408): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1066


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

