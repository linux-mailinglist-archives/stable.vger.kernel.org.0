Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494DC467522
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 11:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbhLCKfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 05:35:40 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55409 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231630AbhLCKfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 05:35:36 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D6C6D5C03E5;
        Fri,  3 Dec 2021 05:32:12 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 03 Dec 2021 05:32:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=A8v/ZZnWdFM8OAkP8mS/D/fS0Ya
        VKxSuLHnhgfoaeHs=; b=gFMe824DTquAYFry76RoPkU1m9yP5PXBDVH49kg6uRF
        Mz1WZa4nNE2cmczgdMjoE6egyQGatNCgCpyMQIzcqd6kC/oH4aLJkVDtG0kSr6LK
        xyER1G3jWriLhHrQL77C2LvlNnmws8sDPcnIGbO2f4tcypqRR4nhk68wAe5d4bVN
        ZboCurL9Gm8adB/o0iVFEjV/va5M9jXzyaoIzRBfWkmFFZXoQ0X/NHSfWcKiLTYs
        RPpGvcl83ilQ5pkkBWhmRZck1PbeYXw3kOeFDFNH2fL9wxJWg17axuWO05CpTwre
        dUoDp55cth6xngSk9AV07mTpe8HlNCKuCmK9dx1jK4Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=A8v/ZZ
        nWdFM8OAkP8mS/D/fS0YaVKxSuLHnhgfoaeHs=; b=TL+rpRAY862v6tyQ7jnxRz
        RgPvql3xg29I05O5xlyxZ5z1Mp0EwEHaBytZEUL0tzI747ysNE9j/wc5lbTmMTg+
        8NMAt7vdIYPJwcDkFovVsSLFHxKCC3JTj5iJLH8ga7ll1Y1L8OsatjIt84dLUupG
        2ilF0etqzPhLH7u91zLu4+OFNyKZwHyo2QgrWSNL7j9N7ZnRem5hh0ULzflQaZJC
        UNq0Vv069qMxgPMPtDQTIiN5E0ABlRZRkvoGdfKVvph+TFuJPhVZtvFXlIVEquMd
        pFIcFB0BpWeJ3f6q6HMDlFxh9Z8B0uJp5rzrsY4CSU6AX8EwYGf3rJh70L4kH16g
        ==
X-ME-Sender: <xms:LPKpYeI6GFAMh3QMBRY4N_Prves2-AjZeX_Pjm0vtd26HEfi4OwnXQ>
    <xme:LPKpYWI6hmuye27_Od31BiIynMxy4J6V3IkDeu-5NgqDNxO3aiga1vC2qShFuEpE4
    enuBPOqnUIsIA>
X-ME-Received: <xmr:LPKpYes_Uyb8q2KZkJrigjr38RRNqtCOSAS2KzRR1hnkuVa0QZ9hfTVN2jKWbvBLvK5LD0IL4jk-8Hl-7edAkP-nd6RqUb1q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrieejgddukecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:LPKpYTbFZhipxvXRs7_JjI6j9-8Ixgc6D3In5XRAP0-9DSvalvZlzQ>
    <xmx:LPKpYVZA_JZvpGto2cPEG5Xw_sHGv5Ix1CevYTOLRz7gxaunEllxag>
    <xmx:LPKpYfBEY08YWP6fUASPcxbfLHY0sIy99gyGcNPz7ydPo5y62fD2sA>
    <xmx:LPKpYaMccqAaSMK7eqGXFDQ6jqdwjiFofOCeBi6O6nWmKSE-Xy0afg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Dec 2021 05:32:11 -0500 (EST)
Date:   Fri, 3 Dec 2021 11:32:09 +0100
From:   Greg KH <greg@kroah.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH] can: j1939: j1939_tp_cmd_recv(): check the dst address
 of TP.CM_BAM
Message-ID: <YanyKbQL44An1HKH@kroah.com>
References: <20211202155256.2405492-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202155256.2405492-1-mkl@pengutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 02, 2021 at 04:52:56PM +0100, Marc Kleine-Budde wrote:
> From: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> commit 164051a6ab5445bd97f719f50b16db8b32174269 upstream.
> 
> The TP.CM_BAM message must be sent to the global address [1], so add a
> check to drop TP.CM_BAM sent to a non-global address.
> 
> Without this patch, the receiver will treat the following packets as
> normal RTS/CTS transport:
> 18EC0102#20090002FF002301
> 18EB0102#0100000000000000
> 18EB0102#020000FFFFFFFFFF
> 
> [1] SAE-J1939-82 2015 A.3.3 Row 1.
> 
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Link: https://lore.kernel.org/all/1635431907-15617-4-git-send-email-zhangchangzhong@huawei.com
> Link: https://lore.kernel.org/all/20211201102549.3079360-1-o.rempel@pengutronix.de
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
> changes:
>  - rebase against v5.4.162

Now queued up, thanks.

greg k-h
