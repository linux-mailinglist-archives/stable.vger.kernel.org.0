Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588683B0F7B
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 23:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhFVVha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 17:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhFVVh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 17:37:29 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6BCC061574;
        Tue, 22 Jun 2021 14:35:12 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id r16so1001565oiw.3;
        Tue, 22 Jun 2021 14:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UaFJH157VEq1TGvmsnmh/6hxm+V18Eon9s87IyqSJaU=;
        b=PFxJg8jpRzbz/PPn1dFyIhyEThXDK8tRGEubWAoCGdwllPCBlmXUjIfAljuJa6dVj4
         DR6MJDpYduHsirhxQR4bzcQTiGFXJ3FLwnSji7ZOF07F7tzBu1uM1lwrJDUiMncQRHDw
         NHFD5yR6ONpjY3Rbr0Wp+oGAuJJlwYWINyhftSh/cdjlFLuZNC9JYY22Pstq4mDMbnv9
         Q7H/A6rkcSZMDK3q05G3vijl9T9YkMD4ku0cwNJokJZBUBekeIxySyqcIFVRzAiVEPWJ
         AoT7oGbLyflte9X4szaz+FHgepAPAmTj8orp02ZafuHqT+BCj7wHYQdVL90d8f9diNSE
         0N9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=UaFJH157VEq1TGvmsnmh/6hxm+V18Eon9s87IyqSJaU=;
        b=mjf0TmB6Oe8WWL4EMbU77bIKtwFrw8u2Oj+wO6fojPVxwAmmDot7mGfjpvtM5Kf6Fl
         FDi4SXun/Z4zUjGsq1cRD2aWAQylvEKu7FkLLNPc6w8bdrkkls/Gx53DwGo4e5zjK8NE
         R0arqvkJGXsp0SdX1UvIMBegGgWryhTOKnxZ8+SS0DCYnZ6ht5vpy/OnirtDiRT4yqOp
         YkbeMWcnU6AdWnkKHNEM2ose4E+MoQhEROCkQEx/yeD0a1jk7syYPnbcGnC7jvbGH/ZJ
         IMpXC7Aw702FPVfCUt7YMLwm+0SB5CaewamrBuc4ijtNY6HexLoMi/tZdjnObOLLSHSd
         usBA==
X-Gm-Message-State: AOAM532RHdynRBC+G/zp7GGIBSBwD86FUMYAUUQi9FDtX3sfBh4nQA+E
        lDkmLfs4Hu/q1X0GwlN7GkM=
X-Google-Smtp-Source: ABdhPJwhcExUlT+jq4k6nGadXEzt5SpL10slbhnItOxim5ivzOecBTCOjwjiu1nUN2Ui38cWKn/poA==
X-Received: by 2002:aca:f444:: with SMTP id s65mr642265oih.38.1624397712175;
        Tue, 22 Jun 2021 14:35:12 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x29sm124442ott.68.2021.06.22.14.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 14:35:11 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 22 Jun 2021 14:35:10 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 000/178] 5.12.13-rc1 review
Message-ID: <20210622213510.GC1296965@roeck-us.net>
References: <20210621154921.212599475@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 21, 2021 at 06:13:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.13 release.
> There are 178 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Jun 2021 15:48:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 151 pass: 151 fail: 0
Qemu test results:
	total: 462 pass: 462 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
