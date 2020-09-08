Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A21261512
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 18:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731354AbgIHQnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 12:43:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732018AbgIHQbi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:31:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A26823BCF;
        Tue,  8 Sep 2020 13:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599571196;
        bh=rAhOf0mRJyskwrDl5gDj7QgaO0r1xaO5XluFHRKoSoY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t7gRwRrIsULY6aGaJXEZAMxnc9Tm2SfQJv7VhAnCVCgwT7wZka5S1dPv3WVG0wN0i
         9aWAhEmn4WX5tcU+RBo3+0COQDnZviRPL72xBpidcTip1EEsszQvxYZ0ddcNXS3buR
         7vF79m1SX7U/JEq/ohB/eY8v8IeUiZtqQ4PCYp/0=
Date:   Tue, 8 Sep 2020 15:20:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tim Froidcoeur <tim.froidcoeur@tessares.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        matthieu.baerts@tessares.net, davem@davemloft.net
Subject: Re: [PATCH 4.4 0/2] net: initialize fastreuse on inet_inherit_port
Message-ID: <20200908132008.GD3173498@kroah.com>
References: <20200902140513.866712-1-tim.froidcoeur@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902140513.866712-1-tim.froidcoeur@tessares.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 02, 2020 at 04:05:11PM +0200, Tim Froidcoeur wrote:
> Fix for TPROXY initialization of fastreuse flag.
> upstream patch was backported by Greg K-H to 4.14 and higher stable version.
> 
> see also https://lore.kernel.org/stable/20200818072007.GA9254@kroah.com
> 
> code in inet_csk_get_port for 4.4 (and 4.9) is different from
> the upstream version, so these backports had to be adapted (a bit)
> 
> Tim Froidcoeur (2):
>   net: refactor bind_bucket fastreuse into helper
>   net: initialize fastreuse on inet_inherit_port
> 
>  include/net/inet_connection_sock.h |  4 +++
>  net/ipv4/inet_connection_sock.c    | 46 ++++++++++++++++++------------
>  net/ipv4/inet_hashtables.c         |  1 +
>  3 files changed, 33 insertions(+), 18 deletions(-)
> 
> --
> 2.25.1

Now queued up, thanks.

greg k-h
