Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4193321928
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 15:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbfEQN1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 09:27:20 -0400
Received: from 4.mo7.mail-out.ovh.net ([178.32.122.254]:42687 "EHLO
        4.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728333AbfEQN1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 09:27:20 -0400
X-Greylist: delayed 7797 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 May 2019 09:27:18 EDT
Received: from player763.ha.ovh.net (unknown [10.109.159.248])
        by mo7.mail-out.ovh.net (Postfix) with ESMTP id 15164119DE5
        for <stable@vger.kernel.org>; Fri, 17 May 2019 12:58:00 +0200 (CEST)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player763.ha.ovh.net (Postfix) with ESMTPSA id 00FA25E06E1D;
        Fri, 17 May 2019 10:57:54 +0000 (UTC)
Date:   Fri, 17 May 2019 12:57:54 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org,
        =?UTF-8?B?Q8OpZHJp?= =?UTF-8?B?Yw==?= Le Goater 
        <clg@kaod.org>
Subject: Re: [PATCH] powerpc/pseries: Fix xive=off command line
Message-ID: <20190517125754.2f0a572e@bahia.lan>
In-Reply-To: <20190515105443.835E72084E@mail.kernel.org>
References: <155791470178.432724.8008395673479905061.stgit@bahia.lan>
 <20190515105443.835E72084E@mail.kernel.org>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 10644257719299512787
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgfeehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 15 May 2019 10:54:42 +0000
Sasha Levin <sashal@kernel.org> wrote:

> Hi,
> 

Hi,

> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: eac1e731b59e powerpc/xive: guest exploitation of the XIVE interrupt controller.
> 
> The bot has tested the following trees: v5.1.1, v5.0.15, v4.19.42, v4.14.118.
> 
> v5.1.1: Build OK!
> v5.0.15: Build OK!
> v4.19.42: Failed to apply! Possible dependencies:
>     8ca2d5151e7f ("powerpc/prom_init: Move a few remaining statics to appropriate sections")
>     c886087caee7 ("powerpc/prom_init: Move prom_radix_disable to __prombss")
> 

Dependencies are:

3bad719b4954 ("powerpc/prom_init: Make of_workarounds static")
e63334e556d9 ("powerpc/prom_init: Replace __initdata with __prombss when applicable")
11fdb309341c ("powerpc/prom_init: Remove support for OPAL v2")
c886087caee7 ("powerpc/prom_init: Move prom_radix_disable to __prombss")
8ca2d5151e7f ("powerpc/prom_init: Move a few remaining statics to appropriate sections")
f1f208e54d08 ("powerpc/prom_init: Generate "phandle" instead of "linux, phandle"")
cbe46bd4f510 ("powerpc: remove CONFIG_CMDLINE #ifdef mess")
450e7dd4001f ("powerpc/prom_init: don't use string functions from lib/")

The patches apply flawlessly and allow the build to succeed.

> v4.14.118: Failed to apply! Possible dependencies:
>     028555a590d6 ("powerpc/xive: fix hcall H_INT_RESET to support long busy delays")
>     7a22d6321c3d ("powerpc/mm/radix: Update command line parsing for disable_radix")
>     8ca2d5151e7f ("powerpc/prom_init: Move a few remaining statics to appropriate sections")
>     c886087caee7 ("powerpc/prom_init: Move prom_radix_disable to __prombss")
> 

Dependencies are:

7a22d6321c3d ("powerpc/mm/radix: Update command line parsing for disable_radix")
028555a590d6 ("powerpc/xive: fix hcall H_INT_RESET to support long busy delays")
3bad719b4954 ("powerpc/prom_init: Make of_workarounds static")
e63334e556d9 ("powerpc/prom_init: Replace __initdata with __prombss when applicable")
11fdb309341c ("powerpc/prom_init: Remove support for OPAL v2")
c886087caee7 ("powerpc/prom_init: Move prom_radix_disable to __prombss")
8ca2d5151e7f ("powerpc/prom_init: Move a few remaining statics to appropriate sections")
f1f208e54d08 ("powerpc/prom_init: Generate "phandle" instead of "linux, phandle"")
cbe46bd4f510 ("powerpc: remove CONFIG_CMDLINE #ifdef mess")
450e7dd4001f ("powerpc/prom_init: don't use string functions from lib/")

The patches apply flawlessly and allow the build to succeed.

> 
> How should we proceed with this patch?
> 

xive=off allows the kernel to use the legacy XICS interrupt controller
interface on POWER9, definitely not a recommended setting. A typical
usage for this would be to workaround some issue that would only pop
up when using XIVE. Note also that this only affects the pseries platform,
ie. running under an hypervisor (KVM or pHyp).

I cannot state right now whether it is worth the pain to cherry-pick all
the dependencies to fix this or not in older kernels...

Cheers,

--
Greg

> --
> Thanks,
> Sasha

