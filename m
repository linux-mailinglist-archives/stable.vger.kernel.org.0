Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B2949B6E9
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 15:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1580633AbiAYOvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 09:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1580352AbiAYOsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 09:48:22 -0500
X-Greylist: delayed 535 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 25 Jan 2022 06:48:13 PST
Received: from swift.blarg.de (swift.blarg.de [IPv6:2a01:4f8:c17:52a8::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5CBC0C061401;
        Tue, 25 Jan 2022 06:48:13 -0800 (PST)
Received: by swift.blarg.de (Postfix, from userid 1000)
        id D0BE040E4E; Tue, 25 Jan 2022 15:39:16 +0100 (CET)
Date:   Tue, 25 Jan 2022 15:39:16 +0100
From:   Max Kellermann <max@blarg.de>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     linux-pwm@vger.kernel.org, thierry.reding@gmail.com,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        andrey@lebedev.lt, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] pwm-sun4i: convert "next_period" to local variable
Message-ID: <YfALlLgo3MAcbFrZ@swift.blarg.de>
Mail-Followup-To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>,
        linux-pwm@vger.kernel.org, thierry.reding@gmail.com,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        andrey@lebedev.lt, stable@vger.kernel.org
References: <20220125123429.3490883-1-max.kellermann@gmail.com>
 <20220125143158.qbelqvr5mjq33zay@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220125143158.qbelqvr5mjq33zay@pengutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/01/25 15:31, Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> I think I'd drop this. This isn't a fix worth on it's own to be
> backported and if this is needed for one of the next patches, the stable
> maintainers will notice themselves (and it might be worth to shuffle
> this series to make the fixes come first).

The first two patches are preparation for the third patch, which fixes
the actual bug.

Of course, I could have done everything in one patch, but I thought
splitting the first two out makes review easier.  This way, every step
is almost trivial.

If you want me to fold the three patches into one, I can do that.  But
I can't reorder them (or backport only the bug fix to stable).

Max


