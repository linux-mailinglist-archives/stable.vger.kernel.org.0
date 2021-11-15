Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD994514D6
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349496AbhKOUNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:13:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345100AbhKOT0Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:26:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D588D63718;
        Mon, 15 Nov 2021 19:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003421;
        bh=4nkgXQ9tGsI8fjC/5tTjNbsI8vRHrX2djpvmtZXPW4M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZJ6Ng8u/PqKO5LWK0g8mrBXmLHGCtGyLaKBvhpmgvHCoFHNSTwMPL4Pb7NPBJlHPf
         65m2axam9CGY7DixC/2prWH4/p0DSEHI6Cp8EaTj53T5h/Lm4/Bc4nsz7JJdB7eT0r
         e8r9fJrwSQ+WEGevYsn2i07Z/XsFOobQiJ8XiPO0=
Date:   Mon, 15 Nov 2021 19:11:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        syzbot+5516b30f5401d4dcbcae@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH 5.10 011/575] scsi: core: Remove command size deduction
 from scsi_setup_scsi_cmnd()
Message-ID: <YZKiwgnnV2Kovot2@kroah.com>
References: <20211115165343.579890274@linuxfoundation.org>
 <20211115165343.996963128@linuxfoundation.org>
 <7ed36c27-a150-39a6-d8e3-483c76bbedc5@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ed36c27-a150-39a6-d8e3-483c76bbedc5@acm.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 09:58:19AM -0800, Bart Van Assche wrote:
> On 11/15/21 8:55 AM, Greg Kroah-Hartman wrote:
> > From: Tadeusz Struk <tadeusz.struk@linaro.org>
> > 
> > commit 703535e6ae1e94c89a9c1396b4c7b6b41160ef0c upstream.
> 
> Hi Greg,
> 
> Thanks for having queued this patch for the 5.10 stable branch.
> 
> Do you plan to also include commit 20aaef52eb08 ("scsi: scsi_ioctl: Validate
> command size")? That patch prevents that the bug in the commit mentioned
> above can be triggered.

It did not apply to 5.10.y and 5.14.y and a "FAILED:" email was sent out
asking for a backport of it.

If you can provide that, great, I'll be glad to take it.

thanks,

greg k-h
