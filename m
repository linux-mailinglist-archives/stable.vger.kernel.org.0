Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E905C3A387F
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 02:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbhFKAUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 20:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbhFKAUo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 20:20:44 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E449C061574
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 17:18:47 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id o17-20020a9d76510000b02903eabfc221a9so1559991otl.0
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 17:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7fVbGkzDMbWH/xzjd9fVHiPChuwdtXQFDYbGkUbQ+LM=;
        b=NAcNxoZoGKx25E1SGTp14Ho7XpwdCNkwzT1GSk14egrMTvsNx/jUPKkUBmBJawp24D
         7VQiJylG3YqtKPydCOA42iU7b1pipt1zXZi8k2TGwaTK3rl90JR0Uq2NZLrLLRx8nVGR
         Xrtno2MSBL6+95zqvtXHNipz+4HmVNbF6xw8I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7fVbGkzDMbWH/xzjd9fVHiPChuwdtXQFDYbGkUbQ+LM=;
        b=iGHNi77/8uij9dkhV81jx94O2gyin3SGezsuEBSZdHX1LnfWFksGxM54uPyB3Zydo/
         cJCQunIWsWF0FUA/uT1+jXMt+Xe5otmfmHGcoKzDJHF8GQVV5bji6zW5tWjPzVkvXmG0
         tKbDj9iErTzSyvlerWN1pUJkKISxcQ6xL/U94RUIIqw6/kxS2cumYm6DgFitAFCR+cbz
         xUBreQBjNB1gLfRMPAyOU+3LAhGDlMXCCLBGUed7nmiWmMFLZTAIrVwFgUiZZV+zMq2g
         Vr+7rWt7yyKW4thh9cYl9lr+jacLxPBBw5BZRMFWlhOBSRe/RQIRO03xRssl4VfUtVEC
         IX9g==
X-Gm-Message-State: AOAM531XlPh07+8wzHXoLIYxwQ3lI5lsVMibUXaQCVqzt1HJ4mUTSn/j
        r5n0NsugjyaPIJrP8JDvv7misjazpJlcew==
X-Google-Smtp-Source: ABdhPJxEza3+20UpqOyPP+SaoNNTpJOCpZjVUuBer17R3BaFSw49sPD2ZEGF/6b1eY3fUD/bMS4u3A==
X-Received: by 2002:a9d:4b98:: with SMTP id k24mr747757otf.359.1623370724939;
        Thu, 10 Jun 2021 17:18:44 -0700 (PDT)
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com. [209.85.210.51])
        by smtp.gmail.com with ESMTPSA id 16sm923650otm.57.2021.06.10.17.18.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 17:18:44 -0700 (PDT)
Received: by mail-ot1-f51.google.com with SMTP id 6-20020a9d07860000b02903e83bf8f8fcso1467259oto.12
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 17:18:43 -0700 (PDT)
X-Received: by 2002:a05:6830:168a:: with SMTP id k10mr734314otr.203.1623370723322;
 Thu, 10 Jun 2021 17:18:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210515024227.2159311-1-briannorris@chromium.org>
In-Reply-To: <20210515024227.2159311-1-briannorris@chromium.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Thu, 10 Jun 2021 17:18:31 -0700
X-Gmail-Original-Message-ID: <CA+ASDXMDtWpZ-xrymmq51j4TjPT-NXs61-7q=sn090BoJu9qDg@mail.gmail.com>
Message-ID: <CA+ASDXMDtWpZ-xrymmq51j4TjPT-NXs61-7q=sn090BoJu9qDg@mail.gmail.com>
Subject: Re: [PATCH 5.13] mwifiex: bring down link before deleting interface
To:     linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Linux Kernel <linux-kernel@vger.kernel.org>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        stable <stable@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>, dave@bewaar.me,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 14, 2021 at 7:45 PM Brian Norris <briannorris@chromium.org> wrote:
>
> We can deadlock when rmmod'ing the driver or going through firmware
> reset, because the cfg80211_unregister_wdev() has to bring down the link
> for us, ... which then grab the same wiphy lock.
...
> Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/linux-wireless/98392296-40ee-6300-369c-32e16cff3725@gmail.com/
> Link: https://lore.kernel.org/linux-wireless/ab4d00ce52f32bd8e45ad0448a44737e@bewaar.me/
> Reported-by: Maximilian Luz <luzmaximilian@gmail.com>
> Reported-by: dave@bewaar.me
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Ping - is this going to get merged? It's a 5.12 regression, and we
have multiple people complaining about it (and they tested the fix
too!).

Thanks,
Brian
