Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10E48611FD0
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 05:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiJ2Dgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 23:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiJ2Dgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 23:36:37 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B06413E11;
        Fri, 28 Oct 2022 20:36:34 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id 8so4696915qka.1;
        Fri, 28 Oct 2022 20:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=20Gh1YbEg1rwYS/meHQRi/TUL6E5CyEIVu0Jp1uVBCI=;
        b=iVn2JaLGZxnYGW75ZSWfyckIj9XM7flo4udF3NISB5KTBHXmG5UsNhSqscGJIqFjZV
         St+C65tu8uoK8ixwlL14XFY/Xav3ED2PN+C5KLmTepgLlS/zCFZr9UYjCLJZPI3pG/XS
         z30J7i5P5BcPj0a7ytrl2pNhgyGf/u8Bn/ml5YAK6xrfR/HhHGLQZSlx96ufZSpFlVXO
         SJT8oy91q6ucp4ID1Y5xf6KWSh2LhmCZFb9GRoF4azjGgn5xRrzpAAwjr0Mq9woDwMXO
         dsOo07OBKgqa94WOAKYTHh4+P+5qKtrz0JdP4qXESHnH16gAVFqfmsU8GRx1eaMI078R
         5zAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=20Gh1YbEg1rwYS/meHQRi/TUL6E5CyEIVu0Jp1uVBCI=;
        b=TKgMvdYSK6yayRf62eKJ0xflrfRnROIqUkF6YOdAmO4AFEDUqGjLxxsKWIqEwv2vLh
         5ytgEAZUYCJmchoHuKrJlqhuEhfFAtAugpPcWx5iNxtwx9m9415P/B3exh/v8mKfMY1F
         MYrnzp4F9rH36dTy6n/roH7KDQBvUgvK6A5Gdqhaiw8aV9EueZrq8QKgjufPPJ5012Lm
         Fzbh8Jg8ubfrs3/avxzrLyrgOX9XjVBKeMaP+3O307DkdLa3uXNan6vinZihfM4TSWoU
         n0QQIlDOd5hJL9LVNWVTzzi1TTtbl9aS2QKqyUv69DIqq1es5EnIm5R+OyUyQnew2O9T
         ZLIw==
X-Gm-Message-State: ACrzQf2w4WfZ9ynD6Y7FwQ7sTEnIaR5OAIxiEysF5KFw6m1ok0XZd0HQ
        X0ZLm+IrdF4Kwkn2q1k4so7gQgmBEXI=
X-Google-Smtp-Source: AMsMyM6JE84j4gkIbUNs8tUNeqQTwPk7bxpmr3/2kUoTkXj5RjYw4gxybBIxUh17he7jgbxfd32Sew==
X-Received: by 2002:a05:620a:2909:b0:6ee:6c83:9769 with SMTP id m9-20020a05620a290900b006ee6c839769mr1872641qkp.732.1667014593416;
        Fri, 28 Oct 2022 20:36:33 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g23-20020ac870d7000000b0039d02911555sm244547qtp.78.2022.10.28.20.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 20:36:32 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 28 Oct 2022 20:36:31 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/94] 6.0.6-rc1 review
Message-ID: <20221029033631.GD53002@roeck-us.net>
References: <20221027165057.208202132@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 06:54:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.6 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 152 pass: 152 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
