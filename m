Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F6532FBEF
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 17:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhCFQaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 11:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbhCFQaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 11:30:23 -0500
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5E8C06174A;
        Sat,  6 Mar 2021 08:30:23 -0800 (PST)
Received: by mail-oo1-xc2f.google.com with SMTP id p6so1203584oot.2;
        Sat, 06 Mar 2021 08:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9m5dJzD2rySY0G/cgv2Z9AEW8iF9E+4pvIHpxsOwTiA=;
        b=TM3dCJx4gyk2hm/z76lM3Ldp5xz1b1uDh7F1mp9npc42NHvTuw1xvwopV2pimEekCS
         0MAD7JLsDrQODXs6JE6uUv2/y8gPGHZcBIJmr3YnvY0z/meuLPEkyLen6rrLxFy+CcP1
         3evs/gAvSa3DNKCJHZls/JfUikXfto7gtt3QrnqSt+Mkr5Ys6po5mINXMmblNZFflhjS
         CticKYAGyXFEr7zM06i3iYwUz/myGIciLOhnCznEK5ZUAbmqJkaxhMgi5uiwisNt1kmq
         0DwqCmiKe3UVnI062wlxrr4D/u98lQ83fiGJuNH1T1MCLh0HKSBjKHbuA9P/xu5kGs9v
         WDUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=9m5dJzD2rySY0G/cgv2Z9AEW8iF9E+4pvIHpxsOwTiA=;
        b=DG8kh3XKwtRqIfaH9+K901pZvl2JXNfwNsfw4twnof4nNyJfPRJJ+sMsUR1W6uyXDC
         mGWpFfVin7AtlKRwPwwrXT1goNV1HwVTHLYp0NJ93tF9LB2WyKLi8EwHTdq9BmV4RMmk
         PEX0Kx4H4uBUoHhg+lciSaU2ODu4TnxDKXeSnF8oSZ7cUcLk/vpCN4mGfiSSLkBUMNDf
         LFll20o09F6l5IFaNcDDM1MvgJNnkjI1TpPuzZi3qXapAwafC9ekyFXCMgJG5sEO+20f
         6xwHFdjhq2rStMj0y0wFGxlxmVmRqBilrYcwhWFhdpBOjptqryxm9o0lL/9X4x2sYL6f
         D2Bg==
X-Gm-Message-State: AOAM532dcL62qYzN53KBge/2Jf2z66zk1W9CQvoMhIWIX5koi02JSQAQ
        aC1JRlRjdh3JvADr1E1v4cU=
X-Google-Smtp-Source: ABdhPJzkWgpH/aXcF3JRZernrKHiJennQz6NPTMflf6KxWGxrG5ZXVy1FvxPmu5AQK6XHD+uQNXJwA==
X-Received: by 2002:a4a:c706:: with SMTP id n6mr12310564ooq.19.1615048222963;
        Sat, 06 Mar 2021 08:30:22 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a6sm1181986otq.79.2021.03.06.08.30.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 06 Mar 2021 08:30:22 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 6 Mar 2021 08:30:21 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/41] 4.9.260-rc1 review
Message-ID: <20210306163021.GD25820@roeck-us.net>
References: <20210305120851.255002428@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305120851.255002428@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 01:22:07PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.260 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
> 

Forgot:

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
