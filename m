Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9F0513F16
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 01:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbiD1XgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 19:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353309AbiD1Xf7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 19:35:59 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D990CA94EB
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 16:32:38 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id k27so7218171edk.4
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 16:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vZkZ0XhSSLD3pS5ShqqGn4xdMdqnX1QQpEkv5r+Vxq0=;
        b=aNh+SY3S6Qr+nCCy38leBofJecNIFCMbyOD8y6gmiQ4d5WbF7vW1N8qNUsb6EBXce7
         yvvGOO1Ppo1youjaNAarYDxO1Z5Odk1oXvsLXoVRIr/YiEsdNL4aqqG+MqYpNhmX5MD0
         2AW97CgjayPp94H4vj8Rb/wRy0RvLswp61khQ0KQqYse5qaGadv89Dsl2CcZiWXTKMmG
         oN77OlMc9V0idPaYpdfycA/5vyCWvSKDoRGb8IypYeCBM0YLNTL7Y6ufpKPfFjps/4BI
         q7gm/qn4VBYRxvlxB1deAfnnpYJ12NvbRrG0iJB0AZ8i6r5WaIkhWWb5nuxkfYI7cHK3
         0OTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vZkZ0XhSSLD3pS5ShqqGn4xdMdqnX1QQpEkv5r+Vxq0=;
        b=2C/rarBk4ujsqVQKjchPHDuCzzPKGPzQvEZW3q32ALQ6KwhQ8obR8XN7g/hfBuD1fB
         6wai+p2qH4GJW4QlPTc/XMxuyFhJZImCWGwbEWXXZfsnsTrZn37Rzg9VU9MGR4yTFlFP
         rd6ll4FItSqh2yUnak0N3/S2h2JWFCIf+OlM3d+DbRu75Nba2ks3EVbVhWJ86JgrLJV9
         r/b43OEhn6MBTXi93+pUEcHiK46SEzUQojfRZFDIujlbfSL+Mf134wM3M8Ms/I+TsAB9
         4L6SFY5AvYjdwyE7FF9k2n1EXldC+cVcXpyP6pIdAwoHK0HE7UVxyevVpJ9g75oNthMm
         fxsQ==
X-Gm-Message-State: AOAM532L+xjzpBT3RWj2lMb7qqW3id/efpBSjaV2zNEQE/8IKsu51+TW
        tObS9mgnGttSM3AWzCrkY/kJk4GLMQnBYN32XgPSM9+AlQ==
X-Google-Smtp-Source: ABdhPJyqof4nzDZ969U2ec55p/9XaZ6kELcRuKfd60rhzl7YKT9/OiM72SxKCDpy0pLu66avQhl4qmNUXDMSySashwg=
X-Received: by 2002:a05:6402:e96:b0:41d:1a0f:e70a with SMTP id
 h22-20020a0564020e9600b0041d1a0fe70amr38739896eda.411.1651188757256; Thu, 28
 Apr 2022 16:32:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAJc0_fxu9ehTRQYZ2A-WYhQ2bfXHoQGc1XL0cOrYLRavLMj71w@mail.gmail.com>
 <YmPHaOjWuegSYE6p@kroah.com> <CAJc0_fxR1wND+GjQ2uASvnOoWNdN_r3TOKi2CAy+9UBjfUv32w@mail.gmail.com>
In-Reply-To: <CAJc0_fxR1wND+GjQ2uASvnOoWNdN_r3TOKi2CAy+9UBjfUv32w@mail.gmail.com>
From:   Robert Kolchmeyer <rkolchmeyer@google.com>
Date:   Thu, 28 Apr 2022 16:32:25 -0700
Message-ID: <CAJc0_fx8Lmi5d=CVA9KF6m7yxn+E0Phr1Lv=VJz1eCQyu4kzcA@mail.gmail.com>
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

I posted the 4.14 and 4.19 backports for review:

https://lore.kernel.org/stable/20220428232605.1231397-1-rkolchmeyer@google.com/T/#u
https://lore.kernel.org/stable/20220428232534.1230905-1-rkolchmeyer@google.com/T/#u

Thanks,
-Robert
