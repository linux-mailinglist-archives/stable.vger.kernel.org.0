Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF07E44DF78
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 01:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbhKLBCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 20:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234546AbhKLBCM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 20:02:12 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E0EC061766;
        Thu, 11 Nov 2021 16:59:22 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id w6-20020a9d77c6000000b0055e804fa524so11508781otl.3;
        Thu, 11 Nov 2021 16:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h3IMAoEKvl1g8CharZfjxhDP9s6IX+929p+pPoJS4vQ=;
        b=XUpe3MoT6HYty2b91dVp71dEM3OSAt8WrRbODpA9LTjiMdyJdnzMNIeTMYudpElT1L
         n9qsZUpJIEmWU1VfBe9JA4z5xhCQcjOTLndfOAkC8DvblYCt0NdSY3wL17fosQu31bzj
         7BhyLypIPh4shk3H4idbsd7yBFjzhpv73+WKO6c26Zx0homiZHiPE4cNmMFBQDJ7gujh
         MoCreEoFKkVZ2dZQaRKQJV9Fd0nA9iG8jslV4JJxO1BtPqUn8Ep55crmO8rCRJc/HP3B
         VLb2jfu2hPjSyrnNI+9+2uK5CZXr3uifMLmpNwxP8oKFOBwfJl9Ako/RvNVRjjhTjHTO
         yilw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=h3IMAoEKvl1g8CharZfjxhDP9s6IX+929p+pPoJS4vQ=;
        b=PysCK4vpMhDfXZzl9bRKX7r/yyWdU5vcyo/Kt1XjvhovOxNa4Hgsl2n3CtWs9d55E+
         WeYuWrtSwrG6ErrrBUFmYjOrTs3HsxLmz4UbHM66Jw4ZIZ7yZAzMq07EpAoFVj6fLG0X
         IVrYtAafSSjZTBAyDnHzwwL2uhIoSw9Y0/K4uYxKgkNPtArVlyvQDHvUjld5AkAP8Scd
         Qa/XYEO3aUI9lLWEeqxI7qu2k2KAeGdwUB8KDED0X9+RKMP810Ne+73eF5c3B/bLNga9
         qAmFLj5ui+95NgioZ9zON5PJVFRcqlfBq1/xX48WhyBGyl9tqXScSw0VaapG4K23p2O0
         Mfeg==
X-Gm-Message-State: AOAM531wnB5DTfhNYXXIqvcCDqYuMPTLZNMjjBVz2GeSnA/QrAisSVOs
        gfVMWei0F2+yTigyXWaO508=
X-Google-Smtp-Source: ABdhPJyohplFFLbq4o85lI6EQOjNH7nByjR5pUv55EGsAXEYSLR0LXRLwbAP5FzFxy7EIWIq6IAMUw==
X-Received: by 2002:a05:6830:22f1:: with SMTP id t17mr9141552otc.39.1636678761722;
        Thu, 11 Nov 2021 16:59:21 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k12sm940777ots.77.2021.11.11.16.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 16:59:21 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 11 Nov 2021 16:59:20 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/17] 5.4.159-rc1 review
Message-ID: <20211112005920.GE2453414@roeck-us.net>
References: <20211110182002.206203228@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110182002.206203228@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 10, 2021 at 07:43:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.159 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 446 pass: 446 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
