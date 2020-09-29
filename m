Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C660327D929
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 22:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgI2Upj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 16:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728820AbgI2Upj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 16:45:39 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E83C061755;
        Tue, 29 Sep 2020 13:45:39 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id x14so6993110oic.9;
        Tue, 29 Sep 2020 13:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kP/doZng03t9cIOCsvhZTRdinmkOlGOOCPdgpH3w1ng=;
        b=XTnk2AtRDpkHBzz9sWx8w5mT51dVBD9fbnmAZaBD46WkoezvNhr9LSzEUS2wdwFwzL
         DYXU/TYdKlfqiApZBWQwQv0OTGTByafnN8KE4fBmZ6mfgvqYxoiSsorw3JE876tSuS2J
         G511PNgWidvcbTBz0KM70GLFuBnDMVK0nL8giWM3G0Sdq/yXMWHom6whugKHIrfTNN4d
         jJGExyV5y9SYAV0+PJEETCWABXtT1uukYWkwe3fQfAe7PGw9viCuejv3i3sqAV/qUByd
         nNOZWQI56zLf2y8TumS4BWBi5d8qj10/86dlFZ9vqXIpMCXufq94sCHR+RKfopOo9DNz
         eQWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=kP/doZng03t9cIOCsvhZTRdinmkOlGOOCPdgpH3w1ng=;
        b=Jpe8+xbZRI5rOaaldJedVJrf4c2Gw6OHhqQ23R+SQf7qThpGRA21wkur6rovM8Q47V
         aT0esHL5puA37TovjcXsvUGM6e5qSQ5fOGampXmBrULjgaUyqdhZ8K35CX66590A5uUH
         41QhT3ao5E78pEwCqedcLG1mt7o2d8nPNdZJmctjJ2CZ7KxA99IUlKa8GChWPNVXidAw
         JqJEPYAjCEdrKf/UM5LPQ69KKxFC91F6KHryZtrE6P55PDSDvyYxXWtjFnX4Oz9SyLNb
         /pY+QBnmmuzZQ2eMX+nu5GysedUuPch7wdZ20fZgurr19xePz4zTbDOFphbzf+wdvJK5
         hp0A==
X-Gm-Message-State: AOAM531lHE4iMH2xrYkWc2OkWKqzsu3iCe149ECuFlYFekX+/OqNxij6
        UdxgCOZv3n/a8cHtwo03grs=
X-Google-Smtp-Source: ABdhPJw4/qaiLvD+h4NyHBW1CQ5Sl7uZ5aGOJvx9xEvx0b1wzb25hW6tjgoEGaOzMMdILvFzfL70Gw==
X-Received: by 2002:aca:538f:: with SMTP id h137mr3826210oib.103.1601412339005;
        Tue, 29 Sep 2020 13:45:39 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w125sm1248435oia.57.2020.09.29.13.45.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Sep 2020 13:45:38 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 29 Sep 2020 13:45:36 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/85] 4.4.238-rc1 review
Message-ID: <20200929204536.GA152716@roeck-us.net>
References: <20200929105928.198942536@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929105928.198942536@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 12:59:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.238 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 169 pass: 169 fail: 0
Qemu test results:
	total: 332 pass: 332 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
