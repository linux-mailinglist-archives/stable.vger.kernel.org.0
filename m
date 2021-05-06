Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9B1375A22
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 20:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbhEFSZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 14:25:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:51046 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231839AbhEFSZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 May 2021 14:25:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 26F63AF98;
        Thu,  6 May 2021 18:24:04 +0000 (UTC)
Date:   Thu, 6 May 2021 20:24:01 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Eric Biederman <ebiederm@xmission.com>, x86@kernel.org,
        kexec@lists.infradead.org, stable@vger.kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
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
Subject: Re: [PATCH 1/2] kexec: Allow architecture code to opt-out at runtime
Message-ID: <YJQ0QdjdRwpMkIqU@suse.de>
References: <20210506093122.28607-1-joro@8bytes.org>
 <20210506093122.28607-2-joro@8bytes.org>
 <YJQOmxx1EMUqNpNn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJQOmxx1EMUqNpNn@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 06, 2021 at 03:43:23PM +0000, Sean Christopherson wrote:
> This misses kexec_file_load.

Right, thanks, I will fix that in the next version.

> Also, is a new hook really needed?  E.g. the SEV-ES check be shoved
> into machine_kexec_prepare().  The downside is that we'd do a fair
> amount of work before detecting failure, but that doesn't seem hugely
> problematic.

That could work, but I think its more user-friendly to just claim that
the syscalls are not supported at all.

Regards,

	Joerg
