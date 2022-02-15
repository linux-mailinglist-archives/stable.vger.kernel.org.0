Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 416DA4B603C
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 02:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbiBOBxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 20:53:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiBOBxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 20:53:06 -0500
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1472CD557F;
        Mon, 14 Feb 2022 17:52:57 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id t75-20020a4a3e4e000000b002e9c0821d78so21600930oot.4;
        Mon, 14 Feb 2022 17:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5FHwY2g8XZO7E/91FYEJn5piuLfTpdbsfC34GzvOGbg=;
        b=cAF6ytjPTkN8b5DIlmvQeL4pxrgHl1DPwYCR5658qJGp6PW0/H4Z3DM3elqWuxIdrB
         KhLjRP1/HlYBHtdtmdqqXPuzTxtsMuQ9FFdK0xeBNdTXoKAPx1gq80KyPbbcMURgmYen
         3xoSGjLwDxEVWy8T6YdhdVQIh9DdvyBUyXGKwoJ41hznCrHikxgOujpGQNmhCDQkxGx/
         t2OY753MnxWcjuSyOePwsKlZoQSQ9FSPjxp6K1UqqiZ/H8q2BHpv7wEfVJpH8AXEISl0
         vm0TLF2iLHxlaDcDgPDwvJbWMXhZPuYun8Y6SoSW4nw6mzRC9qUGe59Xu17dGRZToiZM
         czUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=5FHwY2g8XZO7E/91FYEJn5piuLfTpdbsfC34GzvOGbg=;
        b=zj8iiuklXUaJPEkv/1PiiGS0JhNhRoJNVg5pPi2/kV46ECg9eU5EcoMzVtOCv9uCZv
         bP8Sj8Tt5c6c5GHtLLZitnWHZJmIo/R0a+xeS+U7WFllKN4iDe1O8F7X2CTYSafEzqh1
         qOv01EWtNOYo0zCnHuwbNhV/7f14PNrl+1oIgTCrP/QMzq2v5Nn8u4EIt3UHadAaNoPY
         4Od9jRwBNP99dGZO7EHjrvR9NVlghU2Pl/U7E6TSTA5JgL9aFP5Q39kQUGPN3I6uxi9y
         /qQnN8cVqD6TtxL7gNTES3wZ3M8+TIIDW/hZSz6Xz4/wjKGlBjY8UOFNT+6TsXqF/Ika
         i6Rw==
X-Gm-Message-State: AOAM532JukDM//WVpRaWf6/GOpHnmn1v76Z9hOOWai46a/AWKZv5dgWW
        tdmfpuLsGDzOgEUi125K5U4=
X-Google-Smtp-Source: ABdhPJzR3C/IHrpfe+erGOUlMAhojaAvuKmYahUiK9fVqZgGgBUvAKxFB6Bt8vLXMHXQXtsPNp69/w==
X-Received: by 2002:a4a:40c1:: with SMTP id n184mr542571ooa.63.1644889976482;
        Mon, 14 Feb 2022 17:52:56 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z20sm6765604oap.17.2022.02.14.17.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 17:52:55 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 14 Feb 2022 17:52:54 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/172] 5.15.24-rc1 review
Message-ID: <20220215015254.GF432640@roeck-us.net>
References: <20220214092506.354292783@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
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

On Mon, Feb 14, 2022 at 10:24:18AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.24 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
