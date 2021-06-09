Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE7B3A1E5E
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 22:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhFIU5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 16:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhFIU5d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 16:57:33 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B41C061574
        for <stable@vger.kernel.org>; Wed,  9 Jun 2021 13:55:23 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id bn21so1651196ljb.1
        for <stable@vger.kernel.org>; Wed, 09 Jun 2021 13:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Ti/GPYedshBkKNipdnY5GrhF2dqxzDVtiSSzRhLNtI=;
        b=fM3/ODYVa9wR1hn9nb8YfgPISH77MdgxAUdLzKr7W2e3Sr96ga6sYy1IUgVhfy8HbG
         mdCa640pJmKm5DwoFKNcgsTdX7NuOiKkWvi8/ekGVtCCMyzFvrX4ZVRTFSlNwFLRZrNU
         IxbmSwfgKrqUgHefveb3h1xo0hr4FLtngRpQM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Ti/GPYedshBkKNipdnY5GrhF2dqxzDVtiSSzRhLNtI=;
        b=qbHMHEl5z86DgPx3ymiRxbxkRnggJNBuqep92/Vq9K8mzTSgO844xmemdpBTA1Mn5I
         FbJQPm/pdy4P3OaqekNvcRiffugBuG1ucNtYZX/dFsgh1d0heqIjrO9eC5Rr/zL5ZBR1
         NUnW8Y36rXSBcj4az+cPW1T95vtDGs4qhjAqLcwEfzUXZIaSh6Opwo/g5JjyMco1gkN6
         7SVfo6PbEe2DSYCQa+J1ccZWcO/eU2mJlDh/iweNOM/mxPLXgkFHEbiSFwfSSntph9+p
         f/26LwvauyA+RD/j0r36C67yqmKIUYcIWuPPZLo5KLQC9paku4GuAeWsuItWezo3OvIk
         4JGA==
X-Gm-Message-State: AOAM532G5v9OrO9btyszi+oh0/SQ7kYw1VGMSlgyvxUt/Yl+5VyKQnHo
        HVV+9T0qRFqaiR6uY1au10qJYzVSWXFKiv7E8vM=
X-Google-Smtp-Source: ABdhPJzXLkchzn99RLNbV2MLR0LMyN9Z5lh3/srS1DYTIIvFXoZSnhumYcYKEIMKM7W7WjMvPUjvrA==
X-Received: by 2002:a2e:8647:: with SMTP id i7mr1265682ljj.502.1623272121625;
        Wed, 09 Jun 2021 13:55:21 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id c14sm88948lfh.257.2021.06.09.13.55.20
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 13:55:20 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id n17so1641356ljg.2
        for <stable@vger.kernel.org>; Wed, 09 Jun 2021 13:55:20 -0700 (PDT)
X-Received: by 2002:a2e:2ac6:: with SMTP id q189mr1226604ljq.61.1623272120266;
 Wed, 09 Jun 2021 13:55:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210607125734.1770447-1-liangyan.peng@linux.alibaba.com>
 <71fa2e69-a60b-0795-5fef-31658f89591a@linux.alibaba.com> <CAHk-=whKbJkuVmzb0hD3N6q7veprUrSpiBHRxVY=AffWZPtxmg@mail.gmail.com>
 <20210609165154.3eab1749@oasis.local.home>
In-Reply-To: <20210609165154.3eab1749@oasis.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 9 Jun 2021 13:55:04 -0700
X-Gmail-Original-Message-ID: <CAHk-=win1FaZQga_XYSkRLx0-mF6dSm-HhP2RQ9ZZ3S380SeOg@mail.gmail.com>
Message-ID: <CAHk-=win1FaZQga_XYSkRLx0-mF6dSm-HhP2RQ9ZZ3S380SeOg@mail.gmail.com>
Subject: Re: [PATCH] tracing: Correct the length check which causes memory corruption
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     James Wang <jnwang@linux.alibaba.com>,
        Liangyan <liangyan.peng@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Xunlei Pang <xlpang@linux.alibaba.com>,
        yinbinbin@alibabacloud.com, wetp <wetp.zy@linux.alibaba.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 9, 2021 at 1:52 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> That said, even though I'm almost done with my tests on this patch, and
> was going to send you a pull request later today, I can hold off and
> have Liangyan send a v2 using struct_size and with the clean ups you
> suggested.

I think the cleanups could be separate. I in no way _hate_ Liangyan's
patch, it's just that when looking at it I just went "that code is
very confusing".

So I'm certainly also ok with just getting that ugly fix, and then
hope for a cleanup later. Maybe with a comment or two.

Thanks,
            Linus
