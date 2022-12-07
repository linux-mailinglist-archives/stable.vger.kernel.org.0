Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0906D6454A0
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 08:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiLGHdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 02:33:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLGHdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 02:33:03 -0500
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C0418367;
        Tue,  6 Dec 2022 23:33:01 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 3BFA83200911;
        Wed,  7 Dec 2022 02:32:57 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Wed, 07 Dec 2022 02:32:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1670398376; x=1670484776; bh=1xnvlijY+i
        6/Li/GlHHN8n21RKCu4z9gY3vmv0zrHL0=; b=dw6u4JAkUfiBj828hEMryx+Yk8
        d5UJBnw6eHIsh19+ODZGLCi8y/JGRNun5P4hbki2Mhdi/D2d9ro8dHWKrxzQjbBp
        l3wpr3+uoMg5DDkhK+UJr1cObUafBBRm1qCN+FvyNxH1k4YRIsYqo+B+UBgyUVc3
        IHMj2AlaPTxZEWw8LtPjUhEZgCm1GxSUZya1uKLRxOmkNJJuOAGJ4ccGxRKj/gNk
        i7kqFBsCCDo7m201+xcl3U5P7mx7cdJCdl08fqXQjc4l02Birqk6CribbCOppMLy
        U+BfjRAub8Ai8Rdqoxv0fsCmOY/BmERRWZyNQXXvImgwKdkvjA/18AgXODVw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1670398376; x=1670484776; bh=1xnvlijY+i6/Li/GlHHN8n21RKCu
        4z9gY3vmv0zrHL0=; b=keEdFEOjqB9htN4CFvMJ/VG+iKpl3J5wLTds6rl8zkXI
        eGKnZNQPCwV1WQkgcSfDk1ISHRcsGWqZ+b5MXUoB1WgttZtokKAYRf45JGEJhKRx
        SfzcEfmd7lKveEfj+0PZGyR6SYKKCUgphfblFAgUB1Cw3QzksO7OqIpCAuuy90ci
        VA+apY8o26fbHWbIVUEBBlBU0DNex8GkMrEDG+OjlIvOCda4bW/1zmuh0lY90vcU
        AJkB79HZLWaipzEt51dHaQW+wVrpg4dYoMPlVwZyjIax5l9Tr6yBCKpwPLwWqOB3
        KEuSKZMRPRl4bHrdldS2C/4sxyyxZHU87pZKI4HnZQ==
X-ME-Sender: <xms:qEGQY8HVyHEazmmC6wT1eV5CHqrY3BEJp0pBdHbThix0j9f65qP-0w>
    <xme:qEGQY1WFcJb6jEVflDbfpeeulOOp20g8zL2vydnt66uDQExqHu5HTxVspgj0VyPti
    H4ZsulV-ksEl7jwfQo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudejgdduuddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepvefhffeltdegheeffffhtdegvdehjedtgfekueevgfduffettedtkeekueef
    hedunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:qEGQY2J7b73OJmWWiEcRT8w37BLvJfR0DW9wFW3QoVfOG_XX7mEgEg>
    <xmx:qEGQY-EAjdAm7jXP_lhMcyUM8QZ2o3qKvQ35QKnimUZMyDWjqAKuqg>
    <xmx:qEGQYyVKg6SGjfYQH9yjkdcqMCc24bx9ipcyOn37HlFWD4y2QrkupQ>
    <xmx:qEGQY0Iti1x4BKOthmTl4cR_8xmGTko0_8tWNNmRqqv5vKQB70hmXg>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 2669AB60086; Wed,  7 Dec 2022 02:32:56 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Mime-Version: 1.0
Message-Id: <e2597ffc-34d0-470f-87ed-e70d3914956a@app.fastmail.com>
In-Reply-To: <3beac08e-ffba-8c3b-a5b1-1a34e125b3a7@kernel.org>
References: <20221203105425.180641-1-arnd@kernel.org>
 <95785bc5-ac4b-9c44-74ea-6b3afb11cf14@opensource.wdc.com>
 <3beac08e-ffba-8c3b-a5b1-1a34e125b3a7@kernel.org>
Date:   Wed, 07 Dec 2022 08:32:34 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Jiri Slaby" <jirislaby@kernel.org>,
        "Damien Le Moal" <damien.lemoal@opensource.wdc.com>,
        "Arnd Bergmann" <arnd@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        "Luis Machado" <luis.machado@arm.com>, linux-ide@vger.kernel.org,
        stable@vger.kernel.org, "Randy Dunlap" <rdunlap@infradead.org>,
        "Nathan Huckleberry" <nhuck@google.com>
Subject: Re: [PATCH] [v2] ata: ahci: fix enum constants for gcc-13
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 7, 2022, at 07:41, Jiri Slaby wrote:
> Arnd,
>
> I just noticed this on stable@. Do you have more of the gcc-13-enum 
> patches? I sent some (this one incl.), but didn't have time for v2 of 
> some of them. So should I respin the rest or have you fixed them all yet?

I only have this one, as this is the only one that Luis asked me
about. I haven't actually tried using gcc-13 myself yet.

>  > [PATCH] ath11k (gcc13): synchronize 
> ath11k_mac_he_gi_to_nl80211_he_gi()'s return type - "Jiri Slaby (SUSE)" 
> <jirislaby@kernel.org> - 2022-10-31 1243.eml:Message-Id: 
> <20221031114341.10377-1-jirislaby@kernel.org>
>  > [PATCH] block_blk-iocost (gcc13): cast enum members to int in prints 
> - "Jiri Slaby (SUSE)" <jirislaby@kernel.org> - 2022-10-31 
> 1245.eml:Message-Id: <20221031114520.10518-1-jirislaby@kernel.org>
>  > [PATCH] bonding (gcc13): synchronize bond_{a,t}lb_xmit() types - 
> "Jiri Slaby (SUSE)" <jirislaby@kernel.org> - 2022-10-31 
> 1244.eml:Message-Id: <20221031114409.10417-1-jirislaby@kernel.org>
>  > [PATCH] drm_amd_display (gcc13): fix enum mismatch - "Jiri Slaby 
> (SUSE)" <jirislaby@kernel.org> - 2022-10-31 1242.eml:Message-Id: 
> <20221031114247.10309-1-jirislaby@kernel.org>
>  > [PATCH] drm_nouveau_kms_nv50- (gcc13): fix nv50_wndw_new_ prototype - 
> "Jiri Slaby (SUSE)" <jirislaby@kernel.org> - 2022-10-31 
> 1242.eml:Message-Id: <20221031114229.10289-1-jirislaby@kernel.org>
>  > [PATCH] init: Kconfig (gcc13): disable -Warray-bounds on gcc-13 too - 
> "Jiri Slaby (SUSE)" <jirislaby@kernel.org> - 2022-10-31 
> 1242.eml:Message-Id: <20221031114212.10266-1-jirislaby@kernel.org>
>  > [PATCH] i40e (gcc13): synchronize allocate_free functions return type 
> & values - "Jiri Slaby (SUSE)" <jirislaby@kernel.org> - 2022-10-31 
> 1244.eml:Message-Id: <20221031114456.10482-1-jirislaby@kernel.org>
>  > [PATCH] qed (gcc13): use u16 for fid to be big enough - "Jiri Slaby 
> (SUSE)" <jirislaby@kernel.org> - 2022-10-31 1243.eml:Message-Id: 
> <20221031114354.10398-1-jirislaby@kernel.org>
>  > [PATCH] RDMA_srp (gcc13): force int types for max_send_sge and 
> can_queue - "Jiri Slaby (SUSE)" <jirislaby@kernel.org> - 2022-10-31 
> 1245.eml:Message-Id: <20221031114506.10501-1-jirislaby@kernel.org>
>  > [PATCH] sfc (gcc13): synchronize ef100_enqueue_skb()'s return type - 
> "Jiri Slaby (SUSE)" <jirislaby@kernel.org> - 2022-10-31 
> 1244.eml:Message-Id: <20221031114440.10461-1-jirislaby@kernel.org>
>  > [PATCH] thunderbolt (gcc13): synchronize tb_port_is_clx_enabled()'s 
> 2nd param - "Jiri Slaby (SUSE)" <jirislaby@kernel.org> - 2022-10-31 
> 1243.eml:Message-Id: <20221031114323.10356-1-jirislaby@kernel.org>
>  > [PATCH] wireguard (gcc13): cast enum limits members to int in prints 
> - "Jiri Slaby (SUSE)" <jirislaby@kernel.org> - 2022-10-31 
> 1244.eml:Message-Id: <20221031114424.10438-1-jirislaby@kernel.org>
>  > [PATCH 1_2] ata: ahci (gcc13): use BIT() for bit definitions in enum 
> - "Jiri Slaby (SUSE)" <jirislaby@kernel.org> - 2022-10-31 
> 1243.eml:Message-Id: <20221031114310.10337-1-jirislaby@kernel.org>
>  > [PATCH 2_2] ata: ahci (gcc13): use U suffix for enum definitions - 
> "Jiri Slaby (SUSE)" <jirislaby@kernel.org> - 2022-10-31 
> 1243.eml:Message-Id: <20221031114310.10337-2-jirislaby@kernel.org>

I had a look, these all look good to me, as expected. My guess is that
these all only cause a build failure with -Werror, so Luis didn't
get stuck on the warnings.

Some of them appear to overlap with work that Nathan Huckleberry
did a while ago to fix related clang-14 warnings, see e.g.
https://lore.kernel.org/lkml/20220912214523.929094-1-nhuck@google.com/

I don't know what the state of those is.

    Arnd
