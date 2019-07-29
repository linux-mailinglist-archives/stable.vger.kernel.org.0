Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4526578F48
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 17:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387952AbfG2Pbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 11:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387897AbfG2Pbp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 11:31:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D98862070D;
        Mon, 29 Jul 2019 15:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564414304;
        bh=rQhzlH0PIiskH8UUvq8XfFi4T6uw9eNwW5Hvq52YJwQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iqw05uUSPI8ca7MSPGeT1sJEJNVkIktr5FFNfd01hLwpF5rRppjl8e4dJ94npVVbX
         qhqV+PY0jIGrnJphHFfQ3XotAkOsokxZF/vKmj5Wfp2JW+oqLlif9ICF0wnII8XzGm
         Plp+HLxii3AuxrhHya5BdnBkLmQjP1Hkw+MZBKUs=
Date:   Mon, 29 Jul 2019 17:31:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jack Wang <jack.wang.usish@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, stable@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH stable-4.19 1/2] KVM: nVMX: do not use dangling shadow
 VMCS after guest reset
Message-ID: <20190729153141.GA9692@kroah.com>
References: <20190725104645.30642-1-vkuznets@redhat.com>
 <20190725104645.30642-2-vkuznets@redhat.com>
 <CA+res+RfqpT=g1QbCqr3OkHVzFFSAt3cfCYNcwqiemWmOifFxg@mail.gmail.com>
 <2ea5d588-8573-6653-b848-0b06d1f98310@redhat.com>
 <CA+res+ShqmPcJWj+0F7X8=0DM_ys8HCP+rjg4Nv-7o06EipJQw@mail.gmail.com>
 <471a1023-4f0a-5727-e7b2-48701f75188f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471a1023-4f0a-5727-e7b2-48701f75188f@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 11:30:19AM +0200, Paolo Bonzini wrote:
> On 29/07/19 11:29, Jack Wang wrote:
> > Thanks Paolo for confirmation. I'm asking because we had one incident
> > in our production with 4.14.129 kernel,
> > System is Skylake Gold cpu, first kvm errors, host hung afterwards
> > 
> > kernel: [1186161.091160] kvm: vmptrld           (null)/6bfc00000000 failed
> > kernel: [1186161.091537] kvm: vmclear fail:           (null)/6bfc00000000
> > kernel: [1186186.490300] watchdog: BUG: soft lockup - CPU#54 stuck for
> > 23s! [qemu:16639]
> > 
> > Hi Sasha, hi Greg,
> > 
> > Would be great if you can pick this patch also to 4.14 kernel.
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Ok, now queued up, thanks.

greg k-h
