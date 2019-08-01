Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA6D7DC0A
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 15:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfHANBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 09:01:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbfHANBc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Aug 2019 09:01:32 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A3C320838;
        Thu,  1 Aug 2019 13:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564664491;
        bh=HG3nrkOsqHLSX0CwQdBhFk28USlDFv5Mq7fZhTnTprU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dmvTMafni34bd7yf1rJvAVkmnzWABTcmbQnd61qYYhfM48ImM37PFXDSMJs5D/257
         0pfOVPlT5HbvyHHymc2odA9jsoLEPBZxJSlH2cIfMoaxT+0Re/r6O8n0CE4R2TPl0a
         PDGDFnb0bo7ljCO7stOUDnmOwity/6yMln35hs7c=
Date:   Thu, 1 Aug 2019 14:01:26 +0100
From:   Will Deacon <will@kernel.org>
To:     Julien Thierry <julien.thierry@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com,
        peterz@infradead.org, jolsa@redhat.com, will.deacon@arm.com,
        Russell King <linux@armlinux.org.uk>, acme@kernel.org,
        alexander.shishkin@linux.intel.com, mingo@redhat.com,
        stable@vger.kernel.org, namhyung@kernel.org, sthotton@marvell.com,
        liwei391@huawei.com
Subject: Re: [PATCH v4 3/9] arm: perf: save/resore pmsel
Message-ID: <20190801130126.xxsot2mabvisq76e@willie-the-truck>
References: <1563351432-55652-1-git-send-email-julien.thierry@arm.com>
 <1563351432-55652-4-git-send-email-julien.thierry@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563351432-55652-4-git-send-email-julien.thierry@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[typo in subject: resore ->restore]

On Wed, Jul 17, 2019 at 09:17:06AM +0100, Julien Thierry wrote:
> The callback pmu->read() can be called with interrupts enabled.
> Currently, on ARM, this can cause the following callchain:
> 
> armpmu_read() -> armpmu_event_update() -> armv7pmu_read_counter()

Why can't we just disable irqs in armv7pmu_read_counter() ?

Will
