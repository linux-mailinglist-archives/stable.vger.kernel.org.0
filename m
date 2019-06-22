Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 990B14F68F
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 17:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbfFVP3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 11:29:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbfFVP3c (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Jun 2019 11:29:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 634D9205C9;
        Sat, 22 Jun 2019 15:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561217371;
        bh=thEKz9V+99nKzqQ83nfVg/o9PFGLg+P4SEWztii45gc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=irOBMkNc7S+ruGbZoAcDjjrJGfW2+OeWTLs3JxKcv7IIc1zFW5QCpr92TNjD61gM4
         equp0YRfmBLUiXkidC2N5cwaC0SPfkWImfmXXfcSDe0hWeOaUDttbCX2kGuXFzwz8E
         bHqyh+Jsq49X1Bbuxr0+JTJyTEGtsUvda27gbu0s=
Date:   Sat, 22 Jun 2019 17:29:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: stable queue build failures (ipv4/tcp)
Message-ID: <20190622152929.GA2586@kroah.com>
References: <ff85ebad-2806-810f-0a03-a77c64ff92bf@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff85ebad-2806-810f-0a03-a77c64ff92bf@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 22, 2019 at 06:41:38AM -0700, Guenter Roeck wrote:
> v4.4.y, v4.9.y, v4.14.y are affected.
> 
> net/ipv4/tcp_output.c: In function 'tcp_fragment':
> net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared
> 
> net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undeclared

I deleted that patch a while ago, do you not see that update to the
queue?

thanks,

greg k-h
