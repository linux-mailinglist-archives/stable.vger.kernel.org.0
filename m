Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D1450E687
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 19:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbiDYRKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 13:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232151AbiDYRKf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 13:10:35 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563ED27151
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 10:07:30 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id r13so30903829ejd.5
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 10:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ywjMxyzDoBz8KAzBQy+gO2304Lymg31mfSsXobz7mSI=;
        b=eHnY0LwNdnAlMwVtRKdO9Zs/ZXC2eIFfzm2La4BunN3SGYIhQGLQsLqOuZMpCaESMY
         XVQgh1gXtyQuPhuosmf6ZaPJu/ULb2XAwDiO4bQsQtCQtmUQP6GjUk4eHWEUcUg/Tpgw
         coSd6wxkCoqrYXL5XZ/LWfhlBNblZjwo56ssfI7QGTn+qWLYW9TgWtGoGbxCh0RAOMOP
         J7+wPG3TTNkZXNRS4YgJpsSaVOnijciSxA48A1hf+thdSQosZskhyJn6tJj28efhGSkf
         hrimATu4FxG52h5I1dHVMSkQYJRZ0I2NGwYMiJQRjByh8lNswUoF0CRNB6kUt6JhxKg2
         uYQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ywjMxyzDoBz8KAzBQy+gO2304Lymg31mfSsXobz7mSI=;
        b=ZeIuL/yVlRwf14fQb/KTEAvq1UGfvNbQn+Tnkgq7m3/3BcnUUmyGVq5JgRLJa4L5yw
         noFFul9DqqO63NZPdqc3YFQulfThISpKzoCUB+lGCBaL6A7rhuKqU4DrpF/Muj1KnprV
         TILrOAJVYQHCp9IjnV0DUxnThcgCax6QXG1l/7gBKm27fVZS3nO5JzUh8TezA4YpUoSb
         TjpG7DW16SBSFPw26q1VI7P1GXJJP2zXRKydavUqulqPtpM75VHGiVNRnk56OWFxhcEH
         UnyXllt2j/LeOimnoNRg3HOJXcPbQxycFMtA+zt4kGODaecHiMNbwS28ohf+XeMQvRcv
         Lx3A==
X-Gm-Message-State: AOAM533uNHpqDDSc4nQGviKsQ2VyrXR7oYKc9etxGnSpSMEHMy9RLrZp
        QkRq0BHXgnIFRCs4xPTVzpn7QqvoX3pJsuSIcGKo
X-Google-Smtp-Source: ABdhPJw1Tm1H4wJQ/5m1AaOXUTjGLKaMyQUlaS/RRKrHIXtxZiuPomkzQhCR+/sKByBOH6sllWTADVhfya+38jMBtTw=
X-Received: by 2002:a17:907:1b19:b0:6f0:1022:1430 with SMTP id
 mp25-20020a1709071b1900b006f010221430mr17678057ejc.13.1650906448625; Mon, 25
 Apr 2022 10:07:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAJc0_fxu9ehTRQYZ2A-WYhQ2bfXHoQGc1XL0cOrYLRavLMj71w@mail.gmail.com>
 <YmPHaOjWuegSYE6p@kroah.com>
In-Reply-To: <YmPHaOjWuegSYE6p@kroah.com>
From:   Robert Kolchmeyer <rkolchmeyer@google.com>
Date:   Mon, 25 Apr 2022 10:07:17 -0700
Message-ID: <CAJc0_fxR1wND+GjQ2uASvnOoWNdN_r3TOKi2CAy+9UBjfUv32w@mail.gmail.com>
Subject: Re: Request to cherry-pick 3db09e762dc7 to 4.14+
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Did not apply to 4.14.y or 4.19.y, so can you please provide a working
> backport for those trees?

Sure thing, I'll give the backports a try.

> Queued up now for the other trees.

Thank you very much!

-Robert
