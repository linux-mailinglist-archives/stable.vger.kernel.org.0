Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E663EB4EB
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 13:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239951AbhHML7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 07:59:30 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:39457 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239847AbhHML73 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 07:59:29 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4GmMXj3h4bz9t5K; Fri, 13 Aug 2021 21:59:01 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        Laurent Dufour <ldufour@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
In-Reply-To: <20210805152308.33988-1-ldufour@linux.ibm.com>
References: <20210805152308.33988-1-ldufour@linux.ibm.com>
Subject: Re: [PATCH] powerpc/pseries: Fix update of LPAR security flavor after LPM
Message-Id: <162885586748.2317031.9018391947607622770.b4-ty@ellerman.id.au>
Date:   Fri, 13 Aug 2021 21:57:47 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 5 Aug 2021 17:23:08 +0200, Laurent Dufour wrote:
> After LPM, when migrating from a system with security mitigation enabled to
> a system with mitigation disabled, the security flavor exposed in /proc is
> not correctly set back to 0.
> 
> Do not assume the value of the security flavor is set to 0 when entering
> init_cpu_char_feature_flags(), so when called after a LPM, the value is set
> correctly even if the mitigation are not turned off.
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/pseries: Fix update of LPAR security flavor after LPM
      https://git.kernel.org/powerpc/c/c18956e6e0b95f78dad2773ecc8c61a9e41f6405

cheers
