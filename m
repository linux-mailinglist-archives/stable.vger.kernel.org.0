Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D2E267736
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 04:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725562AbgILCTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 22:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgILCTR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 22:19:17 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F15C061573;
        Fri, 11 Sep 2020 19:19:14 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id g10so9953810otq.9;
        Fri, 11 Sep 2020 19:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Jc/kYUiVYyrhvxpJ+DFw3vb2aJvbu3hBgwtEJnsB20E=;
        b=uvTZS1Q24sUAwO97bnu5dgTkuw3yE1pTld2aCvT4A6WvKpMOsc3CizaOCI12akozr/
         SRmTYPM3Cv3aonNARGvC9ACRRaYOXlGz3ShUfHMGjZSjicaCkdBK08GG6Io6EJY7GJVt
         l+d4Jl7X3KswynacUDNNEOLUBwKYb+u5cSP9SPPH4zDv2yY0Q35qmgqae879CJAd7HSP
         6u8Ln4XztW+HpjkPANUabgKPmIJTmXSRnP1iJ45dr1LImH2+sqqSrXhgf/E/hUGgfzA5
         X7lJM0lRADCjp1f5N8qZJB1ru1RYWLgfYjF1Cj6rZgHNv6IWxVzRrsuajCCg+zFhZKw2
         M1Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Jc/kYUiVYyrhvxpJ+DFw3vb2aJvbu3hBgwtEJnsB20E=;
        b=KksQbbyUrlH1f1HBVVq5TY7uDGhCpASI39a4QtY1AaqWQfVWksTRSVNwOntD7kpz5a
         aCEsgKAQ4xIgSu+HPY7nXr5CHYeCqtqdUnZliNPmfNKAuZ1BWQX+9OjYflB9aM7SxN2Z
         R3z2o+8Zak4x2pODmR9JPh0cFukKBRD7zBW81zj9gCPqsHWafgpvKbZU4oPR32/SNabA
         nur/bn58MC0OQ29gIeCu0hpamQV7o2rMQhD2kT0t1TxSyUdXRTsjEAVliJNqOtq+vysW
         2/k3mOo4RUu6Dd/B4p6qCq12NYD+ejZe61bhwANVY5xVNrl1gF7RbWmCUIFh/Atdvwub
         CHXw==
X-Gm-Message-State: AOAM532sEhwf0fW1bHkDmq3v6i8SXR5St1Cao25MD/Vc/YZSI4AnnPr6
        LwuSOJssqYa7jPsI/fwYccI=
X-Google-Smtp-Source: ABdhPJyj11nlZ8D8jnF3gt+mWR2GdTkEA9WV/u/Q6L7QHVeQMHSzJoPcXRZMeip1jK43YUjLNFpPFg==
X-Received: by 2002:a9d:6498:: with SMTP id g24mr3038740otl.179.1599877154171;
        Fri, 11 Sep 2020 19:19:14 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r33sm675567ooi.48.2020.09.11.19.19.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 11 Sep 2020 19:19:13 -0700 (PDT)
Date:   Fri, 11 Sep 2020 19:19:12 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/16] 5.8.9-rc1 review
Message-ID: <20200912021912.GD50655@roeck-us.net>
References: <20200911122459.585735377@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911122459.585735377@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 11, 2020 at 02:47:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.9 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 13 Sep 2020 12:24:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
