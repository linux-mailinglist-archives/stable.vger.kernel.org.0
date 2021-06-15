Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11D33A82CC
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 16:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhFOO2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 10:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbhFOO2V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 10:28:21 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D77FC035412;
        Tue, 15 Jun 2021 07:20:59 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id o5-20020a4a2c050000b0290245d6c7b555so3537023ooo.11;
        Tue, 15 Jun 2021 07:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rdPFsyMwmkaTSyMzxVWsG7+Le6D7NZchhx0RrqcnSVA=;
        b=ByFUGocXrlrCcJ+p5PkxPE6mfNKH3u8V+hkL7Yf51Zg6OEmOgdcXW8QrL0Z/EGNBSZ
         OFFOnvg/XmvTdUxqJBiHy8elr+L9NOuQtr1t+peDYpjVyt8NizTphrz2JwbSyRA5Ikku
         B3DEillJtPCB36FLrKjvpAlRiOnQW5NMZmvrv0qDI/ODChyl3sRXxPEBUN1byi4ip3+3
         K150xEXe1UNXr14fYZ0pWX3NVFpfqqDck+yg49PRXFwN7GhQ17/3bPA1rzfDYfU3it9h
         bbUoybjtjKXl+RUu6vjIcmmLYGGlsq4QwTpwTQKwX9FiKKl5EEoabPDChd1B/sSSz7WG
         4l1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=rdPFsyMwmkaTSyMzxVWsG7+Le6D7NZchhx0RrqcnSVA=;
        b=t1aBdwitdjimyr8crt7IAKrg7uxWf2F05dtJQ+jejeBkGQL41f7HazX/VgGTTWW02z
         yKNQDM4NJJumb3R92cdhmqTg+tuZnuTW4825hBCLfAB8g3nj+933sQzo8OE4WXWPLUZu
         m1bNesXdYlXnUrsH5Y2eBDLqzmwAfEC2bG+a/pWy2H9bTSV2YeR48rj9NXc0F5/3h8tP
         MmjF73sm9HcLHu/o+Jnqyp1eEP6XmzxHA0bi53TvWQKfuVJp8yFDYtRRya99mF911ZSh
         odyII+R/6ivJTzsrh2YkLhnwKOyUv45PZkMdNfBHzQmTGktFZFfACxECzqxcgG/Fk9z7
         zSiQ==
X-Gm-Message-State: AOAM533lxVp6uUhf0ZSS7C1wQ8thheb9i+fKz4fe03zfNHojLEJxW67Q
        eZOqRlCPUG3VtyZKB2MS1u8=
X-Google-Smtp-Source: ABdhPJx7SWVeUeNkKBMWIIRgTHi64q6QnhcSCEaMRHB/3+ctXieYbb2h96WFHkvxDDeEwC3ff20Kxg==
X-Received: by 2002:a4a:655e:: with SMTP id z30mr17741945oog.16.1623766858828;
        Tue, 15 Jun 2021 07:20:58 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i15sm4183140ots.39.2021.06.15.07.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 07:20:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 15 Jun 2021 07:20:56 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/84] 5.4.126-rc1 review
Message-ID: <20210615142056.GE958005@roeck-us.net>
References: <20210614102646.341387537@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 12:26:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.126 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 428 pass: 428 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
