Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8EB6C5514
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 20:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjCVTh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 15:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbjCVTh1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 15:37:27 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A781689B
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 12:37:26 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id d75a77b69052e-3ddbf70d790so122251cf.1
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 12:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679513846;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lNVsNYh6JoPrV5IHkxgV2l73cv2tbbHB07JTEyvxp44=;
        b=hTVSrVBSnqcl1AS7fOTnZ4FEZF0du2qelbszbArAmNxUp9O1erlgChDNl4uSKHsEcD
         OHk+fnaI6ZUZQpWardD0kgJpz0IUGqs8sI34GS61TwLp7vHGB1HaaF3v0Pp92F+c8K09
         1BjIV8k9G6900MUcvxkCjRhckfhZClyqSYh+l4bSz7UppjMuyhMrOkyGw1t6LgUOOVTX
         xTfK4sFX1H3gxkqle565QkA/KbzBt7lX1XwwZeoiTPNq44Cpy+iI5akWpfA/s5QY1JzU
         fQT/RY/x2PgwZ91YtGUEpMrusuJ83F2whHs2AHDESMQ1Kwu40K55PY6RtfqYlEzzEDH6
         VuGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679513846;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lNVsNYh6JoPrV5IHkxgV2l73cv2tbbHB07JTEyvxp44=;
        b=4az2kap/RDl9o8YPg+2H2un1Kt081nKoybAo2tMpEf9E4B00uBb8acpzpClwd/1WDC
         zN6Rb9qjAwsqnS2AkKuAyf5AbxHoSlV9neacsOpenBWGJDytWEpSM4aHnQb3PgBYo5Y2
         H1smOmhP4p1M6XZfucbDL0HOlAZ+Ho2ouO07GDGHKUt1w/Z1yUm29+ZEl1m43wmis1BC
         u0/IEnObRTwf//cUfv/vBMrhycF7O2yzArdVe/8Gdyhh+2p0cKExzb84gMn6R13X2TfN
         bOWA1YVV+oPhEhviPriFtKRzPOi+mN5sYhe+G+wLWX5v+RiZu6bKBgj5PCJ2LdTtCUqN
         AMSQ==
X-Gm-Message-State: AO0yUKVJzktqvs105Yq9bpUnEFZ5GrawSQSAVqepdkEy0Q98zop0AYtk
        lw7wjhQNP7cbEfxDd9RAqV+h0gkhaU/MhBn4VSloOQ==
X-Google-Smtp-Source: AK7set/ZER5yHB2TrKs4W9PR8ae5zzKuL1Ra12hy2uSBMqX5kn823LNLUm+W6EXVTMffDFJB4WuKqaoyWFgPAMHTk7M=
X-Received: by 2002:a05:622a:181b:b0:3d3:fd80:b06a with SMTP id
 t27-20020a05622a181b00b003d3fd80b06amr18884qtc.13.1679513845807; Wed, 22 Mar
 2023 12:37:25 -0700 (PDT)
MIME-Version: 1.0
References: <CANP3RGeiFUsO4X_qQszO5JRY7UDSQVxuC+57aCscL0p+dmjyKA@mail.gmail.com>
 <ZBtVXJVi/zKb8eAk@kroah.com>
In-Reply-To: <ZBtVXJVi/zKb8eAk@kroah.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Wed, 22 Mar 2023 12:37:15 -0700
Message-ID: <CANP3RGcHDjT1r5kwJRscy3r2deciKDqh7R92we1+eGUvcPbiUw@mail.gmail.com>
Subject: Re: 5.10 LTS - Request for inclusion of getsockopt(SO_NETNS_COOKIE)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Greg Kroah-Hartman <gregkh@google.com>,
        Sasha Levin <sashalevin@google.com>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 22, 2023 at 12:22=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This really is a new feature, why not just move to a new kernel version
> instead if you really need this?

Oh, come on, I *know* you know the answer to this question.

How's your effort to get device vendors/oems to use newer (major)
kernels on their devices going?
Cause I was just recently *forced* into supporting 4.9 for another
couple years...
It's hard enough to get people to take stable version updates in a
reasonable timeframe.

We either need to get this in via 5.10 LTS, or it goes in via Android
Common Kernel...
going in via LTS always seems preferable to me, since it benefits the
wider community.

> Please always submit a working backport here, we can't use random git
> commands for this type of thing, sorry.  That way we can all properly
> review it and verify that you sent what you want us to apply.

Done.
