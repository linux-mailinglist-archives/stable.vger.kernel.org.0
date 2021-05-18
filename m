Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8C4387490
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 11:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242857AbhERJEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 05:04:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:57440 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242816AbhERJEo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 May 2021 05:04:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 792D0AEB9;
        Tue, 18 May 2021 09:03:25 +0000 (UTC)
Date:   Tue, 18 May 2021 11:03:23 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Brijesh Singh <brijesh.singh@amd.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] x86/sev-es: Invalidate the GHCB after completing
 VMGEXIT
Message-ID: <YKOC298KNQVaz1s+@suse.de>
References: <8c07662ec17d3d82e5c53841a1d9e766d3bdbab6.1621273353.git.thomas.lendacky@amd.com>
 <5a8130462e4f0057ee1184509cd056eedd78742b.1621273353.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a8130462e4f0057ee1184509cd056eedd78742b.1621273353.git.thomas.lendacky@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 12:42:33PM -0500, Tom Lendacky wrote:
> Since the VMGEXIT instruction can be issued from userspace, invalidate
> the GHCB after performing VMGEXIT processing in the kernel.
> 
> Invalidation is only required after userspace is available, so call
> vc_ghcb_invalidate() from sev_es_put_ghcb(). Update vc_ghcb_invalidate()
> to additionally clear the GHCB exit code, so that a value of 0 is always
> present outside VMGEXIT processing in the kernel.
> 
> Fixes: 0786138c78e79 ("x86/sev-es: Add a Runtime #VC Exception Handler")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Reviewed-by: Joerg Roedel <jroedel@suse.de>

