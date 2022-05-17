Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8075E529FE7
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 12:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238682AbiEQK73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 06:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344899AbiEQK7Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 06:59:24 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769774B418;
        Tue, 17 May 2022 03:58:53 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id v191-20020a1cacc8000000b00397001398c0so1141376wme.5;
        Tue, 17 May 2022 03:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TC0kU0kx+y+RWbBCqsAsP+HQ3aEjY5q2DVAO89IeC9s=;
        b=FA5r+NX/lZ6cGo1t613iezlHCeUvETSbCJt0C6O1VgaCyU6YyuylO+cyX6HtRu1R0N
         SAFWjtumDwvnU421Jv1/jdQuDnIQ7rbne9UuXWX1ATR4Sh45j/9b7uPVbkrkd8n24XZP
         DAKx+h271EWgpWbniGbSgCUSJe1mhmJXMkAETQjgDja55vjd4xxIwhRTYAhxMSQqsFCK
         +x64/icFr+/F4THXp7Vo6KBhiac54xeCWr6c23hACEpZbjtJS41fff4++cLP8L6tUMB6
         bvOIAkSA2VYMEVtZWWTV8K6MvLkTQqwEQLgBxy4V0JVrhH+qutsXTxOYoxiMcD+BmirV
         V+4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TC0kU0kx+y+RWbBCqsAsP+HQ3aEjY5q2DVAO89IeC9s=;
        b=2BmtYCq3DGQVGIbzwBFk16GtHmu01o+ccyTZt9cLyXMEwUDVhrsR6CYlZ3iAV3njwH
         lL2PIvJOAoSlJxuQfeH7NDzteN9HIGQTVUcgY/lqsEXMM4ps1eDUY5XVWPGxkcjyyxdv
         CUDy/zVP1bMAF4f/acUOk0dO+UEUISXIWSky9FHhG9+Ypz6e2nLhHJz5vGscfKDps91T
         /a4NOvJ8dbz3tMIJ1R/4RYxWu2GmPIMLCtHIDJgv9A00LhtHQLfbcUik7U5mJkzPFrB9
         k92MSohigysX4Rp3MZ454/1+wFAMaNxwOjv/oXVlTb34qn4hS2qrzTkvvQvD0Pietfd2
         wXFQ==
X-Gm-Message-State: AOAM530fB7WLOYagCWxsFsOQXaCtI5mYifRR+xFqPKRpn3eKpyClAZxb
        TLpCBb5xGPVIQ029TEKoNipo0hxgrOU=
X-Google-Smtp-Source: ABdhPJxr+0d+xg6WXoTCcA+d7OTzh/bY9pK52Mpf6fsQ2xUBaC9j4joKbBWfLuzJKShLqdcTx65yNw==
X-Received: by 2002:a05:600c:1d18:b0:394:6469:abec with SMTP id l24-20020a05600c1d1800b003946469abecmr20876498wms.89.1652785131942;
        Tue, 17 May 2022 03:58:51 -0700 (PDT)
Received: from debian (host-2-98-37-191.as13285.net. [2.98.37.191])
        by smtp.gmail.com with ESMTPSA id j8-20020a05600c1c0800b003958af7d0c8sm1584389wms.45.2022.05.17.03.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 03:58:51 -0700 (PDT)
Date:   Tue, 17 May 2022 11:58:49 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/32] 4.19.244-rc1 review
Message-ID: <YoN/6fcgA+1V375I@debian>
References: <20220516193614.773450018@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516193614.773450018@linuxfoundation.org>
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

On Mon, May 16, 2022 at 09:36:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.244 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 12.1.0): 63 configs -> no  failure
arm (gcc version 12.1.0): 116 configs -> no new failure
arm64 (gcc version 12.1.0): 2 configs -> no failure
x86_64 (gcc version 12.1.0): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1154


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

