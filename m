Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1507E53CBAE
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 16:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245139AbiFCOlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 10:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245138AbiFCOle (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 10:41:34 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0252548E59;
        Fri,  3 Jun 2022 07:41:33 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 1B1BD32002F9;
        Fri,  3 Jun 2022 10:41:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 03 Jun 2022 10:41:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1654267289; x=1654353689; bh=bdf6OG8oFg
        5pHlwH19Dh8WKLl53MNJOfNyG8ctdsTPE=; b=IRzI1rPr6whBdIr4f0KDz5ySgi
        61E6CobQ6wtp/ALq+hKXOs3Z3gmveqRd9eCo6G8YXEjcv7FTyduDPFWugrX7vFqR
        Lx8NeiNCo9nVtBRkvctl5VEmYmEtMEAuA3G5nzwA4C766x1ynBOrnLw9tlG0MQ48
        CSF9Y07A20TMNnouD9dMgKBzUrj0F+1JjGGeptJb4mCFyNBNyDSEztqU3E2uz7h7
        0WvDG98dWCPHu2euSjcEscdXa5m5Uw4dfDyO58a9fvHcvoYqGyAeUMFjA4PU/J3Z
        ufoOEEhaglzUFXFCdzoMrXwG/LSGzhJOWxEWgSTeI7AhR4D6A5xNc9xJbn+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1654267289; x=1654353689; bh=bdf6OG8oFg5pHlwH19Dh8WKLl53M
        NJOfNyG8ctdsTPE=; b=qkkmEqlP9gly5Q/6/GTas1xz5w2pLrlXYrBDqofuGTHc
        DytNF5JR88bbrp/wxmh4TRhokUPWvhxl0WoH2BSvb6tnmQyWi9U+/vcWXp+LltdO
        5orrp4PTpKwhrEL2/LL5ecOMHxrU5ohxcAaGT52XhMTiTQFMsr18TO8H2tjX7sHs
        +HJRchymTQ8r7oN6XpLZEK4in5YCnvryW95mODDHBXTKMRENe0PHfh3b0tXp+Yg9
        VpTevF/9qcWnadCTZoKRawgP9/ctY8vChTBy44Gk9qdrfqPpZc/blt4MzFxFiwmz
        twC9w0R24quSp1VvnW5W4CVa1oAurt0NB8n29O6rSw==
X-ME-Sender: <xms:mB2aYnRqFiONT56wPlEps55qr7nSOw4f6CExJyWWejU65jZachJYmw>
    <xme:mB2aYoynFRfDKSMnqL63Z5Ub0uD_nzJwaEdWMqCRZd8saW494U0kPj4CfcNd2ugW3
    ddwZZv2OA6nEw>
X-ME-Received: <xmr:mB2aYs12MB3d-ivPgqkpXyFW7tJn6acOICiS6PkO3Qll_D0vCccQTr9DOqTPC4FVACmU9pJ9j57lVIF4dMR4-nHH89dBZjen>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrleeigdejjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeejhfelff
    ejkeejheetgfeigeekueeuuddvveekjeekueeggfdvhfefteelgefgvdenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:mB2aYnAvPoi_6SzwgLfr6RRS1LObp-nQ3_LFuARIT0uefuq_zjBOEQ>
    <xmx:mB2aYgiXnPhQb0TXjwjpRTibBSvk-eE4N6dZZupmuqWRt8wshKQqUg>
    <xmx:mB2aYroapDY1r3p7hJy2itf2eZQSF6nnv3GJcn-pmSteZgKEQGaLdA>
    <xmx:mR2aYpWszrYW25vfK1QZ1W2UiAyAmirlfO_IsDBuvchQulxZ6MVWOg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Jun 2022 10:41:28 -0400 (EDT)
Date:   Fri, 3 Jun 2022 16:41:26 +0200
From:   Greg KH <greg@kroah.com>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: exfat: check if cluster num is valid
Message-ID: <YpodliEhKuIPEowh@kroah.com>
References: <b6ca08bb-2275-ab66-1a78-d4ac9e87057c@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6ca08bb-2275-ab66-1a78-d4ac9e87057c@linaro.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 31, 2022 at 08:53:40AM -0700, Tadeusz Struk wrote:
> Hi,
> Please apply upstream commit: 64ba4b15e5c0 ("exfat: check if cluster num is valid")
> to stable 5.18.y and 5.17.y
> Backports for 5.15.y and 5.10.y will follow soon.

All now queued up, thanks.

greg k-h
