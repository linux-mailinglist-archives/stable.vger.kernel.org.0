Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5D332FBF1
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 17:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhCFQbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 11:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbhCFQav (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 11:30:51 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BB7C06174A;
        Sat,  6 Mar 2021 08:30:51 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id a17so4967006oto.5;
        Sat, 06 Mar 2021 08:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aIRyXEU2Smz4hR10RPhUomRYUtZ864xg8YwSnBPf918=;
        b=Ii1A5oyA4/X3J8nRiXFW8YAmcIPPGYyf4q8NX+4fuzyMigW0wTXBIsIAjZtOmb7CZ5
         V6ffLbZiFdXVOXm/Z4tkxsI2Koq7WGXqiyxj3napsPu546mPX80eFe/poxb4/oZWwnXT
         Q2KPE0wtxgbp5TJWJzjiIIzIytcDgyyayS7aV6d8k5TSmXVE8scJ+KOh6OeNJT8HPtxk
         ci+jJJdU0ZVLQxv7iJbI4h9gg4AKOvMlyxiQZGgbzZVdCa6RQOrxecfcKobzuwW06wEB
         zqWLU2Ahqm/F/6mkx9l7wHS8Px7PX939dMiB5N35K7wW2s6L17GYXDM04VFuwuszZ32d
         Zj0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=aIRyXEU2Smz4hR10RPhUomRYUtZ864xg8YwSnBPf918=;
        b=IgCwQAZMR1UAOOlJc9kwwRKO03a8pWr4IJRCWiKJmEIzgYpBtcQo/bLouI0HPWT2fM
         WjaW61RSXuZqjvxsc/pK41KNV8n8PZRIGMqZnxA1xvJkf88J0sXRJDa6RAkZNq3w9D5V
         OFjvLd6HRvBZrnc1tRZMRwR9B4+Xf6UAmPtAu/8aIZSzNP9dEh3WwyEZEqc9EJb5K/aW
         21b6psM2OsG6JtaCGCbscuUdvFa0kUDZmjtEwcidsHjVYN28pX0alb6qRzWU4pyieOMJ
         eKMZTu3fKCkPrlthIleJEmV05pCGD3cE2jI4xHwv1kEv/Q7Dwg6vaF4mmmueyDLYVgjU
         a/8g==
X-Gm-Message-State: AOAM533DHafyLzW5g2woUKcyIlW1QlumbnvX8AbiU/u7sDN9DKnenE84
        ZUB+Mfwz6Za+lwDmUnzoWVk=
X-Google-Smtp-Source: ABdhPJyn/qNNNacsn6dkL1f1FBc4rJDlxZaha8TCyHFQovgpgC91SZrx063k7g4OnrN0jX0SVMIOpw==
X-Received: by 2002:a05:6830:1d43:: with SMTP id p3mr13088281oth.184.1615048250926;
        Sat, 06 Mar 2021 08:30:50 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c20sm1199199oiw.18.2021.03.06.08.30.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 06 Mar 2021 08:30:50 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 6 Mar 2021 08:30:49 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/30] 4.4.260-rc1 review
Message-ID: <20210306163049.GE25820@roeck-us.net>
References: <20210305120849.381261651@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305120849.381261651@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 01:22:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.260 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
> 

Forgot:

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
