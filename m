Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE60AE714
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 11:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfIJJfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 05:35:37 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46913 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbfIJJfh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 05:35:37 -0400
Received: by mail-wr1-f68.google.com with SMTP id d17so5963197wrq.13
        for <stable@vger.kernel.org>; Tue, 10 Sep 2019 02:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1rX2wfx0JM+S3vqvQq3rPdTdgiJmEP9yW+1Ecnaf+eQ=;
        b=HKVmaZWxvrmFAbNs8+iRkUl6VWB9pff9O5nuwvo62jxuPsi4pDbBT6HNOYJzKRvRBg
         3BYHVPV5Y81TGwTspomaA5RiRSWwHP2wHdf2PtiaNIOdpdlyXAqr1UitYgC4oI9fKTmV
         XPJ/FfJgEbbQj2q2or7+ju/2z4wwgf2iuHjUNFtN/J/kN7lecmeI3Gg56R0FlTXcSqr6
         CBlrbL8cVgxFuZijsEuobwTlCrtxyDhvuWD8P4ge4FIiBkrfzTIVUwX0q/yNvmxBIjjX
         zoh/cx7bpDhtJ+c2fCBljDuyw1wjlBa0AZZcnhncDi/IQ8qos98Tww2p1Sk90hfP/Nj+
         jOuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1rX2wfx0JM+S3vqvQq3rPdTdgiJmEP9yW+1Ecnaf+eQ=;
        b=NJb6fA8ioxN6tvQXqZEXc4S5EqqFL8xgfZQvg6XEX2f+4sOczEGbgVqu84wlC/z3LT
         u6yByDQNSzhryBGRZ32x53klZG79WCB7zNOb3jIfNudBBFNvMQUNJt2KK1DCClpbJwuN
         HRKWiq9mUDCnPX4fv4+/1sZzp4WcECGrXGAqQS76pMRnwOtBmSbQBaCmnUDaq+UW/8Nb
         eUKpgNWgVSn43Uhb0mDzH36VkAuwzXcqJY5n6dqBM/ApgU3stpofg31BdGmlPSAwSvXS
         i8NofoDjYmjaT2hAm6XL6L7gm50Vjl6jaAYeHxn4N1KRxlMAYhCPl9DT7F8fBvGwBKpZ
         TCPA==
X-Gm-Message-State: APjAAAVvyNHle67d/bYRSuvtydZPC9d3JJcUrNe47oD817MnNGs1NI9Z
        CEOPzHc96FKNVHEuR0DyOZcFwA==
X-Google-Smtp-Source: APXvYqzw/J/EvVDjJcgPFGrJCvlsJX/IISQGIYepT3xubHZUCB8b0v0z9zWwkUA1kAv7dsxa0cJNBg==
X-Received: by 2002:adf:d4c5:: with SMTP id w5mr24604774wrk.280.1568108134936;
        Tue, 10 Sep 2019 02:35:34 -0700 (PDT)
Received: from localhost ([148.69.85.38])
        by smtp.gmail.com with ESMTPSA id k9sm32760428wrd.7.2019.09.10.02.35.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 10 Sep 2019 02:35:34 -0700 (PDT)
Date:   Tue, 10 Sep 2019 10:35:33 +0100
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: Re: [PATCH ARM64 v4.4 V3 12/44] arm64: cpufeature: Test 'matches'
 pointer to find the end of the list
Message-ID: <20190910093533.4wajedq2cfg45zcx@vireshk-mac-ubuntu>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
 <617ad445043f040c5ab986b9620b2ba7847b561e.1567077734.git.viresh.kumar@linaro.org>
 <20190902142741.GB9922@lakrids.cambridge.arm.com>
 <20190905074506.oxsw24xoex7gcfgm@vireshk-i7>
 <20190906134935.GA17375@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906134935.GA17375@lakrids.cambridge.arm.com>
User-Agent: NeoMutt/20170609 (1.8.3)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06-09-19, 14:49, Mark Rutland wrote:
> I think it would be worthwhile to do that ASAP to make sure there are no
> boot-time or run-time regressions. We can look at the logs later (or
> re-run with some additional logging) to verify things are working as
> expected.

Sure, so my branch already goes through some LAVA testing from Linaro and
kernel-ci as well. It also gets build tested by 0-day testing bot.

I will make sure it runs on some big.LITTLE stuff on LAVA. Thanks.

-- 
viresh
