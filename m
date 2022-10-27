Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C4B60F4AD
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 12:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbiJ0KPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 06:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235418AbiJ0KPI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 06:15:08 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF5C34982;
        Thu, 27 Oct 2022 03:15:06 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 497A63200914;
        Thu, 27 Oct 2022 06:15:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 27 Oct 2022 06:15:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1666865704; x=1666952104; bh=Io5M/Xszrh
        TyWKbj+blqnBvyG4ioe9zy9Uf7n+jDrD0=; b=VXI/zgi3opSdNeP3/cd8VcMHl8
        HEDOEOBE+sj2DCLIEklhWLqn3yL/MVFPtwPIB+LnQg2jDvkrU4cF/y9TOMQhTO3u
        z32lQoFUfwPu1U+EKW0pHs5NB3OsmlgADxZgd2yj/AIGzcobONTr+gGM37wxGf4r
        0ojNgjZFONT9tQ0pq7feVoYux3+BhVQPISwXud1Lg1FPv0/9VKxP/2GsmjqTRLpf
        icMFHcoF8l5LmS/BP2MdfpvJ4Ocxospt8KxPF/wjCJsKVvAVi3ITJ7TRUAt92tQr
        TDP+AoUf9F8DkrjjhmM3wcn9xGuJ7wGhiD00O0j4JEhlCt5ZxpT2WNmjqrLQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1666865704; x=1666952104; bh=Io5M/XszrhTyWKbj+blqnBvyG4io
        e9zy9Uf7n+jDrD0=; b=Cp7CTknIY6LJISGerh9K95KA0aXhO9BJF/2K1Y/S2BAy
        gCO09+OObw7lsCkE3ZHOb5I4xIiJd/wR3rSCKI6FWcSvrdkAKN7ZIqu68WpJ5Cuq
        c1goHS3iuHr+WXU7yVQdEFTSNxH6gVVoAmyzfTo3rbnMyIuEIjfC8XPx1vw+38Wf
        BMyFEnkW8Zf/bZX3HIusHJTEXGgTFx0JXjuT7u5pDRUcqdcjAA3UpIt+5PuxrPIS
        ogIZ2Yf8yX5LS+XY28Ck5eOchHaQcCbAYp4rmdPPA4o80duR34TdspMeNESAm1Tc
        DfgEUdeIK1nHH19up0ll75ggo21m+qjAW2Qhyi2HmQ==
X-ME-Sender: <xms:KFpaYyqzdNTe9bB-YxDEr1CsWseyqCpIqYA8xLU_P3uVNEFO27NCUg>
    <xme:KFpaYwohVi1MVcuz6MZgeTMePaoITQhxGHssrfjnUQ2XnC3xxCP2sRo84OSRjzEI4
    gKKwQD0ILJCEQ>
X-ME-Received: <xmr:KFpaY3Nl88foVlgPBPIaW3fGWJIIioE8ckmBlPDCEuPXuleki04IFIalHA7CxBRvhQy-G5Gpne5-ZDpJ6xUTEuG0E5n0f0OM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrtdeggddvfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegheeuhe
    fgtdeluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:KFpaYx7wrlTijNs4k7F9vnf-c-sN6KjCBsy6234gaNZ7p-eZGBQDrg>
    <xmx:KFpaYx71ItYmEytSy1sQKjIZOgecWXs_ZYN8Lpgfbl4m41NQ4ly2Hg>
    <xmx:KFpaYxjuqRGERhrEdBWyE8X-CZ9Kk1ag4syYLT8VtUHlm-5J_9mUrg>
    <xmx:KFpaYwTxKf25LfFQAiP8m-z39ofdqrjDO6hpdEVctDw3CMaILr7ayg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Oct 2022 06:15:04 -0400 (EDT)
Date:   Thu, 27 Oct 2022 12:14:50 +0200
From:   Greg KH <greg@kroah.com>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     stable@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Evan Green <evgreen@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alex Elder <elder@linaro.org>
Subject: Re: [PATCH] arm64: dts: qcom: sc7180-trogdor: Fixup modem memory
 region
Message-ID: <Y1paGsh1o1Y3gAR4@kroah.com>
References: <20221017182241.1086545-1-swboyd@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017182241.1086545-1-swboyd@chromium.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 11:22:41AM -0700, Stephen Boyd wrote:
> From: Sibi Sankar <sibis@codeaurora.org>
> 
> commit ef9a5d188d663753e73a3c8e8910ceab8e9305c4 upstream.
> 
> The modem firmware memory requirements vary between 32M/140M on
> no-lte/lte skus respectively, so fixup the modem memory region
> to reflect the requirements.
> 
> Reviewed-by: Evan Green <evgreen@chromium.org>
> Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
> Link: https://lore.kernel.org/r/1602786476-27833-1-git-send-email-sibis@codeaurora.org
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Acked-by: Alex Elder <elder@linaro.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
> 
> This fixes boot of the modem on trogdor boards with the DTS from 5.10.y
> stable tree. Without this patch I run into memory assignment errors and
> then the modem fails to boot.

Now queued up, thanks.

greg k-h
