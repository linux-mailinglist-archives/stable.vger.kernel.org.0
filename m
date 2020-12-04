Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26F52CE5C1
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 03:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgLDCfP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 3 Dec 2020 21:35:15 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44244 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgLDCfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 21:35:15 -0500
Received: by mail-lf1-f65.google.com with SMTP id d20so5642033lfe.11;
        Thu, 03 Dec 2020 18:34:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Khyohy6WhzBAgPM/rW15M8eybNg16Dm1715a14gwKs8=;
        b=hqp6dl6hkgvmqn4YHktkBnmNAeqpVmRsFSP45CVAbfr1Ie2ey3ixhOsRUpxyXXUmb3
         YzCkJqJFiltB4oZDB0Pq4ModFvF9U892ANb3tbfjF6kgrIYxxT5eFigPXjbzMjMWxydz
         IVaqHwD+pq3LNdqHGVCEmEeikMYTPI2c9GdehdjkjsMmMyJfsC4Qitf9AhwLMDPEnb/w
         J3g5DBLLF+1v/MLch2gEX0zBVJg7ucafPUaXzWZHu1nB5mdqVQuxaRrhCEE5D9vzEPCN
         fmKiNZ8ksP1PHMsmF0CKcQL2qciHdnU/0B33uxNQxBL6DHreaglaZb1kuvA/GTl7NWsD
         l/hQ==
X-Gm-Message-State: AOAM533bHkf8Tw43Jr/cDZcVk6Boxkd7m0xnDYTYyxdONkr+YAKvVf6P
        Lza2Gnaz/UxqAbC2Qp43KgDTVNLZNtpi8Q==
X-Google-Smtp-Source: ABdhPJwhP/fM750CBb47AvSk51ohSXZaxB/Z5m2xdMbqa7qcVJwvdx1TylOYIqsU5OUStGz76ZWpww==
X-Received: by 2002:ac2:484f:: with SMTP id 15mr2301344lfy.553.1607049272479;
        Thu, 03 Dec 2020 18:34:32 -0800 (PST)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id n4sm1155464lft.121.2020.12.03.18.34.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 18:34:32 -0800 (PST)
Received: by mail-lj1-f180.google.com with SMTP id t22so4918553ljk.0;
        Thu, 03 Dec 2020 18:34:32 -0800 (PST)
X-Received: by 2002:a2e:b0c8:: with SMTP id g8mr2482924ljl.331.1607049272093;
 Thu, 03 Dec 2020 18:34:32 -0800 (PST)
MIME-Version: 1.0
References: <20201130234520.13255-1-dinghua.ma.sz@gmail.com>
 <CA+Jj2f8ADtb8JPPPzafvgVM0jssk8fz_BS-3LDUaYjZHcouTJQ@mail.gmail.com>
 <20201201150036.GH5239@sirena.org.uk> <CA+Jj2f9=oCxdnaHJTtPXwvwokRX9HRMDYUNrbDASmV+FoTefvQ@mail.gmail.com>
 <20201202161042.GI5560@sirena.org.uk>
In-Reply-To: <20201202161042.GI5560@sirena.org.uk>
From:   Chen-Yu Tsai <wens@csie.org>
Date:   Fri, 4 Dec 2020 10:34:21 +0800
X-Gmail-Original-Message-ID: <CAGb2v64md8HdxzRpwCoTVkuiMFj2BWWoEKc0KNuALVUF83XAXw@mail.gmail.com>
Message-ID: <CAGb2v64md8HdxzRpwCoTVkuiMFj2BWWoEKc0KNuALVUF83XAXw@mail.gmail.com>
Subject: Re: [PATCH v2] regulatx DLDO2 voltage control register mask for AXP22x
To:     Mark Brown <broonie@kernel.org>
Cc:     dinghua ma <dinghua.ma.sz@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 3, 2020 at 12:11 AM Mark Brown <broonie@kernel.org> wrote:
>
> On Thu, Dec 03, 2020 at 12:04:05AM +0800, dinghua ma wrote:
> > I sent a new email. I don’t know if you received it. The subject is "[PATCH
> > v3] regulator: axp20x: Fix DLDO2 voltage control register mask for AXP22x"
>
> No, no sign.  You can check if things are at least hitting the list at:
>
>     https://lore.kernel.org/lkml/

I did receive it though. Would it help if I tried to bounce it to you
and the lists?

ChenYu
