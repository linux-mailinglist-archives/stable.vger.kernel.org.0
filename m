Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008EA45E6E5
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 05:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352146AbhKZEfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 23:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358221AbhKZEdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 23:33:46 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B6EC06139C;
        Thu, 25 Nov 2021 20:18:34 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id u74so16486802oie.8;
        Thu, 25 Nov 2021 20:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wufeo9wAAG7/tdiBRSS366cjw40GcsJfcKHAdCGDRX0=;
        b=QuCHLfjjwtCycealnFaQKqjABj8/NJEcfzk8CroiVNBehfWxcFSMkydvslVle3uyCS
         IHpkDYb2UlsEdY+4mh6diAmGZDG6I7dDn6/6V4PB2Jye5zA/b753U/qksh0U2vaVOYzF
         eJq9wae5YS6MrmGuhWzturIRyS3vscCCZZUtaqSvJhuEfbNj1PSMu2COa3qj1WIf4yVt
         PDd5GnTDCYgMRpaqp8yJpQiF7/zNLCrB1xFa0Nv4fXg3knxQxsbFhfaTjA+3sh9SGLAG
         u665XBbjuM8GmvthlfZGzW7OKDBmNRh4KGOLC7c39AtdA9TyQeM8R5YLpi3BCrtggMj8
         LdRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=wufeo9wAAG7/tdiBRSS366cjw40GcsJfcKHAdCGDRX0=;
        b=uuQmW3cdTB/59p3xM+knW98YYhrIj8nN0pExDgoOvNlYZWmBZa5NvXWA7wtfEaeKI1
         q9B8KO5H6GIWKEYExm33NvQH7XMKTCgNzd+OKu+XNMEW4unuMQs3zgQ4IlR8tC/7LZs8
         DTb58pbDIF8ygUGywjo2DCq1bjtHHAkkNvymUMzMU4ACrcXKwHR1uNBPxKvAgFRgvINk
         vTTYk1uQormgL1mWyrHgc9NipdzN1v99DPFMRD5+VK/o40jOv0lTSile1byurOgtty00
         m+RYlBSN8vbX+qDXvujGYd75o4dBef+yPzWIh1pK1gyOALrAw74oK0JSZIYe6RifiMlF
         H1gg==
X-Gm-Message-State: AOAM532Km3ntvtUGDWyIaEgpeu87xqFVE6PSdO1Xmot4tlgMVw/pP4aF
        UMJ0X0Qi7pWSSKrKZrO4iAsFXib9ou0=
X-Google-Smtp-Source: ABdhPJwm6P+AjhcSP9mqBVgziUmKkzJ9Jn3laLID7pURE5t1Mh+8aFnNjngnCMR3wEJB0yXhdh5jcw==
X-Received: by 2002:aca:af42:: with SMTP id y63mr20597221oie.167.1637900313581;
        Thu, 25 Nov 2021 20:18:33 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w18sm844285otm.1.2021.11.25.20.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 20:18:33 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 25 Nov 2021 20:18:32 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/100] 5.4.162-rc2 review
Message-ID: <20211126041832.GA1376528@roeck-us.net>
References: <20211125092028.153766171@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125092028.153766171@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 10:23:51AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.162 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Nov 2021 09:20:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 446 pass: 446 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
