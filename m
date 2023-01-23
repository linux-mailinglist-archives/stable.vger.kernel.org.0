Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E852677A00
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 12:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbjAWLS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 06:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjAWLS4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 06:18:56 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9952366B
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 03:18:40 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id 200so8491285pfx.7
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 03:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sP/ck1rVE05Vv0gu7f80XpF6ZgtPOzhHpAqqtvJqe/c=;
        b=RkHjZEpLvCNlRS2ztVVt81CAo4UOyxjfhfcNlPNv7fDg+AUwJnPuCPxDEGMG/ExUNr
         8vbzjNNCCQRy/0lrz12Q7JNxP9SpTWsW6PEIV4TBXKxiAQLMzcTJNn4TFdvX9aFKXAr1
         WTBRUrfOcY+vZbPbqOSrRcXaPr4iFzqhj6f5g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sP/ck1rVE05Vv0gu7f80XpF6ZgtPOzhHpAqqtvJqe/c=;
        b=5TE64xA/ZRsQ7XdOcb+YOXly4jXFoAsyPVEQo9PvXBrUuq9Lu4F+IUSwHM464MvbrN
         /F1DfQJcUpzsZMy8kRXlnd9jnx4ZwbclqWRSbNyMTMX4uLV4tqFqQf/ittAZvjH/14dR
         ufYYldD5+onXYdZVX9JGzpQHqZuZKlY0GK1qUQ4FE38uoPQCf6nieyP2aCG77Ztw9Gal
         lmYthM6Ekk//Zb4DK9w2xNoH281tigv+R0LHDpns6OUAypCpuN6XcXZ41N6RpJqgwAPq
         dI3M2bv1eWaaR0UAgwr4D12T1i5VLjWMj8u/PAOpSXIj6Xe+8MxfJ+wGJLJ0dYrnGQkO
         KGMw==
X-Gm-Message-State: AFqh2krUHpPit7NQ8XnyB6nXqJycBNkBnlRozvOK7QY+MzAUCWdSQhjW
        Icy3Q7oztFxcTrAfzq5TfG5OdA==
X-Google-Smtp-Source: AMrXdXs4KCeQoc8M1qanPuzr9g//pDGp8EpHh9iqpO3i0jtL9OoLSjTkO0SE5F/eCO9VKmDNahXhEw==
X-Received: by 2002:aa7:972e:0:b0:58d:b330:6e7d with SMTP id k14-20020aa7972e000000b0058db3306e7dmr27153901pfg.26.1674472719663;
        Mon, 23 Jan 2023 03:18:39 -0800 (PST)
Received: from eb716ca105ca (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id b126-20020a62cf84000000b00574e84ed847sm20796669pfg.24.2023.01.23.03.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 03:18:38 -0800 (PST)
Date:   Mon, 23 Jan 2023 11:18:30 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/188] 6.1.8-rc2 review
Message-ID: <20230123111830.GA484846@eb716ca105ca>
References: <20230123094931.568794202@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123094931.568794202@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 23, 2023 at 10:52:24AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.8-rc2 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
