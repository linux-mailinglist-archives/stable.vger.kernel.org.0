Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEFF82D0AA5
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 07:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgLGGY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 01:24:27 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:50779 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgLGGYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 01:24:25 -0500
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20201207062342epoutp03171b2274fff93688c39ca9f8bf3063c7~OWwuOv8QD0949409494epoutp03c
        for <stable@vger.kernel.org>; Mon,  7 Dec 2020 06:23:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20201207062342epoutp03171b2274fff93688c39ca9f8bf3063c7~OWwuOv8QD0949409494epoutp03c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1607322222;
        bh=fBP4mWJSZ04Q9CT3hoILVOAje37IO6HJzymBLKwRFEs=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=Dk5DNVOo6Yvvgb99BsHHzt+VZR8SJkSllStJz6Zn57wCVvWTePeTlGRMElKYqGBms
         tVOiU6VtdoWBnCJ6V7E9NmNwTU6G3S4NNP2Wf1lIN2riDEWli93gKArUwabOHFRKQy
         7FuXXP+W9556XBTZIwf0CtNsKKiuJ56s4JWnG6FU=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20201207062341epcas1p316c187679875dfe5ce454263df2fb2a3~OWwt3Ge5Z1514615146epcas1p39;
        Mon,  7 Dec 2020 06:23:41 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.165]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4CqCth6jRYz4x9Q0; Mon,  7 Dec
        2020 06:23:40 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        AB.02.09577.66ACDCF5; Mon,  7 Dec 2020 15:23:34 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20201207062334epcas1p48080d035311cb446cce68e813065fbf2~OWwmmVGDZ2156321563epcas1p4b;
        Mon,  7 Dec 2020 06:23:34 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201207062334epsmtrp243e82dd1e88e6f4a3774272b84741a42~OWwmloUb62830928309epsmtrp2q;
        Mon,  7 Dec 2020 06:23:34 +0000 (GMT)
X-AuditID: b6c32a39-c13ff70000002569-27-5fcdca66b50c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        84.81.08745.56ACDCF5; Mon,  7 Dec 2020 15:23:33 +0900 (KST)
Received: from W10PB11329 (unknown [10.253.152.129]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201207062333epsmtip14ea44c2d24bf1eb66c3040541ccc6bac~OWwmXu0Wi1719417194epsmtip1c;
        Mon,  7 Dec 2020 06:23:33 +0000 (GMT)
From:   "Sungjong Seo" <sj1557.seo@samsung.com>
To:     "'Artem Labazov'" <123321artyom@gmail.com>
Cc:     <stable@vger.kernel.org>,
        "'Namjae Jeon'" <namjae.jeon@samsung.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20201204125730.GA546513@xps13>
Subject: RE: [PATCH] exfat: Avoid allocating upcase table using kcalloc()
Date:   Mon, 7 Dec 2020 15:23:33 +0900
Message-ID: <40be01d6cc61$7d23cac0$776b6040$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQGAh9ZISCX29VPYFR7X7vXspJxNNgFOHEJzAktfIl8Cd4Eq1KpnILpw
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdlhTVzft1Nl4g3XrxC023fzGarFn70kW
        i8u75rBZ/Jheb7Fg4yNGB1aPnbPusnv0bVnF6PF5k1wAc1SOTUZqYkpqkUJqXnJ+SmZeuq2S
        d3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QRiWFssScUqBQQGJxsZK+nU1RfmlJqkJG
        fnGJrVJqQUpOgaFBgV5xYm5xaV66XnJ+rpWhgYGRKVBlQk7GvZZ2toJVPBXv9i9hbGB8xNnF
        yMEhIWAisX8ZVxcjF4eQwA5Gib+Xb7JCOJ8YJT7N3MTSxcgJ5HxmlNi8yBTEBmlY838XM0TR
        LkaJWTOOsUA4Lxklnp7/xwRSxSagK/Hkxk9mEFtEQE/ixM4dYB3MAl2MEo93/QYbyymgI/Ho
        +yVGkDuEBTwldi7UBAmzCKhI9LQcYgexeQUsJXa83M8KYQtKnJz5BKyVWUBeYvvbOcwQFylI
        7P50lBVil5vE1fV7mSBqRCRmd7aB7ZUQ+MkusW/1fEaIBheJzQcnsEHYwhKvjm9hh7ClJD6/
        2wsVr5f4P38tO0RzC6PEw0/bmCABZi/x/pIFiMksoCmxfpc+RLmixM7fcxkh9vJJvPvawwpR
        zSvR0SYEUaIi8f3DThaYTVd+XGWawKg0C8lns5B8NgvJB7MQli1gZFnFKJZaUJybnlpsWGCK
        HNebGMGJUctyB+P0tx/0DjEycTAeYpTgYFYS4VWTOhsvxJuSWFmVWpQfX1Sak1p8iNEUGNYT
        maVEk/OBqTmvJN7Q1MjY2NjCxMzczNRYSZz3j3ZHvJBAemJJanZqakFqEUwfEwenVAPTmrDs
        2MgHgktr0mrYFmctbNbwThKP/d9xKP56zKp/ds41lx8yXI7beqbvbZlFhNKd641NShH27q6+
        r5LljhnY7d9R1jBhfwI3p7DyrR1B/DfaT9pdvc6TZuuo3XBx1aMvgmJSCqEq2immE+acEz3e
        esrkaPYRIabGF/kx3KdFd2fzundvEH8hka2qYPV3i3q5jcK0zfXc6z5e0VL2KVDwXv8xefLS
        Wz+3n1og5ej3Osjzv/0Pt83ti3grlibsXePaVM9WvGY/r2/7n+MbLdUmxy1Kuf5J1NYw3zH1
        xA/H8+svskYfaP/x742aj9lGicmb2UWvPayeVv1/1bxPvnoTz7ZM5vFbc87A2d8x6IASS3FG
        oqEWc1FxIgAX6dmTFQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsWy7bCSnG7qqbPxBrummFpsuvmN1WLP3pMs
        Fpd3zWGz+DG93mLBxkeMDqweO2fdZffo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujHst7WwF
        q3gq3u1fwtjA+Iizi5GTQ0LARGLN/13MXYxcHEICOxglNkw9z9rFyAGUkJI4uE8TwhSWOHy4
        GKRcSOA5o8S7VwUgNpuArsSTGz+ZQWwRAT2JEzt3gI1hFuhjlPja0ccOMfMuo0T/+1mMIFWc
        AjoSj75fYgQZKizgKbFzoSZImEVARaKn5RA7iM0rYCmx4+V+VghbUOLkzCcsIOXMQAvaNoJN
        YRaQl9j+dg4zxPkKErs/HWWFuMFN4ur6vUwQNSISszvbmCcwCs9CMmkWwqRZSCbNQtKxgJFl
        FaNkakFxbnpusWGBUV5quV5xYm5xaV66XnJ+7iZGcHRoae1g3LPqg94hRiYOxkOMEhzMSiK8
        alJn44V4UxIrq1KL8uOLSnNSiw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLglGpgurxE
        keOYfP387Ie6mjwiITuk/ljq33+X6lomYagQttFXYccJ+8db9Lcbx8/j4BLMDzloFlX02IMz
        rJ1BQsI8co3YD4HpK+TD707Mm96mqK/+dfH+zn0szgzpqxQTim9OVTtrevuOvG4LZ23HMiZF
        s7srpqp2lZgLxR9atVLjK/uK1gkaW5a4u89zrFeZUHhrpdoEm+d/N7JzTMjntdhT3u/aObdP
        xl0z+0ie8v7I30WZ/Np5+RG7z0ftCfXo2njPbWVU9J2DYqENmx5Kt+l3BilVSj4p99ow8cCy
        wrOZMT0KiROdIvZs5VYW1dXWavVKaWW7qnZL8M/1d3X7jb8v4PfM2Li+bnK5esUJWSWW4oxE
        Qy3mouJEAPrIdcT9AgAA
X-CMS-MailID: 20201207062334epcas1p48080d035311cb446cce68e813065fbf2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201124194858epcas1p49cacda6a9b4877ff125f25f4dc5fcadf
References: <CGME20201124194858epcas1p49cacda6a9b4877ff125f25f4dc5fcadf@epcas1p4.samsung.com>
        <20201124194749.4041176-1-123321artyom@gmail.com>
        <001101d6c867$ca8c5730$5fa50590$@samsung.com>
        <20201204125730.GA546513@xps13>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > I have not yet received a report of the same issue.
> > But I agree that this problem is likely to occur even if it is low
> > probability.
> 
> Perhaps I should clarify my setup a little bit more.
> The issue can be reliably reproduced on my laptop. It has 8 GBs of RAM
> (pretty common amount nowadays) and runs an unmodified Fedora 32 kernel.
> Also, I use zswap, which seems to be contributing to fragmentation as
well.
> 
> > I think it would be more appropriate to use kvcalloc and kvfree instead.
> 
> I do not think this is really needed.
> Upcase table allocation is relatively large (32 pages of 4KB size) and
> happens only once, when the drive is being mounted. Also, exfat driver
> does not rely on the fact that the table is physically contiguous.
> That said, vmalloc/vfree seems to be the best option, according to
> kernel's "Memory Allocation Guide".

The address range available for vmalloc() allocations is limited on 32-bit
systems. If all kernel codes that need non-contiguous memory of the size
order 1 or larger try to allocate it by only vmalloc(), the address range
for vmalloc() could be insufficient.
So, I think it would be better to give kmalloc() "one" chance.

I know that kvmalloc() only tries kmalloc() once (noretry, nowarn) and if it
fails, it immediately falls back to vmalloc(). Therefore, I think kvmalloc()
and kvfree() are the best solution for solving the problem you are facing
and
the problem I mentioned above.

Could you send me patch v3 that uses kvcalloc() and kvfree()?

> 
> --
> Artem

