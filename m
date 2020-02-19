Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C934164042
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 10:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgBSJXA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 19 Feb 2020 04:23:00 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:37697 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbgBSJW7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Feb 2020 04:22:59 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j4LZ7-00015z-GQ; Wed, 19 Feb 2020 10:22:45 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 1EF39103A05; Wed, 19 Feb 2020 10:22:45 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     =?utf-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        "VMware\, Inc." <pv-drivers@vmware.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/ioperm: add new paravirt function update_io_bitmap
In-Reply-To: <b0f33786-79b1-f8ee-24ae-ce9f9f4791af@suse.com>
References: <20200218154712.25490-1-jgross@suse.com> <87mu9fr4ky.fsf@nanos.tec.linutronix.de> <b0f33786-79b1-f8ee-24ae-ce9f9f4791af@suse.com>
Date:   Wed, 19 Feb 2020 10:22:45 +0100
Message-ID: <8736b7q6ca.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jürgen Groß <jgross@suse.com> writes:
> On 18.02.20 22:03, Thomas Gleixner wrote:
>> BTW, why isn't stuff like this not catched during next or at least
>> before the final release? Is nothing running CI on upstream with all
>> that XEN muck active?
>
> This problem showed up by not being able to start the X server (probably
> not the freshest one) in dom0 on a moderate aged AMD system.
>
> Our CI tests tend do be more text console based for dom0.

tools/testing/selftests/x86/io[perm|pl] should have caught that as well,
right? If not, we need to fix the selftests.

Thanks,

        tglx
