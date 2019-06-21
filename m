Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9D7C4E1C8
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 10:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbfFUIQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 04:16:00 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:40106 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfFUIQA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 04:16:00 -0400
Received: by mail-yb1-f196.google.com with SMTP id i14so2315505ybp.7;
        Fri, 21 Jun 2019 01:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SD27W+Q8nlQECEnXGr9JLasdZ0XZgPtd59eGIQeGLDk=;
        b=mlTS7qVfk+URG6Ss+t40DkDNnv3J+1uwe+pbwqE0d97jii4p1QqzuvBNVevXkPv4WO
         PT0vuwkjsnkhCZqu/ks03J1AHIVmtCAdYDg9ImbuaPTAvlGI2FexnKufRYpdpG4+dcNv
         z2tfhGOMKo8Vr/cJ4Qtc7kHT2RhxCVN2pSVQBJVQeWvzM95AvnJNP9uI3+huBeWv7FhF
         GCMRs3RumNhvW5bYtYV9pg9wOwoF5ZIQet/0KIfr50j61+LI+fPUK2eiOQTfAv7SBlp9
         Vi2pkjAv/d4MxV4cvV1e28GbipoQdwo/2a59n/gHjJmjPXwQ9TuflmTVIO3rJUNIb9F/
         CLlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SD27W+Q8nlQECEnXGr9JLasdZ0XZgPtd59eGIQeGLDk=;
        b=rpHxzSkwb5ZOta0J0f4/JXnbqXFL6HRDJIymPHBKMYBCErOJY8PqVLW4CudUQIAadX
         ofyCgDtvbq4SsM2cCBjRAvyGSTz535mroUmWxm85wquVmDXzPKbwN72A8L4C9jASdky+
         g1BXa1xHYl1zUgd4ZQWikQugKTSuX5cXVuXUXCRtDluk7g7H5xoqt2EOW6Npvfd92SP8
         sYacIbpTBTgQo3cAHDP9ekdAt0mqJuOiK0Plv8OkVHPN7U1LAKw2XMtWG64+vSN1G0y4
         +kPM29bvMbOMbaXR6nsa5Fb+E+NUbg53bJimn97xN5m+5V+2/iBoCIouJKe6+330aZwZ
         wOGQ==
X-Gm-Message-State: APjAAAWRUC77qmq2X4v41T6dW6dnUOXJH0VK9odXEL2K2+ETTHeWrkTt
        5uVr1526GQmN5alddAYcXYxPXG9CTZgkJzzmRfw=
X-Google-Smtp-Source: APXvYqwiNDVIT3cY7nnNsonoy0+ifnCuu+SfoYqYS4cPELFcXm41MMvCUKFlqDY55PnEpJ1f2SXLEG8D648UMarn60k=
X-Received: by 2002:a25:8109:: with SMTP id o9mr61953811ybk.132.1561104959385;
 Fri, 21 Jun 2019 01:15:59 -0700 (PDT)
MIME-Version: 1.0
References: <1560073529193139@kroah.com> <CAOQ4uxiTrsOs3KWOxedZicXNMJJharmWo=TDXDnxSC1XMNVKBg@mail.gmail.com>
In-Reply-To: <CAOQ4uxiTrsOs3KWOxedZicXNMJJharmWo=TDXDnxSC1XMNVKBg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 21 Jun 2019 11:15:47 +0300
Message-ID: <CAOQ4uxiTTuOESvZ2Y5cSebqKs+qeU3q6ZMReBDro0Qv7aRBhpw@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] ovl: support the FS_IOC_FS[SG]ETXATTR
 ioctls" failed to apply to 5.1-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        stable <stable@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 13, 2019 at 11:49 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Sun, Jun 9, 2019 at 12:45 PM <gregkh@linuxfoundation.org> wrote:
> >
> >
> > The patch below does not apply to the 5.1-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> >
> > thanks,
> >
> > greg k-h
> >
>
> FYI, the failure to apply this patch would be resolved after you
> picked up "ovl: check the capability before cred overridden" for
> stable, please hold off from taking this patch just yet, because
> it has a bug, whose fix wasn't picked upstream yet.
>

Greg,

Please apply these patches to stable 4.19.
They fix a docker regression (project quotas feature).

b21d9c435f93 ovl: support the FS_IOC_FS[SG]ETXATTR ioctls
941d935ac763 ovl: fix wrong flags check in FS_IOC_FS[SG]ETXATTR ioctls

They apply cleanly and tested on v4.19.53.

While at it, I also tested that the following patches apply cleanly and solve
relevant issues on v4.19.53, but they are not clear stable candidates.

1) /proc/locks shows incorrect ino. Only reported by xfstests (so far):
6dde1e42f497 ovl: make i_ino consistent with st_ino in more cases

2) Fix output of `modinfo overlay`:
253e74833911 ovl: fix typo in MODULE_PARM_DESC

3) Disallow bogus layer combinations.
syzbot has started to produce repros that create bogus layer combinations.
So far it has only been able to reproduce a WARN_ON, which has already
been fixed in stable, by  acf3062a7e1c ("ovl: relax WARN_ON()..."), but
other real bugs could be lurking if those setups are allowed.
We decided to detect and error on these setups on mount, to stop syzbot
(and attackers) from trying to attack overlayfs this way.
To stop syzbot from mutating this class of repros on stable kernel you
MAY apply these 3 patches, but in any case, I would wait a while to see
if more bugs are reported on master.
Although this solves a problem dating before 4.19, I have no plans
of backporting these patches further back.

146d62e5a586 ovl: detect overlapping layers
9179c21dc6ed ovl: don't fail with disconnected lower NFS
1dac6f5b0ed2 ovl: fix bogus -Wmaybe-unitialized warning

Thanks,
Amir.
