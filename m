Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506023027A9
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 17:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730643AbhAYQVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 11:21:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:44860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730701AbhAYQUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 11:20:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DA36229C5;
        Mon, 25 Jan 2021 16:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611591583;
        bh=n5aTC3RmtiMMWoLmz7O7uGQmR24wpmt1emfkffIc9/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r/UgFltPhL7Aot3gfUYeWFC92Iuj0YFkdwm8xrwUOM3fv4eUd0RhEenJrXqJDLlFQ
         h7p3x+4Fe5l9OyD6rqpbxo9V0KbwuX4A+Zoi30mCKhLnWEB45xSfT1TAG3dxFGbyYd
         T3sMobgj5m5n0Z9A/8+LybdXxIeglIajwa3tOlgw=
Date:   Mon, 25 Jan 2021 17:19:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        LinusW <linus.walleij@linaro.org>,
        Maulik Shah <mkshah@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        "# 4.0+" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] pinctrl: qcom: Properly clear
 "intr_ack_high" interrupts when" failed to apply to 5.10-stable tree
Message-ID: <YA7vnYj8PJpTntvN@kroah.com>
References: <1611585674115135@kroah.com>
 <CAD=FV=Vx02dQ2icjt7D3gC7ew=m27ZMKKhE1jsYD4hcFcwwN8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=Vx02dQ2icjt7D3gC7ew=m27ZMKKhE1jsYD4hcFcwwN8g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 25, 2021 at 08:11:15AM -0800, Doug Anderson wrote:
> Hi,
> 
> On Mon, Jan 25, 2021 at 6:41 AM <gregkh@linuxfoundation.org> wrote:
> >
> >
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> >
> > thanks,
> >
> > greg k-h
> >
> > ------------------ original commit in Linus's tree ------------------
> >
> > From a95881d6aa2c000e3649f27a1a7329cf356e6bb3 Mon Sep 17 00:00:00 2001
> > From: Douglas Anderson <dianders@chromium.org>
> > Date: Thu, 14 Jan 2021 19:16:23 -0800
> > Subject: [PATCH] pinctrl: qcom: Properly clear "intr_ack_high" interrupts when
> >  unmasking
> 
> For 5.10, we should just take these 4 patches:
> 
> cf9d052aa600 pinctrl: qcom: Don't clear pending interrupts when enabling
> a95881d6aa2c pinctrl: qcom: Properly clear "intr_ack_high" interrupts
> when unmasking
> 4079d35fa4fc pinctrl: qcom: No need to read-modify-write the interrupt status
> a82e537807d5 pinctrl: qcom: Allow SoCs to specify a GPIO function that's not 0
> 
> If we apply all 4 together we should be good and no backport should be needed.

That worked, thanks!

greg k-h
