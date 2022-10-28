Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B5D611386
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 15:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbiJ1NsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 09:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbiJ1Nr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 09:47:56 -0400
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD081DD89E
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 06:46:06 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20221028134603euoutp028f600022f5e1ba04791f02ad3b641e10~iP57SnuIj2892828928euoutp02K
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 13:46:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20221028134603euoutp028f600022f5e1ba04791f02ad3b641e10~iP57SnuIj2892828928euoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1666964763;
        bh=RMlwSajiI9aOhuFaMtICTVZnXT/QmMki7tEP8CkRFGc=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=AnkxQBCr7f+guwtjo5lGn5YpjPqaLw4lCe90Y08bOUi12kSyTk3YEjbRm73x98KjL
         Z4IZryk4vjizbBXYejzFOoM97bPPeZf/aNk4NpMKY3qKCSickQ3ELGB0fvsJ0drs7W
         Z2PlgZzyXI4sgNa//HgcApH0kcx/F2ReE/aiZR1Q=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20221028134602eucas1p162a9231f7bc64982ca3653ba7b55ac4b~iP561ityV0609506095eucas1p1V;
        Fri, 28 Oct 2022 13:46:02 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 0F.BE.19378.A1DDB536; Fri, 28
        Oct 2022 14:46:02 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20221028134602eucas1p263f5b1972295650ae2708a44f9e9cae7~iP56IptEZ1545415454eucas1p24;
        Fri, 28 Oct 2022 13:46:02 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221028134602eusmtrp1ed3e3f82e21a46c84fcb1a7d6bf21e7d~iP56GmWbY3233032330eusmtrp1B;
        Fri, 28 Oct 2022 13:46:02 +0000 (GMT)
X-AuditID: cbfec7f5-a4dff70000014bb2-a3-635bdd1ac55b
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 40.DE.07473.A1DDB536; Fri, 28
        Oct 2022 14:46:02 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221028134601eusmtip2ac4c0c2f9a0cd60b885db2c3fc6cb10d~iP55ZGlg01295712957eusmtip2L;
        Fri, 28 Oct 2022 13:46:01 +0000 (GMT)
Message-ID: <ac7918ea-ae67-fd0d-bb0f-b0093908f6d7@samsung.com>
Date:   Fri, 28 Oct 2022 15:46:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0)
        Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH stable-5.15 3/3] usb: dwc3: disable USB core PHY
 management
To:     Stefan Agner <stefan@agner.ch>, Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        stable <stable@kernel.org>, regressions@lists.linux.dev,
        krzk@kernel.org
Content-Language: en-US
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <808bdba846bb60456adf10a3016911ee@agner.ch>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsWy7djPc7pSd6OTDT7fM7ZoXryezWJFpUXT
        jR5Wi/PnN7BbXN41h83i84bHjBYb33awW3w6f4HNYsHGR4wWm9e1sztweSz+fo/ZY3bDRRaP
        Tas62Tz2z13D7vFi80xGj8+b5ALYorhsUlJzMstSi/TtErgy7tzfyVpwjLviVN8DpgbGlZxd
        jBwcEgImEg0rUroYuTiEBFYwSsw+dY0ZwvnCKLH8xCUo5zOjxOK1E5i6GDnBOk69WMgOkVjO
        KLFzxyZWCOcjo8Sq5wvYQap4Bewk7j6eyQayg0VAVeLILiaIsKDEyZlPWEBsUYEUid3d28Bs
        YYFAiUn7X4HViAg4S1y/u40NZCazQDuTxPZH8xhBEswC4hK3nswHK2ITMJToetvFBmJzClhI
        /D/2nA2iRl5i+9s5YGdLCPzgkHj09hwjxNkuEvMu34J6QVji1fEt7BC2jMTpyT0sEA3tjBIL
        ft9ngnAmMEo0PL8F1W0tcefcL7B3mAU0Jdbv0oeEnqPE3s0mECafxI23ghA38ElM2jadGSLM
        K9HRJgQxQ01i1vF1cFsPXrjEPIFRaRZSsMxC8uUsJN/MQli7gJFlFaN4amlxbnpqsXFearle
        cWJucWleul5yfu4mRmCaOv3v+NcdjCtefdQ7xMjEwXiIUYKDWUmEt/5sdLIQb0piZVVqUX58
        UWlOavEhRmkOFiVxXrYZWslCAumJJanZqakFqUUwWSYOTqkGpihLn66Wyu/3zJxTHtw5dpjH
        Yf3rna4Vae/3HNpWoGz+7ImYbxHPtzv7Qt6ENt2r+H3/0fNdiatr/UzvVcnmZAvqcx2UcWx6
        v4f1to+O/wGnH4ZPVDgy0m/4nfS1rGjQenaRlUuiw+jgrPO7r6+wqqxO5GPrupFt4Jvwbcuy
        1n0rb/yYOiHJkf9oxue0uidNT4uLX2hkMOuu/L391U3tum0B17m//vZJK/B7En3LqDRkj+ot
        9e8MDf+DCk8KBYae7ZSwu27Y+rjVPXqB2dOq2df2+NqYPGSq6DlzOnD3SRt94QcmttMuygtr
        1UlfbznUv3N147LXs+7vOJR4QG1fSfa/qKgwjWLHBM71thHhSizFGYmGWsxFxYkAEaGc2sID
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t/xe7pSd6OTDfb/YrNoXryezWJFpUXT
        jR5Wi/PnN7BbXN41h83i84bHjBYb33awW3w6f4HNYsHGR4wWm9e1sztweSz+fo/ZY3bDRRaP
        Tas62Tz2z13D7vFi80xGj8+b5ALYovRsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOt
        jEyV9O1sUlJzMstSi/TtEvQy7tzfyVpwjLviVN8DpgbGlZxdjJwcEgImEqdeLGTvYuTiEBJY
        yiixed1adoiEjMTJaQ2sELawxJ9rXWwgtpDAe0aJ3pfVIDavgJ3E3cczgeIcHCwCqhJHdjFB
        hAUlTs58wgISFhVIkfh2rg4kLCwQKDFp/yuwEhEBZ4nrd7exgaxlFmhnknj8bAULxA2PGSXm
        f5wNdgOzgLjErSfzwTrYBAwlut5C3MApYCHx/9hzNogaM4murV2MELa8xPa3c5gnMArNQnLH
        LCSjZiFpmYWkZQEjyypGkdTS4tz03GJDveLE3OLSvHS95PzcTYzAuNx27OfmHYzzXn3UO8TI
        xMF4iFGCg1lJhLf+bHSyEG9KYmVValF+fFFpTmrxIUZTYFhMZJYSTc4HJoa8knhDMwNTQxMz
        SwNTSzNjJXFez4KORCGB9MSS1OzU1ILUIpg+Jg5OqQamna6CPbw3Z7Ybs7M95bt/4trpfsml
        CSm9+2+Yxmqt5HiYq8Dr3flmxdnSyedePlN80GrWa/elrE1a8zTbQ6H3c7ONmZ8rMnsKvop/
        ya27epuLcrNyyYqHk1OleRrL3py8wBKx/KOSHov5t1Ovzh+u2XuK7U7srfmHDha4Bxu5Lrkb
        0n6QX+/KHD6db68XME60eKrXL35kweNdHXNizXL/7eruFmEW0T6z5I+vgWJW4/5VTYVS7zzX
        7jD73XZOvzj6GeOCqNXzFt737Vmem+My/2tq60rtwvCyQwfjfO9vXfhTdb+Gc1lO/3ZGH/GN
        Txn2XF1idNXny02VrSsDOubWBryUy6q53K9Y+NK02zVciaU4I9FQi7moOBEA+R/syFQDAAA=
X-CMS-MailID: 20221028134602eucas1p263f5b1972295650ae2708a44f9e9cae7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20221018152853eucas1p2bd3531388625cf11f8b514bb9cc35e76
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20221018152853eucas1p2bd3531388625cf11f8b514bb9cc35e76
References: <20220906120702.19219-1-johan@kernel.org>
        <20220906120702.19219-4-johan@kernel.org>
        <CGME20221018152853eucas1p2bd3531388625cf11f8b514bb9cc35e76@eucas1p2.samsung.com>
        <808bdba846bb60456adf10a3016911ee@agner.ch>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear All,

On 18.10.2022 17:27, Stefan Agner wrote:
> Hi Johan,
>
> On 2022-09-06 14:07, Johan Hovold wrote:
>> From: Johan Hovold <johan+linaro@kernel.org>
>>
>> commit 6000b8d900cd5f52fbcd0776d0cc396e88c8c2ea upstream.
>>
>> The dwc3 driver manages its PHYs itself so the USB core PHY management
>> needs to be disabled.
>>
>> Use the struct xhci_plat_priv hack added by commits 46034a999c07 ("usb:
>> host: xhci-plat: add platform data support") and f768e718911e ("usb:
>> host: xhci-plat: add priv quirk for skip PHY initialization") to
>> propagate the setting for now.
> [adding also Samsung/ODROID device tree authors Krzysztof and Marek]
>
> For some reason, this commit seems to break detection of the USB to
> S-ATA controller on ODROID-HC1 devices (Exynos 5422).
>
> We have a known to work OS release of v5.15.60, and known to not be
> working of v5.15.67. By reverting suspicious commits, I was able to
> pinpoint the problem to this particular commit.
>
> >From what I understand, on that particular hardware the S-ATA controller
> power is controlled via the V-BUS signal VBUSCTRL_U2 (Schematic [1]).
> Presumably this signal is no longer controlled with this change.
>
> This came up in our HAOS issue #2153 [2].

I confirm this issue and I've managed to reproduce it locally. The 
mainline is also affected. I will try to prepare a proper patch soon.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

