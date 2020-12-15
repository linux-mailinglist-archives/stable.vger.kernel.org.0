Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1BE2DB52F
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 21:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgLOUcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 15:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728377AbgLOUcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 15:32:46 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58277C06138C;
        Tue, 15 Dec 2020 12:32:06 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id j20so16246131otq.5;
        Tue, 15 Dec 2020 12:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cSNedly/9r2/zTRadf5gSAtcsLmQ7KKn3gTsH9uBzeU=;
        b=g5eO+FWsZbOCxfrybejSsPfz2wTM9x2U8kO+v9f5Hq0RM9NNDGHY/oW5lv1cie8IpK
         5Eg6OWa7JAK4L/nw4acSN9Ub1+krkcbHBAAaOytjsojhUkucFDU43YC4NyHyGw45mKZP
         Zx8lMb+V44vnjTNw0c1GI4d2GOnORTGEJcpcx/NjGf98emtrT+sSm8gTMD2zSqL5UzZe
         QuD4vZV0CX5e5KaE2jINcISgAdUDwbBRiAKFdPTjA1q1xaeLiXCClSjKhASWMFBdDMHk
         /ZcxNyeOM/mVFO0Jfx+287qtYmcQF2vXOHx6nGgYc8k/kSwmCFu7cVb32ZeLB1qZHG1r
         53BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=cSNedly/9r2/zTRadf5gSAtcsLmQ7KKn3gTsH9uBzeU=;
        b=A2zVYhwJho4UTH1xYon8Q74PSiZG9a7ONGav8ESeuPfJqd0i5O4PdriHwn+YB9sAZR
         ZfAqfAPSnvd/I1nArjpq+BraiWFZtO5+7isCX4KVnxAioppnrWp6ZzBn6nUsvuDHJala
         O3C/1X454p651avjsmy3GrfmD8Co/Ut7mf4GCOcrfNjRROIePmdkMSUXTm2RQD5uuAkP
         zBchsfNEtZ7UfpbgCVQEYqEHFzxY6OqZo4aHdqw+titLrIl23GsCJ9nVDHbrEv7qx6t1
         sujy8dt/lihyjEEwpAZ6eHWP+jf7wooCxCUHeF/bYTgZQMw4PYqYLzxAyZaHjyoJMBIe
         pl+w==
X-Gm-Message-State: AOAM5311x4tQYQWIJaumxcpwpz+I74VXrp7T8jTqhtHgFiPzi+azuw8R
        Wzugsm2rZwZ13M/9Gqz387b0jfYu9w0=
X-Google-Smtp-Source: ABdhPJwm1zHh2ecOYOSgup/RgcQkosIixDjPBARpUiyMmtKvkC4qCe0/YfQTyHYhcbLsla8PmrMDxQ==
X-Received: by 2002:a9d:6e0e:: with SMTP id e14mr25124508otr.30.1608064323558;
        Tue, 15 Dec 2020 12:32:03 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w21sm4879824ooj.32.2020.12.15.12.32.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Dec 2020 12:32:03 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 15 Dec 2020 12:32:01 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.9 000/105] 5.9.15-rc1 review
Message-ID: <20201215203201.GB188376@roeck-us.net>
References: <20201214172555.280929671@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 14, 2020 at 06:27:34PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.15 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Dec 2020 17:25:32 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
