Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3F9515A9F
	for <lists+stable@lfdr.de>; Sat, 30 Apr 2022 07:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241103AbiD3FiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Apr 2022 01:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234582AbiD3FiI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Apr 2022 01:38:08 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD7391342;
        Fri, 29 Apr 2022 22:34:47 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id y3so18836413ejo.12;
        Fri, 29 Apr 2022 22:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kUvoGB2vDTB7zKqGhOjlw+/YLAVmdFV6vFxR9oHDumk=;
        b=Y/CaqPLaYXggxB+HrGYzO7DYWHg3xIBTYE6gTohBSr24E+9+SSwfDI2+FnDZ6TfSg1
         okaEsqqoJeeCVH9PyFvuo0gvbnHUx4CgBGXyhaDdWWcjHVAURoSgKd/5s032HLo9QKc1
         B11PKT0d0LqfcQGeHZO/oBF8CTIg3P6obmOPqZtwmVTo/XoFhUL5sRFJ5Y+krsYzl/9i
         86R2aV0R7wUbnEz8+vDRG8mHjBBl+seU/KoTPRHPFIwNxuDGVMYTgELYIZAHjwKwrIvS
         qYu1EAgmJuHTa50STjEs/nr99cuK+N1D660qT19/JiqUHDK4XncR15GnlD0faTEy5sda
         7T+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kUvoGB2vDTB7zKqGhOjlw+/YLAVmdFV6vFxR9oHDumk=;
        b=hCFCgDPu+Zr7ftosoR0CTAMcMk9jsjTYpBblX+scx0OQ1YNQufPV6HmtMrzVLCf7gb
         QAbEAEKF9b8C/GllPISCJf1GuGRA79NLg9R7xW91yUsIrC/HwdxBr4eMSQ6/xAovZS51
         N2hYP/Fqn21cOk8WbDfCcAnQyJIdAggs2NxmXeQsnwiLf41wKuO0b8vfVAcKkXXVEV/B
         iUIh+OlVnQDKO2Iv01Wo6w526cdIpxBLI/x+jTnOaPPN1UGbNeCXnEFwW/mugWaB0Q9k
         1ne1iFwG5itAgPPObDP4MLf7Mkb8SQdHHfC91nHgXUn3hrtuIHSp4HnkDAOauX0DDK0n
         AnWA==
X-Gm-Message-State: AOAM5322xVEaTTV/b2J0X5cS+OpFgjVNcqETYmC2KIQhl19mqU1DbZfF
        eHmq00BKgwu5Fn8xw5Ny109/z+SKPaIOZD52rT0=
X-Google-Smtp-Source: ABdhPJxJAqEg8V6/D8YvyXFayXOvq3GMvJ6PyyBNRoA02ey3oD+yuHLfj8B3ddpA4jtSUXAQfVw16aQHi10JmJ3gVv0=
X-Received: by 2002:a17:906:974e:b0:6bb:4f90:a6ae with SMTP id
 o14-20020a170906974e00b006bb4f90a6aemr2597805ejy.452.1651296886177; Fri, 29
 Apr 2022 22:34:46 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.21.2204291523460.9383@angie.orcam.me.uk> <alpine.DEB.2.21.2204291529070.9383@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2204291529070.9383@angie.orcam.me.uk>
From:   Stephen Zhang <starzhangzsd@gmail.com>
Date:   Sat, 30 Apr 2022 13:34:08 +0800
Message-ID: <CANubcdU99rke6AM4bQEyPNTkJbk1kMit1UVyDggTwTciTUeQMA@mail.gmail.com>
Subject: Re: [PATCH 1/2] MIPS: IP27: Remove incorrect `cpu_has_fpu' override
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Joshua Kinard <kumba@gentoo.org>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Maciej W. Rozycki <macro@orcam.me.uk> =E4=BA=8E2022=E5=B9=B44=E6=9C=8829=E6=
=97=A5=E5=91=A8=E4=BA=94 22:57=E5=86=99=E9=81=93=EF=BC=9A
>
> Remove unsupported forcing of `cpu_has_fpu' to 1, which makes the `nofpu'
> kernel parameter non-functional, and also causes a link error:
>
> ld: arch/mips/kernel/traps.o: in function `trap_init':
> ./arch/mips/include/asm/msa.h:(.init.text+0x348): undefined reference to =
`handle_fpe'
> ld: ./arch/mips/include/asm/msa.h:(.init.text+0x354): undefined reference=
 to `handle_fpe'
> ld: ./arch/mips/include/asm/msa.h:(.init.text+0x360): undefined reference=
 to `handle_fpe'
>
> where the CONFIG_MIPS_FP_SUPPORT configuration option has been chosen.
>

Sorry, but I have a question. From the code in
arch/mips/kernel/genex.S:567, 'handle_fpe=E2=80=99=E2=80=98s
 definition is controlled by CONFIG_MIPS_FP_SUPPORT. Then how can it
still report such
error when the CONFIG_MIPS_FP_SUPPORT configuration option has been chosen.


Stephen.
