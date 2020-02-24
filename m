Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D10B169C27
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 03:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbgBXCI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 21:08:57 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:22374 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbgBXCI5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Feb 2020 21:08:57 -0500
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200224020854epoutp013ff9f914ecfb7def97d9dbb80ac428f2~2NJVL--OE1396313963epoutp01J
        for <stable@vger.kernel.org>; Mon, 24 Feb 2020 02:08:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200224020854epoutp013ff9f914ecfb7def97d9dbb80ac428f2~2NJVL--OE1396313963epoutp01J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1582510134;
        bh=f0d+C946tgK85y3SwPB2NZWOEBk9l0eSYCIjv//nEZk=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=AGS/HivGNfvzC4h0oaPxPaKJ6oBLdVxjzzUEtzTRV/x8oNghtdbTWa3gMT1hjaZJk
         /MpqHTB6E8fC9FzRrQmm2UBBwqv3I4uy8/Xf+onpDsPClgmEVyQuSSHWl/7Jn3RHWp
         QyIEzN9WlwEsjEMe2o1DJYQ8q5LXsSQMMGMfBXiQ=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20200224020854epcas1p4b5259989c068f8f5627f4ccabadea350~2NJUlGOvY2397123971epcas1p4_;
        Mon, 24 Feb 2020 02:08:54 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.153]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 48Qlq64ywVzMqYkY; Mon, 24 Feb
        2020 02:08:50 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        93.79.51241.F20335E5; Mon, 24 Feb 2020 11:08:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200224020846epcas1p13eda1567e7692233438842e3c4e6afdb~2NJNo90ZL1325913259epcas1p1v;
        Mon, 24 Feb 2020 02:08:46 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200224020846epsmtrp2d8915fa4d6e24bb36a67730fa414abd6~2NJNoLwNn1255812558epsmtrp2f;
        Mon, 24 Feb 2020 02:08:46 +0000 (GMT)
X-AuditID: b6c32a39-163ff7000001c829-71-5e53302f7492
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F7.5C.06569.E20335E5; Mon, 24 Feb 2020 11:08:46 +0900 (KST)
Received: from [10.113.221.102] (unknown [10.113.221.102]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200224020846epsmtip1630cff73bd3ede82e02772a3da8076f2~2NJNaUiSx2606426064epsmtip1E;
        Mon, 24 Feb 2020 02:08:46 +0000 (GMT)
Subject: Re: [PATCH] Revert
 "PM / devfreq: Modify the device name as devfreq(X) for sysfs"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chanwoo Choi <chanwoo@kernel.org>
Cc:     John Stultz <john.stultz@linaro.org>,
        Orson Zhai <orson.unisoc@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        mingmin.ling@unisoc.com, orsonzhai@gmail.com,
        jingchao.ye@unisoc.com, Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
From:   Chanwoo Choi <cw00.choi@samsung.com>
Organization: Samsung Electronics
Message-ID: <76f1ac9b-f130-d6f6-eb04-e81f9f06451e@samsung.com>
Date:   Mon, 24 Feb 2020 11:17:04 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:59.0) Gecko/20100101
        Thunderbird/59.0
MIME-Version: 1.0
In-Reply-To: <20200223175422.GD488486@kroah.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJsWRmVeSWpSXmKPExsWy7bCmga6+QXCcQUs3p8XEG1dYLJoXr2ez
        2HLgM6PFmd+6Fmeb3rBbXN41h83ic+8RRov9k9ewWtxuXMFm8eXATDaL6R9mM1os2PiI0YHH
        Y+esu+wem1Z1snncubaHzWP/3DXsHn1bVjF6HG4/y+7xeZNcAHtUtk1GamJKapFCal5yfkpm
        XrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0KFKCmWJOaVAoYDE4mIlfTubovzS
        klSFjPziElul1IKUnALLAr3ixNzi0rx0veT8XCtDAwMjU6DChOyMo1OamQumqVZM+L2OqYHx
        uFwXIyeHhICJxIVPPxi7GLk4hAR2MErc2XOaCcL5xCjRMaEbyvnGKHHpdg8bTEvb6S52iMRe
        Rolb19ZAOe8ZJc4/3M8KUiUsECOxZMIpZhBbRCBC4vzJH2CjmAUeMklM+vOfBSTBJqAlsf/F
        DbCx/AKKEld/PGYEsXkF7CSuLHwFZrMIqEp8/r8LrF5UIEzi5LYWqBpBiZMzn4DFOQUMJDa3
        XmQHsZkFxCVuPZnPBGHLS2x/O4cZZLGEwDJ2ietLN7FA/OAise3fEyhbWOLV8S3sELaUxOd3
        e6H+rJZYefIIG0RzB6PElv0XWCESxhL7l04G2sABtEFTYv0ufYiwosTO33MZIRbzSbz72sMK
        UiIhwCvR0SYEUaIscfnBXSYIW1JicXsn2wRGpVlI3pmF5IVZSF6YhbBsASPLKkax1ILi3PTU
        YsMCU+T43sQITsZaljsYj53zOcQowMGoxMO74khQnBBrYllxZe4hRgkOZiURXm9GoBBvSmJl
        VWpRfnxRaU5q8SFGU2BoT2SWEk3OB2aKvJJ4Q1MjY2NjCxNDM1NDQyVx3oeRmnFCAumJJanZ
        qakFqUUwfUwcnFINjFWGWwpO3uMq6HrlGdOga/f8e8LSFQdcPyk5BvBH7156rkbVvUXiXvqe
        Ze7GFd1Jzs1rd9Q7SP0rmBt34M8FFw9Bk9sFkl2sb6dZ3bSpW3nRoJQ5d3q6W+01D87tAcsE
        vlYLpFXGR2TIvNRmnLE37lxC1eG9/11couzcPpU+m+LtceY6iyebEktxRqKhFnNRcSIAaQde
        ItwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsWy7bCSnK6eQXCcwbtNmhYTb1xhsWhevJ7N
        YsuBz4wWZ37rWpxtesNucXnXHDaLz71HGC32T17DanG7cQWbxZcDM9kspn+YzWixYOMjRgce
        j52z7rJ7bFrVyeZx59oeNo/9c9ewe/RtWcXocbj9LLvH501yAexRXDYpqTmZZalF+nYJXBlH
        pzQzF0xTrZjwex1TA+NxuS5GTg4JAROJttNd7F2MXBxCArsZJW4sbGeHSEhKTLt4lLmLkQPI
        FpY4fLgYouYto8Sjd30sIDXCAjESr+cvZgKxRQQiJO7e+88CUsQs8JBJ4vWiV1BTvzFL9LT9
        YgOpYhPQktj/4gaYzS+gKHH1x2NGEJtXwE7iysJXYDaLgKrE5/+7wDaICoRJ7FzymAmiRlDi
        5MwnYHFOAQOJza0XwS5lFlCX+DPvEjOELS5x68l8JghbXmL72znMExiFZyFpn4WkZRaSlllI
        WhYwsqxilEwtKM5Nzy02LDDKSy3XK07MLS7NS9dLzs/dxAiOSi2tHYwnTsQfYhTgYFTi4Q04
        FBQnxJpYVlyZe4hRgoNZSYTXmxEoxJuSWFmVWpQfX1Sak1p8iFGag0VJnFc+/1ikkEB6Yklq
        dmpqQWoRTJaJg1OqgZGv00OA3eF7ZnXirhixv3MNAwwSj3g5h32VufHu2/HCw4tkDbvsn8oU
        C2sYLC/jPLlhZlD22cykWQEWFgVnTBbmMrt6Wr1iPZewtXgrs0Lamz8vsoRTfMNuPOGcffPH
        BuerN3lcH2oEbJlzcLZ1b/5Uttq89/MrZz3892D7U917nHJfk9cZ31NiKc5INNRiLipOBABc
        TxS9xgIAAA==
X-CMS-MailID: 20200224020846epcas1p13eda1567e7692233438842e3c4e6afdb
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
        <1b9e510a-71bb-5aa8-ef85-a9a9c623f313@samsung.com>
        <20200221111313.GA110504@kroah.com>
        <CAGTfZH0Ev2sCH073WdUjZJS5MNnJ9vzgsc_ApYkg+na2Fk4J+g@mail.gmail.com>
        <20200223175422.GD488486@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/24/20 2:54 AM, Greg Kroah-Hartman wrote:
> On Sat, Feb 22, 2020 at 08:55:22AM +0900, Chanwoo Choi wrote:
>> On Fri, Feb 21, 2020 at 8:13 PM Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>>
>>> On Fri, Feb 21, 2020 at 05:11:02PM +0900, Chanwoo Choi wrote:
>>>> On 2/21/20 4:06 PM, Greg Kroah-Hartman wrote:
>>>>> On Thu, Feb 20, 2020 at 11:47:41AM -0800, John Stultz wrote:
>>>>>> On Thu, Feb 20, 2020 at 11:15 AM Greg Kroah-Hartman
>>>>>> <gregkh@linuxfoundation.org> wrote:
>>>>>>>
>>>>>>> On Fri, Feb 21, 2020 at 01:37:04AM +0800, Orson Zhai wrote:
>>>>>>>> This reverts commit 4585fbcb5331fc910b7e553ad3efd0dd7b320d14.
>>>>>>>>
>>>>>>>> The name changing as devfreq(X) breaks some user space applications,
>>>>>>>> such as Android HAL from Unisoc and Hikey [1].
>>>>>>>> The device name will be changed unexpectly after every boot depending
>>>>>>>> on module init sequence. It will make trouble to setup some system
>>>>>>>> configuration like selinux for Android.
>>>>>>>>
>>>>>>>> So we'd like to revert it back to old naming rule before any better
>>>>>>>> way being found.
>>>>>>>>
>>>>>>>> [1] https://protect2.fireeye.com/url?k=00fa721e-5d2a7af6-00fbf951-000babff32e3-95e4b92259b05656&u=https://lkml.org/lkml/2018/5/8/1042
>>>>>>>>
>>>>>>>> Cc: John Stultz <john.stultz@linaro.org>
>>>>>>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>>>>> Cc: stable@vger.kernel.org
>>>>>>>> Signed-off-by: Orson Zhai <orson.unisoc@gmail.com>
>>>>>>>>
>>>>>>>> ---
>>>>>>>>  drivers/devfreq/devfreq.c | 4 +---
>>>>>>>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
>>>>>>>> index cceee8b..7dcf209 100644
>>>>>>>> --- a/drivers/devfreq/devfreq.c
>>>>>>>> +++ b/drivers/devfreq/devfreq.c
>>>>>>>> @@ -738,7 +738,6 @@ struct devfreq *devfreq_add_device(struct device *dev,
>>>>>>>>  {
>>>>>>>>       struct devfreq *devfreq;
>>>>>>>>       struct devfreq_governor *governor;
>>>>>>>> -     static atomic_t devfreq_no = ATOMIC_INIT(-1);
>>>>>>>>       int err = 0;
>>>>>>>>
>>>>>>>>       if (!dev || !profile || !governor_name) {
>>>>>>>> @@ -800,8 +799,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
>>>>>>>>       devfreq->suspend_freq = dev_pm_opp_get_suspend_opp_freq(dev);
>>>>>>>>       atomic_set(&devfreq->suspend_count, 0);
>>>>>>>>
>>>>>>>> -     dev_set_name(&devfreq->dev, "devfreq%d",
>>>>>>>> -                             atomic_inc_return(&devfreq_no));
>>>>>>>> +     dev_set_name(&devfreq->dev, "%s", dev_name(dev));
>>>>>>>>       err = device_register(&devfreq->dev);
>>>>>>>>       if (err) {
>>>>>>>>               mutex_unlock(&devfreq->lock);
>>>>>>>> --
>>>>>>>> 2.7.4
>>>>>>>>
>>>>>>>
>>>>>>> Thanks for this, I agree, this needs to get back to the way things were
>>>>>>> as it seems to break too many existing systems as-is.
>>>>>>>
>>>>>>> I'll queue this up in my tree now, thanks.
>>>>>>
>>>>>> Oof this old thing. I unfortunately didn't get back to look at the
>>>>>> devfreq name node issue or the compatibility links, since the impact
>>>>>> of the regression (breaking the powerHAL's interactions with the gpu)
>>>>>> wasn't as big as other problems we had. While the regression was
>>>>>> frustrating, my only hesitancy at this point is that its been this way
>>>>>> since 4.10, so reverting the problematic patch is likely to break any
>>>>>> new users since then.
>>>>>
>>>>> Looks like most users just revert that commit in their trees:
>>>>>     https://protect2.fireeye.com/url?k=1012ad0f-4dc2a5e7-10132640-000babff32e3-35779c5ed675ef0f&u=https://source.codeaurora.org/quic/la/kernel/msm-4.14/commit/drivers/devfreq?h=msm-4.14&id=ccf273f6d89ad0fa8032e9225305ad6f62c7770c
>>>>>
>>>>> So we should be ok here.
>>>>
>>>> I'm sorry about changing the devfreq node name.
>>>>
>>>> OK. Do you pick this patch to your tree?
>>>
>>> Yes, I can do that.
>>
>> If you agree, how about merging it to devfreq.git
>> for preventing the potential merge conflict with other devfreq patches?
> 
> Sure, but it should go for 5.6-final, right?

OK.I'll send pull-request of this patch for v5.6-rc4.

> 
>>>> or If not, I'll apply it to devfreq-next branch for v5.7-rc1.
>>>>
>>>> And do you apply it to kernel of linux-stable tree since 4.11?
>>>
>>> Yeah, I'll mark it for stable.
>>
>> Thanks.
>>
>>>
>>> Can I get an ack from you for this?
>>
>> OK. but, if it will be merged to devfreq.git,
>> can I get an ack from you?
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks. I applied it to devfreq-fixes branch for v5.6-rc4.

-- 
Best Regards,
Chanwoo Choi
Samsung Electronics
