Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680BF3A4643
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 18:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhFKQRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 12:17:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229777AbhFKQRu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Jun 2021 12:17:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5E89613FA;
        Fri, 11 Jun 2021 16:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623428153;
        bh=YiYpJNUg9BYo4kr14KGWtZE8xExSKreex7tA6JY7YPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0Rz1rRGyPf41M6/GhRjgql4yAhlqJaL95cBxwAO0Txm5mCnw7NNJraSqncmnhxBb
         imyoGRCiOYBkAB3wsayYOP3qneLKgbFehOdjgFjmaY+HFNDy0alFWNTbWWD+9aLyMw
         u35N4r8h4icaKv/LEkPpJ7y9S+QaZYF6iw1jFDripgxUotrh8fjXqcMTcMT81z+Eus
         F6Mug06N5nW4eDo4ODFVmtFlx3fbhSaWe1MR1y6yYNWCx2njTSYM03DKL7t5ck8cZs
         dmRveMYFRNcv6EUdl5rLrZHcGTyP1ehy4muFF1nd7TclprpMpTQP3KvvKNJzblJnv1
         zIZeWpIHNkNuQ==
From:   Will Deacon <will@kernel.org>
To:     Robin Murphy <robin.murphy@arm.com>, mark.rutland@arm.com
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] perf/smmuv3: Don't trample existing events with global filter
Date:   Fri, 11 Jun 2021 17:15:41 +0100
Message-Id: <162340653067.3037866.6533917282027835932.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <32c80c0e46237f49ad8da0c9f8864e13c4a803aa.1623153312.git.robin.murphy@arm.com>
References: <32c80c0e46237f49ad8da0c9f8864e13c4a803aa.1623153312.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 8 Jun 2021 12:55:12 +0100, Robin Murphy wrote:
> With global filtering, we only allow an event to be scheduled if its
> filter settings exactly match those of any existing events, therefore
> it is pointless to reapply the filter in that case. Much worse, though,
> is that in doing that we trample the event type of counter 0 if it's
> already active, and never touch the appropriate PMEVTYPERn so the new
> event is likely not counting the right thing either. Don't do that.

Applied to will (for-next/perf), thanks!

[1/1] perf/smmuv3: Don't trample existing events with global filter
      https://git.kernel.org/will/c/4c1daba15c20

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
