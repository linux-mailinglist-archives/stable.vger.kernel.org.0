Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E90128D263
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 18:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbgJMQjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 12:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727639AbgJMQjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 12:39:21 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7FB8C0613D0;
        Tue, 13 Oct 2020 09:39:19 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id d28so637601ote.1;
        Tue, 13 Oct 2020 09:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Wg+qLQH7zPxu/s7PpvglKJ/cFsmJF/W6o/BWbDuJosM=;
        b=Z+B4iCJUAT9X61ja2vz82iEEUyTKVLCBmwmuXtzSx7RGZFqt0wnRMvB6fvgbguy50l
         9ahF6t+z97u32W0GC9lyigzDXT/q2Z1GFQ39mtBNirwxY5bkLIexr1DywqmQryr6wPSn
         6laaba5+51LeTGvDvYkAIDoG3/FjkREv5NkIY6PjKh4edJwWSLhNspKRKqI1CoGgHJOB
         LIQMAlwe87KFJy87ahyjePYhpnaolT7J/A+axPK0ilcmZP9aDwREFscM3Y3aSKqzXPnZ
         R6rUKo5Qf81sqra2WJZDgX1HvjCW3dn2RfhfAfQfhG5Qmw7pG8yyDwADdAdnvBm2EzfW
         Vhmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Wg+qLQH7zPxu/s7PpvglKJ/cFsmJF/W6o/BWbDuJosM=;
        b=E6J9pAYu476XVmEAs+JsgISEMwLGnwYnkubSAKbg77embKQsi+4bKJQDWtgB1PnIHP
         IsSlQMquvI7aowRdwhE0igbTjdCNU+A9JDS6uBwKzrWcAowCaGTHpK60LF30DP+FvM1z
         vZqJ8VVzVzk5/Go3FK7Fi9o2sP6fJew7mxJlpzrPipMTVqBa2BNK+Rc4H0LbSvBR71DB
         DaZ049E5KihgZseyovwI3hV7UjMssX/IP/VzbXHTKYZaiJWbCITiAufPDvoimL2OFtJ5
         OB4KKbn1qT/+815RSai7DC++rlV6xYmbX5pHyMuUuRtBbaecnoqbzB02i30sbSYJHdrs
         EG+A==
X-Gm-Message-State: AOAM533qOsmiHCt90NRlmib9iO2QAEST1WgBWjdYIMCbCiHjiLADqU18
        CL1gVhaZJggl3dHkVRNe5lo=
X-Google-Smtp-Source: ABdhPJx0gNNqNfMBty0eEIZ5V4K3Hm0dqPAPVWd66XeHP4HoUDHwEV0tuYUqOQuKeYD+wWQHwcyqzA==
X-Received: by 2002:a9d:27e6:: with SMTP id c93mr334559otb.47.1602607159337;
        Tue, 13 Oct 2020 09:39:19 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s201sm93475oih.25.2020.10.13.09.39.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 13 Oct 2020 09:39:18 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 13 Oct 2020 09:39:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/54] 4.9.239-rc1 review
Message-ID: <20201013163917.GB251780@roeck-us.net>
References: <20201012132629.585664421@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012132629.585664421@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 12, 2020 at 03:26:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.239 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 386 pass: 386 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
