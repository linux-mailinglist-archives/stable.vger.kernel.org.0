Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 238CD99482
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 15:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388895AbfHVNI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 09:08:58 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:35489 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388893AbfHVNI5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 09:08:57 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 46DlGb4DCwz9sP6; Thu, 22 Aug 2019 23:08:55 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 56090a3902c80c296e822d11acdb6a101b322c52
In-Reply-To: <20190718051139.74787-2-aik@ozlabs.ru>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     Sam Bobroff <sbobroff@linux.ibm.com>,
        Alistair Popple <alistair@popple.id.au>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Oliver O'Halloran <oohall@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH kernel v5 1/4] powerpc/powernv/ioda: Fix race in TCE level allocation
Message-Id: <46DlGb4DCwz9sP6@ozlabs.org>
Date:   Thu, 22 Aug 2019 23:08:55 +1000 (AEST)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2019-07-18 at 05:11:36 UTC, Alexey Kardashevskiy wrote:
> pnv_tce() returns a pointer to a TCE entry and originally a TCE table
> would be pre-allocated. For the default case of 2GB window the table
> needs only a single level and that is fine. However if more levels are
> requested, it is possible to get a race when 2 threads want a pointer
> to a TCE entry from the same page of TCEs.
> 
> This adds cmpxchg to handle the race. Note that once TCE is non-zero,
> it cannot become zero again.
> 
> CC: stable@vger.kernel.org # v4.19+
> Fixes: a68bd1267b72 ("powerpc/powernv/ioda: Allocate indirect TCE levels on demand")
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Series applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/56090a3902c80c296e822d11acdb6a101b322c52

cheers
