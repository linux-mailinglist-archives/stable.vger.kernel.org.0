Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB9B461BC8
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 17:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242579AbhK2Qge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 11:36:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33350 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345383AbhK2Qec (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 11:34:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD3B6B80E62
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 16:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033DFC53FAD;
        Mon, 29 Nov 2021 16:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638203472;
        bh=nfVsjz/yNojWLYvOinUUkbFOfPLSUCntnjoBWtBozzE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kxYQrdzYA3+Q0yds3CaWtM2Yi3z+5cgenQFfiu/z43iC0I1maIIdEyLlq35dWh77q
         G/ugBe5U3SCjZeIhTQ7kEfl/FXMiBARKSgZRVq9R0qZUv2H08CXqfBpNbwEh0gigYa
         1ZbBgmIdU9D0Xxed+RcR4vbEm7IzKWpZAl4379yw=
Date:   Mon, 29 Nov 2021 17:31:09 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     Justin Forbes <jmforbes@linuxtx.org>,
        stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] fuse: release pipe buf after last use"
 failed to apply to 4.4-stable tree
Message-ID: <YaUATRTkZrVg3kjs@kroah.com>
References: <163801865218547@kroah.com>
 <CAOssrKdd9u=tQ-fjXhqju9-7efHtN=mBed0ay1e_YM2yBHVT0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKdd9u=tQ-fjXhqju9-7efHtN=mBed0ay1e_YM2yBHVT0Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 05:10:41PM +0100, Miklos Szeredi wrote:
> On Sat, Nov 27, 2021 at 2:11 PM <gregkh@linuxfoundation.org> wrote:
> >
> >
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> 
> Hi Greg,
> 
> Attaching the backport of this patch against 4.4.292 + "fuse: fix page
> stealing".
> 
> The latter has been dropped from 4.4, but together with this backport
> should be good to go:
> 
>   stable-queue.git#c7f34b89ddfe^:queue-4.4/fuse-fix-page-stealing.patch

Now queued up, thanks.

greg k-h
