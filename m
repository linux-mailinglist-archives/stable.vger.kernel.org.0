Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B189727D112
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 16:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbgI2O27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 10:28:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727543AbgI2O27 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 10:28:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73D0520739;
        Tue, 29 Sep 2020 14:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601389739;
        bh=iocx2I8s4yXKt+lp1EQlYMBUlUUVSgr/zLh6l0K+h3Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=THXOWVHeIhXUqSHfg7x99bpbE4ptJa7teKsPQjRzi75+2Ck8/cn5GEgBFzbOOVlEV
         rdJAYwAkPw03gGdYbd4/lN6guXC77T5EDLscULRScjx8MQDSkAVozMxxA6wpJrVpow
         BGZn4yUogpkC5RIXnyFy/d6M8A9tloc3WX3BWrfg=
Date:   Tue, 29 Sep 2020 16:29:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: replace memmap_context by memplug_context
Message-ID: <20200929142904.GC1203131@kroah.com>
References: <20200929135738.28697-1-ldufour@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929135738.28697-1-ldufour@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 03:57:37PM +0200, Laurent Dufour wrote:
> Backport version to the 5.4-stable tree of the commit:
> 
> c1d0da83358a ("mm: replace memmap_context by meminit_context")
> 
> Cc: <stable@vger.kernel.org> # 5.4.y
> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>

What happened to the full changelog from the original commit, and all of
the cc: and signed-off-by from it?

Please include that in the patch, you don't want to see all of that
stripped off, right?

thanks,

greg k-h
