Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940BC407935
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 17:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbhIKPyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 11:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbhIKPyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Sep 2021 11:54:37 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9070C061574
        for <stable@vger.kernel.org>; Sat, 11 Sep 2021 08:53:24 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id h9so10799058ejs.4
        for <stable@vger.kernel.org>; Sat, 11 Sep 2021 08:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=iFi12TFf9Jx3ONiA8xJl7ZrIZ7seeLdaZCCOQnGVeUE=;
        b=XFKo9quL5waVkd3RQ52jCoZxn8toHyPkmUxx2+JVZR9qfAG5210KlrYSQg6BGpNFT8
         Q+d2THoKu785V3cjUzeH/kkkZSp3xeH64XZWh5PoDJZPWxy6BU7X6mzaQZ9L9DNp9/PI
         pAMG+SadKiZvcPR7F8zdmMlEcDLifs/2DaGbY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=iFi12TFf9Jx3ONiA8xJl7ZrIZ7seeLdaZCCOQnGVeUE=;
        b=tXWZMj157CGWKmgQhA1X0bKlbNPb95SGld4mKxghSbo8rI6KcfMSaoASWez/lGAY+c
         geB6y+bI5+7ZpYJfNAbgQwRloER6fFOgmoF4y0oQBa8Kuq4HI4kxJECLjrEx/O3fbuwO
         HdvzUahg3KL9FxRZ02COz0yMX6l7r3CZ7CJwOPcG5N7nLY5xMRqz5H4sFtPOS1nV9LgC
         /NnNMZ1Icnsy41UInz/nU6r5dWQz1T+nOxsM8eb6LuYQunjaZY3C06UWsMdpJl0VsRE7
         IuYUXqC4m4WYug+1c/ZJq0ucw8PoWelJ3iGhCNV0emjnA5OAjPigb4NbnR59tk0e4fkk
         KGpQ==
X-Gm-Message-State: AOAM531lZUZ7tuJnDLNmZQ67U+gF56rgqNdk8UasWGnRNlpKyW+B6l7y
        n6yikeUl1hlK4Q4yfzC4jb12lSN9jCdW6f9bNo8wrmjYcTWlmQ==
X-Google-Smtp-Source: ABdhPJy9Vre1XA7Ic48+KRT5XVm5POo7ks2972vi48EvOIxhfK5GLGOG6wDB4DDoVtPk17jGYgWjUtvY4EaBhnFaaa4=
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr3402379ejc.69.1631375602893;
 Sat, 11 Sep 2021 08:53:22 -0700 (PDT)
MIME-Version: 1.0
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Sat, 11 Sep 2021 10:53:12 -0500
Message-ID: <CAFxkdAqoFriQQ-9udv4aXWh=FfbKhaWfULFOQmHzyYETr_jYtw@mail.gmail.com>
Subject: [PATCH] iwlwifi Add support for ax201 in Samsung Galaxy Book Flex2 Alpha
To:     Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2f32c147a3816d789722c0bd242a9431332ec3ed upstream.

This patch adds a missing pci-id to support the wireless device in the
Galaxy Book Flex2 Alpha which is shipping and in the wild. It has been
tested to work on 5.13+. While it has been shipping in Fedora kernels,
Samsung and a couple of users requested it be added to stable.

Justin
