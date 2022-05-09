Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01BEA51FF14
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 16:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236562AbiEIOG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 10:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236651AbiEIOGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 10:06:54 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E051FB56F
        for <stable@vger.kernel.org>; Mon,  9 May 2022 07:02:51 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-2f7b815ac06so145574067b3.3
        for <stable@vger.kernel.org>; Mon, 09 May 2022 07:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=deN5QvVvswoH9XYBaP1Q+fVKPJFSMrTMILZDXRWnG0M=;
        b=JXp/7OA11XAyBhT2zOubWHp+WvmCG7N+NZFnqEChNZAL1XzdDVpIWZvr2w+RegGWIz
         nn45DJxAij9FgTvgNpYczb2DKvhy8iqYgKnNyg/LcIKngZo0RogErzvf/rEIYu9O7Em/
         QgChmj9vpRroKkCxoC9cv5xsMKFDJdh1KQHJO++EFA+T10v2boZ1leXUXGgg+8yOw8Af
         IpspjYVU3BtvzP1H09eS5kRxv91NeFwDNETpiSRDBMUy+r1MiOLWKXz8QArz5UqemQad
         W+SNh3dWddBHFtgUwjGzQ2qIM7mKpo/5dlz2HEq3dzdxMjYdzj5NzQZpIqc1OaWIIlPd
         oniQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=deN5QvVvswoH9XYBaP1Q+fVKPJFSMrTMILZDXRWnG0M=;
        b=13+YVKWoiFxENJiJxowqbWT4vFcXpuxGvSjcw1P7Osh7cMElmyx7tgp7N97QUgTqyn
         cgkmxBUE/E2sc7fCUesSEc++COEiS2LJ5JC06oGSDU10hGAoGog0bm6QDjddv80gEIyH
         wr/dVpZO50FkiKwRgTUdPsXlpwozG1vB1aJ36Fy9pvjx7Ff7AQ9MBhdK2fKSHN4J9PL7
         ZAOOUAkGHS2nLFUQARyil274KCqIWbkjhoYb/dzHtw2R38yLiioouTcc8zpLr2nONBJX
         Jdb0p6LAVlfovpCJrjghpmSmb+KbzAbOzrawzU4Qad75UzQ6we1l0rsfMMvCOplr2K5X
         upFQ==
X-Gm-Message-State: AOAM533DDJ8UdFqjwBnxGXZkaWIUYX9rWCd9nW7H4Jbe76AeTFSylElH
        jHDQ/iJWN3EmtFN6tK/LDHhOL32JHSEQ3ST9okfhLULJPq3itQ==
X-Google-Smtp-Source: ABdhPJzTsWFuNO6RQPZ2TSj+M2vnb+KxtrJnHcKEsbU0UX4+RU4atUmiveT8ee3gYR4CHg3cBwW3GtnWkKfflZTzCJk=
X-Received: by 2002:a81:5603:0:b0:2f8:3187:f37a with SMTP id
 k3-20020a815603000000b002f83187f37amr13657483ywb.255.1652104970291; Mon, 09
 May 2022 07:02:50 -0700 (PDT)
MIME-Version: 1.0
References: <16520932588119@kroah.com>
In-Reply-To: <16520932588119@kroah.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 May 2022 07:02:39 -0700
Message-ID: <CANn89iKEdDUtLigQU1KZtNRbKw1_wQnAF5WZL9dWJFk-mMxc2Q@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] net: igmp: respect RCU rules in
 ip_mc_source() and" failed to apply to 5.10-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     David Miller <davem@davemloft.net>, fbl@sysclose.org,
        syzbot <syzkaller@googlegroups.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 9, 2022 at 3:47 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,

Thanks, I will take care of it.
