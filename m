Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F3018AD62
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 08:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgCSHja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 03:39:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbgCSHja (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 03:39:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2B2420722;
        Thu, 19 Mar 2020 07:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584603569;
        bh=B+kuIQBeqbL5y1IBvD1kqR+vLTh4kU6kglLn21OfosA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=slBOoSo8jU7XWJNyt9HMs/D7BU5N4d1RWZrIl/AtrtSC/WcoQIO4czzdaSRiPFznN
         jR87nNzz6pcQWRv5f/53sFP9ybja1lCun4m25ZukioZGVcLoZgl07Ri1GbYQraNWtn
         Jy6NBOaOFzZYF0WuHE0s2ki/s3IxdldCRotalTZw=
Date:   Thu, 19 Mar 2020 08:39:27 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     stable <stable@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH v1 0/6] Fix device links functional breakage in 4.19.99
Message-ID: <20200319073927.GA3442166@kroah.com>
References: <20200317065452.236670-1-saravanak@google.com>
 <CAGETcx-uZ3YJHCYqFm3so8-woTvL3SSDY2deNonthTetcE+mXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx-uZ3YJHCYqFm3so8-woTvL3SSDY2deNonthTetcE+mXQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 18, 2020 at 12:10:43PM -0700, Saravana Kannan wrote:
> On Mon, Mar 16, 2020 at 11:54 PM Saravana Kannan <saravanak@google.com> wrote:
> >
> > As mentioned in an earlier email thread [1], 4.19.99 broke the ability
> > to create stateful and stateless device links between the same set of
> > devices when it pulled in a valid bug fix [2]. While the fix was valid,
> > it removes a functionality that was present before the bug fix.
> >
> > This patch series attempts to fix that by pulling in more patches from
> > upstream. I've just done compilation testing so far. But wanted to send
> > out a v1 to see if this patch list was acceptable before I fixed up the
> > commit text format to match what's needed for stable mailing list.
> >
> > Some of the patches are new functionality, but for a first pass, it was
> > easier to pull these in than try and fix the conflicts. If these patches
> > are okay to pull into stable, then all I need to do is fix the commit
> > text.
> 
> I took a closer look at all the patches. Everyone of them is a bug fix
> except Patch 4/6. But Patch 4/6 is a fairly minimal change and I think
> it's easier/cleaner to just pick it up too instead of trying to
> resolve merge conflicts in the stable branch.
> 
> 1/6 - Fixes what appears to be a memory leak bug in upstream.
> 2/6 - Fixes error in initial state of the device link if it's created
> under some circumstances.
> 3/6 - Fixes a ref count bug in upstream. Looks like it can lead to memory leaks?
> 4/6 - Adds a minor feature to kick off a probe attempt of a consumer
> 5/6 - Fixes the break in functionality that happened in 4.19.99
> 6/6 - Fixes bug in 5/6 (upstream bug)
> 
> Greg
> 
> Do these patches look okay for you to pull into 4.19 stable? If so,
> please let me know if you need me to send v2 with commit fix up.
> 
> The only fix up needed is to these patches at this point is changing
> "(cherry picked from commit ...)" with "[ Upstream commit ... ]". The
> SHAs themselves are the correct SHAs from upstream.

These all look good to me, now all queued up, thanks.

greg k-h
