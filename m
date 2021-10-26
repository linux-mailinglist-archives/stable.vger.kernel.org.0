Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6744A43BA7D
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 21:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhJZTSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 15:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhJZTS3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 15:18:29 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDE0C061570;
        Tue, 26 Oct 2021 12:16:05 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id b4-20020a9d7544000000b00552ab826e3aso145560otl.4;
        Tue, 26 Oct 2021 12:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X9XLx/j9emA36kptcNyVQCFTr3RrGI0S1dzQCU6JzCE=;
        b=Tq2wy2EdezwcDZ9fG5eXiIF2hGwneKJfyf5CGWCxoURU1VTTv1VLF1arSNtGSABBTK
         mgQEUIb8vFuwRiMutjr73taog9++W9o0ayZ/v1g76u8fUbYqf47v1MrQwCT3ihlJlg83
         XhDI6W9ITPFOzH5yZslPZR0KqVWBD+sbejDP2BQNGMqFxavdXj08TjYPwFmx78NzuCJ8
         JiFZyaFr3cimhgYXTP7rruDmgyAu07ll4C8SOb5u3yLrnLFQYqfKRGdY4eZ+naAUOjt7
         n1lVVu+w5JvQsgT83O7hEPgdooe4ew+rPGLz/A+YIJxRpZBIMYhgJ2i/1FHZmP4fnK3I
         lpww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=X9XLx/j9emA36kptcNyVQCFTr3RrGI0S1dzQCU6JzCE=;
        b=JHwsME3+AU+fkvgB5sh7DYUtwIEkC2tG9vskPuQdDmNOy6c811sriQfwq6bf6FIlmi
         3RyhdRDm/98nFBthIo3S6QXuD7z2//cYOm1mPUJLZQSMWFHLhNSyRt+ql4qUMKIXtYjH
         kC5CGEWV9VL07fyB5EKZxES1VyHAc+Vi8FKPyiwP7BCxTT4wRruCtAZOS6hnzIhFcXHV
         JohNtUnJzayEBvFo/UYE68pns1D43PVxJQ0JkTyKhl4FsSYa6UGqueG4oct3VWeReegT
         AGm1TKhcwfJK+E1t7hYXMr7+9CQPMaYpRx+78dnwsNSnytFJSGY3VTXj44Jp+Vk3HL1K
         PVBA==
X-Gm-Message-State: AOAM532M2zElSWHcP3D+OkEsW2VyoYXBhG4GSVkialP/srQ/v+HTInfO
        B+T/9t46RLJB9oUFgzefcGYbrAac2WE=
X-Google-Smtp-Source: ABdhPJxvYPjd9jNgswhHdTwB0gxEQ+nWB/8J9QjkydjSo0AHm9n4BuGQ6GzLMp7h64XRtm5Wj0zbgQ==
X-Received: by 2002:a05:6830:4090:: with SMTP id x16mr2347952ott.172.1635275764602;
        Tue, 26 Oct 2021 12:16:04 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d15sm4803922oic.32.2021.10.26.12.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 12:16:04 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 26 Oct 2021 12:16:02 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/58] 5.4.156-rc1 review
Message-ID: <20211026191602.GD2014125@roeck-us.net>
References: <20211025190937.555108060@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025190937.555108060@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 25, 2021 at 09:14:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.156 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 444 pass: 444 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
