Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CCE640458
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 11:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbiLBKSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 05:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbiLBKSJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 05:18:09 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7632A261;
        Fri,  2 Dec 2022 02:18:08 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id n7so3193006wms.3;
        Fri, 02 Dec 2022 02:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TWifImDgU7rHybo8rHu3koXB7xojTPgIH7LvV9QbOUE=;
        b=a9SSakxT3CPnWDAc/fAmnACSKYR07SGM0Xx+z4D4+CznUE2v01eUhlTuKTvgEfV5HH
         ddXwNgHUB/APv0c+HTnhQYZcB+O3GBq1WiUyfBnzj/+5hXSa9LK5iI3FAyyVz8zGbMB/
         z1TmPzyeCY9muLjATJkTVZ/GWQGVsS6gW8GS44uBo71nclfXW4TzJqjb30+4qNx7taBP
         Up0AWlIT7ENFmpJMjA3NstTymOaGulfNY4gywP2jFz5YDx/CaIgwMI5FWEN7ZUHPj9PB
         DVAOSed14WLZ6DruDcA7ZIfv5TCGJTYwdWOwHEsUGNzPTRLzhf481wtmz47X1C0NP5MO
         2lQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TWifImDgU7rHybo8rHu3koXB7xojTPgIH7LvV9QbOUE=;
        b=c+AygOuOwucu5p3ZQkbky8050JrHk1tbGRqBJTe4U+4lUkXwS9i4SIvItViUsvSdf8
         D3Z3WgGpj7QsvzRVcZ6drUrZRvCd0giYvjp2uTdGSN1YVbMPTeuNhav4VluYy8ybMFPf
         fUX8Dh07Qw7a/Mh2fKa8gojki99QoxuBSy9MHiH7/7q6i0ML4sUrIR8Muwl+bGjjZfhv
         XOYtK/Bt5D57nlqVrPvWffl614tuG72Z5T6DaqPrIAZdaGH+k1BIw0kAiQibuV1S3B/x
         hn9NIRQNNGtAbcUBUjl7MZFZ5ilcqv5iXBvszEbJMKHJTRot0Tm9v/3Dfb/NHBEQ/ORE
         2BEQ==
X-Gm-Message-State: ANoB5plE0m9jUaZB/JtU+ZnEXkE7nkJMkNT5bg14hTxZNWOWhkOJAPHm
        KkMJVu8IDqEowAngqSHwNBs=
X-Google-Smtp-Source: AA0mqf7VLLsEPMXxHahA+d8woSWlMcxL1IgEpAx0Dwakte6+dL8FX3JxCY9ChD8h0xMV7ramnFgajA==
X-Received: by 2002:a05:600c:3d16:b0:3c6:de4a:d768 with SMTP id bh22-20020a05600c3d1600b003c6de4ad768mr38070878wmb.61.1669976287300;
        Fri, 02 Dec 2022 02:18:07 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id n3-20020a05600c3b8300b003cfbbd54178sm13831873wms.2.2022.12.02.02.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 02:18:07 -0800 (PST)
Date:   Fri, 2 Dec 2022 10:18:05 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/280] 6.0.11-rc2 review
Message-ID: <Y4nQ3ZqWHD2U8iP6@debian>
References: <20221201131113.897261583@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201131113.897261583@linuxfoundation.org>
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

On Thu, Dec 01, 2022 at 02:11:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.11 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Dec 2022 13:10:41 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
mips: Booted on ci20 board. No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2263
[2]. https://openqa.qa.codethink.co.uk/tests/2264

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
