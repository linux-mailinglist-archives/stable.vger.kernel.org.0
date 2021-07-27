Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8F73D7A10
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 17:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhG0Po4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 11:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhG0Poz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 11:44:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B40A61B4C;
        Tue, 27 Jul 2021 15:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627400695;
        bh=U9Ey5WBIG5f6bJjhLgKtlvudACqfIYt7Lu5MJlwErqE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gsTk6DgXcgVIsDdN7jwDiku1iqcvaeuFfZUbO5xksfC6rDNXvD5nF5IcEt2ZNGj3U
         CZVdwiKQ79YtdtdrwjcHc9pTWwjq1A3or9j+y2JiweHPBtj6/uJCjDH57OQl+vg5DV
         xseltLSh9o/BBOOJjFfDG3qn05IAHSBN5nnwXCBM=
Date:   Tue, 27 Jul 2021 17:44:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jason Ekstrand <jason@jlekstrand.net>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        stable <stable@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>
Subject: Re: [PATCH] Revert "drm/i915/gem: Asynchronous cmdparser"
Message-ID: <YQAp9f1ly39Cbc13@kroah.com>
References: <20210726231548.3511743-1-jason@jlekstrand.net>
 <YP+WQ4Ej2jyHjIeO@kroah.com>
 <CAKMK7uFpmd=Or2uRfh8vrdnmeJLUFkz0HbC44ueNyv59P-T-mA@mail.gmail.com>
 <CAOFGe97sM_GgZV=BCx8HnrJ2q4UD8eGcsZky2RzhALd9W7gw=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOFGe97sM_GgZV=BCx8HnrJ2q4UD8eGcsZky2RzhALd9W7gw=A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021 at 10:22:01AM -0500, Jason Ekstrand wrote:
> On Tue, Jul 27, 2021 at 5:41 AM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> >
> > On Tue, Jul 27, 2021 at 7:15 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Mon, Jul 26, 2021 at 06:15:48PM -0500, Jason Ekstrand wrote:
> > > > commit 93b713304188844b8514074dc13ffd56d12235d3 upstream.  This version
> > > > applies to the 5.10 tree.
> > >
> > > I do not see that commit id in Linus's tree, are you sure it is correct?
> >
> > 3761baae908a ("Revert "drm/i915: Propagate errors on awaiting already
> > signaled fences"")
> >
> > Jason, you need to pick the sha1 from drm-intel-fixes, which
> > cherry-picks. Confuses -stable otherwise.
> 
> Sorry.  Do you want me to re-send with correct reference SHAs?

Please do so, I can not take the existing patches for obvious reasons.

thanks,

greg k-h
