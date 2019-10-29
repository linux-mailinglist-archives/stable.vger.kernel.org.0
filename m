Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27C3EE8B50
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 15:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389722AbfJ2O5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 10:57:18 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:40622 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389095AbfJ2O5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 10:57:18 -0400
Received: by mail-il1-f194.google.com with SMTP id d83so11600626ilk.7
        for <stable@vger.kernel.org>; Tue, 29 Oct 2019 07:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zVkD+LaGViq5vRUuz19jpR+ncRKVH06c3nxLs7qy0yk=;
        b=d2NhlrX48gi03GtFcTrxC0B2qNrjb5V7IECjjXyKWtmXoH5Aax+o6hwz/PqT2lx40P
         X/fsYftcSN/dOVxpvrTp8dlCZbjonzWHo5FHDJkRUqVILnG4DG4RsuEpX1E1Ic8OTsOZ
         akpTmHIAE1twrjDkLdt/f+XmnOxGPk2Aesk+ohv2rZhTaQDbzRXniKrakJjCM5D3ytV5
         2fPhzxq+NlpUwg9JHxhoTHNtWsMmVMuoC3tR9vqmDYhRBBTNUOcLiFj8OIzXAAeF6t0O
         xTsYdbR2lwaCxDIBKxXSxZ8JLBRP7LFzSvfYsaEO+Ujn+LB6E4wKXuK/lW3cJy1GHh7R
         zsBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zVkD+LaGViq5vRUuz19jpR+ncRKVH06c3nxLs7qy0yk=;
        b=h1lRmOWCBWsGJ6Ms1f7UkyQiNeJ2qOsvKyngJriFZ6sTCnatCFZtCS3CotRE4AHy09
         cZitGRJCJ1aYXi6U3vUpa8gZd23lphISyXlXkXp7Mh5ADYtshSLlbFpPvi86m1VkUHmq
         7rKS7xZ1Y+S48to3qkFUGYvLowkKfAGwqv/xx1aAobOsXBDpPjfAvwWHN37AJgXnzRZ9
         D32rZ5fibZM9NmMSLa2WseKl1RJDwWvpvbIQLAMBhGdrPp6gk9TdsxlMVraCc3tfvLkh
         72kl+qAzXg7yqWUEA7TwdULZiNuCYLK5vYMd0zOtEP5pe5Iv1e6laRqZS8WZ1p30nCQl
         ty8g==
X-Gm-Message-State: APjAAAUv4A0ac2OUhwG/+0zxVlVOuQqFVlyN8cUs9K7kTzALAKbKV1HY
        jQZwnmSqugdlXec+VlFneT0xuBk1JGz9dO6/PV0=
X-Google-Smtp-Source: APXvYqzyxHG2P1ob4HYShNB1hKpfl2zCFHQQFY6339T+vOYNoBiRueXrnIbjUXs2XcpgN6KquR7rhuvLsBDoWNeczZ4=
X-Received: by 2002:a05:6e02:d8b:: with SMTP id i11mr29031112ilj.81.1572361037079;
 Tue, 29 Oct 2019 07:57:17 -0700 (PDT)
MIME-Version: 1.0
References: <cki.42EF9B43EC.BJO3Y6IXAB@redhat.com> <CA+G9fYvhBRweWheZjLqOMrm_cTAxNvexGuk16w9FCt12+V1tpg@mail.gmail.com>
 <20191029073318.c33ocl76zsgnx2y5@xzhoux.usersys.redhat.com>
 <20191029080855.GA512708@kroah.com> <20191029091126.ijvixns6fe3dzte3@xzhoux.usersys.redhat.com>
 <20191029092158.GA582092@kroah.com> <20191029124029.yygp2yetcjst4s6p@xzhoux.usersys.redhat.com>
In-Reply-To: <20191029124029.yygp2yetcjst4s6p@xzhoux.usersys.redhat.com>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Tue, 29 Oct 2019 07:57:05 -0700
Message-ID: <CABeXuvpPQugDd9BOwtfKjmT+H+-mpeE83UOZKTLJTTZZ6DeHrQ@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E2=9D=8C_FAIL=3A_Test_report_for_kernel_5=2E3=2E8=2Drc2=2D96dab?=
        =?UTF-8?Q?43=2Ecki_=28stable=29?=
To:     Murphy Zhou <xzhou@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Linux Stable maillist <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Eryu Guan <guaneryu@gmail.com>,
        CKI Project <cki-project@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The test is expected to fail on all kernels without the series.

The series is a bugfix in the sense that vfs is no longer allowed to
set timestamps that filesystems have no way of supporting.
There have been a couple of fixes after the series also.

We can either disable the test or include the series for stable kernels.

-Deepa
