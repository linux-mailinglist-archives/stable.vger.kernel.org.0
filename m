Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689D76987E7
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 23:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjBOWal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 17:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbjBOWak (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 17:30:40 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A3115545;
        Wed, 15 Feb 2023 14:30:38 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id y1so183991wru.2;
        Wed, 15 Feb 2023 14:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6FZw+rbuPNpxPQkAbzgbqnhaAls6Wd3rBlTBF6zE2sU=;
        b=apJUs7dQvTitDwHmsJrfNHfgumGke2KN0f1VSaJYvlncMFOARyecwO47B2h2kcHExn
         0N3MpDeOuk0QA2viJIXEYqCeXLZICGEizaJ0gK4RsS3An2T8x36of7wvpHI9eM14ZGKS
         MQ+DO+Nk39SveSQ/wMvlW3LtjkPAl8QVXozkj4jYTsDc9MEJEciSUu/Q2C7wUGyRnGGs
         d2sJYHbtu3YRXas5iU/AtWGE1shS/2K9Cj6EZbZHcfLlbyMgHjqCRqtW1dz9iKMCxabA
         ENvG/UqzDY+SIqSb9pON5tHJxJyEDgtQJ752vttL+iQ0zhRS6U/5rx4160IwyxkU49sZ
         Lkew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6FZw+rbuPNpxPQkAbzgbqnhaAls6Wd3rBlTBF6zE2sU=;
        b=ZWWEEqknO1ux1lLDL4ik5d4LZ87qIQhmuZVgD5R7eTS+/W3KH78ze9Q3qoEs7nd+cA
         NVFYD4VLVZ5/AvQTw37pPbIpm/bI1gFStlv6Pg4+Yi4+LRIzprlX76PPlxIODjnOVoot
         C9vIo3YaL9+EOSHTmTWfJ9hVHz+8WZrr2UWcnuo8eno49vAHcAektRkY2b1PL8Yzm08D
         pJrzj8pnHFZFerfgrbYSY9Vu4hhTf9Y4dEb5ZI9hWLposJdj8m2/soOjD1QcfRZom2HP
         XUnx8mYXQ9B3twPIr2VmLJ458w5vaUMJ7xFYvg5JezU5a4CR8YRQeqFYLi6ZQGkw/SNF
         kxYg==
X-Gm-Message-State: AO0yUKVdA23UcNQRk9Eua48VWUUoWhcU883KkR7ZZ0EczvMfZYVbtnZd
        BEENE46fbrWkdos4fmBIAg0=
X-Google-Smtp-Source: AK7set8/2BJEkf+A0QdVn0nYN8whIV36+3VYxhcGtj44qJM73ZoRyVtSc6Hdn6x7owSH2IV9wx1E2A==
X-Received: by 2002:a05:6000:10c1:b0:2c5:56ff:4321 with SMTP id b1-20020a05600010c100b002c556ff4321mr3292756wrx.4.1676500237045;
        Wed, 15 Feb 2023 14:30:37 -0800 (PST)
Received: from localhost ([2001:b07:5d37:537d:5e25:9ef5:7977:d60c])
        by smtp.gmail.com with ESMTPSA id g4-20020a5d6984000000b002c552c6c8c2sm11116335wru.87.2023.02.15.14.30.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 14:30:36 -0800 (PST)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 15 Feb 2023 23:30:35 +0100
Message-Id: <CQJHQFNV0Z2I.24P0M0681CSE1@vincent-arch>
Cc:     <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] rust: kernel: Mark rust_fmt_argument as extern "C"
From:   "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
To:     "David Gow" <davidgow@google.com>,
        "Miguel Ojeda" <ojeda@kernel.org>,
        "Alex Gaynor" <alex.gaynor@gmail.com>,
        "Wedson Almeida Filho" <wedsonaf@gmail.com>,
        "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
        =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
References: <20230214224735.264894-1-davidgow@google.com>
In-Reply-To: <20230214224735.264894-1-davidgow@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> The rust_fmt_argument function is called from printk() to handle the %pA
> format specifier.
>
> Since it's called from C, we should mark it extern "C" to make sure it's
> ABI compatible.
>
> Cc: stable@vger.kernel.org
> Fixes: 247b365dc8dc ("rust: add `kernel` crate")
> Signed-off-by: David Gow <davidgow@google.com>
> ---

Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
