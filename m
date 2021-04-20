Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D26364F61
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 02:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhDTAS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 20:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbhDTAS2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 20:18:28 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F4BC06174A;
        Mon, 19 Apr 2021 17:17:58 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id x20so3536955oix.10;
        Mon, 19 Apr 2021 17:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sMHGIRFY8gaZlOrvoWqYXurdQuVq8PePiazVv9mVuaM=;
        b=rm90CcYGCoZ3YOEJHoxIrCF3PVotlPIuhDhosHAI/PD/9N586USYzhEjC4AeZuykAz
         ms2co/HQKWoVo2HZ81atX4lTHWewTUkAKg4lytbQn6HxThQQJvmb/Pc+NKe7ayZsXjJJ
         bc5IaLZIcnb0mwMmOFeBabc/qv5+TbyuDrJpWTXVzyYRJPGIv+iupYczotJ2633rmPSf
         kgUJaKP+MwoeftKU05USJpRD9x1+ThoK9EDtl6+YoD6ifVRasAjip2AYXVr1MejNozF0
         HtlSlUuDLUbu0NmWVeUQ5y6XbTUm1jIdoFHGdsoUSVOTfbtewbReqQSfOHUW5cE8LvMy
         ZVsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=sMHGIRFY8gaZlOrvoWqYXurdQuVq8PePiazVv9mVuaM=;
        b=ptg5UFFF4WG38UlZJ+DIRzaWUrtU9aN0Qp+4/kO6pcOAcjvPBx1VLKiDldSJq0vtnK
         9IT/lbcOCtv+ie63mmzZSutcTDq3A4WXvEjAMQlagZW68NIS6aP1w0GbQ8KvnKPXq7SH
         NhiAEQfHOFJtqqIyo3yWJDl/XPQ+x6Q19txPYyAetsMMsF2y2M2VTLGAQ+GAEvWxsj9h
         c9/F6jr50q1sKG4dIfbUKhfhwTUNb2vBFCgiVXK2sAklXKo4/s1kvxT9GdvEicglwqEd
         TJbpvRN+L3W+ufZtQTs6LCRd8+FOwZkAxNJsMJ8srcIXhrcnjL9BzxyzQQn2hqqdKRQ6
         NdIw==
X-Gm-Message-State: AOAM533uqkBxUzLqOw1PZoN7NGTd+wVjLmJ+26O6PqYqp9wOmlRwVute
        gdQ1zbXuI+OJdTfXlkxY/cMfhICtJKw=
X-Google-Smtp-Source: ABdhPJzt7YfMy8FYfcXaVRUEAoulvMCS2aX6VAhy3+GhByYgF4FdQnGR+VAyagW913pn9a6RALPlZg==
X-Received: by 2002:a54:4501:: with SMTP id l1mr1197480oil.157.1618877877709;
        Mon, 19 Apr 2021 17:17:57 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f65sm3876799otb.11.2021.04.19.17.17.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 19 Apr 2021 17:17:57 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 19 Apr 2021 17:17:55 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/73] 5.4.114-rc1 review
Message-ID: <20210420001755.GA218430@roeck-us.net>
References: <20210419130523.802169214@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021 at 03:05:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.114 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 433 pass: 433 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
