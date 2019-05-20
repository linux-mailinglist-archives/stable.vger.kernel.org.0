Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 242A823233
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 13:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732660AbfETLUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 07:20:46 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45280 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731439AbfETLUq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 07:20:46 -0400
Received: by mail-pg1-f195.google.com with SMTP id i21so6641249pgi.12
        for <stable@vger.kernel.org>; Mon, 20 May 2019 04:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UYlwSS27pTWEEATPfmh5rzik1qsLgJhnfWY7i/VPYGM=;
        b=ZyOXXbD53L7FC9dpCCtwyNa8wQKWqJwmxrwOyTzoaognzLkM7STzGoxJ0Qx71mCs7y
         sHAA5OxEXmZSLBsk4s5UC1wzwRqlxOZXjVI3YgzfNOZlwST9cVbN5Di2bjxFZgSEQ3HC
         cAf4/Nfl6PMX99eTSUz2uNGbgXs/y0h2PP6/aRihXmQiSyxZblBUQqK7q5rd0syljRu8
         Cyxuw9OjLph7KF54MzRzzLb/L92ShE61dFPst2bcFQ5dRzt0VO/azH9aGoomKsVUqPxM
         VEvSapNK8K26mQA/hUYAaQY9aw5vjv7LiIUkwnQBQXjEHUtRLOPtbpSjN4XFGye1o1qY
         nlNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UYlwSS27pTWEEATPfmh5rzik1qsLgJhnfWY7i/VPYGM=;
        b=eafXukQV9hdMMu/eZ82VJGMjM1k8IPrh4v8swinv84fyoLZvIknorE76gfl0WEclZe
         x7pXwsAe2KeSLv75GQExssEz1JXXKaJ4xjFgjqVewjhi2Wtm5sC9qCR2GlVT+Z2fwKib
         sgnanUX6cF5vnljdNilXKN7n4W5au0/EA1h5EEq3gLHQtu/buWUGUBH9Ty0wx31IeMTN
         ErVv8cEYtMfvGg1FDGc3QH4hAetADx6+lTpqkrEHp1nbgocQ+tsb3bwvSONhe3mqeGdz
         DXqX0jb9kl85vDq8Mw0g5SP7uKcCRsBYwyGuGYJUCOXUOxwYGq80qZ761CzNTNC4ETyl
         E4yw==
X-Gm-Message-State: APjAAAV862JRxdELMk2IqtYaZTWqbIZrrHYbhruYbUirFQLuLHOBvt5f
        c8Czy6oXC/+04uLyRzdfpnb5LA==
X-Google-Smtp-Source: APXvYqyzFDClOTo8r2XkJzpOynDgwuJ+BaaJ30GDGYI7e20tvugakdxenyHy289DsPne/XUELPFeGA==
X-Received: by 2002:a65:62cc:: with SMTP id m12mr19802417pgv.237.1558351245681;
        Mon, 20 May 2019 04:20:45 -0700 (PDT)
Received: from localhost ([122.172.118.99])
        by smtp.gmail.com with ESMTPSA id r29sm25031152pgn.14.2019.05.20.04.20.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 04:20:44 -0700 (PDT)
Date:   Mon, 20 May 2019 16:50:42 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Gregory CLEMENT <gregory.clement@bootlin.com>,
        Christian Neubert <christian.neubert.86@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Mike Turquette <mturquette@baylibre.com>,
        linux-clk@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-arm-kernel@lists.infradead.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] clk: mvebu: armada-37xx-periph: Fix initialization for
 cpu clocks
Message-ID: <20190520112042.mpamnabxpwciih5m@vireshk-i7>
References: <20190313163558.6705-1-gregory.clement@bootlin.com>
 <20190314121541.GB19385@apalos>
 <CAC5LXJcCs4nr-qFOWzUJpUBAJ9ngG-cgeTCVCFBKFc1SPzHMuQ@mail.gmail.com>
 <20190314134428.GA24768@apalos>
 <874l85v8p6.fsf@FE-laptop>
 <20190318112844.GA1708@apalos>
 <87h8c0s955.fsf@FE-laptop>
 <20190318122113.GA4834@apalos>
 <20190424093015.rcr5auamfccxf6ei@vireshk-i7>
 <20190425123303.GA12659@apalos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425123303.GA12659@apalos>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25-04-19, 15:33, Ilias Apalodimas wrote:
> Hi Viresh,
> 
> > > > Also, during this week-end, Christian suggested that the issue might
> > > > come from the AVS support.
> > > > 
> > > > Could you disable it and check you still have the issue?
> > > > 
> > > > For this, you just have to remove the avs node in
> > > > arch/arm64/boot/dts/marvell/armada-37xx.dtsi and rebuild the dtb.
> > > Sure. You'll have to wait for a week though. Currently on a trip. I'll run that
> > >  once i return
> > 
> > @Ilias: Can you please try this now and confirm to Gregory ?
> I am more overloaded than usual and totally forgot about this. Apologies.
> I'll try finding some time and do this.

Ping Ilias.

-- 
viresh
