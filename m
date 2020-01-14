Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4A2213AAE3
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 14:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgANNZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 08:25:57 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:53131 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgANNZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 08:25:57 -0500
Received: from mail-qv1-f47.google.com ([209.85.219.47]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MLQl3-1j9AAa2gF9-00IWIF; Tue, 14 Jan 2020 14:25:55 +0100
Received: by mail-qv1-f47.google.com with SMTP id f16so5624337qvi.4;
        Tue, 14 Jan 2020 05:25:55 -0800 (PST)
X-Gm-Message-State: APjAAAVvNkoecJ3BGs8OotCyPhaOyeEiHSbMIJEOIbSXQIS5qc3kSt+c
        vsQin6yMvCHV8rtPAbUqoEsk6IXIXCDY7oqeqOk=
X-Google-Smtp-Source: APXvYqxKBFJwxdm1IsfQ2pWB2NZNq11dYRZSUB388qTjEFgYJ2C/j5g292CLulv5pnMTjoZScAr8EDMMVlvvB247yH0=
X-Received: by 2002:a0c:e7c7:: with SMTP id c7mr16849404qvo.222.1579008354403;
 Tue, 14 Jan 2020 05:25:54 -0800 (PST)
MIME-Version: 1.0
References: <157858781831.30329.9402583283109438334.tip-bot2@tip-bot2> <20200114130955.2EAC824685@mail.kernel.org>
In-Reply-To: <20200114130955.2EAC824685@mail.kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 14 Jan 2020 14:25:36 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2JXFZ2cu4djeKwSNGpNusTiLcqtK6P-czTbG1h=T2m=w@mail.gmail.com>
Message-ID: <CAK8P3a2JXFZ2cu4djeKwSNGpNusTiLcqtK6P-czTbG1h=T2m=w@mail.gmail.com>
Subject: Re: [tip: smp/urgent] cpu/SMT: Fix x86 link error without CONFIG_SYSFS
To:     Sasha Levin <sashal@kernel.org>
Cc:     tip-bot2 for Arnd Bergmann <tip-bot2@linutronix.de>,
        linux-tip-commits@vger.kernel.org,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:xtP8VfJxZCNnWVXa44BqVIy2nqMNG81fMXQAyB3KsKvTIwPVabv
 UShsXL4tarrk7/9iy5uGZED5taVlnZwiW7JuGY6QErn5+vFx7m3FgfAx/MShvSisaSEDUHI
 BtiZRw8Qf9z9c5CCydb2DIPfm1nPw2Y91E1jdeyT7A4mdKLiHMx5C1/wgDNo9txitFzLuF0
 yFbKAhajUJ639FvsV7pmw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:SoOa7GDRIgY=:c8ShLUzIZyJ1vbb+9gVFaW
 8humtsbUTCjdLlyDRTeU5nDixhKs+7OkqaMdlD+12O/gQ2bdyunEA7UhE+wQp9oVPAdIFFLyM
 QofV68R618DJBhGmED6L9h3kPIo/++ge0oIhu8Ia81r5oByTEKVfDM9oQ9v1vKXufLlSwsssP
 fBWz2HUORI7AtPKdqcrxIFeKKjAoeOnampGsw73BFTttJzrR+ZJrvjYRje4IZayJ+i1Gp0MTr
 Q991rYzaJjZYEG3vBPS7iUu+YfdKwEG5B4tlcOuXl0QerB/jjJJuULo06iREvYuvrmPq9umm3
 Ip1H0B/tM3bLZ7BSTOIyWcOY+a2y7Nocf4/GidH7RaozhUnns2U5H1LsJ1mWTRS0gGhHVonOy
 vcWqZC3Jugxt9lJ2uLjVClwjB49ai8JH78nS1Bxle12Hojp3Bw9O+GcyvHm+71PvId4jXomDZ
 mg7deBLcSQ39TTR/bmcLSvuvhJKlOgbhB/uDi30XP19JBm8SgS8eVUYy9750Ox/xy6LU9lU26
 BwL02PDwqK8Q6fbAfxjt6rLdMG2T2AhfIPkZtHH5R/4zv+BOuPSxd34G7eD14InGsqQ+Bqevl
 /PTCNhHiAqCllAQAN/TAATdO99tUh5br4E9Napm3HZV4beUuKLklhsRVfuUOcE9u6SafW9lxE
 339y0aYpCc10+MDPnRsTIg/5UBszNi4FMv13SwK1GTHkgREagIPkmzRXb2GcHRl88+AHJ/aFW
 YuRNtw45eOf2vB49khpf5XaoW1VJNP6z/h7Ylwgw6mJhmTf1BJP/ty8s5vVRaXPGDRjy1obRn
 J/4Mv9cit9tZgiS9CDvEomILpNb1Thk/pSVdoknxlPZCTwEbJ1ihTUfN7/B2WYZEcXdyam/tA
 zgNdF5/njSziW3hfYPaA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 14, 2020 at 2:09 PM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: ec527c318036 ("x86/power: Fix 'nosmt' vs hibernation triple fault during resume").
>
> The bot has tested the following trees: v5.4.11, v4.19.95, v4.14.164, v4.9.209.
>
> v5.4.11: Build OK!
> v4.19.95: Failed to apply! Possible dependencies:
>     34d66caf251d ("x86/speculation: Remove redundant arch_smt_update() invocation")
>     de7b77e5bb94 ("cpu/hotplug: Create SMT sysfs interface for all arches")
>
> v4.14.164: Failed to apply! Possible dependencies:
>     34d66caf251d ("x86/speculation: Remove redundant arch_smt_update() invocation")
>     de7b77e5bb94 ("cpu/hotplug: Create SMT sysfs interface for all arches")
>
> v4.9.209: Failed to apply! Possible dependencies:
>     34d66caf251d ("x86/speculation: Remove redundant arch_smt_update() invocation")
>     de7b77e5bb94 ("cpu/hotplug: Create SMT sysfs interface for all arches")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?

According to the changelog text, the patch is only needed on v5.2 and
higher, so this
is all good.

        Arnd
