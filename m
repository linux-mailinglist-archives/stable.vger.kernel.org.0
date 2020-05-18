Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A001D74D2
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 12:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgERKLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 06:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgERKLN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 06:11:13 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204F1C061A0C
        for <stable@vger.kernel.org>; Mon, 18 May 2020 03:11:13 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id y18so4733802pfl.9
        for <stable@vger.kernel.org>; Mon, 18 May 2020 03:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rcBjffi4kQszuwFLOMY+Y6F9ZFkZd22+sdJvlsBdEYg=;
        b=WfGl7ijczvb4fyfsojKm6/aNFhV2eCeaQfVNvf5pSUzoQrH5gSc0teZbBMAQD3ifY6
         8Xq7ffvVEKShSI+Y5D6o9r0g4UEiy/7PCijWdtr59qtwztnsYfjZ5zofrHUdFMsVo4Wu
         gSqS7ohq6M+QiRNe9MEQAsXtzQ33VBfpwAWKjDh13NM7wmhqm6nDAMFd92NTn3M2oxyH
         vFeI0ylamQfCiWz4KTU1D+PRZrO2D05P7U2Ob+lSoLnkZGe52tqGlEdhsmpwgIjuGZ85
         A9JQgrwsUjTvNUgvG25pqMn39fsOoK5hetlUU0Iou4d+M5xy9u68+T0U2Bd2+2LLitfF
         p2IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rcBjffi4kQszuwFLOMY+Y6F9ZFkZd22+sdJvlsBdEYg=;
        b=dSq5NUCwv3HYazBOOWvpjS4+dl7mXs5EDj+SRY925pALeV7DkzypQMXDS9adMpY/DN
         LIJYn0PDvEau50qe3WSruUXcNbZUOYbEJ8Iflr+CVhIYnY2aufUbgp0GJwPB55XfbJ9r
         vdIvpqTW65izgnbnDtfYkX1NV2TY2aF07Rh9zM8Z/dGYFM3oplHg5HshROgibn6i95eE
         Ce2t5n2v5Uk90OraBIkOjht3+i0nwMtslqbP4idL4Pp8Svz1T5vlzdHiWfQJO9Yf55mp
         5FYanXKbix9o0DSMaYjJEG3JH3f4xWoooyUUrp/KTAid5ANOtIycQVswQhIa6sf3IrP4
         3PSw==
X-Gm-Message-State: AOAM533A7mVLF9SukKbaUKECAd4uSUOtCKADT9NvHJnAb1sUQns5HWMb
        41oITzKovjJxLcUnXokJagZ+nw==
X-Google-Smtp-Source: ABdhPJzWkRCIO7jgNHpcV82IrfsERhQCBZdR7cCDWFIWDzouKNaN0H/xiCZ6R3hSQValouNWNaYbJA==
X-Received: by 2002:a62:79c2:: with SMTP id u185mr1949116pfc.159.1589796672606;
        Mon, 18 May 2020 03:11:12 -0700 (PDT)
Received: from localhost ([122.167.130.103])
        by smtp.gmail.com with ESMTPSA id y22sm2305167pfc.132.2020.05.18.03.11.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2020 03:11:11 -0700 (PDT)
Date:   Mon, 18 May 2020 15:41:09 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org, stable@vger.kernel.org,
        Frederic Weisbecker <frederic@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Yue Hu <huyue2@yulong.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 20/20] cpufreq: Return zero on success in boost sw
 setting
Message-ID: <20200518101109.4uggngudy4gfmlvo@vireshk-i7>
References: <20200306124807.3596F80307C2@mail.baikalelectronics.ru>
 <20200506174238.15385-1-Sergey.Semin@baikalelectronics.ru>
 <20200506174238.15385-21-Sergey.Semin@baikalelectronics.ru>
 <c5109483-4c14-1a0c-efa9-51edf01c12de@intel.com>
 <20200516125203.et5gkv6ullkerjyd@mobilestation>
 <20200518074142.c6kbofpdlxro2pjz@vireshk-i7>
 <a8dfa493-f858-e35d-7e57-78478be555c4@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8dfa493-f858-e35d-7e57-78478be555c4@intel.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18-05-20, 11:53, Rafael J. Wysocki wrote:
> That said if you really only want it to return 0 on success, you may as well
> add a ret = 0; statement (with a comment explaining why it is needed) after
> the last break in the loop.

That can be done as well, but will be a bit less efficient as the loop
will execute once for each policy, and so the statement will run
multiple times. Though it isn't going to add any significant latency
in the code.

-- 
viresh
