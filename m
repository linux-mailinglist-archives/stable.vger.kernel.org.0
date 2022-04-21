Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B896F509D04
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 12:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347487AbiDUKDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 06:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245368AbiDUKDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 06:03:51 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13987DE9B
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 03:01:01 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 59BDB5C012E;
        Thu, 21 Apr 2022 06:01:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 21 Apr 2022 06:01:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1650535260; x=1650621660; bh=YXfTIWXSJt
        S362gSEac1hGRXW1GVnfEWuWuRjjMSJAQ=; b=EHgMwLK0k/EfLhuv5Prb8TDGBV
        pN057wpRyC0O5yHyZB0k61GeNL57oVHl1n9eEX1CDZyIpV49NTbvSNvK//0+BvgE
        WeG/TDNmmu9EHAvDPCLA6LT4xzISAsGYg+g49Jpc57eiuf3LTl1qUgYFB/j5jm9O
        wSiBU6Q6pohg3pm+WSCoZs86tfjNJjRsQMmhvONrl4tPabHH486MYiQnyS6dBBMi
        3v1fOWtjSUr5BJWqOEaglX/EtQjSdagIGn3DlXgBpwd0exm1zLI+D5JGVu8pkN7b
        6xyvEhBuS3rhAnJL8zHvMjb91E6/7ZHrgsGRQm1cUJSkC7jYDwMHag0a81Qw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1650535260; x=
        1650621660; bh=YXfTIWXSJtS362gSEac1hGRXW1GVnfEWuWuRjjMSJAQ=; b=o
        E+40vsO1ZFoD7ZBs+QLB/O4oINex1uMmddw66f13/1wNzUddBaj7OJ/jwiI6bFqv
        qFuDC7y+WmOn6L8SmRIWIjLc3Mm3bIRJ7HA1+FT9JVwT6Yjv1vBAoPZ40Psy/UrL
        yDtAGrfb7MzRBYYeBTr1hvnY2TBG4ZbdSqjr/JcI7Mwp26O4Qc4W0pQdOD2TF2QE
        LmebJMw7B3+V6J7MLasZuF6HRWX3w9birvQsZFqdwCx73yeIhnqdU2/1ADz7bNR5
        X2F6npLwyAMkGjVVS7R6BIYw6wfQvsV5ifQEsMdVVdwvqLQ5lzXIrWNLTipBFOjA
        67HtN4m1JLkhs7CYT/NAA==
X-ME-Sender: <xms:XCthYrWlxR4zntgP6TObf9v-4BJpDlN0wHmH0sx5nz0b8N9ab8mmYw>
    <xme:XCthYjlI2q00EJU4BPJ3qA_pybRwx_NX8fmVQ9tqB6TkACtGGSifAfeFgpg0XUp1t
    UhsRFyEQnYHlg>
X-ME-Received: <xmr:XCthYnZOwBzTD-9SuNwvNWNYsEYCfeXpIjaBHzSTMsOVEwTX6vXIfEV0nRXENEOfGU8-Iv2dPQT1qFvvXOgAAox1ErtryNBG>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrtddvgddvvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehffefgf
    fgvddvkeffhffgleejheffhfelheeljeffffevueeuudehgfevueekjeenucffohhmrghi
    nheplhgruhhntghhphgrugdrnhgvthenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:XCthYmXYCvI7hg6LuYU1SVnmJnHg065NiJWPELE4N_BWXg5HqLXOow>
    <xmx:XCthYlmlaBzCGLg5WjlELoERCsjnR8YtIdB0PZFg-FB9iUAZs5ZEAw>
    <xmx:XCthYjf5Djp-XfelHF0DzAKfwbLF4Xn2eak-_BWpFNypZNHBgZzQNw>
    <xmx:XCthYuBTYZKjprMjJeo1PHzFa11E2YSjMtba881VH0KLTGhqXcMzMw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 21 Apr 2022 06:00:59 -0400 (EDT)
Date:   Thu, 21 Apr 2022 12:00:57 +0200
From:   Greg KH <greg@kroah.com>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Gong, Richard" <Richard.Gong@amd.com>
Subject: Re: amdgpu PSR problem in 5.17.y
Message-ID: <YmErWVUXPO/Ofb3t@kroah.com>
References: <BL1PR12MB515719844E774D18A381A2D3E2F29@BL1PR12MB5157.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB515719844E774D18A381A2D3E2F29@BL1PR12MB5157.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 19, 2022 at 02:43:41AM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> Can you please bring
> commit 1210b17dd4ece454d68a9283f391e3b036aeb010 ("drm/amd/display: Only set PSR version when valid")
> to 5.17.y+
> 
> This fixes a hang in certain GPU firmware on select panels.
> 
> You can also add to the commit log:
> Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1969407

Now queued up, thanks.

greg k-h
