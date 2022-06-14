Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06FE54AE57
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 12:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355470AbiFNK2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 06:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355474AbiFNK15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 06:27:57 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231E63B00A;
        Tue, 14 Jun 2022 03:27:50 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id y19so16252149ejq.6;
        Tue, 14 Jun 2022 03:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jrru+W9CiP61r8FdhVjseVVEnqKypBX79NDxW5VF9lA=;
        b=Br0hoxLR5VWo+VJliWSt18OQApImS7qwCJxg5aonyCX5Xi1xnx7+8jtY4Rj32HfcIs
         e/ZiOwGTfOcb1DXBhTDUpqQ4+4F4u0LIV5hoFqEWz1WNqVUpbNCDhzrO4NnE3MKxOn+m
         x3ImM5WcsWzY/sRfSmTCY6kKvCuE7gZNYVNAePncdTlwPDG3qB7iY7/Imk+oKsOdRBqP
         BSYkTJ9Of9ALO+L3c3omIOJL0retvZfy43wsGLdOU+WsJ0nyeviPB4dF7yGT7GYFAmbD
         qEw2TEK07w3aWk7RZ+ktUmRaVvFbFW2zkx3DSALOMjTKXnOA0biPAQfEt7ybIpONP/gf
         kzIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jrru+W9CiP61r8FdhVjseVVEnqKypBX79NDxW5VF9lA=;
        b=YilOn6FCj8TO4K8XJ2xTCFCp7KclKZ0YxBnClXl0QcdbWRob8UYkv6D/POuDLtaE9s
         gKnwQ41W65sER0p0bFMh+5myI6pUYKAfdwRlZfDui5WttiNBhRhNt5KNuKfMfYC+JHla
         CxLD24vbL8OaX8kQnvhUBGw3VFn91utaqRYB21sfcashHlWFOB+3W5oPfuN3zMe4kP0V
         XG0eKdtA6FAb1WhVmD/RNjJ+O3087A0PkaSot72vr973ZvMejo+FOQIS191OQY3gbqrO
         xYqsxfQYKYEW5bclL8HXai2CkgUWY1jBt820lEekbH+FGjbY9VvK2gEinbVbDcGpl6tT
         +2yQ==
X-Gm-Message-State: AOAM531ncrU6pnGPlYktfrCdO1lSgEfPQ01VEr4z+Sk2/Lx9gEiiI1Uf
        zKYoCbHeZXxHDqHwlSOZjOM=
X-Google-Smtp-Source: ABdhPJzotjsoyauGPAVbh3VRIk3REEEQi4AXDo+imvPsIwdONIFUgP6XY6AunlqB/4RqTW9CmNdpMA==
X-Received: by 2002:a17:907:94c8:b0:711:d864:fd84 with SMTP id dn8-20020a17090794c800b00711d864fd84mr3568421ejc.18.1655202468494;
        Tue, 14 Jun 2022 03:27:48 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id c11-20020a05640227cb00b0042bb229e81esm6815867ede.15.2022.06.14.03.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 03:27:48 -0700 (PDT)
Date:   Tue, 14 Jun 2022 11:27:46 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 000/287] 4.19.247-rc1 review
Message-ID: <YqhioqKm5I/peKcv@debian>
References: <20220613094923.832156175@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
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

On Mon, Jun 13, 2022 at 12:07:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.247 release.
> There are 287 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 09:47:08 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220612):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/1315


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
