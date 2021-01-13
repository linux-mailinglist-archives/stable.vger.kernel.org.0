Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AE62F5065
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 17:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbhAMQv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 11:51:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:49424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727329AbhAMQv1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 11:51:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F010D2339D;
        Wed, 13 Jan 2021 16:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610556647;
        bh=ysD0aOZlpy8PxTCm/xkip8tKV8y+DTQffVf/nrmIYqU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HGX4OqU+XgYThqLOmnMF/3SKFuN0/EbxlBo4UN5oYFcdtYGCwM47sBa4DxS0YDdOm
         N+VcE0uKUDDmsT74qp394RYptOKGnTVXI9fGL+gadYFUkx0WpC9JQSm8XaAHly2iUf
         64iFQTLNZmCfx9m0nX6dlEiOpGadbeqI0p+szxpSAb88RCb8IiH0vbDKv55a43Ql94
         AQvZB9A5QalbDNaN8E2bjPqfLBgzi2JhvhIQJ647jNc85SC2igQ/JVS9412B1YP/zw
         JLNynrjaS6/BuUw0Pr2Ol6HEHMUoLPUG+nZ9nXKRlWwaFhGrMOC85rJAXMK9EKDdWQ
         tz69tPbWscC1g==
Date:   Wed, 13 Jan 2021 11:50:45 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH for 5.10] powerpc/32s: Fix RTAS machine check with VMAP
 stack
Message-ID: <20210113165045.GR4035784@sasha-vm>
References: <790e46767a5f10ae991969b064682c8c82f96bc3.1610519852.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <790e46767a5f10ae991969b064682c8c82f96bc3.1610519852.git.christophe.leroy@csgroup.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 13, 2021 at 06:40:20AM +0000, Christophe Leroy wrote:
>This is backport for 5.10
>
>(cherry picked from commit 98bf2d3f4970179c702ef64db658e0553bc6ef3a)
>
>When we have VMAP stack, exception prolog 1 sets r1, not r11.
>
>When it is not an RTAS machine check, don't trash r1 because it is
>needed by prolog 1.
>
>Fixes: da7bb43ab9da ("powerpc/32: Fix vmap stack - Properly set r1 before activating MMU")
>Cc: stable@vger.kernel.org # v5.10+
>Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
>[mpe: Squash in fixup for RTAS machine check from Christophe]
>Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>Link: https://lore.kernel.org/r/bc77d61d1c18940e456a2dee464f1e2eda65a3f0.1608621048.git.christophe.leroy@csgroup.eu

Queued up, thanks!

-- 
Thanks,
Sasha
