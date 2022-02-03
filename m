Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E0E4A8926
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 17:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242119AbiBCQ6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 11:58:18 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59033 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233754AbiBCQ6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 11:58:18 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 534EF5C010B;
        Thu,  3 Feb 2022 11:58:17 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 03 Feb 2022 11:58:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=MAGzkX2aQdNcpZha8/z+/OQ3OFRwb2miu7EFTA
        6BnNo=; b=mWYxHJLVnV3vAOrxm1CqPrrDPDymFKahTyALNdGdjHyW+8mfuZATqA
        c/HkSRD0wAblBv0yYsd/NfB0DKFphX02zaXLU+DqrFID6rpNvubt8GplijPUVCn+
        1it7fyagKpiyQWKpInjeBue19vGolPnC7m8RbSPS+2PAn9XWc5tkNuSw3GtrrDGN
        XPsLj+LEMlr/ocI7ksD2qSl0s1hCCoTbb+KYzQy1JBOgoYpKITZ2qPib8rcd+ehS
        B60MudWVIeRUgMquLUqDDyUW1NoT5j4oNqhuWPudHfVudU2cYhavs0VTAnAwyVCX
        awY1tyExt2ETZIIIrSSQzCXi42Id8bFg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=MAGzkX2aQdNcpZha8
        /z+/OQ3OFRwb2miu7EFTA6BnNo=; b=CQDHJRaJQrS/GFEQ8E8OuMXojXBaZ5pK0
        tQxw8DskqeXFTlbefKpAhKKwIAckF4C+CJWusxbdi2wpCv8EDnXGtQZ8yAgcJRXN
        80TgxTkE5eRNsSyUuyVaZcTr8XDFuv5GnRJuQoY5PVrnySLoR+w6/1ap5hPxFQqm
        a2Z956g07eTLIx4AEkcW0LzCAv6tVP+dnTTDLjdpSAoSGhzgFkCxgU/ANsPL03oj
        caeFvEuRl+LO6CeSPzXKe/YwnmKgenRqogLY3ctcokiOT3rsGXL89KjNFvS8dp7r
        /DO7Fvi8vkD+JCvIo2wKdR7DYBd3nnjeaPsirT7EuZebDF/yiS0vw==
X-ME-Sender: <xms:qQn8YeDP7PwXbDcwptMcUDnsuHblEblm1dVc2HsshdVXCHCB0kjJWQ>
    <xme:qQn8YYjeDZ5vRGYjJwsGax_jhURAGQ8eReEqTTLaUQn6g2JDyOORBxTTkOK3FGvqn
    3wAYLdshzfojw>
X-ME-Received: <xmr:qQn8YRlIls6z1JoCE9XgkJ9g5QbYBduL4XdsKDKkT08EZ39Luofi4Z6nch9kAdbIeQH6wnS0Mkw5aj9254St_ExTmu4an2Qn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrgeejgdelgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:qQn8YcyUsmTEIOa2C2war8SF72Fm8HYFi8INw49XoTcOcyzVWEO4bw>
    <xmx:qQn8YTRnDKIbEoAjbYozLqSbHHuJMNCDbAIKt8Lmwig2bN4lAThmkA>
    <xmx:qQn8YXZF1-CRWDCGN2FGd0R_bQluRnZkcW-KS6qZHmWlK7clNiDcgQ>
    <xmx:qQn8YeFou-PEZiCXrKBFOcdhctll6LWctBdbbbLOr1NZEjTq0SIkJA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Feb 2022 11:58:15 -0500 (EST)
Date:   Thu, 3 Feb 2022 17:58:13 +0100
From:   Greg KH <greg@kroah.com>
To:     Alex Elder <elder@linaro.org>
Cc:     stable@vger.kernel.org, davem@davemloft.net, elder@kernel.org,
        Matthias Kaehlcke <mka@chromium.org>
Subject: Re: [PATCH 1/1] net: ipa: fix atomic update in
 ipa_endpoint_replenish()
Message-ID: <YfwJpS0nKpaqItBq@kroah.com>
References: <20220201012636.308616-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201012636.308616-1-elder@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 07:26:36PM -0600, Alex Elder wrote:
>     XXX commit 6c0e3b5ce94947b311348c367db9e11dcb2ccc93 upstream.

The "XXX" is a bit odd, I've dropped that :)

Thanks for the backport, now queued up.

greg k-h
