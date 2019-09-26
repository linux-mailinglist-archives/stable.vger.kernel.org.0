Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB00BFBE7
	for <lists+stable@lfdr.de>; Fri, 27 Sep 2019 01:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbfIZXW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Sep 2019 19:22:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728270AbfIZXW1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Sep 2019 19:22:27 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E041207E0;
        Thu, 26 Sep 2019 23:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569540146;
        bh=GQUyMjye5vxmGMIj00o9cH/mVKe1NcXqBa/0DfTtHrw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lwe85V6TohEQw3nBBb9Bdqf+HrEz1OmN6GYeCI4L/QakpJQva0ND2s4ShvldrUl80
         /uxq/DljbUWy73uB6bCvCcZXgo2OvbQ4+yiFr4ZEye2sXcnH2ZPUzwuzEym4AuHsaa
         xn9dbAdK9tQycQVK6SlNYbuuWAyGi63AqRtoYHz8=
Date:   Thu, 26 Sep 2019 19:22:25 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-integrity@vger.kernel.org,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tpm: Fix TPM 1.2 Shutdown sequence to prevent future
 TPM operations
Message-ID: <20190926232225.GJ8171@sasha-vm>
References: <20190925101532.31280-1-jarkko.sakkinen@linux.intel.com>
 <20190925101532.31280-4-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190925101532.31280-4-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 25, 2019 at 01:15:32PM +0300, Jarkko Sakkinen wrote:
>From: Vadim Sukhomlinov <sukhomlinov@google.com>
>
>commit db4d8cb9c9f2af71c4d087817160d866ed572cc9 upstream
>
>TPM 2.0 Shutdown involve sending TPM2_Shutdown to TPM chip and disabling
>future TPM operations. TPM 1.2 behavior was different, future TPM
>operations weren't disabled, causing rare issues. This patch ensures
>that future TPM operations are disabled.
>
>Fixes: d1bd4a792d39 ("tpm: Issue a TPM2_Shutdown for TPM2 devices.")
>Cc: stable@vger.kernel.org
>Signed-off-by: Vadim Sukhomlinov <sukhomlinov@google.com>
>[dianders: resolved merge conflicts with mainline]
>Signed-off-by: Douglas Anderson <dianders@chromium.org>
>Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

I've queued it up for 4.19 and 4.14, thanks!

--
Thanks,
Sasha
