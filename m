Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8CC515C36
	for <lists+stable@lfdr.de>; Sat, 30 Apr 2022 12:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350172AbiD3KUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Apr 2022 06:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349436AbiD3KUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Apr 2022 06:20:53 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE457C270;
        Sat, 30 Apr 2022 03:17:28 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id k2so13703735wrd.5;
        Sat, 30 Apr 2022 03:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SIiQAiRmxK7PkfFSJ9MXwxRWHpfB0DZ/ViXcixe9w6c=;
        b=DinWXtT5/tn6ov/cr2/de/aKGtaZ1WYe5+oxJ99pobmjLUAoxYING3Kmhfgx6jamaZ
         ToWuJQw7KSasqQe0GM8NJwI6ODrSZOt6vjnBHUr0MnZyCQ+Vb7nHGjZaULpxn5wbSIwp
         RHffU5oJ625h+TKZyf3TQYo94xIZ7LeMA7DQVXhGtbv8OkAmCGi2ys9vxaEcWiIuC0Iy
         B4pipEnBoz6eZENZjWO7xtAvwk8EkR2c5QmuTpyHWtRIEPV872RmeC0Jmzx+eSCRfB6G
         6rtZz/KTq4bc2T0r1sNl7ImiqK1AIvZGjtDFKZGCSRzUR2TnpFm171ZkOFB1QriDvvBf
         FRrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SIiQAiRmxK7PkfFSJ9MXwxRWHpfB0DZ/ViXcixe9w6c=;
        b=nV8OLMIpGSZ4OQ2wNhb187D64xbmoqwRdBgMN+rWdAZ/KGrKC/Lfw/ss+td9Uieefv
         tejSyp2ZnSfpZK6G0TIXurRJLXnfvUN3YPdVnI3iF+h4HrW4iyqPqB4tO8VsFAkS1UnP
         c9qARDawdKq3MwqhPTzQxLKL5YsBLn3MeL8865QWgAFPLBbn9FCjD6HiFfd74HaV5O7p
         MA1dA2UGTJKjU/n08XGoSJmSXPwQ9e8UvNfkMkm9p6HKyn6RhHrhZu7rTj7DjMlXFb9/
         c7g2WULNvqmkjrgu74lLxG0ZTmtzdjFajvtlB4KygwPP12I76nGMYkk9DMg/5mpZ1JLH
         6qHg==
X-Gm-Message-State: AOAM533/Gd2+zhjWgoO3aRgxL+BVjYgLEYDLDwP6Ka/zmwDoBxD595go
        TLpvmg/dg6PF7fBD7c+AfRY=
X-Google-Smtp-Source: ABdhPJzFi1aDC7gpXO6QCfb9UNgkYDDuEOhImbowvod3ms9ktVCKknM28wLX+JQt2VEa+nFjhSOrag==
X-Received: by 2002:a05:6000:100c:b0:20a:c8db:69d2 with SMTP id a12-20020a056000100c00b0020ac8db69d2mr2546436wrx.19.1651313846821;
        Sat, 30 Apr 2022 03:17:26 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id c2-20020adfc042000000b0020c5253d8e5sm1690457wrf.49.2022.04.30.03.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Apr 2022 03:17:26 -0700 (PDT)
Date:   Sat, 30 Apr 2022 11:17:24 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/33] 5.15.37-rc1 review
Message-ID: <Ym0MtLt9fy36+W7r@debian>
References: <20220429104052.345760505@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220429104052.345760505@linuxfoundation.org>
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

On Fri, Apr 29, 2022 at 12:41:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.37 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 May 2022 10:40:41 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220408): 62 configs -> no failure
arm (gcc version 11.2.1 20220408): 100 configs -> no new failure
arm64 (gcc version 11.2.1 20220408): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220408): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1087
[2]. https://openqa.qa.codethink.co.uk/tests/1088
[3]. https://openqa.qa.codethink.co.uk/tests/1089

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
