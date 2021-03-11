Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F93336AF5
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 05:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhCKEFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 23:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhCKEFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 23:05:37 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFB7C061574;
        Wed, 10 Mar 2021 20:05:37 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id i18so17700883ilq.13;
        Wed, 10 Mar 2021 20:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xv3vIouzKJJEYqeI0ValNXTX835yLEerDnUvXGiyPDw=;
        b=kT0+PI2e1pZE/xrIooFll7FGpFEdmInj0ZWm+Rceh/VDq2+JSmrC4nvndkIMiS+RZj
         RwL1wSdLbZmDujqEVBRpgGl2It1mlh+xyQUMzGHTbNrO6MZdYpFSDvR1CeX/2sqqaiMM
         xuiS9YC/IoMxIBF+31cLVm+qH5g6II+wKv8wGxr5h71K9l8a8nI1azU2azV6wadLcK9n
         T6AREd4Yd3jMoWp3b98vP/NAdZ9ExALL3LKLc4S8NsUqw7OHsBPYQtcmGEAaMn0Pjfhn
         ZkG4VCibWVxtPdCe6GOxIwH5wDFekhwyD/zlOvWGWG7PLNKkvuOsvZpMPBEEpooEz97G
         DI6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xv3vIouzKJJEYqeI0ValNXTX835yLEerDnUvXGiyPDw=;
        b=n5KaMaEinB/kN1hrZOTdAwcYlIfje4jJehBtVunSX0TDnIF7x8uHntmkpQTNEfkXjT
         nDmldfe2ZPUydZLzwER+cZ5xI+XAlpqtvuYlnzyrQ9Jh4hh2suscI9omnrWyeUA48jrI
         4g02Q88aMfmuDjnCWwcUB4tYP+8v6KgwCWWXJSsDI2iTtw9dezVRtIBxgwIZUgNzHiE8
         f0FGsbf85lqKOTMs2prrzk02sL5z4s//fqrBWAG28PufbuRcavRqPMGljhxprEGeuwPC
         DSuuD7IdcNGMqGbg/q6NoH+nbn4XhBbq151XQO2s3yzIZFwoUDc6Y7uDgLipiGzwzg78
         uWJA==
X-Gm-Message-State: AOAM532Q+YWCo4ix+E23Alr1hD1XgCEBkkEMeuxwVO3SxF5J55MA/fM2
        GS6TN77WYOm9WZZcWshhULA=
X-Google-Smtp-Source: ABdhPJxPKBJs2HrWLxX75ZdRJeFrXf8A07wiTZJ3/LFBTVgi/n/L6DSznRXL1T9zQbB1F3ftt21Z4A==
X-Received: by 2002:a05:6e02:1068:: with SMTP id q8mr5587917ilj.57.1615435536626;
        Wed, 10 Mar 2021 20:05:36 -0800 (PST)
Received: from book ([2601:445:8200:6c90::4210])
        by smtp.gmail.com with ESMTPSA id d12sm675172ila.71.2021.03.10.20.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 20:05:36 -0800 (PST)
Date:   Wed, 10 Mar 2021 22:05:34 -0600
From:   Ross Schmidt <ross.schm.dev@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/24] 5.4.105-rc1 review
Message-ID: <20210311040534.GB7061@book>
References: <20210310132320.550932445@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310132320.550932445@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 02:24:12PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.4.105 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>

Compiled and booted with no regressions on x86_64.

Tested-by: Ross Schmidt <ross.schm.dev@gmail.com>


thanks,

Ross
