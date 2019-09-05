Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE585AABC6
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 21:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387769AbfIETO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 15:14:29 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44192 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfIETO3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 15:14:29 -0400
Received: from p5de0b6c5.dip0.t-ipconnect.de ([93.224.182.197] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1i5xCx-0007se-MN; Thu, 05 Sep 2019 21:14:15 +0200
Date:   Thu, 5 Sep 2019 21:14:14 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Mike Travis <mike.travis@hpe.com>
cc:     Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Christoph Hellwig <hch@infradead.org>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 0/8] x86/platform/UV: Update UV Hubless System Support
In-Reply-To: <d90ffd5c-2e9f-ead2-b866-0af4ab261591@hpe.com>
Message-ID: <alpine.DEB.2.21.1909052113130.1902@nanos.tec.linutronix.de>
References: <20190905184741.256857552@stormcage.eag.rdlabs.hpecorp.net> <alpine.DEB.2.21.1909052056210.1902@nanos.tec.linutronix.de> <d90ffd5c-2e9f-ead2-b866-0af4ab261591@hpe.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 5 Sep 2019, Mike Travis wrote:
> On 9/5/2019 12:02 PM, Thomas Gleixner wrote:
> > Mike,
> > 
> > On Thu, 5 Sep 2019, Mike Travis wrote:
> > 
> > > These patches support upcoming UV systems that do not have a UV HUB.
> > > 
> > > 	* Save OEM_ID from ACPI MADT probe
> > > 	* Return UV Hubless System Type
> > > 	* Add return code to UV BIOS Init function
> > > 	* Setup UV functions for Hubless UV Systems
> > > 	* Add UV Hubbed/Hubless Proc FS Files
> > > 	* Decode UVsystab Info
> > > 	* Account for UV Hubless in is_uvX_hub Ops
> > 
> > Can you please in future mark the next version of a patch or patch series
> > with [PATCH V2 n/M] so its clear that this is something different and also
> > add a quick summary what changed vs. V1? Adding to each patch which changed
> > a short change info _after_ the '---' discard line is also good practice
> > and helps reviewers to figure out which part needs to be looked at.
> > 
> > Thanks
> > 
> > 	tglx
> > 
> 
> Yeah, I noticed that the V2: tag for the removal that Greg requested was
> missing in the copy sent to me.  Sorry I didn't catch that earlier.
> 
> The "[PATCH V2 n/M]" is something I hadn't been aware but I am now.
> 
> Should I resend the patches again with those updates?

No, please provide a summary of changes as a reply to the cover letter and
point out which patches were actually changed vs. v1.

Thanks,

	tglx
