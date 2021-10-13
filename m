Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A254B42C68B
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 18:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbhJMQm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 12:42:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhJMQm6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Oct 2021 12:42:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BFD261053;
        Wed, 13 Oct 2021 16:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634143254;
        bh=EkA4v0mjIRso7/q6xjB+Io2jQgAB0kuI5Qk2ZxsJEbc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EpzHwfYVA/JMLiYHeNNqhcFua+xB+6r/+EBy28SUsI/kauQBQR4ENEnlIlipNaM5W
         BvSUPpe5S1yXROsRj4m7NAUEfJhsymqlsUPmtqzoPXgBedAN3Q9vYKDeDkvRhnZdon
         wWyyCKb4VyTPuM44SxqqDkl7HD7UsMyqMN9ApobM=
Date:   Wed, 13 Oct 2021 18:40:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tomas Henzl <thenzl@redhat.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] mpi3mr: Fix duplicate device entries when scan through
 sysfs
Message-ID: <YWcMFGfAB9gFknes@kroah.com>
References: <20211013081656.16494-1-sreekanth.reddy@broadcom.com>
 <YWaXmqGGOtJaRbOk@kroah.com>
 <CAK=zhgo4CThfpRf37J3wufSjVByErdriBFpjMeBx2EumiRhR=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=zhgo4CThfpRf37J3wufSjVByErdriBFpjMeBx2EumiRhR=A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 13, 2021 at 09:35:39PM +0530, Sreekanth Reddy wrote:
> On Wed, Oct 13, 2021 at 1:53 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Oct 13, 2021 at 01:46:56PM +0530, Sreekanth Reddy wrote:
> > > When the user scans the devices through 'scan' sysfs using below
> > > command then the user will observe duplicate device entries
> > > in lsscsi command output.
> > > echo "- - -" > /sys/class/scsi_host/host0/scan
> > >
> > > Fix is to set the shost's max_channel to zero.
> > >
> > > Cc: stable@vger.kernel.org #v5.14.11+
> >
> > Please tag this based on a release of Linus's, or better yet, provide a
> > "Fixes:" commit so that the stable people know exactly where to backport
> > it to.
> Thanks, Shall I resend the patch with proper "Fixes:" commit ID.

Yes please.

> > As this is, we do not take patches only for stable kernels...
> This fix applies for the mainline kernel as well.

That's good, as that is the only way to get patches accepted :)
