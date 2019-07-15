Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E39F68A3D
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730079AbfGONJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:09:40 -0400
Received: from foss.arm.com ([217.140.110.172]:48936 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730019AbfGONJk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:09:40 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 025CF28;
        Mon, 15 Jul 2019 06:09:40 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A0E623F71F;
        Mon, 15 Jul 2019 06:09:38 -0700 (PDT)
Date:   Mon, 15 Jul 2019 14:09:36 +0100
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
Message-ID: <20190715130936.GH56232@lakrids.cambridge.arm.com>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 12, 2019 at 10:57:48AM +0530, Viresh Kumar wrote:
> Hello,
> 
> This series backports arm64 spectre patches to v4.4 stable kernel. I
> have started this backport with Mark Rutland's backport of Spectre to
> 4.9 [1] and tried applying the upstream version of them over 4.4 and
> resolved conflicts by checking how they have been resolved in 4.9.
> 
> The KVM changes are mostly dropped as the KVM code in v4.4 is quite
> different and it makes backport more complex. This was suggested by the
> ARM team.

> I also had to drop few patches as they weren't getting applied properly
> due to missing files/features or they were KVM related:

>   arm/arm64: KVM: Implement PSCI 1.0 support
 
> I have dropped arch/arm64/crypto/sha256-core.S and sha512-core.S files
> as they weren't part of the upstream commit. Not sure why it was
> included by Mark as the commit log doesn't provide any reasoning for it.

It looks like I messed up spectacularly when backporting that commit;
those files should not have been added. I must have had those lying
around from a rebase or similar.

I'll spin a patch for v4.9.y to drop the bits I added erroneously.

It is somewhat concerning that no-one spotted that (myself included)
when the v4.9.y backport was originally made. :/

Thanks,
Mark.
