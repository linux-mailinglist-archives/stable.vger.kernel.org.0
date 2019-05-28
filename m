Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9602BCB1
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 03:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbfE1BOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 21:14:12 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52188 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbfE1BOL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 21:14:11 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20190528011409epoutp01399827caea0e58e058ffd3917d245645~is73gYvQM1348913489epoutp01N
        for <stable@vger.kernel.org>; Tue, 28 May 2019 01:14:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20190528011409epoutp01399827caea0e58e058ffd3917d245645~is73gYvQM1348913489epoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1559006049;
        bh=oWneqg4jlZBOYOGd3mf8narmqF9wbcpkm6d6dV4nfH4=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=b+wR5arnVYwb7tIjco5/SKom8yjO+guzxSuXVdZdrtL3LWUt0HMMj5c0RSt29/v0f
         v/231/55WKaNoD0nclbjC8e+4QRdE0rdLXcF2p4nuV0fLz6dYBOhNwH30GVfp79GA0
         e6gvcAAN4XMGxLxx+ArOSZCnDfC896BuEJRtMk+Y=
Received: from epsmges1p5.samsung.com (unknown [182.195.40.158]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20190528011405epcas1p4ee675088f2a4473cdc3f62cb0c6840d5~is70B5V6t3137531375epcas1p4P;
        Tue, 28 May 2019 01:14:05 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        ED.1E.04108.D5B8CEC5; Tue, 28 May 2019 10:14:05 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190528011404epcas1p20009f79616dc90ee0f5f5d89fe3b3975~is7zpoX1l1702317023epcas1p2u;
        Tue, 28 May 2019 01:14:04 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190528011404epsmtrp180a6729253dd5e730bc4e299ec08cea2~is7zo2hX82546525465epsmtrp1C;
        Tue, 28 May 2019 01:14:04 +0000 (GMT)
X-AuditID: b6c32a39-8b7ff7000000100c-cb-5cec8b5dc0ab
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F2.FD.03662.C5B8CEC5; Tue, 28 May 2019 10:14:04 +0900 (KST)
Received: from [10.113.221.102] (unknown [10.113.221.102]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190528011404epsmtip1b13f6cfa2097680b37af83cb721389c6~is7zhB7hr0551005510epsmtip13;
        Tue, 28 May 2019 01:14:04 +0000 (GMT)
Subject: Re: [RESEND PATCH] PM / devfreq: Fix static checker warning in
 try_then_request_governor
To:     Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        linux-kernel@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     kernel@collabora.com, Dan Carpenter <dan.carpenter@oracle.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        linux-pm@vger.kernel.org
From:   Chanwoo Choi <cw00.choi@samsung.com>
Organization: Samsung Electronics
Message-ID: <4535a997-e583-da83-0cdd-0433dd798f50@samsung.com>
Date:   Tue, 28 May 2019 10:15:59 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190313122253.24355-1-enric.balletbo@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTYRju2zk7Hq3Z18x6syg91g8FbUdbHSulO0IFglEhi3XajhfczsbO
        VpkRWWRltloG0lo3SijLLjrLipBMNKMkzMqU7kXeUEpWWlFtO0X+e573e5739r00oa6goug8
        0S7YRN7EUGHk9XtxmoQNB/p1mu/3I7m+X+Ukd6mrAXE1raVK7tGu/hDuyS0PxQ0dbERcV9F5
        ijt97R1aRKfXvTyH0j9/7CTTnd5KlD5UPT2DzMpfmCvwRsEWLYgGizFPzEllVmbql+q1czVs
        ApvCzWOiRd4spDLLVmUkrMgz+dtgojfzJoc/lMFLEjM7baHN4rAL0bkWyZ7KCFajyZpiTZR4
        s+QQcxINFvN8VqNJ0vqFG/Nz+y94SOtJ9dbunz3Knag9vATRNOA5UNSmKkFhtBrXIah2Vipl
        8gXB7arykBIU6idfEfhajP8Md7+tkzV3EAx21BAyGUTQ6zxIBgwR2ADuT95gponYiaDP06oI
        EAJ7EVR98wTTUjge6rs7qAAej2Pg6fB7FMAqnAZlvt5gnMSzoK3nDBHAkXg9vG66qpQ1E6Dl
        2IdgtVC8BDyukaCGwJOh88MphYxnwO7a48H2AA9R8OrOSDAp4GVwuGaAlHEE9DZ7Q2QcBT2H
        iv/iQrjQ0kjJ5n0IvPWPlfJDMtRXlCkCyyBwHFy5NVsOx8DNHyeQXDgcBnylSnlfKthXrJYl
        sfDkzUuFjKfA2b37qcOIcY8axz1qBPeoEdz/i51GZCWaJFglc44gsVbt6N+uRsETjU+pQ02t
        qxoQphEzTsU96NOplfxmqcDcgIAmmIkqrbdXp1YZ+YJtgs2itzlMgtSAtP5tu4ioSIPFf/Ci
        Xc9qk5KTk7k57FwtyzKTVfqxL3RqnMPbhXxBsAq2fz4FHRq1Ezl2GKTClOz9LZsyb5/w9C0e
        eO5NG7Pk4sPsF7rl4tF1uw0+YmpX9p5tdrEgtrN7y1qXvuhG0vu8wdWv384a77ph3nSdi8hy
        7qi6+ay4/UH4yBma+X1p3OW2mV21Bbblhu1xXMWasPwx3ysXZHYeuTutmS/D9aqY7tgVEZN8
        A6Xlwy6GlHJ5Np6wSfwfO+8SRLgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsWy7bCSnG5M95sYg5PTLC1e/5vOYrHm9iFG
        i83nelgtzja9Ybe4vGsOm8Xn3iOMFrcbV7BZLNj4iNGBw2PH3SWMHh+f3mLx6NuyitHj8ya5
        AJYoLpuU1JzMstQifbsErow3K+ewFMwTqnjx5yVrA+MVvi5GDg4JAROJg9/Duxi5OIQEdjNK
        7JkxlbWLkRMoLikx7eJRZogaYYnDh4shat4yStw4fo4dpEZYIFli1vMtrCAJEYE+Ronru9eB
        OcwCWxglZt1/ywbRMpVR4k/DXEaQFjYBLYn9L26wgdj8AooSV388BovzCthJTP76CizOIqAq
        cenlQmYQW1QgQuLM+xUsEDWCEidnPgGzOQWcJOZM/AlWwyygLvFn3iUoW1zi1pP5TBC2vETz
        1tnMExiFZyFpn4WkZRaSlllIWhYwsqxilEwtKM5Nzy02LDDKSy3XK07MLS7NS9dLzs/dxAiO
        KC2tHYwnTsQfYhTgYFTi4bU49TpGiDWxrLgy9xCjBAezkgiv6ZZXMUK8KYmVValF+fFFpTmp
        xYcYpTlYlMR55fOPRQoJpCeWpGanphakFsFkmTg4pRoYmWby8Ir9XcW6+G93ic6CmvdJtSfj
        +gu1l/pe+hab2XugeItMrGSp2hXPD2WZds+EN84xbc6s0jWSlP0sPelJipCka7Hqn8CmdZ/n
        ca2Ozr92a0HtlLTrVp+tL87YbvSkMeqlaoPkpwzfkG1xOjHhbMs62cQrJ7E6zT38UuM2t9bL
        l9+uMX9QYinOSDTUYi4qTgQA0Dt/1aQCAAA=
X-CMS-MailID: 20190528011404epcas1p20009f79616dc90ee0f5f5d89fe3b3975
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20190313122310epcas4p4152c2c30d7a2971e44ddc7c5b64b7744
References: <CGME20190313122310epcas4p4152c2c30d7a2971e44ddc7c5b64b7744@epcas4p4.samsung.com>
        <20190313122253.24355-1-enric.balletbo@collabora.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Cc: stable@vger.kernel.org

Dear all,

It missed to send this patch to 'stable@vger.kernel.org'.
So, I add it to mailing list.

Regards,
Chanwoo Choi


On 19. 3. 13. 오후 9:22, Enric Balletbo i Serra wrote:
> The patch 23c7b54ca1cd: "PM / devfreq: Fix devfreq_add_device() when
> drivers are built as modules." leads to the following static checker
> warning:
> 
>     drivers/devfreq/devfreq.c:1043 governor_store()
>     warn: 'governor' can also be NULL
> 
> The reason is that the try_then_request_governor() function returns both
> error pointers and NULL. It should just return error pointers, so fix
> this by returning a ERR_PTR to the error intead of returning NULL.
> 
> Fixes: 23c7b54ca1cd ("PM / devfreq: Fix devfreq_add_device() when drivers are built as modules.")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
> Hi,
> 
> This is a resend of [1] as seems that got lost at some point and I just
> noticed that was never merged.
> 
> Thanks,
>  Enric
> 
> [1] https://lkml.org/lkml/2018/10/16/744
> 
> 
>  drivers/devfreq/devfreq.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index 0ae3de76833b..839621b044f4 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -228,7 +228,7 @@ static struct devfreq_governor *find_devfreq_governor(const char *name)
>   * if is not found. This can happen when both drivers (the governor driver
>   * and the driver that call devfreq_add_device) are built as modules.
>   * devfreq_list_lock should be held by the caller. Returns the matched
> - * governor's pointer.
> + * governor's pointer or an error pointer.
>   */
>  static struct devfreq_governor *try_then_request_governor(const char *name)
>  {
> @@ -254,7 +254,7 @@ static struct devfreq_governor *try_then_request_governor(const char *name)
>  		/* Restore previous state before return */
>  		mutex_lock(&devfreq_list_lock);
>  		if (err)
> -			return NULL;
> +			return ERR_PTR(err);
>  
>  		governor = find_devfreq_governor(name);
>  	}
> 


-- 
Best Regards,
Chanwoo Choi
Samsung Electronics
