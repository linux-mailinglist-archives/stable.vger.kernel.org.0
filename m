Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71982429369
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 17:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237808AbhJKPci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 11:32:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239050AbhJKPcZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 11:32:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1207960FD7;
        Mon, 11 Oct 2021 15:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633966222;
        bh=qNOuID3oGllggWVOJYDAs4WiOHb/u8THodubZUe5cNI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hczNldm4ilpy5d2rw7/HQI8YQAhwNVL4gxmrXW2HE94gT4bhv2wJer70mM10kRLUc
         TQyXBvbWz4CnRB4ZEFc8h5YTCBmI4AUc4vx2ZzsaCQyo/8SGlE9PRc65NZWVKZz5XQ
         h9E4qi8yxZR9a8cgnAmjvanRDtGgzCLKGG6XJHXo=
Date:   Mon, 11 Oct 2021 17:30:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Hunter, Adrian" <adrian.hunter@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 5.10 83/83] scsi: ufs: core: Fix task management
 completion
Message-ID: <YWRYi5Pe1Bshl2iR@kroah.com>
References: <20211011134508.362906295@linuxfoundation.org>
 <20211011134511.235071707@linuxfoundation.org>
 <8dc0e077af3f4fd5a0887784f65bd722@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8dc0e077af3f4fd5a0887784f65bd722@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11, 2021 at 03:03:59PM +0000, Hunter, Adrian wrote:
> Hi
> 
> This doesn't work.  Please drop.  Sorry, no idea why I sent it before testing.
> 
> Specifically, in v5.10, ufshcd_tmc_handler() can be called under the same spinlock
> it is using, which deadlocks.

Ok, now dropped!

thanks,

greg k-h
