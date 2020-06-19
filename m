Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22015201ECC
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 01:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgFSXuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 19:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgFSXuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 19:50:01 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC8BC06174E;
        Fri, 19 Jun 2020 16:50:01 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id k2so4760424pjs.2;
        Fri, 19 Jun 2020 16:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=w3OIWl2TWBmOaXkwLWuFtI2R72QOBe5nEWdqHYE5qrw=;
        b=UvHuyZ1zCUbWku/JDJLMnXb16lOrcWRUvVIfLZdY+ueLJtR1oXk40JPVV59ASg2wbt
         RV7Gyt6vFDPWIY39rbUX4s6UQyuXEjG4ePPpFQRD1HkQuroGYzgnHAQ833iiOMEznrzY
         1S0PQUd3BpjRiXAclhALWnLcJbeCFqSsvfUX8IKwmWs8sdssXbHKGyf5ieWOlC1hjUiK
         RVYNY92m2+eAZSEaXhUDD/lv15BnNnNHmpmajv54wHjCQMB2E2jph8Fs9oMXCnPIasOJ
         Ep+WnkZqmZJQD9MMzhoVZ9+BM2GKGtqhs8fSH5iYnfTcYVxAnCktkfoq0IrSLW9qrUin
         alOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=w3OIWl2TWBmOaXkwLWuFtI2R72QOBe5nEWdqHYE5qrw=;
        b=iAul0OXnClTfN9U5ysGUoayM8e4xTdAr6iGRuw2Ev10b69Ctzf6BHY/VPUCB1PnUz3
         Sie+lRrqLeevhE0XmYVnPTrogY7fHm57ql3o2oqjTaiZGMtsYAFFtZcU1gXjRetmCy/m
         Vo3xbHvvUwp0TPg9Q1fAhsVVYAaw7TmG/TpJTBqM1Uke8HaoMEzoDwPXPFOTOydWEWHq
         oRl4yKQnhUBWkevr9Fnd76AOIm/Mt7hZZ4h+0Y0a1EgaPfEm8uTGg5dsQwf2/wq1RUfg
         n0+A/xz3RKxbOWlLA2xmTbmYsxGxIhmRbtAzO+oTb5cX0cpRaLJBDiZWBhXld1MrpX0g
         byBQ==
X-Gm-Message-State: AOAM5313TCZ6a1yKrLqTQXDvr2JPLVFapDPAD36mJVvA3kC/kXPzATBx
        E62JGK+5KTrSIOhuPpAqIpE=
X-Google-Smtp-Source: ABdhPJxP/RTcln4Xzf67Tr7cjB5wP+jVHPIbyCn9IKtxMU0Nn67yoLGeqWWFEsWnKKhXvnNZfUwHEA==
X-Received: by 2002:a17:902:6548:: with SMTP id d8mr4383508pln.298.1592610601118;
        Fri, 19 Jun 2020 16:50:01 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x20sm6026528pjr.44.2020.06.19.16.50.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Jun 2020 16:50:00 -0700 (PDT)
Date:   Fri, 19 Jun 2020 16:49:59 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/376] 5.7.5-rc1 review
Message-ID: <20200619234959.GF153942@roeck-us.net>
References: <20200619141710.350494719@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 04:28:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.5 release.
> There are 376 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Jun 2020 14:15:50 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Guenter
