Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6A63FB5E3
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 14:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236926AbhH3MS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 08:18:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236721AbhH3MSv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Aug 2021 08:18:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98CA560E77;
        Mon, 30 Aug 2021 12:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630325877;
        bh=Dj+5yK8xpFom0mCcZ7jfHLC+VMnh/en5i7qChO92frY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RfxnPzOqNMUipBFtamdNjXUyKphDTUVdbyQpodkhoYbs7kHS8CdJykSsn6VtHn1KC
         wEDW+t50EQVgwAR5iKt7MuwGJWFMl6bWXWJu4dtwwEew070HWnhJssrCSWTxLE0UMM
         e+PE4A7rRPrAFbr1eyOx5/ke3ZVWFN0AuhpanAkndBMmwl6gFrGC22cd3n92AP4kSP
         rCI9j00lg7c+Ph91T3ppKbgJCT0VTtgcT/aRe07zNCjNXmnlqi2+ooNzzgytBndvmO
         G8VPw2B543LXFzBXQCs4Ccyx4LVv0ZNK5Nqb2rA7RXnUob133dw7d1LU+EUvxSB+DE
         3xn4JBnvg+YWQ==
Date:   Mon, 30 Aug 2021 08:17:56 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Lyude Paul <lyude@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: Re: [PATCH AUTOSEL 4.14 6/7] drm/nouveau: block a bunch of classes
 from userspace
Message-ID: <YSzMdH4E1jIJd5Ed@sashalap>
References: <20210824005528.631702-1-sashal@kernel.org>
 <20210824005528.631702-6-sashal@kernel.org>
 <75ccbdea6e8871856002edb75dff1a32822a5a89.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <75ccbdea6e8871856002edb75dff1a32822a5a89.camel@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 24, 2021 at 01:05:32PM -0400, Lyude Paul wrote:
>This isn't at all intended to be a fix to be backported, so I don't think this
>should be included. I don't know about 5/7, but I'll let Benjamin comment on
>that one

I'll drop it, thanks!

-- 
Thanks,
Sasha
