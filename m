Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B06D664BE
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 04:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbfGLC5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 22:57:10 -0400
Received: from mga07.intel.com ([134.134.136.100]:3302 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728497AbfGLC5K (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 22:57:10 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 19:57:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,480,1557212400"; 
   d="scan'208";a="174333205"
Received: from gonegri-mobl.ger.corp.intel.com (HELO localhost) ([10.252.48.192])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Jul 2019 19:57:07 -0700
Date:   Fri, 12 Jul 2019 05:57:06 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        "# 4.0+" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tpm: Fix TPM 1.2 Shutdown sequence to
 prevent future TPM" failed to apply to 4.19-stable tree
Message-ID: <20190712025706.2psp65fippc67c2p@linux.intel.com>
References: <1562844916142167@kroah.com>
 <CAD=FV=XEE1J6Kx28eV_zi8_oV68qQsmKW8Os2A3_ade1KsBFdg@mail.gmail.com>
 <20190711181723.ys6g4atsb7sxpzs4@linux.intel.com>
 <CAD=FV=UCqRpSsMpastf8K9nZukST6h8qjn2ofAQsJU00EyW5EA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=UCqRpSsMpastf8K9nZukST6h8qjn2ofAQsJU00EyW5EA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 11, 2019 at 11:49:10AM -0700, Doug Anderson wrote:
> Hi,
> 
> On Thu, Jul 11, 2019 at 11:17 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > On Thu, Jul 11, 2019 at 09:30:25AM -0700, Doug Anderson wrote:
> > > Hi,
> > >
> > > On Thu, Jul 11, 2019 at 4:35 AM <gregkh@linuxfoundation.org> wrote:
> > > >
> > > >
> > > > The patch below does not apply to the 4.19-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > > >
> > > > ------------------ original commit in Linus's tree ------------------
> > > >
> > > > From db4d8cb9c9f2af71c4d087817160d866ed572cc9 Mon Sep 17 00:00:00 2001
> > > > From: Vadim Sukhomlinov <sukhomlinov@google.com>
> > > > Date: Mon, 10 Jun 2019 15:01:18 -0700
> > > > Subject: [PATCH] tpm: Fix TPM 1.2 Shutdown sequence to prevent future TPM
> > > >  operations
> > >
> > > Posted at:
> > >
> > > https://lkml.kernel.org/r/20190711162919.23813-1-dianders@chromium.org
> >
> > Thank you! I usually end up taking care of these myself :-) A rare
> > occasion. Does this also address 4.4, 4.9 and 4.14 or do they still
> > need backports of their own?
> 
> In Chrome OS we have the same solution for 4.14.
> 
> This patch will _definitely_ not apply cleanly for 4.4.  Not sure what
> the best course of action is there, but in the "after the cut" notes
> in my post I talk about it a little bit.
> 
> On 4.9 things look similar-ish, but I don't know quite enough to know
> if it will work well there.
> 
> (all of this in the context that apparently some extra locking patches
> even for 4.14 and 4.19--see the thread in response to my posted
> patch).

OK, I'll look at those when I come back from leave after two weeks.

/Jarkko
