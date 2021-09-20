Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD34411824
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 17:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235845AbhITP0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 11:26:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232422AbhITP0I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 11:26:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7606A610A8;
        Mon, 20 Sep 2021 15:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632151482;
        bh=YjQ8NzjrgmxykSP2jvB1DcacMBKkq1X9jkOSod5T2LM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TNSgRPZukSUK0AF3vRmFOPBQcv2lnQZsRjf5ALf72kRoGKSQjbFsFQxxa3b3QYbj+
         xaAtzjIaHZUXE+AA3AnSvIIM0qF20BrARZDCRDrVOEYQL8SmyilhZhqd8t0JZvdRC2
         +3Tj4u8bzbyXDw+EiNKoSGphL/8lBeRevsAVgfIc=
Date:   Mon, 20 Sep 2021 17:24:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 0/1] KVM: s390: backport for stable of "KVM: s390: index
Message-ID: <YUint4b1ETglbj8z@kroah.com>
References: <20210920150616.15668-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920150616.15668-1-borntraeger@de.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 05:06:15PM +0200, Christian Borntraeger wrote:
> Stable team,
> 
> here is a backport for 4.19 of
> commit a3e03bc1368 ("KVM: s390: index kvm->arch.idle_mask by vcpu_idx")
> This basically removes the kick_mask parts that were introduced with
> kernel 5.0 and fixes up the location of the idle_mask to the older
> place.

Now queued up, thanks.

> FWIW, it might be a good idea to also backport
> 8750e72a79dd ("KVM: remember position in kvm->vcpus array") to avoid
> a performance regression for large guests (many vCPUs) when this patch
> is applied. 
> @Paolo Bonzini, would you be ok with 8750e72a79dd in older stable releases?

That would also have to go into 5.4.y, right?

thanks,

greg k-h
