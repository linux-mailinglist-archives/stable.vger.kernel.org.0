Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B31B18850F
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 14:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgCQNOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 09:14:42 -0400
Received: from ozlabs.org ([203.11.71.1]:38941 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbgCQNOm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 09:14:42 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 48hYYB6CJzz9sPF; Wed, 18 Mar 2020 00:14:38 +1100 (AEDT)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: aa4113340ae6c2811e046f08c2bc21011d20a072
In-Reply-To: <20200123111914.2565-1-laurentiu.tudor@nxp.com>
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "oss@buserror.net" <oss@buserror.net>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     Diana Madalina Craciun <diana.craciun@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: Re: [PATCH] powerpc/fsl_booke: avoid creating duplicate tlb1 entry
Message-Id: <48hYYB6CJzz9sPF@ozlabs.org>
Date:   Wed, 18 Mar 2020 00:14:38 +1100 (AEDT)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-01-23 at 11:19:25 UTC, Laurentiu Tudor wrote:
> In the current implementation, the call to loadcam_multi() is wrapped
> between switch_to_as1() and restore_to_as0() calls so, when it tries
> to create its own temporary AS=3D1 TLB1 entry, it ends up duplicating the
> existing one created by switch_to_as1(). Add a check to skip creating
> the temporary entry if already running in AS=3D1.
> 
> Fixes: d9e1831a4202 ("powerpc/85xx: Load all early TLB entries at once")
> Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
> Cc: stable@vger.kernel.org

Applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/aa4113340ae6c2811e046f08c2bc21011d20a072

cheers
