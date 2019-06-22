Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F26094F695
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 17:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfFVPkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 11:40:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbfFVPkc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Jun 2019 11:40:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F0582063F;
        Sat, 22 Jun 2019 15:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561218032;
        bh=iErFkL3gR3P/Fk5+I2jbcoG3MHV+s72rZLJbV7yAcWs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IQuB+2rYYffTiVO8YHqCTMOJBcpua5AxIFQqskR2g95TzaKXEewjl2SvzPXvAju2Q
         VzlyE/6Py5di5OBjaccKP6l1gtbd60X29fWYMt44JkR5R05SOz0Fwd9riFTiJtBgmv
         6YG5fAfRFnTXvpQAwZowxyIyey0hkr2vcW8ecrSU=
Date:   Sat, 22 Jun 2019 17:40:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: stable queue build failures (ipv4/tcp)
Message-ID: <20190622154029.GA4520@kroah.com>
References: <ff85ebad-2806-810f-0a03-a77c64ff92bf@roeck-us.net>
 <20190622152929.GA2586@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190622152929.GA2586@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 22, 2019 at 05:29:29PM +0200, Greg Kroah-Hartman wrote:
> On Sat, Jun 22, 2019 at 06:41:38AM -0700, Guenter Roeck wrote:
> > v4.4.y, v4.9.y, v4.14.y are affected.
> > 
> > net/ipv4/tcp_output.c: In function 'tcp_fragment':
> > net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared
> > 
> > net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undeclared
> 
> I deleted that patch a while ago, do you not see that update to the
> queue?

I have pushed out updated linux-stable-rc git updates in case you were
building off of those.

thanks,

greg k-h
