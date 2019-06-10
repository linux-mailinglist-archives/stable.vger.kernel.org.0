Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A50F3B2EA
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 12:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389292AbfFJKTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 06:19:22 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39483 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389290AbfFJKTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 06:19:21 -0400
Received: by mail-pg1-f194.google.com with SMTP id 196so4802987pgc.6
        for <stable@vger.kernel.org>; Mon, 10 Jun 2019 03:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Xl6v5F/D3VxC6oJtpVMTcWPj1WSUBStBszKQqnRd45o=;
        b=Zxke5XTXYzZ1WpIKENuUCvQiJugmF6xmPmbVa+fQbXPRt5NLXE3XHZUNoUGyv8aLFk
         0rjG9L8UqFlU/U4gpMjRlgJ8X3nE6ri7wGy68f6iQ0YzmFvk4qUWjWrM+LidoPGkcYmC
         PQ9xxtOgJlxOvxLQsHD98QnhH9k+vQEifhuGZEw6YF5JG7SxcgV9Yrm+JHUTnexYbwAF
         kXuHYrgJkBfViN9xWMijKskkhxv4JJjHTYC543USXdVVRRCXXHLpuHefM1TguMusR2yy
         vc20X6vM3jkm2bt3gBKV0pla8vMhrOsmoUlAB2tkbEgoAhTb/u7PiuuxS5EVmWSF1W4W
         /vug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Xl6v5F/D3VxC6oJtpVMTcWPj1WSUBStBszKQqnRd45o=;
        b=tEZjpatR+dV3kDnK7ZNyTqgoNeLVcaD7n3OYRdfA6YnGJ9+Wn/r4Ax/K8Koa1GY7nX
         4Ai+tb8fYEra6omA8yTDFluaRTNROCor9llZMeAtciPWP9sqzDVttot+1TF1qDsNAgyf
         Ctg6XNMT+VcMjnwtGq3OuVhDDdmBrrrLIctH5lLSyXe2Iv/Ru8fgIEMCc1h/NyrKgTLr
         IyQWNKzZ00R1J5mWX9MDDzmycrfnRaGdULK5YRmnSS8atFagvoqH4BBrHHEWI0MST6KF
         RUEHH5oKAavpXhjdx93RBchmAwzmDYUiylfVdIbBCfW8nh8lTURh5PUVq/4sz035z/JM
         p4dA==
X-Gm-Message-State: APjAAAWWl8/4iPyibvGBCfyMg1BnxCO6fccbhwKe8+zLNXjmt95uyExR
        8mzy1+L7cmBAroQZnvbWO8Zs/w==
X-Google-Smtp-Source: APXvYqz3SI+6kD/ZaeTpbKZtNgBi0rdKkLPqyJFXIcZSqv4cqHNVPe2yimUvsPw0UUlmdDCXEymP1A==
X-Received: by 2002:a65:6495:: with SMTP id e21mr993356pgv.383.1560161960609;
        Mon, 10 Jun 2019 03:19:20 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id f186sm13630525pfb.5.2019.06.10.03.19.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 03:19:19 -0700 (PDT)
Date:   Mon, 10 Jun 2019 15:49:18 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Gregory CLEMENT <gregory.clement@bootlin.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Christian Neubert <christian.neubert.86@gmail.com>,
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
Message-ID: <20190610101918.sypafywc6fn4jsbo@vireshk-i7>
References: <20190314134428.GA24768@apalos>
 <874l85v8p6.fsf@FE-laptop>
 <20190318112844.GA1708@apalos>
 <87h8c0s955.fsf@FE-laptop>
 <20190318122113.GA4834@apalos>
 <20190424093015.rcr5auamfccxf6ei@vireshk-i7>
 <20190425123303.GA12659@apalos>
 <20190520112042.mpamnabxpwciih5m@vireshk-i7>
 <20190522070341.GA32613@apalos>
 <20190522070614.jhpo7nqrxinmlbcs@vireshk-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522070614.jhpo7nqrxinmlbcs@vireshk-i7>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22-05-19, 12:36, Viresh Kumar wrote:
> On 22-05-19, 10:03, Ilias Apalodimas wrote:
> > Hi Viresh, Gregory
> > On Mon, May 20, 2019 at 04:50:42PM +0530, Viresh Kumar wrote:
> > > On 25-04-19, 15:33, Ilias Apalodimas wrote:
> > > > Hi Viresh,
> > > > 
> > > > > > > Also, during this week-end, Christian suggested that the issue might
> > > > > > > come from the AVS support.
> > > > > > > 
> > > > > > > Could you disable it and check you still have the issue?
> > > > > > > 
> > > > > > > For this, you just have to remove the avs node in
> > > > > > > arch/arm64/boot/dts/marvell/armada-37xx.dtsi and rebuild the dtb.
> > > > > > Sure. You'll have to wait for a week though. Currently on a trip. I'll run that
> > > > > >  once i return
> > > > > 
> > > > > @Ilias: Can you please try this now and confirm to Gregory ?
> > > > I am more overloaded than usual and totally forgot about this. Apologies.
> > > > I'll try finding some time and do this.
> > > 
> > > Ping Ilias.
> > Sorry for the huge delay. 
> > Applying this patch and removing tha 'avs' node from
> > arch/arm64/boot/dts/marvell/armada-37xx.dtsi seems to work.
> > Changing between governors does not freeze the board any more. I haven't checked
> > the actual impact on the CPU speed but the values on 
> > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor are correct
> 
> Thanks for testing it out. Lets see what Gregory has to say now.

@Gregory: Do you have any further advice for Ilias ?

-- 
viresh
