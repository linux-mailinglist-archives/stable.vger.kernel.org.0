Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F035D1659F5
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 10:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgBTJRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 04:17:03 -0500
Received: from imap3.hz.codethink.co.uk ([176.9.8.87]:36366 "EHLO
        imap3.hz.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgBTJRC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 04:17:02 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone)
        by imap3.hz.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1j4hwy-0006hi-95; Thu, 20 Feb 2020 09:16:52 +0000
Message-ID: <fc00f38ef8db90d982dad4de41e97918b565d321.camel@codethink.co.uk>
Subject: Re: FAILED: patch "[PATCH] KVM: VMX: Add non-canonical check on
 writes to RTIT address" failed to apply to 4.19-stable tree
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org
Cc:     sean.j.christopherson@intel.com, pbonzini@redhat.com,
        stable@vger.kernel.org
Date:   Thu, 20 Feb 2020 09:16:51 +0000
In-Reply-To: <20200209201223.GZ3584@sasha-vm>
References: <15812515183712@kroah.com> <20200209201223.GZ3584@sasha-vm>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2020-02-09 at 15:12 -0500, Sasha Levin wrote:
> On Sun, Feb 09, 2020 at 01:31:58PM +0100, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 4.19-stable tree.
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
> > From fe6ed369fca98e99df55c932b85782a5687526b5 Mon Sep 17 00:00:00 2001
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > Date: Tue, 10 Dec 2019 15:24:32 -0800
> > Subject: [PATCH] KVM: VMX: Add non-canonical check on writes to RTIT address
> > MSRs
> > 
> > Reject writes to RTIT address MSRs if the data being written is a
> > non-canonical address as the MSRs are subject to canonical checks, e.g.
> > KVM will trigger an unchecked #GP when loading the values to hardware
> > during pt_guest_enter().
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> File/code movement. Cleaned up and queued for 4.19-4.4.

I don't know what happened here, but you've ended up adding the
entirety of arch/x86/kvm/vmx/vmx.c on all those branches rather than
applying the change to the right file.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

