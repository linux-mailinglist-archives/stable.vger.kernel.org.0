Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167355368EB
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 00:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352476AbiE0Wj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 18:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354859AbiE0Wj4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 18:39:56 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76DE762A13;
        Fri, 27 May 2022 15:39:55 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id l84so7290896oif.10;
        Fri, 27 May 2022 15:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PRzq3eo9kkjY6xfXWbgYoYfge4AM1rynBBRdKqMUaog=;
        b=aC9PV8dd6ttdGzMcBJJu+UDelJirO0MMkL3/1nK9rgDznMrkI0tRQQz3OQqoIna8MI
         fQJQVWS9YnrEHAlwPlHofSpEYrYijmSvTP90c/KUBXbn3eKiw1dFCEe2JoeSj4GhSH4T
         y0713avOC6FfNtjmxsJPOgoZwg/4U9Bi+hdyk4EBOZVBfBEzJPRPaa8h2YdZZ3hQmbEY
         WYfIvx49dlCEIqpEU6EM2OA7TSr596UpqF9i+oN7+tkoBMLTPSR8n9fWljHdRdKheHw5
         cn+ertDmzeVqXQy4HFpq9n/PGJ8c+IbXwT4Ggwn99E7EQuvGjXIyqg86WmtQrQ1dgnZq
         xVsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=PRzq3eo9kkjY6xfXWbgYoYfge4AM1rynBBRdKqMUaog=;
        b=Ubj7C2u15t3MksVlC+KqH3D3epkcOgJGP8ZSBpcWSafut0Dl6Bqe7dfDfb8rnGIopD
         tFNEnfbRG2FwcWx8HBN6bHn2qwHwYrgeMi/DaYbkoV3qM+ECMYsN0vCepGyuX84Kgd5e
         SFMihnX3P3CyFkUisy2ySLPkal98GI0oXsvj8nKDJUGMH0pLdgiU0tqyWzpKSjvgrC0P
         hj71BVX3mJCq+A1qGLXo8kdA8XIl0dlkmfBJsbHM5JulPW6DDLq0mmI2qYIimkGkchsr
         vrY59a8SATMXL/7arHFXqTURBSzEEd8UhGZvP6DDTP3SdCQSBj1q7ly3tmi7mPspzrpl
         hFvg==
X-Gm-Message-State: AOAM533/E2RlTDzbnUy3OOGcCsJ3wq8nmoAOQPytVYGGsB2V6ln7TuFE
        +qwCysub7SA4U/S30VcR/KM=
X-Google-Smtp-Source: ABdhPJxQ4yijg+1rvqbQtLsnLVSuPoj+2D3l6fPZXC17kqDEO7y2xd3RTm2lH+ANshz7/TP33iuJGQ==
X-Received: by 2002:aca:5889:0:b0:32a:f591:8731 with SMTP id m131-20020aca5889000000b0032af5918731mr4718110oib.270.1653691194872;
        Fri, 27 May 2022 15:39:54 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x2-20020a4ac582000000b0040edc685e11sm1441539oop.13.2022.05.27.15.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 15:39:54 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 27 May 2022 15:39:53 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 000/111] 5.17.12-rc1 review
Message-ID: <20220527223953.GD3166370@roeck-us.net>
References: <20220527084819.133490171@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527084819.133490171@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 27, 2022 at 10:48:32AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.12 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 May 2022 08:46:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
