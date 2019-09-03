Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACB63A74A1
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 22:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfICUbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 16:31:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbfICUbI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 16:31:08 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8888721897;
        Tue,  3 Sep 2019 20:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567542667;
        bh=2zih1QVoibmjgjWFojjfVnzksEZr1ioqVrlCBP0aP14=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v/NEJZtOu3svk+A/SoD0hjaLAa0BKqJ12H63cmseEx4lQbto0XZyAZjWohSmo1OtY
         96eQL+pJAoAyVHdWnPH4kYchvPmw6vm2cURpmEUZ7wdisV1OQ9PH0TLb6gnXfrxJCB
         p1JHMKdYv5YjdWDr97N0wS77aMx7kjAk1L6LPWGM=
Date:   Tue, 3 Sep 2019 16:31:06 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     guoheyi@huawei.com, maz@kernel.org, will@kernel.org,
        yuzenghui@huawei.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: arm/arm64: vgic: Fix potential
 deadlock when ap_list is" failed to apply to 4.19-stable tree
Message-ID: <20190903203106.GL5281@sasha-vm>
References: <1567536037189123@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1567536037189123@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 08:40:37PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.

I've fixed it up and queued it for 4.19, 4.14, and 4.9. Just context
changes due to missing 8fa3adb8c6bee (KVM: arm/arm64: vgic: Make
vgic_irq->irq_lock a raw_spinlock).

--
Thanks,
Sasha
