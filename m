Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACACF641DB9
	for <lists+stable@lfdr.de>; Sun,  4 Dec 2022 16:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiLDPym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 10:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiLDPyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 10:54:41 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8D913D79
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 07:54:40 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 551D55C007E;
        Sun,  4 Dec 2022 10:54:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 04 Dec 2022 10:54:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1670169280; x=1670255680; bh=UE9m3PWEe+
        CVe9HjDgvY6bANTaM74yCy26F4CCzcoJI=; b=hoH9FYLxWm8xfIFD4/RtjW1IIb
        tiL2kwKsfuM4xVwmvCtl1MUEhYmUhOBixzY1P8bLS5WV0FnTiIlE6PDrfR6nMT9s
        z8TkKcTLlj3vZA7mvYcJHAjgCMPyfGDm14qIAM7wpUB2NXJ81i9XoNKFggzWYff3
        fgsZwU6qWWyEcr7ID8MhOrExv220SHN3JFCd7yldhlTLlM6u6+hQH8ZPXL1/0SFY
        gqWTDZPRizu03Gwv8SEqmrlYaFEqU5aWAlJSEljzgFgqcbzk+Zl7b3CSxCC5U0hE
        TqXHrFpjCdSSus/yDZNs1kh217+Mg3pSx7kETsA+i+P1VQg1I+fLnrYH2H1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1670169280; x=1670255680; bh=UE9m3PWEe+CVe9HjDgvY6bANTaM7
        4yCy26F4CCzcoJI=; b=JxP4Oz7iQKKQfmjy46XKv4AAwyRd+aENFkJdK3xHKxCb
        P249AVLRb4JH4y0enRnq7nywQ8UtcosEistyLq0gIzAwPJ4fk9NFJqm8OBVqZNNH
        6sLwd5QL8XjIWT/rhmFfIn4tWjkak0AigFU/p0La59s4JAYPXaqnW8vLWqM9Db/5
        ENDzlc3ycY2SWA8yRgeSSXS13pELXPN+orz72BerVdoyKDpx9FIDvYMukPtwh9dJ
        qleE5srq+JAwvsLdKdLA7Ucje1MF5WmNBf+4IqkhXLRTXeLz2fVnPfridzAbp/u8
        CV4qMu8Cleph+Q3I7mMmw5BtpdB9/KU+LF/OV/k0Ew==
X-ME-Sender: <xms:v8KMY9kmNsEWTwqB_YmC2MB90A1FQxFGm1WYd0wcZQ1jpH0vGSGFew>
    <xme:v8KMY42c9zDRR3OYwokjc2xItF4dpwjAaWXctgFXiCcHye7Halb3-XX4hnRIVi8kg
    qADGEz6fG8OGg>
X-ME-Received: <xmr:v8KMYzqucN8zD1NuSFyADFTvebagZ9AWMu613c3f8V5yQ0MsE5qYY7X-FOErB084_wGjDg7-kqKlpFNeXyqbXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddvgdekvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:v8KMY9m23Y3r3cvN8Rp2Zu5z97J24sE-2NTv4j3dg-QJO2anv-eOOQ>
    <xmx:v8KMY72U_ZMWkylgm4azac9ZlObGXdHP9LWgmOwLkS1nwjdcsXFEtA>
    <xmx:v8KMY8u-vFsR8OQfdVp1xMO7OQNpDsV9DqcLLTXVWlV_1LxCSenk3g>
    <xmx:wMKMY1r0ziDAiO7IwdBB028p77su_Cy8x-ECW6IyUfXSryHW3k7uiw>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 4 Dec 2022 10:54:39 -0500 (EST)
Date:   Sun, 4 Dec 2022 16:54:37 +0100
From:   Greg KH <greg@kroah.com>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5.4 1/2] nvme: restrict management ioctls to admin
Message-ID: <Y4zCvUBSHzOqku1E@kroah.com>
References: <20221128095847.2555579-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128095847.2555579-1-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 28, 2022 at 11:58:46AM +0200, Ovidiu Panait wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> commit 23e085b2dead13b51fe86d27069895b740f749c0 upstream.
> 
> The passthrough commands already have this restriction, but the other
> operations do not. Require the same capabilities for all users as all of
> these operations, which include resets and rescans, can be disruptive.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
> These backports are for CVE-2022-3169.

All now queued up, thanks.

greg k-h
