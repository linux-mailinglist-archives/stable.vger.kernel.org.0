Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0354F62DD
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 17:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbiDFPNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 11:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235841AbiDFPMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 11:12:34 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB4422836B
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 05:13:08 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 5CF873200EAD;
        Wed,  6 Apr 2022 08:12:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 06 Apr 2022 08:12:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=HICJqCIevJNs7C
        HtYoFBzAhRihzeEnaBSA45TAE/+is=; b=Q3YEoUYN598IgecT4CJlWcoNBqSR/Q
        wScunIG1EAxENJKGI5/WrI1TGeeA8bJhkfB50R7295hZhOCORieqfzIHnM3OlTpm
        ShviakAdFpv+K4SAYXWwrjGmagJ059iKW55TUeVFH6QKCy6gikd7+VD9VTBT8GKR
        TulBSevEahzZpzcR64g4YYHYPAkWn5ZRv5vVgFWqO3Wg0/APDtT1oc/s/xQPKwzw
        qMCZQglDVG+NInAxpfkm9SJBssx1WfCuUIL22EW/LjFWB56cgELeCdARykRjy2n2
        hz72aN7OibnAvbJsL+cB5RD3HizeV7leabI55DqaVlBQZo6BOaiLvZsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=HICJqCIevJNs7CHtYoFBzAhRihzeEnaBSA45TAE/+
        is=; b=bwvNOWPriSLJWWfM0W9vbrP/6eGL/p4DDWSg10M8dPnVwB3KeBEX8oMw8
        o1edReKsOdGdZD6GSSp0ZPVFVjNjJBmNB2fYVlWLajdNmiB94qjaOOosU8QBLdbi
        nJz7TYVs208lIG7XIfMbGEmD0ITzx/bZZ1mClql5zVBdJHKAqeTUWoda1Y3gHyjJ
        4d3pGbubcYOBmQW4tmwqDJ8k/aSHZu2WfktQnZFsaDiplcbmtphfroCF8QGdLZ+u
        PYPcpDgz/IpJ/gSjnEoTphO676lvuOw7o0yU1pZGCAZaTjkqXwe/1UOkkNibuZya
        82nlDquOgg7/nU1ZhwTlhXOlTcntQ==
X-ME-Sender: <xms:roNNYuZSeBWIa9walCL-XBJGlYubZcqTxYq9P80E015L7lpQa_Zvbw>
    <xme:roNNYhYMtGbqyPRFJ9uGmPwwOE73WbUgiWBfK61xLqkO7tUdNPiUxbuDEPRamXDf4
    ZGmyb1_9AJDqw>
X-ME-Received: <xmr:roNNYo9BLa0bIqbHogJl0WqljH3WCKrrKHBa_KQttD0Y18gELfqyvdHqVgL_pNE7iv8p2gz1XVk9aa2gBQjRFZyL_RJFW4Fv>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudejiedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeeije
    euvdffuedvffdtteefuefhkeehgfeuffejveettdelgfeuudffffetfedtnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:roNNYgrQ4huFmTLqAOguWZuJ9CNyDb5yeLGV9zmLUwE2xnpPQKiMrw>
    <xmx:roNNYppU91dQQ5q9yH2GHJe-V24_txMny6UBPyRWCCEXfYB3K_oUmg>
    <xmx:roNNYuT9L7VKekm8qXq9HPsx4UtCx_NW4HCp99cYmycSnW3qsE4kLA>
    <xmx:roNNYvYZZV8ZIsj5uX_49NZdTtVnH8FGR80kidsfVWu-wSwp9pYwmg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 6 Apr 2022 08:12:30 -0400 (EDT)
Date:   Wed, 6 Apr 2022 14:12:27 +0200
From:   Greg KH <greg@kroah.com>
To:     dann frazier <dann.frazier@canonical.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Toan Le <toan@os.amperecomputing.com>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>
Subject: Re: [PATCH v5.10] PCI: xgene: Revert "PCI: xgene: Use inbound
 resources for setup"
Message-ID: <Yk2Dq9SYXNRigr5i@kroah.com>
References: <20220405153419.1330755-1-dann.frazier@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220405153419.1330755-1-dann.frazier@canonical.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 09:34:19AM -0600, dann frazier wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> commit 1874b6d7ab1bdc900e8398026350313ac29caddb upstream.
> 
> Commit 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
> killed PCIe on my XGene-1 box (a Mustang board). The machine itself
> is still alive, but half of its storage (over NVMe) is gone, and the
> NVMe driver just times out.
> 
> Note that this machine boots with a device tree provided by the
> UEFI firmware (2016 vintage), which could well be non conformant
> with the spec, hence the breakage.
> 
> With the patch reverted, the box boots 5.17-rc8 with flying colors.
> 
> Link: https://lore.kernel.org/all/Yf2wTLjmcRj+AbDv@xps13.dannf
> Link: https://lore.kernel.org/r/20220321104843.949645-2-maz@kernel.org
> Fixes: 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Cc: stable@vger.kernel.org
> Cc: Rob Herring <robh@kernel.org>
> Cc: Toan Le <toan@os.amperecomputing.com>
> Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Cc: Krzysztof Wilczyński <kw@linux.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Stéphane Graber <stgraber@ubuntu.com>
> Cc: dann frazier <dann.frazier@canonical.com>
> [dannf: minor context adjustment]
> Signed-off-by: dann frazier <dann.frazier@canonical.com>
> ---
>  drivers/pci/controller/pci-xgene.c | 33 ++++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 11 deletions(-)

All now queued up, thanks.

greg k-h
