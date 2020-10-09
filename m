Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6CC2889A6
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 15:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731262AbgJINUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 09:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730978AbgJINUx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Oct 2020 09:20:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC3CD22276;
        Fri,  9 Oct 2020 13:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602249653;
        bh=/rI2I9G6H8suPrKWaTp5fCH2s71sZxapXKIUS+xTw6Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LdFkAjpziK5B2T/04d7Por4gdi6bBa0ZHvESEnlFUHej65WhpQ+KzEcJ/g2EUKduH
         o0KhMe8Tm+YjcmR3nG8MfzSWRXMtckLT2x/DMEUeIceQa/PQ/63wQsGc/hTU4NQ8kO
         k4mIgaUVvHMsSZiRaqk3OCQVyAwhDN3UsiOu1GWo=
Date:   Fri, 9 Oct 2020 15:21:39 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: LTS couple perf test and perf top fixes
Message-ID: <20201009132139.GB561744@kroah.com>
References: <f471ab5f93cd97af4eddebbc78d047289cc55888.camel@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f471ab5f93cd97af4eddebbc78d047289cc55888.camel@nokia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 09, 2020 at 11:28:09AM +0000, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:
> Hi Greg, Sasha,
> 
> Can you pick this to 5.4:
> 
> commit dbd660e6b2884b864d2642d930a163d3bcebe4be
> Author: Tommi Rantala <tommi.t.rantala@nokia.com>
> Date:   Thu Apr 23 14:53:40 2020 +0300
> 
>     perf test session topology: Fix data path
> 
> 
> And this to 5.4 and older LTS trees too:
> 
> commit 29b4f5f188571c112713c35cc87eefb46efee612
> Author: Tommi Rantala <tommi.t.rantala@nokia.com>
> Date:   Thu Mar 5 10:37:12 2020 +0200
> 
>     perf top: Fix stdio interface input handling with glibc 2.28+
> 

Now queued up, thanks.

greg k-h
