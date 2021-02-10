Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEF2315C2B
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 02:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhBJBZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 20:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234260AbhBJBY3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 20:24:29 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7BDC061574;
        Tue,  9 Feb 2021 17:23:49 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id o7so415015ils.2;
        Tue, 09 Feb 2021 17:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Pu9ttn1GFEgumsxyEcTvA4Xf1mToDBrOGYmOi2H6blc=;
        b=Q9h6b5cdFWC1AyCFTkWapW8Q8pZbfQ/OTsolH6IFSVGkoGVmfg0otB6V7TgpQNb5H0
         YYUd16vO2xspJcluCNBav+mRBOv49mFmzP+NHyiAwpxvBaSWsOHo5hf7MdVy2BM1hwJa
         gQf53ssPQY/MamrnNX1FdFPEe3if3wPvtuMBhcFKBh+rm7jLlu9NLwKk0UqsIVNtTuqY
         VeUwRsDpygrYh13nc4QpcxSH1qHuIqVR3JgNEqyincR1ykuQhZF7cTlZ++9fjM00RiJH
         euH8z4wJq8/cUwzK8rtspo0z5ktVB+j3QNsGveJKMaPg+klWWpACGkx3aCnNZkvgA26E
         dfbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Pu9ttn1GFEgumsxyEcTvA4Xf1mToDBrOGYmOi2H6blc=;
        b=Jd153hORAw7E1wJ+q2DZ7TEKAGQF1HHZnS7NnwAyYvzs8ID5qvI6pJjvWTn5+sz1ie
         09vL/v2pHJw90dZQfDtRWlmxhawxsv66Bqj1HMi8bi5GVKZDmIDPT0DwlFFhrZWOrOjN
         oGrQ0SNgNUrVfDYiYeK0bsT4l48bvL+15M/ZrkU7SrByOh6Fz0G93ch48q0ptQe1IP7k
         fcJFQZq43swej5d5zRZDb4FPoundL34HKWZ/aZRTSx5a9ZLY7RWgs5joJwygdl5R3/tq
         EGDDkBsgUh6J1XKY/vibQ+JMcqS/pbKRIJ52ae8ZFSQFhnOt6nHwT8ioh8T4JHKwf07/
         vbVQ==
X-Gm-Message-State: AOAM5318WR/vdjR/l22MyAGy8plWgoefajaiIoTN93caY626DhuNFDSS
        evRNX4FQgugnoOsrMnjAdGo=
X-Google-Smtp-Source: ABdhPJy67IMUaUjRQLVT9uhBH7MOj//gEGjqhSdqfoW98ys8fTR5yIv/YVU4BpymSQlvzpmB1Pslig==
X-Received: by 2002:a05:6e02:f4e:: with SMTP id y14mr744828ilj.60.1612920229146;
        Tue, 09 Feb 2021 17:23:49 -0800 (PST)
Received: from book ([2601:445:8200:6c90::d0e5])
        by smtp.gmail.com with ESMTPSA id i20sm192868ila.82.2021.02.09.17.23.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 17:23:48 -0800 (PST)
Date:   Tue, 9 Feb 2021 19:23:46 -0600
From:   Ross Schmidt <ross.schm.dev@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/65] 5.4.97-rc1 review
Message-ID: <20210210012346.GB5618@book>
References: <20210208145810.230485165@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 04:00:32PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.97 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>

Compiled and booted with no regressions on x86_64.

Tested-by: Ross Schmidt <ross.schm.dev@gmail.com>


thanks,

Ross
