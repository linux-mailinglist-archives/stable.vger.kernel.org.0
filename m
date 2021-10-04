Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040FD4209BE
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 13:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhJDLLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 07:11:11 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:36887 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229825AbhJDLLL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 07:11:11 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 2914C580B12;
        Mon,  4 Oct 2021 07:09:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 04 Oct 2021 07:09:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=lsyNJGlVJemF3bmuo/TeOw5FPZj
        guP/ok8eqc5zK9Yo=; b=ofuOrwCeCMDj6KimNylXQnECJY02jw60zFkkIaXOSsy
        dPiUqztj88DQh2ajS1MNQKHYE3syPMtRQD8M7G49AcuVvSQRN6vCKYY1mhxU4xWi
        5SCHQ7KfoaanzH/RkiuGNWkn+GuRQFUA7qPEmDzLrV43LNfXp+4/51H5nxxt1XNO
        2NWBhzWjk3kjsmM5JLETGPXw6fdRRH6DwjpCha5a3LjVnMX7ru8MxqhYS00c3Je7
        N196yA/GS04yHdEPKPbhQBOkH23Y+CQc+vPmvoNUUnT3cgSrQyV70EZPl+3BzBvw
        /wCSYe2HXleODrMF6PfbQGF4m8uhwzmRp1igM9fEfCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lsyNJG
        lVJemF3bmuo/TeOw5FPZjguP/ok8eqc5zK9Yo=; b=KYLSd7g3/l1dZRbE1aWElm
        0vn0jRtYZvxicTCI5D4h76hj9rMGULr6zZ+Z+AYYGER17DRlzw2XlaP/jyPmQTVL
        7445ZLPB1rhVSftCUI7PiXu1Ra5w+f+zMpsK4NUUcJUvw1o5z5JNQbyDk2dZu1aH
        uiaFSgpfxkrACyz/V1AIy3rWMR0OK4zO/H40mFsDg6BSNe8wlBws5PZ4C4SyT+R5
        CNPG1aB+/yk8Oirfr3ESg6FYvGicHqWD6m47jNSBN64ynzPbe0LJ7xfQCmj+MZtg
        RrfUntTHgAPuKhdo4AOhiACE56rCgxjsle5CEVcPOaWwqaHnX/76fpVeXk/pSgsQ
        ==
X-ME-Sender: <xms:3uBaYZzlVpRHrRAP_sBcRVbvdcdZOPVsTCVWX2ESpmtydyc2VYdqzw>
    <xme:3uBaYZQHEHcqYa38XI6aoqdHgmd2hyli_-lK7qIxBElGgVJv9SykzS7us6CC6cOMu
    ioPEiMeM-F_3Q>
X-ME-Received: <xmr:3uBaYTWKcmSb6WgD2--2wlEZ6Iy94LpmZIRYWNQcZ4JSVQARgjPUPE_s7oHu1GFMPCtuQefZh5KAwiVQthiBYnc29uzp0VE7>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudelvddgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:3uBaYbjir1C_BhxEaZhK-yOF9msZNlAlX0RN-NTfoxpxv_h2g6W9NA>
    <xmx:3uBaYbCceC7spgFqXvBFdm7bYtVfUEMTDMpgE4CEMInYPzYLmrDc1Q>
    <xmx:3uBaYUJzR7mDW4Af8zYMj74TfmEcDPErtZ_WS_txF98i97fDESulrA>
    <xmx:3-BaYdw2dZX9yntdKNRxt_84XQS9lx80XCc8d_IJHnTtB8xZPm4Nww>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 4 Oct 2021 07:09:17 -0400 (EDT)
Date:   Mon, 4 Oct 2021 13:09:14 +0200
From:   Greg KH <greg@kroah.com>
To:     Nanyong Sun <sunnanyong@huawei.com>
Cc:     catalin.marinas@arm.com, will@kernel.org, suzuki.poulose@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, james.morse@arm.com,
        hayashi.kunihiko@socionext.com
Subject: Re: [PATCH v4.4 v4.9 v4.14] arm64: Extend workaround for erratum
 1024718 to all versions of Cortex-A55
Message-ID: <YVrg2mXyaI/5D6mH@kroah.com>
References: <20210929075210.819396-1-sunnanyong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929075210.819396-1-sunnanyong@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 29, 2021 at 03:52:10PM +0800, Nanyong Sun wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> commit c0b15c25d25171db4b70cc0b7dbc1130ee94017d upstream.
> 
> The erratum 1024718 affects Cortex-A55 r0p0 to r2p0. However
> we apply the work around for r0p0 - r1p0. Unfortunately this
> won't be fixed for the future revisions for the CPU. Thus
> extend the work around for all versions of A55, to cover
> for r2p0 and any future revisions.
> 
> Cc: stable@vger.kernel.org #v4.4 v4.9 v4.14
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: James Morse <james.morse@arm.com>
> Cc: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Link: https://lore.kernel.org/r/20210203230057.3961239-1-suzuki.poulose@arm.com
> [will: Update Kconfig help text]
> Signed-off-by: Will Deacon <will@kernel.org>
> [Nanyon: adjust for stable version below v4.16, which set TCR_HD earlier
> in assembly code]
> Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>

Now queued up,t hanks.

greg k-h
