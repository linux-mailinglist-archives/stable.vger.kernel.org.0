Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05D68261A4
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 12:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728438AbfEVKWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 06:22:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728690AbfEVKWR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 06:22:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5E4120868;
        Wed, 22 May 2019 10:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558520537;
        bh=GdVU8GXj/HLCpx/uNFanJPSI3OHYWjhnKshjuhSeYiQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jkzNzJsy0qnUt0AwFLgYQ8j+QnVLy5Ofd9RRWwDQjw7s9ny2XWafHhGOkjXFa+Glb
         l2ywDRo1impStZLVvQMvtBmwvs1QxkOvn8ONkTACdh8lrG4NrGzbFpn6NKw5Jdd6Oa
         Z06PsV3uDS5oCn2IrQ55woNRAVfqFBasVml6uy40=
Date:   Wed, 22 May 2019 12:22:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jeremy Soller <jeremy@system76.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 4.19 038/105] ALSA: hdea/realtek - Headset fixup for
 System76 Gazelle (gaze14)
Message-ID: <20190522102214.GB6721@kroah.com>
References: <20190520115247.060821231@linuxfoundation.org>
 <20190520115249.657128023@linuxfoundation.org>
 <20190522091506.GC8174@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522091506.GC8174@amd>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 22, 2019 at 11:15:07AM +0200, Pavel Machek wrote:
> On Mon 2019-05-20 14:13:44, Greg Kroah-Hartman wrote:
> > From: Jeremy Soller <jeremy@system76.com>
> > 
> > commit 80a5052db75131423b67f38b21958555d7d970e4 upstream.
> > 
> > On the System76 Gazelle (gaze14), there is a headset microphone input
> > attached to 0x1a that does not have a jack detect. In order to get it
> > working, the pin configuration needs to be set correctly, and the
> > ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC fixup needs to be applied. This is
> > identical to the patch already applied for the System76 Darter Pro
> > (darp5).
> 
> Commit 89/ of the series fixes up this patch. Perhaps those two should
> be merged together?

Again, no, that is not how the stable kernel series has ever worked.

greg k-h
