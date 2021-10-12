Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1383A429B3E
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 04:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhJLCCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 22:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhJLCCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 22:02:03 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F61C061570;
        Mon, 11 Oct 2021 19:00:03 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id o4so27025302oia.10;
        Mon, 11 Oct 2021 19:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w6mpdmR7EBZCOfZJHO7Vh/r1Z7LP8xklLKaomxF2RyQ=;
        b=mny+fObnX9YDUTL9zdcBeHoYAG01YDT3gSmwP0NRCYUrmrpDVINaq+0T77sxui2idX
         y2Y7vzA5AKXuMmFO6VOlB4Iv8OnWNudn0sA/AV2y/Dnz83h+2AZSKUPGBhqWc4bDbJ3g
         OFwWx2jn8amFIhJBO/njWF9i00F6DDzVzOA1QLLjUDEQHy3r9CUFVXwCsth/2yUc9O4l
         e5EB0vqIW+eYjhyfjDPUkHsObLKX68DDh/2J4uaq631TD6wDhsEQMTKMEYMIisinGYFx
         4ejf6aaTxCDoG2aNl2Bh5rfUlhU59/hdUYR+ZncPvClonCXo25mMixkq0ZUwH2HYwcKB
         WbMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=w6mpdmR7EBZCOfZJHO7Vh/r1Z7LP8xklLKaomxF2RyQ=;
        b=8O65J/+MBPWufnDvddvdURXG/SY7ln70/Ato5yd7L+Ap5T5PqY/YzNIiRQZjh5lFN4
         SIFER7vimLISMG/gePKdNV1ONdrlPMaQ0/ySaidIlhKysvJNNlgFCNk1Eu2IRyJOMYbt
         9wvkn5Fyv7FYllqiK1MgdKGOR4guGry6duII/W2QSsB5n6yqEWrrMnFL03ma7/rPsGrn
         S9k4mPd0Tv7HT/Aoyqink/rLrakNXpBqGyDpBrhwo2ogNUk/8nc7VeBVSzmjmf0f8nhm
         RDq3ke7wbQ/0CyZ8cV6iJjf+3Ev7vqX4/DfpxGSVrkA4Gz5Hu8Bjv9/FVHSy8rOGdv79
         KWhg==
X-Gm-Message-State: AOAM530CZhgY1I+IBk0b8kndH3A/KWfos3lm0RYPsShcdqRRjY1mXk4P
        wXccesNq7OrZnFhBOY5rMUGCAFKNUnI=
X-Google-Smtp-Source: ABdhPJxyCzZR6Q4PFqidxPIBzD5jM0lg263pTmPKpyEo6ouY1jHdHRrgLMvb1d4WTehwd3GeAvX7dw==
X-Received: by 2002:a05:6808:180a:: with SMTP id bh10mr1858760oib.6.1634004001479;
        Mon, 11 Oct 2021 19:00:01 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v22sm1496075oot.43.2021.10.11.19.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 19:00:00 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 11 Oct 2021 18:59:59 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/28] 4.19.211-rc1 review
Message-ID: <20211012015959.GA2033605@roeck-us.net>
References: <20211011134640.711218469@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011134640.711218469@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11, 2021 at 03:46:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.211 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Oct 2021 13:46:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 153 fail: 2
Failed builds:
	powerpc:defconfig
	powerpc:allmodconfig
Qemu test results:
	total: 439 pass: 418 fail: 21
Failed tests:
	All pseries, powernv

Failures as already reported.

Guenter
