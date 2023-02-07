Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACFC68CF9E
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 07:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbjBGGmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 01:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjBGGma (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 01:42:30 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102F94EFB
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 22:42:22 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id m2so14693593plg.4
        for <stable@vger.kernel.org>; Mon, 06 Feb 2023 22:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ex7EG8pPpJcRAyJIw3O85yhgKVUhIMCK5Um+mNzCBU=;
        b=FGnr4xo8oBOjs366xuF6tWj5aEpXxNiy8GIpKxHZ7jFdBLHWLhqW4QYp2/gSdko2BU
         rerEqy0hLuuCxN/MYwfdZhUtOGidgmjWoItCkLY+SXMMKH6XI2PCU2cwUHcTbagFAwlx
         pZHCw7GfGtcZJRMN2ccMQYK1kVUBDVFPX6/eR/SAtx68xC97FziwssThUjtbvPI40KgV
         xneIqVBOUNI7eQUGE0jYs2sH+JbUY91ImtL9uVL0OBRt2QZA40IZJLzgEeaNmOdtOJ8e
         +3Gy2piVBnC3EKm9LIaHYiiYm0ocXrZxF8vXL3zEx9dcsKvj1SFGTj7R1SRlEiFxbBZT
         ff0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ex7EG8pPpJcRAyJIw3O85yhgKVUhIMCK5Um+mNzCBU=;
        b=srEwxsBCuOIM4Z5A2wyIOdxEiyCFyBAQn26cCvLFukBWRubWGXjh6ROMg1a9tXOPvl
         /QowHHi/qKfGJbdyVJoBwF+n+1XZzfIQ2VTNzA0+3JjvJnBpf5Y/M6EDE9a2fk80wmFL
         Rvp/SM9+SlwsIibzjE2EBssB0JDDswOwsEp850M6KHtU2NU5ZjMquBZWn3B4d9bRdfu0
         SxeZeMrMeyEhAqgZVys9FAedk9iAcQuHmxOE0zVGvP2W3uQRddftrEWKXnS5x+MvHzFO
         tJOqFTgRHaJiuyv+t5UOm4m4LNblfaLwmRORj1V5eSXWUH/9I11BEyUGtueEonT+iJ4D
         X58Q==
X-Gm-Message-State: AO0yUKWbAmxAiH+KWy10WkT38WFRYlbDE/Vhd/UgUSZtVcRXbG/9Utp2
        8DL3K0JYFauaxJjj1B3xx5Yg5ONVRQ4SgtiBP/Y=
X-Google-Smtp-Source: AK7set8jgiUDVt9IXMWXh9hieyMd0hB4SOdpDcaJzuryRuxAT891KGylOe5FuOU6S1yK74zGQ5RhpAvAubJN7JbWh0g=
X-Received: by 2002:a17:90a:7502:b0:22b:f34a:1f52 with SMTP id
 q2-20020a17090a750200b0022bf34a1f52mr537131pjk.76.1675752141599; Mon, 06 Feb
 2023 22:42:21 -0800 (PST)
MIME-Version: 1.0
References: <CAEm4hYXr28O8TOmZWEKfp-00Y9R7Ky7C6X3JTtfm-0AD42KbrA@mail.gmail.com>
 <Y+CSwTDESQjTzS8S@kroah.com> <CAEm4hYW-LzXbf-ZrsG59LrHB067NhuYkRSLzsd8RBfwzA8z1mg@mail.gmail.com>
 <Y+DK4fP/u7iYi7Kt@kroah.com>
In-Reply-To: <Y+DK4fP/u7iYi7Kt@kroah.com>
From:   Xinghui Li <korantwork@gmail.com>
Date:   Tue, 7 Feb 2023 14:43:17 +0800
Message-ID: <CAEm4hYW+p3CdbPkKK8Aiv-ofisQbsBr3xv8Ne9D6QJXeOC9T9Q@mail.gmail.com>
Subject: Re: [bug report]warning about entry_64.S from objtool in v5.4 LTS
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     peterz@infradead.org, jpoimboe@redhat.com, tglx@linutronix.de,
        stable@vger.kernel.org, x86@kernel.org, alexs@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> =E4=BA=8E2023=E5=B9=B42=E6=9C=886=E6=
=97=A5=E5=91=A8=E4=B8=80 17:39=E5=86=99=E9=81=93=EF=BC=9A
>
> Is this an actual real problem that you can detect with testing?  Or is
> it just a warning message in the build?
>
So far, I have not met the actual error in running time.
But according to Kuniyuki's report, it seems like this commit will
cause an actual running time error.
I will continue to analyze these error reports.
> That is very odd, why is it hard to update to a new kernel?  What
> happens if 5.4 stops being maintained tomorrow, what are your plans to
> move to a more modern kernel?  Being stuck with an old kernel version
> with no plans to move does not seem like a wise business decision:(
>
The product base on v5.4 is the LTS version just like the
stable-kernel in the upstream community.
> Great, and we will be glad to review patches.
>
> thanks,
>
> greg k-h
Anyway, I will try to figure it out :-)

Thanks
