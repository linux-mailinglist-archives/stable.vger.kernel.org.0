Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A7E349B0E
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 21:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhCYUhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 16:37:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhCYUg4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 16:36:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CA8B61A14;
        Thu, 25 Mar 2021 20:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616704616;
        bh=VSbFA7ucpE6JJRiKfn6zhywfXOSQMvdyf+Ys4VxCeHM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I5o3QjeDIfNOu3ZASK82Au3m3EFFXX+3l8Zp1KviboLMKRvN+RPL1QUl76VxFELp1
         /eh6XGCVeNz3CS8N7k+nCqcyVYKSuu+HaCUqy6PowqOCKF0ybv5JxzOKRBx4kRtfud
         TTyRt32P1x/1PyT835qza80lgrv/6bJgYwEKu03Tmp9Vz3h8rPY21lFb4PaQPMeRnP
         rMMAQ51e0QIUpeWanp/tbBoUvcGZe2b2XBFriDqPqBOTbb38MeDwSGhmHZZjvNOq/Q
         7kntmGH0HbgItmg0Li3m2GHg/PmsLyVavYFjHprcJwrOUenGDmLO1ucLVBKy7SrEz2
         n9fHSo63xOLZg==
Date:   Thu, 25 Mar 2021 16:36:55 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     stable <stable@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Babu Moger <babu.moger@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>, carnil@debian.org,
        ben@decadent.org.uk
Subject: Re: [PATCH] x86/tlb: Flush global mappings when KAISER is disabled
Message-ID: <YFz0Z8/6eeYI72fq@sashalap>
References: <d3e9e091-0fc8-1e11-ab99-9c8be086f1dc@amd.com>
 <4a72f780-3797-229e-a938-6dc5b14bec8d@amd.com>
 <20210311235215.GI5829@zn.tnic>
 <ed590709-65c8-ca2f-013f-d2c63d5ee0b7@amd.com>
 <20210324212139.GN5010@zn.tnic>
 <alpine.LSU.2.11.2103241651280.9593@eggly.anvils>
 <alpine.LSU.2.11.2103241913190.10112@eggly.anvils>
 <20210325095619.GC31322@zn.tnic>
 <20210325102959.GD31322@zn.tnic>
 <20210325200942.GJ31322@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210325200942.GJ31322@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 25, 2021 at 09:09:42PM +0100, Borislav Petkov wrote:
>Hi stable folks,
>
>the patch below fixes kernels 4.4 and 4.9 booting on AMD platforms with
>PCID support. It doesn't have an upstream counterpart because it patches
>the KAISER code which didn't go upstream. It applies fine to both of the
>aforementioned kernels - please pick it up.

Queued up for 4.9 and 4.4, thanks!

>Jim Mattson reported that Debian 9 guests using a 4.9-stable kernel
>are exploding during alternatives patching:

(Cc Ben & Salvatore)

I'm not sure if 4.9 or Debian is still alive or not, but FYI...

-- 
Thanks,
Sasha
