Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99FD32248C1
	for <lists+stable@lfdr.de>; Sat, 18 Jul 2020 06:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgGREkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jul 2020 00:40:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:44846 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgGREkg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Jul 2020 00:40:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AE7E6AE47;
        Sat, 18 Jul 2020 04:40:39 +0000 (UTC)
Subject: Re: [PATCH v3] x86/ioperm: Fix io bitmap invalidation on Xen PV
To:     Andy Lutomirski <luto@kernel.org>, x86@kernel.org
Cc:     Andrew Cooper <andrew.cooper3@citrix.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <d53075590e1f91c19f8af705059d3ff99424c020.1595030016.git.luto@kernel.org>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <b419bbc1-5bff-2298-a2be-68c892b0999f@suse.com>
Date:   Sat, 18 Jul 2020 06:40:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <d53075590e1f91c19f8af705059d3ff99424c020.1595030016.git.luto@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18.07.20 01:53, Andy Lutomirski wrote:
> tss_invalidate_io_bitmap() wasn't wired up properly through the pvop
> machinery, so the TSS and Xen's io bitmap would get out of sync
> whenever disabling a valid io bitmap.
> 
> Add a new pvop for tss_invalidate_io_bitmap() to fix it.
> 
> This is XSA-329.
> 
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: Stefano Stabellini <sstabellini@kernel.org>
> Cc: stable@vger.kernel.org
> Fixes: 22fe5b0439dd ("x86/ioperm: Move TSS bitmap update to exit to user work")
> Reviewed-by: Juergen Gross <jgross@suse.com>
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

Reviewed-by: Juergen Gross <jgross@suse.com>


Juergen
