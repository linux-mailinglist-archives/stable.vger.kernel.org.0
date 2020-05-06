Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A1E1C6602
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 04:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgEFCvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 22:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgEFCvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 22:51:08 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75562C061A0F
        for <stable@vger.kernel.org>; Tue,  5 May 2020 19:51:07 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 49H1Lc0HT8z9sRf; Wed,  6 May 2020 12:51:03 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 02c04e374e176ae3a3f64a682f80702f8d2fb65d
In-Reply-To: <158737294432.26700.4830263187856221314.stgit@hbathini.in.ibm.com>
To:     Hari Bathini <hbathini@linux.ibm.com>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     stable@vger.kernel.org, Vasant Hegde <hegdevasant@linux.ibm.com>,
        Sourabh Jain <sourabhjain@linux.ibm.com>,
        Mahesh J Salgaonkar <mahesh@linux.ibm.com>
Subject: Re: [PATCH v3 1/2] powerpc/fadump: use static allocation for reserved memory ranges
Message-Id: <49H1Lc0HT8z9sRf@ozlabs.org>
Date:   Wed,  6 May 2020 12:51:03 +1000 (AEST)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-04-20 at 08:56:09 UTC, Hari Bathini wrote:
> At times, memory ranges have to be looked up during early boot, when
> kernel couldn't be initialized for dynamic memory allocation. In fact,
> reserved-ranges look up is needed during FADump memory reservation.
> Without accounting for reserved-ranges in reserving memory for FADump,
> MPIPL boot fails with memory corruption issues. So, extend memory
> ranges handling to support static allocation and populate reserved
> memory ranges during early boot.
> 
> Fixes: dda9dbfeeb7a ("powerpc/fadump: consider reserved ranges while releasing memory")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
> Reviewed-by: Mahesh Salgaonkar <mahesh@linux.ibm.com>

Series applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/02c04e374e176ae3a3f64a682f80702f8d2fb65d

cheers
