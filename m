Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF4C2293E2
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 10:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgGVIsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 04:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgGVIsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jul 2020 04:48:14 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1337C0619DC
        for <stable@vger.kernel.org>; Wed, 22 Jul 2020 01:48:14 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id a24so815089pfc.10
        for <stable@vger.kernel.org>; Wed, 22 Jul 2020 01:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2XMC5RGtEC18Cma6Q9AvZTJswETLyWCWSSbAFrUkvG8=;
        b=BVMnQQa3AsjdzwWRQOHFI5LQ++bYgpCUjROcys7OBMRe+9r+1FcvqlwQDTgb4NFhbY
         MRFvZDwfrVJgYN4Q2hPpSSSDSG0Eq/QYX6YiG2/D2FnGckoA0qMc3e8M9UG6Y61WKUKq
         oHMnzSXe0KEzrMrbiKSyhpiBoTRjG4+5BTD6ez51HISjIMa9F97fnQbHfUqjmfIXJN2f
         Ewm8NE9AIlHQkxGFchJmt4LQz2Q7h/v28X1ViMZBeLO/a5BrnY7AHIzQ7tQyZQGJ9mLR
         zceUmSSqMeyPVe/F4/jx+HOqL1DhAOv44MF4Xz0DMXw+7cjKMesH2iPDHk2Z3XzbDcjX
         c7gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2XMC5RGtEC18Cma6Q9AvZTJswETLyWCWSSbAFrUkvG8=;
        b=Cu0fL+Gzww6DRAyT9OE0VYRKMZpksRnLGpxEUk8LourkLQHuWSqFGsTvaJjCYwuwpN
         VTi42AexuAFBcBvkzTJvHRU68pVIbgokj4794XhTELzSMW9DF5p4jTk6KXSVxkPLkcO1
         u9u4LLDnkltNjjDPWLTy/5WjovEzrxEQDgeoQB/wPl2+fBvLN6mu3AL1xmP57lcEQFLr
         j8DSSV9ZZo444jw4u3OpgpZak7asZUYUKYdF4IdVcgwhdkjd0f8hKxSSA48vdpM2wvec
         X6ywxSI6YAUnjyXPmMgAeeFctYelfnob/dxdoyr98v+Ai+wfqkD8b4ho4+t9+fjsB6pT
         /1ww==
X-Gm-Message-State: AOAM533Hel81aoFKJ6WjzbJObhLqoQiNLP50PnPYbPdaPZ+C/kgcxywI
        d+4aNbiboNzUaCsdJ7kZ2Pi/JQ==
X-Google-Smtp-Source: ABdhPJwMPmap/ES250fUE1ptpDsvTaS8Iq14/4w4/3pyscBrTGIq/rpygg8y8AD2584YTpWphLIIOg==
X-Received: by 2002:aa7:8096:: with SMTP id v22mr29116824pff.132.1595407694228;
        Wed, 22 Jul 2020 01:48:14 -0700 (PDT)
Received: from localhost ([182.77.116.224])
        by smtp.gmail.com with ESMTPSA id c71sm6250020pje.32.2020.07.22.01.48.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Jul 2020 01:48:13 -0700 (PDT)
Date:   Wed, 22 Jul 2020 14:18:10 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Finley Xiao <finley.xiao@rock-chips.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 4.19 123/133] thermal/drivers/cpufreq_cooling: Fix wrong
 frequency converted from power
Message-ID: <20200722084810.sigwmd5beiu5gfw7@vireshk-mac-ubuntu>
References: <20200720152803.732195882@linuxfoundation.org>
 <20200720152809.664822211@linuxfoundation.org>
 <20200721114344.GC17778@duo.ucw.cz>
 <20200722053453.xmfcezyiabz2e2dd@vireshk-mac-ubuntu>
 <20200722074317.GA11366@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722074317.GA11366@amd>
User-Agent: NeoMutt/20170609 (1.8.3)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22-07-20, 09:43, Pavel Machek wrote:
> OTOH the changelog is extremely confusing, because code would not work
> on the table presented there as an example.

Yeah, maybe I should have updated it too, just missed it completely :(

-- 
viresh
