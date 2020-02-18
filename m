Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E85E1636CB
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 00:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgBRXDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 18:03:50 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46926 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727400AbgBRXDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 18:03:49 -0500
Received: by mail-lj1-f196.google.com with SMTP id x14so24909028ljd.13
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 15:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A2b+2qHSICAQfk4L4lxWTYsNq58C+5hPouycMXdDVlQ=;
        b=JCZ5z9TA9DJiwkWsOfjqukijyaYu0aIusI6XEIZJ9+uLhWezmsELqdwSOurjue6DxK
         c6QUuHorl5ixd65q+iv2YKr9OG1u4Mo/dy5UiXnuaNvNOx/7Y6I+vO1va++1CJzm9RTr
         AwzmCCvxwCjKFS8uBbdqY2NddxWSXfkklkYpA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A2b+2qHSICAQfk4L4lxWTYsNq58C+5hPouycMXdDVlQ=;
        b=cweVFWQ6sbPZf7p9B1cZ0owPs44xJ2Q5H3N2R+hnF5/G+1tmTfuwiHNek9/fZb1UVf
         gjOLoFSDVWNxjcP3/YVjZLu5LD1kloLft8VmTeHVYFg4ekixqnEMzDZ3Cge1OUpOLlbp
         1TXv1ED1f0eWEYp7PoqES/awwWe3nj6mJEHwcH0gvooEgBCnRPbv/S4XEKJsiRImqz9z
         aAscj/aZSJtqZ4KOR7oSS7D+/rhhfsNqF5wyN10jF0H8D8wfeWojYRqxq9NHYH6WpffH
         6QkfTrG48l70nooka7wLTopPPoWnTMvDAokqxEocDp6ihyX7qbZ54SMvyIMMLSBT3k7w
         /szQ==
X-Gm-Message-State: APjAAAUNSpLBygGMbkjHOSxcTBLiwIsXYzE1/3mT0pj5aTMOT6NH1v3J
        4thhA7l7zYF5fIUy0wqNPUVEq1efSHE=
X-Google-Smtp-Source: APXvYqzwdiX1PZB7m+kjSc/gBH3bjwei1Pg99UdKjNqSyrQLf3EANNDttvmffTgKvQ1I0HWiKa815g==
X-Received: by 2002:a05:651c:327:: with SMTP id b7mr13039853ljp.22.1582067026636;
        Tue, 18 Feb 2020 15:03:46 -0800 (PST)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id u9sm98173lji.49.2020.02.18.15.03.45
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 15:03:46 -0800 (PST)
Received: by mail-lj1-f169.google.com with SMTP id e18so24863721ljn.12
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 15:03:45 -0800 (PST)
X-Received: by 2002:a2e:9d92:: with SMTP id c18mr14935845ljj.265.1582067024793;
 Tue, 18 Feb 2020 15:03:44 -0800 (PST)
MIME-Version: 1.0
References: <20200214154854.6746-1-sashal@kernel.org> <20200214154854.6746-542-sashal@kernel.org>
 <CANaxB-zjYecWpjMoX6dXY3B5HtVu8+G9npRnaX2FnTvp9XucTw@mail.gmail.com>
 <CAHk-=wjd6BKXEpU0MfEaHuOEK-StRToEcYuu6NpVfR0tR5d6xw@mail.gmail.com>
 <CAHk-=wgs8E4JYVJHaRV2hMn3dxUnM8i0Kn2mA1SjzJdsbB9tXw@mail.gmail.com>
 <CAHk-=wiaDvYHBt8oyZGOp2XwJW4wNXVAchqTFuVBvASTFx_KfA@mail.gmail.com>
 <20200218182041.GB24185@bombadil.infradead.org> <CAHk-=wi8Q8xtZt1iKcqSaV1demDnyixXT+GyDZi-Lk61K3+9rw@mail.gmail.com>
 <20200218223325.GA143300@gmail.com>
In-Reply-To: <20200218223325.GA143300@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 18 Feb 2020 15:03:29 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgKHFB9-XggwOmBCJde3V35Mw9g+vGnt0JGjfGbSgtWhQ@mail.gmail.com>
Message-ID: <CAHk-=wgKHFB9-XggwOmBCJde3V35Mw9g+vGnt0JGjfGbSgtWhQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.5 542/542] pipe: use exclusive waits when
 reading or writing
To:     Andrei Vagin <avagin@gmail.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 2:33 PM Andrei Vagin <avagin@gmail.com> wrote:
>
> I run CRIU tests on the kernel with both these patches. Everything work
> as expected.

Thanks. I've added your tested-by and pushed out the fix.

           Linus
