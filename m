Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9FD2021DD
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 08:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgFTGTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 02:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgFTGTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Jun 2020 02:19:03 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF22C06174E
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 23:19:02 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id k11so12611575ejr.9
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 23:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=QbzYUcCQzxBdKE6nLnsxzPy3Ai/pV4moAOTMQoTtW3U=;
        b=bWYGcxAZkRTw/qIJM5mb4zi6sKb89Vp1rys8/PIl+BsAldwjqTxJCeB7OJ0Nz5rysJ
         I5CO83n85Tc+IAMoIFouFJQvh8iOvv88hrMBFVAqOAuBOwZuMYTpjX6uVv4eW8ITY14C
         9W/kuPb04WhRqlU9P7xD9/JK1QmhgaOBMrWxi7BtVFNe1wmLKTR6eveoAVQHnhbiVYI3
         YiilDEj/sEt0CgXqHN9Kom2bY78i1lUwhNudLg3cG1zvAypzMkzttx0mXXz0glkZftNK
         OSCOpasZ0xQRF71m92Tm4HR/RHxzFJa3Qm0ERiVpwZBy9bnQJRV2jGrGdViBSD8I/pRd
         Ei6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=QbzYUcCQzxBdKE6nLnsxzPy3Ai/pV4moAOTMQoTtW3U=;
        b=KSsfHNcHdG8rJtkdiiU9l4+LKt9a8W5EtzPUoSB5dTO6ts6GGPNkN25U72pXdHnSLF
         NwXGtEArJLmuEjlD9hO3K8YiFhDxQg1KPTiTu1MnpIlQVnkk3mws57/SWt2h0rTnU+Bc
         dbl6muW7eObw6xYZSCkRaL/Gaqhyj0bXkR9jftzSm2mOhPhh9SJ4FaNTUzJ/GIFfoz/s
         pIUBIm75r49v3OJQ4Y8G4Vu5c+zF7AhrvgV6SWD0qPNzpJCwOZSsHYzBvugc8SfbqenU
         IPHD1b2Uaagr9LNaFsZfkIQpInZUJo2ycxXSv6v01LWWH4HJO8kNXK8+Mmm6tNsVInXC
         PVHQ==
X-Gm-Message-State: AOAM532tfV6AQi39nvq1L4bLsZLhgnNt7LkOMEnsjQJKjsIR+DZKbjGm
        E1F036yBHrtHhpp3f+JmhSrfzxev3cu6hLMj6JNoJ2/i
X-Google-Smtp-Source: ABdhPJxvXkbndgPMZCRauTh3a948FAEIVC6EchUFo6v/yZwOlr/qJOS0n/wuDfu4dgbK5hPjuvm+fLTy/71JV5qWGAY=
X-Received: by 2002:a17:906:1c49:: with SMTP id l9mr6508139ejg.296.1592633941500;
 Fri, 19 Jun 2020 23:19:01 -0700 (PDT)
MIME-Version: 1.0
From:   Charlemagne Lasse <charlemagnelasse@gmail.com>
Date:   Sat, 20 Jun 2020 08:18:50 +0200
Message-ID: <CAFGhKbw03b1MB8Q5nuMo+7KqUC=-ZhhdosS3ibB2wwzunSstOw@mail.gmail.com>
Subject: Linux 3.16.x EOL planning
To:     stable@vger.kernel.org
Cc:     Ben Hutchings <ben@decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

https://www.kernel.org/category/releases.html marked the EOL of 3.16.x
as 2020-06 and the main page has an 3.16.x entry (3.16.85 from
2020-06-11) marked as non-EOL.

Will there be a special EOL release (3.16.86?) or will 3.16.85 just be
marked as the last release at some point?
