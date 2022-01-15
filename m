Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE1848F7ED
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 17:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbiAOQjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 11:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiAOQjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jan 2022 11:39:54 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44368C061574;
        Sat, 15 Jan 2022 08:39:54 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id x31-20020a056830245f00b00599111c8b20so573768otr.7;
        Sat, 15 Jan 2022 08:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YTPulQp4q3mRU5jw1w6GLVBKTeFl833/mkrZiUEb47M=;
        b=ccVwG+DVhu2TEokLjH32/C/VD6PPmDCPLy2sWGQfs7A/HTMKd3bAI916WTkZ0PzvXi
         7Q/BqFXZCNihshZYt0gnMGd8pht0ISI2niXw8glDekFyqrCrX9pI3kR3k1VE/IQt6JrL
         2VP4iU2hZCHUMTWnAcj7obZIeYcZD0n4MQr/1yFdx5L7u7V79LaD44nVAux0CueiVAjG
         fCs7H/g5kCqQDd44uFKX2jULhhA/F7NP7gxlinBN/hsJs7wsL4d9ePtCA+l+28ndhNWN
         OTG4KDSubKinCuW0/tMGDReuDgD+yc7ejad6TpwRM5mWNpPXJ6NQGdAyRv8Q6o+PLya5
         5xzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=YTPulQp4q3mRU5jw1w6GLVBKTeFl833/mkrZiUEb47M=;
        b=4TzgcoxFlAI0pkNix6Ve2Qr+MWffFYliHqbmZzbtdEH0lQqeKW8Lfq9Q3TFK3Lrm7L
         s6bKvh6iQVwe9ZH0JwPv6EsVyH9k66dmVTpRTURY02gwK96SHKVJUzWFCBgSPVUal1GL
         xyWqeKuWtlpLGD8J+Zcfh/uec8+/w0RGfMpVFUunqhJyzBute2SALsYwgCe5q5lv+qcx
         krSsRPm++H1npjljM0usMs7Vjkb+2DLAGqFot/iGm4hJpGpbTOxlR6ntzJ68IAS6Y2bD
         esR2iXP1wltM0IF8i/TpQXGihtZKxIC3voMmjseyWP2kOjlUBjtUtgI0Tkp5/YlB0NtG
         U7IA==
X-Gm-Message-State: AOAM532wWFXwUpTUYASkO9SJCppwHURgybd3TWXQ0eEZ5hQXHU87FNuE
        Eqtd41Gqh8ucDFmI9UUg6UI=
X-Google-Smtp-Source: ABdhPJz8j5KQLrKs/M+lDYuWhxnBu7S6QU+pjkH0nQoLQidaTs0z6oISqwsHSJePSAqVd07m8llNzw==
X-Received: by 2002:a9d:24a2:: with SMTP id z31mr10473754ota.216.1642264793643;
        Sat, 15 Jan 2022 08:39:53 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b17sm3633438ots.66.2022.01.15.08.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Jan 2022 08:39:52 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 15 Jan 2022 08:39:51 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 00/41] 5.15.15-rc1 review
Message-ID: <20220115163951.GC1744836@roeck-us.net>
References: <20220114081545.158363487@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114081545.158363487@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 14, 2022 at 09:16:00AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.15 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
