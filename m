Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D628553321D
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 22:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240658AbiEXUDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 16:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231917AbiEXUDR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 16:03:17 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85344AE1D;
        Tue, 24 May 2022 13:03:16 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id s32-20020a4a96a3000000b0040e504332adso2800941ooi.10;
        Tue, 24 May 2022 13:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yLfuSj+eslfwCY84OlbZRMgu5Ap96xOAH3GN9TZ3QH0=;
        b=Pb7uImwf0puBBI2cuXkwBT2NYvWg9rk7NeMdZnIgmYf2iWAYCd2id+UQU32nHfLoOd
         QqUF3GM7+VlWz02uydiBZUDu/IclSZqQl0/Vkw1/IHVc1xLuHX/2E0Flns5AiA7DFqSB
         AJgm76ElhvpfaiV9lxzhxhT6Iho2hrukyXSuwOmUvkWSAD1duXcdYYSqCLcmXUGY37kb
         agydoSpWN9T9tylg7TuUTNW6cjp7z6/v2oKlAwLIrE8RpJtb/KisTtk1e82TzmpwUsXQ
         F8eRZveBe/KDcjxAT67eDQlqOiCV6waknGcEwJvvx6iXNolWW5dOsaX5E2Ny1xEBmivY
         +XgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=yLfuSj+eslfwCY84OlbZRMgu5Ap96xOAH3GN9TZ3QH0=;
        b=KEkv/z/M8LsJJGhH3yhIfyD4nxLaqMSx8Rs2sUimNytot0qnote1AJ7yx4AaOMJDFz
         zrowMOyWopBvYZubVe7wML5+WKX40YOypzXdA/DyJeeZ5GvqOP1p/anq9YcPq6YdFgep
         GzNuSIagZqVdnly97j3s9l/3XURDOibkFS+BVVgoayDL/5JgtTZWDL1noUGrAB6XHaQk
         Ixgp85KRvVp6N+aOyspNwriVmcUIvnqGCoJ5UjsKMfsUfpJ/2Jc7HaXG2xDef+OWgpGX
         mulA+FQeIYEX1TGvLNRTB3yBw2/l7uIS/Scb3Qb6OtORb537wtqL5+J2U0+6u4rBWxOE
         ZDtg==
X-Gm-Message-State: AOAM532DVggud+t2PF2aq9WdWqW+c5QgXspC68+Si4q2Ja4FoVK67BdV
        lZF54Qq5yOZkOp/PVuHBHp4=
X-Google-Smtp-Source: ABdhPJwXgHDAJAXGPadLPCgVE0t/H0BINAEXqUv6vzMv/NmLnvaUZPlo+1T68gdp/TmIJ5dmQqdsGg==
X-Received: by 2002:a4a:8c41:0:b0:362:19a7:7529 with SMTP id v1-20020a4a8c41000000b0036219a77529mr11448024ooj.38.1653422596117;
        Tue, 24 May 2022 13:03:16 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z11-20020a056870e14b00b000f1a2378a12sm5231417oaa.37.2022.05.24.13.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 13:03:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 24 May 2022 13:03:14 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/68] 5.4.196-rc1 review
Message-ID: <20220524200314.GD3987156@roeck-us.net>
References: <20220523165802.500642349@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
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

On Mon, May 23, 2022 at 07:04:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.196 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
