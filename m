Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E79D2906A7
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 15:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408070AbgJPNzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 09:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407440AbgJPNzi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 09:55:38 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CA8C061755
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 06:55:37 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id u8so3335817ejg.1
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 06:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N7AeE/8ZEYkMdda7MRqPSGY/h9PZ7ZMGSOdv+l0BJqM=;
        b=rRNxRHvXxrdIkThWmsaSEzV2wmuxFRR9aLf90NFlOlcnyVWeb9Ivsapeydl0B4gecP
         BBIg0z6f5GUSAasmZBjmL82isvl+jwMxxQgb4oRVwU/g3sXRptjlUQqiHihHEgJHzAFa
         RbvvPJCq+WT5se4YSjFqmGBegd7jS5GqTs7WDwVEF4YJqPvysLEqdJUN3s5uKfdZJbXt
         oYxOuV/guWTsr8tO67DN026/CBQ7lsxnZCVYIQIwJtu18G5vo80lhODixW9fOXOtibn6
         4bEU5Q5bSHRC6fYGo/TqhYPW/V7DNGytWYOQm65+VgGczbNmdIiNTIMMmR/xGNpmnWjF
         D1bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N7AeE/8ZEYkMdda7MRqPSGY/h9PZ7ZMGSOdv+l0BJqM=;
        b=am+2DAJjYcS/iF/WjDdoKB+gI89WD9+rFesA/CSApQduafJ0k7YMYhQUuliWgi0USK
         9TY8NVl85YOo1PPo49L9JwJfo+puKcIp9fDwAdoLTMsMMuMGOfoK9dNQOq3cyeLfirD7
         RodKgtUqaLMwxa4AvVMS6nmaQVmdaX0vQ7D537khoyKIpa+u+C7d4z0Arr91niS9LBlz
         B+fNJuST+T2Q0IMQrhDoZlEu9oLjuu6ByzWnKMo+/xYhy35jt0Q4oJbLYWVVoRLN+mA1
         cWAZ0n9VK3ZSQYgf3anW9G3fnmAQJMCuq7og94TXx3AEZA98Kp+DQZA1Tc/8AIn6j1Wt
         YCeA==
X-Gm-Message-State: AOAM533PR+Mz8yT9RYntxfoSKzrxg+rsINY/2yk0fbWizdQ40YLd6stG
        fnso1hbsEbAkZaSHXX2pfm0bBw8WTU3s/bVDjVRVIKyucg==
X-Google-Smtp-Source: ABdhPJynpfGeTPWurMLvjzhlpYPkK/ETBVsdQbqGys3We0W4hWQwS/FxKI6JPMO+fEQn/oPqD24TzEsWF3/WNpYLZ8w=
X-Received: by 2002:a17:906:f2d2:: with SMTP id gz18mr3783320ejb.542.1602856536545;
 Fri, 16 Oct 2020 06:55:36 -0700 (PDT)
MIME-Version: 1.0
References: <20201015192956.1797021-1-dburgener@linux.microsoft.com>
 <20201016050036.GB461792@kroah.com> <9aeaa66d-d369-a1eb-7a07-08d9244585f3@linux.microsoft.com>
In-Reply-To: <9aeaa66d-d369-a1eb-7a07-08d9244585f3@linux.microsoft.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 16 Oct 2020 09:55:25 -0400
Message-ID: <CAHC9VhR_WG13wLT-rJs0AdDgh6kwN_ei46btyXp5KusUdzuOag@mail.gmail.com>
Subject: Re: [PATCH v5.4 0/3] Update SELinuxfs out of tree and then swapover
To:     Daniel Burgener <dburgener@linux.microsoft.com>
Cc:     Greg KH <greg@kroah.com>, stable@vger.kernel.org,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        selinux@vger.kernel.org, James Morris <jmorris@namei.org>,
        sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 9:05 AM Daniel Burgener
<dburgener@linux.microsoft.com> wrote:
> Yes, thank you.  I will fix up the series with the third commit
> included, and add commit ids.  Thanks.

Greg and I have different opinions on what is classified as a good
candidate for the -stable trees, but in my opinion this patch series
doesn't qualify.  There are a lot of dependencies, it is intertwined
with a lot of code, and the issue that this patchset fixes has been
around for a *long* time.  I personally feel the risk of backporting
this to -stable does not outweigh the potential wins.

My current opinion is that backporting this patchset is not a good
idea; it gets a NACK from me.

Daniel, in the future if this is something you want to see backported
please bring this issue up on the SELinux mailing list when the
patchset is originally posted so we can have a discussion about it and
plan accordingly.

-- 
paul moore
www.paul-moore.com
