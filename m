Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9FC240451
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 11:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgHJJzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 05:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbgHJJzt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 05:55:49 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91BAC061756
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 02:55:48 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id v13so8320960oiv.13
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 02:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=cfJlzp/maklYkfYOx+Y3ZBqfkdN/Iy2b/Y1lZUBz8KA=;
        b=KUqesErG4lVeEL8yLKk5XkaIv+qMbfinqXjYnugOD6JAhp4SeQ1Qwf4OlXyO8vMW4b
         MYL0exfCPzvTFWAqGfTAA7tU4TVCOYOY8l+DQ+nXq0gJnHvV01hZqfG/HZ6m2LP3Sryk
         FsLmFJWXEnsuyqhk+NFcUtUNK4FhHaC2AuSF2o9onyDnMPqmphCMhQ5q1m4mV7zY20pi
         JgwK5G14bhaNuwy6tQJXJclOS22Tw/8sUpP8H3mMPZedkWG2A3ix5aOgnp+e2L4KHmrl
         OQMfTsRKesB9dwKjwDmtCGSJVjaRTxDtOvRvVqL4nlgr9fpEFSFxF/9JGeOlwXs7cspf
         YZRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=cfJlzp/maklYkfYOx+Y3ZBqfkdN/Iy2b/Y1lZUBz8KA=;
        b=OMNabW7J0Jk8Y+MgRvDMYesdh5KrWUix8CM9AaH+rudwtgUGpxFuaJBaynwIsKvgxB
         09lqY4AwpJ9cfV/2vl4zuOU4iXgoVCTgh4y837vq5aW+Jg98y5hhXUkZXxhBlylNmTKD
         D3xtqTR7Qt2/KsL40ZWxIKmzi4vYJ25WKFAENv1U6s1ifpI8TFVckyFJZWBo6Kl10y6k
         TOvNY+WwKBjDQNRcATHtfmCoy/6aFz8xyXICs5K4DvRsJdCe3YIWZT872p1mumsRW5Ah
         atO/b0TUM/fZ3HIf0CN4G5FzfUH0lVGEH2vSco6OyfDKaaFhxBkLK6h+oTgY9w+sdEuI
         z3/Q==
X-Gm-Message-State: AOAM533HHxIRTFPOmiOiCf3aq1V7T1NvBHbjP6DNlF20ugn+Sn3faSEL
        wt6dsStV0OjBLY58OCa9Xt0YVgvN9aE+vC0FTy4=
X-Google-Smtp-Source: ABdhPJx5ULdhdYaklQB2t23LuzWwUghqVbTapDfIus8JabLkZNsPZiEqJ/gtPI/5xjVuT+zqU8W0+0nnxd8L9y35Kqw=
X-Received: by 2002:aca:724f:: with SMTP id p76mr62296oic.35.1597053348209;
 Mon, 10 Aug 2020 02:55:48 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUW_f4d5_yDg0_Ox8nVd_6R=JNc8Bo9TgEzjLUy_1MdXOw@mail.gmail.com>
In-Reply-To: <CA+icZUW_f4d5_yDg0_Ox8nVd_6R=JNc8Bo9TgEzjLUy_1MdXOw@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 10 Aug 2020 11:55:36 +0200
Message-ID: <CA+icZUVE5L8KzAkJLHLTQXiJX6owdCtw6Lz7Yh=K=kghcWrHrQ@mail.gmail.com>
Subject: Re: Base for <linux-stable-rc.git#queue/5.8>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <alexander.levin@microsoft.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Note2myself: Check MAINTAINERS > STABLE BRANCH.

- Sedat -

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/MAINTAINERS#n16354

On Mon, Aug 10, 2020 at 11:52 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> [ Hope I have the correct CC for linux-stable ML ]
>
> Hi Greg and Sasha,
>
> The base for <linux-stable-rc.git#queue/5.8> is Linux v5.7.14 where it
> should be Linux v5.8.
>
> Can you please look at this?
>
> Thanks.
>
> Regards,
> - Sedat -
