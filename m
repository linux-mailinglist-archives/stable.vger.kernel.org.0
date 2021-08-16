Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304433EDAE6
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 18:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhHPQ17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 12:27:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229600AbhHPQ17 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 12:27:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B54D560EFE;
        Mon, 16 Aug 2021 16:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629131247;
        bh=1tOBKC+BcqO+IMMQrhJvbD/6/7Y5GdWstRFZfvynHec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sRMxGLxmMlbPDo9m3q0yMIZpa1bvfp2Pn8COvTEG3MNdOX0upUQW787vDiqHqbrTs
         sR3ui5HCxWXy46yLtcXa/r85eRuAWymqbIvEDY+Lgh0oHHNLvtPfSLr5pAIutEfRmM
         XNQEq2s1LHW+6qlkED59hj38HMckieK7Fj5WTmfU=
Date:   Mon, 16 Aug 2021 18:27:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@essensium.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 52/96] net: dsa: microchip: ksz8795: Fix VLAN
 filtering
Message-ID: <YRqR7NFWJmhFR9/d@kroah.com>
References: <20210816125434.948010115@linuxfoundation.org>
 <20210816125436.688497376@linuxfoundation.org>
 <20210816132858.GC18930@cephalopod>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816132858.GC18930@cephalopod>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 03:28:58PM +0200, Ben Hutchings wrote:
> On Mon, Aug 16, 2021 at 03:02:02PM +0200, Greg Kroah-Hartman wrote:
> > From: Ben Hutchings <ben.hutchings@mind.be>
> > 
> > [ Upstream commit 164844135a3f215d3018ee9d6875336beb942413 ]
> 
> This will probably work on its own, but it was tested as part of a
> series of changes to VLAN handling in the driver.  Since I initially
> developed and tested that on top of 5.10-stable, I would prefer to
> send you the complete series to apply together.

What is the "complete series"?  We have 7 patches for this driver in
this round of kernel rc reviews.  What specific git ids are you
referring to?

thanks,

greg k-h
