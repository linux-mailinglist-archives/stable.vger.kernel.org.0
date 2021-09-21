Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7528B413B71
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 22:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbhIUUff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 16:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbhIUUff (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 16:35:35 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD5CC061574;
        Tue, 21 Sep 2021 13:34:06 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id j11-20020a4a92cb000000b002902ae8cb10so100144ooh.7;
        Tue, 21 Sep 2021 13:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Hcbf/8YqIlHQtwFmvXP6IubknfHGLy+X2L53S60Y54Q=;
        b=OWhPVMjA0RTXQKjvhcD9rl36HvNEsArWAzL36xKr+zccEtfTrMS7bzlC1I0A1/OI4j
         +sE+96IF+nQ7Qz7HWmrOtalpoeT0WN1BG2aZ+7zUgh8qw1Xv9/c4NyUGySpV6I8cwqX5
         0b4YsYNcPs/I55aderIMBN5rCcewTrZnwQ6zMWT/n1GBnf/1QyQP5S99Hczpbhcd25n7
         mvTZvi6T99mWapI/vKZmDAM780qLPKUqEdtDm81kYv6xC5UFInJ6ur8eLNNap9hx8RxF
         mBPbPFLds4aeyhmvmshtoh+uFC4lSyJ7TSelD10gpKqOrtemyFHa6vlWRT45u8fzlo1A
         w4hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Hcbf/8YqIlHQtwFmvXP6IubknfHGLy+X2L53S60Y54Q=;
        b=jqXbjYXa0Ie3GbAaZYkOs/43q/SuakftJlOgth4s3M0bROlqRYaBYrAYqBw959G0OM
         ncCMo0LoAoK4fJ1XAg/3FHP9YxBaSBJqPwBOTKrgm/1ZPgOsblos0xXqcBdD5UF+CZHo
         MKiueNLlZZ0VuJ7smcC37DEmuFFsXeTtEePZ5CWfHd8WZrsBqcE+DuA714VBG8BD4Ttx
         TTA9MVdRNK2bBxxv3yyQ0dMc5wLYjwqhCuYToNW+HBkCaqirRAWHWl2arC03QNAMvY6m
         Hu7vw0TOU8p13XFV8R74wdSZET33k48H5kc9g2SRF2M9EYstAIr8pMcD3GXWwDd/70Be
         QTsA==
X-Gm-Message-State: AOAM533mFCDE0N+DYFCOhe/YoGpj+pqcnsOQO2JGwPS5hKSP2SOlNe1a
        6EO/4tTQkB2LvC7R/C9PBuNfJwgNbqk=
X-Google-Smtp-Source: ABdhPJyTqqe0sPposET1Uzht/W2B/f3FbGwmLd4K6Ir/lPRiJCN1ceg+oOZ45ly+5QARkx1n99lTlg==
X-Received: by 2002:a4a:2104:: with SMTP id u4mr21741467oou.60.1632256446195;
        Tue, 21 Sep 2021 13:34:06 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g2sm18226otp.7.2021.09.21.13.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 13:34:05 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Sep 2021 13:34:04 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/260] 5.4.148-rc1 review
Message-ID: <20210921203404.GE2363301@roeck-us.net>
References: <20210920163931.123590023@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 06:40:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.148 release.
> There are 260 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 444 pass: 444 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
