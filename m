Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA64F3F7D17
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 22:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234879AbhHYUZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 16:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234138AbhHYUZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 16:25:20 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC621C061757;
        Wed, 25 Aug 2021 13:24:33 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id p2so1419987oif.1;
        Wed, 25 Aug 2021 13:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kr7WWMVp/ez5T6KP0I3oK+iSWBSnMn4BeL8PnzKeXJE=;
        b=k4qdT79T8s7M5KHsUgAMj5ty60dG82Kspw7e0EdGuOGXjVZt5WQoXZPm+PNoJHERI2
         QBYOj2CKPV2TTQeB20qRMV6+lHjYE5+899ogZm0YGYMVlR+f5euXXoVJ2LQrtzhyAYWM
         zt4TSMqPTANC5YXPKc2hzEpXJI2pNAldOFFVBm2z7OSZTe2jzdy0RG2lGvyOBVyOoCB1
         45ult4Nh2Vsb7RkJrASnb1q56T+cU/wMAO5ZKeRXphwMRCj2b2qtoi9O/NuU8icdpA5M
         OYYGz+s7/Bz726N08jcpOtGTTuTvA5rlCV6WLwkexg187I1eLmhcafV14ijVV/8wXhMG
         gdSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=kr7WWMVp/ez5T6KP0I3oK+iSWBSnMn4BeL8PnzKeXJE=;
        b=MIoOMWLnKhntGv7xoSHkrgzQirFw0L6U/9q6i43DueBRJ+zl9a1c/NAChV+5DZVOPZ
         Y2LKL17bK/HBe8c8g/r5QhJKW4j7W5zt6GcQX2izA67QivietwTCO5f/mkGujBklmZl9
         Y0lve1f5cng9yWpcB0N8666psiVRKybKOAo9bkdFTfoJqOsnUEeJnvGan3S+zIAiLivl
         fUTADe9EmTlvn7x+DhEfIQaNJ6WRT1AhHqL/VvglaS6SyYfnhK9CkigBISFwLfc+pvdO
         +GvnaI72/3ZM3kFsz15dxFL4Etm7oXGgWQ5F8CYTVoJsjFDkTwT0AeFxy8xNQK+5I8Ri
         Xf1w==
X-Gm-Message-State: AOAM531oYJUJfHroBA6hMGL7Up5ahpw9Y/wkUkLueaKOs4cMb2Ue1Ke3
        PINFCLMs5WylEn2AaIh73+4=
X-Google-Smtp-Source: ABdhPJw31iSs/heIScJC/exzy5/aho3nZD57s4Ytqb5R0LVzeF28hNwFg6gm2YfTFYsfx4bvZ5uBFg==
X-Received: by 2002:a05:6808:1384:: with SMTP id c4mr8332420oiw.106.1629923073231;
        Wed, 25 Aug 2021 13:24:33 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z7sm170386oti.65.2021.08.25.13.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 13:24:32 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 25 Aug 2021 13:24:31 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.13 000/127] 5.13.13-rc1 review
Message-ID: <20210825202431.GA432917@roeck-us.net>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 24, 2021 at 12:54:00PM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.13.13 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 26 Aug 2021 04:55:18 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 479 pass: 479 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
