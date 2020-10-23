Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733A029713C
	for <lists+stable@lfdr.de>; Fri, 23 Oct 2020 16:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374602AbgJWOV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Oct 2020 10:21:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S374556AbgJWOV6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Oct 2020 10:21:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 183F2223EA;
        Fri, 23 Oct 2020 14:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603462917;
        bh=eBzBT9drAAKEdV7SLNu7v8DuoK+iKeAD2N23VVSVhso=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JY+w7Xk56sY4JOh3cbhgAyBEQR2yvI60i4832nI7TFsZOyWrHsjDELAvtO9W8QojW
         VRWmG+OJdsAmF2+HGkuYytLgQ5syiP0AxfOncldVC1mgWJsbgeADll9Q+YODPAwg04
         yIcEcCuiMb+2OR6Uqq//Lai/56to6rSUWh0LdcfA=
Date:   Fri, 23 Oct 2020 16:22:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: does 548b8b5168c9 qualify for stable?
Message-ID: <20201023142231.GA2518006@kroah.com>
References: <4f1324d2-6b0f-dcb6-ff58-a6a05a15d407@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f1324d2-6b0f-dcb6-ff58-a6a05a15d407@rasmusvillemoes.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 23, 2020 at 03:40:26PM +0200, Rasmus Villemoes wrote:
> Hi,
> 
> Please consider whether
> 
> commit 548b8b5168c90c42e88f70fcf041b4ce0b8e7aa8
> Author: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Date:   Thu Sep 17 08:56:11 2020 +0200
> 
>     scripts/setlocalversion: make git describe output more reliable
> 
> qualifies for -stable. It removes one potential source of binary
> non-reproducibility that we have actually seen cause problems.
> 
> I'm fine with it not qualifying, but please let me know if so, because
> then I'll go and add some workarounds to various customer projects.
> 
> In case it doesn't cherry-pick cleanly (I think there might have been
> some shell-portability patches replacing $() by `` or something like
> that) I am happy to provide backports to the still maintained -stable
> branches.

Looks like it qualifies, how far back do you want it to go?

And yes, backported patches always make it much easier to apply :)

thanks,

greg k-h
