Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9C4BA20A3
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 18:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfH2QS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 12:18:28 -0400
Received: from foss.arm.com ([217.140.110.172]:47742 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726728AbfH2QS1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 12:18:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66406337;
        Thu, 29 Aug 2019 09:18:27 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 112D43F59C;
        Thu, 29 Aug 2019 09:18:25 -0700 (PDT)
Date:   Thu, 29 Aug 2019 17:18:20 +0100
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
Subject: Re: [PATCH ARM64 v4.4 V3 00/44] V4.4 backport of arm64 Spectre
 patches
Message-ID: <20190829161820.GA44947@lakrids.cambridge.arm.com>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 05:03:45PM +0530, Viresh Kumar wrote:
> Hello,

Hi Viresh,

> This series backports arm64 spectre patches to v4.4 stable kernel. I
> have started this backport with Mark Rutland's backport of Spectre to
> 4.9 [1] and tried applying the upstream version of them over 4.4 and
> resolved conflicts by checking how they have been resolved in 4.9.
> 
> The KVM changes are mostly dropped as the KVM code in v4.4 is quite
> different and it makes backport more complex. This was suggested by the
> ARM team.

I'm reviewing this backport now, but it's going to take me a few days to
get through the entire series, so please don't be surprised if I'm quiet
until the middle of next week.

If I spot any issues I'll reply immediately, but please poke if I
haven't said anything by Wednesday.

Thanks,
Mark.
