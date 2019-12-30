Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 202FF12D079
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 15:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfL3OBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 09:01:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:40646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727445AbfL3OBz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Dec 2019 09:01:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E11AE20663;
        Mon, 30 Dec 2019 14:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577714514;
        bh=kJaDxR/b4tcSFMfAnbqXDtmvjXP9Yj4aZyya3n8Q2BA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZVmXKhfl3j/8D6EbZUxN3ph50PC9cQqQ+e0QFwQLBNNZnE7xZkTfqdTOaz4R08889
         Ss6OaKlv9/P42S76anu03npPCRDA+FDE3ApO0afZWxXTtkj+2ChyQSxUXe8Yt9UQKW
         nNURjWZM9hXo9c9rtwv9JpVf97uCAwDDYW5V33Jw=
Date:   Mon, 30 Dec 2019 15:01:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kai Vehmanen <kai.vehmanen@linux.intel.com>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 102/219] ALSA: hda/hdmi - implement
 mst_no_extra_pcms flag
Message-ID: <20191230140152.GA1054989@kroah.com>
References: <20191229162508.458551679@linuxfoundation.org>
 <20191229162523.844585380@linuxfoundation.org>
 <20191230113214.GB10304@amd>
 <alpine.DEB.2.21.1912301453150.16459@zeliteleevi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1912301453150.16459@zeliteleevi>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 30, 2019 at 02:58:25PM +0200, Kai Vehmanen wrote:
> Hi,
> 
> On Mon, 30 Dec 2019, Pavel Machek wrote:
> 
> > > From: Kai Vehmanen <kai.vehmanen@linux.intel.com>
> > > 
> > > [ Upstream commit 2a2edfbbfee47947dd05f5860c66c0e80ee5e09d ]
> > > 
> > > To support the DP-MST multiple streams via single connector feature,
> > > the HDMI driver was extended with the concept of backup PCMs. See
> > > commit 9152085defb6 ("ALSA: hda - add DP MST audio support").
> [...]
> > This variable is not ever set in this patch, nor is it set elsewhere
> > in 4.19-stable. This means this patch is not suitable for stable.
> 
> ack on that. In upstream this flag is only used by SOF (sound/soc/sof)
> currently, but SOF is not part of 4.19, so there are no users for this 
> flag. Sorry for not catching this sooner.

Will go drop it from 4.19.y, thanks.  But is this ok also for 5.4.y?

thanks,

greg k-h
