Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B99189DC5
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 15:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgCRO05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 10:26:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726730AbgCRO05 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 10:26:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 348E920772;
        Wed, 18 Mar 2020 14:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584541616;
        bh=szLB4hkX3GaHZXfKQkPKAhD8Np5CPWCO9WbP3dqLyeM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ToymJqFLf0rERhSISWdxufMBYEeq9CeH8k6pRZ4nHgSfApeRN6ny6cFKsGqiPayGC
         pUvXCvLx9U2OBv24zLDWq5ZN42pJAsqnVsvqSx387bKB/4KXsMO5ju3VXAv+f9v5uw
         ljfFwYP9X91LGxS5z6vwFQjtjGMtf4KLJj7oIagA=
Date:   Wed, 18 Mar 2020 15:26:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     Sasha Levin <sashal@kernel.org>, hdanton@sina.com,
        sw@simonwunderlich.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] batman-adv: Don't schedule OGM for
 disabled interface" failed to apply to 4.4-stable tree
Message-ID: <20200318142652.GA2807628@kroah.com>
References: <158436631216439@kroah.com>
 <20200318141750.GD4189@sasha-vm>
 <2953272.8TNtrSRRcZ@bentobox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2953272.8TNtrSRRcZ@bentobox>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 18, 2020 at 03:20:11PM +0100, Sven Eckelmann wrote:
> On Wednesday, 18 March 2020 15:17:50 CET Sasha Levin wrote:
> > >From 8e8ce08198de193e3d21d42e96945216e3d9ac7f Mon Sep 17 00:00:00 2001
> > >From: Sven Eckelmann <sven@narfation.org>
> > >Date: Sun, 16 Feb 2020 13:02:06 +0100
> > >Subject: [PATCH] batman-adv: Don't schedule OGM for disabled interface
> > >
> > >A transmission scheduling for an interface which is currently dropped by
> > >batadv_iv_ogm_iface_disable could still be in progress. The B.A.T.M.A.N. V
> > >is simply cancelling the workqueue item in an synchronous way but this is
> > >not possible with B.A.T.M.A.N. IV because the OGM submissions are
> > >intertwined.
> > >
> > >Instead it has to stop submitting the OGM when it detect that the buffer
> > >pointer is set to NULL.
> [...]
> > Adjusted context and queued up for 4.4.
> 
> There are most likely patches missing again when you only added this single 
> patch. See the 48 patches I've sent yesterday for batman-adv in 4.4.

Yeah, I'll queue these all up later on today, thank you for the series.

greg k-h
