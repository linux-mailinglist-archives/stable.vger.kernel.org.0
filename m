Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02250EF75D
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 09:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfKEIjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 03:39:19 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33356 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727401AbfKEIjS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 03:39:18 -0500
Received: by mail-lf1-f67.google.com with SMTP id y127so14433208lfc.0
        for <stable@vger.kernel.org>; Tue, 05 Nov 2019 00:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gdzE+6c0X0YWGdBkPcVhB+2E6S0ZBzl2+HXJPyALIxo=;
        b=QoZchN2MlJxPPnfv5ip5jv0Yo/GI7K8lFrh8GppZAg2NoF2W82BYVVKtg8unjTzK05
         4A0/STOOVg6Egqgg2JuVCqqBEcfeh8NoH3qWwBjLn6uodEGKQjeQYBqWIu2+5LkIRfmT
         hQxINtSoOnQ/95nXgsgY99s0YJ1IM3csCK0Pu81y1dzf0mVQctc4eBzgUpfzjMK6noVN
         +kZk15IkAKk8cw48vsn+fnOdniu1sAarADDlbsGSw8dBSugzLiv3uLKCJz0bKszhTKBr
         0z0vo2oYlJ4OeOLYxptMxI1fv0ziGoDQ6+VwZazbe++mjuPb5pvg2Z1akOSS8oHzTVHr
         e/ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gdzE+6c0X0YWGdBkPcVhB+2E6S0ZBzl2+HXJPyALIxo=;
        b=H+NdTbB/BHOAOK/FzW2yEzRSue5fXjgahOU9ZuwTOQczU0jlPOYR4ALFA6m7b0Zy+y
         neIvxgtfJGGjZXFnEm1JxAcLV2IgISBeSAnIxiVZ+56J1p3daHKZtDB88vkYaK/3DN2j
         6yCJMpflYcbQtwdmzBbUw9Exm9vFBTPXgpiX0TEZW7xb3WpEi7nnOCNe0cwgtzuZk+E1
         PHHMj9zDiLsVVJzcfZw3rp/en+I0216LM+0RyXTRHY9Y/W8vw4jGK2vpgeTX0FdMcydL
         F/jRwfra3AtZtq5bKU6ih9+qstwbXefbc0skb34c3z0oHfWdiW0+5A0jkTeq5bFuOS5/
         JibQ==
X-Gm-Message-State: APjAAAUo99AQVFeFC07Zx+k9WHV4Kgpq53ucTyPz7QPQl5M2+0WtfjOc
        065uEP3hpen3Ll2Z7Fn4QSLOArb80TBN7ar1Nh4SNw==
X-Google-Smtp-Source: APXvYqxqx8NSYnV4wfLrSehgFQT8UMqVuaihF8wIQXecappLCoFsidLTOfL7TBdEsLOE2/tRXfW1vIiqXg3kPMs383U=
X-Received: by 2002:ac2:5930:: with SMTP id v16mr1088027lfi.67.1572943156625;
 Tue, 05 Nov 2019 00:39:16 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYsWTFQZTHXUDPToaepnKGBoh61SsA_8SHcYgYZXN_L+mg@mail.gmail.com>
 <CA+G9fYu+6A3pYQGs2rydYtHNSCf1t9+OTRqrZeCbpc2ARLx2zA@mail.gmail.com>
 <20191105073459.GB2588562@kroah.com> <CA+G9fYvau-CY8eeXM=atzQBjYbmUPg78MXu_GNjCyKDkW_CcVQ@mail.gmail.com>
 <20191105080614.GB2611856@kroah.com>
In-Reply-To: <20191105080614.GB2611856@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 5 Nov 2019 14:09:05 +0530
Message-ID: <CA+G9fYtWc+6XzWZtG76T7+TdF+tAyUqJPQT8-ykZRTy1sCgEPQ@mail.gmail.com>
Subject: Re: stable-rc-5.3.9-rc1: regressions detected - remove_proc_entry:
 removing non-empty directory 'net/dev_snmp6', leaking at least 'lo'
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org,
        Dan Rue <dan.rue@linaro.org>, LTP List <ltp@lists.linux.it>,
        open list <linux-kernel@vger.kernel.org>,
        Jan Stancek <jstancek@redhat.com>,
        Basil Eljuse <Basil.Eljuse@arm.com>, chrubis <chrubis@suse.cz>,
        mmarhefk@redhat.com, Netdev <netdev@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>, maheshb@google.com,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 5 Nov 2019 at 13:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> > > > These reported failures got fixed on latest stable-rc 5.3.y after
> > > > dropping a patch [1].
> > >
> > > What is the subject of the patch?
> >
> > blackhole_netdev: fix syzkaller reported issue
> > upstream commit b0818f80c8c1bc215bba276bd61c216014fab23b
>
> That commit is not in any stable queue or tree at the moment, are you
> sure this is still an issue?

Since it has been dropped, the issue is gone now.

>
> > > > The kernel warning is also gone now.
> > > >
> > > > metadata:
> > > >   git branch: linux-5.3.y
> > > >   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > >   git commit: 75c9913bbf6e9e64cb669236571e6af45cddfd68
> > >
> > > The -rc tree is rebased all the time, can I get a "real" subject line to
> > > get a chance to figure out what you are trying to refer to here?
> >
> > Linux 5.3.9-rc1 is good candidate on branch linux-5.3.y and
> > linux-stable-rc tree.
>
> I can not parse this, what do you mean?

linux-stable-rc linux-5.3.y branch and make kernel version 5.3.9-rc1
is been tested and
no regresion found.

- Naresh
