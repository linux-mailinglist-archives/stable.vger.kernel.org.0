Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB021557ED2
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 17:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbiFWPqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 11:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiFWPqF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 11:46:05 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5791336B6A
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 08:46:04 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id BD8085C0135;
        Thu, 23 Jun 2022 11:46:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 23 Jun 2022 11:46:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1655999163; x=1656085563; bh=fcPvyP/Dn4
        OiJdp2A6xYRC/c+cl4MTmz3QIPRt5hqCA=; b=HAO5ktOz12ICiJUWvjK/RLHqvX
        QBq8CBtG06LkOZ/+KDaPm+c4gS48pEFIW+lBCvJ6Pp8wwV45wA6CW1jXU3puzNft
        b98uYtUkX1+xZ+JTQCItjSd9/dW9nhYD1bqyksIb2K+/VI0LQzzkcY8z1Bc39NE+
        YBz/K615XaGWcXnv+yxH6Sb6wfjAjpcO3C+lgYWK2nnP2ZCKgjAA98kH2XHFKBzw
        w9w+0AqNwj99WnysyBmDtNKKfBC+FRfVDqqNlZr0iXYmNRKFFo27qUInUFoFYCOF
        UuwG5lvU02bSd/j/C4FBzDpaYwmFUT8Ts3B/qppJIekyLGJ/PUAy7b2KPzGA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1655999163; x=1656085563; bh=fcPvyP/Dn4OiJdp2A6xYRC/c+cl4
        MTmz3QIPRt5hqCA=; b=a7nqzDJsc9CRB83KgBOGZ35tcfsuNm889dnyjJ9u/0TQ
        jeKjdCq0aMTByQx6P5mWm8j7yEzgM3w95QFLeNRRy9aK9YwMvjORRZWGRJt7LzCA
        YzeC5J6sru99F8GIdd5uMc/9itWjNas+nVHYneWoowInZmJe6SefhdxbtkteWbs1
        HB0zhLp7KTy5YCoC91A+M1WFSR+c1PVBdSZXRI/rf1OKlkLA4w+QxSdC89oCrAJd
        +W4V1YGNOORqs+lGFNokYC9IjN9sdwIVZffijPILBG/5lJW8SG1eSjG39GHqlbpt
        JfjK90v3gPgSoKavfphqN6TZrBr/2hWRPeQ6jDV6lg==
X-ME-Sender: <xms:u4q0Yn7wzOHHz_Ky6_fMcDGd7_Sw6iLtNbgRy5PBPXtyzfeodw09Mw>
    <xme:u4q0Ys61cYSGATBfyP6WZ3rnM7dUOkCW7HclYYWA-Er75VUJSO5G6q7yn_WSY152K
    4htEcodrOMWEg>
X-ME-Received: <xmr:u4q0YufUCcOQp_UPgnWds63N_1m8aRrRyj924eB53M1f5yONojIYZL1Fm9vmUOnBnrBhXjnBFfFW7oY00aHUhKonbstz_s5_>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudefjedgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhephefffe
    fggfdvvdekfffhgfeljeehfffhleehleejffffveeuueduhefgveeukeejnecuffhomhgr
    ihhnpehlrghunhgthhhprggurdhnvghtnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:u4q0YoKcTrwCL0306T4N0OHjeWSd1PWc0CVzCrp2MPU_llWPCvjDcg>
    <xmx:u4q0YrIzMQ7wFa-mKQd7fPKi2Q2VScwCd_8gZKZpLz2lHTrLelnEEQ>
    <xmx:u4q0YhyLY8ScxN3E-Wye4jyM7GQORHsmAewDg6jrMdZMCdfmlEiQOw>
    <xmx:u4q0YiVF-CZwS6EXPK5u69I7AiovuVQbiiNwz5-hF17tsrbdWZQcrw>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Jun 2022 11:46:03 -0400 (EDT)
Date:   Thu, 23 Jun 2022 17:46:01 +0200
From:   Greg KH <greg@kroah.com>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Display corruption on resume
Message-ID: <YrSKuU/G82yCVBnA@kroah.com>
References: <MN0PR12MB6101E7031A343ABD977D723DE2B29@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB6101E7031A343ABD977D723DE2B29@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 22, 2022 at 07:49:46PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> Can you please backport this commit to 5.15.y?
> 
> commit 79d6b9351f086e0f914a26915d96ab52286ec46c ("drm/amd/display: Don't reinitialize DMCUB on s0ix resume")
> 
> It fixes display corruption that was found during s0ix resume on Ryzen 6000.
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1978244

Now queued up, thanks.

greg k-h
