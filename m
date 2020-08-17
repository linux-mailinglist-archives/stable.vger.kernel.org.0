Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E0524673A
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgHQNQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:16:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728671AbgHQNPd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 09:15:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A67A02076E;
        Mon, 17 Aug 2020 13:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597670133;
        bh=WPqoU3M/tSeDRK0/a7iH0K3g9jrs8S8btudhscmg+VY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1/IkPprg6AYvW8riSJ9/DgTRs2c7NkXRkcE6vG/3SlycPQ55VarICicCjY89FI4od
         TwYWzhjaeqf/B2B1hW5M3RHeoZ2ilSP44Z0Zs/SIj++B27prt97gU4gh+3eIZKCGtP
         L3Ol2oL62wIKMYF4Q3Ee0I6SPjCIvrevL/em2+fU=
Date:   Mon, 17 Aug 2020 15:15:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     josef.grieb@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: enable lookup of links holding
 inflight files" failed to apply to 5.8-stable tree
Message-ID: <20200817131552.GB208556@kroah.com>
References: <159766102815889@kroah.com>
 <bac8dccd-1a06-50a2-729d-8421aed4455d@kernel.dk>
 <0f227a86-52fc-3fbf-12c8-d896466790bf@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f227a86-52fc-3fbf-12c8-d896466790bf@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 06:07:53AM -0700, Jens Axboe wrote:
> On 8/17/20 6:05 AM, Jens Axboe wrote:
> > On 8/17/20 3:43 AM, gregkh@linuxfoundation.org wrote:
> >>
> >> The patch below does not apply to the 5.8-stable tree.
> >> If someone wants it applied there, or to any other stable or longterm
> >> tree, then please email the backport, including the original git commit
> >> id to <stable@vger.kernel.org>.
> >>
> >> thanks,
> > 
> > Needs a prep patch, please apply these two (last one being this patch).
> 
> Sorry, sent the wrong one, here's the right 2nd patch.

Both applied, thanks.

greg k-h
