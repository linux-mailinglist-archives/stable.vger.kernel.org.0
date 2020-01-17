Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD846140F3D
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 17:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgAQQpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 11:45:04 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37868 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgAQQpE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 11:45:04 -0500
Received: by mail-lj1-f194.google.com with SMTP id o13so27095678ljg.4
        for <stable@vger.kernel.org>; Fri, 17 Jan 2020 08:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cTFFRrPPMNXyj68w5vFnNgaB8lehH1R0kT3hViXW+dk=;
        b=R/vqnjE1Cn6gnUAGoqsEnQDlF+U9TWR6jn320mob3Bmoz89qWxGzMTXFzNGBYcHNvm
         8wr/EyxWxH8mkCUOfiC789zbhhzOJbb0pwd0NxNvejUKxDBDlur6vZC2vWxXZ4G7elsq
         Rgtq3hBYdS4e5y/1hph9y4I2BQ+NpKCZCIlWR27tf1Cy6dCGSMQgqX8+SIFKjvOhfE8y
         68ZFz9u/l6R0o1Iqi4XgO9qjdmGpy1Bj3MurPgJCUmymIqgS14CsFHgkzUB/EIdnYAu4
         hcs6Sq0sYOJDfgJvi+IBrae5oRnkBIUZWz8XxbjfhnDgH2DDPIPwSuaw3JgfsxEA44iT
         dhGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cTFFRrPPMNXyj68w5vFnNgaB8lehH1R0kT3hViXW+dk=;
        b=lnyJUH5lB4BgjRHeyfqIGkecpAcwFOS2rdeREESuhBOqT4D5ZXPIHv1Q4elgrkYq1X
         DKGgvs+h++EJnfZot79WWtgj9WzidPLxaALnK+M7yEtKkRUTXLU5CtrsNHD9HIX4GHAV
         KNq99qQT7LdjPyHQlJn7jihWe+T1/KjskUli5y1K06Zggr1mib0vHlXOz/eO4eeDjsaT
         ayEixUWnVr2px8CsvEdtsqw0Jjdt/8uKzGxSdF5yrf91W9E4SiXo2/FqpTp/uM8SWiTH
         wBXNPw2xLQc9tN0OelN1WhnagMWqDrKxIQMasjmdp4HAOQUujGXC/RPzS7DtDiFyb9u0
         ma+A==
X-Gm-Message-State: APjAAAXjs2mpo8PZ3DpvsY6Wo912dZ9OFFaKXHNFZNIOy0KnH3c+Tkkr
        g7esK2G3z1luc9JzJrhLvIlcUs3ZMtXbZmOh+OKrTqMy1Wk=
X-Google-Smtp-Source: APXvYqw3yFKpW73XgyJYcfYTsxOUShvhUDwR3Pjl9K1P63s7+QfByvx2PVt0acuaTHxDrzoiEwUsikGbxWQ/I43pl9U=
X-Received: by 2002:a2e:9c0b:: with SMTP id s11mr6081829lji.11.1579279501423;
 Fri, 17 Jan 2020 08:45:01 -0800 (PST)
MIME-Version: 1.0
References: <cki.FA900DB853.LBD049H627@redhat.com> <84944fa0-3c18-f8a4-47ca-7627eb4e0594@redhat.com>
 <20200116153741.GA558@rei> <1477632721.2420697.1579250111441.JavaMail.zimbra@redhat.com>
In-Reply-To: <1477632721.2420697.1579250111441.JavaMail.zimbra@redhat.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 17 Jan 2020 22:14:35 +0530
Message-ID: <CA+G9fYuuVLziEVJ+93OWSWeB0h-=_qaYcAObe=_JSsbtydO7cQ@mail.gmail.com>
Subject: Re: [LTP] ??? FAIL: Test report for kernel 5.4.13-rc1-7f1b863.cki (stable)
To:     Jan Stancek <jstancek@redhat.com>
Cc:     Cyril Hrubis <chrubis@suse.cz>,
        Rachel Sibley <rasibley@redhat.com>,
        Jianwen Ji <jiji@redhat.com>, Hangbin Liu <haliu@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Jianlin Shi <jishi@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 17 Jan 2020 at 14:05, Jan Stancek <jstancek@redhat.com> wrote:
>
>
>
> ----- Original Message -----
> > Hi!
> > > > One or more kernel tests failed:
> > > >
> > > >      ppc64le:
> > > >       ??? LTP
> > >
> > > Hi, I see max_map_count failed on ppc64le:
> > > https://artifacts.cki-project.org/pipelines/385189/logs/ppc64le_host_2_LTP_mm.run.log
> >
> > That's strange, we do attempt to map 65536 mappings but we do not touch
> > them, so these shouldn't be faulted in, so there is no real reason why
> > mmap() in the child process should stop prematurely at 65532.
> >
> > I guess that we cannot do much here, unless it's reproducible, because
> > there is not much information there.
>
> max_map_count.c:205: FAIL: 64882 map entries in total, but expected 65536 entries
>
> I can reproduce it by running it in loop for couple hours. Though no idea
> why we started seeing it only in 5.4.13 rc kernels, as there doesn't seem
> to be any significant mm changes.
>
> I'll try some older kernels.

I have noticed max_map_count fail intermittently on multiple stable
branches on slow devices.

max_map_count.c:202: FAIL: 63231 map entries in total, but expected
65536 entries

https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/tests/ltp-mm-tests/max_map_count
https://qa-reports.linaro.org/lkft/linux-mainline-oe/tests/ltp-mm-tests/max_map_count?&page=2

- Naresh
