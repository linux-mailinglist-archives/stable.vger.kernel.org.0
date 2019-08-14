Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A34BC8CD4E
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 09:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfHNH5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 03:57:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:33438 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725928AbfHNH5y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 03:57:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2CD97ACBD;
        Wed, 14 Aug 2019 07:57:53 +0000 (UTC)
Date:   Wed, 14 Aug 2019 09:57:51 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3 5.2-stable] Sync mappings in vmalloc/ioremap areas
Message-ID: <20190814075751.GC9222@suse.de>
References: <20190813152814.5354-1-joro@8bytes.org>
 <20190813183642.GC6582@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813183642.GC6582@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Aug 13, 2019 at 08:36:42PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Aug 13, 2019 at 05:28:11PM +0200, Joerg Roedel wrote:
> > From: Joerg Roedel <jroedel@suse.de>
> > 
> > Backport commits from upstream to fix a data corruption
> > issue that gets exposed when using PTI on x86-32.
> > 
> > Please consider them for inclusion into stable-5.2.
> 
> Thanks for these.  Based on the Fixes: tags on the commits, I've taken
> them all the way back to 4.4.y.

Thank you! The problem almost only exposes itself when PTI on x86-32 is
enabled (which was merged in 4.19), so I only backported down to that
kernel.

But it is right that it might be possible to trigger the problem on
older kernels too, e.g. in some 32bit XEN-pv configurations that use
same PAE page-table structures as the PTI code for 32bit.

So thanks for picking the fixes up for the older kernels too.


Regards,

	Joerg

