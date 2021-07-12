Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2EB3C62F3
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 20:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbhGLS4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 14:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230199AbhGLS4K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 14:56:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 534F16121E;
        Mon, 12 Jul 2021 18:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626116001;
        bh=P5X393WyIxdFqhqk+0CBPuqb8O6oBJbTZBpmyg5suV8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D2r0adsQKwvFOCRjsK7axLiTsaqXEAiBrP2hZLRJcoqNWG4I9Ws/7SC8WNWNNnHQC
         0Pce4/OTVrnG7nxORajnXcJkFTc2JInDMgcdJxeBEmkI2mfqgA0S6tSh+x7ksio0xQ
         KQIhhNHaEQ3D6veTSdZAm5+4AT3BdMW7kAQA8r6I=
Date:   Mon, 12 Jul 2021 20:53:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.12.16 (stable-queue, e2aabcec)
Message-ID: <YOyPn2MPRWjI3BnN@kroah.com>
References: <cki.4B06E639A0.ME3EXCXRTW@redhat.com>
 <CA+tGwnkjpwHE6=5MxFRnHSZ6=LYN_uiJQhTOP1oTr2rqhSiTyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+tGwnkjpwHE6=5MxFRnHSZ6=LYN_uiJQhTOP1oTr2rqhSiTyg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 03:40:01PM +0200, Veronika Kabatova wrote:
> On Mon, Jul 12, 2021 at 3:37 PM CKI Project <cki-project@redhat.com> wrote:
> >
> >
> > Hello,
> >
> > We ran automated tests on a recent commit from this kernel tree:
> >
> >        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> >             Commit: e2aabcece18e - powerpc/preempt: Don't touch the idle task's preempt_count during hotplug
> >
> > The results of these automated tests are provided below.
> >
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: FAILED
> >
> > All kernel binaries, config files, and logs are available for download here:
> >
> >   https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.html?prefix=datawarehouse-public/2021/07/12/335283844
> >
> > We attempted to compile the kernel for multiple architectures, but the compile
> > failed on one or more architectures:
> >
> >             x86_64: FAILED (see build-x86_64.log.xz attachment)
> 
> 00:07:45 sound/soc/intel/boards/sof_sdw.c:200:41: error: implicit
> declaration of function ‘SOF_BT_OFFLOAD_SSP’
> [-Werror=implicit-function-declaration]
> 00:07:45   200 |                                         SOF_BT_OFFLOAD_SSP(2) |
> 00:07:45       |                                         ^~~~~~~~~~~~~~~~~~
> 00:07:45 sound/soc/intel/boards/sof_sdw.c:201:41: error:
> ‘SOF_SSP_BT_OFFLOAD_PRESENT’ undeclared here (not in a function)
> 00:07:45   201 |
> SOF_SSP_BT_OFFLOAD_PRESENT),
> 00:07:45       |
> ^~~~~~~~~~~~~~~~~~~~~~~~~~
> 00:07:45 cc1: some warnings being treated as errors
> 00:07:45 make[6]: *** [scripts/Makefile.build:272:
> sound/soc/intel/boards/sof_sdw.o] Error 1
> 00:07:45 make[5]: *** [scripts/Makefile.build:515:
> sound/soc/intel/boards] Error 2
> 00:07:45 make[4]: *** [scripts/Makefile.build:515: sound/soc/intel] Error 2
> 00:07:45 make[3]: *** [scripts/Makefile.build:515: sound/soc] Error 2
> 00:07:45 make[2]: *** [Makefile:1859: sound] Error 2
> 
> 
> Hi, this looks to be introduced by
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=queue/5.12&id=514524d8977c5eca653e739fa580862f027e2b37
> 

Thanks, offending patches now dropped from all queues.

greg k-h
