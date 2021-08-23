Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501A83F52A3
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 23:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbhHWVOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 17:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbhHWVOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Aug 2021 17:14:41 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65B7C061575;
        Mon, 23 Aug 2021 14:13:57 -0700 (PDT)
Received: from maud (unknown [IPv6:2600:8800:8c06:1000::c8f3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: alyssa)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 957661F42654;
        Mon, 23 Aug 2021 22:13:52 +0100 (BST)
Date:   Mon, 23 Aug 2021 17:13:45 -0400
From:   Alyssa Rosenzweig <alyssa@collabora.com>
To:     Steven Price <steven.price@arm.com>
Cc:     Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        dri-devel@lists.freedesktop.org, Rob Herring <robh@kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
        Chris Morgan <macromorgan@hotmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH 3/3] drm/panfrost: Clamp lock region to Bifrost minimum
Message-ID: <YSQPiQX8IOkJJSoY@maud>
References: <20210820213117.13050-1-alyssa.rosenzweig@collabora.com>
 <20210820213117.13050-4-alyssa.rosenzweig@collabora.com>
 <818b1a15-ddf4-461b-1d6a-cea539deaf76@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <818b1a15-ddf4-461b-1d6a-cea539deaf76@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > When locking a region, we currently clamp to a PAGE_SIZE as the minimum
> > lock region. While this is valid for Midgard, it is invalid for Bifrost,
> 
> While the spec does seem to state it's invalid for Bifrost - kbase
> didn't bother with a lower clamp for a long time. I actually think this
> is in many ways more of a spec bug: i.e. implementation details of the
> round-up that the hardware does. But it's much safer following the spec
> ;) And it seems like kbase eventually caught up too.

Yeah, makes sense. Should I drop the Cc: stable in that case? If the
issue is purely theoretical.
