Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA15D1F968C
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 14:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgFOMa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 08:30:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729937AbgFOMa6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 08:30:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F4502070E;
        Mon, 15 Jun 2020 12:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592224257;
        bh=x0EHUi1wwNz+5Z7VGhNFUq1TJbQI2kLDGwX/Aty0iWE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=175NhJ+A6R7jkjPnZlw1DiDk4LPP6NIXGQ3qpAYcPnpfv+c3kBjoVqX+SdKFphRRH
         msRPSBwnggLfGrShWmMtWhLF7l6QqJn1nuJkqwQ7s+IsIYjUPr0BE+p51oNNJy7ob5
         Vrmv3IYzFcmPAIbMTrQOzak5v0v/PQVTK3SdFVpw=
Date:   Mon, 15 Jun 2020 14:30:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Avi Kivity <avi@scylladb.com>
Cc:     stable@vger.kernel.org
Subject: Re: Backport status of "aio: fix async fsync creds"
 (530f32fc370fd1431ea9802dbc53ab5601dfccdb)
Message-ID: <20200615123045.GA615921@kroah.com>
References: <a88009bc-dcea-eaee-7fe9-943bc8aae781@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a88009bc-dcea-eaee-7fe9-943bc8aae781@scylladb.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 08:27:22AM +0300, Avi Kivity wrote:
> Commit "aio: fix async fsync creds"
> (530f32fc370fd1431ea9802dbc53ab5601dfccdb) was committed for v5.8-rc1, but I
> don't see it in any stable branches or rc queues (it is marked for 4.18+).
> Did it slip through the cracks? Or is it on some other queue?

It had to wait until 5.8-rc1 was out before I could take it into a
stable release.  That just happened a few hours ago, and now I have 250+
patches to dig through that people decided to push in the -rc1 cycle,
yet are valid for stable trees...

I'll go queue this up now, but note that this just take longer during
the -rc1 cycle, and if you need it into a stable tree sooner, please let
us know.

thanks,

greg k-h
