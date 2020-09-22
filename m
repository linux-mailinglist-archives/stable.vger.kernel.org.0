Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E204B2749F8
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 22:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbgIVUR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 16:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgIVUR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 16:17:58 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB14DC061755;
        Tue, 22 Sep 2020 13:17:58 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id t76so22459471oif.7;
        Tue, 22 Sep 2020 13:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LXCRnZGF9B/MQaAdx8Lgmau8FkPRZgOP0DFx/q7DEmQ=;
        b=XOody3FD5H/rR/gCanyplRPp0j6la/YA0dWFssnP5Ic26MmYnhCfPCrs/smGBZfaWR
         gUEFztMbem0tUfg0UDuQDHjIuw0E/4nx1X4Flsti/GgTg4+iYQsFGYwcm8rcpbXRWRb5
         ek4HCPRdj8YxFpGQji+JBgSNj0O4mpdyNx/I7UTlXom18cXC54wn7Lv2bhkDnJs3tzzo
         dviOr9oJdterOV7QF4higJQp5dUlY9OPwC2vsSAN/oDuuEdZU4aa/va9NYaDgVnk9LFD
         OQ5b4BFV+H+zF/cHb94PwUBXaIi0sOrhwgB4KVdSbdHremeuaaceTpqYxqfd6be9TmSc
         +tHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=LXCRnZGF9B/MQaAdx8Lgmau8FkPRZgOP0DFx/q7DEmQ=;
        b=cH3LU2rquka1EKqPXbGzqiQhZr2LjspCxQvZq29Poob2n8MKpdo6izaBPSruWoQQGb
         HT1xFAgaLpcb7y8I6gytylxyWxTdBApS9hNoRI4YUlKz1kZsmJv8b56hxt9YwrmOpub4
         krdgnL53pVn0Lu3e2OsA5K22P68dGKRoNqC/d+Klr63zwTNjQ5lDDdtS4rNy2ZlmMVp8
         DOfGqyrZVzesZfb7Lg6HgyzlBzv0u8jA7WuKAW/uxd11xAndF6JKx5va9Y5ezTT2T45/
         v8kTvLuW3K0IZ2/Wb7V1a/lk7DKS1o+vT47V/dgQa9PzfU2hUzKs8q+eQ7F2jXdEp+n2
         hThg==
X-Gm-Message-State: AOAM530KT7xNuvv95pR+OB9ubNUEVskRsjKTgBpg+QPKHF+QrQ8gSRgt
        RUIXZqE1RUfpSVctTa4NoPO5gcbCsJQ=
X-Google-Smtp-Source: ABdhPJxJIqePrlcJ4IK0t4Wbzv+R6LMY5PkERO4I7ZVttyRs7lzBLdYDC4BpxdfW3zyc5okWLs2vqw==
X-Received: by 2002:aca:fc95:: with SMTP id a143mr3775501oii.104.1600805878182;
        Tue, 22 Sep 2020 13:17:58 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y24sm8560827ooq.38.2020.09.22.13.17.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Sep 2020 13:17:57 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 22 Sep 2020 13:17:56 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/70] 4.9.237-rc1 review
Message-ID: <20200922201756.GB127538@roeck-us.net>
References: <20200921162035.136047591@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 06:27:00PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.237 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
total: 171 pass: 171 fail: 0
Qemu test results:
total: 386 pass: 386 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
