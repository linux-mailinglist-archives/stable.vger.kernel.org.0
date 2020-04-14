Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DCC1A87C5
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 19:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730473AbgDNRmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 13:42:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728863AbgDNRmr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 13:42:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9710206A2;
        Tue, 14 Apr 2020 17:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586886167;
        bh=ac8XRH9mDtOZJ/fqnP12mjlJ4vFb+2eV7iYmkeCn+6M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qE+LVzGsmroZJGOr9mm5P3RmMTY7d68thPQDGofnle98pQ5shWi6B/Y0+pM/r96cS
         1lGOw1TKdBDI4qiZU/0azJ7EU+Mm5ybcYxtolgZqed8xgO31P7wjsVNCSKLXi/wXQ3
         Yz28k+R053x38uwY31l4zm3MMF5GOSzOXuWNk3EU=
Date:   Tue, 14 Apr 2020 19:42:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: honor original task
 RLIMIT_FSIZE" failed to apply to 5.4-stable tree
Message-ID: <20200414174244.GB1035385@kroah.com>
References: <15868668307141@kroah.com>
 <898eca01-58e5-8452-34b3-100de2506b38@kernel.dk>
 <6b6323fa-670e-a656-1bb6-82d89ed692ae@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b6323fa-670e-a656-1bb6-82d89ed692ae@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 10:38:41AM -0600, Jens Axboe wrote:
> On 4/14/20 10:31 AM, Jens Axboe wrote:
> > On 4/14/20 6:20 AM, gregkh@linuxfoundation.org wrote:
> >>
> >> The patch below does not apply to the 5.4-stable tree.
> >> If someone wants it applied there, or to any other stable or longterm
> >> tree, then please email the backport, including the original git commit
> >> id to <stable@vger.kernel.org>.
> > 
> > Here's a 5.4 backport.
> 
> Sorry, please use this one!

Now queued up, along with the other backports, thanks!

greg k-h
