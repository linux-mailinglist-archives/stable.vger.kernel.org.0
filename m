Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28062046BB
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 03:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731941AbgFWBbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 21:31:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731933AbgFWBbV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 21:31:21 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2BDF20720;
        Tue, 23 Jun 2020 01:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592875881;
        bh=Ip4hUp+Kx7JnyG5ATjNdkBh2pA4/XUhvLpOYNdxsUaA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yfmpx2NLnFJfdPc6DE6WBegGbL/8/V24P9Odeh0x0tyEVZIlYFIb/5EfVy3Oxv+xK
         twDn3ttlKFJCz6ErjGoUZolrt+/BH9yXzKWFjJ306qvPTt9nKTkSCBGs0mh5IrMu9l
         0RkedVysEMZSsy3GrZoEQ7WANGgcmGS7W0TtAlEY=
Date:   Mon, 22 Jun 2020 21:31:19 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     stable@vger.kernel.org
Subject: Re: Patch "ARM: dts: meson: Switch existing boards with RGMII PHY to
 "rgmii-id"" has been added to the 5.7-stable tree
Message-ID: <20200623013119.GV1931@sasha-vm>
References: <20200622125212.03B9220732@mail.kernel.org>
 <CAFBinCC6uK233uKOXYnGis=M8ms=EjH3=yoGLe7c3J_PNMv2LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAFBinCC6uK233uKOXYnGis=M8ms=EjH3=yoGLe7c3J_PNMv2LQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 22, 2020 at 11:54:45PM +0200, Martin Blumenstingl wrote:
>Hi Sasha,
>
>On Mon, Jun 22, 2020 at 2:52 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> This is a note to let you know that I've just added the patch titled
>>
>>     ARM: dts: meson: Switch existing boards with RGMII PHY to "rgmii-id"
>>
>> to the 5.7-stable tree which can be found at:
>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>      arm-dts-meson-switch-existing-boards-with-rgmii-phy-.patch
>> and it can be found in the queue-5.7 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>this patch has another dependency on upstream commit 9308c47640d515
>("net: stmmac: dwmac-meson8b: add support for the RX delay
>configuration") which itself depends on a few other commits
>unless you are also planning to backport more changes (I would have to
>make a detailed list and also reserve some time for testing) I suggest
>to drop this patch from 5.7, 5.4 and 4.19

I'll drop it, thank you!

-- 
Thanks,
Sasha
