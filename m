Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393D23F0523
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 15:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238393AbhHRNq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 09:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238206AbhHRNqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 09:46:53 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FDCC0613A3;
        Wed, 18 Aug 2021 06:46:19 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4GqTh13bTxz9t18; Wed, 18 Aug 2021 23:46:09 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     pratik.r.sampat@gmail.com, rjw@rjwysocki.net,
        "Pratik R. Sampat" <psampat@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org,
        mpe@ellerman.id.au
In-Reply-To: <20210728120500.87549-1-psampat@linux.ibm.com>
References: <20210728120500.87549-1-psampat@linux.ibm.com>
Subject: Re: [PATCH v2 0/1] cpufreq:powernv: Fix init_chip_info initialization in numa=off
Message-Id: <162929392908.3619265.5755055049744911919.b4-ty@ellerman.id.au>
Date:   Wed, 18 Aug 2021 23:38:49 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 28 Jul 2021 17:34:59 +0530, Pratik R. Sampat wrote:
> v1: https://lkml.org/lkml/2021/7/26/1509
> Changelog v1-->v2:
> Based on comments from Gautham,
> 1. Included a #define for MAX_NR_CHIPS instead of hardcoding the
> allocation.
> 
> Pratik R. Sampat (1):
>   cpufreq:powernv: Fix init_chip_info initialization in numa=off
> 
> [...]

Applied to powerpc/next.

[1/1] cpufreq:powernv: Fix init_chip_info initialization in numa=off
      https://git.kernel.org/powerpc/c/f34ee9cb2c5ac5af426fee6fa4591a34d187e696

cheers
