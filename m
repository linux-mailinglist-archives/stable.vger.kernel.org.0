Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07A73639FC
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 06:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237470AbhDSEFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 00:05:04 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:54461 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237411AbhDSEEx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 00:04:53 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4FNtVb50Htz9vGW; Mon, 19 Apr 2021 14:04:23 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Mahesh Salgaonkar <mahesh@linux.ibm.com>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>
Cc:     stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Oliver O'Halloran <oohall@gmail.com>
In-Reply-To: <161821396263.48361.2796709239866588652.stgit@jupiter>
References: <161821396263.48361.2796709239866588652.stgit@jupiter>
Subject: Re: [PATCH v2] powerpc/eeh: Fix EEH handling for hugepages in ioremap space.
Message-Id: <161880479477.1398509.366681090347824239.b4-ty@ellerman.id.au>
Date:   Mon, 19 Apr 2021 13:59:54 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Apr 2021 13:22:50 +0530, Mahesh Salgaonkar wrote:
> During the EEH MMIO error checking, the current implementation fails to map
> the (virtual) MMIO address back to the pci device on radix with hugepage
> mappings for I/O. This results into failure to dispatch EEH event with no
> recovery even when EEH capability has been enabled on the device.
> 
> eeh_check_failure(token)		# token = virtual MMIO address
>   addr = eeh_token_to_phys(token);
>   edev = eeh_addr_cache_get_dev(addr);
>   if (!edev)
> 	return 0;
>   eeh_dev_check_failure(edev);	<= Dispatch the EEH event
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/eeh: Fix EEH handling for hugepages in ioremap space.
      https://git.kernel.org/powerpc/c/5ae5bc12d0728db60a0aa9b62160ffc038875f1a

cheers
