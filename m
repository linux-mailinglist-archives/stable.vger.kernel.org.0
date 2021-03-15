Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288C333C873
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 22:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbhCOVal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 17:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbhCOVaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 17:30:09 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E544CC06174A;
        Mon, 15 Mar 2021 14:30:08 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id l23-20020a05683004b7b02901b529d1a2fdso5858269otd.8;
        Mon, 15 Mar 2021 14:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XD1i2dEaqkw/v4JPHuHMRkSJt1J0bk0r2JFsMrwwpME=;
        b=YqzODKKol8ozssu4s3lAFUPaetSEcdt2M33nNIEQEYw2ULtFPKsFzglA0URRNIliFU
         UApFVoWqm1/9wd/wMGXrjWhh272TST3YtpdQVIs+2YXZ3dp8Re2jJQqVNkEm5b+ERokh
         t5EHH2enZIq6r7KNQnGjXRbZsyfpPQvMbRaWt5tzT5qLPz8CLBOGFc5lK0raB8oEVxGR
         U59UJDwkXN67nrJnvQYO7sJQixXJ3jHT1PCWtSzSg3H8R/H+J8Hreku1w23Jpg3GUMso
         iKDcPUSAxs3oCpwjkoVjJcMHVCwg2AUYl/6UaGcm7U4J0R68MfeXb+E4Zc9rrNlT+df9
         euhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=XD1i2dEaqkw/v4JPHuHMRkSJt1J0bk0r2JFsMrwwpME=;
        b=dZ954f4dirZ8O4qhgAeAb2EtrYTUgsllk0A4O9U46gEm1raBfOlDb/V5XFK4VoL59T
         5bbieYQqUeUuNr7245uuvcYWCnujFj8uG+sMC5hrhI0bLYJ3cOTO99Cyi6c723mgaaEQ
         oLXqMtOG/RdHVBQRLanMot5ehFftMowC6LGmuj491tmdqXsx9b6BlFWS6gjTUzcK8DKU
         y1GJRwb/QKqO0KZ4GQCXl11eCJ7TVQIfLWlKvjyq6tevbH6l9BsDBfBYf1zo1jPO9KYY
         QO5RHSqetSiFVYl1+5SQeMSYueTky4IICVHIQHqW3d1KfZL2Yp06nDd/k6sGVGUp3tu0
         1ANQ==
X-Gm-Message-State: AOAM532s7PY4YoDx/0JVFvTFtGWRJkI0n5HhsZIzDM60lgyrOJXVIYgj
        4c8jAVYSZVVapc3Uotggg7g=
X-Google-Smtp-Source: ABdhPJzmtVTrXHhPa6fnlgn/97TSJBRSh/7Y29VC2sajDzr3mG/cEFAfPXFujEcs0Av+6o+5eUGSBg==
X-Received: by 2002:a05:6830:1c6e:: with SMTP id s14mr850675otg.17.1615843808432;
        Mon, 15 Mar 2021 14:30:08 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g11sm7393087ots.34.2021.03.15.14.30.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Mar 2021 14:30:08 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 15 Mar 2021 14:30:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/95] 4.14.226-rc1 review
Message-ID: <20210315213006.GC69496@roeck-us.net>
References: <20210315135740.245494252@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 02:56:30PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.14.226 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Mar 2021 13:57:24 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 406 pass: 406 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
