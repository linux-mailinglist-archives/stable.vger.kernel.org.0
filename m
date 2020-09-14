Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249802686A8
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 09:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgINH7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 03:59:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbgINH67 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 03:58:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2459E20829;
        Mon, 14 Sep 2020 07:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600070338;
        bh=gOckBU/C3tkEKhzQbfY7Y+yhZEKq+qqNfBzi4OkB38M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=USGIaH6+9IJ8iO6KUmeLFYLTUFYms0t4YbAu8y0Be1K4oFHJaBds2UnctLOP/xQ8q
         wgQnT6v6FZ4/S/RIlNrG2BgHAp/Yb2hkL9ZWAFltUoS/HFRT8VVeG1Ieco++3s38/9
         K9JXpK/LfryKf9exufq0kz+Hs8KrfSMyHhqbieMc=
Date:   Mon, 14 Sep 2020 09:58:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 4.19 1/8] ALSA; firewire-tascam: exclude Tascam FE-8 from
 detection
Message-ID: <20200914075858.GA1035258@kroah.com>
References: <20200911125421.695645838@linuxfoundation.org>
 <20200911125421.771196664@linuxfoundation.org>
 <20200914074731.GA11659@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914074731.GA11659@amd>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 14, 2020 at 09:47:31AM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
> > 
> > Tascam FE-8 is known to support communication by asynchronous transaction
> > only. The support can be implemented in userspace application and
> > snd-firewire-ctl-services project has the support. However, ALSA
> > firewire-tascam driver is bound to the model.
> 
> This one is in upstream, but is not marked as such. AFAICT it is
> 0bd8bce897b6697bbc286b8ba473aa0705fe394b.
> 
> Unfortunately it is too late to fix that now.
> 
> This one was scheduled to be released at "Responses should be made by
> Sun, 13 Sep 2020 12:54:13 +0000.". But it was released day earlier:
> "Date: Sat, 12 Sep 2020 14:42:49 +0200".
> 
> Could you actually follow published schedule?

If all of the reported testing systems come back successful, there is no
need to wait any longer.

> Could you cc me release announcements on pavel@denx.de email?

Will add you to the list, thanks.

greg k-h
