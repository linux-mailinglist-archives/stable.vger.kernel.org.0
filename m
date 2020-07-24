Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE43E22BCB3
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 06:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbgGXEBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 00:01:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49181 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbgGXEBH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jul 2020 00:01:07 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200724040103epoutp0296197d6d57cbaf09746c4276ee449701~klFW2_Bpw3094630946epoutp02n
        for <stable@vger.kernel.org>; Fri, 24 Jul 2020 04:01:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200724040103epoutp0296197d6d57cbaf09746c4276ee449701~klFW2_Bpw3094630946epoutp02n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595563263;
        bh=4oztz4LeLjm2r+k2SBAwuOt7dQd7C6+B0gFTCCxP6NQ=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=mKmV3Rbu/aJ37SmGWpiq+jX4IhydIF4iacEaKSJfK6X6LyPrVtbHlTYk/0Hq2bYnn
         TtWLFkWFlq6/BPyiokvOoxgJsFu5eUq3wyu4zFQJhYMgRuC9HfaYRwvJapLYX9xTYe
         /8dfIeSaHOPotgaP8oJ65aiJazftS2vYvI/Lk+hc=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20200724040103epcas1p3a098ac4482bdfe179226c1b714f68f44~klFWYTowD0296002960epcas1p3X;
        Fri, 24 Jul 2020 04:01:03 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.163]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4BCb8s3CyLzMqYkh; Fri, 24 Jul
        2020 04:01:01 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        1A.7A.29173.BFC5A1F5; Fri, 24 Jul 2020 13:00:59 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20200724040058epcas1p48e5a26a997f899d376a7c033983b17bb~klFRmBNxx0697606976epcas1p4c;
        Fri, 24 Jul 2020 04:00:58 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200724040058epsmtrp1d1c1b794bba17e3c4b935b7be32042a2~klFRlZvrB0158301583epsmtrp15;
        Fri, 24 Jul 2020 04:00:58 +0000 (GMT)
X-AuditID: b6c32a37-9cdff700000071f5-96-5f1a5cfb0577
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        79.CE.08382.AFC5A1F5; Fri, 24 Jul 2020 13:00:58 +0900 (KST)
Received: from namjaejeon01 (unknown [10.88.104.63]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200724040057epsmtip27655044a71c0b79684bca35dd3e4fc79~klFRZC8DN0495804958epsmtip26;
        Fri, 24 Jul 2020 04:00:57 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Sasha Levin'" <sashal@kernel.org>
Cc:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
In-Reply-To: <20200724035723.GF406581@sasha-vm>
Subject: RE: [PATCH 5.7.y 0/4] exfat stable patches for 5.7.y
Date:   Fri, 24 Jul 2020 13:00:58 +0900
Message-ID: <016201d6616f$0983e030$1c8ba090$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGJDqnsY1LDjyjebNXsD2Bok62GUAL5Dj7NAe6AywWpiYOW8A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFKsWRmVeSWpSXmKPExsWy7bCmvu7vGKl4g+b1mhbNi9ezWWxac43N
        YsHGR4wOzB6bVnWyeeyfu4bd4/MmuQDmqBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0Nd
        Q0sLcyWFvMTcVFslF58AXbfMHKBFSgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwC
        Q4MCveLE3OLSvHS95PxcK0MDAyNToMqEnIxpz/qZChYwV0y695KpgXEvUxcjJ4eEgInEiyu7
        2LsYuTiEBHYwSjyduY0ZwvnEKLFo33kWCOcbo8SZHWfZYFqeLtvCBpHYyygxedkKqKqXjBLP
        ez4zg1SxCehK/PuzH6xDREBdYtWNNWA2s4CVxPauM2A2p4C+xM1NV8DqhQVsJVbenckIYrMI
        qErsmtDNCmLzClhKvH73gRHCFpQ4OfMJC8QceYntb+cwQ1ykIPHz6TJWiF1OEpPu90PtEpGY
        3dkG9o+EwFt2iZcbL7FANLhI/Oo+CQ0BYYlXx7ewQ9hSEi/724BsDiC7WuLjfqj5HYwSL77b
        QtjGEjfXb2AFKWEW0JRYv0sfIqwosfP3XEaItXwS7772sEJM4ZXoaBOCKFGV6Lt0GGqptERX
        +wf2CYxKs5A8NgvJY7OQPDALYdkCRpZVjGKpBcW56anFhgXGyJG9iRGcCLXMdzBOe/tB7xAj
        EwfjIUYJDmYlEV4dRvF4Id6UxMqq1KL8+KLSnNTiQ4ymwKCeyCwlmpwPTMV5JfGGpkbGxsYW
        JmbmZqbGSuK8/86yxwsJpCeWpGanphakFsH0MXFwSjUw5UoGvkye5j7pdsTsAqH91sIBUdq5
        e2TFW8qUN3Mm+6R80N7x2zn2R5kla1KG+aXgFVcfp8TMdayet86bIzHwX5L+Pa1SnlMTeE49
        n9Vw9lxah4Nl6hwVX9N5847e6z/gpSp3dGFqfwH/nsxjCS11Xmx+XV4/rTtc9n+/tte1ctfH
        faFtGYrWE5Y/fOrGxS5ocX3mdv3Nr4xOhYY0CR8y97wy67LaSsv9XvfSDP75ubi+jLg6qXvd
        kZa9AZUF9R7C7WGKpqnlvv4FD//N4qiW5tayY19Q7vxhLussmx+rpe/tEz7aEbQ8S0J29wOB
        /f35ZxqmFKe0nTgaVrPwpqXg98O+/7/reuk8mWahparEUpyRaKjFXFScCAC8G0tKDQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsWy7bCSvO6vGKl4gxM32SyaF69ns9i05hqb
        xYKNjxgdmD02repk89g/dw27x+dNcgHMUVw2Kak5mWWpRfp2CVwZ0571MxUsYK6YdO8lUwPj
        XqYuRk4OCQETiafLtrB1MXJxCAnsZpR4craVDSIhLXHsxBnmLkYOIFtY4vDhYoia54wS36+c
        ZAapYRPQlfj3Zz9YvYiAusSqG2vAbGYBG4mJ2y+wQjRsZJSYs/QiO0iCU0Bf4uamK2DNwgK2
        EivvzmQEsVkEVCV2TehmBbF5BSwlXr/7wAhhC0qcnPmEBeQIZgE9ibaNjBDz5SW2v53DDHGn
        gsTPp8tYIW5wkph0vx/qBhGJ2Z1tzBMYhWchmTQLYdIsJJNmIelYwMiyilEytaA4Nz232LDA
        MC+1XK84Mbe4NC9dLzk/dxMjOB60NHcwbl/1Qe8QIxMH4yFGCQ5mJRFeHUbxeCHelMTKqtSi
        /Pii0pzU4kOM0hwsSuK8NwoXxgkJpCeWpGanphakFsFkmTg4pRqY2vxNbuyMm/RnqZaEe/CM
        PRtYtWYkMFYcehJzptyVmb2gPbj2cef8ULMjL5wemf7cefjClxm1sbwdURIvby7oNBffsvJn
        trz9E1NNGwGXd8XRWrKHj3m7nFFU0eCW1lnquOkQ36KY0u0yC/Y2rtwtzSB5+dz+0z/0DB+u
        WX5uw7x42VBdN/2wnC11W9IYOW7l2nHf+aaRK+DZV7/lkb8ve0b3MVZpl0V7H6br7/60a9LX
        P/OqQ7nzzndcXHwsRVJrXsoZrRfNxsEbeqvFZrbfN+A69UWrdsf+nV7zr6Y/f/zzygXt2rO8
        Czka9UwNEzdPOL5yScTqSSbBpTsfq2ywPrT0auysu4Z8aw93PRaIVGIpzkg01GIuKk4EAMIB
        71z2AgAA
X-CMS-MailID: 20200724040058epcas1p48e5a26a997f899d376a7c033983b17bb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200724002112epcas1p24c54808617a5baddef4e4a2f49722866
References: <CGME20200724002112epcas1p24c54808617a5baddef4e4a2f49722866@epcas1p2.samsung.com>
        <20200724001544.30862-1-namjae.jeon@samsung.com>
        <20200724035723.GF406581@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> 
> On Fri, Jul 24, 2020 at 09:15:40AM +0900, Namjae Jeon wrote:
> >Hi,
> >
> >Could you please pick up exfat stable patches ?
> 
Hi Sasha,
> I see that the upstream commits already have stable tags and don't need modifications for backporting,
> so there is no need to explicitly send them here - they will be picked up automatically.
Okay, I see:)
Thanks for your mail!
> 
> --
> Thanks,
> Sasha

