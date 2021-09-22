Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15977414C44
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 16:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235464AbhIVOnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 10:43:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232720AbhIVOnG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 10:43:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E799561038;
        Wed, 22 Sep 2021 14:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632321696;
        bh=6L0KW5oHzFK5t0IJVeUv+qg+HkVTPUSJRYR9a1icGDo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pz5G6aJr1RhDnrzpdUdNQoZrmchoSukgk8VxTQSKW5mi42Jn9oAExENwl2u6ULU5d
         auht/+S5l0kGRIqB9S8VjqMtMHsa4c7uU0mibbipv9A2q3Gpm9wVOdH9OOo9HVjV6m
         XIq7Ap4WrZw3joLSpLBZj0SUhwjX1+eJcps2JFCo=
Date:   Wed, 22 Sep 2021 16:41:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     lorenzo.pieralisi@arm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] PCI: aardvark: Fix reporting CRS value"
 failed to apply to 5.14-stable tree
Message-ID: <YUtAmk46bRf/qO2i@kroah.com>
References: <16317162038625@kroah.com>
 <20210915164643.wuvqooapjccdc2nd@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210915164643.wuvqooapjccdc2nd@pali>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 15, 2021 at 06:46:43PM +0200, Pali Rohár wrote:
> On Wednesday 15 September 2021 16:30:03 gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 5.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Hello that patch depends on commit which fixes name of rootcap member:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e902bb7c24a7099d0eb0eb4cba06f2d91e9299f3

Thanks, that worked for 5.10 and 5.14, but not for 5.4.y.  If this needs
to go there too, can you send a working set of backported patches?

thanks,

greg k-h
