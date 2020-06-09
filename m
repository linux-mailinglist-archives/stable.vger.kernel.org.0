Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87DD81F3368
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 07:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgFIF26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 01:28:58 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:50011 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727843AbgFIF24 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 01:28:56 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 49gzF30vRgz9sSy; Tue,  9 Jun 2020 15:28:55 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Hari Bathini <hbathini@linux.ibm.com>
Cc:     Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
        Vasant Hegde <hegdevasant@linux.ibm.com>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Sourabh Jain <sourabhjain@linux.ibm.com>
In-Reply-To: <159057266320.22331.6571453892066907320.stgit@hbathini.in.ibm.com>
References: <159057266320.22331.6571453892066907320.stgit@hbathini.in.ibm.com>
Subject: Re: [PATCH] powerpc/fadump: account for memory_limit while reserving memory
Message-Id: <159168034302.1381411.13026447475832378827.b4-ty@ellerman.id.au>
Date:   Tue,  9 Jun 2020 15:28:53 +1000 (AEST)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 27 May 2020 15:14:35 +0530, Hari Bathini wrote:
> If the memory chunk found for reserving memory overshoots the memory
> limit imposed, do not proceed with reserving memory. Default behavior
> was this until commit 140777a3d8df ("powerpc/fadump: consider reserved
> ranges while reserving memory") changed it unwittingly.

Applied to powerpc/next.

[1/1] powerpc/fadump: Account for memory_limit while reserving memory
      https://git.kernel.org/powerpc/c/9a2921e5baca1d25eb8d21f21d1e90581a6d0f68

cheers
