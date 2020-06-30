Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E3820F062
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 10:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbgF3IUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 04:20:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727919AbgF3IUX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jun 2020 04:20:23 -0400
Received: from localhost (unknown [84.241.197.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84A8220768;
        Tue, 30 Jun 2020 08:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593505222;
        bh=zgYtACOiUxPCgAo/uDCmxNkysztpmNDFqy0jDeI/bqA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HGKPDX02oo1FCvCk4c40H5o4YUV18s44gP5g6UmENlPV7lTW6iTC3pQqMwAK4IVBR
         UerXBbU1lt1ajOH4vx8Wdu62FIEE112LDJu30qwpT4Twgb5jW7ijqquH6YZmqxgASG
         VbypMO6ON9J2tGcSJCGYIkytt5sKml0iJmy/xh4s=
Date:   Tue, 30 Jun 2020 10:20:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH] dm zoned: assign max_io_len correctly
Message-ID: <20200630082019.GA636803@kroah.com>
References: <20200630040047.231197-1-damien.lemoal@wdc.com>
 <20200630061840.GC616711@kroah.com>
 <CY4PR04MB37511B459111266535ACEF62E76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR04MB37511B459111266535ACEF62E76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 30, 2020 at 06:20:58AM +0000, Damien Le Moal wrote:
> On 2020/06/30 15:18, Greg Kroah-Hartman wrote:
> > On Tue, Jun 30, 2020 at 01:00:47PM +0900, Damien Le Moal wrote:
> >> From: Hou Tao <houtao1@huawei.com>
> >>
> >> commit 7b2377486767503d47265e4d487a63c651f6b55d upstream.
> >>
> >> The unit of max_io_len is sector instead of byte (spotted through
> >> code review), so fix it.
> >>
> >> Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Hou Tao <houtao1@huawei.com>
> >> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> >> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> >> ---
> >>  drivers/md/dm-zoned-target.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > What stable tree(s) is this for?
> > 
> 
> 5.7, 5.4, 4.19 and 4.14.
> 
> Got the automated email that the patch was not applying so I sent this corrected
> version. I sent you a separate note about this.

Yes, but given the huge email flow, you need to be specific as your
response there was seen about an hour after this email due to them not
being threaded/attached/whatever :)

thanks,

gre gk-h
