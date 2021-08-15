Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526333EC8D1
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 13:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237639AbhHOLnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 07:43:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229677AbhHOLnC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Aug 2021 07:43:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7722C60F11;
        Sun, 15 Aug 2021 11:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629027753;
        bh=MOhBmeozH5SlefXLm+Rklc27VBOOJ6ubDwoO9svYyyA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EJVYjgHbAhzzXzl3NNv6vopa1gxXjmz1jKyM9PTFXjP+HSkLcywqMI0xy1pvfupc3
         2rTnh6JcW1zuPq6iDJMZyadhWxSECO0w3Y2jE3x8FkR6K+MtABRgJL2Er7zmyE0P2G
         TrzZXfYSSYTegOY3uWIaCwOCVif/FkOZEN2bynJw=
Date:   Sun, 15 Aug 2021 13:42:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH 5.10 04/19] bpf: Add _kernel suffix to internal
 lockdown_bpf_read
Message-ID: <YRj9pl459cFK+2kJ@kroah.com>
References: <20210813150522.623322501@linuxfoundation.org>
 <20210813150522.774143311@linuxfoundation.org>
 <20210813195523.GA4577@duo.ucw.cz>
 <f42f4fbb-3777-6e5b-0daf-6fdb2cc707b8@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f42f4fbb-3777-6e5b-0daf-6fdb2cc707b8@iogearbox.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 13, 2021 at 11:57:58PM +0200, Daniel Borkmann wrote:
> Hi Pavel,
> 
> On 8/13/21 9:55 PM, Pavel Machek wrote:
> > > From: Daniel Borkmann <daniel@iogearbox.net>
> > > 
> > > commit 71330842ff93ae67a066c1fa68d75672527312fa upstream.
> > > 
> > > Rename LOCKDOWN_BPF_READ into LOCKDOWN_BPF_READ_KERNEL so we have naming
> > > more consistent with a LOCKDOWN_BPF_WRITE_USER option that we are
> > > adding.
> > 
> > As far as I can tell, next bpf patch does not depend on this one and
> > we don't need it in 5.10. (Likely same situation with 5.13).
> 
> Yeah, it's nice to have for consistency given also small as well, but
> also fully okay to drop it as there shouldn't be any conflict.
> 

Ok, now dropped, thanks.

greg k-h
