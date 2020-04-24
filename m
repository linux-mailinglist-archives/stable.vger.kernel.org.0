Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE071B717C
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 12:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgDXKF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 06:05:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgDXKF7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 06:05:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4FF52071E;
        Fri, 24 Apr 2020 10:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587722759;
        bh=2vnJPVaPw/0zCFzJzxMMbElYp/a7faQK6B07NZCVr4Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JYUGsJJTUfb78jkFT2T6McKlz8p36vgTy7fV2axOND2QRLj2khG+7zbXI1iXytAlx
         8fvjBCYuJg0Tshf0ClrnvAmPyDAgADe+Cgjpn0VVMcb6sGFGDmBpJSxm99zaUz/Kco
         +q2VXtx46lx5koQQq71tHtCpsbcQGQD2UkqkZV4s=
Date:   Fri, 24 Apr 2020 12:05:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     William Dauchy <wdauchy@gmail.com>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: backport status of "net, ip_tunnel: fix interface lookup with no
 key"
Message-ID: <20200424100556.GB381429@kroah.com>
References: <CAJ75kXYo5rYg6pLj=Qf173pwVoxd6KjLMdG-DNuR3PAYmbX7xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ75kXYo5rYg6pLj=Qf173pwVoxd6KjLMdG-DNuR3PAYmbX7xQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 09:52:11PM +0200, William Dauchy wrote:
> Hello,
> 
> I found the following commit 25629fdaff2ff509dd0b3f5ff93d70a75e79e0a1
> ("net, ip_tunnel: fix interface lookup with no key") backported in the
> following stable versions: v5.6.x, v5.5.x, v4.19.x, v4.14.x, v4.9.x,
> v4.4.x.
> However I cannot find it in v5.4.x yet. I checked stable queue on
> netdev side (http://patchwork.ozlabs.org/bundle/davem/stable/?state=*)
> but also main stable queue
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
> 
> I was wondering whether it was an oversight or I was too hasty?
> 
> Sorry for the noise if I'm mistaken.

Odd, I think this was a bug in Sasha's scripts where it would sometimes
miss kernel trees.  I've queued it up now, thanks.

greg k-h
