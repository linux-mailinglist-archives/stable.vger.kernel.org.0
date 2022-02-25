Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59DF44C3A49
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 01:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiBYAXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 19:23:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiBYAXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 19:23:44 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9AB1B3A52;
        Thu, 24 Feb 2022 16:23:14 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id u16so3273009pfg.12;
        Thu, 24 Feb 2022 16:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=WNAX63/c99XOFkeIMCeWIytIe0Oh9CQliGpSjMLfo3Q=;
        b=h1p+uPkqcxvYE7x/Gfa8GpqEMj4C9gcpysZ6Fb53cs1JgFb/EVxyJGzvWFnhrdhOyp
         Pu0iIfffTCWQwNdEhPkG5awMACtbndp4X1M3A4+EFp6YaMMyTuNAqNZRlX/zeFrietnw
         ygoBuzggj6hn8c0MeDdKuCV4YLuxPoO3/RocYqK8vlprzOzWiHyauUmM2z6e+iv7GABi
         pcXXLVwad2bFlYs1QfNAO+wSaK191EdX/K6DvFUVIZht7tnOIZUYj+t5UbiFZfPWUG6C
         Q1spvP7hiXgiW5CdXPCbo9fh36YOB8CGcKX6qS2eXOx8XNX+954o+Cn/up+0mBc9KXq7
         HzfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=WNAX63/c99XOFkeIMCeWIytIe0Oh9CQliGpSjMLfo3Q=;
        b=JSXE9qkqGcPLRujBn2jMq4r43TXrb2lV1/XXiwZ37zbS0tez36wLbQALaXPh87oSrZ
         D7B9Xy5i6OQIpot3DT5npf6a43xkqKYONCfFgOf90DllkIekispNC5iz93kltYHj24Qs
         fy6cuCf9JrdyWrbdinL5maWVIZBkO8MJ1B0YkjNx4xSjQYtxioFXaF4cRW59u+fEJarK
         6X0+5gy7ORZNju9WkoDG3jf1mwSmPmB5cbrNnZQO3QYZhte01tqU8CGYV9bxWBsb3Xxi
         pOk8oLdKOLIUlvXObgELTllczgW9TG2LQxqKByZ+ijT6mNVqIyoYJAYBlaEyrX7HFT4A
         O4PQ==
X-Gm-Message-State: AOAM53191tv7tiJ/Z9KPmW9ACBVmKOb2iuuUfqP8ewQj3HH43luu3dGk
        whxB4s+b9QwKtiFHIvjPJ+jm6sMJ/wk=
X-Google-Smtp-Source: ABdhPJyUjEFOcHnNJKQCfpLKU2R/5+7s046kejLK9AP1h3bVEuzh+/IK8fJtiWjzrrTU4pidgLaG9Q==
X-Received: by 2002:aa7:8d08:0:b0:4e1:5fb5:b15 with SMTP id j8-20020aa78d08000000b004e15fb50b15mr4989729pfe.70.1645748593544;
        Thu, 24 Feb 2022 16:23:13 -0800 (PST)
Received: from localhost (115-64-212-59.static.tpgi.com.au. [115.64.212.59])
        by smtp.gmail.com with ESMTPSA id j2-20020a655582000000b00372b2b5467asm637228pgs.10.2022.02.24.16.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 16:23:13 -0800 (PST)
Date:   Fri, 25 Feb 2022 10:23:07 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 2/3] powerpc: fix build errors
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "# 3.4.x" <stable@vger.kernel.org>
References: <20220223135820.2252470-1-anders.roxell@linaro.org>
        <20220223135820.2252470-2-anders.roxell@linaro.org>
        <1645670923.t0z533n7uu.astroid@bobo.none>
        <1645678884.dsm10mudmp.astroid@bobo.none>
        <CAK8P3a28XEN7aH-WdR=doBQKGskiTAeNsjbfvaD5YqEZNM=v0g@mail.gmail.com>
        <1645694174.z03tip9set.astroid@bobo.none>
        <CAK8P3a1LgZkAV2wX03hAgx527MuiFt5ABWFp1bGdsTGc=8OmMg@mail.gmail.com>
        <1645700767.qxyu8a9wl9.astroid@bobo.none>
        <20220224172948.GN614@gate.crashing.org>
In-Reply-To: <20220224172948.GN614@gate.crashing.org>
MIME-Version: 1.0
Message-Id: <1645748553.sa2ewgy7dr.astroid@bobo.none>
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

Excerpts from Segher Boessenkool's message of February 25, 2022 3:29 am:
> On Thu, Feb 24, 2022 at 09:13:25PM +1000, Nicholas Piggin wrote:
>> Excerpts from Arnd Bergmann's message of February 24, 2022 8:20 pm:
>> > Again, there should be a minimum number of those .machine directives
>> > in inline asm as well, which tends to work out fine as long as the
>> > entire kernel is built with the correct -march=3D option for the minim=
um
>> > supported CPU, and stays away from inline asm that requires a higher
>> > CPU level.
>>=20
>> There's really no advantage to them, and they're ugly and annoying
>> and if we applied the concept consistently for all asm they would grow=20
>> to a very large number.
>=20
> The advantage is that you get machine code that *works*.  There are
> quite a few mnemonics that translate to different instructions with
> different machine options!  We like to get the intended instructions
> instead of something that depends on what assembler options the user
> has passed behind our backs.
>=20
>> The idea they'll give you good static checking just doesn't really
>> pan out.
>=20
> That never was a goal of this at all.
>=20
> -many was very problematical for GCC itself.  We no longer use it.

You have the wrong context. We're not talking about -many vs .machine
here.

Thanks,
Nick
