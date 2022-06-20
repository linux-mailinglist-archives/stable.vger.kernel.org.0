Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE995551A46
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243837AbiFTNET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244430AbiFTNDi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:03:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7641EAC3
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 05:58:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC39BB811A3
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 12:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B872C3411C
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 12:58:08 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="aForGrLz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1655729885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KiXARaBWZoYSY/TiMQC3QRggUpwlP8lHhY5evQDKZyE=;
        b=aForGrLzsok+X+blZnzw0oyX8tlNgeY1uN3n4qkTdN9syRqWZO+g8gjO09TkSl4OGzEF9+
        Kt/2e8ZsByh2wpNbuZAsgWqNKeO9ZgnNW41L4AbufPqXkoizOa6MdcYSZXVvlQLWec97lB
        Z/CBCcX0jjdZiwEiVgpdLVdUyds6GUE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 29cda434 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <stable@vger.kernel.org>;
        Mon, 20 Jun 2022 12:58:05 +0000 (UTC)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-2ef5380669cso99276347b3.9
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 05:58:05 -0700 (PDT)
X-Gm-Message-State: AJIora9RRhSnpZMRYT7wr3nBgOnpKJ2Z6X8GgNyN08aJQVVCYP8RLJ5M
        kazjIkFCqzIcwyTpl2ejFAPnatQEbPJS4jwgV+c=
X-Google-Smtp-Source: AGRyM1tXNwIMXMhZAzN2kpW09dDs4qedN2VwT05tVv2p4g+41PHfv4GQksQ9m+p6wxkIgioDHDOHPzvWTysP1RQltoA=
X-Received: by 2002:a81:3a83:0:b0:317:82a1:a74 with SMTP id
 h125-20020a813a83000000b0031782a10a74mr19380930ywa.404.1655729883124; Mon, 20
 Jun 2022 05:58:03 -0700 (PDT)
MIME-Version: 1.0
References: <165572762017277@kroah.com>
In-Reply-To: <165572762017277@kroah.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 20 Jun 2022 14:57:51 +0200
X-Gmail-Original-Message-ID: <CAHmME9q6VJ__Rpfqy6+Akh-ONuGaGQ4jOEZfu9rhbxB4hX5s4A@mail.gmail.com>
Message-ID: <CAHmME9q6VJ__Rpfqy6+Akh-ONuGaGQ4jOEZfu9rhbxB4hX5s4A@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] random: do not use jump labels before they
 are initialized" failed to apply to 5.18-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Phil Elwell <phil@raspberrypi.com>,
        Stephen Boyd <swboyd@chromium.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is fine. The commit that this patch was fixing, 60e5b2886b92
("random: do not use jump labels before they are initialized"), was
reverted from stable. You could revert the revert if you really wanted
to apply this, but it's just a performance optimization.

Jason
