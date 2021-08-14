Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB273EC466
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 20:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238997AbhHNSRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 14:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238989AbhHNSRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 14:17:04 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BBFC061764;
        Sat, 14 Aug 2021 11:16:36 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id r19-20020a0568301353b029050aa53c3801so16043257otq.2;
        Sat, 14 Aug 2021 11:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6Elw94D5PlXVQU7Hq+hlZOaMuFkxOR0XFqmHqmifax8=;
        b=JO0yo1a/ThG5UH4KK92KPBp8AjmxWUtD6HzgxhSrYsnmESpMFzZZ4shAUli8MCwK3Y
         +ZyouPHvoBbCNIwmLHPM/12GbrqxSWOxgNJbSS5aftRFGli2VmKkjHatrhasVNpNf+Lm
         gETqDSd6a6zCQE8EJsFfb2IbzZIdvf8QFMXNgNUe6lJNQgn3gadAGx4gV1B602JDpT7j
         y6huUeWHCViReYGwyaTpu7CYzlCHJpQBcXYOqscUTEFMMrgSOSREuRPEmdgqzQfHOyhR
         wOvn6naBdCBEV60pNXpH5r0Do+IwIijSya1dgOtCjNB+3nj5zeLUaQJtVA0XpXcp6MeG
         8FlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=6Elw94D5PlXVQU7Hq+hlZOaMuFkxOR0XFqmHqmifax8=;
        b=H1FUKQ5LbtaLLFfLsclL/6ynCGX3ImqtpQQhp0a11Z/vnECDu3aKN+38MumK4e5fy0
         xYibXnGO4OND8ylLf0gbfZna9noh2yT6HCC4IeW+sIg9+0+bkh6XObuNvK4qw9P/Gxp2
         oljSWXkKCl9DycNWSAsbv/Bor07r57wOUQ/CO7Bf+DObWXvJDBjJ/wk0Grm6K5OVOU0F
         TK0zKpoNpNRGTFt9A69yKg5IHrBBELw2Rc3sd8C13QU6ukr9FvhuMw4uiK6c//XtEENy
         CwcXGIQCJaN2OcAxc6crEcp+eh5HG2AxaCI2f93bfZ8GEGtvwWKdf90YXvmFMe6BVT0A
         N9aA==
X-Gm-Message-State: AOAM532BoRLTnF08GHQCCYyRDlYon9IAwbej9TXN/j37RSQOTQB4C7Ov
        NQZWzuaeg7ZSuF2CIDIyGYw=
X-Google-Smtp-Source: ABdhPJx2NVe2Scg6pbZozR1PkCvtuBpaDCKGAWT7XzysOiA/Syz60oIBYC8aaVttnaNcw2W4lrNCAQ==
X-Received: by 2002:a05:6830:110a:: with SMTP id w10mr2318543otq.291.1628964995612;
        Sat, 14 Aug 2021 11:16:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m16sm1020836oop.3.2021.08.14.11.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 11:16:35 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 14 Aug 2021 11:16:34 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 0/8] 5.13.11-rc1 review
Message-ID: <20210814181634.GF2785521@roeck-us.net>
References: <20210813150520.090373732@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813150520.090373732@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 13, 2021 at 05:07:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.11 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
