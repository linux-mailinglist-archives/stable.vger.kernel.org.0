Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2AA255ECD
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 18:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgH1Qc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 12:32:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726649AbgH1Qc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Aug 2020 12:32:28 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BE1B20872;
        Fri, 28 Aug 2020 16:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598632347;
        bh=ik1jdm0/k/hfJpI7vq1Y3jymD5JY0rhXamGXtK4dhJc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HimxpczdifWE/KJ1+13eGdHfs76DiVclA3FELfO0Rbvtm+3Cj+HVsZyUTSBqgPx8E
         ku8YY6zHvNfw4/qtiTgZpKnCEpkJjTTuWIjeFiMB4JC+YioJfmn6KG0ma8CrO2aSw8
         lKOMAtSyPmuXz0Z3AA2bBkgmgCy7H9xad+MGCnAs=
Date:   Fri, 28 Aug 2020 12:32:26 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nick Lowe <nick.lowe@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: Stable inclusion request: Revert "ath10k: fix DMA related
 firmware crashes on multiple devices" for 4.4, 4.9, 4.14, 4.19 and 5.4
Message-ID: <20200828163226.GS8670@sasha-vm>
References: <CADSoG1tJ5sujd17zZ2CV4gNLKwVrGkRxw09qvfB24MOLOr0_oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CADSoG1tJ5sujd17zZ2CV4gNLKwVrGkRxw09qvfB24MOLOr0_oQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 28, 2020 at 04:07:24PM +0100, Nick Lowe wrote:
>Hi,
>
>Please can commit a1769bb68a850508a492e3674ab1e5e479b11254 be back
>merged to the 4.4, 4.9, 4.14, 4.19 and 5.4 LTS kernels to resolve a
>PCIe hang with Wave 2-generation 802.11ac QCA chips?

I've queued it up to the kernel trees listed above, thanks!

-- 
Thanks,
Sasha
