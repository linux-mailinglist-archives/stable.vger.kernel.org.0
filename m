Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862E6532255
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 07:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbiEXFEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 01:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiEXFEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 01:04:46 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A526B7DD
        for <stable@vger.kernel.org>; Mon, 23 May 2022 22:04:44 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id a23so19521761ljd.9
        for <stable@vger.kernel.org>; Mon, 23 May 2022 22:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hcsdovZexsweBQgXsrS9TmegcFHPxrc5+tTSlWIXW4Y=;
        b=Rqw7Z0Ir5nkvK4Idoj3QXs3s9WergRPxhCXYD+ydlB/0tBWWFtDhn4xp5mgRQwH/qN
         jHz8p72CoULg/Mxegm3NYNTOkW9KEYd0mYk38+Q08urVxzE1G5gdKBNtLgrw9PyoZ71e
         NoYQ3q2DZ5vDFRu7psPO9x1gObUKxyUQ9ddZRx/8eaX61QPWccccRToQ75szYmNqt73k
         kbRtnCveyJXk10PdfqowxHCn+7BsYy3QT7m4NGjduf/CYFxyG7rrTUaV8rCxRuWWG+8m
         eK1e5Y9mS3EzW14ZTk7morN5ZH6yzZPNgvGySU/hTq981ffqLEcb/dIFBSdChFn/Imel
         F3Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hcsdovZexsweBQgXsrS9TmegcFHPxrc5+tTSlWIXW4Y=;
        b=xtmcFvvl3txfkKPheuXzYrXe3r6mwCsRDfVxQSqC1Dq0HWuHAWgk+XXmWyZEwoikBB
         4wkLrdQ/tr874w4EeYMmbImnH4LLwf9KoyG22G7N2Wi64jDkAjVbtErtiLtDoU8puEvR
         iCjPRHMUhuoTae5OY9ztW4JQ622H4jjq9i79X29Kq9MMOVCIrpvnUoLd6kELJUmAx9I8
         Oi8uJ36hIDgU9PLPO+vc9H8srHRBYFhXisiNj6l5AHAOP4vGd3RDK5di+R0nbu5O8jOs
         BlfPArQ+rlV25B+YFu0a4wt0gcwp5e3WVyKLgs/IOQmbkefghrPy201Zxbz9P4w5xMkQ
         K5mA==
X-Gm-Message-State: AOAM533thDhm/O/Mtas4B6XK84PwwDRawqwPKu592G/umwl8EFcBBY97
        wCm8/W7Zx57s7oKpBl3xQzKzdrfvLo8cxsC7Tcm5x93/oLQ=
X-Google-Smtp-Source: ABdhPJy1k/SDPQe740chOuCaYYFuOf6Xf/dVfQfJBFO+fnbOySkMI4/ez2ClSzl8ZSTuUe2OZz0X0rH40ZXaB/DMwvQ=
X-Received: by 2002:a2e:a801:0:b0:24a:ff0b:ae7a with SMTP id
 l1-20020a2ea801000000b0024aff0bae7amr14398870ljq.287.1653368682530; Mon, 23
 May 2022 22:04:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220523165830.581652127@linuxfoundation.org>
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Tue, 24 May 2022 10:34:31 +0530
Message-ID: <CAHokDBm97f0imdhj68SFUaFf08HrJsA6T4+6xMshug5UpKYadQ@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/158] 5.17.10-rc1 review
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
