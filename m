Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C5E24C67D
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 22:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgHTUCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 16:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbgHTUCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 16:02:15 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556F4C061386;
        Thu, 20 Aug 2020 13:02:14 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id nv17so1444125pjb.3;
        Thu, 20 Aug 2020 13:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gHI5fms2eY3ljRyjPJ3Px3gImH2SXsoONhOJNBFVKmI=;
        b=AngRTNce5VsfbuO1AOicDhQ24fOGg6EM8VhiRkPux88yTSFCU83359HMGhTJIvnZVJ
         6R4mARP9ZpSt3liLBXGr0wlUVeT+cWkuqhezt9zOMoxE4hbuEtqA1WiQZ3gf5d1kjCGP
         dqDZz8kc1SAZindOGXjNxCGiEdfQQyCte+rk/BwTO13cTGp7C9/d2XytefBi2EodqOY0
         G2/WPLpBAUkK7wQM5K/fIV4A4m6fP1L1Fxo2ZrnSu2OR/heFrAKqFLlP3D1AUMzdAUgS
         QqulW2mEEZiHzm+PugAj9F5KSLMKWNyE7Pq9EaCy+4h+brr+QPJ+oQqliu+hkb3r0Hz2
         33Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=gHI5fms2eY3ljRyjPJ3Px3gImH2SXsoONhOJNBFVKmI=;
        b=i2G+mQrxVe5UzX8wLkAafeF1VOe+SdHvquGkVWN54NlwR5YwukKRUytqdqWBfERhi2
         AKj7GGSlIiCHl5HyxyChLZfhTHL7hapgxHW0hRDymg38k8pooD78SX/ik/wARHO77t/V
         KfcZdd8Kza6KGJEql08TN1MGt79c39Zj+oWFQQDtZLldPdaci9ZqjHFu2yD3tnnX3qk6
         WgK3QqGxgRFRjZ8oHI8ecCdvSCpwOTODhKjP0qqSBBxx2ag/lTcO10BhbhnGgnBFtp39
         3FkX4DvoZGVbvT3sQiO7Wd+KKhODv+CiFijcofQwPuKVJPy8moKvii4ez3RodtMQvTA3
         WfLQ==
X-Gm-Message-State: AOAM530yhaz0j0sBoTgqJTTDnqWKaOAM8E6wdILj1MWMJD14Mt8QkJrr
        NDD1Dj3mS46u32JP1Hz29ZQBlsP872E=
X-Google-Smtp-Source: ABdhPJzSYu/fwrnxbWbu0gP7WD9q41/BCtXT+cq58aHBmXY6BRKI6lG6f9L56RPFhhxF7bDn1Wp9lg==
X-Received: by 2002:a17:902:b205:: with SMTP id t5mr12489plr.7.1597953733668;
        Thu, 20 Aug 2020 13:02:13 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n1sm3955763pfu.2.2020.08.20.13.02.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 20 Aug 2020 13:02:13 -0700 (PDT)
Date:   Thu, 20 Aug 2020 13:02:12 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/226] 4.14.194-rc2 review
Message-ID: <20200820200212.GB84616@roeck-us.net>
References: <20200820135009.684062405@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820135009.684062405@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 03:51:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.194 release.
> There are 226 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2020 13:49:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 408 pass: 408 fail: 0

Guenter
