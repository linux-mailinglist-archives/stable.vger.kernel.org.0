Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2666D6C3A43
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 20:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjCUTUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 15:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjCUTUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 15:20:09 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8397B2F051
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 12:19:43 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id ga7so458213qtb.2
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 12:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112; t=1679426379;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rxWi1H133ZQCtSj8Y+2jFuE3HGaaHVxqMPQgGdZbnm0=;
        b=UWdQybfb3HPyv77SoF+AygRnmFv8gUg8EQfMDiPE3LGZHrtP2Q5beKJvJhLeKweCB7
         +8Vu6KXst3SRADyYwxndxDdPNztJr94e5lf1K9k+N6DiP/TF2IKYmXvFa6Zwlo2YZ6vU
         m8OjNDeY8CHFNTIFVhKQlKRmnbL+LVOW2EXHx3zd3XdiBYkNWJae2WArSW4jpM1CQVTY
         qLGoXO/4CV410AFzpIO9f1u0VF6C1kT7q9EBOMzbtHdq+Rb2jEB9TS/lw2WkzFFmIXZj
         ijOnRKUvkXPYV7+LqVUu5olmBY2UVe/ryzVoMLXDaeAQoJQitIJXJAkgDLFCt9GQnBAH
         thQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679426379;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rxWi1H133ZQCtSj8Y+2jFuE3HGaaHVxqMPQgGdZbnm0=;
        b=ee35DOJ+SKQrVmhYxkaZu8ud6lyHTb0TJPkvARSHObkJ22wno3dHzcbuacws3YsFw+
         w3zr2yqAsuxyUTGR5+7/et2AwummE7MEOURDD2WCAiiLyXOk3xnteznSi2oavVRB1kff
         XJkYCOvPC89t5ieHFsBPCZ7XN85Pn/LHISLJjpUnpj7QKtHGekR306v0xA+h/jwiy4PO
         CFo3pfqndBRejsD6slH765pNYIjuPw07m6W2fHnNiON5LQ+PEuEUwQsez78dzXtcPHja
         9bSzqBRxki7hVhuH59H/VaMNIa+I2av/CgAGAwrj4dip+ualVgC4IX7k8PoMBlOA4Mr2
         7QxA==
X-Gm-Message-State: AO0yUKW65Jh8IuFeZo5IJb5kA6ERwRgfGL8gsoP/tKusqhxctY8ojMEe
        txoxqZuWOx39tIouEd+X9kvE3w==
X-Google-Smtp-Source: AK7set8rynN+vVb0DctbpbSJ1Yt2e9AbFOXF57qN81XihTqGj7mo/M5mX7g0/MyELOZxNvNRxvIlgg==
X-Received: by 2002:a05:622a:651:b0:3dd:8b9f:1fe8 with SMTP id a17-20020a05622a065100b003dd8b9f1fe8mr1706198qtb.68.1679426379601;
        Tue, 21 Mar 2023 12:19:39 -0700 (PDT)
Received: from xanadu.home (modemcable108.170-21-96.mc.videotron.ca. [96.21.170.108])
        by smtp.gmail.com with ESMTPSA id a20-20020ac87214000000b003d9650a7a9csm8655105qtp.46.2023.03.21.12.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 12:19:39 -0700 (PDT)
Date:   Tue, 21 Mar 2023 15:19:38 -0400 (EDT)
From:   Nicolas Pitre <npitre@baylibre.com>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
cc:     linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Frederic Weisbecker <frederic@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org
Subject: Re: [PATCH v4 04/12] ARM: entry: Fix iWMMXT TIF flag handling
In-Reply-To: <CACRpkdbRf9NL4+m+bJZ16x5uCMb2rDYmBk3xTwmVDFykDTmnMQ@mail.gmail.com>
Message-ID: <2q3srsro-n086-s7r1-5o68-8r0qs2467s5r@onlyvoer.pbz>
References: <20230320131845.3138015-1-ardb@kernel.org> <20230320131845.3138015-5-ardb@kernel.org> <CACRpkdbRf9NL4+m+bJZ16x5uCMb2rDYmBk3xTwmVDFykDTmnMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-177517537-1679426379=:2175915"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-177517537-1679426379=:2175915
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, Mar 20, 2023 at 2:19 PM Ard Biesheuvel <ardb@kernel.org> wrote:

> The conditional MOVS instruction that appears to have been added to test
> for the TIF_USING_IWMMXT thread_info flag only sets the N and Z
> condition flags and register R7, none of which are referenced in the
> subsequent code.

Really?

As far as I know, the rsb instruction is a "reversed subtract" and that 
also sets the carry flag.

And so does a move with a shifter argument (the last dropped bit is 
moved to the carry flag).

What am I missing?


Nicolas
--8323328-177517537-1679426379=:2175915--
