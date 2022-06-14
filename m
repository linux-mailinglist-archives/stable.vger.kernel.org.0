Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F393654BDFD
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 00:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357291AbiFNW6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 18:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357265AbiFNW6b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 18:58:31 -0400
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B4152E49
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 15:58:29 -0700 (PDT)
Received: by mail-vk1-xa2e.google.com with SMTP id z17so4729463vkb.13
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 15:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UkqFbBi+A/2vE7M5pU7dTrJfpvUGAtZJJHYHvnAzjmk=;
        b=Dbnan30aVU1f+Qlhi2+AzU1+olG4Ud5B7u7/VNEhJgxdZeaL4I0fwTRP/ro9E6Nl2W
         mZ6VkHWXFImwa6PnfWPUpqYbPyt48d3KCQKBQM+kAWMPpxkm5dXZbm2Y3UzGqYu4fK1+
         SbaoIykbL2XU1sjDMaEeuU57xkd7BFOtFrRXTyKDszUpCGS4VupLvXtcrGXwMXyKjSFX
         DeZNadmAuace7c2DB+Q6DEkO5DXepc1PDrVwWYo+ycw8EqzHEJOErJtoGrj/ZKJJYAPh
         CmwNng/zgkZ9oNJtp89DmJNhlzD77ReGDJT7XqGv7w2MJJHfoYlSvsdP90tfOxPEpOAv
         yi0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UkqFbBi+A/2vE7M5pU7dTrJfpvUGAtZJJHYHvnAzjmk=;
        b=pGAQ6zO4g8xk6MJz6+OOuGLPNur4w/HdNQgZqqFTEv6f2LH0N3/fHO11b5+ySQds0O
         eQSEsfzo3ydJC82lj/2Dl0fiKUffX9KasaEgVhM1MQUqfhavG99Y3BZWSu+6V+Jf1mI/
         4s40r+ThGZMySA2v5znpXmELcp+FLKqYn66M7zabS7MB83hpVMi7wI8ZGlQzOwucx4dg
         Ycxr0x1uzqP8PSaKg6Zby2gYodWDHiwl7N4QP6DOg/vftMdlHlUcnOzwUe9qPcoFO+Qq
         JKX3lsLpzpL6UWR+intFomLmYnW1Xr7sEuE3nOgdPRS06kBVVr9ZjY8Xnu0S64CHoHjL
         4mpA==
X-Gm-Message-State: AJIora+2+KtpQm9K63d5Zz83zPYjuNUACE/cpBDfD28iqm9oZ1y3AHCL
        59q+m1L6bMntc2bCG0sjEg9D8mXCZvC6aiUIALFdWg==
X-Google-Smtp-Source: AGRyM1t8kCFiD9cxx07ZJT15xgPe5em/0yadhAjeoCHSbZFWtFEgdhq5cwRIVbU/WazUSt52P2U62+xJLn0q1bZbUtk=
X-Received: by 2002:ac5:c5b7:0:b0:365:1e47:aa26 with SMTP id
 f23-20020ac5c5b7000000b003651e47aa26mr3394774vkl.8.1655247508442; Tue, 14 Jun
 2022 15:58:28 -0700 (PDT)
MIME-Version: 1.0
References: <1655105678194169@kroah.com>
In-Reply-To: <1655105678194169@kroah.com>
From:   Martin Faltesek <mfaltesek@google.com>
Date:   Tue, 14 Jun 2022 17:58:17 -0500
Message-ID: <CAOiWkA8PR_jMznWrc=iHh7=nrOrjqUTPXiVfvjytf6QaU3k6sA@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] nfc: st21nfca: fix incorrect sizing
 calculations in" failed to apply to 4.14-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     groeck@chromium.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>, stable@vger.kernel.org
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

On Mon, Jun 13, 2022 at 2:34 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I'm working on this.
