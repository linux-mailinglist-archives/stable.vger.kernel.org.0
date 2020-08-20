Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313E224AE29
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 06:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgHTE6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 00:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgHTE6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 00:58:21 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C19C061383
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 21:58:21 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u20so471369pfn.0
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 21:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=MgWKvwbixDoVFhCX8j2Wxsz+XLL8akDRZzoDWLA4TpM=;
        b=VBVS3y6ET9yGsjgbdBruST1OCrCP7YkfZzAMXwWOfF0L70eEf30pW+DnJBZzuDUW1y
         XqU09zDoFXEe4BQuvViq0FLsgyJw6HjIGa5I2ZKDNid8SUQL8bzH0HhFGwB/LBjIUvxT
         kG66Bpz1RFzPSmYOgazxJGOAQEc9b2G1pBDpCjA+jcnKtpENI+k4vs0OvDrTVIZLZUac
         JlRxQ9Rs7OeKne6iyD6f1fLLJS4DVJbuNZNZ1tO0QxbKkYFLSpgKjw1akYJU9W7vAnmF
         IjmeB7Aws9gq/0QeNSgdgBuyl57XwvXWeSrKiaOn/QHpg7P0gD1G7dmPNF57X8rEE65E
         EHeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=MgWKvwbixDoVFhCX8j2Wxsz+XLL8akDRZzoDWLA4TpM=;
        b=p0dA6CEHh7SW6bobmDjnHhXdksYuVzW5o4vk87SWQUNAt8QEWGF2zz/Km+Xn4sgoTp
         N2gUp3TlHJoSCIbr9zrGMqeudqpnMtOsFalMUYf3mvQm3EqHb8t918os8TjLn4tBfZCH
         6URqxtVBjkoOK9zFGt773ANrNlbQByZEu9joCdHENsHDnVbGe15OzN0h6I14v6Sc4sNQ
         3FbbvuFEzOnhk3l+HoHU/lqHQMWrUfvCfRYzirmIFp19/t12gHg8HpBJEBdPfegT99xi
         X9GDPC6bgWvVOonVbRJV5MoOoxDYVlUfO5KMPrMCsNKnj4ZFFVc94pq0CIXJfC+L+3Ik
         +xYA==
X-Gm-Message-State: AOAM533kanIapSfI8SRM1D6oJMlPqsg7h4l4pj61Lm/5KsULA1PB+NgL
        llf6m1N9ztiLNd0LDtDOhVepxQ==
X-Google-Smtp-Source: ABdhPJwvQTx6yDB26PhKSrGjiiUUZn5kr0azekWGE3CsyGRDPDtjfoKsPmGjJlKHmVEGHYoKYN6MTw==
X-Received: by 2002:aa7:9096:: with SMTP id i22mr1010445pfa.310.1597899501054;
        Wed, 19 Aug 2020 21:58:21 -0700 (PDT)
Received: from localhost ([122.172.43.13])
        by smtp.gmail.com with ESMTPSA id f17sm1047306pfq.67.2020.08.19.21.58.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Aug 2020 21:58:20 -0700 (PDT)
Date:   Thu, 20 Aug 2020 10:28:18 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Rajendra Nayak <rnayak@codeaurora.org>,
        Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>,
        linux-pm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V2 1/4] opp: Enable resources again if they were disabled
 earlier
Message-ID: <20200820045818.5awujxfd5zothblv@vireshk-i7>
References: <c6bba235a9a6fd777255bb4f1d16492fdcabc847.1597292833.git.viresh.kumar@linaro.org>
 <20200819235657.45FC4214F1@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200819235657.45FC4214F1@mail.kernel.org>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19-08-20, 23:56, Sasha Levin wrote:
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: cd7ea582866f ("opp: Make dev_pm_opp_set_rate() handle freq = 0 to drop performance votes").
> 
> The bot has tested the following trees: v5.8.1, v5.7.15, v5.4.58.
> 
> v5.8.1: Build OK!
> v5.7.15: Build failed! Errors:
>     drivers/opp/core.c:849:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:849:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:849:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:849:17: error: 'struct opp_table' has no member named 'paths'
>     drivers/opp/core.c:849:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:849:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:849:17: error: 'struct opp_table' has no member named 'paths'
>     drivers/opp/core.c:849:17: error: 'struct opp_table' has no member named 'paths'
>     drivers/opp/core.c:849:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:849:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:849:17: error: 'struct opp_table' has no member named 'paths'
>     drivers/opp/core.c:849:17: error: 'struct opp_table' has no member named 'paths'
> 
> v5.4.58: Build failed! Errors:
>     drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:847:17: error: 'struct opp_table' has no member named 'paths'
>     drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:847:17: error: 'struct opp_table' has no member named 'paths'
>     drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:847:17: error: 'struct opp_table' has no member named 'paths'
>     drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:847:17: error: 'struct opp_table' has no member named 'paths'
>     drivers/opp/core.c:847:17: error: ‘struct opp_table’ has no member named ‘paths’
>     drivers/opp/core.c:847:17: error: 'struct opp_table' has no member named 'paths'
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

We probably need to send different versions for those kernel versions.

-- 
viresh
