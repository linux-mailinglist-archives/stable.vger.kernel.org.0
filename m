Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F34322162
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 22:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhBVV25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 16:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbhBVV2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 16:28:49 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7667DC061786;
        Mon, 22 Feb 2021 13:28:09 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id d20so15514631oiw.10;
        Mon, 22 Feb 2021 13:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IGC+hojrbhCNtlCslV1ZdhGScKiSKA8taFGbSyWTnHw=;
        b=k4o+mOzvHOIIf+vN9IpVHz0FJ03VEnCsIHWnSsOqzUAZrCQPVqOEvVq5d8PHxdPTwq
         ivJP9d5ujucDfEC2HGwXcoF8jJCUkAg7Cu9BIgsUYa9Lt8NwIRd2DjlKjjxslImCzN4c
         nlCIjv0Xoo7dmH6PbSrpmEglgHnD11VG3ZBZDdpzaBIL1b7LrDk70LuA8Uyix5xrStYY
         EjmU+3uDvx2F1swnfUoph3bh64MaY2Nv4W1riMJcEWgJQgtagqgDJcKy3EFekH1ddvG5
         wVUalbEyleyOvqS6O8zzSQI0BAE526Iy7s+y9HbKGcu4ZGTHdLlQHp7BrKzZMZAogKGm
         3JhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=IGC+hojrbhCNtlCslV1ZdhGScKiSKA8taFGbSyWTnHw=;
        b=CCciDLv6l7YEGHnKTfOQ4YuT/jebguek8Ke6fq1TPJAZnXn8KetpbOQ+GABoDXa06a
         EG1kLBuOX/zUyd6R80wY0jwgRc8LTVQbqwZbXcOfrd+KtwLovjE0eTSmRfZh52vGZonj
         0XZe01UPqQHQG0P4UH6Sdy2yd7YpUpf+kuBycou7vd6nLkJvDzHmiS35g0eqX8G2DdaS
         idBI7N1DjXALjn0pGml8+GY34NrO2zgeUCcd7dHtFuwMafBeERTJLggjYo95g0IBi1NT
         G00chm3yGOZ1dESEqD/moQuGZaJhj2WqzAwBtoO7rOeKdsuEKZxhHl1kpVTComDr0s4D
         fReg==
X-Gm-Message-State: AOAM532WAJK08d43GGFdam3r5GP1laBfVdcYy7fH9din5i/X0Qfg4LPL
        gSNH62WJMqjd+62qCwH/Hss=
X-Google-Smtp-Source: ABdhPJxGD524hv3mNg6gTt5UXbU1OaUpcwfWb4pa/KPFxqyl3TEjCkaeM4PyOxzhQ6nEpb6RWN1Luw==
X-Received: by 2002:a54:4499:: with SMTP id v25mr17020063oiv.100.1614029288986;
        Mon, 22 Feb 2021 13:28:08 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 69sm3889441otc.76.2021.02.22.13.28.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Feb 2021 13:28:08 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 22 Feb 2021 13:28:07 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/50] 4.19.177-rc1 review
Message-ID: <20210222212807.GD98612@roeck-us.net>
References: <20210222121019.925481519@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222121019.925481519@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 01:12:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.177 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 420 pass: 420 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
