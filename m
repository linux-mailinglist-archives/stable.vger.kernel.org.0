Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15463644319
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 13:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbiLFM10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 07:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiLFM1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 07:27:25 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AE826486
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 04:27:22 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B230A5C00B4;
        Tue,  6 Dec 2022 07:27:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 06 Dec 2022 07:27:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1670329639; x=1670416039; bh=hdVlZicn27
        i4ziJlCRc/A2DQTg1fuWDJIOQBeNIaPN4=; b=EGpYTvZvtY3diUlYu8bQNSIYnT
        +j0k1uNSvKhswsq/Izf44+/QEwbtGWs/vrXMLQsI+iqcSHPjd+0YAeGgj+zH2NHw
        +tCBQ/9P3OWjT+VCK1J/z1zBv7NpbtvSSfmhbRpiaeY4kjy2UrYGw145/8xshd/p
        OyUze8rRlwB0KUKDKa8VJeX6e/QaOb42KhM7q4drOnL1gewyFPC8DmMn+v5kbyFJ
        sZOCmR1FVX4RXRBGWToFOoUrTAbQkneY1N4d1xcNN192C/IlLhcdltLTSJkoici4
        Domo3/LWtTKBUfb9iMdqfQBTwVVhDcTT+o34TGmxeuLkvQVsAZYOAGkd6dvQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1670329639; x=1670416039; bh=hdVlZicn27i4ziJlCRc/A2DQTg1f
        uWDJIOQBeNIaPN4=; b=tSOEyN5K2aWOMhgerWsH0AInJB/VLmaIoXfOAoOELDpu
        Ao4xRhZDQZI3P0pFhdI+SeHPE1sonA2zGGU00Cs1lGb7wKveWm0m3fSPnxStRkcM
        k88sqdXsdQWVizmweubhho+2k7xREfQK1zVNTasEfzdaOicNjxZUVkuCzj6rFssw
        XNYO+LFbpDY7Emx3GV0WoDGB4HogQp3FA17l6WG4txRg+B8rbqdcchrq3SIpZ5e+
        cPKr9nnzM412pPKwpX5sAThd/mSD42495HKMLJG6SAEpMScSKTNmUl2mM4M+cnx0
        vNWiFqDIkmNB3De3qeIuR5C3b6v+CY1ixLPrM6TOOQ==
X-ME-Sender: <xms:JjWPY6liUxn__yFs88xscGfaQOOx7d29zu3IFrLbOAKNEFxq8BMeYg>
    <xme:JjWPYx305nz-Fb9hntTgY02cEB84rhEumyNTaiw25E3MX_g8I3ErLhCNWNYbJrVLn
    JsnCdeS6cEPww>
X-ME-Received: <xmr:JjWPY4pWxNUMarXLlDlGPCb1e-Z1CfZkLYQnQTWn4b6a1S0zAGcMKWIEIEeuszaTHMlsIv_ysTqf1RABEVAsYw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeigdeflecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:JjWPY-lAdCKAnSU0e10uSUFGjVd2VRAKQgeNjzCYahhvxiVnLuBH8g>
    <xmx:JjWPY4294D46muw4NqglpLfLJ9Aw--dkQ3E2hxjGO_xDGrMZOO_Irg>
    <xmx:JjWPY1v_3zRMaY4_HRwLtA1je0fLRFyQaDj5amgxdMpQWH6hrGkjIw>
    <xmx:JzWPY-Pomn7-ykcqfZGSzmQPy0OxaiqNLU3-2febs79tubVgMVMXzA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Dec 2022 07:27:18 -0500 (EST)
Date:   Tue, 6 Dec 2022 13:27:17 +0100
From:   Greg KH <greg@kroah.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 4.19] Revert "x86/speculation: Change FILL_RETURN_BUFFER
 to work with objtool"
Message-ID: <Y481JfkDZAac/6CF@kroah.com>
References: <Y45jLPqv/0fJ+rmk@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y45jLPqv/0fJ+rmk@decadent.org.uk>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 05, 2022 at 10:31:24PM +0100, Ben Hutchings wrote:
> This reverts commit 9f3330d4930e034d84ee6561fbfb098433ff0ab9, which
> was commit 089dd8e53126ebaf506e2dc0bf89d652c36bfc12 upstream.
> 
> The necessary changes to objtool have not been backported to 4.19.
> Backporting this commit alone only added build warnings.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  arch/x86/include/asm/nospec-branch.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Now queued up, thanks.

greg k-h
