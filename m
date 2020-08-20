Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D180024B58B
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730492AbgHTKZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:25:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730638AbgHTKZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:25:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2BEB20738;
        Thu, 20 Aug 2020 10:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597919104;
        bh=9oYax7Vp/sAADx+saTCkAJutmFw9MX576JS3dAW94qk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v49FYdt+kCIo6yhXddlU3h1I6OicKBQuGqQ3W79GZIj9LChc1S4y8caYW1CC2haEj
         dmqcZQjru+Pd1WrjLObbmK/Z8/g70DH9g6VYW8SXca9uzXEcHmLAALrsrSiy0RFBsy
         UtXnV1Zc9x+ybOoC4S/ZvkJtcb0xf7+RGfXgJgbo=
Date:   Thu, 20 Aug 2020 11:56:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.8 137/232] USB: serial: ftdi_sio: fix break and sysrq
 handling
Message-ID: <20200820095652.GA1266907@kroah.com>
References: <20200820091612.692383444@linuxfoundation.org>
 <20200820091619.460392380@linuxfoundation.org>
 <CAMgPeKX54WqE0Wc56u6W3M2JwttV=E7sBKmM5eRa5_Mu7m+okg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMgPeKX54WqE0Wc56u6W3M2JwttV=E7sBKmM5eRa5_Mu7m+okg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 11:51:56AM +0200, Johan Hovold wrote:
> This was never intended for stable as it is not a critical fix and has
> never worked properly in the first place. Please drop this one and the
> preparatory clean ups from all stable trees.

Ok, but the "fix this thing" and the "Fixes:" tag really did imply this
was actually fixing something :)

I'll drop it from everywhere, thanks.

greg k-h
