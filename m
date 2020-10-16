Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C583B290C02
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 21:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409086AbgJPTB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 15:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409074AbgJPTB0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 15:01:26 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82DEC061755;
        Fri, 16 Oct 2020 12:01:24 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id s81so3540424oie.13;
        Fri, 16 Oct 2020 12:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=npejH+5/z27ofQgajkfOsXVttdCHfcaNma/RAZyqzOI=;
        b=vWbCDBqPFFU02rv/WNjppoDhy+wPT4yGQXP63JkmhumfnknalsZ3nEM63nZ189BFPh
         7SzBcPqG1UiaVNXmqQmr+hnp0zwuNJyekaDwCS3VvRQJoFTGk3/7tuM95osPcsR5JtRi
         2p/c7FML47kK0llmeGf2RXWj+pBZLHr3te3OMm+5hdLYjILLcR0pXCBfkXnWTx28oODQ
         BWhj6DLXfPAZxQ7oDFdeautgnt/7bC5sUqLpaiWkygozDQ3j3bAjcDbEcE+0jfvxW1go
         TWay9Dm1Es04w5pNEi3ZHSJ8784LFXwLHX3RUHy903M8pxDEW8HBlgMOTh2BVJEdEG+Q
         zOFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=npejH+5/z27ofQgajkfOsXVttdCHfcaNma/RAZyqzOI=;
        b=hVg8d7nOlSfG22lvA1HIvLep10hqxCCejIE+OMAv4D7G1SE/2XFQBsVc5vSYTpH3gN
         BkmVbr6MuS4jMH+NVJWwzXhudytBDAN20WqBfpBf1oVKQzrCsZ/N/00VgVAUapUo+h/A
         KyqWu/0cwl/+XLkdq0gUC9TGXmwqMvY0A8BV76xY9ctk4fW2CR5IN7iJRWN+VpS2Xk5M
         fSi20gnRTORObGol71w7PHWXRUWYK42cQ4J+vX+q1Jx7bsrKBd6zu/wBD4qFiVgltRXs
         dEjNUXZbhhWXjpMik+L5LxScGAALJf8EUO1GjutX1bRP1p3SY36RVOCTV1SytOU1I2Kx
         AeGQ==
X-Gm-Message-State: AOAM533lYOdU5qcDBufuOZ4mRSKw7fcZnyNYRAN79xy1ncrs/kNePde+
        LcYo6hzYfD5SZ+MHll3n3/s=
X-Google-Smtp-Source: ABdhPJwH53ytOBRelPSfJlUm3KhDII6O+HqbiHH1J3skqxTobHSohRgtPczJSwcYnF9X6nXIUT9PGQ==
X-Received: by 2002:aca:ad10:: with SMTP id w16mr3562706oie.83.1602874884132;
        Fri, 16 Oct 2020 12:01:24 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j34sm1204675otc.15.2020.10.16.12.01.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 16 Oct 2020 12:01:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 16 Oct 2020 12:01:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/18] 4.14.202-rc1 review
Message-ID: <20201016190122.GC32893@roeck-us.net>
References: <20201016090437.265805669@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016090437.265805669@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 11:07:10AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.202 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 408 pass: 408 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
