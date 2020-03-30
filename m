Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE7F819811B
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 18:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgC3QX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 12:23:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728708AbgC3QX6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 12:23:58 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 700F6206CC;
        Mon, 30 Mar 2020 16:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585585437;
        bh=B16m0Ow773Aqt4Qa1Tz8oIJFgNSYnnbreOBbAtbj1TE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ALdimsSjD+8ZuMxjCyejq9LaubNn4niiZn/BBj6zc00nY86kzolBYNOlXXzgp3Vwq
         rJD/6moM7Oc7jMeVQ1gr0/5tku4c3slQ/4Uvw0VCpAiZ+mEkp2DhNnqEQyoIn9uH0i
         2kV39z5cedZYZscRkdnZY5Ah/l6OdMzq870hvKzE=
Date:   Mon, 30 Mar 2020 12:23:56 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     johannes.berg@intel.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] mac80211: set
 IEEE80211_TX_CTRL_PORT_CTRL_PROTO for nl80211" failed to apply to
 4.19-stable tree
Message-ID: <20200330162356.GJ4189@sasha-vm>
References: <158557523660185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158557523660185@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 30, 2020 at 03:33:56PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From b95d2ccd2ccb834394d50347d0e40dc38a954e4a Mon Sep 17 00:00:00 2001
>From: Johannes Berg <johannes.berg@intel.com>
>Date: Thu, 26 Mar 2020 15:53:34 +0100
>Subject: [PATCH] mac80211: set IEEE80211_TX_CTRL_PORT_CTRL_PROTO for nl80211
> TX
>
>When a frame is transmitted via the nl80211 TX rather than as a
>normal frame, IEEE80211_TX_CTRL_PORT_CTRL_PROTO wasn't set and
>this will lead to wrong decisions (rate control etc.) being made
>about the frame; fix this.
>
>Fixes: 911806491425 ("mac80211: Add support for tx_control_port")
>Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>Link: https://lore.kernel.org/r/20200326155333.f183f52b02f0.I4054e2a8c11c2ddcb795a0103c87be3538690243@changeid
>Signed-off-by: Johannes Berg <johannes.berg@intel.com>

I've also grabbed 060167729a78 ("mac80211: add option for setting
control flags") for 4.19.

-- 
Thanks,
Sasha
