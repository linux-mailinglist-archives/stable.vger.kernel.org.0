Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541161F8ABF
	for <lists+stable@lfdr.de>; Sun, 14 Jun 2020 22:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgFNUoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jun 2020 16:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbgFNUoQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Jun 2020 16:44:16 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F58CC08C5C2
        for <stable@vger.kernel.org>; Sun, 14 Jun 2020 13:44:15 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id s1so16760240ljo.0
        for <stable@vger.kernel.org>; Sun, 14 Jun 2020 13:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=5M48B4L92DeZOP5t4irBa43CHn1nEXUvPd4V7AjWpmg=;
        b=mnYzMlIssSrOfqMkbiMQRw/w1iuBn/lmD7GIhxrrJq59vLofDZUt8aTjM8oXcbsNe/
         34oKT42xfBW4QScNiuwhJ11PkGYKPN7CsKVKnri8lC/0glLGF7dzKSBf6Rb0hee2pZYR
         KDJlEPFh5t7KQXFX2AMTPb0b1S8OGRIi8cPCTM0sb5RmanrDpzRktgNNxFIX/XHnXLjk
         HIfffUzt3k7Px2WQb9PAFxnyt8nh6TEuuI1TP+jDQIO2NwL7pTp7BLCv9D/YY1kcgihE
         vgnn6tQSBuZxAmigmqHm/w1DouKRR7DTkIh+yREHY2gQE3UA3XKyhWHCJPV/Lj475hGx
         wiIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=5M48B4L92DeZOP5t4irBa43CHn1nEXUvPd4V7AjWpmg=;
        b=ef56T2flKFsHdLBvVinm/QjME9Fx7tdM+786IzAlyGfHs1Zr7BYPEXrsEW0CVGKcmc
         ZKqPtSXOD6e39zQ17ijGozeCdFymLP2wfs7BQQ4IUxfWZsu7TJRTu1xKYTngAPkkBw+c
         Z9AHpOEYLoPJB/lLuK6mEb4snBHjfThI92cMB1T3MqL7quzlHS1ExAZ59I4AMzRiNpnn
         9rPlSf07DkrnB2UilUXlsCVXo939SmQZ8zSTG80V+FLfcQh4UR4KKb5WqCW15pifn7Tt
         4MR6g58PoOPz0T/Z1BIjzCpzuiG8HJBI0BGW0revtNzSsNelD9xgdlDqBdSClLM70wDw
         SStw==
X-Gm-Message-State: AOAM532M2ROGzfBHOhnEsa4Or0EiXYnF+w9vFg3QDf1NR0IHaef0pKCa
        RX54z3+JH757mQMvO6aMOxdZ5ElqK3YCctBzChTH2WatGgI=
X-Google-Smtp-Source: ABdhPJytpkr1xNxbpX5p50QisGEsqWGeevq3vtc9xRu5K2dP/XaYRbyKmVnvwZ9kPwM9nsT81MpgcwOTM9VTXx+pXRs=
X-Received: by 2002:a2e:a16d:: with SMTP id u13mr11802305ljl.362.1592167452733;
 Sun, 14 Jun 2020 13:44:12 -0700 (PDT)
MIME-Version: 1.0
From:   William Dauchy <wdauchy@gmail.com>
Date:   Sun, 14 Jun 2020 22:44:00 +0200
Message-ID: <CAJ75kXa6U1w2ahZ3avX5OdM+pRA-5CaudeLD30o0rMVSaJkKhg@mail.gmail.com>
Subject: backport status of two sctp commits
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

I found the following sctp commits:

582eea230536a6f104097dd46205822005d5fe3a ("sctp: fix possibly using a
bad saddr with a given dst")
backported in the following stable versions: v5.6.x, v5.5.x, v4.19.x,
v4.14.x, v4.9.x, v4.4.x.

5c3e82fe159622e46e91458c1a6509c321a62820 ("sctp: fix refcount bug in
sctp_wfree")
backported in the following stable versions: v5.6.x, v5.5.x, v4.19.x,
v4.14.x, v4.9.x

However I cannot find them in v5.4.x yet. I checked stable queue on
netdev side (http://patchwork.ozlabs.org/bundle/davem/stable/?state=*)
but also main stable queue
https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git

I was wondering whether it was an oversight or was it expected?

Sorry for the noise if I'm mistaken.

Best regards,
-- 
William
