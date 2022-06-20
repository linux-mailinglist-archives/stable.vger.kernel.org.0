Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040B85517D1
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 13:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241489AbiFTLwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 07:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbiFTLwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 07:52:39 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E168C175A3
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 04:52:38 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A64415C0162;
        Mon, 20 Jun 2022 07:52:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 20 Jun 2022 07:52:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1655725955; x=1655812355; bh=14aCWnmW5W
        gyBoGsQlECGP8Y4g9NvnxiXP8IyPaHbjI=; b=Ur9czDayzJror6mGt5qgasWLVP
        ZmbZe8KOrfifrNnXzbOBXXmHU6kmRm29xXhxbVdgkg728GuyP0lfyj0MXe4SpsjE
        V8NgLCxRy11Z9NZ3netum89IOMQYmDNI5i4RtVyc/SEyVo1pdOs4BryTK4ffWjWT
        EMa/vLk2x9qcNc8+Db3JLOq8+snTBOELb+4OE/NqU4lxHsPf2EjwRph43kOOARyz
        5wHm/QtTSnh6jnmB62AadThgFi8Ydu0hyC02PIGYMhFiymt4OwUyU80X1ykupMNP
        WMw2snp1fq+1m2x04Yd5o+G0o5UI+3h7cGmpqn+LDVI8zwXuPbnXch6Czo2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1655725955; x=1655812355; bh=14aCWnmW5WgyBoGsQlECGP8Y4g9N
        vnxiXP8IyPaHbjI=; b=AJxxHiSmuCQAatRtxGKhA6Jzlb2Q456IPYSt6VNmqGti
        LquvbV6NNtoEGcWr4dwXqpnozVarzvGclkKmjyZWqry0gzTJgbdig0npER0REPLZ
        lylYKzVufDPcLsUiObYVI3bB/6eYE91jMXI0RV2JImkKZcl9cv5rBAPm2i/2nEbV
        thnyXCZ67Fa9WMXqs4ik2K4J2IKah7ubItM5d1bd9lpo9G5IspkWul1yqx+Da/lZ
        vuORHh5zUdMv6p1xKZ1KpcCwMkb8kFQq7KLn9RoZAwGJc1E3JPpqRMZJzGHE5LQH
        AMtESi7J55sBkMxIytr+EmPDNhKY+iRegJWryee+tg==
X-ME-Sender: <xms:g1-wYoK2-4J9L_7BdHa0RJBQd82945JOMTHpFKkpDY9aL-pje_xhZQ>
    <xme:g1-wYoKd8y7uJ703JRcEH61bTv4oFl9xS38TF20MLNca0A8wennsMZCgBDlsqDj0_
    pubUoszgs4E3w>
X-ME-Received: <xmr:g1-wYos0dcQt4ABFX6tYW7e5xx2ifRsYWh_6YSWok6DTV8fxH6PwMPzlJa5_Oqrg7ECb2Mi4ctlR0Y1HUILQXsyrJGAlzT5o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudefuddggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:g1-wYlatIzIfkP_ccJJsHALpxZ8dO6xcdmEBt_X4lMW1HHfDklkgcA>
    <xmx:g1-wYvbVdwIcX8cLfk_nRcWno7OPJZuLFPGkBTjwPcVYpHp-c5G8QQ>
    <xmx:g1-wYhC678pILi3iEJIrXY05rmhG6DecEDikcZoRuGN7N-Q_40nxwA>
    <xmx:g1-wYtNV1vJN5f3mz2_RrnD_7N4RGSvMghGQnpXiqIzbTf1r9PpGGg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 20 Jun 2022 07:52:34 -0400 (EDT)
Date:   Mon, 20 Jun 2022 13:52:32 +0200
From:   Greg KH <greg@kroah.com>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     stable@vger.kernel.org,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>,
        Aaron Conole <aconole@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.4] net: openvswitch: fix leak of nested actions
Message-ID: <YrBfgH3OTDpPU6hP@kroah.com>
References: <20220617155234.237994-1-i.maximets@ovn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617155234.237994-1-i.maximets@ovn.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 17, 2022 at 05:52:34PM +0200, Ilya Maximets wrote:
> commit 1f30fb9166d4f15a1aa19449b9da871fe0ed4796 upstream
> 
> [Backport for 5.4: Removed handling of OVS_ACTION_ATTR_DEC_TTL as it
>  doesn't exist in this version.  BUILD_BUG_ON condition adjusted
>  accordingly.]

Both now queued up, thanks.

greg k-h
