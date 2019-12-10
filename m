Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8A29118CA9
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 16:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbfLJPhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 10:37:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:22276 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727380AbfLJPhE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 10:37:04 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 07:37:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,300,1571727600"; 
   d="scan'208";a="363294114"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 10 Dec 2019 07:37:03 -0800
Date:   Tue, 10 Dec 2019 07:37:03 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        thomas.lendacky@amd.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: use CPUID to locate host page table
 reserved bits
Message-ID: <20191210153702.GA15758@linux.intel.com>
References: <1575474037-7903-1-git-send-email-pbonzini@redhat.com>
 <20191204154806.GC6323@linux.intel.com>
 <9951afb8-8f91-2fe1-3893-04307fafa570@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9951afb8-8f91-2fe1-3893-04307fafa570@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 10, 2019 at 10:19:57AM +0100, Paolo Bonzini wrote:
> On 04/12/19 16:48, Sean Christopherson wrote:
> >> +	/*
> >> +	 * Quite weird to have VMX or SVM but not MAXPHYADDR; probably a VM with
> >> +	 * custom CPUID.  Proceed with whatever the kernel found since these features
> >> +	 * aren't virtualizable (SME/SEV also require CPUIDs higher than 0x80000008).
> > No love for MKTME?  :-D
> 
> I admit I didn't check, but does MKTME really require CPUID leaves in
> the "AMD range"?  (My machines have 0x80000008 as the highest supported
> leaf in that range).

Ah, no, I just misunderstood what the blurb in the parentheses was saying.
