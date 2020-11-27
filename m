Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A452C66C4
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 14:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729925AbgK0NYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 08:24:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:35054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729888AbgK0NYu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 08:24:50 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08C6C2224D;
        Fri, 27 Nov 2020 13:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606483490;
        bh=JHrJIVISyhPpvytC2C4otcIEKz6vJE7t6voIzOjzqVo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Peengyzf4SVrFJhTIq8zFo5R3ZXblvdK4LfhJt/Qfyk/wjKcEXIhnfgyGzd1OTrZ/
         wCCuv4IRRCW/KlRqWGAD5NV95wcN3aMDCTDPDP+JPKKnDjbxoF+q+83sFQc43YJySO
         V7mkh4TRiowjpGRJjWyZoVe/vOyxT3O77AT15HZM=
Date:   Fri, 27 Nov 2020 14:24:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     rajatja@google.com, bhelgaas@google.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] PCI: Add device even if driver attach
 failed" failed to apply to 4.14-stable tree
Message-ID: <X8D+IGXFiG8MT2lM@kroah.com>
References: <1597832576184218@kroah.com>
 <20201127123537.t2oejpb5iickm52z@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127123537.t2oejpb5iickm52z@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 27, 2020 at 12:35:38PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Wed, Aug 19, 2020 at 12:22:56PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport. It will also apply to 4.9-stable.

Now queued up, thanks.

greg k-h
