Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F1D6E2F62
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 08:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjDOGvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 02:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDOGu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 02:50:59 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DFD3C0F
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 23:50:59 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7C1715C00B0;
        Sat, 15 Apr 2023 02:50:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sat, 15 Apr 2023 02:50:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1681541458; x=1681627858; bh=BC
        ErmVLT+/8ZPh2ThmzdktPjkfx5AeGhjDelmV2f7iA=; b=14v95G4hTu6QEszpv5
        PDNFuatDjC7L0FCXvjfSp2Gx7J3RfYaBHA6ik6nlidL9ZQSSNqFzvLNboI/2LPQg
        hz4IzJjTwy0goxbSQqMOEYjUqIYCh1Jv/UnCH4tJSc8o2nvefaxQvoiYkbJH4/aN
        zevIg0mULvIBzIZVu8G9vRfQUx5JpOL1SVmWiHFXkaLoubkmOF5+8pe6S4Qh0u08
        NgEHO+R30H4k3nzMkQshJU67kEiItw2RWBF29j/UuQxGJMD96+b8VbkEbJzI421t
        B8xIdMZpiJiIHT1wl1onsqKAJrcWHxdrTggkfeRB0H/TwrUnlFih+gXxvc/W27/3
        +tvg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1681541458; x=1681627858; bh=BCErmVLT+/8ZP
        h2ThmzdktPjkfx5AeGhjDelmV2f7iA=; b=IfyRbdObkcTZiI7R+80LxW4Cttazo
        wGui0k6W45fFZUL66Esu96V/Udtw8MEK4vbHvZVv0czTARI/rAmESbtHjuDXq+I5
        dG6DcS5KTD1LI35D3p2RqisxPo4AszfZsibIkXzYdrS8C5suxrPh+tdWWtC54Voy
        85qqmXpkgNyf8hARJFYAR2tM3ubSBMluGG8DwUhiPJDOPUW/oumSPoEfyoO3e4cZ
        B0LF0zCjslVyMN7ZNyAd1oKcUBssOiHmxmu6Yum5Jgg+1w1FNkm3C7mUAeWvwdmn
        5nL5W5PQDifTeNoLsex3fQEkfjMXpWBmnYdsY2vxcli0hyj9zZUaeSjJg==
X-ME-Sender: <xms:Ukk6ZGGUgVArw6u1gZSm57wp_-efxApb42Hj-uiLk5XWJy5lK3craA>
    <xme:Ukk6ZHVv3eHabYFMD4L99804OivHgLFB_-SRjQmvjoOraGD0PGGi4QiEpCGVEi40g
    8aJqWpqgjjFFw>
X-ME-Received: <xmr:Ukk6ZALrp0qFWxPOFdHaz7TWkaXQcAFYVsb9-8Y_XT7eWSo-TA3up6owFfnec05nqNxLLgc5KqLulANzOTsmh9QuR9cn-Yv-sFllCg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeluddgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehge
    dvvedvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:Ukk6ZAFIXk0WEFNz40seXnMZ8Sl5QnHqmijfBF8GCtsEck0pO2uwKw>
    <xmx:Ukk6ZMVSBSELGnQqIgy_KMn87m9KaB2C-o8resdG_iq8EDXkmRldRQ>
    <xmx:Ukk6ZDPYI3zLHeI7j1gI8N0ERk4uSupfuwAYEzWIRdRah3KV3OUKGA>
    <xmx:Ukk6ZOLTcLsPcEQ1GNK7Z78QnfQbhNHiNHV4D3a2m6ImSCG1r4LflQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 15 Apr 2023 02:50:57 -0400 (EDT)
Date:   Sat, 15 Apr 2023 08:50:55 +0200
From:   Greg KH <greg@kroah.com>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     stable@vger.kernel.org,
        Veronika Schwan <veronika@pisquaredover6.de>, Jerry.Zuo@amd.com
Subject: Re: [PATCH 6.2 6.1 0/1] Fix regression in 6.2.10
Message-ID: <2023041546-obscurity-ferris-52d7@gregkh>
References: <20230414195634.1845-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414195634.1845-1-mario.limonciello@amd.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 14, 2023 at 02:56:33PM -0500, Mario Limonciello wrote:
> Veronika Schwan reported an MST regression introduced in 6.2.10 by
> a backport of commit d7b5638bd337 ("drm/amd/display: Take FEC Overhead
> into Timeslot Calculation") into stable.
> 
> This fix was actually correct, but there was a related fix that should
> have come back as well. This is a backport of that fix for 6.2.y
> and 6.1.y.
> 
> Due to another code change, it's not a straight backport, but it's just
> a one line change from context that changed in other patches.
> Wayne Lin (1):
>   drm/amd/display: Pass the right info to drm_dp_remove_payload
> 
>  .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 57 ++++++++++++++++---
>  1 file changed, 50 insertions(+), 7 deletions(-)
> 
> -- 
> 2.34.1
> 

Now queued up, thanks.

greg k-h
