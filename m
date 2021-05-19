Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FBB388DE9
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 14:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241545AbhESMYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 08:24:10 -0400
Received: from 8bytes.org ([81.169.241.247]:39896 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241424AbhESMYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 May 2021 08:24:10 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 562EB2FA; Wed, 19 May 2021 14:22:49 +0200 (CEST)
Date:   Wed, 19 May 2021 14:22:48 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     x86@kernel.org, Hyunwook Baek <baekhw@google.com>,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 4/6] Revert "x86/sev-es: Handle string port IO to kernel
 memory properly"
Message-ID: <YKUDGIrnR2doYEKj@8bytes.org>
References: <20210512075445.18935-1-joro@8bytes.org>
 <20210512075445.18935-5-joro@8bytes.org>
 <YJwSlVnHb0SZTSrG@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJwSlVnHb0SZTSrG@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 05:38:29PM +0000, Sean Christopherson wrote:
> Alternatively, and probably even better, fold this revert into the switch to
> the unchecked version (sounds like those will use kernel-specific flavors?).

I folded this revert into the previous commit. But I kept the
__get_user()/__put_user() calls and just added a comment explaining why
they are used and why it is safe to use them.

After all, even the get_kernel*() functions call __get_user_size() under
the hood.

Regards,

	Joerg
