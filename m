Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B6854AE43
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 12:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354713AbiFNKZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 06:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236694AbiFNKZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 06:25:50 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC5E47AC2;
        Tue, 14 Jun 2022 03:25:49 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id u12so16216428eja.8;
        Tue, 14 Jun 2022 03:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rZvwfIylD70bucePkFCRGBDvl+eZWioeOXtzXjlTB90=;
        b=b6kjw2kDvSiTcMhC11SE70LwvKykOdDMuhlbq8hHxrE7qjR3/PX1BCM4ctb06wWKO8
         AKpWoRCXMQs3zoM1peOvCEltokTWB69GvfEwyA+p81B0yhZGJFwBQn1CiOqvzuR9VyAX
         6bl03aF6UUhHSQOqwJnI+tYSIYyQO91XzCK/KXCr1flJa8g2z3OrI14UXINLl4TMyKfC
         lzxxWDN73fsUg0qJij7AlLIpvukC8BxVi4mcGxZxoDEYwdhzbYKnE5/Y+BRLe8uI8dkN
         2h7TX6K9ZlvSXI600NbxBdyvUUaE+QyskPvRiB2/Vr9vcIcGF7pLhytujWM23oZds1Is
         auvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rZvwfIylD70bucePkFCRGBDvl+eZWioeOXtzXjlTB90=;
        b=MhqQ++5QMxFtYR40uQJuyka0MCS3iEV9c5gjyHc+NC0ZneYRwEoNS+4LXLowBaJ4V8
         H04M9beAejL7dmGIUgxNB56OYgCDzVdhPsJnNESkMmJwUArzNdLpyMbY5jVQC27ttlXZ
         M8zD2yc/Ksk9nVIw1wCca/aPJVuR+tJMVcQuHs3SqEW9X1DsceDxtjIEiIkopwaGdkG3
         BEbRgOfbUYGDzeQGTs22Xl1PFhONuShzi6Uz1qNN3DJU8ULVLRvb0C5YJgbNTC770Z6V
         TRAnHGj85sxVR124CESqj69meMVYOA24GWq45EjRg9jwp2SQTVELv6mITEzKXk86qdzh
         dZPA==
X-Gm-Message-State: AOAM53311+9muCIysrHoyQotp6GqTEt/hFDBfqvPBzbvk88TL9FQorof
        k1aEbv0LakKzsDFvo3DmEoYceXw/ULc=
X-Google-Smtp-Source: AGRyM1tWLQMjD6MKytQoKP7Q9q1l3bSQGGvz9MkMAmjJ1NoCuLIcBQQazwgWyN+ZvFCYCdQ6v7OS+w==
X-Received: by 2002:a17:907:6d24:b0:70c:81d9:d5b9 with SMTP id sa36-20020a1709076d2400b0070c81d9d5b9mr3460698ejc.597.1655202347711;
        Tue, 14 Jun 2022 03:25:47 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id z14-20020a05640240ce00b0042dc8dd59c7sm6967999edb.51.2022.06.14.03.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 03:25:47 -0700 (PDT)
Date:   Tue, 14 Jun 2022 11:25:45 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 000/411] 5.4.198-rc1 review
Message-ID: <YqhiKTSONZPHwXES@debian>
References: <20220613094928.482772422@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
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

On Mon, Jun 13, 2022 at 12:04:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.198 release.
> There are 411 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 09:47:08 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220612):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

powerpc allmodconfig and riscv allmodconfig failed to build.
backported patches sent separately.


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1316


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

