Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A2414A785
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 16:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgA0PvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 10:51:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:40440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729203AbgA0PvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jan 2020 10:51:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DE5D214D8;
        Mon, 27 Jan 2020 15:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580140268;
        bh=fgHgC1IHpgok6v54v63FdkHsuyc6wfcAIdY8ET3xw48=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tuyF5hywFyHks62ZJx/CbFxfdDW4y/Ago9dPOXjapDQc5cz9lysg9eYEyYAS1LR9V
         VckH/7w2tWiny7qW/aRgepW9O8OdkridutkSYk8tvuH/W1a5OmJ7+hOp6EeRL5RuYK
         Bvum/7Oh546J1VVzH5nguplJxViDKvfu017tftDg=
Date:   Mon, 27 Jan 2020 16:51:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jeremy Linton <jeremy.linton@arm.com>, stable@vger.kernel.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: Request to backport "Documentation: Document arm64 kpti control"
Message-ID: <20200127155106.GA668073@kroah.com>
References: <520fee3a-4d14-9a78-e542-cce98acae9f6@gmail.com>
 <20200126135233.GB11467@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200126135233.GB11467@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 26, 2020 at 08:52:33AM -0500, Sasha Levin wrote:
> On Sat, Jan 25, 2020 at 08:03:25PM -0800, Florian Fainelli wrote:
> > Hi Greg, Sasha,
> > 
> > Could you backport upstream commit
> > de19055564c8f8f9d366f8db3395836da0b2176c ("Documentation: Document arm64
> > kpti control") to the stable 4.9, 4.14 and 4.19 kernels since they all
> > support the command line parameter.
> 
> Hey Florian,
> 
> We don't normally take documentation patches into stable trees.

Normally we do not, but this is simple enough I've queued it up for 4.19
and 4.14.  Are you sure it is ok for 4.9?  If so, Florian, can you
provide a backported version of it?

thanks,

greg k-h
