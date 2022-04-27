Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7AF95115FD
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 13:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbiD0LMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 07:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbiD0LM0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 07:12:26 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C79B37A09;
        Wed, 27 Apr 2022 04:09:11 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id s21so1969317wrb.8;
        Wed, 27 Apr 2022 04:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rSP+R2ynVaGfkNfXQLhocMMWf1Fd92Ficyi7N+VxK5Q=;
        b=kZkgsDAU+xNADXHTbRSjo7dIZiWh0AvnFh+jTM0poQ9eLm+pfBFFNWY8ek0iMe1Ocr
         OD5/0aVOCOcYwqu2UfFHKdAV4nBdJ92sR48iVUE6rwSgPjU/lfKDfM0YvZ3R9gPmZ27L
         1HvXK82w0vWX7kLc2lfjKONxJkZcpx77Ccd5WeK9LqegDJb42ZJHsXv6rGoi/jzE5uyG
         xZxNGy0hSx5u9XPrjuwnSn02OWs2GZ+bDx76aJ+k/oUB57/gEtpHUJ0qPpMI3WIsRejF
         s05S/MlSCEanagesHOsTjv7GRHWRA9+zcXi+UfX0Y2LJAuf1fTMyHlpDOgnotcKzbV8d
         4TVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rSP+R2ynVaGfkNfXQLhocMMWf1Fd92Ficyi7N+VxK5Q=;
        b=Aebzf/aWTxkO/5r5Utve/4JIbS1/9QJeWa7vNTTSdQOypoMyVAMPia3YY97Gt2y2J9
         EE5bHfOpIrLoJwGrKVKbRVkau6xUqZcmY+zhNnsc/TPDT/K4/rKIwxHThftWWWwB2Mln
         m1JVlklZYg3UTf2dNhCfqEJea43D5QO9AiS7ZF7XcfQtRMtiKM6Q27XFM3aYhd6OokQ0
         3mqoaRyWfAJUNFbBXFvIrD5bvc79Z3+jc+GsZFAaxBv9tPLynUN7Q4DWCHEos7tf/4PU
         vzapUgUEPcf5D6mG5uE40rn/jybko8SRveYM0pmsShWDXjgA9n+4A1QaD6YlXDwSdxMc
         3EDg==
X-Gm-Message-State: AOAM531e78Ot3oWZUEhFhqrIMb8d/9KpRhr9wM6B2RVVAUhreWDaHJ7Q
        ISbFY6EscXdy/pNgcS9CBCw=
X-Google-Smtp-Source: ABdhPJy5HvZ/KlDUcaOI4M2q52j3rfJKzHPzcwhX4iKK13xyKyI6MDLy0xrZjr/DciIQHmdF7MSYHg==
X-Received: by 2002:a5d:64ed:0:b0:20a:a5ea:e0cd with SMTP id g13-20020a5d64ed000000b0020aa5eae0cdmr21357069wri.520.1651057749770;
        Wed, 27 Apr 2022 04:09:09 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id l21-20020a05600c4f1500b00393eb0d01f7sm1448862wmq.23.2022.04.27.04.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 04:09:09 -0700 (PDT)
Date:   Wed, 27 Apr 2022 12:09:07 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/86] 5.10.113-rc1 review
Message-ID: <YmkkU7rZ3kOXH6f7@debian>
References: <20220426081741.202366502@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
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

On Tue, Apr 26, 2022 at 10:20:28AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.113 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220408): 63 configs -> no failure
arm (gcc version 11.2.1 20220408): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220408): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220408): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1070
[2]. https://openqa.qa.codethink.co.uk/tests/1072


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

