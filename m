Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E94837C9CB
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 19:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfGaRC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 13:02:28 -0400
Received: from foss.arm.com ([217.140.110.172]:51906 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbfGaRC2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 13:02:28 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DE33B337;
        Wed, 31 Jul 2019 10:02:27 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 84A793F71F;
        Wed, 31 Jul 2019 10:02:26 -0700 (PDT)
Date:   Wed, 31 Jul 2019 18:02:24 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: Re: [PATCH v4.4 V2 00/43] V4.4 backport of arm64 Spectre patches
Message-ID: <20190731170224.GK39768@lakrids.cambridge.arm.com>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
 <20190731025253.ys4ph2hwa7hzdi5n@vireshk-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731025253.ys4ph2hwa7hzdi5n@vireshk-i7>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Viresh,

On Wed, Jul 31, 2019 at 08:22:53AM +0530, Viresh Kumar wrote:
> On 12-07-19, 10:57, Viresh Kumar wrote:
> > Hello,
> > 
> > This series backports arm64 spectre patches to v4.4 stable kernel. I
> > have started this backport with Mark Rutland's backport of Spectre to
> > 4.9 [1] and tried applying the upstream version of them over 4.4 and
> > resolved conflicts by checking how they have been resolved in 4.9.
> 
> Since it has been almost 3 weeks since the patches are last posted,
> here is a gentle reminder for reviewing it :)

I've taken a look at about half of the series today, and left a couple
of comments. I intend to attack the rest, but I won't be able to do so
until Tuesday next week.

Thanks,
Mark.
