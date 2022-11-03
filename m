Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C87618248
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 16:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbiKCPST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 11:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbiKCPSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 11:18:18 -0400
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D8F193F5
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 08:18:16 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20221103151814euoutp0203c2756660d9507b6cd3329ac6cd0911~kHCH0a2Vy1456714567euoutp02w
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 15:18:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20221103151814euoutp0203c2756660d9507b6cd3329ac6cd0911~kHCH0a2Vy1456714567euoutp02w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667488694;
        bh=rbUMn6HqqS28Y3UuFN/O9DUfkW3PyC6du2nvuOus6QI=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=kfC2PtOwv7WPM5S8+tPZwGDD1OvE+/JozBYn+1hhgvwTuWH4UVDiXmkvzol6emS08
         D5+ZXYcNrkuzoh5rSj9YH/VgeugNTIrvqK/cn+sr5n3XsbuZAOByw5mFuBmlEy9uAQ
         7aKv20s6ckxxn5tikEVqOyMpVewQzXYlYtR0Mw1I=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20221103151813eucas1p16cbb9fafd44f569dc22b07dfdb65a8d9~kHCHY8P2o2075520755eucas1p1s;
        Thu,  3 Nov 2022 15:18:13 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id AF.8B.29727.5BBD3636; Thu,  3
        Nov 2022 15:18:13 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20221103151813eucas1p23d0fcda856fb48133a8a724f835b6665~kHCHANL7o1831318313eucas1p2P;
        Thu,  3 Nov 2022 15:18:13 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221103151813eusmtrp161e2d75364bb8d19ebb5ed0ecbd8b543~kHCG-apS70504605046eusmtrp1J;
        Thu,  3 Nov 2022 15:18:13 +0000 (GMT)
X-AuditID: cbfec7f2-205ff7000001741f-78-6363dbb58b96
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 90.E1.07473.5BBD3636; Thu,  3
        Nov 2022 15:18:13 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221103151812eusmtip23de54a39b28d6be6dda5601291548f1f~kHCGaHvPd2294822948eusmtip2W;
        Thu,  3 Nov 2022 15:18:12 +0000 (GMT)
Message-ID: <53e543e8-f895-d4f1-da94-d0baca528e79@samsung.com>
Date:   Thu, 3 Nov 2022 16:18:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0)
        Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH stable-5.15 3/3] usb: dwc3: disable USB core PHY
 management
Content-Language: en-US
To:     Johan Hovold <johan@kernel.org>, Stefan Agner <stefan@agner.ch>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        stable <stable@kernel.org>, regressions@lists.linux.dev,
        krzk@kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <Y2PVF/IJoKvSu3SM@hovoldconsulting.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsWy7djPc7pbbycnG2z9rWrRvHg9m8WKSoum
        Gz2sFufPb2C3uLxrDpvF5w2PGS02vu1gt/h0/gKbxYKNjxgtNq9rZ3fg8lj8/R6zx+yGiywe
        m1Z1snnsn7uG3ePF5pmMHp83yQWwRXHZpKTmZJalFunbJXBl9B74zFawQ7Ri6WzzBsa9/F2M
        nBwSAiYSu5atZO5i5OIQEljBKHFqzwRGCOcLo8SehglQmc+MEhMaFrDAtDTdeAtVtZxRYtGE
        oywQzkdGiQM73zOBVPEK2El8vrkTqJ2Dg0VAReL33UqIsKDEyZlPwAaJCqRI7O7eBmYLCwRK
        TNr/CqyVWUBc4taT+WC2iICzxNVlZ8GuYBZoZ5LY/mgeI0iCTcBQouttFxuIzQl00Yqd1xkh
        muUltr+dA9YgIfCDQ6LlyU1WiLNdJKZcaoR6QVji1fEt7BC2jMTpyT0sEA3tjBILft9ngnAm
        MEo0PL/FCFFlLXHn3C82kHeYBTQl1u/Shwg7Skz5OosdJCwhwCdx460gxBF8EpO2TWeGCPNK
        dLQJQVSrScw6vg5u7cELl5gnMCrNQgqXWUj+n4XknVkIexcwsqxiFE8tLc5NTy02zEst1ytO
        zC0uzUvXS87P3cQITFSn/x3/tINx7quPeocYmTgYDzFKcDArifB+2pacLMSbklhZlVqUH19U
        mpNafIhRmoNFSZyXbYZWspBAemJJanZqakFqEUyWiYNTqoFJ+q5m1Avn3ye3Xng99UzN1eB/
        17nvKEmfifVxFSy/4qzLvUgoL1FLWiSE40pHu9hOI5WmrxlSHOntDPx/Ju4L6lL49Ed19QXz
        LR4ZzSdT2rZe+fbo9jG/tCfffuhr/oz89K/kdarHxfldCfdio3yrFpYI9m4ofDuxapJkd+cf
        tfDf4p2y7h+m7lwaXLBF5Wrig10rUm7IrBDyjb9oNuNTv+HNGwfddV3FYr5N/aq2Tit5wheT
        xQ8b8tx8fDkcjFSEwyN0VaaFz3NV61MNmbvvMku2hMYO9YUnWA/JVZ1/3bGDff5Sg1en/s5O
        CL+xM89WZsGWpWtjDm1c8GBmS3/LWpnP2q6LPuhkijwS0ZZRYinOSDTUYi4qTgQAEHyKo8MD
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t/xe7pbbycnG6w+ymPRvHg9m8WKSoum
        Gz2sFufPb2C3uLxrDpvF5w2PGS02vu1gt/h0/gKbxYKNjxgtNq9rZ3fg8lj8/R6zx+yGiywe
        m1Z1snnsn7uG3ePF5pmMHp83yQWwRenZFOWXlqQqZOQXl9gqRRtaGOkZWlroGZlY6hkam8da
        GZkq6dvZpKTmZJalFunbJehl9B74zFawQ7Ri6WzzBsa9/F2MnBwSAiYSTTfeMoLYQgJLGSWa
        HotAxGUkTk5rYIWwhSX+XOti62LkAqp5zyhx43MfG0iCV8BO4vPNncxdjBwcLAIqEr/vVkKE
        BSVOznzCAhIWFUiR+HauDiQsLBAoMWn/KyYQm1lAXOLWk/lgtoiAs8TVZWeZQcYzC7QzSTx+
        toIFYtdzZol//5+AHcEmYCjR9bYLbC8n0NErdl5nhJhkJtG1tQvKlpfY/nYO8wRGoVlI7piF
        ZOEsJC2zkLQsYGRZxSiSWlqcm55bbKhXnJhbXJqXrpecn7uJERiV24793LyDcd6rj3qHGJk4
        GA8xSnAwK4nwftqWnCzEm5JYWZValB9fVJqTWnyI0RQYFhOZpUST84FpIa8k3tDMwNTQxMzS
        wNTSzFhJnNezoCNRSCA9sSQ1OzW1ILUIpo+Jg1Oqganhw/2JdrPurvjbyN0yteIkR2eeXJv6
        79ryPdVLrBu35AuInC46VbVkvsDOi1+PdBx2YN8+60jdo3khstPKd85+KjHPW1NiUePZ0HUG
        3zafZxbLfZpyObfUz2Xu5BdVOVPWzLlwJk9RMTvuAmPmum7PuRv0r2nx+Z5WaV0xWWAJp/b0
        1BmlMg+qVsTrbjrHfmfNzwszKt49buBRzjyw/OFvyZMffiX2hSQssNnf9ZpryqaM7/bFQTG5
        v/jPzlLtn/F7wuzpE5a1n3Rs7t42bdn/q0smVGspb6v497thqonzsnM6O2INz814tveSpH2H
        qNvZjUWzp/ceO//j0Wvv2nVhf/wrvz7pi2PfzfaiqabrvhJLcUaioRZzUXEiAEaY6SVTAwAA
X-CMS-MailID: 20221103151813eucas1p23d0fcda856fb48133a8a724f835b6665
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20221103145022eucas1p2218e78d51500c85b3cda59cc533a3631
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20221103145022eucas1p2218e78d51500c85b3cda59cc533a3631
References: <20220906120702.19219-1-johan@kernel.org>
        <20220906120702.19219-4-johan@kernel.org>
        <808bdba846bb60456adf10a3016911ee@agner.ch>
        <Y0+8dKESygFunXOu@hovoldconsulting.com>
        <86c0f1ee8ffc94f9a53690dda6a83fbb@agner.ch>
        <Y1JCIKT80P9IysKD@hovoldconsulting.com>
        <b2a1e70bda64cb741efe81c5b7e56707@agner.ch>
        <Y1p9Wy9w5umMBC4V@hovoldconsulting.com>
        <CGME20221103145022eucas1p2218e78d51500c85b3cda59cc533a3631@eucas1p2.samsung.com>
        <Y2PVF/IJoKvSu3SM@hovoldconsulting.com>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Johan,

On 03.11.2022 15:49, Johan Hovold wrote:
> On Thu, Oct 27, 2022 at 02:45:15PM +0200, Johan Hovold wrote:
>> On Wed, Oct 26, 2022 at 03:11:00PM +0200, Stefan Agner wrote:
>>> The user reports the S-ATA disk is *not* recognized with that patch
>>> applied.
>> I just noticed a mistake in the instrumentation patch I sent you. Could
>> you try moving the calibrations calls after dwc3_host_init() (e.g. as in
>> the second chunk in the diff below)?
>>
>> As mentioned in the commit message for a0a465569b45 ("usb: dwc3: remove
>> generic PHY calibrate() calls"), this may not work if the xhci-plat
>> driver is built as a module and there are some corner cases that it does
>> not cover.
>>
>> It seems we should revert the offending commit and then try to find some
>> time to untangle this mess, but please check if the below addresses the
>> issue first so we know what the problem is.
>>
>> I'll prepare a revert in the meantime.
> I've now posted the revert, but please do check if the below patch was
> enough to resolve the immediate issue.

The below patch was a half-fix. It worked only if both dwc3 and 
xhci_plat_hcd were compiled into the kernel. Afair Debian-based distros 
used xhci compiled as a module, so this didn't work for that case due to 
timing issues.


>
> Johan
>
>> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
>> index 31156d4dec9f..37d49a394912 100644
>> --- a/drivers/usb/dwc3/core.c
>> +++ b/drivers/usb/dwc3/core.c
>> @@ -197,6 +197,8 @@ static void __dwc3_set_mode(struct work_struct *work)
>>                                  otg_set_vbus(dwc->usb2_phy->otg, true);
>>                          phy_set_mode(dwc->usb2_generic_phy, PHY_MODE_USB_HOST);
>>                          phy_set_mode(dwc->usb3_generic_phy, PHY_MODE_USB_HOST);
>> +                       phy_calibrate(dwc->usb2_generic_phy);
>> +                       phy_calibrate(dwc->usb3_generic_phy);
>>                          if (dwc->dis_split_quirk) {
>>                                  reg = dwc3_readl(dwc->regs, DWC3_GUCTL3);
>>                                  reg |= DWC3_GUCTL3_SPLITDISABLE;
>> @@ -1391,6 +1393,9 @@ static int dwc3_core_init_mode(struct dwc3 *dwc)
>>                  ret = dwc3_host_init(dwc);
>>                  if (ret)
>>                          return dev_err_probe(dev, ret, "failed to initialize host\n");
>> +
>> +               phy_calibrate(dwc->usb2_generic_phy);
>> +               phy_calibrate(dwc->usb3_generic_phy);
>>                  break;
>>          case USB_DR_MODE_OTG:
>>                  INIT_WORK(&dwc->drd_work, __dwc3_set_mode);

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

