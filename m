Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989E724FF1D
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 15:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgHXNkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 09:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgHXNk3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 09:40:29 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587A8C061573;
        Mon, 24 Aug 2020 06:40:29 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id q1so4247867pjd.1;
        Mon, 24 Aug 2020 06:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GegIgy0cL58i7RxC1XLMfU37QkwjYG7OWhDY0lJZn2w=;
        b=a0rZI2HfhmAbO+VUjRe9nkEk7FRjOg4vQUzBRmuEwkUE2vF1UqM8tFYTqnjnLppUae
         jkesHyKEcbgqvAwCUWORIvHZ4uEVTQNRQ42jIstNbI1qA1Gh3mL1k3LlmsqwBOqANWQU
         Gu4kCfWerkJAFNrzc0HiDqIP3/OuPH9pi+4p6vZQdhi4DuYjYJ7j9W1k84t9vBYiJa6D
         S9ZlSWnKcY2+JvlPeTSXapd7GhBDqr4vbFmB4Ysz235FvNHp8j9W1+IyIpNR6AgXuo3y
         m2tqj97GpLugV8eBYONUI90s0D3XjGovvg7CEAS8WyWejlifSOx4U8E75tGl6YTL0kg/
         kPSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=GegIgy0cL58i7RxC1XLMfU37QkwjYG7OWhDY0lJZn2w=;
        b=OyufOZUgVQfZ1Ep+t9G3yuPSsHo4NM8OmoydPglDW53CvY0kIIz1IWn21EvYPZ7e48
         pQMuupigk74ab3ERVZRFweTjeTD6s0zfKu3V8Yhcq4gkqdBDHcg/o2bGIEV2uOa/5xga
         0loc4kDsRLZeIyuv1pIdK1SDt5Adz+bz78/5Ay8zkRQqsNygK4WHXGM2kUg+KEQc7MkU
         0zqljgLTFPbqVqY7C6glRsDh9iTzU00cpKieij2YQwkdLDsOG4lFZMIErhcm38L6bUtc
         OXAU81ruHqA8aeGYpfeVlSsko7T6stWNQGPXcQRhuTc1/GbkjyTtGjj0G6aapYc3Oh4g
         e55A==
X-Gm-Message-State: AOAM532ZedNMjOt6Wi/VqViEWE9ARGPwZ3PAgBq2TrNGNrr0KYlmT8Sw
        jstwj/rOEiIcHf1ZcE4b9ok=
X-Google-Smtp-Source: ABdhPJypdU9vfBbHzYiJjmQeyV0UlkeqK7XgvlUODaVkKK0n/arzdhMqV3fIZ7SFe7XH9U+9RVeZ6Q==
X-Received: by 2002:a17:902:d715:: with SMTP id w21mr4020030ply.14.1598276428969;
        Mon, 24 Aug 2020 06:40:28 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t63sm9846396pgt.50.2020.08.24.06.40.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 24 Aug 2020 06:40:28 -0700 (PDT)
Date:   Mon, 24 Aug 2020 06:40:27 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/148] 5.8.4-rc1 review
Message-ID: <20200824134027.GA86241@roeck-us.net>
References: <20200824082413.900489417@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 10:28:18AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.4 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Aug 2020 08:23:34 +0000.
> Anything received after that time might be too late.
> 

Building powerpc:defconfig ... failed
--------------
Error log:
powerpc64-linux-ld: arch/powerpc/kernel/cputable.o:(.init.data+0xd78): undefined reference to `__machine_check_early_realmode_p10'
make[1]: *** [vmlinux] Error 1
make: *** [__sub-make] Error 2

The problem affects several builds.

Guenter
