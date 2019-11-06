Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3B2EF1A93
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 16:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbfKFP6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 10:58:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:59742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbfKFP6u (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 10:58:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10F772178F;
        Wed,  6 Nov 2019 15:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573055929;
        bh=4FyKc4th4BQusUcTvnbsyi6qnO2PL7eBet+jEw0skR8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wb8lrfFg9yZVzTNUaIXoHBePHJgSgfEeSl8w2mObAgYBOiYuDckHC25vjifSU82Mu
         NQQwioMoxF9veqdqpn8y/e221Tar5GdcljSgc14iSmRVxnE0+Y1Gl7hhgU4v5M8X9N
         F6Qts2cBt4bJQxHI03zTgGDiMgzSZJ7UJzK5aopA=
Date:   Wed, 6 Nov 2019 16:58:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Amit Klein <aksecurity@gmail.com>, Benny Pinkas <benny@pinkas.net>,
        David Miller <davem@davemloft.net>, jonathann1@walla.com,
        Tom Herbert <tom@herbertland.com>, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] net/flow_dissector: switch to siphash"
 failed to apply to 4.4-stable tree
Message-ID: <20191106155846.GA3803662@kroah.com>
References: <1573054955217129@kroah.com>
 <CANn89iK=PdiKW8whW7NECFXGKGU44Xjoka_vTwMGUBoiU_Wysw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iK=PdiKW8whW7NECFXGKGU44Xjoka_vTwMGUBoiU_Wysw@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 06, 2019 at 07:48:00AM -0800, Eric Dumazet wrote:
> Thanks Greg.
> 
> We definitely want to backport this fix to all relevant kernels, I
> will work on these backports soon.

Wonderful, thanks!

greg k-h
