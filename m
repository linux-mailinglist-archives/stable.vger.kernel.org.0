Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7DDD605E13
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 12:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiJTKnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 06:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiJTKnj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 06:43:39 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311F01DE3DC;
        Thu, 20 Oct 2022 03:43:38 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id a3so33643473wrt.0;
        Thu, 20 Oct 2022 03:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8by0Y4Eoa0kr85uGkSh6id4MSxKcFJ3fiBsqOvDMlAE=;
        b=Dg6FZMiKOpS+wPxYXYMQwJb3ghZ5Ne0C127VSEeSn3UKizE7cW7LRh12OvEHacm+qZ
         KhNtypoje0v5fsvDtzKGq72NbjfASL/e8+ZM74dESE7QDnCfxXD8h0wzc+Z9plxtyPvM
         ou19svqJ0A6hZ3+zB6SG+EzdbxbVkw1PVVSvGywkkhCgtsKIc3pN2QzNSHb1AB8as2b+
         n4sI7lxtpfrHU+x9plYF108oFAYbulyky+Gn5iWZjryOTHbpcXViHhDlmXmAQl4xDv7H
         zxu5jPFvwf9+5oJ/GMizcfHZZPpWZI4+IEslAbikejLDq2AeOzP1eZixTEDn6Ytu+ntG
         U42Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8by0Y4Eoa0kr85uGkSh6id4MSxKcFJ3fiBsqOvDMlAE=;
        b=amckc+jKBblgOFQjB8pInDYbLoFyZcTMCmn4/noY5OR7tWOBfqWBrmn4JexApj2tQu
         xo/kI6WEuJzCdV+xamNA2+gg7+6PfJiVy2SRj5hqDgNpG0IqKpMOdxB2M6YPE1Co967f
         T+aWaE5VQWNeWJDjOcWxauLS0e+MorbVaUzkZXCerKdeUh83L2K5M42DjvEsSovstpbD
         QnwKTWcUQDlwbVQisoGdM24sphQzf4ghupzLukcAnS21N3Gm9J6lFtZomNXiQVKAcLx/
         pnsXL05eduZycUfKnS0ljpbntc0gb4ammN07q8wjmCaMZHD7/CxjXFMObVB+h14Ka/Vu
         JOew==
X-Gm-Message-State: ACrzQf00tk/oMlWOuej2E5H1RgEkggoVXY8UHmlgNK+wpguKxDGFDO5N
        HhbA8PXfCjWYFNOE9Dt3+Ys=
X-Google-Smtp-Source: AMsMyM6G/XskeXiqSWkNXzfremvJ9+c3oqzjPfthvFDcEEEWjq5GY/l8JArMbaaY5BR7Q0M6TODDVg==
X-Received: by 2002:a5d:6485:0:b0:230:b6db:d41c with SMTP id o5-20020a5d6485000000b00230b6dbd41cmr7786324wri.709.1666262616595;
        Thu, 20 Oct 2022 03:43:36 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id p26-20020a1c741a000000b003c6b70a4d69sm2357806wmc.42.2022.10.20.03.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 03:43:36 -0700 (PDT)
Date:   Thu, 20 Oct 2022 11:43:34 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 6.0 000/862] 6.0.3-rc1 review
Message-ID: <Y1EmVsftX4MYH8TS@debian>
References: <20221019083249.951566199@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Oct 19, 2022 at 10:21:27AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.3 release.
> There are 862 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Oct 2022 08:30:19 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2018

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
