Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5EEE11B1
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 07:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732358AbfJWFaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 01:30:10 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46464 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730204AbfJWFaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 01:30:10 -0400
Received: by mail-pg1-f196.google.com with SMTP id e15so11401784pgu.13
        for <stable@vger.kernel.org>; Tue, 22 Oct 2019 22:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2rDF05/6n06417wlJVscVUcvibGyzQU00P9mXQIXKPI=;
        b=unyYhVkChYE/uDac0HDbcWN0G8GoHP0zxWY0fxtb/LUoGEbwhJnX7Hq4/MHWxVy0GI
         55H5/ynS1xRqnl675xUK6TOKQbmqdwH403PiCwfecCtzIWLiuQ0Hih64KGKiQcs1moN4
         rmaSUaxUfu1MBS/4nKdguaTTHWlr/AE2gAnOFCZoCY+k2yxizr5uv3QofF1JssrjF177
         g0msVuAH6XdCkxKodaYqaow5W6ZPZTpLu3b1pJ8yn7bKa19VfzWEM/XHUj7yb7uI99f8
         kJFdIJIE2CC7nT7/TqQGv0aN1DbEeoFYAwp9A9K9g8BBGzMVTNqZKZT6sIMOoi6GS7dE
         kD7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2rDF05/6n06417wlJVscVUcvibGyzQU00P9mXQIXKPI=;
        b=tUa4IT7dPHqRNuyryJfybUmZbV3fkqjxpVhVQ85gaVd75KMrhTMpsUPSm5u4FltKWU
         IIQeVLduK5XjBv6su4apCg4EaOwqTTlnohsNte/PqY+32YD+rFu0aOIS7V+N0sNa5uL1
         1C7F5dZzOifx1oik0stJyafILL5RB15axOEQaS4NsyvPPX5SHtZXFnBr+AW+t8s9jX7X
         84CaPH5h79PbwA+B+6O8AEJmsmhP04DxGqot2026+RI57st5TOcrsSI+B8cWXxYXtEP2
         C7oZZgirIQ1OybzOT1iiDLyJtUCzwOr9MGiiS19OA4//j8EAiC1jS7iDvjD6jSWHKj/H
         X+bQ==
X-Gm-Message-State: APjAAAUN5kvvyhwuB8BW14nS7lZoNoto4vzsKi9l0sDr2EYDX9jyM8+K
        wm7PDqrcM+ke5JPY7KL562S/5A==
X-Google-Smtp-Source: APXvYqxRwNayP0aERsMuW4AmJWpia1ARqwMiw0nTvlpYpmTN1wiwajanp5beDtUvou4COtPyjAqQnw==
X-Received: by 2002:a63:d450:: with SMTP id i16mr7822345pgj.126.1571808608951;
        Tue, 22 Oct 2019 22:30:08 -0700 (PDT)
Received: from localhost ([122.172.151.112])
        by smtp.gmail.com with ESMTPSA id v1sm20270144pjd.22.2019.10.22.22.30.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 22:30:07 -0700 (PDT)
Date:   Wed, 23 Oct 2019 11:00:05 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>,
        Stephen Boyd <sboyd@kernel.org>
Cc:     linux-pm@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        "v5 . 0+" <stable@vger.kernel.org>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] opp: of: drop incorrect lockdep_assert_held()
Message-ID: <20191023053005.m4y4bcebgi4km35q@vireshk-i7>
References: <6306e18beab9deff6ee6b32f489390908495fe14.1570703431.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6306e18beab9deff6ee6b32f489390908495fe14.1570703431.git.viresh.kumar@linaro.org>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10-10-19, 16:00, Viresh Kumar wrote:
> _find_opp_of_np() doesn't traverse the list of OPP tables but instead
> just the entries within an OPP table and so only requires to lock the
> OPP table itself.
> 
> The lockdep_assert_held() was added there by mistake and isn't really
> required.
> 
> Fixes: 5d6d106fa455 ("OPP: Populate required opp tables from "required-opps" property")
> Cc: v5.0+ <stable@vger.kernel.org> # v5.0+
> Reported-by: Niklas Cassel <niklas.cassel@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/opp/of.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/opp/of.c b/drivers/opp/of.c
> index 1813f5ad5fa2..6dc41faf74b5 100644
> --- a/drivers/opp/of.c
> +++ b/drivers/opp/of.c
> @@ -77,8 +77,6 @@ static struct dev_pm_opp *_find_opp_of_np(struct opp_table *opp_table,
>  {
>  	struct dev_pm_opp *opp;
>  
> -	lockdep_assert_held(&opp_table_lock);
> -
>  	mutex_lock(&opp_table->lock);
>  
>  	list_for_each_entry(opp, &opp_table->opp_list, node) {

@Niklas, any inputs from your side  here would be appreciated :)

-- 
viresh
