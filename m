Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E242A81C8
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 14:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729912AbfIDL7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 07:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729741AbfIDL7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 07:59:37 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BBF72339E;
        Wed,  4 Sep 2019 11:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567598376;
        bh=6dTOn9yTcoIQDgFMXLLTkMhZvPTBq/erRmVI+z+oQnU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vm6F7waIhgrBzuz3e5LhsvbUB1PQ9aG6B6C/1Gf6p0sO+ZipHLhHMb2/JjyMFWCbN
         Xy5ZUkM5C7g6ajkrJnoTsaBWlHXMO5lGTHkNlRxsrclCCbW8/q3SyerpKtKo8u8TkZ
         3wtrCnUmo2pHZmSS8IYZVaXuEkXvVa/geJHr474E=
Date:   Wed, 4 Sep 2019 07:59:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19] mt76: mt76x0u: do not reset radio on resume
Message-ID: <20190904115935.GV5281@sasha-vm>
References: <20190904080704.GA2704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190904080704.GA2704@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 04, 2019 at 10:07:10AM +0200, Stanislaw Gruszka wrote:
>commit 8f2d163cb26da87e7d8e1677368b8ba1ba4d30b3 upstream.
>
>On some machines mt76x0u firmware can hung during resume,
>what result on messages like below:
>
>[  475.480062] mt76x0 1-8:1.0: Error: MCU response pre-completed!
>[  475.990066] mt76x0 1-8:1.0: Error: send MCU cmd failed:-110
>[  475.990075] mt76x0 1-8:1.0: Error: MCU response pre-completed!
>[  476.500003] mt76x0 1-8:1.0: Error: send MCU cmd failed:-110
>[  476.500012] mt76x0 1-8:1.0: Error: MCU response pre-completed!
>[  477.010046] mt76x0 1-8:1.0: Error: send MCU cmd failed:-110
>[  477.010055] mt76x0 1-8:1.0: Error: MCU response pre-completed!
>[  477.529997] mt76x0 1-8:1.0: Error: send MCU cmd failed:-110
>[  477.530006] mt76x0 1-8:1.0: Error: MCU response pre-completed!
>[  477.824907] mt76x0 1-8:1.0: Error: send MCU cmd failed:-71
>[  477.824916] mt76x0 1-8:1.0: Error: MCU response pre-completed!
>[  477.825029] usb 1-8: USB disconnect, device number 6
>
>and possible whole system freeze.
>
>This can be avoided, if we do not perform mt76x0_chip_onoff() reset.
>
>Cc: stable@vger.kernel.org
>Fixes: 134b2d0d1fcf ("mt76x0: init files")
>Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Queued up for 4.19, thank you!

--
Thanks,
Sasha
