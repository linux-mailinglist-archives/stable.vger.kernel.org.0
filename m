Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA40805BE
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 12:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388476AbfHCKcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 06:32:08 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45992 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388475AbfHCKcI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Aug 2019 06:32:08 -0400
Received: by mail-io1-f65.google.com with SMTP id g20so157813780ioc.12;
        Sat, 03 Aug 2019 03:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=da8KRfbEJR8oI6dph8pOWFJBoDpxiOlghod0qc29YNk=;
        b=ur/qYbkcaFRigMcGfbkyjRR9Ci5OFfz0p10SpbaNfXAmmnb9wpvLL8S4f2ZNI/jmNZ
         6eIBV5C8Z+/tACC+UbCUzLIU8FPTtwXk3dV6HObjGOoG35sn6Dg052XlOMvZjMYwzjkz
         J5A6QgQMoDPTnNcyOW95JxPNDdP/0edmzBfHy/sYJ4MkwTUl1PhvJ37ovhDa6+ewwGDN
         szW3GR4HQymM5s6V0juJjUrowXyKKWmiEhUuTrUKpjPjKcbcCTyy5t1j8hNDp4RMBpuo
         5MFzIskuDabtL0c7QLP/EV6pqbbSxe5QT86nGicesRe8cYkpaVzt3xm3FN83vhcAucaQ
         qHWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=da8KRfbEJR8oI6dph8pOWFJBoDpxiOlghod0qc29YNk=;
        b=gvvtHQD5nIZN8GMFiLo9eSJVqlptIQOgd30kFGMaANMKF8L21tG2hGzveB0Y98cc8s
         JsmY+4cQwgHnRtbzPJfB5ivA2owTCS1YrhcMW4Zbak66+fm2LzDud8zifXYAw8dJow7s
         wYQofm3s2neqWrjk3ohefQShvKetS/aEKE2W2ubtZD4tda1RKJ1IOf+THxylzi7CUr8P
         k/skl3OJj7nN0GhkSlpiwgih8fb4S2Ov2k/mLxs8eq+ew+0t8XVs1kS7S8xCxhSoQFKt
         jFUWNOjaGxgSFqbKjswkf2KMucHP0Vr+i/5Rdr+unIflmRFNh+NwvsHE8zLxDnS4oX0o
         8Ubw==
X-Gm-Message-State: APjAAAUJst/MHZdVz+purngQ69OXgSkZ0M8Gp1+C69zuofZdS/hvWqLQ
        xCBciWYwDw4vFgT4o/5yojaH5zHYEA5lNjAdlMs=
X-Google-Smtp-Source: APXvYqzSb8j1fq6O7rFD2jXQWgqNHP8qtISFgYusBlZIk6vclAhRo2eNMoWvK0QqcKjrGqHabWe+DdWtHQ55dYrGmVo=
X-Received: by 2002:a5e:8209:: with SMTP id l9mr126332553iom.303.1564828327694;
 Sat, 03 Aug 2019 03:32:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190802132302.13537-1-sashal@kernel.org> <20190802132302.13537-6-sashal@kernel.org>
In-Reply-To: <20190802132302.13537-6-sashal@kernel.org>
From:   Alexander Kapshuk <alexander.kapshuk@gmail.com>
Date:   Sat, 3 Aug 2019 13:31:30 +0300
Message-ID: <CAJ1xhMWb6OG0xdBtAQZkX-T0XNmMNaMaS=ScJ4ZRwpv9eHXmCQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 06/42] scripts/sphinx-pre-install: fix script
 for RHEL/CentOS
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        "# 3.9+" <stable@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 3, 2019 at 11:19 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
>
> [ Upstream commit b308467c916aa7acc5069802ab76a9f657434701 ]
>
> There's a missing parenthesis at the script, with causes it to
> fail to detect non-Fedora releases (e. g. RHEL/CentOS).
>
> Tested with Centos 7.6.1810.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  scripts/sphinx-pre-install | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/sphinx-pre-install b/scripts/sphinx-pre-install
> index 067459760a7b0..3524dbc313163 100755
> --- a/scripts/sphinx-pre-install
> +++ b/scripts/sphinx-pre-install
> @@ -301,7 +301,7 @@ sub give_redhat_hints()
>         #
>         # Checks valid for RHEL/CentOS version 7.x.
>         #
> -       if (! $system_release =~ /Fedora/) {
> +       if (!($system_release =~ /Fedora/)) {
>                 $map{"virtualenv"} = "python-virtualenv";
>         }
>
> --
> 2.20.1
>

The negated binding operator '!~' could be used here as well, and it
does not require the use of extra parenthesis.
Just a thought.
