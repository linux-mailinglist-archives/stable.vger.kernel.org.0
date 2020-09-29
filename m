Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECF227D93F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 22:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgI2Uuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 16:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728362AbgI2Uuy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 16:50:54 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86472C061755;
        Tue, 29 Sep 2020 13:50:54 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id q21so5836666ota.8;
        Tue, 29 Sep 2020 13:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vUCqiDej9EjDMEnG/JeTz+FmhCWQs0Gy0fsqtuu17bY=;
        b=W4Xkqla2zWmiBoUjuO8r8FgYtEUr1zs8iWkN4V5ypqqld2CvmY0OgNU26S2wPHykXh
         vSxwthtO4DX0ktsFZq9Pbcz4QOsClU8GObaz0tbXvpVpefLx9+L9zxUIJZmNqYmCppp5
         10bh/J933yvl5R0V4ewjQqnbrxXfuuzszUQ/6ztVKdyyAx7fx/usWEQHNsORSApLX6TL
         5W2NMF7eESIC5KinSAui7kcMvCTzDhwh3ZRSghAGVLsaRELofqbsBwqeLkH2r1QgKV2Y
         GpvUbLQBtuHVTQaUFst3tLDu8E2Q8ZwbWULpaD8RaozpBxaVTfBcrDf0bAGZ4XT/xu5b
         W+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=vUCqiDej9EjDMEnG/JeTz+FmhCWQs0Gy0fsqtuu17bY=;
        b=s8xUVrE3OjJEEFC/RFGO5nHefkSPjiwwOwYmrmxv8gmcARP/8XLrJc/rMPqMdC9PaS
         nn79knzMSE/qLWlpWAfAjygBWRqfBgcCENFv+VvwN3r00ZncT61LSabbEXv/LHIBCY5S
         9i87jsWHKDUAKWDv/9HYvQcYdUj2rAELFB5M1yCAsMLPKyjeonbkvP2DCi6SqSCwGkoq
         wFnPG+t8bv4zlSnlOV5pDTt3vPaFZNKuzg7t7aNq7RIw9rSDvEOKpJVUVlfHQct6Fu4m
         i2H90Ec0minzAw83Xl/2O8AJ23a0GuUMFY/ooWjpOHRKJ3C9sil6BNeq8iE1EuGew2Nh
         J2yg==
X-Gm-Message-State: AOAM532kolkF4xZ5um84m7XSb4O9BLeBknduDdCON9D6DU/AKlIBJkVV
        RH97GLBXDYSpCXnW6XUxbJk=
X-Google-Smtp-Source: ABdhPJx+bxiijmxV4bwVJzySrisq5b8n5ytOla9HrJFzgMsx34FTDVDvchb1xMIiRugUMDlIQM8VQA==
X-Received: by 2002:a9d:66da:: with SMTP id t26mr3872493otm.240.1601412653870;
        Tue, 29 Sep 2020 13:50:53 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r5sm1259388otk.74.2020.09.29.13.50.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Sep 2020 13:50:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 29 Sep 2020 13:50:52 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/166] 4.14.200-rc1 review
Message-ID: <20200929205052.GC152716@roeck-us.net>
References: <20200929105935.184737111@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 12:58:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.200 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 170 fail: 1
Failed builds:
	unicore32:allnoconfig
Qemu test results:
	total: 408 pass: 408 fail: 0

The error is:

/tmp/ccUSHFRj.s: Assembler messages:
/tmp/ccUSHFRj.s:572: Error: invalid literal constant: pool needs to be closer
make[2]: *** [mm/memory.o] Error 1

I didn't try to understand or track down the problem. I'll drop unicore32
tests going forward.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
