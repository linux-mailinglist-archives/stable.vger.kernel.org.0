Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 069DB65F63
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 20:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbfGKSR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 14:17:28 -0400
Received: from mga06.intel.com ([134.134.136.31]:32749 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728455AbfGKSR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 14:17:28 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 11:17:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,479,1557212400"; 
   d="scan'208";a="171311484"
Received: from jolivell-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.50.138])
  by orsmga006.jf.intel.com with ESMTP; 11 Jul 2019 11:17:24 -0700
Date:   Thu, 11 Jul 2019 21:17:23 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        "# 4.0+" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tpm: Fix TPM 1.2 Shutdown sequence to
 prevent future TPM" failed to apply to 4.19-stable tree
Message-ID: <20190711181723.ys6g4atsb7sxpzs4@linux.intel.com>
References: <1562844916142167@kroah.com>
 <CAD=FV=XEE1J6Kx28eV_zi8_oV68qQsmKW8Os2A3_ade1KsBFdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=XEE1J6Kx28eV_zi8_oV68qQsmKW8Os2A3_ade1KsBFdg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 11, 2019 at 09:30:25AM -0700, Doug Anderson wrote:
> Hi,
> 
> On Thu, Jul 11, 2019 at 4:35 AM <gregkh@linuxfoundation.org> wrote:
> >
> >
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> >
> > thanks,
> >
> > greg k-h
> >
> > ------------------ original commit in Linus's tree ------------------
> >
> > From db4d8cb9c9f2af71c4d087817160d866ed572cc9 Mon Sep 17 00:00:00 2001
> > From: Vadim Sukhomlinov <sukhomlinov@google.com>
> > Date: Mon, 10 Jun 2019 15:01:18 -0700
> > Subject: [PATCH] tpm: Fix TPM 1.2 Shutdown sequence to prevent future TPM
> >  operations
> 
> Posted at:
> 
> https://lkml.kernel.org/r/20190711162919.23813-1-dianders@chromium.org

Thank you! I usually end up taking care of these myself :-) A rare
occasion. Does this also address 4.4, 4.9 and 4.14 or do they still
need backports of their own?

/Jarkko
