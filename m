Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9230C6DA46F
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 23:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236921AbjDFVJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 17:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236507AbjDFVJQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 17:09:16 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EACC7ECB;
        Thu,  6 Apr 2023 14:09:15 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id r187so47507970ybr.6;
        Thu, 06 Apr 2023 14:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680815354; x=1683407354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=klFrmi00Z3pggeaXv1LLk/QRMVU2POucaD3ESeOb7sQ=;
        b=MdK+SiSVYQcPOczJdqighKBIn8DjAyO1bixiMUf+QqzplYl5bXxDnQZcw7xZIOtgxo
         1s7oy8FLhE0BN3tbF9iC56R1+EWGdUlnGHhBAvVdr8F64faJgdMY3mJPSy+Y0PM9D77D
         krW2HJz6fOJ3/DGPabdfgSznPhhhW337s3T/JIy/9/9N43gi5QWS0NtyVwx9m+lE38mW
         rrOsi8Fd13Czhjr9FSbBEMLxCf6Mn/C4/PAdLDIlzC0GqvDN/YhR4p0f6Pmlre5mEK1D
         XaVKzfACnEM7ab/HirNNgU2mhv7QyQqs+NSxq5aMH8IkKB3vcyMODvBC0DqCGb0Smw9i
         d/8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680815354; x=1683407354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=klFrmi00Z3pggeaXv1LLk/QRMVU2POucaD3ESeOb7sQ=;
        b=Z05NdGL4oMkROQiYrPed4WVDqGJMEbIQZb15fy68nZrXf4UF/dMM+nN40bwl3tcoPG
         iPPw8sMmojB3I6LjKGwh6BqXXKp9FikaYvwT9nkc/A6nLjt6gTi/GbS7+e0cJmHoDm3j
         dMTNalJ/mg2EycO46nf2FT4lC+znUTTE02gafJaIAJIW7CyG+maxnSROYwvi4HvMlGHD
         knziGJDMKIHpIM/9VPVaOsed0Xxl9NtNWEvYS1b5MZWOrDrJBjwcfwUvaHKmxzo3XYUp
         odwgyMwX8ejWfCk8x6xC51Jpby6Uy9Hv/4oX4dTcgy3DahNOuApCt6zJXgymFNWvtggX
         Eh0w==
X-Gm-Message-State: AAQBX9ftw6hDRahAP7A3Pj3u57yOQPiyuj22J9PV7HgtAjoHxxpeflIr
        FDHhvKmqwAEiT+urkix5DimgZx/b4uuQAZ1/R62+vW1e1CQ=
X-Google-Smtp-Source: AKy350a8PyzhIz9mwCJN+Gant3I8R/AO26N9X7+1eMvfGNbu67tGbfklJJRU23sxoPywYUPzbs+JLoEcjssq09pDz4Y=
X-Received: by 2002:a25:7489:0:b0:b6d:fc53:c5c0 with SMTP id
 p131-20020a257489000000b00b6dfc53c5c0mr2922932ybc.1.1680815354537; Thu, 06
 Apr 2023 14:09:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230214224735.264894-1-davidgow@google.com>
In-Reply-To: <20230214224735.264894-1-davidgow@google.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Thu, 6 Apr 2023 23:09:03 +0200
Message-ID: <CANiq72mLhopJDp5dQn0N-STv2uvZ8_xWfv-o4Ko-M7RSxd=6-A@mail.gmail.com>
Subject: Re: [PATCH] rust: kernel: Mark rust_fmt_argument as extern "C"
To:     David Gow <davidgow@google.com>
Cc:     Miguel Ojeda <ojeda@kernel.org>,
        Alex Gaynor <alex.gaynor@gmail.com>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
        =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
        rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 14, 2023 at 11:47=E2=80=AFPM David Gow <davidgow@google.com> wr=
ote:
>
> The rust_fmt_argument function is called from printk() to handle the %pA
> format specifier.
>
> Since it's called from C, we should mark it extern "C" to make sure it's
> ABI compatible.

Applied to `rust-fixes`, thanks!

Cheers,
Miguel
