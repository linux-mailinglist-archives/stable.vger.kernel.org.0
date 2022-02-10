Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12AFA4B1758
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 22:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344463AbiBJVAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 16:00:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344465AbiBJVAQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 16:00:16 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5280210DE;
        Thu, 10 Feb 2022 13:00:17 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id t75-20020a4a3e4e000000b002e9c0821d78so7960456oot.4;
        Thu, 10 Feb 2022 13:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mZCscgKzlM5JyygXB6uJSHIvkFjLITBgUjtuJHNht/0=;
        b=pDGyOYv+n6uEWjEylJwT5KrTqkOaIRT9THt4K41W7hzpZnkeUwYsG2Pra/NdfDsST/
         2by9SoGNJ5bcTe5fdPK6P1AQs9rSDtaIclCgBFISVKsowca4qEr7nzy2Xn3AoCW84QBy
         0iOwwQmtQ27rvgAET2hgy8E6zfYxiG0OLCULr4+aAXr2SsM+Fyn+pAF865M2p4x2bCdN
         8UNJWeG5Hq2nnBpvth8M+87szXvEm4NIcMvi6LvUMuSDxWEjV6GcVrBZum+/QZtYxQvd
         WRqY552fEIM4kRPtQNl9c/Bn4DIbZ9SR3K1hCm/LFl9HxDP0bQMGEX7EHgkRbsLj9k/G
         iTmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=mZCscgKzlM5JyygXB6uJSHIvkFjLITBgUjtuJHNht/0=;
        b=SeYxHoRD7LlSxPuy9e+CoZHNhzXFtBwXBWHxtqPHCH1tU0xwu/wVHjIYv2csYv1RN4
         nOy7sA+uuGifuMfmJpwbX/nk5xt6lltWzXvJ4XGzvrhHWfEGpCaOrTeFB9B4kS1bTcl3
         1tecf/erJT2Fj1xzOx5bln9uZdKdl08i2IU2HOGhp6DUZXYvfn2eUOVCYxWPeYKVqW8+
         eMctqmL+Grsteqd3b2MaYD3F8jRHSn1KyclM86Yupeqv2ZGYyLDFSgROo0y5xH1Un2by
         +IBDfligiJt6ZQ8g/l25yJWKW2bZizS6lggdDDSBtLDLIKcO0z4MIy1dk/V2FYNdypBo
         ldnw==
X-Gm-Message-State: AOAM530Npw8Gnxm049vxzqnydACwXj23JEGCEzp9N4YuLC1iLRAuUEFk
        lqe37wlmaMNZ7iLyW0/nGZk=
X-Google-Smtp-Source: ABdhPJyb8O1c2wVcQZ1GbR4KdTQB8hPZNBbs+/0lT0Z8dGYAJwcAWnhismnf2qY48i9tXN+6dvS0sA==
X-Received: by 2002:a05:6870:790e:: with SMTP id hg14mr1329811oab.191.1644526815978;
        Thu, 10 Feb 2022 13:00:15 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x19sm8390584otj.59.2022.02.10.13.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 13:00:15 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 10 Feb 2022 13:00:14 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 0/3] 4.14.266-rc1 review
Message-ID: <20220210210014.GA2963498@roeck-us.net>
References: <20220209191248.659458918@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209191248.659458918@linuxfoundation.org>
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

On Wed, Feb 09, 2022 at 08:13:37PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.266 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
