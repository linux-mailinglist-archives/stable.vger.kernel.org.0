Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47684FB530
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 09:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235800AbiDKHtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 03:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiDKHtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 03:49:16 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3073123140
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 00:47:03 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 76172320206D;
        Mon, 11 Apr 2022 03:47:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 11 Apr 2022 03:47:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1649663222; x=1649749622; bh=e40RzIBLrK
        M4rP8dZqOYryDou0XxFcbo6P5l3XSjBBU=; b=EI34QiFjO72QS65NZMs6Nqefgi
        GuQsU3hd/vndf9zMQo2tNDK21Ie/Es/dJ8GJCh6MOrC9fNPy0rAXPCQvDWZN2axC
        z1KTWFEbbpeKGDko9qx+KilX1wqeivjiCvgqmduV1si+UTJVGLUUxfFcz7LZrJW2
        9UBEBgyFS6u+LJ/AzfEt1i/hVBIhdMi4KZ8P33TD+nb5c3HS1kTT56NhIFmObCcZ
        3ZwRzhYxT5Lhpy2Uq2Y32eAwEW82ZCcJ4f9/xIivTWALilKQikHJgIBRUbuerNsQ
        yha0UXJxZnqIecQ7WbQiSOnmyt4FoyRPaVE2UD8hPiffLH3iDL/UgaRIdy/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1649663222; x=
        1649749622; bh=e40RzIBLrKM4rP8dZqOYryDou0XxFcbo6P5l3XSjBBU=; b=Z
        NoTvyKAAaCZJYlOW7pB4YkKiO7EtBMZnn+Jq0hkzLdaaYwFForsIWVBqRqIrbn0a
        hpTYd9QZXEFO4hu2hSb+Ty2llzT82mp/cSfJnGtihbNhm6qmEBGRxxRav8k4hX3C
        iVuzVrLTqRaO6QE/DEFRhckxrq4uoWr9kTfFVCDGC4wiUyLk/I0Qq6IxxVwA/nqR
        bJ4im+rE3AeNMFt/WKyn8z2u7UKS+du9pidam9Z2OHg+9kdsUaMfdn0vR+rS7uJR
        SrPrEDQvjikebcVxE+I151Ut9FAIsK0utaeAS7gUBGnqU61Qt1zHOf2XkDRHP151
        3JqbbmrC7qHjtkgIwHkPw==
X-ME-Sender: <xms:9dxTYqgDp_fA4-8WvOl54sum62w8Yu_tlMT6IGcSodO4yXx3gVGa2g>
    <xme:9dxTYrCaO9bfARd8cFva6vpR_ZCHdtSREP-WSSE1Wpmlnw3q9cirROpHQl-gLmBte
    vrooM_wqMTZGg>
X-ME-Received: <xmr:9dxTYiFV-_UJvLkTzjzPe3icUd5BpLdL2GwTgJssYVdQ4Ial51ro_bYY_C2DO_cAgizsf3oN9eFnZAihUt7LEindHsSkNCwn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudekhedguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:9dxTYjRRzueSvS6YqP9H3IHSefsOmhKOY9u7SWWJqHUt_MSpFiWwGA>
    <xmx:9dxTYnwPAUAIpFlE-oxmhh6gpYdMNSGgyeWZ_5VAgiGehEOjSVNuiw>
    <xmx:9dxTYh6ck4PwFMYffvYs5SlKslGEZ8iK2pvzUeoembwxOC17AjzwiA>
    <xmx:9txTYi8QeOb_haFngU-M8WejThoULGXQKbogR0Ey4zPwztG-f2dq4Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 11 Apr 2022 03:47:01 -0400 (EDT)
Date:   Mon, 11 Apr 2022 09:47:00 +0200
From:   Greg KH <greg@kroah.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: Queue up 5.10 io_uring backport
Message-ID: <YlPc9NeVwwG5jsRK@kroah.com>
References: <5baa6fdd-4f5e-338b-7c38-28e5a88bfe65@kernel.dk>
 <22c864c3-d0c5-8081-f965-754db2e75069@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22c864c3-d0c5-8081-f965-754db2e75069@kernel.dk>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 10, 2022 at 10:53:46AM -0600, Jens Axboe wrote:
> On 4/10/22 10:46 AM, Jens Axboe wrote:
> > Hi,
> > 
> > Can you queue up this one for 5.10 stable? It has an extra hunk
> > that's needed for 5.10. 5.15/16/17 will be a direct port of
> > the 5.18-rc patch.
> 
> Here's the 5.15-stable backport. For 5.16 and 5.17, the upstream commit
> will apply directly with no fuzz.

Thanks, all now queued up.

greg k-h
