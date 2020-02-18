Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27FEA1633C0
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 22:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgBRVDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 16:03:25 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:36933 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgBRVDY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 16:03:24 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j4A1O-0006ER-Ar; Tue, 18 Feb 2020 22:03:10 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id B684E100617; Tue, 18 Feb 2020 22:03:09 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     Juergen Gross <jgross@suse.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        "VMware\, Inc." <pv-drivers@vmware.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/ioperm: add new paravirt function update_io_bitmap
In-Reply-To: <20200218154712.25490-1-jgross@suse.com>
References: <20200218154712.25490-1-jgross@suse.com>
Date:   Tue, 18 Feb 2020 22:03:09 +0100
Message-ID: <87mu9fr4ky.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Juergen Gross <jgross@suse.com> writes:
> Commit 111e7b15cf10f6 ("x86/ioperm: Extend IOPL config to control
> ioperm() as well") reworked the iopl syscall to use I/O bitmaps.
>
> Unfortunately this broke Xen PV domains using that syscall as there
> is currently no I/O bitmap support in PV domains.
>
> Add I/O bitmap support via a new paravirt function update_io_bitmap
> which Xen PV domains can use to update their I/O bitmaps via a
> hypercall.
>
> Fixes: 111e7b15cf10f6 ("x86/ioperm: Extend IOPL config to control ioperm() as well")
> Reported-by: Jan Beulich <jbeulich@suse.com>
> Cc: <stable@vger.kernel.org> # 5.5
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Reviewed-by: Jan Beulich <jbeulich@suse.com>
> Tested-by: Jan Beulich <jbeulich@suse.com>

Duh, sorry about that and thanks for fixing it.

BTW, why isn't stuff like this not catched during next or at least
before the final release? Is nothing running CI on upstream with all
that XEN muck active?

Thanks,

        tglx
