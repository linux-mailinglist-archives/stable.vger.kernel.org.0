Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C542FCEC8
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 12:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbhATLGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 06:06:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:55762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388728AbhATLBM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Jan 2021 06:01:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE7ED22202;
        Wed, 20 Jan 2021 11:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611140425;
        bh=Bj8kmq5R1+d7y/qf8QaG8Z+rsnlbsp1megmNrn+iwqI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z3OfRazYvKFoMjUHKj9KUZm/DLngsO2N6XtPu2uQ7BbdnyLZSsfnbB81E7ArdHZ3D
         YG7tW6NEswCyz79nvi/8D5H7bwCM5qzpgLyvSqlY9PVE9La+9sgX/pJTVPEnWITQ7n
         5MjtSd5AoNK7m41Nmju1n9UXFjLEUSbxd8EhOTRs=
Date:   Wed, 20 Jan 2021 12:00:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     lukasstraub2@web.de, snitzer@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] dm integrity: fix flush with external
 metadata device" failed to apply to 4.19-stable tree
Message-ID: <YAgNRhXAuSJwpkPu@kroah.com>
References: <161089356815125@kroah.com>
 <alpine.LRH.2.02.2101191057280.9916@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2101191057280.9916@file01.intranet.prod.int.rdu2.redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 19, 2021 at 10:59:57AM -0500, Mikulas Patocka wrote:
> 
> 
> On Sun, 17 Jan 2021, gregkh@linuxfoundation.org wrote:
> 
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi
> 
> Here I'm submitting the backported patch for the branch 4.19-stable:

Now queued up, thanks.

greg k-h
