Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5F53F7D22
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 22:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242615AbhHYU0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 16:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242609AbhHYU0e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 16:26:34 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1124C061757;
        Wed, 25 Aug 2021 13:25:48 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id l12-20020a4a94cc0000b02902618ad2ea55so184715ooi.4;
        Wed, 25 Aug 2021 13:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Jiv9Pw8i9GLMvBgO1OZvWArORrcE7NEP5vKp9GRx9lM=;
        b=F4vjMQ6iyYCLYwl/f9kGRd8MCHhxv4ziYTDkPZ8sGaG65+ZESmqsOhig8t0+56hgJm
         YCsaTqBqo1MEaOO69cZZmAevWzHSPi0O+JU8E2HyIn9XMNaoPmBbNgpyTi1Uke6ZclB0
         MByL9IXB048284sAgGpJmJ1PR0LOT4o3i4Rb7Ui8FyxYE2CwrlEnnrr6pI7YO4V6irCi
         ZVf3oAYNumVE3IIyjFUC910lJHKZX3vHCPj4S9Ifo1y3WIY8ZvdxMP4NNVfhsIUU/yYh
         YOLm9QfgIsDn1ldPjrYSxfR16f2Cacj9I8R2YNopW7aKRGkRpV5+H/HPWvMZ1vYBQ9Zw
         aTlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Jiv9Pw8i9GLMvBgO1OZvWArORrcE7NEP5vKp9GRx9lM=;
        b=CqWbuVdiIWrCx2c3IJjCjnnXCV9DizQ0YUquKASzWv1K3Ho+Nb/2DmRfzCyQaPRYCL
         +U2gLSk/8jbkNnbiWVuaKjqYe75zjiYhmqcOyvGmNO8ogDIl9MOEoTkEN9Q92tLNyWkh
         NQ3JICXOjwLzF55hXWBEqWH5YUorbho4p3Ory3YIGidLcWvxo5QUrHCy3v9MXCOvgcAH
         6PRz8pTGs0VtR9i54S8cuODnC6yUk4sF3htdPb6UQT25J3k639RHT3AjjxgNgl0149+F
         bMbDlr52jd9Yc6wkF+PYjtB0Pd1tBb+slVzYAzI4hpbS5SabwTdDfGFEJ9BjrQJlPYmY
         4wCg==
X-Gm-Message-State: AOAM533MtmcanXc3dxlpWxH68iD2PTBouCSEYYfXaujvPMyVd6yaB044
        PTzgjYjQiphPsShRoWQ7SMo=
X-Google-Smtp-Source: ABdhPJw0TGAEBgOC1yH+o+owkrE0TFr1CjY2/INBRXiCgNUv3SS7EPtNLtQGgcBsrGfZfe5JQXHalw==
X-Received: by 2002:a4a:d457:: with SMTP id p23mr148703oos.70.1629923148169;
        Wed, 25 Aug 2021 13:25:48 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l7sm165595ooq.28.2021.08.25.13.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 13:25:47 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 25 Aug 2021 13:25:46 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 4.19 00/84] 4.19.205-rc1 review
Message-ID: <20210825202546.GD432917@roeck-us.net>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 24, 2021 at 01:01:26PM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.19.205 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 26 Aug 2021 05:02:47 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 438 pass: 438 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
