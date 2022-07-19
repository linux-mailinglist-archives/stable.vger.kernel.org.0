Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED33579216
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 06:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235021AbiGSEnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 00:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbiGSEnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 00:43:49 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35745275F0
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 21:43:48 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-10bec750eedso29267814fac.8
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 21:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yyDMYIZDOiiHKTI5gIWD2Gm2cDPY/Cy3uyHGpaSuF9A=;
        b=bFAX5vPTa8PIG9zYVxjXXa4D7DOmGv/Yh3svgEupY6OiwtO3Iyjic8XauCdkEPnWTy
         Hos/aXMylIK6Jw5gFnimq+MDW3e5d8KygZmUuWMyz6Fp7BGmt2YRqOxEmdLMFGM3swsS
         uK/VzF+SO3KWWl4hntIac9RzGtbePpyPezMa0pPvBl2DYmULsACFO4DnFgIfo7/DliAo
         gw0nkJWeoOVYChYYnxVGCyTb6ZNXv5LRiA8Sya5AJnyAbdHo6yBzmvN0QlfleeJokCWF
         OHr/8deYVELiRkV1OctJ7Voh2TOzD6Wo/cZU1BYeCjk6p8avXa7MLeHk7KMHLfCl3Rt9
         VkKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yyDMYIZDOiiHKTI5gIWD2Gm2cDPY/Cy3uyHGpaSuF9A=;
        b=nxhnSePxxkJuQYP1IGLW0lmANR430Y8qtO+ij3uWZkDa8VzZUi5evlAse1GK5cwM8u
         8PttTpzmDOFCus8JmIAyF7kenryVGL/zm98gRkzDPATTAOBVTC4hlVzxbW9oJY2N/KVP
         muSVQZEx5spd6NOR0L+Hewak1qpn/73srHKY6eLgsbU2rxt5nts61RSlkcpnvvAIPB7j
         gX8DALy/tquweDEwXkOb9cSRPZyllZBMbwkHV53qZR/nCwWUuQNcFUHW26CHC5d2eK16
         9OL6KLMhqY6bUbQB3W9GIJgOI1rkEW3RTrYc5dYVi0PqdCJu5GldJxKqdcrqBmkFFP9p
         Xj2w==
X-Gm-Message-State: AJIora8X73HaXseBjjSwJZmTrZstRD/uvKS+eKOVy14aSEP/PHWkMuKA
        g+d4E58fRypSNRrKwap/Zr5+7FNxHpwy+mTUHoCed501Byg=
X-Google-Smtp-Source: AGRyM1vO7sanL8pd0AwnVtpCWi0kYik7SMCpWtvFdoQ8bdQhpDBdqiF/zsjnWpWrHtkbp3HS77akfOCcfA2bhoytOj4=
X-Received: by 2002:a05:6870:6195:b0:100:ee8a:ce86 with SMTP id
 a21-20020a056870619500b00100ee8ace86mr20177895oah.40.1658205827433; Mon, 18
 Jul 2022 21:43:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220718132711.393957-1-fabio.porcedda@gmail.com> <YtV0YBzHEsXtOL5D@kroah.com>
In-Reply-To: <YtV0YBzHEsXtOL5D@kroah.com>
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
Date:   Tue, 19 Jul 2022 06:43:36 +0200
Message-ID: <CAHkwnC8yQ_W3kp1soZjqL0gG2qUmKFarq+SE0a0j16G8j0YOwA@mail.gmail.com>
Subject: Re: [PATCH v2 5.18 0/2] Backport support for Telit FN980 v1 and FN990
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Il giorno lun 18 lug 2022 alle ore 16:55 Greg KH
<gregkh@linuxfoundation.org> ha scritto:
>
> On Mon, Jul 18, 2022 at 03:27:09PM +0200, Fabio Porcedda wrote:
> > Hi,
> > these two patches are the backport for 3.18.y of the following commits:
>
> 3.18.y still?

It's a typo, please apply them on 5.18.y

Thanks
-- 
Fabio Porcedda
