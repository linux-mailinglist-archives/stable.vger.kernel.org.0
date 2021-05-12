Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981D037B890
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhELIvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:51:52 -0400
Received: from 8bytes.org ([81.169.241.247]:38848 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230137AbhELIvv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 04:51:51 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id D8842F3; Wed, 12 May 2021 10:50:42 +0200 (CEST)
Date:   Wed, 12 May 2021 10:50:41 +0200
From:   'Joerg Roedel' <joro@8bytes.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     David Laight <David.Laight@aculab.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Hyunwook Baek <baekhw@google.com>,
        Joerg Roedel <jroedel@suse.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 3/6] x86/sev-es: Use __put_user()/__get_user
Message-ID: <YJuW4TtRJKZ+OIhj@8bytes.org>
References: <20210512075445.18935-1-joro@8bytes.org>
 <20210512075445.18935-4-joro@8bytes.org>
 <0496626f018d4d27a8034a4822170222@AcuMS.aculab.com>
 <fcb2c501-70ca-1a54-4a75-8ab05c21ee30@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcb2c501-70ca-1a54-4a75-8ab05c21ee30@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 10:16:12AM +0200, Juergen Gross wrote:
> You want something like xen_safe_[read|write]_ulong().

From a first glance I can't see it, what is the difference between the
xen_safe_*_ulong() functions and __get_user()/__put_user()? The only
difference I can see is that __get/__put_user() support different access
sizes, but neither of those disables page-faults by itself, for example.

Couldn't these xen-specific functions not also be replaces by
__get_user()/__put_user()?

Regards,

	Joerg

