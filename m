Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97BA027CF79
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 15:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730146AbgI2Njd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 09:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730316AbgI2NjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 09:39:24 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B0CC061755
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 06:39:24 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id w7so4573374pfi.4
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 06:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=0b0l8ZUG3zwXWMxWGQR/zxHkfGwj6nS7mjqC10ksX4g=;
        b=fsG52lO+3Ej3Fej/RMLsGa8ytZSz2un10lwsZjlazPSe9cOsSJJ/ucPvOM6RC4cud/
         mWwbPOSMxV3O8oivM4J4Z8QAfFfe6hWF90oPluVDZVeyXHrnCXR20nYTbPEUUY24Sslr
         W5ZeELra4wcZtNLo9SNgHC8ExdGtelocjgPgg+pGAa/O4Ex3dSbfGo85uI3osUgYzCzc
         WTaf4V7+dhflVxq5y4neiLJcxkrGkT+Ig2Igokh4k+lZyIVeuxZeNvNjMAcS5ov7s0Mg
         5PBIakqZFmwXAgVn7FbsGMsLdPZbFWqTP81fu9ytG473dreLn5wvjVdh8M27Xv2ijOUc
         ojsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=0b0l8ZUG3zwXWMxWGQR/zxHkfGwj6nS7mjqC10ksX4g=;
        b=hpTguZfy8ZO0NhLMIqJond3H7JMGbuBuG0W+Ed1SLeKiJWEm68J+qmvi4stv1xldmx
         G/Dx6ySJZ4YY2/0YCMR8fl30aFPUY3by5n1Wml3kRAHwvir0yCbGHIhe6WMvUtPGQdco
         asJjgorR0SYE0Oq0ej2iYe7XYf2AqGcw4PX5VB2vdnUBV1MJjYfoPinADhqoEIlUh048
         H1DGDq8LP0kKE71Yw3/NipTF1W/AwtiF5x+PaRXA1P0XZ+Ewnkgv4uXsoSRkRxwGiSF8
         4ztFIQ/OXIaotEVfpyygCskHmx3rAkGc5eyGweUdo3xSPwQQekV+kWw2VkzB5qRK4UyG
         Ud/g==
X-Gm-Message-State: AOAM532RHTwXYsyzmeeCAZ6SXPZkLgYq4vwrG3oWzjQnQEEnXcU6sUZy
        OH6Rcs+Yy6FEtgFiIO1sLlTyhw==
X-Google-Smtp-Source: ABdhPJzWSHlUls723LLvd6jzpzhXgoAF/nY//8yL3Er8Ogb7M09BTqnoLSsgJ+32tZfmlCe3Zau8PQ==
X-Received: by 2002:a63:801:: with SMTP id 1mr3396344pgi.48.1601386763471;
        Tue, 29 Sep 2020 06:39:23 -0700 (PDT)
Received: from debian ([122.164.218.24])
        by smtp.gmail.com with ESMTPSA id g23sm5625895pfh.133.2020.09.29.06.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 06:39:22 -0700 (PDT)
Message-ID: <666487600b77a8e59c737c33ac7acbbfff96a25c.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.8 00/99] 5.8.13-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Date:   Tue, 29 Sep 2020 19:09:18 +0530
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-09-29 at 13:00 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.13 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied,
> please
> let me know.


Compiled and booted 5.8.13-rc1+ .
"dmesg -l err" did not report any error or errors.

Tested-by: Jeffrin Jose T  <jeffrin@rajagiritech.edu.in>


-- 
software engineer
rajagiri school of engineering and technology

