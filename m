Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C98391561
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 12:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234219AbhEZKwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 06:52:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234215AbhEZKwh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 May 2021 06:52:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22B74613D8;
        Wed, 26 May 2021 10:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622026266;
        bh=S9/pAYFIAyH3CJvdhr0NwqSNGC3fJicd7BJ2pjYbvPA=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=FeiU9VWzXwgElY7tn01m8NmxVq7xFXgMpI1g2rr1o7durQr5Qncrx5luZxH8IW3Hr
         ahkP3oBPNs8ZYKg7zFqZiGTBonEdoZln2YDV3VlzaXyPhYcrRlBoT+5ErTFnobxnw8
         OsWMSWjuk6Jz7ACW5jvMty2bJkP3pJDwKGMJDZiws+42phGDLx7BSKk1fUZ1UhTluO
         dF0i9+YurklDHg3AYzOEPW4EKknns4VtwbN0b98szOYfqnp2wopG2I/Kd6ZKtsZdgR
         DrEzPJUBVwTRhp/bGLFFmIxkZ36BmtLLThDS+4pYLf+nBgn4yKjPwmOOKTEvI60xJT
         dOyeJBrgIN3nw==
Date:   Wed, 26 May 2021 12:51:03 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Johan Hovold <johan@kernel.org>
cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+ee6f6e2e68886ca256a8@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Claudio Mettler <claudio@ponyfleisch.ch>,
        Marek Wyborski <marek.wyborski@emwesoft.com>,
        Sean O'Brien <seobrien@chromium.org>
Subject: Re: [PATCH] HID: magicmouse: fix NULL-deref on disconnect
In-Reply-To: <20210517100430.20509-1-johan@kernel.org>
Message-ID: <nycvar.YFH.7.76.2105261250560.28378@cbobk.fhfr.pm>
References: <20210517100430.20509-1-johan@kernel.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 17 May 2021, Johan Hovold wrote:

> Commit 9d7b18668956 ("HID: magicmouse: add support for Apple Magic
> Trackpad 2") added a sanity check for an Apple trackpad but returned
> success instead of -ENODEV when the check failed. This means that the
> remove callback will dereference the never-initialised driver data
> pointer when the driver is later unbound (e.g. on USB disconnect).
> 
> Reported-by: syzbot+ee6f6e2e68886ca256a8@syzkaller.appspotmail.com
> Fixes: 9d7b18668956 ("HID: magicmouse: add support for Apple Magic Trackpad 2")
> Cc: stable@vger.kernel.org      # 4.20
> Cc: Claudio Mettler <claudio@ponyfleisch.ch>
> Cc: Marek Wyborski <marek.wyborski@emwesoft.com>
> Cc: Sean O'Brien <seobrien@chromium.org>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Applied, thanks Johan.

-- 
Jiri Kosina
SUSE Labs

