Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5A4C9BFB
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 12:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbfJCKRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 06:17:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbfJCKRH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 06:17:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4263A218DE;
        Thu,  3 Oct 2019 10:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570097826;
        bh=5OM8J6Pb0uIJkb1p9cxTKr+YrVkdO+tv6hyPsF0Cfyc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rhsIpyLurUg+S7WEbSiisbWy2SDuhm/dW2Iqt8AyBF4GHsGzXzob/E2YHt6sXBvOH
         /90PFmM4I6sPmjvtgZ9/KnPZAn8PPp6JZU16ALgfOgSmVCwJPWRrnXasaVwmMeoGtX
         090oqdENht+MC/hMOowgeZdNCgpJryTTWUzl2bm0=
Date:   Thu, 3 Oct 2019 12:17:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     stable@vger.kernel.org, dan.carpenter@oracle.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com
Subject: Re: FAILED: patch "[PATCH] x86: KVM: svm: Fix a check in
 nested_svm_vmrun()" failed to apply to 5.3-stable tree
Message-ID: <20191003101704.GA2141015@kroah.com>
References: <1570089676108127@kroah.com>
 <87pnje18zy.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pnje18zy.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 11:19:45AM +0200, Vitaly Kuznetsov wrote:
> <gregkh@linuxfoundation.org> writes:
> 
> > The patch below does not apply to the 5.3-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> >
> > thanks,
> >
> > greg k-h
> >
> > ------------------ original commit in Linus's tree ------------------
> >
> > From a061985b81a20248da60589d01375ebe9bec4dfc Mon Sep 17 00:00:00 2001
> > From: Dan Carpenter <dan.carpenter@oracle.com>
> > Date: Tue, 27 Aug 2019 12:38:52 +0300
> > Subject: [PATCH] x86: KVM: svm: Fix a check in nested_svm_vmrun()
> >
> > We refactored this code a bit and accidentally deleted the "-" character
> > from "-EINVAL".  The kvm_vcpu_map() function never returns positive
> > EINVAL.
> >
> > Fixes: c8e16b78c614 ("x86: KVM: svm: eliminate hardcoded RIP
> > advancement from vmrun_interception()")
> 
> Hm, this commit wasn't backported to 5.3-stable so no fix is needed
> (scripts don't check pre-requisites like commits mentioned in Fixes:?)
> 
> Also, c8e16b78c614 is not a stable@ candidate IMO.
> 
> > Cc: stable@vger.kernel.org
> 
> This wasn't needed as it's only 5.4 which will have the offending commit
> and the fix.

Yes, I saw that, but as it was explicitly marked for the stable tree, I
wanted to verify that this really was not needed here.

thanks

greg k-h
