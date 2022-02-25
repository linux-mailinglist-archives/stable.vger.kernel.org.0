Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCB74C42C9
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 11:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236823AbiBYKwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 05:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233510AbiBYKwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 05:52:39 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1282417AEF8;
        Fri, 25 Feb 2022 02:52:06 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id i21so4312970pfd.13;
        Fri, 25 Feb 2022 02:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=lOPOPfTT4jvu98yCK4rpV6Lqqj8jf8x3i39DL5jIpco=;
        b=V5B+L7kkmOLNwj2gCGdaorIBzmt8oiMQhtgWPxwrvRkvEFR7f+5APv/FvxoYjgErTf
         ANTG3PR8iDx9n+Qah2R682GxFBWXV0HwfVyNAfa7oY08KBNLDcL28ZO98CmJAdeJ7A/T
         NRjzJ+xWm1qOW9WHfNoJnQE0tLzb75gxC82Qbcm/4BVbE3AIJE6I5eKzK5OOsblW0Ue+
         VY+VISqz+doRzyzG6VX8o5uXgIvb28TSs782rKyn3pzGkts23LVgUFLu+0EYAibXcffm
         xGQD8xv/J2F5Ccs6HJF3hwv+cksPeOrEvtg+VcssicUaGZUA/VGak4E82ATQ+heUcyUn
         CZEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=lOPOPfTT4jvu98yCK4rpV6Lqqj8jf8x3i39DL5jIpco=;
        b=qPOo7UckIC57bFQoCQFZNL0T5uDARcLV4bmsYYte5D+JpR/PERYBHNEDAqhMSEtf6S
         H2j+KhEASZ+cO7Iiw1cZxmzJnsyA2TDesNdsnApsEqOp1QdozxpxtODevhN5ysuUOOB0
         NoV+XdMfmRozFvYwEd62w+MAjtkkuoTkTs5pdR4+pO2jeY8pbgE0gC7mbg8KP8E3rxmQ
         TY1A82SWBW5xD0160MiYxZm/wr5yTBUAfQCQCasg0EP6Ffs4awOc1+iRG+gTDrKlNNVt
         O3ZwWni6GSUNrK/1oWIZTZ5sCZJgEIF0/HqbR3pxLQAZisaVfaMneMWbPdtJwMl9PGQE
         NEAg==
X-Gm-Message-State: AOAM532oR8AYMwL8qkCZvSpXUFBStTM7u9cD8wfYpG5QSURSMFVPOh6r
        56jDaqk+WEG6yjixocR7J2ndiBcnXVN2aA==
X-Google-Smtp-Source: ABdhPJw1p3JpylPzwdPP9TEVvKcOyG6aC0IjbCbljtAOdMk1Nof42N6/33RGILbpNFCQaprbTYZTYA==
X-Received: by 2002:a63:e54d:0:b0:375:5987:af5d with SMTP id z13-20020a63e54d000000b003755987af5dmr5750991pgj.14.1645786325457;
        Fri, 25 Feb 2022 02:52:05 -0800 (PST)
Received: from localhost (118-208-203-92.tpgi.com.au. [118.208.203.92])
        by smtp.gmail.com with ESMTPSA id d14-20020a056a0024ce00b004f3c87df62bsm2729639pfv.81.2022.02.25.02.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 02:52:04 -0800 (PST)
Date:   Fri, 25 Feb 2022 20:51:59 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 2/3] powerpc: fix build errors
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        "# 3.4.x" <stable@vger.kernel.org>
References: <20220223135820.2252470-1-anders.roxell@linaro.org>
        <20220223135820.2252470-2-anders.roxell@linaro.org>
        <1645670923.t0z533n7uu.astroid@bobo.none>
        <1645678884.dsm10mudmp.astroid@bobo.none>
        <20220224171207.GM614@gate.crashing.org>
        <1645748601.idp48wexp9.astroid@bobo.none>
        <CAK8P3a0feJOsKMNP0zCdPho5XdD+NXFceUTTe1X6dA9OdWQntQ@mail.gmail.com>
In-Reply-To: <CAK8P3a0feJOsKMNP0zCdPho5XdD+NXFceUTTe1X6dA9OdWQntQ@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <1645786002.lvhr18b39u.astroid@bobo.none>
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

Excerpts from Arnd Bergmann's message of February 25, 2022 6:33 pm:
> On Fri, Feb 25, 2022 at 1:32 AM Nicholas Piggin <npiggin@gmail.com> wrote=
:
>> Excerpts from Segher Boessenkool's message of February 25, 2022 3:12 am:
>> >> +#ifdef CONFIG_CC_IS_GCC
>> >> +#if (GCC_VERSION >=3D 100000)
>> >> +#if (CONFIG_AS_VERSION =3D=3D 23800)
>> >> +asm(".machine any");
>> >> +#endif
>> >> +#endif
>> >> +#endif
>> >> +#endif /* __ASSEMBLY__ */
>> >
>> > Abusing toplevel asm like this is broken and you *will* end up with
>> > unhappiness all around.
>>
>> It actually unbreaks things and reduces my unhappiness. It's only done
>> for broken compiler versions and only where as does not have the
>> workaround for the breakage.
>=20
> It doesn't work with clang, which always passes explicit .machine
> statements around each inline asm, and it's also fundamentally
> incompatible with LTO builds. Generally speaking, you can't expect
> a top-level asm statement to have any effect inside of another
> function.

You have misunderstood my patch. It is not supposed to "work" with
clang and it explicitly is complied out of clang. It's not intended
to have any implementation independent meaning. It's working around
a very specific issue with specific versions of gcc, and that's what
it does.

It's also not intended to be the final solution, it's a workaround
hack. We will move away from -many of course. I will post it as a
series since which hopefully will make it less confusing to people.

Thanks,
Nick
