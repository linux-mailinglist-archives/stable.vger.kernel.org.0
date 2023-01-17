Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07DCD66DDB9
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 13:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236544AbjAQMf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 07:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236398AbjAQMfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 07:35:25 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16592B61B;
        Tue, 17 Jan 2023 04:35:23 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id bk16so30394461wrb.11;
        Tue, 17 Jan 2023 04:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H1sazlO13B0CCYmrJZ9N/1/ukVSWqASb/1IbYgu+dLk=;
        b=WbQtQoGPoellA3xFKFY1+amIvyc+OBh2aSgFVXJ5OqL9NAaFkZTCmPeZvUWlGSU+YG
         ILi8AKN+dEhtPGhsWV814JG/sk7IhPqZboSKEqc/tiFisOmLGy9jTvI6ZlWxjigRFx2v
         dL0LPzowlBljUEE+5BEZ2mm7rboqYdvwogJj0uyI1i+Lcn0iDY6agpU3NYebMVKF/xJz
         JvgkSHQKcQGiD6Ttyq3Eb6MMqAxss6iYQgw+83R+U05P9l+jBqXhG8CVrztLrM9p3gQI
         AqLi9BNwkjV7JYZX0KnB5jdeFO4umCMER0wQo1d2VVzZSd47gHa8z6l4ddn0DACr49oy
         UkKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H1sazlO13B0CCYmrJZ9N/1/ukVSWqASb/1IbYgu+dLk=;
        b=QQk8ahkkj0deyFRcCkfL7RBzDIgMSCm90ZsfzLhiGvXGeRAlAERdprcZHPaqJxkDEG
         LGIivFYIkXCjVCYP3OaJgFp0GCEDh3f5AzA3wviEReh6I+sONwwG4V5+qF0gjSMqBDaJ
         sVZ60pOXgLC1bxCr55QTiCSoKGsiVD7g2wnsElz7sK4OkLXuSgv+7u4hC3evU0NclCIt
         QPKIyT3ozhO3xQp2gv8srTL5CFWfm/nN3I1TlXPjitYPrruVZnvijYdAlOopqEfwuyCU
         jdvnfSJNeXYffdAAUs3u7lrHxJncManYjrbvN2mSeVfTEdahgMxHhsDhdIEfNJ5gie08
         Ua3w==
X-Gm-Message-State: AFqh2koi6exo5r9YYNY6cDIMHk4+9QAb2NhUJqmTiNypz0e7PXZGMOlt
        6qUs6rIT9Y/VAc9Z+i7EPpI=
X-Google-Smtp-Source: AMrXdXso8XJce4JaQ4/3V6qIdrV5+rNmUK9DrELcy6Q5u0Zydz8Lv+npgysFjqsY0epSLG2o3qU7Fw==
X-Received: by 2002:a05:6000:98d:b0:242:809e:1428 with SMTP id by13-20020a056000098d00b00242809e1428mr3034513wrb.5.1673958922445;
        Tue, 17 Jan 2023 04:35:22 -0800 (PST)
Received: from debian ([67.208.52.125])
        by smtp.gmail.com with ESMTPSA id j17-20020adff011000000b002a64e575b4esm29129839wro.47.2023.01.17.04.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 04:35:22 -0800 (PST)
Date:   Tue, 17 Jan 2023 12:35:20 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/64] 5.10.164-rc1 review
Message-ID: <Y8aWCCF8bvmMnj0g@debian>
References: <20230116154743.577276578@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
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

On Mon, Jan 16, 2023 at 04:51:07PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.164 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221127):
mips: 63 configs -> no failure
arm: 104 configs -> 1 failure
arm64: 3 configs -> 1 failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Note:
arm and arm64 builds fail with the error:
drivers/gpu/drm/msm/dp/dp_aux.c: In function 'dp_aux_isr':
drivers/gpu/drm/msm/dp/dp_aux.c:427:14: error: 'isr' undeclared (first use in this function); did you mean 'idr'?
  427 |         if (!isr)
      |              ^~~
      |

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2661
[2]. https://openqa.qa.codethink.co.uk/tests/2667


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip

