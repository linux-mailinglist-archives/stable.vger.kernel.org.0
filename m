Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F78B20EA5C
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 02:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgF3Aid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 20:38:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45263 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728777AbgF3Aic (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 20:38:32 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200630003828epoutp01affb204efb3bef83796981d793e3290a~dK1oPwyXp2289822898epoutp012
        for <stable@vger.kernel.org>; Tue, 30 Jun 2020 00:38:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200630003828epoutp01affb204efb3bef83796981d793e3290a~dK1oPwyXp2289822898epoutp012
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593477509;
        bh=BGcI4sW/4NWDbR0YPdZykhJ0fZePdhSRq9FDAb2iitQ=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=td/Hu1dmGdY0GT6wvgH/Q21pn/nHMVwe8IUqhU4KB38CwV7NnveUOn9IZgGrlKIfi
         Gx9Luek335p9A3d9uwGI0gpMoPrJJX7WM0Hg7DPR+7y25+jtgSALiJT2nwyo9OosMt
         A+8brtuMNchkhvPgfdlmfPpxEk8C5/mjI2T+zfS4=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20200630003828epcas1p3a174ce5c7703fcb6c3913a649407e34a~dK1nxpEr51041410414epcas1p34;
        Tue, 30 Jun 2020 00:38:28 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.156]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 49wlp96xgLzMqYkb; Tue, 30 Jun
        2020 00:38:25 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        FE.8E.19033.E798AFE5; Tue, 30 Jun 2020 09:38:22 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200630003822epcas1p2f017c7ac051424736ae3c97da6d1d607~dK1iHWKL30561605616epcas1p2O;
        Tue, 30 Jun 2020 00:38:22 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200630003822epsmtrp2a378995b5ea63ed2d58979d866767458~dK1iGg3X60711807118epsmtrp2S;
        Tue, 30 Jun 2020 00:38:22 +0000 (GMT)
X-AuditID: b6c32a36-159ff70000004a59-3b-5efa897eb942
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A1.81.08382.E798AFE5; Tue, 30 Jun 2020 09:38:22 +0900 (KST)
Received: from [10.113.221.102] (unknown [10.113.221.102]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200630003822epsmtip20d59274b66518e07b04c7e82f4a0c199~dK1h1BKl22242522425epsmtip2e;
        Tue, 30 Jun 2020 00:38:22 +0000 (GMT)
Subject: Re: [PATCH v2] PM / devfreq: rk3399_dmc: Fix kernel oops when
 rockchip,pmu is absent
To:     Marc Zyngier <maz@kernel.org>
Cc:     Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        =?UTF-8?Q?Heiko_St=c3=bcbner?= <heiko@sntech.de>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        kernel-team@android.com, stable@vger.kernel.org
From:   Chanwoo Choi <cw00.choi@samsung.com>
Organization: Samsung Electronics
Message-ID: <20fe48e9-62bc-69e4-6cea-2499f6fd2b60@samsung.com>
Date:   Tue, 30 Jun 2020 09:49:32 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:59.0) Gecko/20100101
        Thunderbird/59.0
MIME-Version: 1.0
In-Reply-To: <636bcc73fa658747626e36d71bfcc4f9@kernel.org>
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOJsWRmVeSWpSXmKPExsWy7bCmrm5d5684g0NbLSzW3D7EaPH/0WtW
        ix3bRSzONr1ht7i8aw6bxefeI4wWO+ecZLW43biCzWLBxkeMDpwe23ZvY/XYcXcJo8emVZ1s
        Hn1bVjF6bL82j9nj8ya5ALaobJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8
        xNxUWyUXnwBdt8wcoKOUFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUpOQWWBXrFibnF
        pXnpesn5uVaGBgZGpkCFCdkZzxZOYixo46nYs7ODqYHxAmcXIyeHhICJxJnZx9i7GLk4hAR2
        MEr8ufmZFcL5xCixefo1qMw3Romp2+6zwLTsmfAAqmovo8SuVXcYIZz3jBK/N19hB6kSFoiX
        uNFyhxXEFhFQlPh04SRYEbPABiaJaafmsoEk2AS0JPa/uAFm8wMVXf3xmBHE5hWwk9hx4SQT
        iM0ioCoxd+ojsKGiAmESJ7e1QNUISpyc+QTsJE4BK4kjq3+D1TMLiEvcejIfypaXaN46mxni
        7C0cErvXy0HYLhKPNt1jgrCFJV4d38IOYUtJfH63lw3CrpZYefIIG8jREgIdjBJb9l9ghUgY
        S+xfOhmomQNogabE+l36EGFFiZ2/5zJC7OWTePe1hxWkREKAV6KjTQiiRFni8oO7UGslJRa3
        d7JNYFSaheSbWUg+mIXkg1kIyxYwsqxiFEstKM5NTy02LDBCju5NjOAUq2W2g3HS2w96hxiZ
        OBgPMUpwMCuJ8J42+BUnxJuSWFmVWpQfX1Sak1p8iNEUGL4TmaVEk/OBST6vJN7Q1MjY2NjC
        xNDM1NBQSZxXTeZCnJBAemJJanZqakFqEUwfEwenVAPT/Nud/CtezZu4o7N9Wzur1jHhd693
        e5//e/aWXglb/sWdlo23VkvPlGk8xnNn1bepIdHT5JIavl6s1koKlX0UmZO7QsorNGPifec+
        psefG6oWS1SYNR7rCb8855RtkZpEU+LR/83JAg2JZXPvhKocTDe04zWqNWstTEg6Kupwern6
        70cTezW2/mqWlsg8ExF77dSc13/3uexhf/l7596QrT8P3XmoXjC7/N+kuzbTPsY89L36Urt3
        7sUCzU9erw/c72NY9umdtkh1opTWrWPBfVb/zZ8obKvZPyPxT8zqS6y3s94/1KooXXq7LTk5
        adV257OKFqv0DyZs+Hbe3ENcm6N0TRXT817uE6/iGIIOKLEUZyQaajEXFScCAM7UCyc6BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsWy7bCSvG5d5684g4ZvfBZrbh9itPj/6DWr
        xY7tIhZnm96wW1zeNYfN4nPvEUaLnXNOslrcblzBZrFg4yNGB06Pbbu3sXrsuLuE0WPTqk42
        j74tqxg9tl+bx+zxeZNcAFsUl01Kak5mWWqRvl0CV8azhZMYC9p4Kvbs7GBqYLzA2cXIySEh
        YCKxZ8ID1i5GLg4hgd2MEpNvPGKESEhKTLt4lLmLkQPIFpY4fLgYouYto8TdtffBaoQF4iVu
        tNxhBbFFBBQlPl04yQhSxCywgUli+Z7FYEVCAhuYJe7/MASx2QS0JPa/uMEGYvMDNVz98Ris
        hlfATmLHhZNMIDaLgKrE3KmP2EFsUYEwiZ1LHjNB1AhKnJz5hAXE5hSwkjiy+jdYnFlAXeLP
        vEvMELa4xK0n86Hi8hLNW2czT2AUnoWkfRaSlllIWmYhaVnAyLKKUTK1oDg3PbfYsMAwL7Vc
        rzgxt7g0L10vOT93EyM41rQ0dzBuX/VB7xAjEwfjIUYJDmYlEd7TBr/ihHhTEiurUovy44tK
        c1KLDzFKc7AoifPeKFwYJySQnliSmp2aWpBaBJNl4uCUamA6Vlh3WfSGwzWOiH0rGopq8xxj
        1be263Tlx+7rOheTO2PXvH0cQro5q62+8QlYacZJn/tlsmBvo/z/38e6TTRkT6e3yvKfPlHz
        Ojdf3m6q8D2nzEXvI/VvRPpsizjssVnn1xSdvScvvDq8cpZ0mfIN8+8OVzUOfiuxT1253s1/
        6pp/llZx/tf3qdRo8n6aeGlmpYslk2KXnPrf+pLc316Gok1lp15u+CpmtubxC49nl6pzbx1Q
        +WkhPn/9zGnyplmTOhT+r9DYYuP65qDg48NKb/Zv+zc97WmZYYizpsXZ2nxec0Wz9exqSRuS
        SiselG6wtHKfauXLWizeIOQxN3GvwZm9Inz71qa4rwwr+qzEUpyRaKjFXFScCAAIFWEYJAMA
        AA==
X-CMS-MailID: 20200630003822epcas1p2f017c7ac051424736ae3c97da6d1d607
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
        <154fe5b6-6a05-c2b7-3014-2f7b9c2049f9@samsung.com>
        <636bcc73fa658747626e36d71bfcc4f9@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,
Hi Marc,

On 6/29/20 10:22 PM, Marc Zyngier wrote:
> On 2020-06-29 12:29, Chanwoo Choi wrote:
>> Hi Enric and Mark,
>>
>> On 6/29/20 8:05 PM, Enric Balletbo i Serra wrote:
>>> Hi Chanwoo and Marc,
>>>
>>> On 29/6/20 13:09, Chanwoo Choi wrote:
>>>> Hi Enric,
>>>>
>>>> Could you check this issue? Your patch[1] causes this issue.
>>>> As Marc mentioned, although rk3399-dmc.c handled 'rockchip,pmu'
>>>> as the mandatory property, your patch[1] didn't add the 'rockchip,pmu'
>>>> property to the documentation.
>>>>
>>>
>>> I think the problem is that the DT binding patch, for some reason, was missed
>>> and didn't land. The patch seems to have all the required reviews and acks.
>>>
>>>   https://patchwork.kernel.org/patch/10901593/
>>>
>>> Sorry because I didn't notice this issue when 9173c5ceb035 landed. And thanks
>>> for fixing the issue.
>>
>> If the 'rockchip,pmu' propery is mandatory, instead of Mark's patch,
>> we better to require the merge of patch[1] to DT maintainer.
> 
> It is way too late. Firmware exists (mainline u-boot, for one) that
> do not expose the new property, and you can't demand that people
> upgrade. This is an ABI bug, and we now have to live with it.

As you commented, it is proper that rk3399-dmc.c treats 'rockchip,pmu'
property as optional. Could you send v3 with edited patch descritpion
and adding stable mailing list to Cc?

> 
> So, yes to fixing the DT, and no to *only* fixing the DT.

-- 
Best Regards,
Chanwoo Choi
Samsung Electronics
