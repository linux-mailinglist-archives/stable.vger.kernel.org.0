Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010A94E9191
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 11:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbiC1JlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 05:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239905AbiC1JlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 05:41:21 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091A25371A;
        Mon, 28 Mar 2022 02:39:40 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 6036B5C01A4;
        Mon, 28 Mar 2022 05:39:38 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 28 Mar 2022 05:39:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=3gI26DL8NQTZpr
        waOUHaJBNyZ4xA3LZVbCf2m5zXIx4=; b=Uk4hYrpNC/VYg9XroMdIYT0Vl9rQzy
        cwgtj7fKMu7SNOpOotdpSC7QIxE4wTSB1T2JoVWbGDeeBthXdenU1/pq4gO4JiAM
        7hhz2AWwHPsEDOjkJoGnWBiQveQBfGt/IiMUjra5Pdo9wmliePS88rjE66EvmDJm
        fAqvcYbxr2wHOh3tUS5uqNhKvnRNNIt00jnIubDVf0DDoISLsjz0qYhCUdXxPdjn
        NHz4FbZwFtnHiU3A3Vspv61CsPklQgT+6uUm3W6QeCod3tHzqR8ZFbKrILZdmwoE
        NbF1aARD9FfeYYzccnlYztivgx4bFvNOKzjgRLySWVhGkW4g+jhEj/aA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=3gI26DL8NQTZprwaOUHaJBNyZ4xA3LZVbCf2m5zXI
        x4=; b=MzgqK84xvBH/V+dwP2YBQ7shQ7JOoVHfm0dnz3lFTFcsxSc832CYJZIgc
        fQ48YP21DOf/SpwIz4c9TR/FEc8UyCtXJCtePQJvj6qX6ci+UuC0yvjSujDM2zq9
        89oW55nF2/MDzSygU4X8OwTXwuDSztpceJqfdngAAXlNHjB5CEvVcwIExMSHz/39
        BLI2WU3qy0teUfRUsO4X0Zrs9MN2bMYoWMCpRb3dHURXqCiFmSgDeKeaNsBDFG9r
        lG1BOcB/JPSHV1mPsXnV9pPY/elw3h0vYZuYl5qIdX4ad9PpGcrPTUohXxAC7QaG
        A4B87Lj3X7qntexeBDECuZIjcPVyw==
X-ME-Sender: <xms:WoJBYtKBFEVGfYob0UEuvFcnnWCpBSmiRrEZDWnb0izE-nq_wUxrXA>
    <xme:WoJBYpIO7OdMgZ0n5Ksh15ofTqeEYHUucVcP-tvs1vamVjsToI-f0S70wJcukJ9YB
    piAZrvXW73VBA>
X-ME-Received: <xmr:WoJBYlu4kdaRuuIMjaT50kw7lmIl_U2Lg-2-WIUOVsYOQbcrde_A56Fuw2iSF2Xrw1GjCMf2Wksre4V_sDX9gVFgqZlvVgFX>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudehjedgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueehke
    ehlefffeeiudetfeekjeffvdeuheejjeffheeludfgteekvdelkeduuddvnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:WoJBYuasdGrZY-MU_0USTIFV0SVlS7uSBY4h9UBjlveqD0HRMTRtjQ>
    <xmx:WoJBYkYGUDs7rbjE7uydSCQSe2yxy-aIuRYlcw1GQc31lvBO30n32A>
    <xmx:WoJBYiAsJCRLPMO4FqH4S8FFs_8W7SOMsbcp9QfLSItbYsxl86XoFw>
    <xmx:WoJBYpP_zfEipcoDOvPFf7hJAahemGi7eFHigZ_K0L8AO4ZXTnwlag>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Mar 2022 05:39:37 -0400 (EDT)
Date:   Mon, 28 Mar 2022 11:39:35 +0200
From:   Greg KH <greg@kroah.com>
To:     Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc:     stable@vger.kernel.org, linux-hyperv@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: Backport fix for 5.15: hv: utils: add PTP_1588_CLOCK to Kconfig
 to fix build
Message-ID: <YkGCVy5Y14h5RB6O@kroah.com>
References: <20220328093115.7486-1-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220328093115.7486-1-ynezz@true.cz>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 28, 2022 at 11:31:15AM +0200, Petr Štetiar wrote:
> Hi,
> 
> I would like to ask for a backport of upstream commit 1dc2f2b81a6a ("hv:
> utils: add PTP_1588_CLOCK to Kconfig to fix build") to 5.15 kernel series as
> it fixes following build failure for me with 5.15.31:
> 
>  x86_64-openwrt-linux-musl-ld: drivers/hv/hv_util.o: in function `hv_timesync_deinit':
>  linux-x86_64/linux-5.15.31/drivers/hv/hv_util.c:770: undefined reference to `ptp_clock_unregister'
>  x86_64-openwrt-linux-musl-ld: drivers/hv/hv_util.o: in function `hv_timesync_init':
>  linux-x86_64/linux-5.15.31/drivers/hv/hv_util.c:746: undefined reference to `ptp_clock_register'

Now queued up, thanks.

greg k-h
