Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82AD94E8BEA
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 04:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiC1CKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 22:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236669AbiC1CKu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 22:10:50 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA12A20F57;
        Sun, 27 Mar 2022 19:09:10 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id f10so3228986plr.6;
        Sun, 27 Mar 2022 19:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2dCQ/vF0SeGrJ8RhQQvy7/J4z9rXZ1GpCIEt4kS4KPo=;
        b=OpLPgdYRINKmrL7xrgd2J14yQPwt0N31PsTWW0f4LeqVoQFCejx2P1LdduF4uzQOr/
         0zTTcpy+dRQtPLKvRVzNjl21DKeK57IX/2Nvy/q3D+7LP19rJaJxt/J0uYGvvWuOL83j
         a+IO9YnkKya33wo45XgG7GcqT/vu4m9+OAWARWJCc0a/qtSyEM9Byjjif/nk6CBSILYK
         lM6YrS2FmlW5iCXj/Nm+Ok2Y9tE+4uUUa2NjiU59faCRBFLSR+SSc+IDE4Q+AYzJ8Sge
         2ynH7aZRKcS20I7kMeihkjC1t5qbZ+Q9BSbnS2l7rDdKz6I5dXVz28YvU5RwPPydtdTl
         xmsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2dCQ/vF0SeGrJ8RhQQvy7/J4z9rXZ1GpCIEt4kS4KPo=;
        b=dZLMD4uiL76gVWss7V8nv1+8nVuPnzu1K5mmMe/ldNYyoZPSVHReU0Ay+OUPRSZ12R
         qEkgXmCqDnqDDuD+cHUjA49wedD2kuB1NRCvw5/UCw+xNGFAKQMLSjW4zAZEK2mg3o8k
         Jt8y1muCSC7UBgKukd4HXC+6nR377eYLONqOwxkFzpxpspQjAXRUqR4kTqgTDVt+fagv
         fMwNVD3FHst5bMzCl+ieNCdV/8VQamFNPYy7XE/8j7J0O6ayliHlMqMosoorjJlegQtL
         oKnS2KjVb9LMszh31S5ovspENaaxkWTHh/hg2e1nKISlK+YVb4Uk4NPCWTRT+Vi8vWzu
         wFMQ==
X-Gm-Message-State: AOAM531v5ZbhBMCw5Otwt0/Ov7IOZeTJ+7U+/sEHATspd/jQQFbW1aTB
        ItIQjDSZG70i+WAS6x6zx+0=
X-Google-Smtp-Source: ABdhPJyqaVpbob+fqPul71KENy+IsyImv0wRFpr7UNCtfG6Q1nwHd+/o9Att122DE+kpVOpKiFhwGA==
X-Received: by 2002:a17:90a:2b86:b0:1c7:6e7a:3e00 with SMTP id u6-20020a17090a2b8600b001c76e7a3e00mr34609009pjd.115.1648433350273;
        Sun, 27 Mar 2022 19:09:10 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id lb3-20020a17090b4a4300b001c726c65facsm18880311pjb.43.2022.03.27.19.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 19:09:09 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     emil.l.velikov@gmail.com
Cc:     airlied@linux.ie, bskeggs@redhat.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org, kherbst@redhat.com,
        linux-kernel@vger.kernel.org, lyude@redhat.com,
        nouveau@lists.freedesktop.org, stable@vger.kernel.org,
        xiam0nd.tong@gmail.com, yangyingliang@huawei.com
Subject: Re: [PATCH] dispnv50: atom: fix an incorrect NULL check on list iterator
Date:   Mon, 28 Mar 2022 10:09:02 +0800
Message-Id: <20220328020902.19369-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CACvgo50pK3rr5UH_FyfR1pADmPRjEawi43cAecoaz7nM5AFgBg@mail.gmail.com>
References: <CACvgo50pK3rr5UH_FyfR1pADmPRjEawi43cAecoaz7nM5AFgBg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

on Sun, 27 Mar 2022 16:59:28 +0100, Emil Velikov wrote:
> On Sun, 27 Mar 2022 at 08:39, Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:
> >
> > The bug is here:
> >         return encoder;
> >
> > The list iterator value 'encoder' will *always* be set and non-NULL
> > by drm_for_each_encoder_mask(), so it is incorrect to assume that the
> > iterator value will be NULL if the list is empty or no element found.
> > Otherwise it will bypass some NULL checks and lead to invalid memory
> > access passing the check.
> >
> > To fix this bug, just return 'encoder' when found, otherwise return
> > NULL.
> >
> 
> Isn't this covered by the upcoming list* iterator rework [1] or is
> this another iterator glitch?

Actually, it is a part of the upcoming work.

> IMHO we should be looking at fixing the implementation and not the
> hundreds of users through the kernel.
>
> HTH
> -Emil
> [1] https://lwn.net/Articles/887097/

Yes, you are right. This has also been taken into account by the upcoming
list iterator rework to avoid a lot uesr' changes as much as possible.

However, this patch is fixing a potential bug caused by incorrect use of
list iterator outside the loop, which can not be fixed by the implementation
itself.

--
Xiaomeng Tong
