Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15F394FA4B
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 06:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfFWEwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 00:52:38 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42565 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725294AbfFWEwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 00:52:38 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9AA9E21BBA;
        Sun, 23 Jun 2019 00:52:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 23 Jun 2019 00:52:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=9
        NUbYbNslNocPTKm5rsWXu6dHgqNp/Kvxs0srhYNSQw=; b=OwyE7NU/k07adyy12
        1By5j31IokKVZcwUKMhK8elCau7ip58LbXEPus9kVWNEC6bVkH93BlRk0RRZ7HGh
        NHl+TQ7irdPzd0NA8rsU5wlxH42Vw5Vs8o8NlACfnEvDZwdLY2vqPhErYpErvFxY
        TwTMkCS98kW17cZsVWpawq9MYiY57M39qq7o7zSTyF0KYEhstWYDQK8DG7J/Hf1Y
        /n/SrA70LvjoraYpGUhPcN9D964F2WjDlxhw8EYixiCgd6B2FlRWX69eELzY+ZbT
        RXR6C5kRjU7Kb50TtgzXGRjfnbKlRF9wclQOevzr532NmXqQYuEEK5i6YiL+483E
        mGo6A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=9NUbYbNslNocPTKm5rsWXu6dHgqNp/Kvxs0srhYNS
        Qw=; b=o5URg5qNzDsP2EbtutfyWRHWwHkJrAU0RRK6Ttnc/mgXJuG+CSewJ6kgv
        +KW5XmVd6soRRuaEzCaPHx9I7+jsbpuGoMwMss2LU1IKFme0QHsTb04CT+FznUPd
        9BYG3cDCGv/LdusWXas5jVNHX1ddm7Qhz8dV+daWzlKad3bzg8gWc2tEueSkIt0Y
        k49N8sgY7kIjgrUDObPPt2r17mkl0wYToMiSbLZ396R6naiI5wH05x61yn7uYr1v
        yhYB8Cxeqv/cizrI1YtHfApJ/en2qr7/1aXJeS2Cq+KN+aC3OUcTNIeVlI+pwZL3
        IgxMmDQffqkvF3+bCooxkIVNK5p0Q==
X-ME-Sender: <xms:kgUPXVYdUS_q3wFWy3rnWwATkrTLhjZlxGqfMPFEkxfBlPx79oHsfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtdelgdekkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjfgesthekredttderjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:kgUPXZEN17IYp-vR-QTG_JLR-iQnez2tZtwsLmxVV7Drmn63rCF0dA>
    <xmx:kgUPXb3vWhWHQe6leCXkxjKRuVasg7nYbnHy4Ua9_pCu90wy8cccKA>
    <xmx:kgUPXdzUHVFAeiGW_ZYHshPEQgs-lHcPyGaoHQgRJ2Fldcq226FsDw>
    <xmx:kwUPXbirxeJqZP4WWRvFNDPVz9LNiobdfSVAWchoCuwtFbF6VjKZSg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 62157380076;
        Sun, 23 Jun 2019 00:52:34 -0400 (EDT)
Date:   Sun, 23 Jun 2019 06:52:32 +0200
From:   Greg KH <greg@kroah.com>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v5.2-rc5] Bluetooth: Fix regression with minimum
 encryption key size alignment
Message-ID: <20190623045232.GA30005@kroah.com>
References: <20190622134701.7088-1-marcel@holtmann.org>
 <20190622181349.8C8F320862@mail.kernel.org>
 <F46C65F2-411F-4B24-BD3C-ED9F39F5E65E@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F46C65F2-411F-4B24-BD3C-ED9F39F5E65E@holtmann.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 22, 2019 at 08:21:07PM +0200, Marcel Holtmann wrote:
> Hi Sasha,
> 
> > [This is an automated email]
> > 
> > This commit has been processed because it contains a "Fixes:" tag,
> > fixing commit: d5bb334a8e17 Bluetooth: Align minimum encryption key size for LE and BR/EDR connections.
> > 
> > The bot has tested the following trees: v5.1.12, v4.19.53, v4.14.128, v4.9.182, v4.4.182.
> > 
> > v5.1.12: Build failed! Errors:
> >    net/bluetooth/l2cap_core.c:1356:24: error: ‘HCI_MIN_ENC_KEY_SIZE’ undeclared (first use in this function); did you mean ‘SMP_MIN_ENC_KEY_SIZE’?
> > 
> > v4.19.53: Build failed! Errors:
> >    net/bluetooth/l2cap_core.c:1355:24: error: ‘HCI_MIN_ENC_KEY_SIZE’ undeclared (first use in this function); did you mean ‘SMP_MIN_ENC_KEY_SIZE’?
> > 
> > v4.14.128: Build failed! Errors:
> >    net/bluetooth/l2cap_core.c:1355:24: error: ‘HCI_MIN_ENC_KEY_SIZE’ undeclared (first use in this function); did you mean ‘SMP_MIN_ENC_KEY_SIZE’?
> > 
> > v4.9.182: Build OK!
> > v4.4.182: Build OK!
> > 
> > How should we proceed with this patch?
> 
> either you reapply commit d5bb334a8e17 first or I have to send a version that combines both into a single commit for easy applying.

I can reapply it...

thanks,

greg k-h
