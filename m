Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E14332FBF3
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 17:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhCFQbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 11:31:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbhCFQba (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 11:31:30 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8106CC06174A;
        Sat,  6 Mar 2021 08:31:30 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id h22so4953933otr.6;
        Sat, 06 Mar 2021 08:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0abfN4+p0r6rxh7CwRm9iy1owMAFDWmJNro201nOqLw=;
        b=ksCDMYR0X9T7gmseXn5T67qmlgWtZah/pulGNgYrw3kbTMghu3ft/HMv0yJlNS10s+
         bar5rgGLcaXEGWfjIGTQggx8tXDXAlyv7ItJtkmNV4zGyT7TsvWKUe2tUBAAOSno/vCn
         7JvxaAmlHVJamdcAEEVyW1KK/sJmtmxfYOInvgZbTB3PX2o0YWoVgMKP9DZEa+s0N3uJ
         yE/VOZ6NfvqwTamcQUR+Gla7dMeizAiyW8Rl/mT3YCSeloRk0bMTyQ3Qt6kEYZRiaUWY
         JZjKi7d6bExa6KHiBMtAIe7Ir1yANmF177uFik2pD5wABq3spkz/ddScMYxwcDdDBScm
         PTzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=0abfN4+p0r6rxh7CwRm9iy1owMAFDWmJNro201nOqLw=;
        b=ex2BF9KfmYvRiaWPdRhaKwHkNW4t2NWmq7NEmZtJTH5U85tRoSGNHEZ/VgKcgDo7Vw
         q4cSLhfqEC8+t5kR46tn8bKhJsj0y+TMC1C7jYBNXr0EmVvBhPoDMw3yR22U/XZDUdoa
         9L9C3079wxdFa4Avehpp++iZWmG263tdV4NTqo7diF+t3ftEVGLbPkiu43AgPSg8iHLo
         gqDhjY1KzOqHAqexUtmr0KH0LvTj0WkSWUX862P1YjhhqaFsGuQOe+S/yGudX2JjlSrl
         d0gHoF1QAFyhRVN6/3FMniTgOR086RK0AOWcPIC1eEG2coR55FK4MuNkhgtXwmM30u+O
         1sww==
X-Gm-Message-State: AOAM531eLGG81HklNIHz1ZIgfVe2bCji3jFxHaqgtGYuopjklzMINj9N
        ahJxqIi5kCi0LbW8X0Q9kTE=
X-Google-Smtp-Source: ABdhPJzdXYWuc6jg8NQX0nt1DJeKk6XWv3NsFnj/EXvi28xkZwaQUqu0+QOUxWhU3f21+FNDZlVq8Q==
X-Received: by 2002:a9d:3df7:: with SMTP id l110mr12697862otc.36.1615048290026;
        Sat, 06 Mar 2021 08:31:30 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m22sm1235754ooj.43.2021.03.06.08.31.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 06 Mar 2021 08:31:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 6 Mar 2021 08:31:28 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/52] 4.19.179-rc1 review
Message-ID: <20210306163128.GF25820@roeck-us.net>
References: <20210305120853.659441428@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305120853.659441428@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 01:21:31PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.179 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 420 pass: 420 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
