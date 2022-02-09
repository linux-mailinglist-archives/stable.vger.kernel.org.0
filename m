Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A9A4AF25F
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 14:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbiBINJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 08:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbiBINJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 08:09:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00010C0613CA
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 05:09:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E2F061948
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 13:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334D5C340EF;
        Wed,  9 Feb 2022 13:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644412192;
        bh=3aqJPtLYSJmymBrT+ODgEyB0AWBnZLcNvrWpbxek9XM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WaiLUliNHCocYizUTQ14AauSrO53n9LXJ9kT1qIFJlGIMMmEX+n8eb4QCqt8X9Tv6
         j759CMC/VongzFQNX7o+npwn1VC1sVVi6Y3gs0483gqjsVMHdNXpsh5nq76cnjzapk
         /EtLoReZdSIiYjkAcDoBtGKAHOWP56K66Y7+ExLo=
Date:   Wed, 9 Feb 2022 14:09:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anshuman Khandual <anshuman.khandual@arm.com>
Cc:     stable@vger.kernel.org, suzuki.poulose@arm.com,
        mathieu.poirier@linaro.org, catalin.marinas@arm.com,
        will@kernel.org
Subject: Re: [PATCH] arm64: Add Cortex-A510 CPU part definition
Message-ID: <YgO9HliVFmvATHZo@kroah.com>
References: <1644289688-22235-1-git-send-email-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1644289688-22235-1-git-send-email-anshuman.khandual@arm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 08, 2022 at 08:38:08AM +0530, Anshuman Khandual wrote:
> commit <53960faf2b73> upstream.
> 
> Add the CPU Partnumbers for the new Arm designs.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Suzuki Poulose <suzuki.poulose@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: <stable@vger.kernel.org> # 5.15.x
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> This applies on Linux 5.15.21 stable branch.

Thanks, now queued up.

greg k-h
