Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0854965B60C
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 18:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbjABRoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 12:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbjABRoK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 12:44:10 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127381119
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 09:44:10 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-14455716674so34299542fac.7
        for <stable@vger.kernel.org>; Mon, 02 Jan 2023 09:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ralston.id.au; s=google;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wpUdWNyPhWU5w8o3Zwx5VFBr6NeDV2N4F/Qnpa1vL6I=;
        b=m6MfbMmfrvFMSUgheX+b1ukF1/bEA3TEehvz5R5uFzBKT/TyBoKBSLtWV+njwJqx8v
         tspcNCE91UZXack1P2u1PQvk1cXE+2YnYZHlKYOb5AC1nlfaVGG0yK6X797LnQg2TtTy
         H3iwEfDsHqXGhUBEoKw+B8vG5Zosq/HWi/kQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wpUdWNyPhWU5w8o3Zwx5VFBr6NeDV2N4F/Qnpa1vL6I=;
        b=B0CW7iAIHIdwNYiLSa4c6WL8l9r3fC8dvVt7UbxOzMyaPInzS7Q2SdmN2qPJFJZ18o
         D/jmAJ9/NOSvvZ6NPvD5AMz6MuyxDWwOR8DIF/RhgoO8mfkJxHBTitb63XPlbJVn7Kst
         S6oEoeXilTL0izhDbgGMCZLjUnOeMx3qh2ViUhWjCnKEyl5hUqplBpPX8MgVK6siTvo2
         P+ySG6ncqccGEvjz0+DairFkqKldCK3eQHj9oUe9V2I+q3Oy4Yum5/St/DBXjNt3VfEC
         DJkJzHQJUP6nDnS/1H4JMcVZ94zb2oCt0V+gpmnhNqvXFRKNJgWT03gmqh+HGWEJW5nF
         y7Lw==
X-Gm-Message-State: AFqh2krZylONYo0SlJnGXW9nuZ1Oh/zoFzmUlMFkl07X0HwlwfwV6j4T
        1f46ISDhvJhFkOs1uN6DEukRLJ2ZoAATNBNdLvrt5w==
X-Google-Smtp-Source: AMrXdXt300OkGf3B2NgvxWo1oA2JPnVGjbbRXY38U1mSSmMdpmnqxV4oDKEOoFyumXSsZZDh0jag4jDM2UvUsf2wacQ=
X-Received: by 2002:a05:687c:189:b0:14f:a2ed:988f with SMTP id
 yo9-20020a05687c018900b0014fa2ed988fmr1910155oab.220.1672681448813; Mon, 02
 Jan 2023 09:44:08 -0800 (PST)
MIME-Version: 1.0
References: <CAC2975JXkS1A5Tj9b02G_sy25ZWN-ys+tc9wmkoS=qPgKCogSg@mail.gmail.com>
In-Reply-To: <CAC2975JXkS1A5Tj9b02G_sy25ZWN-ys+tc9wmkoS=qPgKCogSg@mail.gmail.com>
From:   Michael Ralston <michael@ralston.id.au>
Date:   Tue, 3 Jan 2023 04:43:32 +1100
Message-ID: <CAC2975KFpfPXb06Mfx9oEawbvV_bAoV=YOCCh7g1vfgfLrJWyg@mail.gmail.com>
Subject: Re: USB-Audio regression on behringer UMC404HD
To:     alsa-devel@alsa-project.org, regressions@lists.linux.dev,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For comparison, on a working kernel version, my audio devices are
listed in a different order:
http://alsa-project.org/db/?f=3Deff15e3b674b313f12121c95d4cf330f9d48897c

--
Michael

On Tue, 3 Jan 2023 at 04:29, Michael Ralston <michael@ralston.id.au> wrote:
>
> I'm currently experiencing a regression with the audio on my Behringer
> U-Phoria UMC404HD.
>
> Alsa info is at:
> http://alsa-project.org/db/?f=3Df453b8cd0248fb5fdfa38e1b770e774102f66135
>
> I get no audio in or out for this device with kernel versions 6.1.1 and 6=
.1.2.
>
> The versions I have tried that work correctly include 5.15.86 LTS,
> 5.19.12, and 6.0.13=E2=80=9316.
>
> When I run this on 6.1.1, it will just hang until I ctrl+c:
> aplay -D plughw:1,0 /usr/share/sounds/alsa/Front_Center.wav
>
> I've run strace on that command, and its output is at:
> https://pastebin.com/WaxJpTMe
>
> Nothing out of the ordinary occurs when aplay is run, according to the
> kernel logs.
>
> Please let me know how I can provide additional debugging information
> if necessary.
>
> Thanks
> Michael
