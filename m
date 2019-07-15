Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30C5B69195
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391020AbfGOOai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:30:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391694AbfGOOaZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:30:25 -0400
Received: from localhost (unknown [88.128.80.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD1CD205ED;
        Mon, 15 Jul 2019 14:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563201025;
        bh=UjFjLIvPVWknp9uluSELT71ZIZponhx0x/e09KbJ2wk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TSRmLNz9ycT2K40xzIYDG3P71RtRx4sQcdDIwlZZi13z6kL5MzbKvLhYUSlN/ejoR
         xDbW0LPPPc/PgvdXinTYAXuh0zM7d13RjXC0VqgrZHUT7d2CLf/iKNo3SqG28Fy1n7
         to39PVXY0L02Dfo8M1rO1CdZCdjoY3xo7PPDUpVE=
Date:   Mon, 15 Jul 2019 16:30:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     stable@vger.kernel.org, viresh.kumar@linaro.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4.9.y] arm64: crypto: remove accidentally backported
 files
Message-ID: <20190715143022.GA2582@kroah.com>
References: <20190715133923.42714-1-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715133923.42714-1-mark.rutland@arm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 15, 2019 at 02:39:23PM +0100, Mark Rutland wrote:
> In the v4.9.y backport commit:
> 
>   5ac0682830b31c4fba72a208a3c1c4bbfcc9f7f8
> 
>   ("arm64: Add ARM_SMCCC_ARCH_WORKAROUND_1 BP hardening support")
> 
> ... I accidentally added unrelated arm64/crypto files which were not
> part of the upstream commit:
> 
>   b092201e0020614127f495c092e0a12d26a2116e
> 
> ... and are not used at all in the v4.9.y tree.
> 
> This patch reverts the accidental addition. These files should not have
> been backported, and having them in the v4.9.y tree is at best
> confusing.

Now queued up, thanks!

greg k-h
