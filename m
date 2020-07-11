Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04CE521C123
	for <lists+stable@lfdr.de>; Sat, 11 Jul 2020 02:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgGKA2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 20:28:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726581AbgGKA2D (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 20:28:03 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 928E32078B;
        Sat, 11 Jul 2020 00:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594427282;
        bh=BRp8sZxnMGB3vpZ0E+ioDMibR1SlBT/gKwtr/pLNEYo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rcoEfIMjSYOscAN4dOPiRCIwgHLNfsr7WG33Xmy4XgKSPX9fNs3pkh0AaMgqZdLtc
         LssjVDTYv0uJJtzW6DQThgD3hoW9QztI7ZtFZvf178SFjx1tBiMW5qHGFPnzn80fn4
         gl3ywItY31zXbbTGkHz3MQJEXwCvCnACTvLT8/rI=
Date:   Fri, 10 Jul 2020 20:28:01 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>
Subject: Re: [PATCH stable v4.9 v2] arm64: entry: Place an SB sequence
 following an ERET instruction
Message-ID: <20200711002801.GE2722994@sasha-vm>
References: <20200709195034.15185-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200709195034.15185-1-f.fainelli@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 09, 2020 at 12:50:23PM -0700, Florian Fainelli wrote:
>From: Will Deacon <will.deacon@arm.com>
>
>commit 679db70801da9fda91d26caf13bf5b5ccc74e8e8 upstream
>
>Some CPUs can speculate past an ERET instruction and potentially perform
>speculative accesses to memory before processing the exception return.
>Since the register state is often controlled by a lower privilege level
>at the point of an ERET, this could potentially be used as part of a
>side-channel attack.
>
>This patch emits an SB sequence after each ERET so that speculation is
>held up on exception return.
>
>Signed-off-by: Will Deacon <will.deacon@arm.com>
>[florian: Adjust hyp-entry.S to account for the label
> added change to hyp/entry.S]
>Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

I've queued it up, thanks!

-- 
Thanks,
Sasha
