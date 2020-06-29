Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2246320D7E8
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgF2Td5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:33:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12246 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733222AbgF2Tdz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 15:33:55 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200629111830epoutp04116a79afe5a63bc89e8da734e4f5f4a7~c-7Kju6iH1614016140epoutp04N
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 11:18:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200629111830epoutp04116a79afe5a63bc89e8da734e4f5f4a7~c-7Kju6iH1614016140epoutp04N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593429510;
        bh=vAb4Z4GpL0lkxDlDzwNAXVXDBv/QoqR6PMn/lVDdCPM=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=nMQNZsGbdWBc+/wtyPxmFoUY1YlO0sDSTwYExxh5pRi25Rf3bpodtpYooskzkuYtW
         XeGFqmUjW1N1XXeif6UhPDnM4kPV9QTi28R8axgBdYVfci7FmjpC9WFr5BWcZuUwke
         NMLwNart/4hF2988NRGMBH2sxzPYYm5yx/k6nvRU=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200629111830epcas1p15bc36ccb76f3c368183f1ee4f0b1d7fa~c-7KK9aiR0380903809epcas1p1U;
        Mon, 29 Jun 2020 11:18:30 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.155]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 49wQ3602b6zMqYkW; Mon, 29 Jun
        2020 11:18:26 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        EC.77.29173.10EC9FE5; Mon, 29 Jun 2020 20:18:25 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200629111825epcas1p16a9284e083090d9d7e104cf40b562226~c-7FN1jj22938729387epcas1p12;
        Mon, 29 Jun 2020 11:18:25 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200629111825epsmtrp2dbf8e59832c86034c20f1906fade73b4~c-7FKc4BV3011930119epsmtrp2-;
        Mon, 29 Jun 2020 11:18:25 +0000 (GMT)
X-AuditID: b6c32a37-9b7ff700000071f5-cf-5ef9ce0194ab
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D3.64.08382.00EC9FE5; Mon, 29 Jun 2020 20:18:24 +0900 (KST)
Received: from [10.113.221.102] (unknown [10.113.221.102]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200629111824epsmtip1d9f39c9a50b08335436aa1db858cdacc~c-7E4Xod-0337403374epsmtip1l;
        Mon, 29 Jun 2020 11:18:24 +0000 (GMT)
Subject: Re: [PATCH v2] PM / devfreq: rk3399_dmc: Fix kernel oops when
 rockchip,pmu is absent
To:     Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     =?UTF-8?Q?Heiko_St=c3=bcbner?= <heiko@sntech.de>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        kernel-team@android.com,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
From:   Chanwoo Choi <cw00.choi@samsung.com>
Organization: Samsung Electronics
Message-ID: <154fe5b6-6a05-c2b7-3014-2f7b9c2049f9@samsung.com>
Date:   Mon, 29 Jun 2020 20:29:36 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:59.0) Gecko/20100101
        Thunderbird/59.0
MIME-Version: 1.0
In-Reply-To: <3de68490-d788-e416-dd5f-d4d6e7eca61a@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOJsWRmVeSWpSXmKPExsWy7bCmri7juZ9xBhtnmlmsuX2I0eL/o9es
        Fju2i1icbXrDbnF51xw2i8+9Rxgtds45yWpxu3EFm8WCjY8YHTg9tu3exuqx4+4SRo9NqzrZ
        PPq2rGL02H5tHrPH501yAWxR2TYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5
        ibmptkouPgG6bpk5QEcpKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgosC/SKE3OL
        S/PS9ZLzc60MDQyMTIEKE7Izpn3vYStYrFnROf86UwPjb4UuRk4OCQETic//1zJ1MXJxCAns
        YJS4vvofI4TziVHi0ruJ7BDON0aJ/aca2WFall1pYYNI7GWUmN7WwgLhvGeU+N/xkxGkSlgg
        XuJGyx1WEFtEIEqi/+M3sCXMApOYJCYt+wCWYBPQktj/4gYbiM0voChx9cdjsGZeATuJRdNv
        sIDYLAKqEk9vngSzRQXCJE5ua4GqEZQ4OfMJWJxTwFGie9N9JhCbWUBc4taT+VC2vMT2t3OY
        QRZLCKzlkHhw6yGQwwHkuEj09flAvCMs8er4FqjXpCQ+v9vLBmFXS6w8eYQNoreDUWLL/gus
        EAljif1LJzOBzGEW0JRYv0sfIqwosfP3XEaIvXwS7772sEKs4pXoaBOCKFGWuPzgLhOELSmx
        uL2TbQKj0iwk38xC8sEsJB/MQli2gJFlFaNYakFxbnpqsWGBMXJ0b2IEp1gt8x2M095+0DvE
        yMTBeIhRgoNZSYT3s/W3OCHelMTKqtSi/Pii0pzU4kOMpsDwncgsJZqcD0zyeSXxhqZGxsbG
        FiaGZqaGhkrivL5WF+KEBNITS1KzU1MLUotg+pg4OKUamIq1jA68+TfTcXkT2wvb5dobPD7f
        nn3+S8eHrKrytV1LGd7tfDP3aXrv4pglM9M8xX73aJxgYnF49kB9yhVljr18rN5rzxvOKRVg
        FJ6qXXn20cHXW0+zq962cVG7pnawT/yBhBGT0aOrgYaBTr+XW/PZ667UOPre0MR7Z09WEHOt
        YVMrF2eH+NOCb8f+qubmHlY55l/sdLJW8au/CePe48sk+upc32uGSxdq7ftYMFUn0nKG+o04
        ZiHLD7wLr5U8PHfNzorjdPu/zMOyz2IianexHlukFH16j3lvY9qhm0V96ZtfyIc9XuH78mC9
        UD4jSwO7hsMdPR33u4c+7ua/d1j1pfTGSX/mhN+Yx1rXr8RSnJFoqMVcVJwIAOdSvLw6BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWy7bCSnC7DuZ9xBnM7rCzW3D7EaPH/0WtW
        ix3bRSzONr1ht7i8aw6bxefeI4wWO+ecZLW43biCzWLBxkeMDpwe23ZvY/XYcXcJo8emVZ1s
        Hn1bVjF6bL82j9nj8ya5ALYoLpuU1JzMstQifbsEroxp33vYChZrVnTOv87UwPhboYuRk0NC
        wERi2ZUWti5GLg4hgd2MEncuXWGGSEhKTLt4FMjmALKFJQ4fLoaoecsoceLPKrAaYYF4iRst
        d1hBbBGBKIlDPXfYQYqYBaYwSdz/sxtq6mkmifN377CAVLEJaEnsf3GDDcTmF1CUuPrjMSOI
        zStgJ7Fo+g2wGhYBVYmnN0+C2aICYRI7lzxmgqgRlDg58wlYnFPAUaJ7032wOLOAusSfeZeY
        IWxxiVtP5kPF5SW2v53DPIFReBaS9llIWmYhaZmFpGUBI8sqRsnUguLc9NxiwwLDvNRyveLE
        3OLSvHS95PzcTYzgaNPS3MG4fdUHvUOMTByMhxglOJiVRHg/W3+LE+JNSaysSi3Kjy8qzUkt
        PsQozcGiJM57o3BhnJBAemJJanZqakFqEUyWiYNTqoHpCKfGs+8H3q8RV/mgk5oo4iXWsV2R
        MUn/zhOj16IvPogFrYrZOWuZ+J6L/RFCz+rN2vU+mvVmbe68s2P90aX3Ll1p8nHebDZn81T3
        hwoX3k2ZNLO1d/KHlsKs8vA4PsZTEqHcDj5ejJesX213V9o9bcbqpl3LnQ0rdLUY1qnfD/7/
        cdlh9t8hvyZuur3sm5O+9s8Lf369uyQfH+mQrnjscGCVs+lKV0VjuameP2Zp3jabJ/l2f5lc
        SorIy/e+ZW+5bHcyf9C6cNd84ZVEfesJE4/4CQuGprQ9s2nNW1hqpnK+ReVpLJ8Hy5FLnOoz
        vt914LMWUf18/gxTfu8D7X39roa/nXYuNF4uJnymyGuaEktxRqKhFnNRcSIAdNbXgyUDAAA=
X-CMS-MailID: 20200629111825epcas1p16a9284e083090d9d7e104cf40b562226
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200622152844epcas1p2309f34247eb9653acdfd3818b7e6a569
References: <CGME20200622152844epcas1p2309f34247eb9653acdfd3818b7e6a569@epcas1p2.samsung.com>
        <20200622152824.1054946-1-maz@kernel.org>
        <784808d7-8943-44ab-f15a-34821e6d4d5f@samsung.com>
        <87tuyue142.wl-maz@kernel.org>
        <c1a5b730-0554-bb90-9d8d-b50390482e96@samsung.com>
        <3de68490-d788-e416-dd5f-d4d6e7eca61a@collabora.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Enric and Mark,

On 6/29/20 8:05 PM, Enric Balletbo i Serra wrote:
> Hi Chanwoo and Marc,
> 
> On 29/6/20 13:09, Chanwoo Choi wrote:
>> Hi Enric,
>>
>> Could you check this issue? Your patch[1] causes this issue.
>> As Marc mentioned, although rk3399-dmc.c handled 'rockchip,pmu'
>> as the mandatory property, your patch[1] didn't add the 'rockchip,pmu'
>> property to the documentation. 
>>
> 
> I think the problem is that the DT binding patch, for some reason, was missed
> and didn't land. The patch seems to have all the required reviews and acks.
> 
>   https://patchwork.kernel.org/patch/10901593/
> 
> Sorry because I didn't notice this issue when 9173c5ceb035 landed. And thanks
> for fixing the issue.

If the 'rockchip,pmu' propery is mandatory, instead of Mark's patch,
we better to require the merge of patch[1] to DT maintainer.

[1] https://patchwork.kernel.org/patch/10901593/

> 
> Best regards,
>  Enric
> 
>> [1] 9173c5ceb035 ("PM / devfreq: rk3399_dmc: Pass ODT
>> and auto power down parameters to TF-A.")
>>
>>
>> On 6/29/20 5:18 PM, Marc Zyngier wrote:
>>> Hi Chanwoo,
>>>
>>> On Mon, 29 Jun 2020 03:43:37 +0100,
>>> Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>>>
>>>> Hi Marc,
>>>>
>>>> On 6/23/20 12:28 AM, Marc Zyngier wrote:
>>>
>>> [...]
>>>
>>>> It looks good to me. But, I think that it is not necessary
>>>> fully kernel panic log about NULL pointer. It is enoughspsp
>>>> just mentioning the NULL pointer issue without full kernel panic log.
>>>
>>> I personally find the backtrace useful as it allows people with the
>>> same issue to trawl the kernel log and find whether it has already be
>>> fixed upstream. But it's only me, and I'm not attached to it.
>>>
>>>> So, how about editing the patch description as following or others simply?
>>>> and we need to add 'stable@vger.kernel.org' to Cc list for applying it
>>>> to stable branch.
>>>
>>> Looks good to me.
>>>
>>>>
>>>>
>>>>   PM / devfreq: rk3399_dmc: Fix kernel oops when rockchip,pmu is absent
>>>>
>>>>     Booting a recent kernel on a rk3399-based system (nanopc-t4),
>>>>     equipped with a recent u-boot and ATF results in the kernel panic
>>>>     about NULL pointer issue.
>>>
>>> nit: "results in a kernel panic on dereferencing a NULL pointer".
>>>
>>>>
>>>>     This turns out to be due to the rk3399-dmc driver looking for
>>>>     an *undocumented* property (rockchip,pmu), and happily using
>>>>     a NULL pointer when the property isn't there.
>>>>
>>>>     Instead, make most of what was brought in with 9173c5ceb035
>>>>     ("PM / devfreq: rk3399_dmc: Pass ODT and auto power down parameters
>>>>     to TF-A.") conditioned on finding this property in the device-tree,
>>>>     preventing the driver from exploding.
>>>>
>>>>     Fixes: 9173c5ceb035 ("PM / devfreq: rk3399_dmc: Pass ODT and auto power down parameters to TF-A.")
>>>>     Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>>     Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>
>>>
>>> Note that the biggest issue is still there: the driver is using an
>>> undocumented property, and this patch is just papering over it.
>>> Since I expect this property to be useful for something, it would be
>>> good for whoever knows what it does to document it.
>>
>> Hi Marc,
>>
>> You are right. We have to do two step:
>> 1. Add missing explanation of 'rockchip,pmu' property to dt-binding document
>> 2. If possible, add 'rockchip,pmu' property node to rk3399_dmc dt node.
>>
>> When I tried to find usage example of 'rockchip,pmu' property,
>> I found them as following: The 'rockchip,pmu' property[2] indicates
>> 'PMU (Power Management Unit)'. 
>>
>> $ grep -rn "rockchip,pmu" arch/arm64/boot/dts/
>> arch/arm64/boot/dts/rockchip/px30.dtsi:1211:		rockchip,pmu = <&pmugrf>;
>> arch/arm64/boot/dts/rockchip/rk3399.dtsi:1909:		rockchip,pmu = <&pmugrf>;
>> arch/arm64/boot/dts/rockchip/rk3368.dtsi:807:		rockchip,pmu = <&pmugrf>;
>>
>> [2] the description of 'rockchip,pmu' property
>> - https://protect2.fireeye.com/url?k=e55f0ba3-b8384f85-e55e80ec-0cc47a31384a-d9c5f6b28aba9be6&q=1&u=https%3A%2F%2Felixir.bootlin.com%2Flinux%2Fv5.7.2%2Fsource%2FDocumentation%2Fdevicetree%2Fbindings%2Fpinctrl%2Frockchip%2Cpinctrl.txt%23L40
>>
>>
>> If don't receive the any reply, I'll add as following:
>>
>> cwchoi00@chan-linux-pc:~/kernel/git.kernel/linux.chanwoo$ d
>> diff --git a/Documentation/devicetree/bindings/devfreq/rk3399_dmc.txt b/Documentation/devicetree/bindings/devfreq/rk3399_dmc.txt
>> index 0ec68141f85a..161e60ea874b 100644
>> --- a/Documentation/devicetree/bindings/devfreq/rk3399_dmc.txt
>> +++ b/Documentation/devicetree/bindings/devfreq/rk3399_dmc.txt
>> @@ -18,6 +18,8 @@ Optional properties:
>>                          format depends on the interrupt controller.
>>                          It should be a DCF interrupt. When DDR DVFS finishes
>>                          a DCF interrupt is triggered.
>> +- rockchip,pmu:                 Phandle to the syscon managing the "pmu general
>> +                        register files".
>>  
>>  Following properties relate to DDR timing:
>>  
>>
>>
> 
> 


-- 
Best Regards,
Chanwoo Choi
Samsung Electronics
