Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E284ACC00
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 23:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235281AbiBGWVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 17:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242361AbiBGWVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 17:21:32 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C52C061A73;
        Mon,  7 Feb 2022 14:21:30 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id b15-20020a4a878f000000b002dccc412166so15378330ooi.11;
        Mon, 07 Feb 2022 14:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wFhLXWchk49XO6XaaUdOJCoA9VgZCJ1FPny/dt9AN+4=;
        b=BRlA9SaVQRATsbDJyUjp9LkWTT3PF7P9Y/VvUhtVsPNJJ7pfRy3saqxP9ebm2gTKVY
         5s0au7hLRVz1CUnpKUnCvoQGe42smZkT6VdRUl6N3493MZe6Gdl3fESfYP5VNxuX01uL
         GnceLGiS32jpZNE40wwYqIBmydKtjZ49h/qUt1SeGtq7hOGEX7DiUwPQwtyikcuR129g
         CdeHueMCzK6NvzvNsDQW/WOGuN67/4mYmRv2rJ+Sc2pgmwheZGQ3vF7w0Sdes4NkDXRK
         hNwyphK7O3qOVtEX/NuDslmzqoZbDCwRTuJyMc42PuKXCP/HrGEjx38rnb+rW0PJjwrl
         tgsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=wFhLXWchk49XO6XaaUdOJCoA9VgZCJ1FPny/dt9AN+4=;
        b=MFy1OqJmrMhHwUGQWIyhYDlr7TY41vQ7E3QNqyDqnRoJBCeoT6zTSFXXyyKgYxk7Bu
         YcBHo06rY9Oo4F7z5h+uv3O2ibDPexr1tBHyoZOcOfPQD+tO5S9qfyj4OPGMSb2csiyp
         zovPVGLJtjd2yzAfGbtJjso0gh/KfGGILmRrWEP2KpeyQMwWSiO4CGzj6c/8nJwe17q8
         VQ5iMpm0Hh2SXISmz5GBDnhSPVENS7ZaoqT/2ZZbmbPVnCFW8hNRGBvg9kz9yCbKq5Tb
         5g/1asFO/WOE3O3mZuoX1xfLwIeM0FWIe3m5WMMt7K5TzOJvG7F0RKRJsKe+kQ/vqDB/
         xWkQ==
X-Gm-Message-State: AOAM531ChbEzazZFhmdHSFhwYJz6kT9991s25/9s+O3paosMjJQqfhIv
        Cz1cPBJbhi0pdhiT6LlIMzg=
X-Google-Smtp-Source: ABdhPJzJ/UCZhA5ENG3pA1JpylLQzGtw79ROjQMWKySOCc1vYPudclDJYetq1gGDvXpEw2GNQmS7Zg==
X-Received: by 2002:a05:6870:e350:: with SMTP id a16mr345067oae.143.1644272489740;
        Mon, 07 Feb 2022 14:21:29 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w7sm4513118oou.13.2022.02.07.14.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 14:21:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 7 Feb 2022 14:21:27 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/74] 5.10.99-rc1 review
Message-ID: <20220207222127.GD3388316@roeck-us.net>
References: <20220207103757.232676988@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
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

On Mon, Feb 07, 2022 at 12:05:58PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.99 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 10:37:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
