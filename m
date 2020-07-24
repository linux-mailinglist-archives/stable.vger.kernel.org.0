Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C5322C064
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 10:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgGXICZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 04:02:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23258 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgGXICX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jul 2020 04:02:23 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200724080221epoutp029bd54f4759fcd0187b4d9b94bd9e3909~koYBxmYSm3121931219epoutp02g
        for <stable@vger.kernel.org>; Fri, 24 Jul 2020 08:02:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200724080221epoutp029bd54f4759fcd0187b4d9b94bd9e3909~koYBxmYSm3121931219epoutp02g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595577741;
        bh=hY9rpWUhx1P8mckQQzl9WKYfgD/JvNgWgM+Fv0pMqhE=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=t2x/2CGEfZtj2xq4QkiaTjtXnN6eiM1EwHtEgcBRzKACxTh2iuwmkQmLyOMJBx9h6
         B+ZeTeMxmPchwl8Du18sSc4Ox8O/cyN03pgoeH8zo8Z0WE72PjUGloXpZhFZZym5KT
         qCiyERja+JYDAUA0Imc1764ZPFca+k0YHYN8hWsk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20200724080220epcas1p443170d5346261ccbd17f9089c64afedd~koYBbg6y-0480704807epcas1p4f;
        Fri, 24 Jul 2020 08:02:20 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.156]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4BChWG1pyBzMqYkV; Fri, 24 Jul
        2020 08:02:18 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        F2.A5.18978.F759A1F5; Fri, 24 Jul 2020 17:02:07 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200724080207epcas1p125e12a249e629b1068223b16b9e07edf~koX0uHQQl2072320723epcas1p1G;
        Fri, 24 Jul 2020 08:02:07 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200724080207epsmtrp206d8e37a04ddd95a000789a6a2e8e708~koX0tfoc_1271612716epsmtrp2C;
        Fri, 24 Jul 2020 08:02:07 +0000 (GMT)
X-AuditID: b6c32a35-b8298a8000004a22-bc-5f1a957f216d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E2.9E.08303.E759A1F5; Fri, 24 Jul 2020 17:02:06 +0900 (KST)
Received: from [10.113.221.102] (unknown [10.113.221.102]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200724080206epsmtip152503e90280764acc12e5a815165880e~koX0fHojd1861618616epsmtip1t;
        Fri, 24 Jul 2020 08:02:06 +0000 (GMT)
Subject: Re: [PATCH] PM / devfrq: Fix indentaion of devfreq_summary debugfs
 node
To:     Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     chanwoo@kernel.org, stable@vger.kernel.org
From:   Chanwoo Choi <cw00.choi@samsung.com>
Organization: Samsung Electronics
Message-ID: <41a5d612-ac02-ff22-84ad-9e2138b53b43@samsung.com>
Date:   Fri, 24 Jul 2020 17:13:54 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:59.0) Gecko/20100101
        Thunderbird/59.0
MIME-Version: 1.0
In-Reply-To: <20200717170847.F18AB207DD@mail.kernel.org>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42LZdlhTT7d+qlS8Qc90OYuJN66wWFzeNYfN
        4nPvEUaLTWuusVks2PiI0YHVY9OqTjaPz5vkApiism0yUhNTUosUUvOS81My89JtlbyD453j
        Tc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgLYpKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yV
        UgtScgosC/SKE3OLS/PS9ZLzc60MDQyMTIEKE7Izprc1sRec56xoOjCRpYHxPHsXIyeHhICJ
        xKRFB9i6GLk4hAR2MErc/ngDyvnEKPF1XgczhPOZUeJf43U2mJYDvftZIRK7GCXezngJ5bxn
        lNi7dz/YYGGBIIldrxeA2SICsRJrF19nBLGZBfQkbvSvBIuzCWhJ7H9xA2wqv4CixNUfj8Fq
        eAXsJH4fOwNmswioSjz4/5kZxBYVCJM4ua0FqkZQ4uTMJywgNqeAhcS7iVNZIOaLS9x6Mp8J
        wpaX2P52DtgLEgJf2SV+vd3GDPGCi8TSmVOg3hGWeHV8CzQ0pCQ+v9sLFa+WWHnyCBtEcwej
        xJb9F1ghEsYS+5dOBtrAAbRBU2L9Ln2IsKLEzt9zoZ7kk3j3tYcVpERCgFeio00IokRZ4vKD
        u0wQtqTE4vZOtgmMSrOQvDMLyQuzkLwwC2HZAkaWVYxiqQXFuempxYYFhsjRvYkRnBS1THcw
        Tnz7Qe8QIxMH4yFGCQ5mJRFeHUbxeCHelMTKqtSi/Pii0pzU4kOMpsAAnsgsJZqcD0zLeSXx
        hqZGxsbGFiaGZqaGhkrivP/OsscLCaQnlqRmp6YWpBbB9DFxcEo1MAV/nn/ulWlZLq/hrO7J
        T3Yv2/KsXuFsg8+kg2ZPouNu30pm37pxj6/rsbALO8se1P7cE572RJ/xTuEenQUTVc6fWLri
        rPM3hiub50w7oDInu1jgwDu7WNUm1tvGtyRfMsx/JbKpwMPu35rympy+OZ7+O0qDHe8GpNYX
        cOWpRcsznF9VZRDVeqlg5pp3ucHxc5mmHZzewx93oWnXTS4+xlXPjvyWNL3Gu+Dp4QN1OW/L
        gnP2Nf30iG7+oVCVqjGdaxHPlpVqefoCxwuLrso7nqpRSJ6XPGlr35Eeszvvdl+5ZnKlSmua
        gucr8Tld0/Y0Tc+RMpT69ee3g0ois0rZ/g1uB88HPpVqamVi0XQ4dluJpTgj0VCLuag4EQCu
        Hwn/EwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsWy7bCSnG7dVKl4g/nbzS0m3rjCYnF51xw2
        i8+9RxgtNq25xmaxYOMjRgdWj02rOtk8Pm+SC2CK4rJJSc3JLEst0rdL4MqY3tbEXnCes6Lp
        wESWBsbz7F2MnBwSAiYSB3r3s4LYQgI7GCWeHTOEiEtKTLt4lLmLkQPIFpY4fLi4i5ELqOQt
        o8SLhw8ZQWqEBYIkdr1eADZHRCBWov3qK2YQm1lAT+JG/0p2iIbdjBJLr/1kA0mwCWhJ7H9x
        A8zmF1CUuPrjMdggXgE7id/HzoDZLAKqEg/+fwYbJCoQJrFzyWMmiBpBiZMzn7CA2JwCFhLv
        Jk5lgVimLvFn3iWoxeISt57MZ4Kw5SW2v53DPIFReBaS9llIWmYhaZmFpGUBI8sqRsnUguLc
        9NxiwwKjvNRyveLE3OLSvHS95PzcTYzg2NDS2sG4Z9UHvUOMTByMhxglOJiVRHh1GMXjhXhT
        EiurUovy44tKc1KLDzFKc7AoifN+nbUwTkggPbEkNTs1tSC1CCbLxMEp1cB0SY/xtdniCeKX
        M/xlOR/WyVgsKmV5WeGp8TrgccGBKY9m6d223Pp6Q8keef5EGfsJs2brmt5PWc/ltlVzcuv/
        Y6qL+Rf+skvZYtzE5lq5gNNrWvDM1M+sDM8s5z30fDbh+Wo2ORG5f0fMTj1Sy2VbKmSh0ZZ1
        SXvhrOdegn57TX57LtU5HB+rJZXjy2o+jelf+6NLe6dYv7D8aTfxaIuAue2lor3RK1YIGiw9
        G/TJTjao/AW3BdM0ztQ7euc3Zry+vrNE1HNCzWfBr3tSrOt7bL1nnA/MVfRa5sHdt/1W9tGg
        /bar+XI9Vt1gd2Z6O6my1a1PWsjpHn/WN46JF/ftUo/5oiAvnSVXpRB1/rYSS3FGoqEWc1Fx
        IgDQEy35/AIAAA==
X-CMS-MailID: 20200724080207epcas1p125e12a249e629b1068223b16b9e07edf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200717170852epcas1p39bbb3c1e07c7a60c47f1dac2ee992a00
References: <20200713073112.6297-1-cw00.choi@samsung.com>
        <CGME20200717170852epcas1p39bbb3c1e07c7a60c47f1dac2ee992a00@epcas1p3.samsung.com>
        <20200717170847.F18AB207DD@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 7/18/20 2:08 AM, Sasha Levin wrote:
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: 66d0e797bf09 ("Revert "PM / devfreq: Modify the device name as devfreq(X) for sysfs"").
> 
> The bot has tested the following trees: v5.7.8, v5.4.51, v4.19.132, v4.14.188.
> 
> v5.7.8: Build OK!
> v5.4.51: Failed to apply! Possible dependencies:
>     490a421bc575d ("PM / devfreq: Add debugfs support with devfreq_summary file")
> 
> v4.19.132: Failed to apply! Possible dependencies:
>     490a421bc575d ("PM / devfreq: Add debugfs support with devfreq_summary file")
> 
> v4.14.188: Failed to apply! Possible dependencies:
>     490a421bc575d ("PM / devfreq: Add debugfs support with devfreq_summary file")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 

The fixes commit was merged to v5.6-rc4. As your test result,
it was possible to build above v5.6. It is not problem. Thanks for your testing.
- 66d0e797bf09 ("Revert "PM / devfreq: Modify the device name as devfreq(X) for sysfs"").

-- 
Best Regards,
Chanwoo Choi
Samsung Electronics
