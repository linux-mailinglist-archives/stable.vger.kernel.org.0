Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2704B3BE454
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 10:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhGGIaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 04:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbhGGIaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Jul 2021 04:30:16 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BAEFC061574
        for <stable@vger.kernel.org>; Wed,  7 Jul 2021 01:27:35 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id z9so1679540ljm.2
        for <stable@vger.kernel.org>; Wed, 07 Jul 2021 01:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=ZM++XRpukVjBicD5uP3vvc1/eFsxUyUK1LYgFb7gn38=;
        b=DucAoRiKrvVMkrgkQ9XE9wIrs+vq0U7FByxVz4bfd/iVHq8O+EeyKxMUUJooK1aeEK
         yMm4sSL6K7KZJIwr/69N8HwPdY6ks4Cjd1wl8OD2glUog/MLP7LXRGpemZ82FBCu79Ul
         IXIL2Ggw4Q5/WZMbGvVtQfSyb733okqEia1AgtanpwZHfmLEBUCQUAf0YDW0awaqghTQ
         MJs7GTqwUiy1uHlH+Cm/XbC1mX961LRzvAVq017jaUPyjGsf2VzsQd2qtuN+yepstXNE
         wVmljYwC+ToDO/3pS04QyB8HtJHOTF786hNc9li2p2FsKJZRtwK4le6sIicU5NDPjx4x
         c93g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ZM++XRpukVjBicD5uP3vvc1/eFsxUyUK1LYgFb7gn38=;
        b=KLK9KfKrc8eTqCrR2KCpDIADgHCW+wEfpm2Db+syNgk9n7SKqauMmdbkznGQsPEtRH
         YhAH90VSQULj8f4W45Y6AfGRelEhiKeZj4p+1rbTgZZFf+8mB3vO0je8jknBeB2ANp7x
         EYbPdODxCpdC3WbtSO2eJsXQe9gtdOosee9bP+JddveO6ZUhKGoAQaNAZ1VKBvctt8jO
         DkEEW55ef/nG1RS+Qae44BeCjIb9ZVTa7GrZSkMPQ8mcPlrLh7TNrimroeUXAuIrdNq0
         akPdIdsL9bl6Nf1IWn1uJAmP+Tg+iBTeFWlUFSjaSsX128s79jxIdyATf/KA2pmHpJ/+
         lP8A==
X-Gm-Message-State: AOAM5338REjHK5xtl3sy0CqVj7y2Xp2om4AxBPhY3jVx9dMvIJAPKdkS
        ieTsPyAzvnRJciL7yE178eUWL2n+rq/tInx4L1WiFh8eRb3f9g==
X-Google-Smtp-Source: ABdhPJx0VYwxnHhDpnshrjU55KKgxz9PFlNUoU0mqRDwglLarmq/Bf8Q8Ibl0jXpJFnus4pSafVZFyRjqoXYo9Egvjk=
X-Received: by 2002:a05:651c:2115:: with SMTP id a21mr18426962ljq.185.1625646453683;
 Wed, 07 Jul 2021 01:27:33 -0700 (PDT)
MIME-Version: 1.0
From:   Beatriz Carvalho <bcarvalho.ic@gmail.com>
Date:   Wed, 7 Jul 2021 09:27:22 +0100
Message-ID: <CAGgEMaA95w6h3RVQ3QqrWUW-Esu9c6iVgdGpU_48Vb5h2S444w@mail.gmail.com>
Subject: 
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

unsubscribe stable
