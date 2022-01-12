Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9ECE48C270
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 11:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352584AbiALKke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 05:40:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36304 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352604AbiALKjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 05:39:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A093CB81D6E
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 10:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA289C36AEA;
        Wed, 12 Jan 2022 10:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641983975;
        bh=xmMkc7eoVqznzYw3K32BJLnIBKIV1DEB/SKRW/enw/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GvKZMtHiKXLjsuKaEQP+GSx/cszThmrnippDrReHuvPKMLuPOtiEJk5E75nd4v3Kk
         ceLIeU1WY0258a423lcILkOQHS9QKQX0tTRbbhQ0FjH0iB/Dw7CfjtsOsAbIkjv64a
         Hl7nbfDHCHWXc8/MqQsm4ZsvoQr8kRYcbri/H06k=
Date:   Wed, 12 Jan 2022 11:39:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Egorenkov <egorenar@linux.ibm.com>
Cc:     hca@linux.ibm.com, ltao@redhat.com, prudo@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] s390/kexec: handle R_390_PLT32DBL rela
 in" failed to apply to 5.15-stable tree
Message-ID: <Yd6v5Ob3a883gCX+@kroah.com>
References: <1639748305210135@kroah.com>
 <8735lt8gs9.fsf@oc8242746057.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735lt8gs9.fsf@oc8242746057.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 12, 2022 at 10:06:14AM +0100, Alexander Egorenkov wrote:
> Hi Greg,
> 
> <gregkh@linuxfoundation.org> writes:
> 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> please apply the following upstream commits (in this order):
> 
> 1. edce10ee21f3916f5da34e55bbc03103c604ba70

This commit fails to apply.

> 2. 41967a37b8eedfee15b81406a9f3015be90d3980
> 3. abf0e8e4ef25478a4390115e6a953d589d1f9ffd (the failed commit)

Can you please send a working set of backported patches that we can
apply?

thanks,

greg k-h
