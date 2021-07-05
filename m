Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679FA3BC370
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 22:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhGEUnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 16:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhGEUnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 16:43:00 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC170C061574;
        Mon,  5 Jul 2021 13:40:22 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id h9so22053037oih.4;
        Mon, 05 Jul 2021 13:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I1p7MahbJ+LF7YZPvRwHnllZEO9gVbXbjFcm5cH2K/Y=;
        b=irpNmgll1WW5/wIveIXjHe2auyH+0WymhX8dd4XTij3U6eQao/tUCf216NLcLg7gbq
         4YE9BuSUpI7LoGqKoH3qvkZjBe+H8n7Fi6qqYmBZn2t7tFf/t7kK90/BKpNq8ZBQGdqM
         Xq4UzEgTMd9ZdRgTw6MgDLu9sF36v1zWgh8j4QN2b79HOvg0EmS1KwcWAucyMa6RIT0L
         Xy4FNFMSrL7bIMLJ2eM2RygMXtWaqe3N/mCmarSAvoBK+bLZE8okMoAJyXlQ6SDGH6eI
         mTl9hP/z9Q/DaxWCi6Fc5XeOxmeYKOYd2WpisMUzwXCVPGSC6fkEIunfAUMx9Ly8laZM
         mEIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=I1p7MahbJ+LF7YZPvRwHnllZEO9gVbXbjFcm5cH2K/Y=;
        b=CPA2/D8+FSoUX1fmsyWPBIRocFdyHBSVn3oFOFKwuyEuLG/fsaCYU5KQhU82g3b/MC
         6hLp4tq6xT4QTNQ+YGfMGHdajhWnu7mmwWFOrJsb9Z/uNdqdKl3CZWqsM8KPdeMCzQ98
         izOJ7+A5l3v1/AWfU8bNebgyoiqt7RH1FMw7U0o7KVLxJvujo8mvzHe7PWuzId2Gfzvf
         lRCgbMv7+LdZY636qFXbnxcTKacs0RT0K1K2L9glvOS7Yp0+HD/aTBFVIcRI/76LKsMd
         X94D+27WMHM29hQvGZ7XDGc4egKvfaRc64aJtOtPOjB3lYB0vEEPZyrpTBBBc2oCwlj5
         w6sg==
X-Gm-Message-State: AOAM531cMFgAtK7ICLAjOJKlQEjVHb5yDkaAERs4f7UccIGKicKAGKj9
        eKRVmO9Z6UW8hjTuZkdEvFY=
X-Google-Smtp-Source: ABdhPJwRc8p9lSaz9WJIY4qllLudT66EP6Y+iVdlfpAr96fOh5W0iAb6H7Wj5+bPuWdOqz+shM8LLw==
X-Received: by 2002:a05:6808:f0d:: with SMTP id m13mr736562oiw.23.1625517622441;
        Mon, 05 Jul 2021 13:40:22 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t14sm477137otq.23.2021.07.05.13.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 13:40:22 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 5 Jul 2021 13:40:20 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.13 0/2] 5.13.1-rc1 review
Message-ID: <20210705204020.GD3118687@roeck-us.net>
References: <20210705105656.1512997-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210705105656.1512997-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 05, 2021 at 06:56:54AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.13.1 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Jul 2021 10:49:46 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 151 pass: 151 fail: 0
Qemu test results:
	total: 462 pass: 462 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
