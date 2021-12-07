Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6EF46C4BF
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 21:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236388AbhLGUn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 15:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbhLGUnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 15:43:25 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDF2C061574;
        Tue,  7 Dec 2021 12:39:55 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id bk14so851150oib.7;
        Tue, 07 Dec 2021 12:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cznJ9waA+9Qmfq5qNSYk6zSOKOMxyCRfyUh4OLdtMZQ=;
        b=P5yetQ7b0kx3/aj7ow2+O3b3351zXDGqRMXgs7l9RINI4mbmjzpjls3jPYCySMxg1d
         LSEdIoRbHnSjWHwLuQphX/9UOdc+GnXP0ZG91+BDq7QJ3fgzWuKhEA4j9XaXjhUW23+u
         4ZoZl3eOy2NQiSHb1S8rPDQ3zjt5kL2uqqe7u4qACjhj4nqUp8BYfnfS/Jn2smfu4iBk
         Riei5oLBiaG/2zELIAZS8ZKH2Z0lo8/96iYGOAf10LYal8hsh0ACI6ASrX7NyTHmtU3A
         BKAW9xalyTuq+TxvdHxqra0EwxYSThBkw3qerE47I1Y3dfkPEcXlanOGqk03wDomhzD8
         /1mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=cznJ9waA+9Qmfq5qNSYk6zSOKOMxyCRfyUh4OLdtMZQ=;
        b=L5mQDQlMRFyOu9yHHqKDZCHbg0xRAPhlt7HF2xlIE07pjGqPwi2C325JIVtWGwRGTD
         lmmvOlz2tvdc42ucbRRD+DGgpoUBVX1RUZ5X//FqoR5EF4Heq1Dg0tCRTRudFGvz8sDv
         7wPTrV+jGdPGYx8136/WTonV7hpxZbPTeQ2cOWF/vCJwTPRJ2b5xjMo9iz9/xziUaVvh
         apmafoAfW6Xwl2ViYIbyVp9SR04TOFs0OnZdBfUbL1LVIKlWX1XhIjgyMqfNliYjP5xD
         CKsrmRoKOcWe+mfRSP8HOF8cujZwitL7fJznxKc9oc2Msh2EfXRFzazK9stSlsDiBA+e
         Sukg==
X-Gm-Message-State: AOAM531udnG7xGwKpJfc9gIeSk9aEKtWKLiDVraUWCeKc3jXf9dNpW1q
        E8REmOVDWjzoxtsuDQJebBY=
X-Google-Smtp-Source: ABdhPJwR6up79sxObT1I6OEEQWcg1cMLRVvn43SeSKmNQ6giStwvWaxlUr36pLGWyeMmCGpw0KRzoQ==
X-Received: by 2002:aca:5ac6:: with SMTP id o189mr7384738oib.150.1638909594687;
        Tue, 07 Dec 2021 12:39:54 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 111sm123113otu.55.2021.12.07.12.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 12:39:54 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 7 Dec 2021 12:39:52 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/52] 4.4.294-rc1 review
Message-ID: <20211207203952.GA2091648@roeck-us.net>
References: <20211206145547.892668902@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206145547.892668902@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 06, 2021 at 03:55:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.294 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 341 pass: 341 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
