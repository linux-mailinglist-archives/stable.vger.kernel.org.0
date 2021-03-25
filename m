Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D5F349CD5
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 00:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhCYXU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 19:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231378AbhCYXT7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 19:19:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0197761A0F;
        Thu, 25 Mar 2021 23:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616714399;
        bh=OalJxYsX/8zbFXAfh8XZiTq4+jcNEcC9CIhGxum63FM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oq32UKdDcqPGZse/zfj3fkD+ijd2qjGrWUXgVQTxNzBqtIeyVrueHh0v9CP3/T4ql
         pzY8/s9ferwFSgW/gXs6Ljd6M6YgxOAAuhCMv0V8VM6hSI926WbbmpjY+aQZ9HLOth
         VDZ1eotqwymHtXYdNdvtYkCgMzkdI6zisoDkKU9GSy5pVSLgedBt9pNEdgI7N/9oYS
         qlR0fqervi8DkN2y8XTJjfDeqUPQu9csljgFELKjf7MUHL2ur82iYv4j4yQU3K/Lid
         Dy1zZFOnWbef7FCtdlvFTqCbmOrMhZTMonvlUxjS9c6L0EWl3F3Ndk73IZiEZBMQQi
         HwW2rXmk2tw0g==
Date:   Thu, 25 Mar 2021 19:19:58 -0400
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
Message-ID: <YF0anj5TFU5D8tXD@sashalap>
References: <4a72f780-3797-229e-a938-6dc5b14bec8d@amd.com>
 <20210311235215.GI5829@zn.tnic>
 <ed590709-65c8-ca2f-013f-d2c63d5ee0b7@amd.com>
 <20210324212139.GN5010@zn.tnic>
 <alpine.LSU.2.11.2103241651280.9593@eggly.anvils>
 <alpine.LSU.2.11.2103241913190.10112@eggly.anvils>
 <20210325095619.GC31322@zn.tnic>
 <20210325102959.GD31322@zn.tnic>
 <20210325200942.GJ31322@zn.tnic>
 <YFz0Z8/6eeYI72fq@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YFz0Z8/6eeYI72fq@sashalap>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 25, 2021 at 04:36:55PM -0400, Sasha Levin wrote:
>On Thu, Mar 25, 2021 at 09:09:42PM +0100, Borislav Petkov wrote:
>>Hi stable folks,
>>
>>the patch below fixes kernels 4.4 and 4.9 booting on AMD platforms with
>>PCID support. It doesn't have an upstream counterpart because it patches
>>the KAISER code which didn't go upstream. It applies fine to both of the
>>aforementioned kernels - please pick it up.
>
>Queued up for 4.9 and 4.4, thanks!
>
>>Jim Mattson reported that Debian 9 guests using a 4.9-stable kernel
>>are exploding during alternatives patching:
>
>(Cc Ben & Salvatore)
>
>I'm not sure if 4.9 or Debian is still alive or not, but FYI...
		    *on

		    :)
-- 
Thanks,
Sasha
