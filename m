Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9A148C472
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 14:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353391AbiALNMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 08:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353396AbiALNMI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 08:12:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A32C061748
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 05:12:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F9EC61919
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 13:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74292C36AEA;
        Wed, 12 Jan 2022 13:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641993126;
        bh=t1BScziANUkYHYbQguI+65+Dv12n8Hb7sF1vMHkQC6w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RoryXVGedvvSdA2X04t0VSNkW42BYIpG4e+Oxlb1H1RTueN+gvPZcWqoGn/F4qamn
         MXCF/pvf49hRIq3VqUiscL4k9xQL8sLHvd68cX3dbNy63psAKNDahl290XEkkhePFi
         QeXOpp6ITAukPhPU3GF/70OAhaf63sl2ttqDKO6k=
Date:   Wed, 12 Jan 2022 14:12:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Egorenkov <egorenar@linux.ibm.com>
Cc:     hca@linux.ibm.com, ltao@redhat.com, prudo@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] s390/kexec: handle R_390_PLT32DBL rela
 in" failed to apply to 5.15-stable tree
Message-ID: <Yd7TogdbfW6dcFyy@kroah.com>
References: <1639748305210135@kroah.com>
 <8735lt8gs9.fsf@oc8242746057.ibm.com>
 <Yd6v5Ob3a883gCX+@kroah.com>
 <87tue96ruj.fsf@oc8242746057.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tue96ruj.fsf@oc8242746057.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 12, 2022 at 01:50:12PM +0100, Alexander Egorenkov wrote:
> Hi Greg,
> 
> Greg KH <gregkh@linuxfoundation.org> writes:
> 
> > On Wed, Jan 12, 2022 at 10:06:14AM +0100, Alexander Egorenkov wrote:
> >> Hi Greg,
> >> 
> >> <gregkh@linuxfoundation.org> writes:
> >> 
> >> > The patch below does not apply to the 5.15-stable tree.
> >> > If someone wants it applied there, or to any other stable or longterm
> >> > tree, then please email the backport, including the original git commit
> >> > id to <stable@vger.kernel.org>.
> >> >
> >> > thanks,
> >> >
> >> > greg k-h
> >> >
> >> 
> >> please apply the following upstream commits (in this order):
> >> 
> >> 1. edce10ee21f3916f5da34e55bbc03103c604ba70
> >
> > This commit fails to apply.
> >
> >> 2. 41967a37b8eedfee15b81406a9f3015be90d3980
> >> 3. abf0e8e4ef25478a4390115e6a953d589d1f9ffd (the failed commit)
> >
> > Can you please send a working set of backported patches that we can
> > apply?
> >
> 
> I tested the stable branch 5.15.y and discovered that
> the fix 41967a37b8eedfee15b81406a9f3015be90d3980 is already present
> there.
> 
> Please try to apply just abf0e8e4ef25478a4390115e6a953d589d1f9ffd again.
> I think you probably tried to apply
> abf0e8e4ef25478a4390115e6a953d589d1f9ffd before
> 41967a37b8eedfee15b81406a9f3015be90d3980 was present ?
> And now that is there, everything works.

Ah, yes, I think that is what must have happened here, it now worked,
thanks.

greg k-h
