Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7BE3A7B13
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 11:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhFOJtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 05:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbhFOJtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 05:49:42 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59054C0613A2;
        Tue, 15 Jun 2021 02:47:36 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id c18-20020a05600c0ad2b02901cee262e45fso716923wmr.4;
        Tue, 15 Jun 2021 02:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5s24YduTPQUCOlxF8wsHy3Qgh5jZvUWHVZCaONw0MXE=;
        b=rcT+h6YEzv6+ZfD/x+7fkZ9RckGCNngfqbYj+Rn5SGBIVOw28om/HcysaYQGqsaB2o
         jSsG6R4o81C2V4tDlTORc4eGjA/0yBKFDyxSuZ1eooADK2i81XPJ14iW0hLob0IGU98l
         Jqv+P2hGkE9CMB4Vf7WUrTkmuMUeg35tNstIHDIeK11bpcUWXhqqe8ErONpwxhyR7ODD
         MeHesFDBhnZYlDp75xwWwvospX6XQUSyuEte09YhfxR29awtK28oqqLMihz9ZSFDwwxR
         7voTSJVqzGnkREstpsIcaofKzygIlAp4CScWQdXuiLOQqQKzcnbkvrhYq02+9aYeR1u7
         brpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5s24YduTPQUCOlxF8wsHy3Qgh5jZvUWHVZCaONw0MXE=;
        b=aJhgWN3a8mZJ99Vk+9HYvYkTdmIz6b3nDL2Xl7m09312o4Gc4IEgZloQUrG/mGyavA
         xFqny+i+0ANrfsJV3w0n5RqEzkcZQO+RaG+y/7qE0ITV4Y93Gt6gZi5hOLf4TU4MwRz4
         W6wJu/W4DF5IkIN8q0kKfxGxG7rRNBVm99kUKhtmfv0mZvJCknaxM+1LWVY7POJso1oi
         nRdUzBGSUDCE0cQZ0C4l1ALi/J+O5r94k6shDet72h1aHb87MJrM9VJgqKxpF6d9thSz
         C3buRZSEHL3VwrHxLAydqPt735NZpWLHaMffpixa8oO5yKWR/m4BEwn54Qq/CvEWtNlk
         STQQ==
X-Gm-Message-State: AOAM532JR9bUqgQU08GKSM8rhSD54Js773bqmhS79IWRO8qo/Gn1vDcM
        K/VPQW6+DnsAR7KmotGRcDs=
X-Google-Smtp-Source: ABdhPJyAVU4OhYEeBq4wo1CAtyDD0Puj3qN9LA1zJ49lNIXdzVPret9b7N6TKWXbcJB4rjXbseyP7Q==
X-Received: by 2002:a05:600c:350a:: with SMTP id h10mr21635367wmq.164.1623750454934;
        Tue, 15 Jun 2021 02:47:34 -0700 (PDT)
Received: from debian (host-84-13-31-66.opaltelecom.net. [84.13.31.66])
        by smtp.gmail.com with ESMTPSA id l13sm19096051wrz.34.2021.06.15.02.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 02:47:34 -0700 (PDT)
Date:   Tue, 15 Jun 2021 10:47:32 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/67] 4.19.195-rc1 review
Message-ID: <YMh3NP2af96pLMXy@debian>
References: <20210614102643.797691914@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614102643.797691914@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jun 14, 2021 at 12:26:43PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.195 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210523): 63 configs -> no failure
arm (gcc version 11.1.1 20210523): 116 configs -> no new failure
arm64 (gcc version 11.1.1 20210523): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

