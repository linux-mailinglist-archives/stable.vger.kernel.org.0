Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2962E71A3
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 16:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgL2PMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Dec 2020 10:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbgL2PMT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Dec 2020 10:12:19 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2D6C0613D6;
        Tue, 29 Dec 2020 07:11:39 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id x13so12037037oto.8;
        Tue, 29 Dec 2020 07:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QTh6fA91I++9gcTkOHj/HCKNyVdUA4qhYY29Jc1MRJU=;
        b=P3KNRpDhCfwtKVxmRd9ZwxmhRVFoa3xGofjfO6z7wk4C4LIkLlHzk8xEcjlxmwR3wk
         yEYuhVfv0ANOGZ+Dpqg2SmY6sB4YO/HhVxW+lFjSWx7v9tdUXY7H05yx2CwknJf7X4nJ
         Auv9k1P/ZviZj5xotDA43n5WEYLTMJnGqBWRGLxyHZOoWx/mN9nfyDKKLqixbPWAU79r
         ks3D3NGh+EGWkC4HLpCVH3QUlWPi3bZsEd0icnysa3MYs0ELop4a523orR0/hN5bSwMd
         U6bF4CG6ov2RXZdfOOmlGUzmXUU1nt53r0IVdVudgnzvS5zMWz2gfHiDf+t8Eb4V0cj+
         5kqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=QTh6fA91I++9gcTkOHj/HCKNyVdUA4qhYY29Jc1MRJU=;
        b=ZFiCG9XgMg49T2jNLWuVLhn82z6Sot6UGMRVX3YCBAxK7Era+fDlDfSL0JaZCOTr1I
         ThzAEe+1fLOTEC1cSRDwYM0vQP0qhglqXWDp0rcxHGUcJB6O1pLfVHwU9JE058p1A+la
         Ls8AHt6FKP3c3ZjGzg1OZiltv6AXGzTa9cw0V4JC5hfBIpzF0i1jXz0T4FyQOKtqyYJz
         y6n6UxNDRKgjS35qvqO8szbx8Oku4yJqmFDyL5/jPKjTlpkB6PCoyVOQFuhUPpIqmlbL
         pZUBMOxSgRiXc2gTH/nkniBwXromkCQdUGJ6rUcS0SCeIG0fWrhKvjsPF7eCT0N+jDMa
         EZsw==
X-Gm-Message-State: AOAM532inthX3nlRLV+JtAXs7USRlTyR4yDCFrwh7mhrQTcBYvTBg/eh
        GFdio10+V2PvcsnTkccYiLY=
X-Google-Smtp-Source: ABdhPJyIfyi2tdPx9C1KNzW9Tg57yNztWxCfnB0ny/UInidZoMYFTVqn7qibPhFvkEETRkrFuLRjbA==
X-Received: by 2002:a9d:347:: with SMTP id 65mr37487546otv.312.1609254698898;
        Tue, 29 Dec 2020 07:11:38 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r25sm10104505otp.23.2020.12.29.07.11.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Dec 2020 07:11:38 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 29 Dec 2020 07:11:37 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/450] 5.4.86-rc2 review
Message-ID: <20201229151137.GA49720@roeck-us.net>
References: <20201229103747.123668426@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201229103747.123668426@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 29, 2020 at 11:53:14AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.86 release.
> There are 450 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 31 Dec 2020 10:36:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
