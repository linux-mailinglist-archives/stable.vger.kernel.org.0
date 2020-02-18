Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E604A1622B4
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 09:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgBRIvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 03:51:01 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:44617 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726638AbgBRIvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 03:51:00 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 142FF3A9;
        Tue, 18 Feb 2020 03:51:00 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 18 Feb 2020 03:51:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=1P9VPU8qn+M0fuIXesmdgWbwKBb
        xerAPkORBfivjroc=; b=c+LiA8q+9HCYbXmvZEXJjtOP5DxZbL57dz59Pug4Aqn
        W5uRi0fGUIptN12K6Yuty6awNEx2RACuoAyVKJEWwdmbAQycYP8i5czuZxwYWvDf
        Hue0h4JMjUDgiii3PCDNXoProyO18WmEsebYjio88zIKVbOEIXPMocraeNMo0tPa
        jvNelSuyg6DjylLDP9OPwDA6zrCztRKSR327ZftWti5hthXS/bc4lCEkbyIlGhYt
        0iN1YA2Xroe4s6lEAwKo/T2+n8IPE5qp8buFCw7IsNlSFma4UACZzN0rn9Oqnad4
        deyRBmoJSfw0gAOD9BREbnNPT2riVMX7CouQAyQX6Lw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1P9VPU
        8qn+M0fuIXesmdgWbwKBbxerAPkORBfivjroc=; b=AaDQNlqq+AWzM05ryM5Qj8
        YKDiPjqbwHXzhq/kO9uHuFPKaqvs0LDYl3cpI25s9tENw8uj/aC/IUuHQa0MgKtU
        JMzRy9yurLVP8cJXgC4Q74w34MIODtJsmvJ4evTBs9PHiFxdGZCDqQ8nz7szLW4n
        +4vjQdMSrAVHaTpsVz6NWN7Zs8aKNnHWdLbi9LFJh8rggwJQBtjX9Y83a9E9nl8b
        /VM6r3JKFGUTEsIjGAcP5DtcUFG/SOourv4F43s3o4FtZQZMtREKrjKM5l3PwQ4F
        YfmFxpNrMnIBqZFhY4eZIx4WfOTE0LMqe4eerp9ziZWxtLo4/JJXvJ3IQm2Tfwcw
        ==
X-ME-Sender: <xms:c6VLXih2NVgu30IMeTxkXe7mke3Z11gO0GNSN0hGovU2FvdSgOnNOA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeejgdduvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhr
    vghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:c6VLXusVGM8NuvV9cR_J3R-TaTB9TFfhfG7WdNLkwQsEAV6hC60nbw>
    <xmx:c6VLXg9vCJz_SnMVsiDUA4iytqQeUmdp7a6pl8Ss9G9-NYMaxhqXFA>
    <xmx:c6VLXgGEH7W7uGFchcO-yACseINnfBIEXnjcINMO-JdHaA62t2RtNA>
    <xmx:c6VLXozlGsos03UrTCYaszN7p885K8eK3E5UWHpHud6_LDbgU1k7Ig>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 435573280063;
        Tue, 18 Feb 2020 03:50:59 -0500 (EST)
Date:   Tue, 18 Feb 2020 09:49:01 +0100
From:   Greg KH <greg@kroah.com>
To:     Santosh Sivaraj <santosh@fossix.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: Random memory corruption may occur due to incorrent tlb flushes
Message-ID: <20200218084901.GA2285287@kroah.com>
References: <87pnecxqlg.fsf@santosiv.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pnecxqlg.fsf@santosiv.in.ibm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 01:41:07PM +0530, Santosh Sivaraj wrote:
> Hi Greg/Sasha,
> 
> The commit a46cc7a90fd (powerpc/mm/radix: Improve
> TLB/PWC flushes) picked up in 4.14 release has the potential to cause random
> memory corruption. This was fixed in 5.5 by the following patches.
> 
> 12e4d53f3f powerpc/mmu_gather: enable RCU_TABLE_FREE even for !SMP case
> 0ed1325967 mm/mmu_gather: invalidate TLB correctly on batch allocation failure and flush
> 0758cd8304 asm-generic/tlb: avoid potential double flush
> 
> It's a bit tricky to backport to 4.14 stable (though I have a backport to 4.19
> stable, which I will post shortly). If you think it's important to fix this in
> 4.14, it would easier to revert the above mentioned commit (a46cc7a90fd). 
> 
> Please let me know your thoughts.

A revert is probably best, can you send it?

thanks,

greg k-h
