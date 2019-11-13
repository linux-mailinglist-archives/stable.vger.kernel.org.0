Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E92EAF9FF7
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfKMBOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:14:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbfKMBOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:14:37 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D735222C9;
        Wed, 13 Nov 2019 01:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573607677;
        bh=qqHFtH1sjrKzVDfjQo1y/zN54352Jnzdj98KMD/Ycd0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Okpd6z7XM64hEbFgyPbEtvEVivlHV4jOLWnOjGh4YQgknbYgrH5Gm1gVPJmUATNs9
         ag4eQLGrwKuT9aZdqO9C79+fROmJ++UPiJj1RklQkVd1fSnwsPwwN/RD8daF3Yj12o
         rhk5NsEhoEr0fD/g2CZWFxZ9Bo1JmxY6NrC5nK1k=
Date:   Tue, 12 Nov 2019 20:14:36 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.14 STABLE 0/2] KVM: x86: PAE related bug fixes
Message-ID: <20191113011436.GK8496@sasha-vm>
References: <20191111233718.28438-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191111233718.28438-1-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 03:37:16PM -0800, Sean Christopherson wrote:
>The primary goal is to land patch 2/2 (from Paolo), which fixes a reported
>crash when running 64-bit KVM guests on systems without unrestricted guest
>support.
>
>Attempting to cherry-pick Paolo's patch revealed that a similar PAE bug
>fix from Junaid was also missing.  Grab Junaid's patch as a prerequisite,
>even though it will effectively be overwritten, so that Paolo's upstream
>fix can be applied without modification (sans the vmx.c split in 5.x).
>
>Junaid Shahid (1):
>  kvm: mmu: Don't read PDPTEs when paging is not enabled
>
>Paolo Bonzini (1):
>  KVM: x86: introduce is_pae_paging
>
> arch/x86/kvm/vmx.c | 7 +++----
> arch/x86/kvm/x86.c | 8 ++++----
> arch/x86/kvm/x86.h | 5 +++++
> 3 files changed, 12 insertions(+), 8 deletions(-)

Queued up for 4.14, thank you.

-- 
Thanks,
Sasha
