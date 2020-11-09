Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BD52AC909
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 00:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729807AbgKIXHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 18:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729585AbgKIXHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 18:07:00 -0500
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E2BC0613CF;
        Mon,  9 Nov 2020 15:07:00 -0800 (PST)
Received: by mail-oo1-xc44.google.com with SMTP id l20so2636929oot.3;
        Mon, 09 Nov 2020 15:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4VWlU6bBoDI+eCAjID6XHwsYz045JZHwm7ur8fVsZ30=;
        b=Rv4Rj/GXaF4gu2WOtkBGviy8y17czN3mOjACycdzL5Q7jIhXCUQ/D4OM9hxo0C/Omf
         VJKc30Jcgmrh9kHazFdOuyDAF0hdqpiWIZ/e+ZKVTHKbaaarayg04d+7kjUy5A8928E+
         X61Xp8eFZLGQtnlvESIupVBxe0jlGm3ycbYejTU9lChpwRmu6agpzcrWhGHg9fR5MJG0
         Z6tqW5AhbPXqfxSwauI0yvAxEe67qphnzutm3aae90FgFvEJJicICElbHnY8ESG2anmQ
         b6sSlqIIMvhc0Ev8nKIY1S/YTU52SKXCEGXak8VGkNkgzc3Q3kxA81meaIibjiDFnp6+
         Gmrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=4VWlU6bBoDI+eCAjID6XHwsYz045JZHwm7ur8fVsZ30=;
        b=BAaEiOCHM7ZoyNwzQNu+aNzlwZacwSZ3zQfaHBQZW3/5Z12rk0b7/FskGqndygcv5I
         lKfnQHpBc0aEwziuYTrTbReuTpvPIUfGXY5gHvbJlhhHfBVhar0eCZqrLIEAKWtLT537
         /9b316p+WhHlGVLAdAuxE1RYnCjN31w2GKH2Y32ovOyiq0UAOAcjxOV2kCoT202iWCrx
         Grc9Hom7LzM0LgJDJJXQyYHdRtB8r3XyHBmMIGlbyEH6V2E88r/pRJKtLnue/vs1EyhI
         qvdfmVxbe8CxOGcHHgljz6r+5cgMxmbyMcYV1twvGbpBhSpUud4PWqRYO0dQxZtOGFN9
         SiYQ==
X-Gm-Message-State: AOAM531HRZhtV3QegZLHQ/R8vgKjoUvPIwO8EhZDsa0npiJGMh74lBvi
        MCy9S1MgQUdVejuccoeqvwI=
X-Google-Smtp-Source: ABdhPJzIsMgQY7eYm/rVjxXg0XrYvYfwSwWkM/kaFuDLrz1N0KIHCXl/V4Nbe+eckGbLDX+Uqr5ZJg==
X-Received: by 2002:a4a:d63a:: with SMTP id n26mr7532920oon.38.1604963219472;
        Mon, 09 Nov 2020 15:06:59 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q18sm2823787otf.46.2020.11.09.15.06.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 09 Nov 2020 15:06:59 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 9 Nov 2020 15:06:58 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.9 000/133] 5.9.7-rc1 review
Message-ID: <20201109230658.GE92773@roeck-us.net>
References: <20201109125030.706496283@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 09, 2020 at 01:54:22PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.7 release.
> There are 133 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 426 pass: 426 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
