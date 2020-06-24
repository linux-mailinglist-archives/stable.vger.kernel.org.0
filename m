Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB762076FD
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 17:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390902AbgFXPOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 11:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390817AbgFXPOm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 11:14:42 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F98C061573;
        Wed, 24 Jun 2020 08:14:42 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ev7so779784pjb.2;
        Wed, 24 Jun 2020 08:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Yb598zp6uk8AoCmXw2EiWvFbjizpcqsCge2mk6ednSA=;
        b=SxjYXwQgoeJzfloFPTMTo9l0eyasTXa6juGEzWttQcOSyocYKzxinhJWd0+3wTHQu6
         p9dkMGWV4/Gntjmr/6znrDMPHVfx3YQbsF8jyaHkcBkLi7OnuRYxg0pjnHQl1anVXHUy
         s+CKhR2/8/CMhRh/WurLyR1Xdyl/zO1XRMCENCizpqp8iEdwp+o8A5OkkwS43awuG6T9
         2RTvjBvw0VPyoUBV/UiHZJkVDT3GMXgAlxQ6ItBpg1x++exCK0NeFnS0LEIOtHPQCMco
         8dgSMFk0tn6n/DWs27Qj3Xd3fADwC6vjRgtiBVH2STtHLRZqua7nOyi4OAHClgZjGLxF
         EQgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Yb598zp6uk8AoCmXw2EiWvFbjizpcqsCge2mk6ednSA=;
        b=JLFqPJbGK5yZGT1gUSZ/Ea5SiBhHwk6OReMPuTAzUv0no/UDUmKpi5K0IkIfL1vM6G
         trfN0juyyALBTZziIfGEXN7mU6aBqPN3nyspFIAcIAzkdkGRsPwoMT6mz3AMKxJQBvp9
         Hxm53dkw8BL+yBW8LmDUQF8skKNhLu67A4w8X29uN5UI93UQBV3HrU9AKLrB/+h9F+PJ
         dB4I/TuVgTV4TI67Vtmh46rfSbmlf5FzWOcVaIskNOkbQYuoJg48opYe4lmnflWWrtp5
         48qncYK+8nOf5vvYlyHrE6XAASmhma6rdVDYU0u3/FvcemT3qhMQxzBBB9Yd+leOAUdD
         Mh2Q==
X-Gm-Message-State: AOAM533GKOuQzqS/JjQ3xyfsecrASllgSqyWxD6x+5/NP/zrvMhJVre/
        5VgNa3PpM22PrQWICDndiZY=
X-Google-Smtp-Source: ABdhPJwaHPNGk7dWEaymOCvFnNSoQQiUsYsmaRogq1VPkAPgfSmGPxlRnu2NqjaiIIDDP3/nFAxq1A==
X-Received: by 2002:a17:90a:c905:: with SMTP id v5mr29041050pjt.39.1593011682423;
        Wed, 24 Jun 2020 08:14:42 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d7sm20417925pfh.78.2020.06.24.08.14.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Jun 2020 08:14:41 -0700 (PDT)
Date:   Wed, 24 Jun 2020 08:14:41 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/474] 5.7.6-rc2 review
Message-ID: <20200624151440.GD54105@roeck-us.net>
References: <20200624055938.609070954@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624055938.609070954@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 24, 2020 at 08:10:33AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.6 release.
> There are 474 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Jun 2020 05:58:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Guenter
