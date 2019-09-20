Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57F9CB99DB
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 00:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406834AbfITWzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 18:55:44 -0400
Received: from mout.gmx.net ([212.227.15.19]:52067 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406833AbfITWzo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Sep 2019 18:55:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1569020123;
        bh=fg+Fhu6V5VJyuACGUBLseXFjv2kSmmWXdJJcK6kyNNY=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=gKJUcSTOAUmRIRlqF0chMUVnkrHWKQcJ1D9WFftnxHSmTtH5vy+iIofPK6i8Oxw4s
         QFBEwkr9HpJlANo0lk/+Bn7LmNdiIz+meEpt5xTKVHBcTqh8fRjpYJkZ8kd2YhDpLu
         BmCgQyASHJHhZCeq4KDW/n15Q4IRATP5YyJ1Y85I=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.162] ([37.4.249.90]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MIMbO-1iNZIV2E0C-00EKWI; Sat, 21
 Sep 2019 00:55:23 +0200
Subject: Re: [PATCH] Revert "ARM: bcm283x: Switch V3D over to using the PM
 driver instead of firmware."
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Eric Anholt <eric@anholt.net>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        boris.brezillon@bootlin.com
Cc:     bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org
References: <1567957493-4567-1-git-send-email-wahrenst@gmx.net>
 <09f15af6-a849-a5eb-ac39-f4cdb07ebfb9@gmail.com>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <3b5db3d9-147b-6cbe-a3be-16569b5fa5b0@gmx.net>
Date:   Sat, 21 Sep 2019 00:55:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <09f15af6-a849-a5eb-ac39-f4cdb07ebfb9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:fvhcLD5NIXoijsnJbghoo73iDEDtCLM7Oh+qleIkLeb3h9niSfO
 0wsgJf0BMb1IqJfXSpk9EOsD6qIGQC/bQYWnAnWEbr8pRuCxWcj2XZg7hpovodcHsco7SGL
 PpzmESTGMs87zGwuwB2NnQ461gmxw7mfFRDDftU7fBaMogkzwtpjD51Gn14I5oQJcJaJjnm
 D5LKHnEU5mWFJ51PvyLgA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:oGkxg6wEmkY=:UTTqj+UGIQ/jKVxdAI6upI
 f52frNj8xcvkOpGY2YZquOhvfG9p7CmL5pV+VmsTHYQQclc0llluyw0JRyKDmyY9UgbelUXn7
 yaN6FBb7ORlvVbe9LmjDhLEDYNuOU61hRaOW3b/7LUm1qmLq5Og+0Ml9wqvzLRMhu3bRYmbRS
 MQLRj6W+SEPQxBp/CxAIj98ShQFEWiOs3XpVCUz7EVt2zcnKz6zbMxKZRLE5KtaG/dmjmAeqb
 d1lene6LwfVLetV/29jKpEQOlbjiktJCZwi/EWzW9Y2KISKs5Tx/Oi+9Wg6jM/4NEv/vOzvKw
 ehaAVQnQLrYVxD1FMdr5PtbGhsc8r7Nm0+IXLPw1n+cPIFc4B8nvNpt/baUl9ZmIiP4NuNOJ/
 DXXp01j4UGc54lyVeCAgKPvDJYTewq58eZuthTm+eVAFGSWRNbY4IbYIL+Cm5u0Zu/oHQLrQN
 lv8ymHuJUl4+0iL6wKZme83zMfQpWvD7D0MoNQ2cBuHTv+xrN2020fGc+eIHgGkC5rcZrHkR6
 JmlgETDL5ILhdkVU4w5Cw0FxLAr5nzS3KW+rVH3iAUEVMwpNERo2MheQ5bB4rCCm183Hc2QTF
 1+RgGWXW5w/RKtS6UMIn2xiV6+bgwBFjHt2jc9tnEuF1iiFLAZwEImAlDbpisoBArXuJuWrGg
 8H8Cfz43UFJIqTarQytvu4Xzc2uOfAtzU3kVblKbzTxUibQIaKI8spaBBlK/sQJWjxyT+tDUV
 lKPLUbmOJi5A85r7fNUcU8KWo5DHVXZVRxdRAP6/r5Gqzf7IBvisIB7R5kS4GYLNOx/sm0TLh
 pIqC/lzuHhovlVX3EM05AElKuPS8kiO818jGhaPIrCf8Tm+0I0J/qz9JoR86YMl/RpCT48nVl
 NeLhQs1jdvNY6xEsbd38wq23uj/6dFfCYTLWLg9wKvj6WeUkNOF2sOHKbiSNTgxoa+SDeoAm7
 fvzu1j4Bbl1o10sVcPm6zTpUy/c9K3GcpiUZsEjjY1mkMFTtlVv4mZik20oOCGCFxXhAb51+7
 wYJULKJpqOfyo3jHuZZ1CqLFWEvp6xtH4XzSbrJW9HCfadWHCf1Z7SfJBXDeXZsyt43W/Pq44
 pIAGu8HxtI5DDTopkUegy26Luis1AjbHl+uIZSMbwKc9iZIFGBnV1XvaHPjptJ0RRjhhdl5me
 rVKeoAHKcFrGRoyX7deeYi2DM8G+XJi2FxZRPc6lT5HD/bJeUc22K9Sx6Ld2RUmzh+tSOLbWR
 xXRhWX9z6KucEV/wma4U/AMtFTEOsQGKbiJlyU9KxeUOc4XdrNnN/RiIjcJI=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Florian,

Am 20.09.19 um 19:52 schrieb Florian Fainelli:
> On 9/8/19 8:44 AM, Stefan Wahren wrote:
>> Since release of the new BCM2835 PM driver there has been several reports
>> of V3D probing issues. This is caused by timeouts during powering-up the
>> GRAFX PM domain:
>>
>>   bcm2835-power: Timeout waiting for grafx power OK
>>
>> I was able to reproduce this reliable on my Raspberry Pi 3B+ after setting
>> force_turbo=1 in the firmware configuration. Since there are no issues
>> using the firmware PM driver with the same setup, there must be an issue
>> in the BCM2835 PM driver.
>>
>> Unfortunately there hasn't been much progress in identifying the root cause
>> since June (mostly in the lack of documentation), so i decided to switch
>> back until the issue in the BCM2835 PM driver is fixed.
>>
>> Link: https://github.com/raspberrypi/linux/issues/3046
>> Fixes: e1dc2b2e1bef (" ARM: bcm283x: Switch V3D over to using the PM driver instead of firmware.")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
> Do you want me to pick up this change directly, or would you want to
> issue a pull request for 5.4-rcX with other fixes?

there aren't any other fixes, please pick up this directly.

Thanks

Stefan

