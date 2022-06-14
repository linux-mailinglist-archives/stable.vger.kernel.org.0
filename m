Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D39D54AE36
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 12:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237318AbiFNKXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 06:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbiFNKXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 06:23:43 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653CC46CB7;
        Tue, 14 Jun 2022 03:23:42 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id u12so16206499eja.8;
        Tue, 14 Jun 2022 03:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4dcg+H1oAmJbiOEZNTr5RFYm7SEOhWvApFzLxsAKfoo=;
        b=n9n7wJO+wrDLxyq20J573T89LLJA+gRVn5L9x8XLQJKwcwd7iK3oSRDpZJNFrYwQwi
         QngxIHcK0aUj2K9DpiqpkfQsk+qMYbzM6YG+Vq0QPm4pinDIPz4q6aZrIEBnsps9Q0SB
         gF3mexA/ARWJXowNtL2IFZYQxtsMj4eRs3CZOzOpqwSuCYAGVvJpoAZoDqHqGZkgo0EI
         Qzxu9t2NLVyiSPkGLIwDosqFdlGsurphoMg4foM8ZHTDkuj8V02zvjqnYyUj11ybrUHF
         eVnY7k1kovIWIDoBK9Aep2wciy1j3wmeW4F8M6+f5cxQ/rZD92t/Vbx613BM0OstNZEm
         hLxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4dcg+H1oAmJbiOEZNTr5RFYm7SEOhWvApFzLxsAKfoo=;
        b=nWvwnd+VsmvBV47DEsOucCR00ZmTf5mOwDZtkfIx3cFnkXkd+aFxG+sYPeO1m2kkeh
         +U5F3XjfReLsfBdzmPtpVA4ELxDXnN4LERPvrifdMahrryfRpA2J43Gcohtx+1//u6C4
         YeAZ1VQKUVVrqAFGJA3ETxzpIGsXrtAQRdfoEm2hJKD66Ldj4ZV3RzyXURLv4OWRQNIU
         izZx9OiXOO4zw7qC9crTgBSr9bg3RhD3dKnoO9iHDYTYU9uigD496N6GtLdZgpZa9ziF
         KieG1TG9US/wFkN5jfYmpipG0/PlwRebnG/R0RQNaip7Lu7jqOqg3oPyIC83n7X6R3zu
         2tmg==
X-Gm-Message-State: AJIora+vQCLQihe5T92xrKCP4kY9BQYvj1sO/HpcJDArlTsVtZ2/ktsF
        D2P66AJyqCRJ1pio5XhMAGY=
X-Google-Smtp-Source: ABdhPJzxe/HTF0vBDlPf7gmhI7L7tTnJMTxeYluPo7Hdfyt67tJye/Rt3fdFc5oyvQQjTwtikFlOSQ==
X-Received: by 2002:a17:906:5d0d:b0:711:d149:7f2c with SMTP id g13-20020a1709065d0d00b00711d1497f2cmr3595335ejt.678.1655202221006;
        Tue, 14 Jun 2022 03:23:41 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id x21-20020a1709065ad500b006fe8bf56f53sm4879419ejs.43.2022.06.14.03.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 03:23:40 -0700 (PDT)
Date:   Tue, 14 Jun 2022 11:23:38 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/173] 5.10.122-rc2 review
Message-ID: <Yqhhqso3TYvrXn4f@debian>
References: <20220613181850.655683495@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613181850.655683495@linuxfoundation.org>
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

On Mon, Jun 13, 2022 at 08:19:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.122 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 18:18:23 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220612):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1317
[2]. https://openqa.qa.codethink.co.uk/tests/1323


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

