Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2EE6526F44
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 09:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiENGMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 02:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbiENGMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 02:12:46 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3D8E07
        for <stable@vger.kernel.org>; Fri, 13 May 2022 23:12:45 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id i10so17721995lfg.13
        for <stable@vger.kernel.org>; Fri, 13 May 2022 23:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hcsdovZexsweBQgXsrS9TmegcFHPxrc5+tTSlWIXW4Y=;
        b=ZLXer9DgWEe4b90m0BP6PtIzTw4hHIo8FNUKosyGoPlE6+2pV7ezzjblj3sMH75CKw
         cufQJDq9tBKYMfdjDkQkmw6uncsnJsepGC+m/L94diagrA6WkQIEWv2julxvTgTMO8p3
         TBjgiRNmhv02UudoDs4a4FxMTrM2syNukwwQGKJ0Qoqv21LEsnaO+rRwR9tXt04pwW2n
         AO/lHSTErhvMJnAG026c3zpnC3xKlkog37J0a64YeW8lQ7VtveEbKWhamjV0gTyoC8D7
         4FpkF+Yrqu/XUWbwkMPhUvsSR/Ca9KQpvO0aEJ+6Y5J+dQOubIRFfU7/QpQXU+RjRqqb
         C9yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hcsdovZexsweBQgXsrS9TmegcFHPxrc5+tTSlWIXW4Y=;
        b=X2dNhITIuAJsRBim0XukUsbIkbSGCldS7Mbk2xVyOfU53hxby6zh3E1RWl+5BnY97O
         9cPNjB+9wiJswsuATZW+BGv5EXzdYi/X4mOYLG/S4veukKIh5idZMJ5OkkntXqYMhKhe
         JjE3qgGpwC1Re3Ed06aRAaA0l8rqGavFw0vIKwWv5s+7BycPbYqtBoBAw2WLhBSl7bOT
         mXBsPyPkKtBgt97idxx0+SQXo/0cAYWK5sgshgaqmmWf5Z3SJqCikjmllnbIBouMmyM0
         sWUh6QMQsuBZqQoiKt0g6kP0gkLRTyKxvIuLxMWxmHRhuCE/YgupLqMJFsharH+6F7zc
         CbNQ==
X-Gm-Message-State: AOAM531W+4ZMSYUiZ2ZvZjsqI/DRrghdnTymxEywhBHEkZ4uIhE/s+BW
        F8B88kAkDNPYvMOQoYQo4SUIPLK3iMgA4qIYhjXcKrO3ZkkrnQ==
X-Google-Smtp-Source: ABdhPJySEmeD51QmZADIQlmWq43na7jdHTkgJAKhBGRejdWyzAw8MMg8CNtivZm9WRR+4IzkFHQYWwRiU2aRyQcHtDk=
X-Received: by 2002:a05:6512:3b84:b0:473:a5e5:165a with SMTP id
 g4-20020a0565123b8400b00473a5e5165amr5731060lfv.417.1652508764025; Fri, 13
 May 2022 23:12:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142228.651822943@linuxfoundation.org>
In-Reply-To: <20220513142228.651822943@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Sat, 14 May 2022 11:42:32 +0530
Message-ID: <CAHokDBmVJK9hY=fcLV_M1ZroH6kOnOZgcSmSfb1YRGhAVY4qdg@mail.gmail.com>
Subject: Re: [PATCH 5.17 00/12] 5.17.8-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     skhan@linuxfoundation.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg,

Ran tests and boot tested on my system, no regression found

Tested-by: Fenil Jain<fkjainco@gmail.com>
