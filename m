Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1E02DF51
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 16:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbfE2OJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 10:09:43 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34260 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbfE2OJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 10:09:43 -0400
Received: by mail-ot1-f65.google.com with SMTP id l17so2170157otq.1
        for <stable@vger.kernel.org>; Wed, 29 May 2019 07:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EvVRdR1pAhDuZWorE20R2dEwxPVelW5AqaNeJeFQTrY=;
        b=ev5Y28CI1Gj1w5WljmD+qjolXhHluDJZGNf9aYE2TOiCFwHkodM5lCcVSOfVB1hGiM
         6pIU7XDZL7fDdolzPnKC+N/MZdwuGfsgUMqMlPCKACj/ONIM6c79727y35rfCs4iiFxQ
         nK8bFymxIKc4AgsAVOJwQKlTP4mkk+kutvOxuLqSqsBM5S/TZ4OJoNFgwzsuVqkHYZ3L
         gspyOGpEwWJ9+Oacs7ROUf5uGLMQKZYkHhmPlXolIKiWkAnYsW5G3SLFg7MfTEuJB/BU
         kvzOcutYxL/bEHqXEp8OYTVt3JsBMF3YYX6loE5jQ7uaHIEjjpX9zscWgbty2F7Dkcnv
         EqBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EvVRdR1pAhDuZWorE20R2dEwxPVelW5AqaNeJeFQTrY=;
        b=FpvX/lORvhKVRuGOWjmOUBZnwl5Ve7Q1vWwu4MOBFsbQa91qoDkpWF+3IbqtlsvGxt
         VouBpYeEHMEuWdU4her4Hj8You6aKpbRRtqH6tgryvwlxoPykPjos0quPrCiG1SzLo0b
         Aro1Jg/BVkSkVx4yywPBY67cXWwwoabtpH4D1UI5a4zhf0oIfB410LYK/98udJpv2eOZ
         L80BtQzzTgBRafigzrZrQ1MlZSPTyCkxy2+lsT5Zu8hr2nZlnNbeO8p1K/F8tA0lL/IW
         TC7Prf83cjapIDJLPTaAtOzZa9rXudcor6q19qUyDcCwat298fvlAttzhV5UE6Puj+op
         prpg==
X-Gm-Message-State: APjAAAUs+JfSGmR/0FdlQWT5t8EXT5Ycs/sY2U50xtOat8ss01W1poig
        BiGImeZZKQjxqbb0GDAaiQdvJDtXq/i+s8sdO+mC/A==
X-Google-Smtp-Source: APXvYqygGmkMLJ/EF3edaii5aPpVIlyxTToDUyM4xfgakdClLUfCNKF73fKCsRtPYXpZUZk3tyVxu3Ci25IlZCXdtMY=
X-Received: by 2002:a9d:7347:: with SMTP id l7mr1090523otk.183.1559138982044;
 Wed, 29 May 2019 07:09:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190524201817.16509-1-jannh@google.com> <20190529131501.A44162183F@mail.kernel.org>
In-Reply-To: <20190529131501.A44162183F@mail.kernel.org>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 29 May 2019 16:09:14 +0200
Message-ID: <CAG48ez0Rca6PF2kF=ecsD=X4LOxvZLqAE6HHf_QcKopzhB9opw@mail.gmail.com>
Subject: Re: [PATCH] binfmt_flat: make load_flat_shared_library() work
To:     Sasha Levin <sashal@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 29, 2019 at 3:15 PM Sasha Levin <sashal@kernel.org> wrote:
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 287980e49ffc0 remove lots of IS_ERR_VALUE abuses.
>
> The bot has tested the following trees: v5.1.4, v5.0.18, v4.19.45, v4.14.121, v4.9.178.
>
> v5.1.4: Build OK!
> v5.0.18: Build OK!
> v4.19.45: Build OK!
> v4.14.121: Build OK!
> v4.9.178: Failed to apply! Possible dependencies:
[...]
>     ddb4a1442def2 ("exec: Rename bprm->cred_prepared to called_set_creds")
[...]
> How should we proceed with this patch?

I think the dependency is on ddb4a1442def2; but the simplest way is
probably to manually adjust the fix, it's basically the same in 4.9.
