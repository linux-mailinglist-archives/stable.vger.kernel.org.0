Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D540F216E5C
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 16:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgGGOFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 10:05:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726839AbgGGOFx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 10:05:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D311D20738;
        Tue,  7 Jul 2020 14:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594130753;
        bh=OEiUEyF6ehvOfuHz3qE/fA113AVgzegriTZlFfll6g4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nkdSdCxOxPR5lyFuubXMkL679GXuuOlrCB6rUNjzoIjDfmVfG/cTtn1cKvucAedOs
         2EMlew5AsBl9QVsr/k9bx9Jo5rpG5tpY1K6BV5ka6+0lFXBn2XzDDQD3uZ7dmNLBXr
         kCNX77UPuPZgBPkT9OnDxBj7WHTHNMP66YnX9j38=
Date:   Tue, 7 Jul 2020 16:05:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH] dm zoned: assign max_io_len correctly
Message-ID: <20200707140551.GC4064836@kroah.com>
References: <20200630040047.231197-1-damien.lemoal@wdc.com>
 <20200630061840.GC616711@kroah.com>
 <CY4PR04MB37511B459111266535ACEF62E76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200630082019.GA636803@kroah.com>
 <CY4PR04MB3751E01A0219B5A76E771450E76C0@CY4PR04MB3751.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR04MB3751E01A0219B5A76E771450E76C0@CY4PR04MB3751.namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 01, 2020 at 12:36:49AM +0000, Damien Le Moal wrote:
> On 2020/06/30 17:20, Greg Kroah-Hartman wrote:
> > On Tue, Jun 30, 2020 at 06:20:58AM +0000, Damien Le Moal wrote:
> >> On 2020/06/30 15:18, Greg Kroah-Hartman wrote:
> >>> On Tue, Jun 30, 2020 at 01:00:47PM +0900, Damien Le Moal wrote:
> >>>> From: Hou Tao <houtao1@huawei.com>
> >>>>
> >>>> commit 7b2377486767503d47265e4d487a63c651f6b55d upstream.
> >>>>
> >>>> The unit of max_io_len is sector instead of byte (spotted through
> >>>> code review), so fix it.
> >>>>
> >>>> Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
> >>>> Cc: stable@vger.kernel.org
> >>>> Signed-off-by: Hou Tao <houtao1@huawei.com>
> >>>> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> >>>> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> >>>> ---
> >>>>  drivers/md/dm-zoned-target.c | 2 +-
> >>>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> What stable tree(s) is this for?
> >>>
> >>
> >> 5.7, 5.4, 4.19 and 4.14.
> >>
> >> Got the automated email that the patch was not applying so I sent this corrected
> >> version. I sent you a separate note about this.
> > 
> > Yes, but given the huge email flow, you need to be specific as your
> > response there was seen about an hour after this email due to them not
> > being threaded/attached/whatever :)
> 
> Greg,
> 
> Sorry about that. I will make sure to be more clear with a cover letter next
> time. Thanks !

Not a problem, now queued up!

greg k-h
