Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7CC8D297B
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 14:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733082AbfJJM3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 08:29:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731230AbfJJM3Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 08:29:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16F6B208C3;
        Thu, 10 Oct 2019 12:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570710564;
        bh=C8VqkU7v3wAzEbcXleNkpsJR4ud+QMo6al7Q+MPKvkE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N/F/KjOV6cASJn2JD5k48WsHyhSM8QESdwogYeixXTZ7i94kLb1vHHW3FEGf0SuVP
         fykEj5TpaZsDvsF5ja6wNiE6HcNHwb9WuAGyWjzgfNhQF+31u4pQrfFJ38PkMMWUqb
         QEbGi2GvR7GaAaD1ok2/GbLClzscHgatZ4nHauJg=
Date:   Thu, 10 Oct 2019 14:29:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     stable@vger.kernel.org, mark.rutland@arm.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64: cpufeature: Fix truncating a feature value
Message-ID: <20191010122922.GA720144@kroah.com>
References: <20191010110856.4376-1-suzuki.poulose@arm.com>
 <ca77dec7-b29b-5a3b-0c01-047a06d1854d@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca77dec7-b29b-5a3b-0c01-047a06d1854d@arm.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 10, 2019 at 12:12:01PM +0100, Suzuki K Poulose wrote:
> All,
> 
> On 10/10/2019 12:08, Suzuki K Poulose wrote:
> > A signed feature value is truncated to turn to an unsigned value
> > causing bad state in the system wide infrastructure. This affects
> > the discovery of FP/ASIMD support on arm64. Fix this by making sure
> > we cast it properly.
> > 
> > Fixes: 4f0a606bce5ec ("arm64: cpufeature: Track unsigned fields")
> > Cc: stable@vger.kernel.org # v4.4
> 
> Please note that this patch is only applicable for stable 4.4 tree.
> I should have removed the Fixes tag.

Why is it only for 4.4?  That needs to be documented really really
really well in the changelog as to why this is a one-off patch, and why
we can't just take the relevant patches that are in Linus's tree
instead.

Please fix up and resend.

thanks,

greg k-h
