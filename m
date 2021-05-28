Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66F7393CD4
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 08:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235299AbhE1GCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 02:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbhE1GCO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 02:02:14 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D30C061574;
        Thu, 27 May 2021 23:00:38 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id b25so3254934oic.0;
        Thu, 27 May 2021 23:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fvxiXMxd6PELUPQMofNFrbFvVv+AvLbyp4OiO0N1ueE=;
        b=di5Xn5h1QKfU7MKJ15uckZIw8926mOui5eKsz5iI3z78u1LCRTkcRjzHIiZGt4Yg/p
         xrmtd0tgVuVbrcsMkzoldZGLyKHZZ0ONuH62B53IHuTJjDHms59BgmFJxUsW3VhLvCok
         Nuwv7TFSWXsrqLOFkLI8NrlU1nAOHTkj8W5QyvEdr9RgcFB3aeyG3+cZrsyHlhAlUiGL
         1sNUt9c7NkuhUDur3OAQs4Q5yf0+41mO4KqKD6osAVTspS5+crI6SzNb0Tb37jLrAL82
         eeYae9M6PFA640wUjkvApA/+nauN30TQNg8MSKFmMM101zCTzD8TSupuqcgs72q0pB1O
         3YIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=fvxiXMxd6PELUPQMofNFrbFvVv+AvLbyp4OiO0N1ueE=;
        b=TqB2VeiemOli2mWcBn/WCb7Pf5nuZboXJ6RsM+BdZTuXtqwiZ3nLDFfIsF97gImJQ6
         3B/bQ5f9NQh49KfbpVkv8STUOMIan4wGOTlw3Ksd7S8gEXP9GZexgPU9QDVDT37jYZi0
         g5qLX7liSMB7Ql5h/54NPWo5nmNjrY8npMraYAoXmLAmgxbaQZSzyAfXveh7OoiWoSo4
         98N2EUd5cQJA4GXHUKnLTVcauY1+BdfPPKU0wu4TKXX/hxAVUw8J78rn92zwj48slG5S
         acRmqFe+sROsUjichI6eo/lCc8vawLGsh8xVdtCfI6NyBKayxmoxLMvyt3jmCfopW0on
         1Y6A==
X-Gm-Message-State: AOAM533YP6Qd7dJFkysUYoc0j+JarHIpJLarYa+iFf6YaO2yJUOr2YsV
        qVFYbdAQHBZ217mI8ekjhKU=
X-Google-Smtp-Source: ABdhPJwQ139T1OgatkgYZsVFhWoDiaKgEC72p+ua+ng2r/Y2RNPAMZ/csG5zHkt+EICYzht518oW0A==
X-Received: by 2002:a05:6808:15a0:: with SMTP id t32mr7718120oiw.91.1622181637869;
        Thu, 27 May 2021 23:00:37 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l8sm907361ooo.13.2021.05.27.23.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 23:00:37 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 27 May 2021 23:00:36 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 0/7] 5.12.8-rc1 review
Message-ID: <20210528060036.GC2447409@roeck-us.net>
References: <20210527151139.241267495@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527151139.241267495@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 27, 2021 at 05:13:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.8 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 May 2021 15:11:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 151 pass: 151 fail: 0
Qemu test results:
	total: 462 pass: 462 fail: 0

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Guenter
