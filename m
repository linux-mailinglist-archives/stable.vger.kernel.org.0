Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E390556318E
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 12:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236570AbiGAKit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 06:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236585AbiGAKik (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 06:38:40 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE72510FE;
        Fri,  1 Jul 2022 03:38:34 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id d17so2566967wrc.10;
        Fri, 01 Jul 2022 03:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mgt/Z2s/iXV2JOEmbfj5qncD2GVhoZ1LXkNgUe37ArQ=;
        b=Lvuh3KWqnrKuz3tjEnNResZ3siQ7nP5M0v0SFvi+8mPNeEu9wFjHfSb4Qnj0ntYN2m
         YW6yFQc/IXk6LDQK+YW8Xo+F6UCoDpNunCB+oz0OKzwCloYULdBcOZlIXcW81loD95Ml
         1LNdo587zrHpb09dSeushL/A78+2EBOTyiXLmC8/c/cgDLK1ntF1C+vZfDDJyEZpdl6B
         x2m9e3zJxjfE6jVeQANJVxVk9OnT286lRIcoWbk0CXaqWvkylJGOVgVRyTnLm15KJMdh
         hJ9e9mN04s5/pdNAat+Pbu0I9Cwfa+aXvBTZbDNo6K9CjPbWprLFYsQxQcmeCSne66QP
         QcyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mgt/Z2s/iXV2JOEmbfj5qncD2GVhoZ1LXkNgUe37ArQ=;
        b=YKMVrY3TsRcWkT0P1olVlORLOYxsrx5FxhSyLDpMFK9vlvjJN4z42S6mhM6kiL3oLo
         kdrOCxMkZBr3Z/PVWlENo/IGfKAJNST7iacJShNt6Bl9hfFNnHnpq/T5RDuZDyB9ahcG
         2BKx2/m4166fCKlsmiAzWoXGxQAEOOv/aUziK6GSqp5Pd/luD0+DhQAKojt1W7nXoAbT
         KwOKd6nyw3N+INtSIHD+CCH/BFtDoeHoO3LoaysjVLO8+k6mhTYQ2iRO3MaxeJj7dVGq
         akbLFpKibiD1vhkXvlhlwEgUxZA2k4nim0mQqLz7HrI0jCLF1b1bh+cV9KNE1QmSF/9S
         0Low==
X-Gm-Message-State: AJIora+YpSjPgTrAS5DzpnnMdDOcnqh7sI7lOz2CXz6O7NhFowEeDgWV
        u3f4GL1kXVetNN4mL1McWgg=
X-Google-Smtp-Source: AGRyM1tVN5pAoe7/cFBqlOUIe8qIQWckGaWJ7gpvfcpHr15uDNm6k/waW3Vqh7xiF6N0vpXRspj2jQ==
X-Received: by 2002:a05:6000:1a89:b0:21b:83a9:aa6f with SMTP id f9-20020a0560001a8900b0021b83a9aa6fmr13377146wry.33.1656671912874;
        Fri, 01 Jul 2022 03:38:32 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id f7-20020a05600c4e8700b003a17ab4e7c8sm7335322wmq.39.2022.07.01.03.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 03:38:32 -0700 (PDT)
Date:   Fri, 1 Jul 2022 11:38:30 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/49] 4.19.250-rc1 review
Message-ID: <Yr7OpkhYKMKTlapx@debian>
References: <20220630133233.910803744@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630133233.910803744@linuxfoundation.org>
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

On Thu, Jun 30, 2022 at 03:46:13PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.250 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220627):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1428


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
