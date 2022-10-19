Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3168E603B0A
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiJSIAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiJSIAx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:00:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAF2326F5
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 01:00:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 427C0B82035
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 08:00:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86043C433C1;
        Wed, 19 Oct 2022 08:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666166450;
        bh=ZyhrDMILSFdx4tTsLlZtE/jDSUjmWOnm6ZlEYOr1FmM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VkYMnNju+wGokQMCgP5maY8RoF48RdjJW6toG5ZsU98Zn0cUM8HTOMdF7xIM2i11x
         YMESszcxX7zAkXrP7UmatDm4B7BQsqjgqcY3Gw4HCUXkeWev9xp5d/CVfUlaTK4LPC
         l/V08vYMra+t4jVpN3du/R4wydg1LtSHZbJClFto=
Date:   Wed, 19 Oct 2022 10:00:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org
Subject: Re: stable-rc: queue/5.10: drivers/dma/ti/k3-udma.c:666:26: error:
 'struct udma_chan' has no member named 'bchan'; did you mean 'tchan'?
Message-ID: <Y0+urspQi80CtAj6@kroah.com>
References: <CA+G9fYuxe6KWGt0bkKLZTfhhYdnLqp5ZBarFc4aRvpRR_xJEjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuxe6KWGt0bkKLZTfhhYdnLqp5ZBarFc4aRvpRR_xJEjg@mail.gmail.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 12:44:37PM +0530, Naresh Kamboju wrote:
> Following build error noticed while building arm64 defconfig on
> stable-rc queue/5.10.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> drivers/dma/ti/k3-udma.c: In function 'udma_decrement_byte_counters':
> drivers/dma/ti/k3-udma.c:666:26: error: 'struct udma_chan' has no
> member named 'bchan'; did you mean 'tchan'?
>   666 |                 if (!uc->bchan)
>       |                          ^~~~~
>       |                          tchan
> make[4]: *** [scripts/Makefile.build:286: drivers/dma/ti/k3-udma.o] Error 1

Thanks for the report, the offending patch is now dropped.

greg k-h
