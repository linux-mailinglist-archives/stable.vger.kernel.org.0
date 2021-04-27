Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E7C36C8A8
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 17:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237665AbhD0Pc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 11:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237630AbhD0Pc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 11:32:27 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CEBC061756
        for <stable@vger.kernel.org>; Tue, 27 Apr 2021 08:31:43 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id n138so94483646lfa.3
        for <stable@vger.kernel.org>; Tue, 27 Apr 2021 08:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wRPmVW+l8hNmuKSneUNYdhg6EPkPkT9qOMTPIVf8vaQ=;
        b=WvECQx1Lb6QUA9eLy2mj3gWKTvRi2qlDxWJvxkBthHBDfZ1k6fJ+CL1hGO00/dVrWw
         wPIWvoBw+wlYADN0Me7iKLqFSjyRkWlX93t/vKXur51a404hExsx0Fi9/arh1Zx8jWgw
         RyXZ+PeJ9wrOnOw1TFy8SXg+p4uruoka+RSxg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wRPmVW+l8hNmuKSneUNYdhg6EPkPkT9qOMTPIVf8vaQ=;
        b=DzkeXzYxsq9vLZBj0kNUVwk1gm7USpg37WAjH411wG26wvHdpret/PMa7376vqu3ZK
         TjcFS8hcGseioXZkT/ZygeArxJpDDuZOqOyfsMZE2pM0WXcFRL+rBiyfw4309sa4KpiR
         paHLSweXVU/L50EsmkWkRAg2yAOcUBeqxUrubDHXKSz0rjy20RVMsAFV/k1JEo/xJcra
         hdiSBGnkLwFA0K9xtTrpaROS0ppT5AuYPYV+BadxI1GY6xhmLZEirmgNSPNy6Rnx50/e
         VPU9yDwPlkZNPldn1x1ZVYhZ47BzQYqlZ1B44OD8V1SAYZBV2ZjMi0S4nD6lEFYDzeih
         d3JA==
X-Gm-Message-State: AOAM531nJQ/I6PcJZhxadZCazmH49s3ovXUKBvfQ86Ia253B+ZBCDxxC
        B+agi6ADQuVK9hZr2Jp4kfOfYlf2/5dcj00P
X-Google-Smtp-Source: ABdhPJy0C3uKtRtr5hYAwmZlfF9HiPPqlLDTM44+xWLbIcomO0y/rnxmShMNorYNBqVxfrg6CrOu4w==
X-Received: by 2002:a05:6512:1143:: with SMTP id m3mr16991848lfg.366.1619537501205;
        Tue, 27 Apr 2021 08:31:41 -0700 (PDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id e8sm49719lft.281.2021.04.27.08.31.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Apr 2021 08:31:40 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id b23so11776931lfv.8
        for <stable@vger.kernel.org>; Tue, 27 Apr 2021 08:31:40 -0700 (PDT)
X-Received: by 2002:a05:6512:a90:: with SMTP id m16mr16619989lfu.201.1619537500295;
 Tue, 27 Apr 2021 08:31:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210427114946.aa0879857e8f.I846942fa5fc6ec92cda98f663df323240c49893a@changeid>
 <4ae9835c535db4f9c0c78f1615f16d56c7083640.camel@sipsolutions.net>
In-Reply-To: <4ae9835c535db4f9c0c78f1615f16d56c7083640.camel@sipsolutions.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 27 Apr 2021 08:31:24 -0700
X-Gmail-Original-Message-ID: <CAHk-=whsCHfM2XY_0sbXjFKwS5Zzi76w_cErQHg=yAyPKZYuLA@mail.gmail.com>
Message-ID: <CAHk-=whsCHfM2XY_0sbXjFKwS5Zzi76w_cErQHg=yAyPKZYuLA@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: fix locking in netlink owner interface destruction
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Harald Arnesen <harald@skogtun.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 27, 2021 at 2:59 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> Though then again, I'm not sure I have a good pathway into the tree
> right now (pre rc1), so if you want to throw it in sooner that's fine
> too.

Ok, applied with Harald's tested-by added.

Thanks,
           Linus
