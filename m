Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2065164B1
	for <lists+stable@lfdr.de>; Sun,  1 May 2022 16:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbiEAO1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 10:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiEAO1E (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 May 2022 10:27:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6036C1FCE2
        for <stable@vger.kernel.org>; Sun,  1 May 2022 07:23:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 047AEB80CED
        for <stable@vger.kernel.org>; Sun,  1 May 2022 14:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D128C385AA;
        Sun,  1 May 2022 14:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651415015;
        bh=iv56mzhmqGogXNOv6NPw1zYjSZqKsadP5jZwzugwjaU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y1iL1jKCQfbk4LlOG7sS9ZP58plR3uJvRz0fAr5RBZUhOLLFkahwiWgTW5Sbdxato
         oupixAMo3iIViVAG8fynr/9cnvroGTECtQGm5TGjM7LsdExMv5y2WFJ5FRlUx99fmx
         tBENz1a2OTt+/J+MfX5o3oycD/y0F4sufDxWfccE=
Date:   Sun, 1 May 2022 16:23:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>
Cc:     SuraveeSuthikulpanit <suravee.suthikulpanit@amd.com>,
        WillDeacon <will@kernel.org>, JoergRoedel <joro@8bytes.org>,
        stable@vger.kernel.org
Subject: Re: Linux 5.17.5
Message-ID: <Ym6X3enhptEUyyJG@kroah.com>
References: <165106510338255@kroah.com>
 <a5c7406e-64b0-7522-fef0-27fec1ac6698@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a5c7406e-64b0-7522-fef0-27fec1ac6698@web.de>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 01, 2022 at 02:37:36PM +0200, Jörg-Volker Peetz wrote:
> Greg Kroah-Hartman wrote on 27/04/2022 15:11:
> > I'm announcing the release of the 5.17.5 kernel.
> > 
> > All users of the 5.17 kernel series must upgrade.
> > 
> > The updated 5.17.y git tree can be found at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.17.y
> > and can be browsed at the normal kernel.org git web browser:
> > 	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> > 
> > thanks,
> > 
> > greg k-h
> > 
> <snip>
> Hi,
> 
> while booting a self compiled kernel 5.17.5, the following warning appeared in
> the logs:
> 
> Apr 28 15:57:41 xxx kernel: WARNING: CPU: 0 PID: 1 at
> drivers/iommu/amd/init.c:851 amd_iommu_enable_interrupts+0x312/0x3f0
> Apr 28 15:57:41 xxx kernel: Modules linked in:
> Apr 28 15:57:41 xxx kernel: CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.17.5 #1
> Apr 28 15:57:41 xxx kernel: Hardware name: Micro-Star International Co., Ltd.
> MS-7C94/MAG B550M MORTAR (MS-7C94), BIOS 1.94 09/23/2021
> Apr 28 15:57:41 xxx kernel: RIP: 0010:amd_iommu_enable_interrupts+0x312/0x3f0
> Apr 28 15:57:41 xxx kernel: Code: ff ff 49 8b 7f 18 89 04 24 e8 2a ff f6 ff 8b
> 04 24 e9 7b fd ff ff 0f 0b 4d 8b 3f 49 81 ff 90 15 ac b0 0f 85 35 fd ff ff eb 82
> <0f> 0b 4d 8b 3f 49 81 ff 90 15 ac b0 0f 85 21 fd ff ff e9 6b ff ff
> Apr 28 15:57:41 xxx kernel: RSP: 0018:ffffaf47c005fdd8 EFLAGS: 00010246
> Apr 28 15:57:41 xxx kernel: RAX: 0000000f03059ee4 RBX: 0000000000000000 RCX:
> 0000000000000000
> Apr 28 15:57:41 xxx kernel: RDX: 0000000000009da4 RSI: 0000000000009428 RDI:
> 0000000f03050140
> Apr 28 15:57:41 xxx kernel: RBP: 0000000080000000 R08: ffffffffffffffff R09:
> 0000000000000000
> Apr 28 15:57:41 xxx kernel: R10: 00000000000000d1 R11: 0000000000000000 R12:
> 000ffffffffffff8
> Apr 28 15:57:41 xxx kernel: R13: 0800000000000000 R14: 0008000000000000 R15:
> ffff8f7380190000
> Apr 28 15:57:41 xxx kernel: FS:  0000000000000000(0000)
> GS:ffff8f8171c00000(0000) knlGS:0000000000000000
> Apr 28 15:57:41 xxx kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Apr 28 15:57:41 xxx kernel: CR2: ffff8f81ae1ff000 CR3: 00000008a740a000 CR4:
> 0000000000750ef0
> Apr 28 15:57:41 xxx kernel: PKRU: 55555554
> Apr 28 15:57:41 xxx kernel: Call Trace:
> Apr 28 15:57:41 xxx kernel: <TASK>
> Apr 28 15:57:41 xxx kernel: iommu_go_to_state+0x10e0/0x138d
> Apr 28 15:57:41 xxx kernel: ? e820__memblock_setup+0x78/0x78
> Apr 28 15:57:41 xxx kernel: amd_iommu_init+0xa/0x20
> Apr 28 15:57:41 xxx kernel: pci_iommu_init+0x11/0x3a
> Apr 28 15:57:41 xxx kernel: do_one_initcall+0x47/0x180
> Apr 28 15:57:41 xxx kernel: kernel_init_freeable+0x162/0x1a7
> Apr 28 15:57:41 xxx kernel: ? rest_init+0xc0/0xc0
> Apr 28 15:57:41 xxx kernel: kernel_init+0x11/0x110
> Apr 28 15:57:41 xxx kernel: ret_from_fork+0x22/0x30
> Apr 28 15:57:41 xxx kernel: </TASK>
> 
> Is this serious?
> CPU is AMD Ryzen 7 5700G (RENOIR).
> The config file is attached.
> With kernel 5.17.3 this warning did not appear.

Can you use 'git bisect' to track down the offending change?

thanks,

greg k-h
