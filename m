Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBD54C21E9
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 03:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiBXCz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 21:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiBXCz2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 21:55:28 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C7E23A1B6;
        Wed, 23 Feb 2022 18:54:59 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id i6so647131pfc.9;
        Wed, 23 Feb 2022 18:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=FxQHatlTrRq7n3gKv7MI+frHpxxNsIq5DRZG8efWFS4=;
        b=b518rUrDU5aRRQEoulnpVrkWEE0YPug819IuLWcpCyw32P6K+H9akNr8b0UtmTFe/U
         KWQYZ7ciC7LMs1CnnACaZjAewODXu/w7X5GEv4ryE0UcfgzVl7er9Aygco8Vg1eahP+t
         dx1+mgnszHtWeJ2ychRMEh5WrE4KI6f+UvskHoGNnCRD9EDYXfOU06jGhf8+67aZbrJ2
         QypI3Zdy2GqCWAptTEM2iFnb8mAa5VYIMZEkK7DgoWbDIcJJPqCunk8x5VVSGb2Tp5m2
         Rt2D4tJL903ktJ68WxQo8qUL1SajUJi9yOAN738rWLH3Q03YPeRNQ33HsIVB2MONKUQ0
         VS5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=FxQHatlTrRq7n3gKv7MI+frHpxxNsIq5DRZG8efWFS4=;
        b=Z/C6+kkZdDbKKylWmAz9pBLDMQkS97cP3XN5Yo8YC5HN/a8QutNx3x9nxqu+3iUdv3
         SqygTc+tWc8kxE0u2u4ElrR7bZ4Ns93KQYVWFyvTJRvXDk12VG9873DpQgBqJo+vI1HN
         0Y0mnJnGoUMoQ3vo70p7oLGP9kBRcwBUcW2ZnUAJo8AyHlQTM3CDVjkAHIb78GFvA4vC
         rpQJ9BFVw7KOxqIh3ykj/kIkylP2kdynnL15Nb14ZeO7BJa/IhhVETQyVhxyhguh8OTA
         1aKOIEFz7ZQXkKn3UXLiMmNKbWrqKTjWfA69LlajGl2i7DkPTXBe+IgCbgmRXj4mcft/
         Aegw==
X-Gm-Message-State: AOAM533hRJhA05IUCuzImwOIJW3sxh26PyCikEo81i4IWKs6q/b5oBnA
        v5GFlvH9fD7R40pCsjwQV2yRhwkDEDQ=
X-Google-Smtp-Source: ABdhPJyFv+lwxjKmKEwPGxhmxZsPA6m+LPm+lRZgyA+/E+lsDACEN1iWas9d9jL/8UIqCUseD6JRew==
X-Received: by 2002:a63:375b:0:b0:374:915e:d893 with SMTP id g27-20020a63375b000000b00374915ed893mr674932pgn.494.1645671299350;
        Wed, 23 Feb 2022 18:54:59 -0800 (PST)
Received: from localhost (115-64-212-59.static.tpgi.com.au. [115.64.212.59])
        by smtp.gmail.com with ESMTPSA id s6sm949926pfk.86.2022.02.23.18.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 18:54:58 -0800 (PST)
Date:   Thu, 24 Feb 2022 12:54:54 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 2/3] powerpc: fix build errors
To:     Anders Roxell <anders.roxell@linaro.org>, mpe@ellerman.id.au
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
References: <20220223135820.2252470-1-anders.roxell@linaro.org>
        <20220223135820.2252470-2-anders.roxell@linaro.org>
In-Reply-To: <20220223135820.2252470-2-anders.roxell@linaro.org>
MIME-Version: 1.0
Message-Id: <1645670923.t0z533n7uu.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Excerpts from Anders Roxell's message of February 23, 2022 11:58 pm:
> Building tinyconfig with gcc (Debian 11.2.0-16) and assembler (Debian
> 2.37.90.20220207) the following build error shows up:
>=20
>  {standard input}: Assembler messages:
>  {standard input}:1190: Error: unrecognized opcode: `stbcix'
>  {standard input}:1433: Error: unrecognized opcode: `lwzcix'
>  {standard input}:1453: Error: unrecognized opcode: `stbcix'
>  {standard input}:1460: Error: unrecognized opcode: `stwcix'
>  {standard input}:1596: Error: unrecognized opcode: `stbcix'
>  ...
>=20
> Rework to add assembler directives [1] around the instruction. Going
> through the them one by one shows that the changes should be safe.  Like
> __get_user_atomic_128_aligned() is only called in p9_hmi_special_emu(),
> which according to the name is specific to power9.  And __raw_rm_read*()
> are only called in things that are powernv or book3s_hv specific.
>=20
> [1] https://sourceware.org/binutils/docs/as/PowerPC_002dPseudo.html#Power=
PC_002dPseudo

Thanks for doing this. There is a recent patch committed to binutils to wor=
k
around this compiler bug.

https://sourceware.org/git/?p=3Dbinutils-gdb.git;a=3Dcommit;h=3Dcebc89b9328

Not sure on the outlook for GCC fix. Either way unfortunately we have=20
toolchains in the wild now that will explode, so we might have to take=20
your patches for the time being.

Thanks,
Nick
