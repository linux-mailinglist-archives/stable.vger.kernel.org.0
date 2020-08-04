Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8FE23BFAE
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 21:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgHDTYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 15:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgHDTYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 15:24:20 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F70C06174A;
        Tue,  4 Aug 2020 12:24:20 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t11so3958139plr.5;
        Tue, 04 Aug 2020 12:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iq2aYfhJ5sJs77/hPx3FMr3YTRxCtfhdhT9zx8Qv3yg=;
        b=h09FAqNMyBUWkeGKmzOTjFfMGvrbMg7upPYBms7YkhKhtHSVTbqSDZEMdcJZv1KW+9
         iWXERt4ej+FOpf2SolwJ+cG61NAxrtv+fUIgk0ltZlTDkQWdLxWwxfKbJ065jYo716SO
         WK53JIRHx8poRXi7C3Q3GoYI6HF7Rhcn1Xzaf+yfJ1/jVlhyg+OtJFifmZl9MZrEdES6
         6vNUaNgnEpm/IfEZ8zGjoDOH2DfOF60PeC2bOXK+pRP2OJB3orPpjVzzF9BsoKdPXxNq
         PzXvEqy8s2fkMjgFjITHL/3ehl8+caVRiYDeRD6t/KpHbyd3lNTddmpFYxRxm6+rAElv
         vQBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=iq2aYfhJ5sJs77/hPx3FMr3YTRxCtfhdhT9zx8Qv3yg=;
        b=XFAz19qwdYMSuZ7r0yu3hhdoazPtdi8Lrukh8gg5+buhll0pRO8ZyMlboy4IzPCbaw
         KJYkhdZ6Hpd2GLb+Rykv28l9nW2+v2ooPiSCG/aSPZjgIo4CWjy1mMBJkNgtP23ZYnSI
         eNHL58NDlEB6wSF+l1Jj3jDif5ViqwmxsWD4ezT9r8GzJZRr6WYua8U2DwyT/a00Luo/
         EV2o8GXjDX/qLzr/otULyi5SepR6uyodC79r9bMC1Nb54bOofSY/avBycFCA0COth1mY
         FKQ7OJAfBum4T3ZhLfugOrrkanO2lD2u/woMCbix/rnxhkTOM3VsiTZPaOrfxjYrOBJS
         jvaw==
X-Gm-Message-State: AOAM5320iaCUSMAqjS7v4Jv9zZcn0XRISh67K2KYEuRBYMrVHewUXKY5
        YhDReGFDJjvLUIRRo2TPMdU=
X-Google-Smtp-Source: ABdhPJx4gGcSVdoJWOaGdjTpS0w0DViuNaRPZd2s4fR9qCzvP9W0eOOB3lzkr1lpkBxDhCiXqr/B2g==
X-Received: by 2002:a17:90a:884:: with SMTP id v4mr5493506pjc.27.1596569059764;
        Tue, 04 Aug 2020 12:24:19 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x6sm18420473pfd.53.2020.08.04.12.24.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Aug 2020 12:24:19 -0700 (PDT)
Date:   Tue, 4 Aug 2020 12:24:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/116] 5.7.13-rc3 review
Message-ID: <20200804192418.GD186129@roeck-us.net>
References: <20200804085233.484875373@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804085233.484875373@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 04, 2020 at 10:53:53AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.13 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Aug 2020 08:51:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Guenter
