Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30B7D25E72
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 09:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbfEVHDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 03:03:47 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55520 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfEVHDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 03:03:47 -0400
Received: by mail-wm1-f68.google.com with SMTP id x64so946817wmb.5
        for <stable@vger.kernel.org>; Wed, 22 May 2019 00:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XyUExAoRIQds+qaoHz71XnnFutNbjVISu9zM0HA1E0Q=;
        b=j0btQvTz6E4xGvDiw4VXPhX7YQ6nOsdnHrZV5hlXZT8LnvPguOHY0A6C6F68DbXgsT
         1UZhr3USWTP4RQO8tV7nSgQ0Qc/kY39lSydBLYpOCjwSlv5H2+Qi+g4BDAUAi1x932SM
         XbR8r4HMZKgdKZkDlupKGCxhxW1rD4dXaEQ6iqD0mXyurCQXabhgh0ecB185tLLTyvGw
         00ni7naU2QWh99Fh2Gk0f5LqnEZFfHe1QNv72nxj0WOtZPhF4fQ5r/AdkP6LtJWKmFEt
         P6nUcthiKbsZTEfR1UkN/tMrHpjj8QCaXHmVrJ7NwfZBxou9cKvUqGxVz2GKzq3jfusk
         ZCJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XyUExAoRIQds+qaoHz71XnnFutNbjVISu9zM0HA1E0Q=;
        b=Wz0/1DT9zpjrSwtfKefQdrgzzVA1NQCYyZ5FH0Rr+zeS32WMXGCEuGsn2jp9s8wc/e
         0KdPtYt8EIaIvMRFmdfzschpwPaeejfDxmkvrGxxk87lnH2pD2EhLh0qQ0RLrgrh/8QL
         t44VXRmie4Q77ULH4+k06ByeviSZZicerNlvFhz686+xbyURF3iTdyX31jhAmdAT10Pm
         OH7xR6W6N32AaischuZWEm/Zy1yNI5lBc9cQqhmgkrSrDM2LbZ48D1NGvHqQBMb4//7o
         PR05ye57ZrXmWnHJl09Jq13cZhMxdKjQ/kO1V+GbpejsQ9BybLL6jBwmky70jnvzY65B
         G1vw==
X-Gm-Message-State: APjAAAX0KsAgSNd9csjl8xGZfyHBsDeZV0qSgbqWYfZLSE24fJjyTUqf
        0B9yehDBHi561j0dxoxbRo+UYQ==
X-Google-Smtp-Source: APXvYqyI/8BkHq8u9vd6mhfC6UOZUI4KUX4YD1XbWpr2TILi4b1BFlR3W0pVD27X22wwcaFNwPfa+w==
X-Received: by 2002:a1c:4107:: with SMTP id o7mr6321092wma.122.1558508625472;
        Wed, 22 May 2019 00:03:45 -0700 (PDT)
Received: from apalos (ppp-94-66-229-5.home.otenet.gr. [94.66.229.5])
        by smtp.gmail.com with ESMTPSA id p8sm15598396wro.0.2019.05.22.00.03.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 00:03:44 -0700 (PDT)
Date:   Wed, 22 May 2019 10:03:41 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Viresh Kumar <viresh.kumar@linaro.org>
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
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] clk: mvebu: armada-37xx-periph: Fix initialization for
 cpu clocks
Message-ID: <20190522070341.GA32613@apalos>
References: <20190314121541.GB19385@apalos>
 <CAC5LXJcCs4nr-qFOWzUJpUBAJ9ngG-cgeTCVCFBKFc1SPzHMuQ@mail.gmail.com>
 <20190314134428.GA24768@apalos>
 <874l85v8p6.fsf@FE-laptop>
 <20190318112844.GA1708@apalos>
 <87h8c0s955.fsf@FE-laptop>
 <20190318122113.GA4834@apalos>
 <20190424093015.rcr5auamfccxf6ei@vireshk-i7>
 <20190425123303.GA12659@apalos>
 <20190520112042.mpamnabxpwciih5m@vireshk-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520112042.mpamnabxpwciih5m@vireshk-i7>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Viresh, Gregory
On Mon, May 20, 2019 at 04:50:42PM +0530, Viresh Kumar wrote:
> On 25-04-19, 15:33, Ilias Apalodimas wrote:
> > Hi Viresh,
> > 
> > > > > Also, during this week-end, Christian suggested that the issue might
> > > > > come from the AVS support.
> > > > > 
> > > > > Could you disable it and check you still have the issue?
> > > > > 
> > > > > For this, you just have to remove the avs node in
> > > > > arch/arm64/boot/dts/marvell/armada-37xx.dtsi and rebuild the dtb.
> > > > Sure. You'll have to wait for a week though. Currently on a trip. I'll run that
> > > >  once i return
> > > 
> > > @Ilias: Can you please try this now and confirm to Gregory ?
> > I am more overloaded than usual and totally forgot about this. Apologies.
> > I'll try finding some time and do this.
> 
> Ping Ilias.
Sorry for the huge delay. 
Applying this patch and removing tha 'avs' node from
arch/arm64/boot/dts/marvell/armada-37xx.dtsi seems to work.
Changing between governors does not freeze the board any more. I haven't checked
the actual impact on the CPU speed but the values on 
/sys/devices/system/cpu/cpufreq/policy0/scaling_governor are correct

Cheers
/Ilias
