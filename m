Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E202F31975C
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 01:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhBLAUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 19:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhBLAUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 19:20:40 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E4DC061786
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 16:19:59 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4DcDf54gv9z9sVR; Fri, 12 Feb 2021 11:19:57 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Hari Bathini <hbathini@linux.ibm.com>
Cc:     linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Dave Young <dyoung@redhat.com>,
        Petr Tesarik <ptesarik@suse.cz>,
        Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
        Pingfan Liu <piliu@redhat.com>, stable@vger.kernel.org,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Sourabh Jain <sourabhjain@linux.ibm.com>
In-Reply-To: <161243826811.119001.14083048209224609814.stgit@hbathini>
References: <161243826811.119001.14083048209224609814.stgit@hbathini>
Subject: Re: [PATCH] powerpc/kexec_file: fix FDT size estimation for kdump kernel
Message-Id: <161308904153.3606979.2063516658676565641.b4-ty@ellerman.id.au>
Date:   Fri, 12 Feb 2021 11:19:57 +1100 (AEDT)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 04 Feb 2021 17:01:10 +0530, Hari Bathini wrote:
> On systems with large amount of memory, loading kdump kernel through
> kexec_file_load syscall may fail with the below error:
> 
>     "Failed to update fdt with linux,drconf-usable-memory property"
> 
> This happens because the size estimation for kdump kernel's FDT does
> not account for the additional space needed to setup usable memory
> properties. Fix it by accounting for the space needed to include
> linux,usable-memory & linux,drconf-usable-memory properties while
> estimating kdump kernel's FDT size.

Applied to powerpc/next.

[1/1] powerpc/kexec_file: fix FDT size estimation for kdump kernel
      https://git.kernel.org/powerpc/c/2377c92e37fe97bc5b365f55cf60f56dfc4849f5

cheers
