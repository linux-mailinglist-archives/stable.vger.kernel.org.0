Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D5A57B8C2
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 16:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235043AbiGTOsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 10:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235022AbiGTOsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 10:48:18 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FED51410;
        Wed, 20 Jul 2022 07:48:17 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id n12so13613423wrc.8;
        Wed, 20 Jul 2022 07:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2HCmRDULNNOk3LrcIoxYSs/mdDkOe4DtzslLYnc6NdE=;
        b=Smvlm7x16XYbh8AtqkmjI0A83dAYB9mzKiHzU/yaeSeYZXS6G6yIkWbM2PqXpR7geg
         mZkgBRH5Cw+1u2NaH8LCT7OhMNFgobwxm2mLzUf6z+uPvQLvpbT7gAF91ShZKEAAV1wn
         60VAvGQFvoeG92jR/aEz4etJ5FQ/ICARTKmkhTbi/0eWYmbvvrx8VQgFajA1bC4pJj6o
         TdMR81z6wAA8aYlKdZg8lbeFz25WXjDDB7VJanrtFIfJIhcjgytyKWVszTyj8Q8rGqV4
         fbZ3umnFDWLl2+0Eol/6EewhLTjMs6xzuousHd+JsPkvWNyXIBR2aXkFfGI3pUw334Ku
         kNNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2HCmRDULNNOk3LrcIoxYSs/mdDkOe4DtzslLYnc6NdE=;
        b=00MGGIgAnOyyG5oOiA/6lcua5zJ9IO24TWD7tZoejETB8DYgpfdv2Kf/+C12Y8mnk5
         +CQ/ZAzTe6V86AlFo4JoToMpWWDM27CvLSOXyCYryanwNeGccwtAhdcGIdk5hzXmMDZX
         ej9nFBiJ6bX9W10EPFZZtomJKtzE5KzQBnpm86Ak0UAr++2wMW11mZuOtsDhV2c6QBGi
         yZ/h31OscOwyZulqmd8QPT032Bug9Pk+xcBpaUuegpRHNSbN+UsgRuOumSOoTdavGG6Y
         AJK1wWIPa2Vre5fVCDtsnAqUrY4aVk2Jn7V9iQ7MidBX4DpBCod5ZkmgoGf2Eg58vIW4
         YcSQ==
X-Gm-Message-State: AJIora8w0NKOmIG6AjncgKWO/OZkCV3ljKApi7plFqB9AdAQ0F8hP+UM
        He0uX2IZx7PSLJ61YiwwcwA=
X-Google-Smtp-Source: AGRyM1sU4coKz5eJp1od9QIXLB1n1uGRdbenHdC6dzF+5/lYxTYrK4tYOVXN4nROdynVAf6uLHKZpg==
X-Received: by 2002:a5d:45c5:0:b0:21d:978e:f93 with SMTP id b5-20020a5d45c5000000b0021d978e0f93mr31445782wrs.134.1658328496270;
        Wed, 20 Jul 2022 07:48:16 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id n21-20020a05600c4f9500b003a2f2bb72d5sm3964492wmq.45.2022.07.20.07.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 07:48:15 -0700 (PDT)
Date:   Wed, 20 Jul 2022 15:48:14 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/167] 5.15.56-rc1 review
Message-ID: <YtgVrtcpJoLIfIub@debian>
References: <20220719114656.750574879@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
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

On Tue, Jul 19, 2022 at 01:52:12PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.56 release.
> There are 167 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220706):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
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
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1528
[2]. https://openqa.qa.codethink.co.uk/tests/1531
[3]. https://openqa.qa.codethink.co.uk/tests/1533

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
