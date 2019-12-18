Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 746B0124C5A
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 17:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfLRQDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 11:03:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:43464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727185AbfLRQDM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 11:03:12 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 831572146E;
        Wed, 18 Dec 2019 16:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576684991;
        bh=u8m+Lwq31qWhD0UzfhyK67aiuxro10wEUtknWSR8HnU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kUqZCG1mRrcc3nw1pAQnYsw/f6WB+r4UNW+pU21vUcKd5qoQ9DA+R9hKj3g758nrl
         6xA4kWlY1k4caNhXJatK+tejDtvcClFuya2OlTtxIBplp6DQY5+/p430IOX2N7S05+
         KUuFX9vu7lXNwd1vBdQWgcFQNpAYOMxdIOe9oUjA=
Date:   Wed, 18 Dec 2019 16:03:06 +0000
From:   Will Deacon <will@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "kernelci.org bot" <bot@kernelci.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 4.19 031/219] arm64: preempt: Fix big-endian when
 checking preempt count in assembly
Message-ID: <20191218160305.GA16411@willie-the-truck>
References: <20191122054911.1750-1-sashal@kernel.org>
 <20191122054911.1750-24-sashal@kernel.org>
 <20191214021403.GA1357@home.goodmis.org>
 <20191216094523.GA9938@willie-the-truck>
 <20191218104001.2b2773b7@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218104001.2b2773b7@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 18, 2019 at 10:40:01AM -0500, Steven Rostedt wrote:
> On Mon, 16 Dec 2019 09:45:24 +0000
> Will Deacon <will@kernel.org> wrote:
> 
> > Yup, without 396244692232 this commit makes no sense. That's why I didn't CC
> > stable or add a Fixes tag :(
> 
> I'm wondering if we should add a tag to state "not to be backported",
> to tell auto select to ignore a patch that appears to be a fix.

I'd be in favour of that!

Will
