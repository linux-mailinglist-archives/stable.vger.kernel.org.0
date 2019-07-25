Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57054747A0
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 08:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387418AbfGYG7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 02:59:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387668AbfGYG7j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 02:59:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE1EA2070B;
        Thu, 25 Jul 2019 06:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564037978;
        bh=eqsaAomPO9wIOKM+wsrSXhDJBVwb+imqnpL/tT7Vxx4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dz/Kz5w3sKtQR3X7KwObW4YBPuO1rsZOIX+7qhEDsQAIZQ3gO5mMIGFLIysFlOvyB
         cCsAml7gygVQQDWPV930eGJwB+Atojl7Y2GLBTu1hWf9i5qVBAWRBRAJNT5lvZQ3xd
         THWJstFFVM1cpYa4iPsTJOdxL7/Nr+EbzDx917xI=
Date:   Thu, 25 Jul 2019 08:34:54 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] block: Limit zone array allocation size"
 failed to apply to 5.1-stable tree
Message-ID: <20190725063454.GD6723@kroah.com>
References: <1563883019244153@kroah.com>
 <c1ed04aded7fb0e68cd4095cb4c7049c02a11e3f.camel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1ed04aded7fb0e68cd4095cb4c7049c02a11e3f.camel@wdc.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 25, 2019 at 06:06:45AM +0000, Damien Le Moal wrote:
> On Tue, 2019-07-23 at 13:56 +0200, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 5.1-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Greg,
> 
> I sent you a backported version that applies cleanly to both 5.1 and
> 5.2 stable trees.

Please fix up your backports and send them in a format that I can use
that does not lie about the author of the patch :)

thanks,

greg k-h
