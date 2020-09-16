Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B6526BF8D
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 10:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgIPIlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 04:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgIPIle (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 04:41:34 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A831C06174A
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 01:41:34 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id r9so7397131ioa.2
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 01:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Gzr0tG9QIS5L2SbET8WTvMQNvVp/DEVyaK54Yv2iwwQ=;
        b=u0hRdeRoGPrNEqclVTxKPbJktRq0xCJtP7gaT19BqI4gG8wrcKQglm7FbKOBFv1b9i
         11mOd6tU753nQIG8bdxX6wqi9I362SiqffqFdSR8diswqUCiIxQ/HlVFGmyNaLA19jON
         50j8R0EZpzt88NsKn8HENSulDNaX2Pa/bbNcv6c59eZJ/sbKE+YwsUIKFhnz66tbcwHe
         m+9vGRhbw6hvimDi2TFRTOrv2XlQkhB4kHGLeZa72Qmiyb3VyUTnC4Dsljc+96IB6K8d
         VRcTl8ObUxY0mWxlZGtzLPVgtKiGr7gJG8PyNPfbRZqQeUCPfQtgczbMJnorFgGvxTfB
         hRtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Gzr0tG9QIS5L2SbET8WTvMQNvVp/DEVyaK54Yv2iwwQ=;
        b=L9KPG5NXLrKx57rY/cKbUK+lWEu97occ0nH8RHDjG2Lu4QH9Rym/vx2wDXneyKD1L7
         l5OrWavGgj9SvQeUHEoepgLrQbd6lyYvLLqyoHymyBKXO3WNwpgZ2EhYEde/xGGtB2Am
         A6tU7qOpCIPv32Mlb0GYoCO+s09g9XzhmQ+yPlEMKNYDtzd/dbroCxLzkxLYZeC4mmN/
         /8LJaIX2bEy6PYQDI8n3OxkwJ0ltCEO1dwPHBTJWKhPtU0l6QZH/ukUxjUMCUS0ez0i5
         aK/IyS2U9FrdbYxWfWfjIRLzKZoPABvN3kYZDSxBCq7cUW31accBGFJtesRum7pCQSFf
         11lg==
X-Gm-Message-State: AOAM531L1mOJEjBcDIgpXZUg3Pga2EIW/mkDUjBuQsZcNJY9oIykpuZ7
        pLjZyRdL/fZPmOf2sNKLEB7n2mjxKe9SY8wFRJHZIf+J4GQNSQ==
X-Google-Smtp-Source: ABdhPJxzDHRkzKTCEwR17QFaRMp/lK8q83gN9vbB7mAq2PW+Eei+Sdmu6zPWW+gxfKMkv+xQ52d/hM+YiLCbajy9KrY=
X-Received: by 2002:a6b:d214:: with SMTP id q20mr18819224iob.23.1600245692814;
 Wed, 16 Sep 2020 01:41:32 -0700 (PDT)
MIME-Version: 1.0
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Wed, 16 Sep 2020 16:41:23 +0800
Message-ID: <CALW65jb8xv2tZPiimQcLHmpzcyhZG3t1HAZG_wdjE9sdXsQxPg@mail.gmail.com>
Subject: Please apply commit 1ed9ec9b08ad ("dsa: Allow forwarding of
 redirected IGMP traffic") to stable
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Daniel Mack <daniel@zonque.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please apply commit 1ed9ec9b08ad ("dsa: Allow forwarding of redirected
IGMP traffic") to stable as well, as it fixes IGMP snooping on Marvell
switches.

Regards,
Qingfang
