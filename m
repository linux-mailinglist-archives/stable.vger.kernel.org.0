Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7DBB1AA8F5
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636224AbgDONp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:45:29 -0400
Received: from mga05.intel.com ([192.55.52.43]:13110 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2636218AbgDONp0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 09:45:26 -0400
IronPort-SDR: D3aXQ0Vqs6GXWhRYY5vzc3TR+S8QozTmEkda9eVsFpxSC/QOJ4xeayYCLPcxjYCf0apCx/9ENI
 HLPC3oPcsdUg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 06:45:23 -0700
IronPort-SDR: QzA+CqihMFTrByvNRfgRQYI2s01miNNfXdQvVpnl11aLRUWZGBc7aGTDATaiQ1w/ZvPM3qqme3
 scseqzhpF5lw==
X-IronPort-AV: E=Sophos;i="5.72,387,1580803200"; 
   d="scan'208";a="363673560"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 06:45:22 -0700
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 3ABF620606; Wed, 15 Apr 2020 16:45:20 +0300 (EEST)
Date:   Wed, 15 Apr 2020 16:45:20 +0300
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, david@unsolicited.net,
        hans.verkuil@cisco.com, linux@roeck-us.net,
        mchehab@osg.samsung.com, stable-commits@vger.kernel.org
Subject: Re: Patch "Revert "[media] videobuf2-v4l2: Verify planes array in
 buffer dequeueing"" has been added to the 4.4-stable tree
Message-ID: <20200415134520.GE27762@paasikivi.fi.intel.com>
References: <158694575418840@kroah.com>
 <20200415131412.GD27762@paasikivi.fi.intel.com>
 <20200415132742.GA3461248@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415132742.GA3461248@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 03:27:42PM +0200, Greg KH wrote:
> On Wed, Apr 15, 2020 at 04:14:12PM +0300, Sakari Ailus wrote:
> > Hi Greg,
> > 
> > On Wed, Apr 15, 2020 at 12:15:54PM +0200, gregkh@linuxfoundation.org wrote:
> > > 
> > > This is a note to let you know that I've just added the patch titled
> > > 
> > >     Revert "[media] videobuf2-v4l2: Verify planes array in buffer dequeueing"
> > > 
> > > to the 4.4-stable tree which can be found at:
> > >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > > 
> > > The filename of the patch is:
> > >      revert-videobuf2-v4l2-verify-planes-array-in-buffer-dequeueing.patch
> > > and it can be found in the queue-4.4 subdirectory.
> > > 
> > > If you, or anyone else, feels it should not be added to the stable tree,
> > > please let <stable@vger.kernel.org> know about it.
> > > 
> > > 
> > > From 93f0750dcdaed083d6209b01e952e98ca730db66 Mon Sep 17 00:00:00 2001
> > > From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > > Date: Wed, 11 May 2016 13:09:34 -0300
> > > Subject: Revert "[media] videobuf2-v4l2: Verify planes array in buffer dequeueing"
> > > 
> > > From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > > 
> > > commit 93f0750dcdaed083d6209b01e952e98ca730db66 upstream.
> > 
> > This patch has been already applied to the 4.4-stable tree --- and the
> > original has been re-applied as well, just as in upstream.
> > 
> > The original revert was done because another patch was missing the tree
> > (commit 93f0750dcdaed083d6209b01e952e98ca730db66 upstream), not because
> > there was a problem with the patch itself.
> > 
> > In other words, this patch must be dropped.
> 
> Really?
> 
> This is a mess.  I see the following commits in the stable 4.4 tree:
> 
> In the 4.4.9 release the following upstream commit was backported:
> 	2c1f6951a8a8 ("[media] videobuf2-v4l2: Verify planes array in buffer dequeueing")
> 
> then in 4.4.11 it was reverted by backporting:
> 	93f0750dcdae ("Revert "[media] videobuf2-v4l2: Verify planes array in buffer dequeueing"")
> 
> Then finally, in 4.4.19 this commit gets added:
> 	83934b75c368 ("[media] videobuf2-v4l2: Verify planes array in buffer dequeueing")
> 
> So, is 83934b75c368 ok to backport, but 2c1f6951a8a8 was not?

Both are backports of separate patches in upstream, and should be in the
stable trees as they are at the moment (I checked 4.4). This all happened
back in 2016 but now this revert popped up four years later.

> 
> Because they look identical to me...

They are the same patch that got applied twice with a revert in between.

> 
> So, what am I missing here?

The fix was originally reverted due to an issue in the API usage in DVB,
and then re-applied with another fix in videobuf2 core. The discussion is
here, and all these patches ended up being applied:

<URL:https://www.spinics.net/lists/linux-media/msg99334.html>
<URL:https://www.spinics.net/lists/linux-media/msg100428.html>
<URL:https://www.spinics.net/lists/linux-media/msg100458.html>

Applying this revert re-introduces the original kernel memory overwriting
bug.

-- 
Kind regards,

Sakari Ailus
