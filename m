Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7DD6BE9BA
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 13:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbjCQM5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 08:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjCQM5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 08:57:15 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839836BC35;
        Fri, 17 Mar 2023 05:57:13 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 18C145C00C2;
        Fri, 17 Mar 2023 08:57:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 17 Mar 2023 08:57:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1679057831; x=1679144231; bh=wH
        WJBfMShjSFXsFCq5Zk4cPStZjnt2HZow5SXTrbR1M=; b=ocKgd9SpcBruwflJI3
        NQNli0D84J6K/1wC+siptfN3QvlrUNAagJY+/mliyoxTo2Um/ABgjOex7tTszw2S
        cSPoUQdIY3dYX0V/HtUZ4+ch1YrD32DPvqtK6nAP7Zn9R1Ac82VqLfShiqXTS0Rt
        Qz9wGevBHvynazlgqeyhWoQAQnyKZes/6THQYGh80FeblFE1ZeoEVPZppp04NJgh
        7z0z1VfHhhUEN7IDDIUf/do7k5itKbcOh9tV67zDMcszhoDa0vDQDxjPjNnu4I6B
        OhtToeemRArGpniM9lkLdmnoY0sUAwDMTl9FGTsxeHQbPk9tPoW+elKMiZLBv+Qr
        om+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1679057831; x=1679144231; bh=wHWJBfMShjSFX
        sFCq5Zk4cPStZjnt2HZow5SXTrbR1M=; b=Bv1LUJCxrgEpcdXPsfdmUSEmkC0nR
        ZDGSKCt+u1Gi5vnVVk6v0aSFEtXxOAW3oIiHJTqmm1pzs4+ZgBwnP95cvA4DPCrw
        /PGVwTppHr290LGb2KFa8GbjAMoLA27mnCIC4Kpzf+R7zt7WuQfyFNMvXD7PQUDh
        sMGj4rQZKayKmtVU/mCU4hohaXpN3R4t9ohU7/SGf+P40KSdNLvqVbKLA04IU9Jp
        3cY5WTsl5AN4ePhWB37ii9eDCEnJQVncxE2xvMvP5/E0nso0B9QmHDAiM26nGhVB
        QL/ZO0/XiJY4GeD2+bVGMTzsS3pNYjykjd0TVyWahTHTWY7V4xQPFushw==
X-ME-Sender: <xms:pmMUZC7ptSIlbM2gWy7XOhucz4BDQZ3QQryGuhPVIpmUEtyNP_1JaA>
    <xme:pmMUZL64UVkoSJ-A83NQJGUt10rOtEhltjeFkpTujnYLXbWPfBLF6LgSX-PF6yvgX
    8UGJpbEPuqaUg>
X-ME-Received: <xmr:pmMUZBe1Tn4JoScfyfxc-lsPazYba8vlS0E1o-TGoKaOliy36RIyjg0tEmJTvyMVfQOpzPfTXwkcLqTeFbD5vn_A5Za4EjaQDElvjA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdefvddggeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:pmMUZPIwTaZgAgmSRMWnsGCqxdgzlbqud6PsRAdiTpSeX9kKh-sBHg>
    <xmx:pmMUZGIHM2D0WJWqk7XccSi6n5ed39Rp6sYgTaphyDPuaRPTyXEppA>
    <xmx:pmMUZAzNmhlPZbxdlXum2Zn2fyfJ6qSiKlEwlcFdPmdfLI_I-8r1xw>
    <xmx:p2MUZDA20ntsMYjCKU9RgTkuSai-KdFn1xP6Ix44WirJQAWxjJNd0A>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Mar 2023 08:57:10 -0400 (EDT)
Date:   Fri, 17 Mar 2023 13:57:07 +0100
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-ext4@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Tejun Heo <tj@kernel.org>, Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5.4] ext4: fix cgroup writeback accounting with fs-layer
 encryption
Message-ID: <ZBRjozEki2sRr9vR@kroah.com>
References: <20230317050119.55794-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317050119.55794-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 16, 2023 at 10:01:19PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> commit ffec85d53d0f39ee4680a2cf0795255e000e1feb upstream.
> 

Thanks, all queued up.

greg k-h
