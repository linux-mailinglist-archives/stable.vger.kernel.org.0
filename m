Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 760C86E76F0
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 11:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbjDSJ6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 05:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232916AbjDSJ61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 05:58:27 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35852118ED
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 02:57:59 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-2f7c281a015so1994778f8f.1
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 02:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681898275; x=1684490275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hupHNG5IAW/zmzShc8lttgNkGPU8qe7bXT1BDjiDGH0=;
        b=gozxd3oNE0j/YGydsFJapiJzk+9Q1aDhBfoBxPSPDoQ7y7jyLCdpFWora3xRjXFapx
         T/NXIHcnHr9RtBSy4QPAiTbgphKWm0eHsyCCcgotPyIC8d5EY6nQvY3/SzmVvHpgmAyd
         9CFz5v1pLx4espbUtEulhJxIDC9Msn1ptCOkV6VG/0RKzYuSAjaQX6PVVZFcUt0Jz73E
         SrOjiOM3KgstMOkhvU9GkWG7M/UlrN4L3J65NAg1mYNdK72/FUUNXZKLJc82jzM3x7Ej
         ZFhwL8h8qaAJxDpt1KX9pzizLQcJbL21w7SpPLIaS3uYJRxYQOcoeY1bWC+DNotkcf2D
         CE0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681898275; x=1684490275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hupHNG5IAW/zmzShc8lttgNkGPU8qe7bXT1BDjiDGH0=;
        b=JIwXCnrvMyXxwe8PXc+NacR9e/pe/hS3jDKmrrInK6Ptb011ZlEpq8Q58s3UbAo8FB
         hhrUBTuibihudtGybx1NkFTf7fkyQOyJXKRYiN6Yj6uysh5lXDlQQigDKXIxAraU7v7P
         DNoHQmd3XbqEQcR1KWnlL6VrCMsUUxNjwaGl2C1HZDsovWJCAsH0Dks/L7MeZx1oGs7n
         HQX3u83UFDHQWqXJzDTRhBAFPEtYft2umSVaIDJ0/H/HAxT1Gj1jP6lZZmxr0CNIqxrr
         nknv5H4e5Tak+OxrxiQL5pjEH46+iAxk9XS/RbdYQoKKXEcf8tPZ87Gas9/XDFtbct4y
         vEZg==
X-Gm-Message-State: AAQBX9fnB9Z1umGyVWu8qfn/+JL48o8Iaj9fKXP+OBSJDkjPZJYv02KE
        sB550vna5/TNkr9ypu6vjr8PIajsdyOp30Yb3HV3+p0uL9/XEbHF
X-Google-Smtp-Source: AKy350YZRxtrR3nRrp3HaHXWDzmawpHicPoNTqVzkpPnwGU4a0cPHCBdKS8zZ+MY18ZlDlBNm0Q40S2LocwpqaBSRZY=
X-Received: by 2002:a5d:6708:0:b0:2f9:d629:48f1 with SMTP id
 o8-20020a5d6708000000b002f9d62948f1mr4123971wru.26.1681898275594; Wed, 19 Apr
 2023 02:57:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230418120313.001025904@linuxfoundation.org> <20230418120317.673170852@linuxfoundation.org>
 <20230418-tactile-cocoa-4242e87bf994@wendy> <2023041948-overthrow-debtor-289d@gregkh>
 <20230419-uninstall-fragile-51c326b1adbc@wendy> <2023041918-stammer-subgroup-fbd1@gregkh>
 <20230419-unpeeled-squabble-986a9e40e4d5@wendy>
In-Reply-To: <20230419-unpeeled-squabble-986a9e40e4d5@wendy>
From:   Alexandre Ghiti <alexghiti@rivosinc.com>
Date:   Wed, 19 Apr 2023 11:57:44 +0200
Message-ID: <CAHVXubgRXAzGWwyTPwUpWxjP++0Yybu=wPMRCPuaPs2mEaA86w@mail.gmail.com>
Subject: Re: [PATCH 6.1 129/134] riscv: Move early dtb mapping into the fixmap region
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Conor,

On Wed, Apr 19, 2023 at 11:51=E2=80=AFAM Conor Dooley
<conor.dooley@microchip.com> wrote:
>
> On Wed, Apr 19, 2023 at 11:36:43AM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Apr 19, 2023 at 08:55:34AM +0100, Conor Dooley wrote:
>
> > > However, this patch ("riscv: Move early dtb mapping into the fixmap
> > > region") did end up getting applied to 6.1.y and 6.2.y, despite what =
the
> > > email I got said for 6.1.y!
> >
> > That's because Sasha backported the dependent patches to get it to
> > apply.
>
> Should probably send out a notification of success then, no?
> At least, I didn't see one land in my inbox.
>
> > Let me just drop all of them, that makes it simpler and then if anyone
> > wants them applied, then they can send us an explicit set of patches.
>
> Perfect, I should be able to do that.
> Some time here might actually work in our favour, as I don't think this
> stuff has been tested yet by anyone using XIP and I had expressed some
> concerns that we would cause them issues.

Let me know how far you'd like to see it backported, I'll do it, I
already let you deal with all the backport errors, that's the least I
can do :)

Thanks!

Alex

> I already owe you one set of non-urgent backports that I have yet to
> get around to...
>
> Cheers,
> Conor.
