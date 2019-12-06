Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0A7D1156CF
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 18:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfLFRzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 12:55:15 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:44821 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726317AbfLFRzO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 12:55:14 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C2AC9807;
        Fri,  6 Dec 2019 12:55:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 06 Dec 2019 12:55:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=TVzE7bLvXWlWYg2H1BnirD6z5AD
        MuAPINVkG3pkvUwU=; b=uQBjWg14pcuQ+dcoG6Z3bWyu1Zc5KuPtjObbtfV49Td
        lh900+dyB/ZWWG6wt5zrQTvXYWwAdxkt/BBpsFLvrFGZIuh+yMPpIE4DDyIApirN
        /iCltQfGDuv/NDMrEycLgH7VUuRBWaWZx1d1JCo/I09jlPduuDWrW7khGwQr866y
        k09RKx7cKzYJc/f4URdYhk6e1mX8sV2Hyx0GtU88XwPOqXfNfyWCr/HEIWzcFYoF
        uV6G+W9DMDU/YIFZeErRrrziX4D4YlVGe0+Xv0IXteSfgUBW0/L/9QuRfcgTA09/
        jq/yqPuvMK/Ik9HX++Xd7THdzAc/pIuStc4/vwhiZng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TVzE7b
        LvXWlWYg2H1BnirD6z5ADMuAPINVkG3pkvUwU=; b=pC8N/laXumoa3GtUYhSjdP
        H1D5ETCVEdk11y5KhvSEUAtiNUmflaYON4vXUwFkpVe9fpvvBDldQV/ZrtvinXfg
        gLTJUHCQtpRWAcPtF6OYz3vU5SrzmyaDLF1h1sI56o4y5+rsw4APTDtoE06YbFRz
        GefkKSk8+CeTNq6gE7a1viqaw0z7uM9juUtlJ53NXtKmgEM9Xn8CnJAZwQc3ovfP
        gib28YFfXxnXQJ3z1ZkFB+P7Rip/BfCzwNVq9K4VdkC6ZxLWBM4DiAj5aaBFm45h
        Iws3Ezo7lbP7shvcjVBM1XlLCSJzwsFtXRaDDgNdvqSmsXSINwJ4/eTHHulRjNWA
        ==
X-ME-Sender: <xms:AZbqXc49wYHcBxTVRYznoPRwuRLiKsX-kzv7WVgPkrqra0Nrkvxusw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudekfedguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:AZbqXcMI_tY9T9lgg17k0snLQ-F9vJSmKBmN4x3a0lc1odah5eTdzg>
    <xmx:AZbqXRvvcspTa6jjQOoCRriiq0uqpnuTCa6HSd2VHGbb4zLQX7j1gw>
    <xmx:AZbqXVfJ-Lx7OXhZHu6u_hcOhI1VgBcb3pFowqpc4NEUdlnfNjcDsA>
    <xmx:AZbqXYkguRVZXPXm4Y0uS8rd3fBBouVHiAcCKW5FV4brvF8-vFOB1w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E709480060;
        Fri,  6 Dec 2019 12:55:12 -0500 (EST)
Date:   Fri, 6 Dec 2019 18:55:11 +0100
From:   Greg KH <greg@kroah.com>
To:     Sowjanya Komatineni <skomatineni@nvidia.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 09/15] ASoC: tegra: Add fallback for audio mclk
Message-ID: <20191206175511.GA186026@kroah.com>
References: <1575600438-26795-1-git-send-email-skomatineni@nvidia.com>
 <1575600438-26795-10-git-send-email-skomatineni@nvidia.com>
 <20191206070912.GB1318959@kroah.com>
 <6fef4ee1-0528-9f8e-cb25-4af126d33b99@nvidia.com>
 <20191206162934.GA86904@kroah.com>
 <febf1f1a-6cca-c4d1-e220-50af5ef13ff7@nvidia.com>
 <bb19856c-ced5-1627-c5eb-ef44bbd177ae@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb19856c-ced5-1627-c5eb-ef44bbd177ae@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 06, 2019 at 09:15:20AM -0800, Sowjanya Komatineni wrote:
> -----------------------------------------------------------------------------------
> This email message is for the sole use of the intended recipient(s) and may contain
> confidential information.  Any unauthorized review, use, disclosure or distribution
> is prohibited.  If you are not the intended recipient, please contact the sender by
> reply email and destroy all copies of the original message.
> -----------------------------------------------------------------------------------

Now deleted, this is not compatible with public mailing lists, sorry.
