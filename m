Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65218464940
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 09:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239283AbhLAIGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 03:06:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50014 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237530AbhLAIGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 03:06:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C171DB81DBF
        for <stable@vger.kernel.org>; Wed,  1 Dec 2021 08:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E63C53FAD;
        Wed,  1 Dec 2021 08:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638345779;
        bh=k3x+g7KJXTxo+xR4Btn6HcIFFSay2y8+6AdTikMd9hU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aUXxOIxx3CsFQ9WeBaD4RvwMtVFZO0xNL5lZaVS6kmOC+XIsLElRGh8n1blAxwqPp
         adtGD2a+3IyR2o3onJ+XJwfDBgPwLlHOrMVZ9Zw+fyLUNsNRrHzS3wuofn3DBzddrx
         SBwgNgB7SL5pycRibX2ZHBsZV/SU1XBp15e8WxNo=
Date:   Wed, 1 Dec 2021 09:02:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Build failure in v4.9.y.queue
Message-ID: <YacsMD3mOS8s+2WO@kroah.com>
References: <4b3a8f2f-a3b5-b0c4-f93a-d1de27bf1196@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b3a8f2f-a3b5-b0c4-f93a-d1de27bf1196@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 30, 2021 at 07:55:27AM -0800, Guenter Roeck wrote:
> Building sh:rts7751r2dplus_defconfig:net,rtl8139:initrd ... failed
> ------------
> Error log:
> In file included from arch/sh/mm/init.c:25:
> ./arch/sh/include/asm/tlb.h:118:15: error: unknown type name 'voide'
>   118 | static inline voide
>       |               ^~~~~
> ./arch/sh/include/asm/tlb.h: In function 'tlb_flush_pmd_range':
> ./arch/sh/include/asm/tlb.h:126:1: error: no return statement in function returning non-void [-Werror=return-type]

thanks, now fixed.

greg k-h
