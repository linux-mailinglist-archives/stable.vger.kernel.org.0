Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26C6E14B09F
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 09:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbgA1IFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 03:05:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:60190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbgA1IFA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 03:05:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 562E92465B;
        Tue, 28 Jan 2020 08:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580198699;
        bh=k1kZ9fV9qajHn4aJDqTvPkELNNlsgiV7OkxdBa9BNZI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m5Hs88tttmkP3jSiY01GSHfnrBK0rq8TidXu3KDE2bxiW7CAdpo0vfMtuqHPCZs4f
         NLWw2bK1odR342uYldj9qMAoheFbZQ1BKUqsMFNWHOOvCGVdeCH67XbdPJHJEpJNmr
         oybYBPTA0yYmPjYMyhR8M/Neu4Te3FxOx2gw7w4k=
Date:   Tue, 28 Jan 2020 09:04:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Masato Suzuki <masato.suzuki@wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] sd: Fix REQ_OP_ZONE_REPORT completion handling
Message-ID: <20200128080457.GG2105706@kroah.com>
References: <20200127050746.136440-1-masato.suzuki@wdc.com>
 <BYAPR04MB5816781F4588054DF9C31380E70B0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <yq1k15c9qkx.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1k15c9qkx.fsf@oracle.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 27, 2020 at 11:01:50PM -0500, Martin K. Petersen wrote:
> 
> Damien,
> 
> >> Fixes: 89d947561077 ("sd: Implement support for ZBC devices")
> >> Cc: <stable@vger.kernel.org> # 4.19
> >> Cc: <stable@vger.kernel.org> # 4.14
> >> Signed-off-by: Masato Suzuki <masato.suzuki@wdc.com>
> >
> > This bug exists since the beginning of SMR support in 4.10, until report
> > zones was changed to a device file method in kernel 4.20. It fell through
> > the cracks the entire time and was caught only recently with improvements
> > to our test suite.
> 
> Looks good to me. Obviously only applies to stable since, as you point
> out, this code has been substantially reworked.
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

Thanks for the review, now queued up.

greg k-h
