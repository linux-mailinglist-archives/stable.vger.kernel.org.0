Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A669D6E9A2F
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 19:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjDTRCi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 20 Apr 2023 13:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjDTRCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 13:02:36 -0400
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E961170E;
        Thu, 20 Apr 2023 10:02:35 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-95227e5164dso26662166b.1;
        Thu, 20 Apr 2023 10:02:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682010154; x=1684602154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i/X+o+ftAI89fQ1SMw4xknkK3QSfyh6NWxdsWdhV5pA=;
        b=hRGS0SYLZy7A+80U8RFRmCUps9d2LP7vgf9e8Egn9f5jnISkU+vU/JMU9L/PXC/9+q
         yih7sN+0bUspnBbSLWB8waJlOIQcs+V8q70ezFsrf3Fj1B3CGKYBZui1Hoy+Pj8yd6xj
         7qz8P3D7TImBSk3XxDSFHUq1oD4HcFqfsFAPyajBqIbQV7SG6GYEhv/r1JLnRPb8SDUy
         4wkRp18eXA/Tx9iIQiDRwXXw90hi910841ntOYMkyS2wxXhoMUE2ycAvFlPs9TaiDJTq
         xypgoM3HsJkgB+EUZIdCU/vmOdGHhg6o+DkMwqClSLcrFWVNInhPufVVdaxePgbblIrv
         T9LQ==
X-Gm-Message-State: AAQBX9cQOKH4c9noAtkZew8y/auRe2FXbGEaT5JdAfsREK4WSgeqZWOY
        1AFUvne3s93P1TMgcWrgUHzlLxz62BGks+68/C5EGLG0
X-Google-Smtp-Source: AKy350ZFH1Tt+q8YX1WHoBz806x7CQv/s/ou6r5uAf+z2BkK7q2sZ0n/8p1XZqIJXgo3lVIEcezdsUSN1q27hLkked4=
X-Received: by 2002:a17:906:b6d3:b0:92e:f520:7762 with SMTP id
 ec19-20020a170906b6d300b0092ef5207762mr2017199ejb.6.1682010153758; Thu, 20
 Apr 2023 10:02:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAK4BXn0ngZRmzx1bodAF8nmYj0PWdUXzPGHofRrsyZj8MBpcVA@mail.gmail.com>
 <2023041711-overcoat-fantastic-c817@gregkh> <CAK4BXn30dd3oCwcF2yVb5nNnjR21=8J2_po-gSUuArd5y=f9Ww@mail.gmail.com>
In-Reply-To: <CAK4BXn30dd3oCwcF2yVb5nNnjR21=8J2_po-gSUuArd5y=f9Ww@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 20 Apr 2023 19:02:22 +0200
Message-ID: <CAJZ5v0g+PAOZs47LCrxRswZoCmHbGfBg3_cr13Y8zWPXDjgm3A@mail.gmail.com>
Subject: Re: REGRESSION: ThinkPad W530 dim backlight with recent changes
 introduced in Linux 6.1.24
To:     =?UTF-8?B?0KDRg9GB0LXQsiDQn9GD0YLQuNC9?= 
        <rockeraliexpress@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CC: Hans

On Thu, Apr 20, 2023 at 6:38 PM Русев Путин <rockeraliexpress@gmail.com> wrote:
>
> >Any reason why you didn't cc: the developers of that commit?
> Sorry I did not realise I should have done that.
>
> >Do you also have this issue on the latest 6.3-rc release?
> Yes I have tested it recently by installing the latest 6.3-rc7 kernel
> , and I do encounter the same issue there. I have linked the
> screenshots below referring the same.
> Kernel 6.3.0-rc7 with 43% brightness - https://i.imgur.com/5LqsEJb.jpg
>
> > That's what this commit does, right?
> According to the commit , it was pushed to fix backlight controls
> which were broken on Lenovo Thinkpad W530 while using NVIDIA. It was
> not intended to reduce the backlight intensity on W530. Backlight is
> dimmer than before even when using the laptop in Intel iGPU mode.
>
> Thanks
