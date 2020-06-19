Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E218F201ECA
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 01:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgFSXt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 19:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgFSXt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 19:49:27 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A02C06174E;
        Fri, 19 Jun 2020 16:49:26 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id n2so4574235pld.13;
        Fri, 19 Jun 2020 16:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LNZcBc6AW3KgNqbf37xC8/2tkS3zJNqwIFIvBJVDMGE=;
        b=OnYQH3fwACwnA+RfZ9oOpK5co8zLOr47b9wqYhFi8sghm7fPLm090bRFSRQ4yRM/B8
         BoxPxZ68z5Cktyiwn1hDqcppHQPihLS1KQx63UYNOv97ShtSCtzxhmsBbA7GsdCxb4Uy
         BgUJomTy0oM4gPcRlarDh54Vg860hTTNrxXzIs0pmniJIG8m9gfIQWBrc0V9tvU7mRB+
         QhQ9KStjRofz8C8OdbF+aX2U7bkp0WviBeZOf1/WgXQEa1+TEOTHIw8RLkVxZ5ORzhMu
         gPRrJvEpErSVQuBOg6RNxLqVrkkC9a3y9b+LG8Hxz4N9fzyy/jFHVerB2EVvjM3pzgJk
         WRPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=LNZcBc6AW3KgNqbf37xC8/2tkS3zJNqwIFIvBJVDMGE=;
        b=ZR3QLSLUow1O6RrCr5R/P3QM+vmSDGfWvXbTITDIOya73NYBPviFDRYXNLvGSUYAPE
         O4pLE3Fva63FUHtciKMz/4su0BR364HTPj4LGiTYG78h6qAa3M/QOYygZSCYBzO2SwG9
         vaIjnCxlpd4ufero2PE/Zz6XKAo7pcaOWhrtb9DY8tCNaGgbzTjd8DwWf5Maze2OL4ux
         7DQfpooa0LjVEwQSHPkOcPqPCbqRZqh3MkhmCr24EnmrSNETQIH+NP/RZRgsMUXYz0fX
         mNaEqKavGFDlhMTlJ3TEriWJBHty9OcMms+VNrB7gTa+VlDn6+6M9yfVxmS+CP7axkjX
         Xk1A==
X-Gm-Message-State: AOAM533UpTia21B1+An98JDnF173TGtPxzfPfHsOIRpt8CGnO0YL87i9
        tzVg377Xq/H8O8ykQZAB7KU=
X-Google-Smtp-Source: ABdhPJwUv4c+bjBy5FjddzBlmR2PCHE+1JtOEytJNYOkx60Dveq7sqIDGJrOq/ZQC8slQyq8wVJWSg==
X-Received: by 2002:a17:902:c206:: with SMTP id 6mr8079530pll.133.1592610565592;
        Fri, 19 Jun 2020 16:49:25 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q22sm6716750pfg.192.2020.06.19.16.49.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Jun 2020 16:49:25 -0700 (PDT)
Date:   Fri, 19 Jun 2020 16:49:24 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/261] 5.4.48-rc1 review
Message-ID: <20200619234924.GE153942@roeck-us.net>
References: <20200619141649.878808811@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 04:30:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.48 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Jun 2020 14:15:50 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 146 fail: 11
Failed builds:
	<most mips>
Qemu test results:
	total: 429 pass: 370 fail: 59
Failed tests:
	<all mips>

arch/mips/mm/dma-noncoherent.c: In function 'cpu_needs_post_dma_flush':
arch/mips/mm/dma-noncoherent.c:36:7: error: 'CPU_LOONGSON2EF' undeclared

Guenter
