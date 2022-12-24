Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 411CC655B47
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 22:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbiLXVSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Dec 2022 16:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiLXVSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Dec 2022 16:18:11 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBB4A45C
        for <stable@vger.kernel.org>; Sat, 24 Dec 2022 13:18:09 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id x66so5308881pfx.3
        for <stable@vger.kernel.org>; Sat, 24 Dec 2022 13:18:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n0tEj2KHHLXlRs/DpFrhZLI9re/SQ5h+K4lQdCJqf/I=;
        b=Eu7JWJQgRap8U5kq6yICeqv5y9X6K6LbFwtdlCPwE2B3a4ZEyTXIqC7BTmr4Sj5879
         jgJrU9zMgnCDVRWV9+DnE8ejx4MwHkJbkJMAqRMz9u0QBfMkmEYrMRP6+C9O2HpiJ5gU
         uQxQp7AN1ymhz2AMNbHK8K+rYPMMTR+kGMthRUcMWlWHSyhzwwZGw7Tr5djGL3+zOfN4
         4qXOvJeAdHJts1GkZ7LOUttNb8ppSk5g6mAeDqyhDCIxNCG8fwVlLCKsbulL279cpPj8
         sWv1GolkamqSCBKAkWiCWtXmKs/0P44hxgTVogfWnPQfPaNAjLI/5gx9jgeOX9tD2Bxm
         ttNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n0tEj2KHHLXlRs/DpFrhZLI9re/SQ5h+K4lQdCJqf/I=;
        b=18tV/TrA11yXUnk9FDHmvtROQY+qbN1z0bf3BrOtEXgwlUAagJUylJSfVT0DXy68QN
         Dj4Ltd3N5le92yJNLXf0/WCjD9L3IEwytBUgId3z6UTkcYMR8GADZAK8IGvHnzZ4HfqI
         +FAUfhRAZjUFxrehlu0kgFsaUata3+fX60222PDD0K6dfMFZi8eQ7ZtKeTKceI9pg6KA
         7+ML4mgg/qy9X276AOsafUedjmjoPm0O/BiIVBo02uriWYIk+9Wa8ea4eb5tJYB4pnaf
         wQdWIBlxBlyHtYSjJyFuE43GUL2eIhOm4h6UvnBRo+hGdZGAwZqIc7lvK7pZqvLQ101B
         Kn3g==
X-Gm-Message-State: AFqh2krRiAZSmUeGLA1arT6B7x0Dyuaw1/G6zDe3WpEfXeGqASwLJYuP
        ddUijuLN5dVtQpDQtJ/KkuEToF1l5abqDEbM6GmnIA==
X-Google-Smtp-Source: AMrXdXudlR3eJWqL676SrUiUQ2KL6TdVyqZp+yAys+Xtb3e9mJru5OHtHaaQ4dUt6Bl6SBfXkPhTpieAoEN9ExP/jnw=
X-Received: by 2002:a63:161d:0:b0:46f:6225:c2f9 with SMTP id
 w29-20020a63161d000000b0046f6225c2f9mr564361pgl.225.1671916689378; Sat, 24
 Dec 2022 13:18:09 -0800 (PST)
MIME-Version: 1.0
References: <d7bb31547e9bbf6684801a7bbd857810@umbiko.net>
In-Reply-To: <d7bb31547e9bbf6684801a7bbd857810@umbiko.net>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Sat, 24 Dec 2022 16:17:58 -0500
Message-ID: <CA+pv=HO1mvnN5XZHkWDjWr=NJHJZxjcstiY4qtJGJ6mfsqPfQw@mail.gmail.com>
Subject: Re: rtla osnoise hist: average duration is always zero
To:     Andreas Ziegler <br015@umbiko.net>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 24, 2022 at 7:48 AM Andreas Ziegler <br015@umbiko.net> wrote:
>
> -- Observed in, but not limited to, Linux 6.1.1

Wait, "but not limited to"? What does that mean? Are there more
versions affected?

-- Slade
