Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58000585E9D
	for <lists+stable@lfdr.de>; Sun, 31 Jul 2022 13:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbiGaLWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jul 2022 07:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232378AbiGaLWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jul 2022 07:22:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD53AE73
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 04:22:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C84A60C79
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 11:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC58CC433D6
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 11:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659266542;
        bh=LebUxnoJqQxwYBGLS2pTI6LjWQjipUlx/vluZkP0ZXg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cmSHyr+PtradXKGfVP+/CeMXCaNMArgJt5B1GM5WCrBCcLh8zqQ5NEChz7roeplhb
         lCgm7sB6E/w3nJflHbe4kv0TVMVOEs2QyRW+5PA1AoMkMcVDtsKaIPSr5ONID7GQ/c
         0nqnTxErelbv7o61F8ngdmYGTZhpO7WT9OKEEoXiV7WMytyOw8ZiVjB+BDSGBt/ei6
         +0HZuJ8Jw8PYqkybJ2JMLMvD1ea2i1stHWTRS90hQOd0dQzoqgTtGBlV7lZRRGkCrc
         Cv5uaKGwQELhLbqLIKVvJEXBtlpAyEtKpdP0mbqgDOuArPb5hpBI+HbObjHH9jI4KO
         jAx1kmiwiaq7w==
Received: by mail-ej1-f44.google.com with SMTP id rq15so9581265ejc.10
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 04:22:22 -0700 (PDT)
X-Gm-Message-State: ACgBeo24bOHWJuocXRYk9ul/YIakBww9dJLwXPEVW6kDc7tiL4FLqb6/
        KBaZsLnYL5OrvVoNIO/7u5evX3VIa7Td8CSPfuQ=
X-Google-Smtp-Source: AA6agR4imQTCxKZDLBzbVXWZd+AvZHRuv8alJGUKK1OXZ7VRqA4VhCF2+XOUu9SYN3DV0k+3djBjdR3uXiHSl5aqc5w=
X-Received: by 2002:a17:907:2cf8:b0:730:6854:1c26 with SMTP id
 hz24-20020a1709072cf800b0073068541c26mr1989125ejc.766.1659266540895; Sun, 31
 Jul 2022 04:22:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220731100551.3679874-1-gregkh@linuxfoundation.org>
In-Reply-To: <20220731100551.3679874-1-gregkh@linuxfoundation.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sun, 31 Jul 2022 13:22:02 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1xg=LN-Q0vrTDEssfDpRqDCudCt=ibxPkdbwG+960p9A@mail.gmail.com>
Message-ID: <CAK8P3a1xg=LN-Q0vrTDEssfDpRqDCudCt=ibxPkdbwG+960p9A@mail.gmail.com>
Subject: Re: [PATCH] ARM: crypto: comment out gcc warning that breaks clang builds
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Justin M. Forbes" <jforbes@fedoraproject.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nicolas Pitre <nico@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 31, 2022 at 12:05 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> The gcc build warning prevents all clang-built kernels from working
> properly, so comment it out to fix the build.
>
> This is a -stable kernel only patch for now, it will be resolved
> differently in mainline releases in the future.
>
> Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
> Cc: "Justin M. Forbes" <jforbes@fedoraproject.org>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Arnd Bergmann <arnd@kernel.org>
> Cc: Nicolas Pitre <nico@linaro.org>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>

I always resisted this from going into mainline without actually
making the code work
as intended on clang, but now that mainline kernels get it right and we have
decided not to backport the new version, this is the best we can do
for LTS backports.

        Arnd
