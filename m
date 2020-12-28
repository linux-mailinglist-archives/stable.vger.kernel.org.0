Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855802E6C3C
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbgL1Wzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 17:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729414AbgL1UZj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 15:25:39 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2A0C061793;
        Mon, 28 Dec 2020 12:24:59 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id j20so10173164otq.5;
        Mon, 28 Dec 2020 12:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Sgz+ELLwYmarYiRdYOQumGU9LTVrklEAU5pagllME3g=;
        b=BEHuC2hsxu7HutOM//+PNmab1XZdAL3gc/1wnGLzFYKrx+Pm4v2S+KzV1RZAYNwNAo
         AzTngATRFKLEZuw/Y/jBNkCPbJrdGNxLDJ8slQuMciS3ULWXtB5LMaCdwetOhVaipYWU
         tPz4qS+AdtPKmqllUVy0uezwp/i9cqhtlUE9nNm3anPEsEjXWVt4xpeqmhvJz8ZwRB+i
         PTVAGKdIKL1X06aWIFWcYLkMXscCcMAoMCeT32Pv/otC9DbLW2R8eQ4jyBXswMrI8i5G
         6ZjRcAbVBYTUXv7p5jzw3fljwKTGNXkxtRa+XUkH4UiG6cVjTdHlgOAcjhAM47jhk6Qy
         QLlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Sgz+ELLwYmarYiRdYOQumGU9LTVrklEAU5pagllME3g=;
        b=KN2kII1ImfdYRCDVexNDPzbr5M6f2LVXSLFZJm1HIZAeWhtMNX20DS69U+09MeYfz3
         n5M7rMVmZME5hh2Nc2weS0JKWu3leQr50+qKNeiGPxcurZCKuBbidGbBsRH5yJMUBxUR
         4jA+X6M+yKzA4AIDfYcOYPYxQZ9KYDbkN5GfIHVGePWOneNN7Z+KwFQ3/WW9ppKhKeuc
         D/XAznbTGwp/lBrFmqibJV0jtcAYtG56paxw5OSuGzbGazhjQWShRR0ue7ztDqYoR07t
         +SiHJuoxOkmurPsfU9k2fYpL/xKYl1/KRoudtmZi3yqZBl9AZu3Ar++IP72RrrXCb6UF
         vU5w==
X-Gm-Message-State: AOAM5339ygQYKtR+V+TquK2ui4lZrqiqoiTygpOBbKmzohiuqvnJus5t
        sC/Xjon6FA/Tu+6Usx+fGvE=
X-Google-Smtp-Source: ABdhPJy5QXNhsYNGGk8Xaqw/eYfY6ws/nR70ANJEs/XN7kuFvGqlFR0is+BVrOWvCMW/AuwmJ85v1Q==
X-Received: by 2002:a9d:3d06:: with SMTP id a6mr32666701otc.368.1609187099178;
        Mon, 28 Dec 2020 12:24:59 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l12sm1441230ooq.22.2020.12.28.12.24.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 28 Dec 2020 12:24:58 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 28 Dec 2020 12:24:57 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/175] 4.9.249-rc1 review
Message-ID: <20201228202457.GB9868@roeck-us.net>
References: <20201228124853.216621466@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 01:47:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.249 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Dec 2020 12:48:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 382 pass: 382 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
