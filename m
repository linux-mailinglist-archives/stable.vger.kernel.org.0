Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 132E7178CD2
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 09:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgCDIvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 03:51:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725271AbgCDIvQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 03:51:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6893220732;
        Wed,  4 Mar 2020 08:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583311875;
        bh=lc8ZcrxfTb7ziZCP6ve86LRFQyF/mtfu4M4IYApuctQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0EPbFPXmlJMC09ZrudEBw1DFLptEzQWrJkwffIcbT2InFZnVfTKtxckc2SINK8V3t
         ZEk6kf93chQD5mgbqN72G3VD2KPHczTsErUgQn//ZeVIJRl8YK3khNP98vZrkD9/6o
         0MBUjZ63PcolvfboDVLiw3Hf7YM1hqRv2l/GbA1c=
Date:   Wed, 4 Mar 2020 09:51:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Oliver Upton <oupton@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.5 111/176] KVM: nVMX: Emulate MTF when performing
 instruction emulation
Message-ID: <20200304085113.GA1419475@kroah.com>
References: <20200303174304.593872177@linuxfoundation.org>
 <20200303174317.670749078@linuxfoundation.org>
 <8780cf08-374b-da06-0047-0fe8eeec0113@redhat.com>
 <CAOQ_QsjG32KrG6hVMaMenUYk1+Z+jhcCsGOk=t9i+-9oZRGWeA@mail.gmail.com>
 <20200304081001.GB1401372@kroah.com>
 <04e51276-1759-2793-3b45-168284cbaf67@redhat.com>
 <20200304082613.GA1407851@kroah.com>
 <cf7c6b2d-64eb-8d13-3e9a-09c40d2ecf95@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf7c6b2d-64eb-8d13-3e9a-09c40d2ecf95@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 04, 2020 at 09:43:18AM +0100, Paolo Bonzini wrote:
> On 04/03/20 09:26, Greg Kroah-Hartman wrote:
> > On Wed, Mar 04, 2020 at 09:19:09AM +0100, Paolo Bonzini wrote:
> >> On 04/03/20 09:10, Greg Kroah-Hartman wrote:
> >>> I'll be glad to just put KVM into the "never apply any patches to
> >>> stable unless you explicitly mark it as such", but the sad fact is that
> >>> many recent KVM fixes for reported CVEs never had any "Cc: stable@vger"
> >>> markings.
> >>
> >> Hmm, I did miss it in 433f4ba1904100da65a311033f17a9bf586b287e and
> >> acff78477b9b4f26ecdf65733a4ed77fe837e9dc, but that's going back to
> >> August 2018, so I can do better but it's not too shabby a record. :)
> > 
> > 35a571346a94 ("KVM: nVMX: Check IO instruction VM-exit conditions")
> > e71237d3ff1a ("KVM: nVMX: Refactor IO bitmap checks into helper function")
> > 
> > Were both from a few weeks ago and needed to resolve CVE-2020-2732 :(
> 
> No, they weren't, only the patch that was CCed stable was needed to
> resolve the CVE.

Ah, that's not what was posted to oss-security :(

> Remember that at this point a lot of bugfixes or vulnerabilities in KVM
> exploit corner cases of the architecture and don't show up with the
> usual guests (Linux, Windows, BSDs).  Since we didn't have full
> information on the impact on guests that people do run, we started with
> the bare minimum (the two patches above) but only for 5.6.  The idea was
> to collect follow-up patches for 2-4 weeks, decide which subset was
> stable-worthy, and only then post them as stable backport subsets.

Ok, that's fine, but it would be good if someone told me about this so
that I knew what was going on when people asked me about this type of
thing :)

thanks,

greg k-h
