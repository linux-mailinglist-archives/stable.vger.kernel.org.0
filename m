Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30CE061F764
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 16:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbiKGPRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 10:17:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbiKGPRf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 10:17:35 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85261EAF8
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 07:17:34 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 47F005C0165;
        Mon,  7 Nov 2022 10:17:34 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 07 Nov 2022 10:17:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1667834254; x=1667920654; bh=CUkidtKBWW
        HcMNGXxiC5dIRtRiBf96s5Ar+SA4WMLoM=; b=Ib8siO1V8SvKVBQwHzZbNFbU+K
        x9OjCH8RUOp4dI8TESxSYQMG7h2tHOZnGGvUz17Zp9EWvfBMCbB7a1MQUikJDEcQ
        6i0oXQzUjrVkkQPaCZk0e3VZHdAF/XAAufzHyGiw0MIu/PabcMZ+NVSqLMhfNTBO
        sxYs30v6dOAXZalITF75sPA/wAuiS2qICzVqRpgsZ6yZtkr1Ue5aZbjfUwBMBBey
        ly3QSI0ni7J32DqTUvj0Vv6niz9iyNNHEO/rQNvPQdLio6gSvIXyfeanfsKrwYqA
        xMUxTldcD9I7ejYnIpE4PPMWIc67trey7KMPHn8eTzc03zNEBi+pjTCArM6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1667834254; x=1667920654; bh=CUkidtKBWWHcMNGXxiC5dIRtRiBf
        96s5Ar+SA4WMLoM=; b=ioR1pi+s2Ghoy2YKCLYD+pk1J5w3war0+CfwgwciJ+Te
        kLvVwT6OrUZY6wCuNfohcvyGRYf1zg0jlTdZWlPuTRpRxlnhTBBz43clXu65OOH1
        g2ei0Dv10eNuNbWaTTZy1kcNj2hv4jpyOtCDdEwdimI/wBIVX8YQ/T26gdm5w1O/
        6UeFToCHgp8kjZBqTzEg4YpIggisMskQm3ZZnk9RrdzROfDucSVm79Navjv+aXYc
        89EMYHemLQ6Fn4ZQe9X8vHXrUm5PRD+AgOlauwS81bz1aa28wD1bd71e3esAgA0u
        6dD00jWCqUipbX3hSJ5m8xV4g6AFFxQD7g+r9j2DCQ==
X-ME-Sender: <xms:jSFpY_PJx4cqrJddvKnrTJVpWRTLPU7nT1iKfW8Vlbgzk8-QrurqXQ>
    <xme:jSFpY59qe30agYtvNASkZdZK0hqJTKqhHlzqbphdgdFcG1yO_miQK6Q3V1yWZUejx
    uSksFOgEx2Yew>
X-ME-Received: <xmr:jSFpY-SXS3Mueysw9ag-TnUZolzTS8hQKKdcVBjgT3LGm6DpCfggLh-Dxbgh2oRCvVdkBHUSfWED4D1lJlNl5IPT622qqPeW>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvdekgdejvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegheeuhe
    fgtdeluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:jiFpYzvwuQTB-pklmJpPdwgyup8fLh-nVQ7Hd-9I7-agHwLlFBCXVA>
    <xmx:jiFpY3cPqO3XXsqL8y9uMY7G41zOflou5PVcsSynG_y1ENIyPyLQlw>
    <xmx:jiFpY_0bDiMeHIQzhn49c_HZgG550a_g4YX2ZIb1dNsMUh9woDnjdg>
    <xmx:jiFpY-7Bw24Pbz_SsTPpW2NIItbVdGiGa4fF5FQzyfQAJDkxvLSarg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Nov 2022 10:17:33 -0500 (EST)
Date:   Mon, 7 Nov 2022 16:17:23 +0100
From:   Greg KH <greg@kroah.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 4.14] tcp/udp: Make early_demux back namespacified.
Message-ID: <Y2khg2DvyLLgQDYi@kroah.com>
References: <20221103235033.47512-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103235033.47512-1-kuniyu@amazon.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 03, 2022 at 04:50:33PM -0700, Kuniyuki Iwashima wrote:
> commit 11052589cf5c0bab3b4884d423d5f60c38fcf25d upstream
> 
> Commit e21145a9871a ("ipv4: namespacify ip_early_demux sysctl knob") made
> it possible to enable/disable early_demux on a per-netns basis.  Then, we
> introduced two knobs, tcp_early_demux and udp_early_demux, to switch it for
> TCP/UDP in commit dddb64bcb346 ("net: Add sysctl to toggle early demux for
> tcp and udp").  However, the .proc_handler() was wrong and actually
> disabled us from changing the behaviour in each netns.
> 
> We can execute early_demux if net.ipv4.ip_early_demux is on and each proto
> .early_demux() handler is not NULL.  When we toggle (tcp|udp)_early_demux,
> the change itself is saved in each netns variable, but the .early_demux()
> handler is a global variable, so the handler is switched based on the
> init_net's sysctl variable.  Thus, netns (tcp|udp)_early_demux knobs have
> nothing to do with the logic.  Whether we CAN execute proto .early_demux()
> is always decided by init_net's sysctl knob, and whether we DO it or not is
> by each netns ip_early_demux knob.
> 
> This patch namespacifies (tcp|udp)_early_demux again.  For now, the users
> of the .early_demux() handler are TCP and UDP only, and they are called
> directly to avoid retpoline.  So, we can remove the .early_demux() handler
> from inet6?_protos and need not dereference them in ip6?_rcv_finish_core().
> If another proto needs .early_demux(), we can restore it at that time.
> 
> Fixes: dddb64bcb346 ("net: Add sysctl to toggle early demux for tcp and udp")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> Link: https://lore.kernel.org/r/20220713175207.7727-1-kuniyu@amazon.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

All now queued up, thanks.

greg k-h
