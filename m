Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE35941262C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387171AbhITS4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1384926AbhITSwy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:52:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EB71606A5;
        Mon, 20 Sep 2021 18:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632163487;
        bh=7fU7b/cAIa+MPWF5CIYZiPgVGFO3AZYQ1DrtG9/NlOE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2VGFr1pWZXOVcZooHLan70yYq5H+mYfkijp5TezjAyz/Mu0wW3u16ePnRxGAdDvXa
         BFiCaYxcS7giPgse3l2Lr2Y2HlDZQbwE/xxZLF0uk2MutP18GKwI9Ay+dwhVr2xQRS
         N1hkQZ4vUIEWppnRHm8oHOW7hDloXrv/gIJhpQEg=
Date:   Mon, 20 Sep 2021 20:44:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     open list <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Edwin Peer <edwin.peer@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 118/122] bnxt_en: Fix possible unintended driver
 initiated error recovery
Message-ID: <YUjWnR75ohAfAYeU@kroah.com>
References: <20210920163915.757887582@linuxfoundation.org>
 <20210920163919.680890632@linuxfoundation.org>
 <CACKFLi=a_5Qhr1rRq2gKqmO1su-pwxt3845K1AVjVqq5iOXJ5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACKFLi=a_5Qhr1rRq2gKqmO1su-pwxt3845K1AVjVqq5iOXJ5A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 11:11:39AM -0700, Michael Chan wrote:
> On Mon, Sep 20, 2021 at 10:28 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Michael Chan <michael.chan@broadcom.com>
> >
> > [ Upstream commit 1b2b91831983aeac3adcbb469aa8b0dc71453f89 ]
> >
> 
> Please include this patch as well:
> 
> eca4cf12acda bnxt_en: Fix error recovery regression
> 
> Otherwise, it can cause a regression.  Thanks.

Now added to 5.10 and 5.14, thanks!

greg k-h
