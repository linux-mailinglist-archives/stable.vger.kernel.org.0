Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268796AB6D9
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 08:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjCFHSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 02:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCFHSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 02:18:04 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E50383C8
        for <stable@vger.kernel.org>; Sun,  5 Mar 2023 23:18:03 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id D6F523200946;
        Mon,  6 Mar 2023 02:18:00 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 06 Mar 2023 02:18:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1678087080; x=1678173480; bh=Eo
        +njv5prXqIvtdbMSHJOlQbRIt1zn2AkCCO9y29ALE=; b=TAE+hZcNvMT9GUMGW7
        i6XSF/4VtbnAimj9guwplhKn48t36w4kv2q2vrAjea/o1lW+vp6bkzjj8zc2fK3L
        Qy0iGjv1ojaVmJuJWMjdYQPM3RqQ/cG7S9oyQeHzgQAEclMbVyYuaxJVcavJM2qE
        cEn/fK/ZCIKek2Kn8JDcv6h1KAIGH51DDIsB0ioQm7NrU7XMTtBbKSXjJuVOhNFP
        XF4hBhIQCy/zAsh0xdyXr2aKUKeVGTTWdIhGW8BJ4h5BnYrI6UukJhAvjsvLJWtJ
        DhN9247doYHqUdt3Kmvs1hUIQjSew4ZxZkd3NyEcYPOqDXrpvIHaBXDe/kfGNXkJ
        bxjg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1678087080; x=1678173480; bh=Eo+njv5prXqIv
        tdbMSHJOlQbRIt1zn2AkCCO9y29ALE=; b=s9VeifxfnExtQdcS8yC8ccy/ALE5h
        Ru4jucjoc/3cRhZovjOovar/5HCMNrQenwv287gbWeTL9u8WI3iNAQP1WgbVOLdd
        JTIFup/PsadoVn+nQ+mH0Knk1C0TjfPvJlBHP0IcDkEslWHrHYCfq9XKNzYQ+5an
        h49wtN9ZZirlnF+eR/eswLS5VOdtsgrqRSSmbkdzq8x1QGfpAMZnpWkdJ5tLx30t
        o4ibRjYxa/LRF3y4mP8/MqdU1yZGRfUjwT9v9qeOQKR6uM91ZoNqi0j94gM98umF
        PL0eJUVWgIRYM1aQxbmYA3K9Qe1MwL9Ziw4kBALSKrlx34In/HHLjb/8A==
X-ME-Sender: <xms:qJMFZIyzlwC-LEq5GJZFRp7LkcR8Mn1zGizYWShcvcUfN4CC_N3anw>
    <xme:qJMFZMRW7cA7oonqaIhTyVH53IguF7LC60CKf5un9T4AQJounRcCwpzSqfpM2NT3x
    wUfJaQYFLR3vQ>
X-ME-Received: <xmr:qJMFZKVhEk1FlbPkco_pShIdlVEz0Yrm3mfbGyyuxSRhgr8ZedfkDzYKS04vlGJI-I8RcwKkc7OCU34CkHwlay0U-HKGBWWOMIAyNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddthedguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehge
    dvvedvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:qJMFZGg9jbPuZVNxoQJyTf1ziS0M8mjf9XGz3SzG2yyQemOflt-tWA>
    <xmx:qJMFZKBZcmDwKA5uSRAv-UgOiv1-OCPzKJ1Sr6PGVReMAy6ugEpRxA>
    <xmx:qJMFZHKFnK0galrLKruptMXwZytezGYh6YAQ_ciTqHVTkPOS5-nmvg>
    <xmx:qJMFZNP6UoU2hCEEksdao-FPpBuYWW7pJrAtZ7Xe1V2oJNC87z4Jtg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Mar 2023 02:17:59 -0500 (EST)
Date:   Mon, 6 Mar 2023 08:17:56 +0100
From:   Greg KH <greg@kroah.com>
To:     Jun ASAKA <JunASAKA@zzy040330.moe>
Cc:     stable@vger.kernel.org
Subject: Re: wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
Message-ID: <ZAWTpNHkt13tK4+M@kroah.com>
References: <91a734dd-a12f-54b8-0092-1da2e03e820d@zzy040330.moe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91a734dd-a12f-54b8-0092-1da2e03e820d@zzy040330.moe>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 05, 2023 at 01:34:02PM +0800, Jun ASAKA wrote:
> commit c6015bf3ff1ffb3caa27eb913797438a0fc634a0 upstream.
> 
> Fixing transmission failure which results in
> "authentication with ... timed out". This can be
> fixed by disable the REG_TXPAUSE.
> 
> This patche should be applied to all kernel versions since the problem
> seemed to be existed since version 4.9.x.
> 
> Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>

now queued up, thanks.

greg k-h
