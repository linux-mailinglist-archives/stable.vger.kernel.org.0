Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5906937C82B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238449AbhELQFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:05:00 -0400
Received: from 8bytes.org ([81.169.241.247]:38920 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235955AbhELQBs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:01:48 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 7621E247; Wed, 12 May 2021 18:00:32 +0200 (CEST)
Date:   Wed, 12 May 2021 18:00:31 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Dave Hansen <dave.hansen@intel.com>
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
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 3/6] x86/sev-es: Use __put_user()/__get_user
Message-ID: <YJv7n9aZPiQYgdmf@8bytes.org>
References: <20210512075445.18935-1-joro@8bytes.org>
 <20210512075445.18935-4-joro@8bytes.org>
 <9282239c-138c-7226-88d3-a5611d11cccd@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9282239c-138c-7226-88d3-a5611d11cccd@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 08:57:53AM -0700, Dave Hansen wrote:
> The changelog _helps_, but using a "user" function to handle kernel MMIO
> for its error handling properties seems like it's begging for a comment.
> 
> __put_user() also seems to have fun stuff like __chk_user_ptr().  It all
> seems sketchy to me.

Yeah, as Juergen already pointed out, there are certain problems with
that too. But I don't want to write my own accessors, so I will
introduce a separate user and kernel path to these functions.

Regards,

	Joerg
