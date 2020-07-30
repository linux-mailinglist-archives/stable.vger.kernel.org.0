Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6248233717
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 18:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgG3QrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 12:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgG3QrJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 12:47:09 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB7EC061574;
        Thu, 30 Jul 2020 09:47:09 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d1so14666838plr.8;
        Thu, 30 Jul 2020 09:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ypfrHlAeqp0fkHr5HvJKwXsHKSkqOrW3FxxxBPheOl4=;
        b=R0nuX9F6XL2Cc/JdSsQV9wB/zWTM/lw6t5IxQLTqRDNDCRb5vExBxQDinziaYm6mjg
         YZkOQ3grqCPyPzBAddHpV6TI3lO7p2qcIXFznAxWtoBjaRVnUvr49LEyvnUpwRCsHx63
         unM+t3L2OTt/SMCH7in5jJRNF/5pu593Dn+iT4D9QIIZB3WfAgZsPPjFHMH+3rw4E/IT
         u37r+14oIVvxUwEEFEJvfMtdK5kw422YJkzTrtCcGbpBNPHAvQWq5XK3JkI+iI08k5PN
         tx3/PknA5UiQgWrr6tlzAHehuGx7wLfQ04ZHkSFUpui3azUMCohdZCjV5k5S523WWskn
         uSuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ypfrHlAeqp0fkHr5HvJKwXsHKSkqOrW3FxxxBPheOl4=;
        b=aJUUe9owH4swhOebIXN8eja4MGiRoTlJxQKFuPJbWQo4fwvyE211Eu8b1/zgbB/1cv
         BIJgM/+FLfnHb//SitGTEVQiLUOcJl7I4YYApGgeN0+dgDxR3/JO+P+KKprE3qjSIKib
         /qYGGlIYF9z166C11BH9B8MdFAfq1mjUXJ3DCKS7cXrRoGZzKeJUicK5/hb5XHJ/DG1X
         jSaFM6+DohRlVGUoqy0KYal04JV5UF5zKJR1WwJLvi05jD1HdjzGeDjQRYiqWe/XT71M
         F+2W9THyYc2hbbJ275/Vn6d/wOt/jjqWZnwzZbKw5zjgPlKNSLOkxeHbhUR5iTLXVPc9
         5dow==
X-Gm-Message-State: AOAM532apbSS30Lk3MPP+v3KgkxJxNaqP4N2u8cxh0rTY6URHUXhqdQ7
        RUHNAtztpAj96Z5ZDrsBQD5p1C2L
X-Google-Smtp-Source: ABdhPJxuLn1ouPzq0SvMirta1U3RxkT8VH0lLar4/EvwSNlPpdDBe5XXFeb1NwdZM2KZHa3gi5WIJQ==
X-Received: by 2002:aa7:946e:: with SMTP id t14mr4055456pfq.85.1596127628747;
        Thu, 30 Jul 2020 09:47:08 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a5sm6580688pfi.79.2020.07.30.09.47.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Jul 2020 09:47:08 -0700 (PDT)
Date:   Thu, 30 Jul 2020 09:47:07 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/14] 4.14.191-rc1 review
Message-ID: <20200730164707.GC57647@roeck-us.net>
References: <20200730074418.882736401@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730074418.882736401@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 30, 2020 at 10:04:43AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.191 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2020 07:44:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 405 pass: 405 fail: 0

Guenter
