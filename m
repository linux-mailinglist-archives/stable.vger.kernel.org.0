Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC6394B124E
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 17:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243980AbiBJQF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 11:05:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238433AbiBJQF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 11:05:26 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C958C26;
        Thu, 10 Feb 2022 08:05:27 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id q7so10345882wrc.13;
        Thu, 10 Feb 2022 08:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pOy4s7AtfAiIbY/f4X/cj2Mnq2IZEHHcQFmlpYsQx9Q=;
        b=hnqb+NNN9oC9NBK1z2IvfIZWtDN7NUQpGubZo0a/7/L+qM7G1IRP6RCoWvpMUDYpfc
         uoMMHOpVkOUUMvqgNL9jm2fCQPmmpRaTGMk5NEu22uDGNQhtD0zlN0Fy6qQC309Sx+yu
         aJDQ49gpKxzU0+ZPidk8IPOIpNoCZ2H6JR03dayIyGS6K4+UowLq3jVKemidc5ASZs7H
         mLOZ+BLu4pbMpL14EDCqtwVOGa7wjtg8qCwk19rk6r1fRhtQjqe7RqBRE5+2wpJnFNPT
         BqmKfaH/JpVqRrvRhRvropNsA4CTRnO7S82VW9ClegT5982G7g+e7f0n8K+8ZiwDm2nW
         Thnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pOy4s7AtfAiIbY/f4X/cj2Mnq2IZEHHcQFmlpYsQx9Q=;
        b=jjRccXAYCttAJ5xVew2iBtbGwojwKZ20v2aIjdwXStCHF9bkQfxLAaUzVi5gpvwINW
         mBhRWa+n3DXsY1Bq0VrYTj+RsDS3VhclkDb3vqWdtePsyRS3Pc5Jmo7BF5QX/lu0d/Pv
         dR2RwZ1ARio6zYHOLiMsGjN1N8d9hRs4I7BmPyQBcZ0M6fH+dCqiFdOEDG7Z6NBQ/zz4
         /p9E7nHorHIfl6Pb6eLyfqh6UXmPC82GiPbcNuwjdsXs7TaOUvReld3cQDDqqPIq9pYu
         M8ze1YFMzV4Tw+t/MrYWRvudWcuO49NsmKwiNo+qNh0H/X/GaMH5y5xUmCPlzk4PtlQB
         oH3w==
X-Gm-Message-State: AOAM5302LthNNKlK/8pPxTdKHq1w5e3nAjxGkqBXHDp+xKyHgCDWFaCS
        CoBnF0zpEtipVqPkkiFpbs4=
X-Google-Smtp-Source: ABdhPJzdJC/tgv0rTZN0QM1pg/FQTSHuCjoVma9nD1D1VrlRUiS2NfuZVOwpuR7/qf3PLXSFNKETfA==
X-Received: by 2002:a05:6000:18ae:: with SMTP id b14mr6913931wri.100.1644509126162;
        Thu, 10 Feb 2022 08:05:26 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id d6sm18641925wrs.85.2022.02.10.08.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 08:05:25 -0800 (PST)
Date:   Thu, 10 Feb 2022 16:05:23 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 0/2] 4.19.229-rc1 review
Message-ID: <YgU3w39lY127cUqU@debian>
References: <20220209191248.596319706@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209191248.596319706@linuxfoundation.org>
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

On Wed, Feb 09, 2022 at 08:14:02PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.229 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 63 configs -> no failure
arm (gcc version 11.2.1 20220121): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/736


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

