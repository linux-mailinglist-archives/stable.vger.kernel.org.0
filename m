Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC70B47376A
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 23:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240519AbhLMWYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 17:24:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234623AbhLMWY3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 17:24:29 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5394DC061574;
        Mon, 13 Dec 2021 14:24:29 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id d10so41940260ybe.3;
        Mon, 13 Dec 2021 14:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ch2TdgR4AmygX6qQzzvXHiybw81RXUfB559RRg917nA=;
        b=GatuucZfu0mNLwCzfIXpkTTsM5Gajkhdcnonl4QsnM242XkBgSfYHoRsRSpIcU+8pa
         5ecakBaGuq0Jx+p+mVTzpzH2iJQqf/l4sxisCIIjYBDG8mQyjUqCn8eXCgiF9+asojXE
         lpAE5veAX03b8dVUliKhfq3FvYX5EXdRgaw7TW0UbCU17A/XwHYvfpbk1bdgxSGvzy8V
         6vBPGjKEzqwBHV3sPTUjgtnG2BVs2ZRiSITiksEwBo524QgCX9/HUNKuMgawyszqngHj
         0aWsJeoVJhXzwZAgtca1c0ZcVAKu6e/T6pFcjmWtK0u4cTnn2pg0/HfornBZY3J0LJ9g
         bZow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ch2TdgR4AmygX6qQzzvXHiybw81RXUfB559RRg917nA=;
        b=1pl3VVWLUe64CKs+ETM5TNChysfnEpvRrBI5bP39U9BV6Z1PMsYCJYsR8/JFNtMuJ4
         Qvc6e88+cCqZf8UcwBl+lxDpQqe2WsWR/8RYtSv604LAavhspMwUSYMUWem2mB4zHbC5
         igWFJYm+Rky0YE+HVCgdocuEur9ZCc6M7X30BwuWlHkZKE8yj1FhvOoyLNHsT3xWqRcy
         FsfVCFUQ4esWOaHiIxEwI9NoXRwu7JsTMh67D0dLXRmELetPo/AVN+7v3oi206nfJvYE
         M6QMAab9j/76P+RBjMNtT027rDs4j29Ij4wskUI0evNBjuI8X3Sfk+xi3SJxnJVV9lXj
         79Rg==
X-Gm-Message-State: AOAM532xgQS2DtOO/ZongYO1J35+x8dTcsAidq26E76+4Ja3LorpOLCQ
        Qmh92daKW7TIhuMnuuJpH+pqvytM/UMI+UcIeVn7+0iiKI4=
X-Google-Smtp-Source: ABdhPJzOT/e6m/v4qmub3IWQ1CPmBQ3dO6l/nuefGYIy79KnYoKwJZK/QjgVqkahLBcG/7uRgmj8OcXZJgqK70LtqHM=
X-Received: by 2002:a5b:489:: with SMTP id n9mr1419998ybp.721.1639434268468;
 Mon, 13 Dec 2021 14:24:28 -0800 (PST)
MIME-Version: 1.0
References: <20211213092930.763200615@linuxfoundation.org> <CADVatmPsqW050=k07RDChjnf_F+MJfkLzHiRcdeoWQ7Mws_qMw@mail.gmail.com>
 <CADVatmMMe7NGpX9CcViLrhxP69gJ6m+9rViEVuh0E6j1QXGDVg@mail.gmail.com> <CAHk-=wh14HQZHWr=aNjpKrq-dP51iA6YbL3LmZGEVsOkWL-9XA@mail.gmail.com>
In-Reply-To: <CAHk-=wh14HQZHWr=aNjpKrq-dP51iA6YbL3LmZGEVsOkWL-9XA@mail.gmail.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Mon, 13 Dec 2021 22:23:52 +0000
Message-ID: <CADVatmN2NwdVoR823x8xvOOz2C1rp4k0dOngT+v3MQ1EXw5GZg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/74] 4.19.221-rc1 review
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 7:06 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, Dec 13, 2021 at 10:59 AM Sudip Mukherjee
> <sudipm.mukherjee@gmail.com> wrote:
> >
> > >
> > > Just an initial report. mips allmodconfig is failing with the following error.
> >
> > Ignore this please. I am not seeing the error on a clean build. Need
> > to check what went wrong with my build script.
>
> The gcc plugin builds often fail if there's been a gcc version update,
> and you need to blow the old plugins away.

I have not changed my gcc since 20211112.
And, I also have "scripts/config -d GCC_PLUGINS" as part of my build script.
Anyway, I will trigger my build for v4.19.221-rc1 again to verify.


-- 
Regards
Sudip
