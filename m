Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4FB7561943
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 13:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbiF3Lbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 07:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235112AbiF3Lbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 07:31:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176B258FD4
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 04:31:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 561E8B82A2A
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 11:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9886C34115;
        Thu, 30 Jun 2022 11:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656588675;
        bh=3Qju4ra8mIgPc4sJgCZMUzFsVmDwFqohz+hKY9A/4fc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kflvoIVQctbhBY/HIGks5hmJHXqhLRq+cE7jgcinVlokJLaaDw6jt7Ox7qyDQyTmV
         9paBBZ94Bz2+gnrfuFnXPPhYP0owmvO1r3MAluX3f+HLsU4EZvnwWi9c1s5ofq/nf3
         KlrC2dWkK98rY+3HDlNLBBbxdJZ5nSPx50byKuEY=
Date:   Thu, 30 Jun 2022 13:31:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc:     stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v5.18] powerpc/ftrace: Remove ftrace init tramp once
 kernel init is complete
Message-ID: <Yr2Je34UxKYTg6fC@kroah.com>
References: <20220627173930.133620-1-naveen.n.rao@linux.vnet.ibm.com>
 <20220627173930.133620-3-naveen.n.rao@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627173930.133620-3-naveen.n.rao@linux.vnet.ibm.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 11:09:29PM +0530, Naveen N. Rao wrote:
> commit 84ade0a6655bee803d176525ef457175cbf4df22 upstream.
> 
> Stop using the ftrace trampoline for init section once kernel init is
> complete.
> 
> Fixes: 67361cf8071286 ("powerpc/ftrace: Handle large kernel configs")
> Cc: stable@vger.kernel.org # v4.20+
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/20220516071422.463738-1-naveen.n.rao@linux.vnet.ibm.com
> ---
>  arch/powerpc/include/asm/ftrace.h  |  4 +++-
>  arch/powerpc/kernel/trace/ftrace.c | 15 ++++++++++++---
>  arch/powerpc/mm/mem.c              |  2 ++
>  3 files changed, 17 insertions(+), 4 deletions(-)

All now queued up, thanks.

greg k-h
