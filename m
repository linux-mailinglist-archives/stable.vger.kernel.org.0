Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE5565AF8C
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 11:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjABK2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 05:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbjABK2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 05:28:42 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8411027;
        Mon,  2 Jan 2023 02:28:40 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 5BA2A5C0159;
        Mon,  2 Jan 2023 05:28:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 02 Jan 2023 05:28:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1672655318; x=1672741718; bh=ipZXv8yRhK
        ZofvGCU1oHV2J3KqF43Zgo5kJ7nwHtRMc=; b=kQXkva8oxxbRAEiIloZjO3uk81
        dnTXr8q7G58VCyjd/Zau9m+LfWN8bfEkUXJ+bFm2/OFQ+KAr1dQDmuLMxtXiHEkC
        G3FT3LDZokJVBCRz68o+HcwrLGU35rV0k7nQwX+rroX7XRUymCOQMksCRpe7iVK3
        FPbJSRJwVznmo3p5PwKlHmo4tq1yLY2Bd6rUZbayi+WFK+BBp8m4Yg7yUkluvX7b
        DQGpe1AQFZPwE0OspTNd39r20GDEeTJRjidYzAPxglBpy+GmNPhNm/yCgfyqh5xW
        gxZMyLCU80ZRBErkAnMVtS+NT5i05YcchXWtgwQa66VsdNEOoqb1JVpNWWUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1672655318; x=1672741718; bh=ipZXv8yRhKZofvGCU1oHV2J3KqF4
        3Zgo5kJ7nwHtRMc=; b=Ixc8JFT6byBxNkl/njDvcqd5WY2RThkZxXZ8Scd60oXW
        s80BWqS1eajVNFlhpPJ9uLNurww/DQrkIP87Ho06dwpdMObyN/h9DC6Vrq1Nx6zX
        CPIL1vaPZAGlfRZWuIAZZwqpuZDbSnCsKTeZawlIscJaJeqPY3aoGiPoTAk9jNLw
        9z8m6gOR2mudv5FfZe4enIlB1GJfCY28HUbQVZqUZdmOxtUuz0dV7uU1J7H8HOGx
        bxVAjmp8ErdneVx0adGXccA/VqM1Nz2u2vGppU4sz4AkEcI1sC5l92n+FOxFJlhg
        1u0Z/6qIg0uEmyLDPLJjGQjZIwaN4Bst4FV2RcNW4g==
X-ME-Sender: <xms:1rGyY8XOuoxt9kIP06arDk3ls1d1rLA7p4oWJq8Lyk1BzjnhkCPgRA>
    <xme:1rGyYwkk4Xwu6uS_8R36mQDxpss-nV-VzhbP6yhDjWWm7V1pbgs7H__5Zob0ReD6K
    PE7KABNKlOHyw>
X-ME-Received: <xmr:1rGyYwbG6G-t_rmpXPweM4x59TBBS-ygEPXIMjGiJoVBNagjXE_XZrVTpqwLKarPU_OuuFKNKHt17SqGaYCqCSOJhaJGG9abxQTMD7yxlUzZ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrjedvgdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegheeuhe
    fgtdeluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:1rGyY7Ugcc7YR7SfNCkF535dqbcLPByedCaKJMo_PUvjUm5ez2lLrQ>
    <xmx:1rGyY2lPreJ20hCUQmqFqcCbhL8yxY3Hpx2x91mwRDSjBU7T_f1RrA>
    <xmx:1rGyYwfC1fx5iD6mc0FJAPI9vvya7u_uE0ufBmHQN4oTSYpoqmi5sg>
    <xmx:1rGyY7-5mIqWe2Ncy-ymOryvowo-Xq9qXnVlTIzJQEvnUv-8I5CP6g>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Jan 2023 05:28:37 -0500 (EST)
Date:   Mon, 2 Jan 2023 11:28:35 +0100
From:   Greg KH <greg@kroah.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        stable-commits@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: Re: Patch "powerpc/msi: Fix deassociation of MSI descriptors" has
 been added to the 4.9-stable tree
Message-ID: <Y7Kx0xTFluvKDrCB@kroah.com>
References: <20230102033733.1838845-1-sashal@kernel.org>
 <868rilb6lj.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <868rilb6lj.wl-maz@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 02, 2023 at 09:58:48AM +0000, Marc Zyngier wrote:
> On Mon, 02 Jan 2023 03:37:32 +0000,
> Sasha Levin <sashal@kernel.org> wrote:
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >     powerpc/msi: Fix deassociation of MSI descriptors
> > 
> > to the 4.9-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      powerpc-msi-fix-deassociation-of-msi-descriptors.patch
> > and it can be found in the queue-4.9 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> >
> > 
> > 
> > commit 760aa3717faf046c8d5bdc27c226179d192b7ddf
> > Author: Marc Zyngier <maz@kernel.org>
> > Date:   Sat Dec 17 10:46:44 2022 +0000
> > 
> >     powerpc/msi: Fix deassociation of MSI descriptors
> >     
> >     [ Upstream commit 4545c6a3d6ba71747eaa984c338ddd745e56e23f ]
> 
> 
> Again[1], please drop this from all stable branches, as it has no
> purpose before 6.2. If I wanted it backported, I would have earmarked
> it as a stable candidate.

Now dropped from all branches, thanks.

greg k-h
