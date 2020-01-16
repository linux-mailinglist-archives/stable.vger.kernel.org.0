Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAD013F834
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733240AbgAPTQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:16:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:50650 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733204AbgAPTQd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 14:16:33 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jan 2020 11:16:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,327,1574150400"; 
   d="scan'208";a="373426824"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.25])
  by orsmga004.jf.intel.com with ESMTP; 16 Jan 2020 11:16:32 -0800
Date:   Thu, 16 Jan 2020 11:16:32 -0800
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Jari Ruusu <jari.ruusu@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Fenghua Yu <fenghua.yu@intel.com>, johannes.berg@intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: Fix built-in early-load Intel microcode alignment
Message-ID: <20200116191632.GB117689@otc-nc-03>
References: <CACMCwJLJCA2iXS0QMKKAWQv252oUcmfsNvwDNP5+4Z_9VB-rTg@mail.gmail.com>
 <5C216684-6FDF-41B5-9F51-89DC295F6DDC@amacapital.net>
 <CACMCwJLogOH-nG7QEMzrXK-iJPOdzCrL05y0a6yAbtPsfdRjsQ@mail.gmail.com>
 <CAHk-=wiqPHc=BzSYO4N=awucq0td3s9VuBkct=m-B_xZVCgzBg@mail.gmail.com>
 <CACMCwJL+kdkJRfRhG6bt_ojU0UeipqxVL3vwS3ETqVEjnWL1ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACMCwJL+kdkJRfRhG6bt_ojU0UeipqxVL3vwS3ETqVEjnWL1ew@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jari

Sorry for the delay, just returned after a long vacation. 

On Thu, Jan 16, 2020 at 08:55:52AM +0200, Jari Ruusu wrote:
> On 1/15/20, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > However, the most likely cause is that you have a borderline dodgy
> > system, and the microcode update then just triggers a pre-existing
> > problem.
> 
> For that particular processor model, there appears to be microcode
> updates for four steppings: 9 10 11 and 12. My model is stepping
> 9, so it appears to be early commercially sold version of that
> model. Probably more problems on it than on later steppings.

I don't suspect the alignment issue during microcode load to trigger
any hangs after couple days. Its only used to copy to some internal store.
So once the ucode is loaded and if you look at /proc/cpuinfo and it reflects
the latest microcode you are past the alignment issue. I suspect its
something else.

Can you please also document the OEM, BIOS versions, and also both the
old and new microcode versions after the update.

Would suggest logging the hang issue in public github for microcode issues.
This would let the product folks look at them.

https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files

> 
> > But it might be worth it if the intel people could check up with their
> > microcode people on this anyway - if there is _one_ report of "my
> > system locks up with newer ucode", that's one thing. But if Jari isn't
> > alone...
> 

Cheers,
Ashok
