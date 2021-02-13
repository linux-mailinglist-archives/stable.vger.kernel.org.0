Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD8131A9B9
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 04:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbhBMDQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 22:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhBMDQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 22:16:09 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316C0C061574;
        Fri, 12 Feb 2021 19:15:29 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id u8so1216837ior.13;
        Fri, 12 Feb 2021 19:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=P68Xlwkd2VFwZrNBdT3Q6/hwS7cc99fB0MhjS7aD+k0=;
        b=I/GN3F/FKIZewmeCtfk5wZLuHyY9TVE7Lf6nwUJzZg66dMRlxbdrHYxHhCARXHNnuu
         8ql8tFmnOueXbuW/8ci7DvwKqNYY0XfBkRU4JSRjwiHkk9G9SRwoCFE5gy94a9EoRJRW
         LW5ac/jDZ6D/ZNck+wy7+idXnNQSYweheznpaiNlMLzPXrrI9eALNTK6eUOCSZkTWTfB
         OW9l//0U+tao60TZe909Zul4YjkiAySOT6GiQwX2dyv0ARbsVs0iKK1BzIzXVBEzwo4c
         3q/P4YjkzMw+uoiu94uglWNsCVEaBy1XKeP7hAQbGyr2cVEBO+8nPq1ZuXhhtwyadbrP
         PDcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=P68Xlwkd2VFwZrNBdT3Q6/hwS7cc99fB0MhjS7aD+k0=;
        b=gmSAkVUUgQaqrgZjSR3kQfw2og2YyCrIAaYKrIlON+U2G421XEP92JaTM+28a6vMyN
         SNcIstZLMQYYD5hOIzw2Go/3Kekzfdat7HL+WZyvhDnp18+NOFcKWo690Xluuzfq+mgu
         6gsR8S18HK7geQOpb8MTIp0HI2K6BNfWLDOUVHyPgoOL7fU87nMx5DHmnjEogizyfunB
         sFWVNNbLMGsKMisfAXeIMnZqpKVI4QlqU8x260z3npmy0wDOQNN7j4129t13kbY4kdrS
         8xp5lY2QMx8CiIPkFVo+jvf/Qs9TezUi/TkL53RzHIMSBQ6Wd6QHvEUYOKMgWigWYJBh
         ruEA==
X-Gm-Message-State: AOAM530WnxSK6/RguXSMpXg65DCQbXU6Zn1tdrzw5pW/kFA/4UUQEyH2
        JNR8VM6KXmOO9GOJrCMkMBk=
X-Google-Smtp-Source: ABdhPJxeklg9F2sBdA0h24DHNx5mzPxQiL2bKCfAUL0LFNuCM8+d5jLgSdakukQc4iUKeDlQ9RlPbA==
X-Received: by 2002:a5e:a816:: with SMTP id c22mr4664659ioa.199.1613186128336;
        Fri, 12 Feb 2021 19:15:28 -0800 (PST)
Received: from book ([2601:445:8200:6c90::d0e5])
        by smtp.gmail.com with ESMTPSA id b1sm5114967iob.42.2021.02.12.19.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 19:15:27 -0800 (PST)
Date:   Fri, 12 Feb 2021 21:15:25 -0600
From:   Ross Schmidt <ross.schm.dev@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/27] 4.19.176-rc2 review
Message-ID: <20210213031525.GA7927@book>
References: <20210212074240.963766197@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212074240.963766197@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 12, 2021 at 08:55:04AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.176 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>

Compiled and booted with no regressions on x86_64.

Tested-by: Ross Schmidt <ross.schm.dev@gmail.com>


thanks,

Ross
