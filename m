Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C1A1AAEC2
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 18:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410463AbgDOQv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 12:51:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410454AbgDOQv0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 12:51:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7320B20737;
        Wed, 15 Apr 2020 16:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586969485;
        bh=2UTlhSsav0GTvZpIKs15Hq0DOjR27F+7dQp4nt2KPlY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EfHUMfSMZpWtfl3s892quycAOE/T0/5qutT/0JhzSjdUiwBloxY0yDqkxSdfdv12U
         cua3Z4AJkA8wC7IZ25A9g7ZaPieltwNfr9c7VY5/fWZHHgJZP6Bje7fjV3Gna2o4wV
         jyhmuEav+9KTGXu0buJ7n4WOX9dXjc5Ya83QAygQ=
Date:   Wed, 15 Apr 2020 18:51:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>,
        Matthew Wilcox <willy@infradead.org>
Cc:     bhelgaas@google.com, keescook@chromium.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] XArray: Fix xa_find_next for large
 multi-index entries" failed to apply to 5.4-stable tree
Message-ID: <20200415165122.GA3654762@kroah.com>
References: <1586948677159164@kroah.com>
 <20200415150222.GD5820@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415150222.GD5820@bombadil.infradead.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 08:02:22AM -0700, Matthew Wilcox wrote:
> On Wed, Apr 15, 2020 at 01:04:37PM +0200, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 5.4-stable tree.
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
> > >From bd40b17ca49d7d110adf456e647701ce74de2241 Mon Sep 17 00:00:00 2001
> 
> Seems like it's already there as commit
> 16696ee7b58101c90bf21c3ab2443c57df4af24e

Ugh.

Sasha, your scripts are applying patches to older kernels before newer
ones for some odd reason again, which confuses mine to no end :(


thanks,

greg k-h
