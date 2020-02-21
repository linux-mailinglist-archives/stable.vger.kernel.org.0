Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BECE16771B
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731400AbgBUIDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:03:00 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:13094 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731105AbgBUIC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 03:02:56 -0500
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200221080253epoutp018e30ca610a374a797f2ae3efafd7f8cc~1XCifiYTA3199431994epoutp01U
        for <stable@vger.kernel.org>; Fri, 21 Feb 2020 08:02:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200221080253epoutp018e30ca610a374a797f2ae3efafd7f8cc~1XCifiYTA3199431994epoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1582272173;
        bh=RuNkI30XmWwZxqQObHz6T1KC8yq8kdryO4pn+XRWJAU=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=kJrnWTy1G+omAWEINOdYfSX6jYR+6qYAfAmqXKEFN0qDJGVIp+qbXn8z74iOkofl1
         6IKr24yZLlWJLBixopgkQx8cByAg23omVWStUY/bPPqqroWBPa4vDy4dfYMo16oAx/
         0g47tdBcUUvbEwep4IJ/HeciwMp2Tym8bbCAupUU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20200221080253epcas1p34bb4a2cc86d964b85d6e16f7fde37274~1XCh-hEqe0978909789epcas1p3m;
        Fri, 21 Feb 2020 08:02:53 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.153]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 48P3px32KszMqYkd; Fri, 21 Feb
        2020 08:02:49 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        23.25.48019.9AE8F4E5; Fri, 21 Feb 2020 17:02:49 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20200221080248epcas1p42f4aafa2cb9c153e7e06ce9f15d3ae78~1XCeHhtxN0524605246epcas1p4N;
        Fri, 21 Feb 2020 08:02:48 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200221080248epsmtrp121fe4eefef944446aed2c89cad574c80~1XCeGwbZH2312023120epsmtrp1r;
        Fri, 21 Feb 2020 08:02:48 +0000 (GMT)
X-AuditID: b6c32a38-23fff7000001bb93-cd-5e4f8ea9a958
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1E.B6.06569.8AE8F4E5; Fri, 21 Feb 2020 17:02:48 +0900 (KST)
Received: from [10.113.221.102] (unknown [10.113.221.102]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200221080248epsmtip15b2ad9e0a2aa3a05eac84844ef457f79~1XCd8ePZV2693826938epsmtip1h;
        Fri, 21 Feb 2020 08:02:48 +0000 (GMT)
Subject: Re: [PATCH] Revert
 "PM / devfreq: Modify the device name as devfreq(X) for sysfs"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>
Cc:     Orson Zhai <orson.unisoc@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        mingmin.ling@unisoc.com, orsonzhai@gmail.com,
        jingchao.ye@unisoc.com, Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
From:   Chanwoo Choi <cw00.choi@samsung.com>
Organization: Samsung Electronics
Message-ID: <1b9e510a-71bb-5aa8-ef85-a9a9c623f313@samsung.com>
Date:   Fri, 21 Feb 2020 17:11:02 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:59.0) Gecko/20100101
        Thunderbird/59.0
MIME-Version: 1.0
In-Reply-To: <20200221070646.GA4103708@kroah.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPJsWRmVeSWpSXmKPExsWy7bCmge7KPv84g3VrJCyaF69ns9hy4DOj
        xZnfuhZnm96wW1zeNYfN4nPvEUaL/ZPXsFrcblzBZvHlwEw2i+kfZjNaLNj4iNGB22PnrLvs
        Hneu7WHz2D93DbtH35ZVjB6H28+ye3zeJBfAFpVtk5GamJJapJCal5yfkpmXbqvkHRzvHG9q
        ZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0npJCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1
        ICWnwLJArzgxt7g0L10vOT/XytDAwMgUqDAhO2PxihMsBa+lK54v/8zSwHhPrIuRk0NCwETi
        66npjF2MXBxCAjsYJTYvWcIO4XxilDiycykbhPONUWLPh6VMMC2Hbj2AqtrLKHFw0jKo/veM
        Ekf3TGYBqRIWiJFYMuEUM4gtIhAt8WLDM7AiZoGdTBL3nl5gA0mwCWhJ7H9xA8zmF1CUuPrj
        MSOIzStgJ/Fhykl2EJtFQFXiwdGLYKtFBcIkTm5rgaoRlDg58wnYMk4BQ4kN/f9ZQWxmAXGJ
        W0/mM0HY8hLb385hBlksITCdXaLh2S2oH1wk9uzZwAphC0u8Or6FHcKWknjZ3wZlV0usPHmE
        DaK5g1Fiy/4LUA3GEvuXTgYaxAG0QVNi/S59iLCixM7fcxkhFvNJvPvawwpSIiHAK9HRJgRR
        oixx+cFdqBMkJRa3d7JNYFSaheSdWUhemIXkhVkIyxYwsqxiFEstKM5NTy02LDBBju9NjODE
        q2Wxg3HPOZ9DjAIcjEo8vBUNfnFCrIllxZW5hxglOJiVRHjVeIBCvCmJlVWpRfnxRaU5qcWH
        GE2BoT2RWUo0OR+YFfJK4g1NjYyNjS1MDM1MDQ2VxHkfRmrGCQmkJ5akZqemFqQWwfQxcXBK
        NTAu+827Quybjp9Jt9E7u/l2J3YsNLH5mHyfa5qij9nHdDeuyeEcUZJz5kjPWP1LU10luP2J
        rer0K087nIoev5hhOGnvcXsVxS0BunMC6tzPLe6P3C3YaZdnIvhczW6C4z71FxP3mgTNO2W2
        JWI7l76U9pT8p9ar2sx+Hp3JfuJaZqatbt9Jt2olluKMREMt5qLiRACr0k060gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWy7bCSnO6KPv84g5NPTS2aF69ns9hy4DOj
        xZnfuhZnm96wW1zeNYfN4nPvEUaL/ZPXsFrcblzBZvHlwEw2i+kfZjNaLNj4iNGB22PnrLvs
        Hneu7WHz2D93DbtH35ZVjB6H28+ye3zeJBfAFsVlk5Kak1mWWqRvl8CVsXjFCZaC19IVz5d/
        ZmlgvCfWxcjJISFgInHo1gP2LkYuDiGB3YwSc3f9ZoRISEpMu3iUuYuRA8gWljh8uBii5i2j
        xJI7B9hBaoQFYiRez1/MBGKLCERLrN9wmwWkiFlgN5PE+bNfWEESQgLrmCT2z3cEsdkEtCT2
        v7jBBmLzCyhKXP3xGGwZr4CdxIcpJ8GGsgioSjw4ehFsqKhAmMTOJY+ZIGoEJU7OfMICYnMK
        GEps6P8PNp9ZQF3iz7xLzBC2uMStJ/OZIGx5ie1v5zBPYBSehaR9FpKWWUhaZiFpWcDIsopR
        MrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzj+tLR2MJ44EX+IUYCDUYmHt6LBL06INbGs
        uDL3EKMEB7OSCK8aD1CINyWxsiq1KD++qDQntfgQozQHi5I4r3z+sUghgfTEktTs1NSC1CKY
        LBMHp1QDo2fKjK5f3yuqfW9m/Mn7/mybtlrWb5NLG/9KZv149Jb39IofU8SPleWoXPt6rc3T
        UOK73YnsmaxnmEQld2z3ffL8D5MUa1LZ7wdLVvrlZhVeX5lRVNtbXPNr49N85aTjnxTma7O5
        33Wqe2vL2iiapl7rtPfA0+bSvxs0T5nNV3dNEZbb8r+/Q4mlOCPRUIu5qDgRAOKdyWq7AgAA
X-CMS-MailID: 20200221080248epcas1p42f4aafa2cb9c153e7e06ce9f15d3ae78
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200221070652epcas1p11e82863794f130373055c0b7bdedff23
References: <1582220224-1904-1-git-send-email-orson.unisoc@gmail.com>
        <20200220191513.GA3450796@kroah.com>
        <CALAqxLViRgGE8FsukCJL+doqk_GqabLDCtXBWem+VOGf9xXZdg@mail.gmail.com>
        <CGME20200221070652epcas1p11e82863794f130373055c0b7bdedff23@epcas1p1.samsung.com>
        <20200221070646.GA4103708@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/21/20 4:06 PM, Greg Kroah-Hartman wrote:
> On Thu, Feb 20, 2020 at 11:47:41AM -0800, John Stultz wrote:
>> On Thu, Feb 20, 2020 at 11:15 AM Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>>
>>> On Fri, Feb 21, 2020 at 01:37:04AM +0800, Orson Zhai wrote:
>>>> This reverts commit 4585fbcb5331fc910b7e553ad3efd0dd7b320d14.
>>>>
>>>> The name changing as devfreq(X) breaks some user space applications,
>>>> such as Android HAL from Unisoc and Hikey [1].
>>>> The device name will be changed unexpectly after every boot depending
>>>> on module init sequence. It will make trouble to setup some system
>>>> configuration like selinux for Android.
>>>>
>>>> So we'd like to revert it back to old naming rule before any better
>>>> way being found.
>>>>
>>>> [1] https://protect2.fireeye.com/url?k=00fa721e-5d2a7af6-00fbf951-000babff32e3-95e4b92259b05656&u=https://lkml.org/lkml/2018/5/8/1042
>>>>
>>>> Cc: John Stultz <john.stultz@linaro.org>
>>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Orson Zhai <orson.unisoc@gmail.com>
>>>>
>>>> ---
>>>>  drivers/devfreq/devfreq.c | 4 +---
>>>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
>>>> index cceee8b..7dcf209 100644
>>>> --- a/drivers/devfreq/devfreq.c
>>>> +++ b/drivers/devfreq/devfreq.c
>>>> @@ -738,7 +738,6 @@ struct devfreq *devfreq_add_device(struct device *dev,
>>>>  {
>>>>       struct devfreq *devfreq;
>>>>       struct devfreq_governor *governor;
>>>> -     static atomic_t devfreq_no = ATOMIC_INIT(-1);
>>>>       int err = 0;
>>>>
>>>>       if (!dev || !profile || !governor_name) {
>>>> @@ -800,8 +799,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
>>>>       devfreq->suspend_freq = dev_pm_opp_get_suspend_opp_freq(dev);
>>>>       atomic_set(&devfreq->suspend_count, 0);
>>>>
>>>> -     dev_set_name(&devfreq->dev, "devfreq%d",
>>>> -                             atomic_inc_return(&devfreq_no));
>>>> +     dev_set_name(&devfreq->dev, "%s", dev_name(dev));
>>>>       err = device_register(&devfreq->dev);
>>>>       if (err) {
>>>>               mutex_unlock(&devfreq->lock);
>>>> --
>>>> 2.7.4
>>>>
>>>
>>> Thanks for this, I agree, this needs to get back to the way things were
>>> as it seems to break too many existing systems as-is.
>>>
>>> I'll queue this up in my tree now, thanks.
>>
>> Oof this old thing. I unfortunately didn't get back to look at the
>> devfreq name node issue or the compatibility links, since the impact
>> of the regression (breaking the powerHAL's interactions with the gpu)
>> wasn't as big as other problems we had. While the regression was
>> frustrating, my only hesitancy at this point is that its been this way
>> since 4.10, so reverting the problematic patch is likely to break any
>> new users since then.
> 
> Looks like most users just revert that commit in their trees:
> 	https://protect2.fireeye.com/url?k=1012ad0f-4dc2a5e7-10132640-000babff32e3-35779c5ed675ef0f&u=https://source.codeaurora.org/quic/la/kernel/msm-4.14/commit/drivers/devfreq?h=msm-4.14&id=ccf273f6d89ad0fa8032e9225305ad6f62c7770c
> 
> So we should be ok here.

I'm sorry about changing the devfreq node name.

OK. Do you pick this patch to your tree?
or If not, I'll apply it to devfreq-next branch for v5.7-rc1.

And do you apply it to kernel of linux-stable tree since 4.11?

-- 
Best Regards,
Chanwoo Choi
Samsung Electronics
