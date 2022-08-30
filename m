Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB885A60F0
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 12:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiH3Kl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 06:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiH3Kl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 06:41:58 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7316F9D8E2;
        Tue, 30 Aug 2022 03:41:57 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id n17so13636078wrm.4;
        Tue, 30 Aug 2022 03:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Ur9LSE+726hU91hAgUo0OMhul68sy6ujWhk0uIeDHZI=;
        b=qVlno9n5cb+TbqRZhshHrFOsqlASjw2EL6BzeYdAHoUWeF/DFR3SU+3VYhw72gJipp
         ZqaoUXas/reQ8XDn0FgWkvs91x5P90UoHsmP3pQ0f/tEOlt6FyfdsNtJHgjqXpirTe9x
         Fstc6wOQa9uzn43+ExCDV92sOtKiJEGGpj4fiePVVV+tjSFqTShXPzmBDt/ZSXB+suYZ
         XEvGolSxDHQR1HZ+GrlX0CoLTaXg3tnnX1pmSImHajGEnk8P4TjuYRNVAMaindLqXu1m
         hLXJzk8flUkTQXVL1pBS0Xf92ZxCByv1dnPS5BHCDoKrvmjQIq/uZoXwFC261LtGgWra
         FG4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Ur9LSE+726hU91hAgUo0OMhul68sy6ujWhk0uIeDHZI=;
        b=usM9xNHAsuw/GHF0/Jq+GjNZGIkbaEr5x0A56b3jy2fwjIlG77A6znVhJf+SqQfX80
         JRDqWVKYDXsnRA1kpJ4QAvbhM4qNvp97RkBY6LQRX9eXXwQKnRzlCTA1SNCviXcxvlzp
         sYVifIl14YfLh5dz/9zfrrTBO+OgaGGdnyV7Cu/1cmLRevm83z070HIBc81t3+aq8DBs
         VH75XGhFPlm0AEpqv+FUYAzzxt9KBFqEPeGCrqcvF0lXR+PRAgAs2e8vaAtZ7QKpx8EP
         Mu/p09I7jx6n3G58GY3uEKDmZO5MXgJOdZcpPaRH4IHb7MaaBGhNzQeAXfWUioY06bZn
         BVKA==
X-Gm-Message-State: ACgBeo1nwtbJKEuEKby3HD2+FQ2EqXzoLTBrNJPhavet2wMa936hgyaI
        p6n3HlAS83T5ojnUh3hg7jI=
X-Google-Smtp-Source: AA6agR53FqQ8+jVD1Xwx/uc1sp8KKbMwx57GiifnN9mIZ/Hs1WNJDhbJtOmEKiHw+YlFBTbtdxh9Rw==
X-Received: by 2002:a05:6000:1a8d:b0:226:dfe2:15ed with SMTP id f13-20020a0560001a8d00b00226dfe215edmr2896756wry.110.1661856115993;
        Tue, 30 Aug 2022 03:41:55 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id m3-20020a05600c4f4300b003a84375d0d1sm8670378wmq.44.2022.08.30.03.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 03:41:55 -0700 (PDT)
Date:   Tue, 30 Aug 2022 11:41:53 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/86] 5.10.140-rc1 review
Message-ID: <Yw3pcSOJlmpBqqP9@debian>
References: <20220829105756.500128871@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
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

On Mon, Aug 29, 2022 at 12:58:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.140 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220819):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1728
[2]. https://openqa.qa.codethink.co.uk/tests/1732


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
