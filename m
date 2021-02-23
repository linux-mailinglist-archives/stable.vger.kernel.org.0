Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7627D322901
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 11:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhBWKsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 05:48:52 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63131 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbhBWKsu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 05:48:50 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210223104756euoutp013bd71413915b2d5c6c1acf9159108f93~mWrslg9qZ3062930629euoutp01i
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 10:47:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210223104756euoutp013bd71413915b2d5c6c1acf9159108f93~mWrslg9qZ3062930629euoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614077276;
        bh=O18C7NkrVUWOEXXqkIut9+cUmQ4gaqnLQQ/SVXsnk28=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=CstA0S+nuB4zTK47VHs2cu3k/6k0dzkVIH2APTnxg0Kh9yF///F22ZaNiwW8ATC+q
         8gUOWIudZoTZUd1nYiTsXhkjzH8Gp2TmApa8T4ZYB26JoCeqIsEhrfDwFVAu2ALLBM
         Z8tEFnAPMsfFJC0Q2jmMPOkISsQv3gcOF0dPmM/I=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210223104756eucas1p17c2ef81948ba50b3030d516ff7bcdde4~mWrsdThNO2852828528eucas1p1R;
        Tue, 23 Feb 2021 10:47:56 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id FC.61.44805.C5DD4306; Tue, 23
        Feb 2021 10:47:56 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210223104755eucas1p2cbacf24a50c0a2ff0098a6a2e45beb58~mWrr1qcAx2396623966eucas1p2I;
        Tue, 23 Feb 2021 10:47:55 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210223104755eusmtrp289c505fe6d85712a4ad06fe5617db20e~mWrr0-PHh2053320533eusmtrp2J;
        Tue, 23 Feb 2021 10:47:55 +0000 (GMT)
X-AuditID: cbfec7f4-b37ff7000000af05-d3-6034dd5ce89d
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id B8.5D.16282.B5DD4306; Tue, 23
        Feb 2021 10:47:55 +0000 (GMT)
Received: from [106.210.134.141] (unknown [106.210.134.141]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210223104755eusmtip1b6ecabb9ce0ad0d1fb6cd9605e141e16~mWrrbHxIB2343923439eusmtip1N;
        Tue, 23 Feb 2021 10:47:55 +0000 (GMT)
Subject: Re: [PATCH v2 1/6] ASoC: samsung: tm2_wm5510: fix check of of_parse
 return value
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org
Cc:     tiwai@suse.de, broonie@kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>, stable@vger.kernel.org
From:   Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-ID: <2c96aa88-2a53-3eca-e9d7-24ea9afe63a7@samsung.com>
Date:   Tue, 23 Feb 2021 11:47:54 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210222213306.22654-2-pierre-louis.bossart@linux.intel.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsWy7djPc7oxd00SDFbOYrG4cvEQk8XUh0/Y
        LM6f38Bu8ev/MyaLBRsfMVq83PyGyYHNY8PnJjaPTas62TzmnQz02Hy62uPzJrkA1igum5TU
        nMyy1CJ9uwSujK4rv1gKrnJVHH96nK2B8QtHFyMnh4SAicTSy8cYuxi5OIQEVjBKTNsxjwUk
        ISTwhVHi/kJ2iMRnRol1B1YwdzFygHV8fxkPEV/OKPGqbQYrhPORUaJlzxqwbmGBaIk11zYx
        g9giAnESy7+cZwexmQXSJDac/w9WwyZgKNF7tI8RxOYVsJO4vHQFK4jNIqAqsfvsdbB6UYEk
        ib+/bzJB1AhKnJz5BKyXU8BL4vOiKYwQM8Ulbj2ZzwRhy0tsfzuHGeQgCYErHBI/j31jg/jT
        RWL6szZGCFtY4tXxLewQtozE/50gzSANzYwSPbtvs0M4E4D+P74AqsNa4s65X2wg/zMLaEqs
        36UPEXaUeHVqFRMkWPgkbrwVhDiCT2LStunQ0OKV6GgTgqhWkfi9ajoThC0l0f3kP8sERqVZ
        SF6bheSdWUjemYWwdwEjyypG8dTS4tz01GKjvNRyveLE3OLSvHS95PzcTYzApHP63/EvOxiX
        v/qod4iRiYPxEKMEB7OSCC/bXaMEId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rxJW9bECwmkJ5ak
        ZqemFqQWwWSZODilGpg8Ml7YXNy/0IB3dlja83OeL+dm5btJb1yxPYz3fk/kZOvQurYVpsWP
        uq/tu1b3aIPo79isHx9u7zGMfnN5TX3Q/8p2S+F7QilclzMtvmh+m1Qlcduh4PhMxbJ7rNmO
        jAs5RFLyFnHLBK08JecqesTBmme1iPxlvUPidtfnh1ns4b0qud26cv7UY6E/Fh0Qs2hzcM66
        Yc724x+Ty+f/D3m0HgS8PjdpZSvXieLz4vFXZP3OBspXXToibtFX63BEI+fc+tKi+zcnPrd/
        dNTqFI+jvPTWR36cVY+UNlXbyLLKPLMMn62ceOBp1Ukvx/KS73J3nBWErd1kZ66/4bVJVP14
        oo5xnYtEe8sZiWOz2pRYijMSDbWYi4oTAd0sRWSpAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsVy+t/xu7rRd00SDO6el7S4cvEQk8XUh0/Y
        LM6f38Bu8ev/MyaLBRsfMVq83PyGyYHNY8PnJjaPTas62TzmnQz02Hy62uPzJrkA1ig9m6L8
        0pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNTJX07m5TUnMyy1CJ9uwS9jK4rv1gKrnJV
        HH96nK2B8QtHFyMHh4SAicT3l/FdjFwcQgJLGSVae+6zQcSlJOa3KHUxcgKZwhJ/rnWxQdS8
        Z5ToPfCTFSQhLBAtsebaJmYQW0QgTmL3wkMsIDazQJrEvpcn2UBsIYG7jBLfLySB2GwChhK9
        R/sYQWxeATuJy0tXgM1hEVCV2H32OjuILSqQJLF++k0miBpBiZMzn4DN5BTwkvi8aAojxHx1
        iT/zLjFD2OISt57MZ4Kw5SW2v53DPIFRaBaS9llIWmYhaZmFpGUBI8sqRpHU0uLc9NxiI73i
        xNzi0rx0veT83E2MwBjbduznlh2MK1991DvEyMTBeIhRgoNZSYSX7a5RghBvSmJlVWpRfnxR
        aU5q8SFGU6B/JjJLiSbnA6M8ryTe0MzA1NDEzNLA1NLMWEmc1+TImnghgfTEktTs1NSC1CKY
        PiYOTqkGJhYGhRUHU8XWrpOWWfF+7lMF75X3e5fOFVXMO7GhmEkzm9uk4PHmGQVSJ4L/LLzv
        avlfWr0t+aVJgT/T0y8Konnbp0wrSxJ1nFp4RuSQpFyamNaVgIIwtrlrtnV+/ngw+9n192qv
        bpTsPODT83GDweNcNbe6kh+xu+oO9MxdUdthXBAtcu5u417VYLFOs1/Tf4kevf5hwUMTP+kI
        kaDeyEV867O3bBIVr+5I2P7/kXhFonSejGPbrivKX0xZLXcvnfBunX9nh71v1vvJfIF955yn
        t35+Hqjw3fKcmnDa6tzac8tmbbAoMQhkO5KutHdlxftA3iNWH5e5cwVcV3p732md955wvl/3
        2+JUzNPmK7EUZyQaajEXFScCAPLdrwo6AwAA
X-CMS-MailID: 20210223104755eucas1p2cbacf24a50c0a2ff0098a6a2e45beb58
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210222213325eucas1p18611358dee29234661ceeac6ac29ce52
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210222213325eucas1p18611358dee29234661ceeac6ac29ce52
References: <20210222213306.22654-1-pierre-louis.bossart@linux.intel.com>
        <CGME20210222213325eucas1p18611358dee29234661ceeac6ac29ce52@eucas1p1.samsung.com>
        <20210222213306.22654-2-pierre-louis.bossart@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22.02.2021 22:33, Pierre-Louis Bossart wrote:
> cppcheck warning:
> 
> sound/soc/samsung/tm2_wm5110.c:605:6: style: Variable 'ret' is
> reassigned a value before the old one has been
> used. [redundantAssignment]
>  ret = devm_snd_soc_register_component(dev, &tm2_component,
>      ^
> sound/soc/samsung/tm2_wm5110.c:554:7: note: ret is assigned
>   ret = of_parse_phandle_with_args(dev->of_node, "i2s-controller",
>       ^
> sound/soc/samsung/tm2_wm5110.c:605:6: note: ret is overwritten
>  ret = devm_snd_soc_register_component(dev, &tm2_component,
>      ^
> 
> The args is a stack variable, so it could have junk (uninitialized)
> therefore args.np could have a non-NULL and random value even though
> property was missing. Later could trigger invalid pointer dereference.
> 
> This patch provides the correct fix, there's no need to check for
> args.np because args.np won't be initialized on errors.
> 
> Fixes: 75fa6833aef3 ("ASoC: samsung: tm2_wm5110: check of_parse return value")
> Fixes: 8d1513cef51a ("ASoC: samsung: Add support for HDMI audio on TM2board")
> Cc: <stable@vger.kernel.org>
> Suggested-by: Krzysztof Kozlowski <krzk@kernel.org>
> Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Thank you for fixing all those issues.
