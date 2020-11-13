Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3775A2B14D5
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 04:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgKMDta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 22:49:30 -0500
Received: from [157.25.102.26] ([157.25.102.26]:60464 "EHLO orcam.me.uk"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726011AbgKMDt3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Nov 2020 22:49:29 -0500
Received: from bugs.linux-mips.org (eddie.linux-mips.org [IPv6:2a01:4f8:201:92aa::3])
        by orcam.me.uk (Postfix) with ESMTPS id F0B9C2BE0EC;
        Fri, 13 Nov 2020 03:49:26 +0000 (GMT)
Date:   Fri, 13 Nov 2020 03:49:25 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@linux-mips.org>
To:     Jinyang He <hejinyang@loongson.cn>
cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: reserve the memblock right after the kernel
In-Reply-To: <4a73a75f-a3b2-7ba1-d8a1-a46f5c20e734@loongson.cn>
Message-ID: <alpine.LFD.2.21.2011130339250.4064799@eddie.linux-mips.org>
References: <20201106141001.57637-1-alexander.sverdlin@nokia.com> <20201107094028.GA4918@alpha.franken.de> <1d6a424e-944e-7f21-1f30-989fb61018a8@nokia.com> <20201110095503.GA10357@alpha.franken.de> <c435b3df-4e82-7c10-366a-5a3d1543c73f@nokia.com>
 <20201111145240.lok3q5g3pgcvknqr@mobilestation> <4625868b-f845-2f03-c3f2-fc3ff1ccf63d@flygoat.com> <4a73a75f-a3b2-7ba1-d8a1-a46f5c20e734@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 13 Nov 2020, Jinyang He wrote:

> Commit: d3ff93380232 (mips: Make sure kernel memory is in iomem)
> As I thought, this check is related to kdump. More directly, it is
> related to the "mem=" parameter. Kexec-tools provide a "mem=" parameter
> to limit the kernel location in kdump. But sometimes the memory may be not
> enough and this check gives a way to ensure the capture kernel can
> start rightly. Although "mem=" is not in kexec-tools now, I thought
> it is also useful if someone use "mem=" to do other things.

 I used to supply `mem=' by hand on many occasions across different MIPS 
systems and for various reasons over the last 20 years; surely before 
kexec was even thought of.  The option itself has been there in the MIPS 
port since I added it to Linux 2.4.0 back in Dec 2000.

  Maciej
