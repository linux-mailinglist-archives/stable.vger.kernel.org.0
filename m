Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6116A6237A3
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 00:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiKIXph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 18:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKIXpg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 18:45:36 -0500
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9892654B
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 15:45:35 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id D051E320098F;
        Wed,  9 Nov 2022 18:45:34 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 09 Nov 2022 18:45:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tyhicks.com; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1668037534; x=1668123934; bh=EKbvm6lXWN
        WG0tnKNgWaxRY/vxfnNA6gcaiiYQn/rPQ=; b=aP+8Kth39y9GVNx0NL8YMv8q0R
        OtxW9l/rQUc3xaEFBMAS+G+7gyK37ynlUTg04J8qjX4sb7sZIQj5YN/9AXwWIE0U
        B3jwxRDEoqRuJagO9InhpJM369LNadrTzWJhdX40ZXjQYkTiBiGPJkdURF48fJW6
        EEq4/noYY7p1+p4daEXU/JjH61ZNObvERGfXjc/ruxu8OlTsuZKyOykQ5JpmTN0f
        JqFYdmj0uGcpuzQw6ULT1qL6JgOta/Yjch32Wx2W/SWYLvK8gRuWiekLwc1hSEhQ
        mVmqHZkbsdp7smUrMfFelA5OKDUb7feXaClK52Ggcu/4VQ5GTOlZ6Q0q448g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1668037534; x=1668123934; bh=EKbvm6lXWNWG0tnKNgWaxRY/vxfn
        NA6gcaiiYQn/rPQ=; b=oOgHFuKxb4Ct7H56DN/S5jNPERh8Lfo41yefjl3cEaSP
        5ZrXQaAYGhzgzuwX6sV5gLGDqpyMOqbrK0CwW/QeB+JmYSxGEqv6AtK8ziFvSsAR
        Drialyg5BF29w86J7GBpyGb5ElKXqUb1rs8gC1fapO5KcW/0Aha735bG48sLrkdp
        j18kVJlM/5ChWbBUJHO+m/JT5yTcq+y1DfX6A9hheg2FG1t9EAMdv5O9G2oOuwjC
        M7CPtzm7zMpfqPpej4bglp5D7oTkBvwzNqg0X7jWnOTqPOOO0gmezEEi5ITOjKch
        uaQhfNA73zZYV8dzTl/q3dimR57/UX61JvTTMW+3bA==
X-ME-Sender: <xms:nTtsYxp_4WIDiEESB-ErwSI2cr4YpshddIouCkCTXTDnW51PM49MMA>
    <xme:nTtsYzqWIrKQIARbyIHj8iagK-nfWalwQzQK1iXj2D-YQKR0qiLACmhcCqygHGjxo
    jnFtSgsUeV4r2-SXgI>
X-ME-Received: <xmr:nTtsY-Nqiqw9pSmV3dtsawMZZIsrdLaf3_zzuPtlDyRQ-leDvEpPERJ6fDM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfeefgddufecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpedfvfihlhgv
    rhcujfhitghkshculdfoihgtrhhoshhofhhtmddfuceotghouggvsehthihhihgtkhhsrd
    gtohhmqeenucggtffrrghtthgvrhhnpeevfedvieegtdduhfehtdfgleefueeukeehhfeu
    fefgudekjedvtdffjedvjedtffenucffohhmrghinhepkhhrohgrhhdrtghomhenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegtohguvgesthih
    hhhitghkshdrtghomh
X-ME-Proxy: <xmx:nTtsY87gHnuDM-K1uA02MlvJq_Pv_5alU5j6VCNSoteD5OgUAXWbag>
    <xmx:nTtsYw6QSkjij4boRvm7tXZMmUNXlxSFUO_DAjubT6u193aCJNvqug>
    <xmx:nTtsY0iG-jYcvZwIhdaY6Nam1Tz4I6ty2VyPzS9m4gbEOUx_TQWnpw>
    <xmx:njtsY6TYN97yWc2va4V19ELa3l3daLFCXVdG6vS-KAOrEW0I2M0ZVA>
Feedback-ID: i78e14604:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Nov 2022 18:45:33 -0500 (EST)
Date:   Wed, 9 Nov 2022 17:45:26 -0600
From:   "Tyler Hicks (Microsoft)" <code@tyhicks.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Suleiman Souhlal <suleiman@google.com>, sashal@kernel.org,
        Sangwhan Moon <sxm@google.com>, stable@vger.kernel.org,
        Kelsey Steele <kelseysteele@linux.microsoft.com>,
        Allen Pais <stable.kernel.dev@gmail.com>
Subject: Re: LTS 5.15 EOL Date
Message-ID: <20221109234526.r5raofrnzddggarw@sequoia>
References: <CABCjUKBwLuTWE7A4PkNvRZx=6jeu3QjsFZq5iWZAKnmPYWKLog@mail.gmail.com>
 <Y1EGHnKcWzKv6t99@kroah.com>
 <20221028194019.vda2ei2nsqsysvby@sequoia>
 <Y1zIJw0RNGtQ3XgQ@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1zIJw0RNGtQ3XgQ@kroah.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-10-29 08:28:55, gregkh@linuxfoundation.org wrote:
> On Fri, Oct 28, 2022 at 02:40:19PM -0500, Tyler Hicks (Microsoft) wrote:
> > On 2022-10-20 10:26:06, gregkh@linuxfoundation.org wrote:
> > > On Thu, Oct 20, 2022 at 08:25:35AM +0900, Suleiman Souhlal wrote:
> > > > Hello,
> > > > 
> > > > I saw that the projected EOL of LTS 5.15 is Oct 2023.
> > > > How likely is it that the date will be extended? I'm guessing it's
> > > > pretty likely, given that Android uses it.
> > > 
> > > Android is the only user that has talked to me about this kernel
> > > version so far.  Please see:
> > > 	http://kroah.com/log/blog/2021/02/03/helping-out-with-lts-kernel-releases/
> > > for what I require in order to keep an LTS kernel going longer than 2
> > > years.
> > 
> > Microsoft is also interested in a longer lifetime for v5.15 LTS. An
> > additional year should meet our needs.
> 
> Wonderful, thanks for letting us know.
> 
> > We are aware of your "Helping Out ..." blog post and have been making
> > improvements to be of more assistance. Kelsey and Allen (Cc'ed) have
> > been doing -rc testing of v5.15 -rc releases and reporting the results
> > to the list, on behalf of Microsoft. Testing of the -rc releases is
> > mostly manual at this point, so we don't get every release tested before
> > the release happens, but we're working on improving our processes and
> > having builds/tests kick off automatically so that you can rely on us
> > even more. We should have a much better system in place to help with
> > testing and reporting by the time Oct 2023 rolls around. :)
> 
> Don't you all use kernelci already?  Doesn't that fit into your testing
> environment already to make this easier?

You're right that we provide kernelci resources for the broader
community but we use something different internally.

> 
> And yes, I have seen the testing results, thank you for that.  If you
> all want to be added to the initial -rc1 email announcement to help
> trigger any build systems that way, just let me know.

Thanks. I had planned to watch for new pushes to the linux-stable-rc.git
branches. If that doesn't work for some reason, we'll take you up on the
email offer.

Tyler

> thanks,
> 
> greg k-h
