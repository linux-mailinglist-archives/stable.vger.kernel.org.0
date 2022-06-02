Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC4A53B19E
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 04:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbiFBBbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 21:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbiFBBbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 21:31:49 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014942A1427
        for <stable@vger.kernel.org>; Wed,  1 Jun 2022 18:31:48 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id u12so7101185eja.8
        for <stable@vger.kernel.org>; Wed, 01 Jun 2022 18:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k62nV7Jswjfh4J4CVA+J/+R723CZLyDDE2S4baqnCag=;
        b=H5FDe3jnuN+KGmzQtMY8FjzxIp5OgCVrg5TLH2gAYextyJrNTj0AvwoN6LuojxpTVR
         72gGqG52f8sxiemwN6dFAEz/4wR4xwg2kVv6Zf25KN/MGnHvxc86UCA3A5IdMufuJYk+
         qu7dPwyLLlHdNnFN2Wb9UYnpaxdFjlic3+Lto=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k62nV7Jswjfh4J4CVA+J/+R723CZLyDDE2S4baqnCag=;
        b=hnfG0ZOHTsGKzNzvpOnL6+Y1hClDro1pfsnXn5ONLul/qMM5cXqYAQgbcYQn7uL5qT
         3gDSp+Sd+6dIqx/OP1zDulZqdkDwpZV/zkMqlkr6OHtKgHKIpTB4YSgrXs4yRkdatQ7s
         W63GlcC2l3b1V4jqpf6iGSwGaZle7+Z4//YgnQQJA8qA5xqVnABPf8WlxvnPQu0alaPz
         eIcaOmZg1sEHVEcAX0vev+4oC4Df/N48gMRuDhIg4poNXcEjTPbxwiMAy4XJHRsdlw5a
         Zd2ytmqqhdq5OSZJ/4wJAnxwAyFhxNCBQLKjcPfRCAcpNSFJUVMEMdEuiDRUhdRp52F6
         RjOA==
X-Gm-Message-State: AOAM530mIFWL2H+VpDFtK/gds0Eyx+A5LP/2fqBKC8+4dl9iM5qKAy3c
        iKRGPTqmw+qOlkjPYlpQjYjbv4L9qdOM3ec/
X-Google-Smtp-Source: ABdhPJxPDXj50qVTON8aKiGrqM8d5a7nWZ6QGdT/jf5m9Jpyqiw8MB4a1lvdAQODwXwzo0foZGElrQ==
X-Received: by 2002:a17:907:6e19:b0:6fe:89b6:5c21 with SMTP id sd25-20020a1709076e1900b006fe89b65c21mr2122207ejc.350.1654133506308;
        Wed, 01 Jun 2022 18:31:46 -0700 (PDT)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com. [209.85.221.44])
        by smtp.gmail.com with ESMTPSA id p6-20020a05640210c600b0042ab87ea713sm1702445edu.22.2022.06.01.18.31.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 18:31:45 -0700 (PDT)
Received: by mail-wr1-f44.google.com with SMTP id e25so4479821wra.11
        for <stable@vger.kernel.org>; Wed, 01 Jun 2022 18:31:44 -0700 (PDT)
X-Received: by 2002:a05:6000:1b0f:b0:210:313a:ef2a with SMTP id
 f15-20020a0560001b0f00b00210313aef2amr1547932wrz.281.1654133504250; Wed, 01
 Jun 2022 18:31:44 -0700 (PDT)
MIME-Version: 1.0
References: <165295023086.3361286.8662079860706628540.stgit@warthog.procyon.org.uk>
 <8735go11v0.fsf@stepbren-lnx.us.oracle.com>
In-Reply-To: <8735go11v0.fsf@stepbren-lnx.us.oracle.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 1 Jun 2022 18:31:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjHHg_buCqw=Q2OtRWoFpD67OxsQ0jMzao+6rGM6hRE0A@mail.gmail.com>
Message-ID: <CAHk-=wjHHg_buCqw=Q2OtRWoFpD67OxsQ0jMzao+6rGM6hRE0A@mail.gmail.com>
Subject: Re: [PATCH] assoc_array: Fix BUG_ON during garbage collect
To:     Stephen Brennan <stephen.s.brennan@oracle.com>
Cc:     David Howells <dhowells@redhat.com>,
        stable <stable@vger.kernel.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        keyrings@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 1, 2022 at 3:00 PM Stephen Brennan
<stephen.s.brennan@oracle.com> wrote:
>
> Just wanted to check on this patch as the 5.19 window closes. David, are
> you planning on taking this through a particular tree, or is the ask for
> Linus to pick it directly?

Ok, picked up directly.

These fall through the cracks partly because it's not obvious what
they are for. Sometimes I get pull requests from DavidH, and sometimes
I get random patches, and while the pull requests are fairly
unambiguous ("please pull") the same is not necessarily true of the
patches. Are they for discussion, an RFC, or fro applying...

So then I pretty much guess.

                 Linus
