Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3ECD4B6EF
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 13:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbfFSLVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 07:21:06 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42793 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbfFSLVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 07:21:06 -0400
Received: by mail-pg1-f195.google.com with SMTP id l19so9465547pgh.9
        for <stable@vger.kernel.org>; Wed, 19 Jun 2019 04:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JdKqAYv2tlg441mmk5Yg5PgqcK1xocn/JRSFbmxrc10=;
        b=u9kXZrJd86bjJOlHKkwdwnDp4wFgvkMvklJ6jOln9aZOpLWWGLVYU/g5gqnRExMjtU
         hU5JArSwIK/goj0o5l9NwBgqOsXzNydlp+8sm+4CYu5jqGnPMVglhuwu2G3CiPj3LufK
         shzrU/YwBQxraRusFeYWSLoTibtcqf4XP1KZLi3p2bUJZhxJWaO9o6cZ1LP1xhJsNreo
         GlUsdY/rWMuZgG8YXwpUbfYjvRMV1p/4Xw7FnVBt+gnYRSA8EErXHTYoL1AvPYnnfR1y
         seOUa+kyPogcdfqzVct8Bo6cObZCI+S/lgWmkqWQ7XsNuLAs/7I5ki+2p37RMvnY8mGh
         BK+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JdKqAYv2tlg441mmk5Yg5PgqcK1xocn/JRSFbmxrc10=;
        b=J89b6pndGn2Grv5GiQib6le7qZYXY2daYegDr4T1fhEuBX9y/7SvHEedsw+RAi54kl
         XrZkP5FHYM8LQv38cUPUMK1ybvow0Ou8RprJ1eH5Rk77C2ageJIouSnItyCAB0YeV8bG
         7IEanouFLrCNfQA95VSSUsSJ3vXssyo4anKzEIdBpyNOoMgJgCFvlhhR5InQe91iAg+L
         xkjVq29y02Sq1IAw6tZyS69w1jn33hMgCA2wbnUpN5FrnFP1CAQ/9/Z7JVtJh8gV+MiO
         DPIc9NZMqGCH2AQLCdr4zmEeuZuiZcp6SoNfFTpQxb0sIpUzsuAwUT/Zug7njq2OXTay
         iz6A==
X-Gm-Message-State: APjAAAXplQjUF+LN1bJSLbPQOTo1iwnyGAwHHFWaKff7ebAmQ2jT0yc1
        CQgA8W8h7WNtdp9vruiJ0EO+MPWLW+0=
X-Google-Smtp-Source: APXvYqy838wv3KP2iTGxzWl8Ukjs9WArMvCugLfEYD7RcNav5FtRQSfOse41XJyP3r0R0WVVy+TSrQ==
X-Received: by 2002:a62:2e46:: with SMTP id u67mr9849479pfu.206.1560943265279;
        Wed, 19 Jun 2019 04:21:05 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id k13sm17350006pgq.45.2019.06.19.04.21.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 04:21:04 -0700 (PDT)
Date:   Wed, 19 Jun 2019 16:50:59 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Julien Thierry <julien.thierry@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: Re: [PATCH v4.4 00/45] V4.4 backport of arm64 Spectre patches
Message-ID: <20190619112059.ovdwxazcchf7wagz@vireshk-i7>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
 <7329e6d9-140d-59bc-c835-5f6300cf60e0@arm.com>
 <20190618102122.z52oi37pp3wigqxx@vireshk-i7>
 <ed7d6125-e8ec-c3a1-06c7-2a2fa2c92d32@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed7d6125-e8ec-c3a1-06c7-2a2fa2c92d32@arm.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19-06-19, 12:03, Julien Thierry wrote:
> I've given a run for your new version and it looks like the BP hardening
> is not taking place.
> 
> I believe the culprit is update_cpu_capabilities(), which in 4.4 tests
> for capability.desc to know where to stop (and requires all valid
> capabilities to have a description).
> 
> Since commit 644c2ae19 "arm64: cpufeature: Test 'matches' pointer to
> find the end of the list", the restriction was lifted.
> Unfortunately for you, the errata workarounds using BP hardening were
> introduced after that commit and were not given a description. So they
> do not get applied and also, in the current state, would prevent
> following entries in the errata table from getting applied.
> 
> So either 644c2ae19 needs to be backported, or the workarounds need to
> be given descriptions.

Okay, I have backported it and pushed it to my branch now. Thanks.

-- 
viresh
