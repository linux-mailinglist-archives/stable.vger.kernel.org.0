Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868032B99F2
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 18:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgKSRqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 12:46:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49172 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728266AbgKSRqR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 12:46:17 -0500
Received: from mail-ed1-f71.google.com ([209.85.208.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <guilherme.piccoli@canonical.com>)
        id 1kfo04-0002Et-Ub
        for stable@vger.kernel.org; Thu, 19 Nov 2020 17:46:14 +0000
Received: by mail-ed1-f71.google.com with SMTP id g1so2670378edk.0
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 09:45:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UcNqyeQmFGNZ/Z1t0naZPh421CcgFl6xNwdW4VrpvsQ=;
        b=VzTh4oHU3/XqPucMtszgzmcPMHLxzk2xnKixteVktMegj/znxsmyjNBb3rPM53gqhC
         zr7vz3o1m0il9nS61KGDm+FkgMfzMcSXX4uVVkg+/PAJRLwx+PrrTSyUrg7N36lVvpdn
         BzMlmEZYSIvyMG4WzFNGVNS8HfBl+af2F28JVgCu2m0wJewwevgSo6fIVavIfHz1V3hH
         nwFoJi7OLDLfjBe5up4SAn4sH7aipSp3vKNsS6gzMa6kTRshZb9meZbyzDXaHchrkqRx
         I/koQoqHKSVUjsuMjUK+hd3kk96Rx5+IOt8YGhvciJgtXlJVE0qnsyOdHK2otm5l4fut
         AlYg==
X-Gm-Message-State: AOAM531L+V3POdF2OzCwyP9Lq5Hf2vICE2TfFJMu2bsqHtOa9zq5/q3v
        KHjZppcuQLE/d4xcNPr8CDISzBcR2gA9q75seRaTUgmR40YnYeJPQH+UPoV4ad8908+hcWAYUyc
        L6oRAC1H8FTsqjbqQCth9QppCNb3cGYmVsP9rRA830YY5n1LaIQ==
X-Received: by 2002:a05:6402:114c:: with SMTP id g12mr31644743edw.167.1605807940666;
        Thu, 19 Nov 2020 09:45:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwcMqog08yb/SpQWquGH3DWwblAtqsXkiIVoTLNnkrSpAcVJQiz8QjwdRLG3MkbSV9gv1YP0zjsFeVMZ2QFUZo=
X-Received: by 2002:a05:6402:114c:: with SMTP id g12mr31644720edw.167.1605807940471;
 Thu, 19 Nov 2020 09:45:40 -0800 (PST)
MIME-Version: 1.0
References: <d3188913-ddb8-7198-8483-47d3031b01fe@canonical.com>
 <CAHD1Q_zRaaROK_TCGg0csua=r9pskwKxCnztGW7XPK71n68DGw@mail.gmail.com> <BN8PR12MB297872B12C4DBE0793605F9B9AE00@BN8PR12MB2978.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB297872B12C4DBE0793605F9B9AE00@BN8PR12MB2978.namprd12.prod.outlook.com>
From:   Guilherme Piccoli <gpiccoli@canonical.com>
Date:   Thu, 19 Nov 2020 14:45:04 -0300
Message-ID: <CAHD1Q_z+Y6b7ay69jOvcOBwQYFmgcPUkdaFu8zTc1QxqfoY2xA@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix unthrottle_cfs_rq() for
 leaf_cfs_rq list" failed to apply to 5.4-stable tree
To:     Tao Zhou <ouwen210@hotmail.com>, Ben Segall <bsegall@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Phil Auld <pauld@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "# v4 . 16+" <stable@vger.kernel.org>,
        Gavin Guo <gavin.guo@canonical.com>,
        Nivedita Singhvi <nivedita.singhvi@canonical.com>,
        "Heitor R. Alves de Siqueira" <halves@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 19, 2020 at 1:44 PM Tao Zhou <ouwen210@hotmail.com> wrote:
> [...]
> That time I realized something, but..
> I try to remember something and get some impression.
>
> We need to update the below when do not need to enqueue entity because
> this is added for runnable_avg updating,
>
>         update_load_avg(cfs_rq, se, UPDATE_TG);
>         se_update_runnable(se);
>
> Earlier version do not introduce the above to only update runnable_avg.
> Use one *for loop* is enough though. Please correct me if I am wrong.
>

Thanks a lot Tao! I'm not sure, I'm definitely not an expert in the
scheduler. Will defer this one to Vincent / Peter / Phil / Ben.
Cheers!
