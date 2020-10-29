Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B4029E702
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 10:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbgJ2JNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 05:13:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgJ2JNX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 05:13:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3D86206F7;
        Thu, 29 Oct 2020 09:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603962802;
        bh=uYNrlajr/3qyzdoaPXw+q7AW6Khx2+jwG2kxrMZyEgY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H4KaLOOtSTzhSgOK2Py3axU1HaJ+OC7ftDvtv/zCozAGfgw6su0kQUu3fttjQFcqh
         mmrHiLvD3IyZmYpuIXJG43rGZpLyMNJ88UeFHosKIQS80UDE1KFx4Cw6lfG98GVfAj
         ZQilaisQUVZz/RHiYDdFz3jBjwgNssdlfSeDgVZg=
Date:   Thu, 29 Oct 2020 10:14:12 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ronald Warsow <rwarsow@gmx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.9 000/757] 5.9.2-rc1 review
Message-ID: <20201029091412.GA3749125@kroah.com>
References: <d8211fcd-ddb5-34e1-1f9e-aa5b94a03889@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8211fcd-ddb5-34e1-1f9e-aa5b94a03889@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 27, 2020 at 07:09:52PM +0100, Ronald Warsow wrote:
> Hallo
> 
> this rc1 runs here (pure Intel-box) without errors.
> Thanks !
> 
> 
> An RPC (I'm thinking about since some month)
> ======
> 
> Wouldn't it be better (and not so much add. work) to sort the
> Pseudo-Shortlog towards subsystem/driver ?
> 
> something like this:
> 
> ...
> usb: gadget: f_ncm: allow using NCM in SuperSpeed Plus gadgets.
> usb: cdns3: gadget: free interrupt after gadget has deleted
> 
>    Lorenzo Colitti <lorenzo@google.com>
>    Peter Chen <peter.chen@nxp.com>
> ...
> 
> 
> Think of searching a bugfix in the shortlog.
> 
> With the current layout I need to read/"visual grep" the whole log.
> 
> With the new layout I'm able to jump to the "buggy" subsystem/driver and
> only need to read that part of the log to get the info if the bug is
> fixed or not yet

Do you have an example script that generates such a thing?  If so, I'll
be glad to look into it, but am not going to try to create it on my own,
sorry.

thanks,

greg k-h
