Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB6912E092
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 22:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgAAVjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 16:39:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:57220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbgAAVjg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jan 2020 16:39:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87E63206DB;
        Wed,  1 Jan 2020 21:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577914776;
        bh=1OJNz8UNfnhAqVGwGCRLBN66G73Jrfa5Y4gz/m4FnJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dbJL2oYF3a5Im7IYrqZMcAk53/pQ4G5Wgrz3iK0To5VYn+tXl3pMPoArcwiL7mwFp
         lAcUKh4Ob2s0EXiAJ8f+yeVowr967OpRU14SzvEwuDLBleyTzzXvo1QVn/pghk5DKC
         84bQAozX+ArDdpC8oD+42jiQ7XAxRScZfI3/m4dQ=
Date:   Wed, 1 Jan 2020 22:37:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200101213722.GA3342026@kroah.com>
References: <20200101.121337.869108048422106627.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200101.121337.869108048422106627.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 01, 2020 at 12:13:37PM -0800, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v4.19 and v5.4
> -stable, respectively.
> 
> Thank you!


all now queued up, thanks!

greg k-h
