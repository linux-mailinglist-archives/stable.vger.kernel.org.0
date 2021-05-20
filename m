Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4937F389AD7
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 03:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhETBX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 21:23:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39308 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhETBX6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 21:23:58 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210520012210epoutp02c80c60bcffa4dec58653d8ac6f82c9de~AocRcNUt62348723487epoutp02w
        for <stable@vger.kernel.org>; Thu, 20 May 2021 01:22:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210520012210epoutp02c80c60bcffa4dec58653d8ac6f82c9de~AocRcNUt62348723487epoutp02w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1621473730;
        bh=oO9Bsak6buLdyZ0ElfmZV+Ftbykbeh+pNMakJGzjd9A=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=diR3h3/3sC8yVfQUJAymSTZHWqDyVz6uo+HsVv6p5N7iDfaylZ2lFRo4rnRjHV55i
         StLY9XE3dKX+qhf54OpT6eMPAl6Ztw9p3c48mYQo+UQqgZfCSnhI7+O1ZJPaT9g8U3
         ZdmhXEQv+k+spPyEHWY5+OfZuW3sZFA8m59DQatE=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210520012203epcas1p2d89187772ca095d93c4216e42df86023~AocLGk5Ei2002820028epcas1p2m;
        Thu, 20 May 2021 01:22:03 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.158]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4FlsQw1GSsz4x9QF; Thu, 20 May
        2021 01:22:00 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        57.7D.09824.3B9B5A06; Thu, 20 May 2021 10:21:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210520012154epcas1p17f8894f3dcf351646d2b5eec0f8d0b65~AocCI4aMu1780417804epcas1p1y;
        Thu, 20 May 2021 01:21:54 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210520012154epsmtrp167bb48497007f48dcfb7cca866e017de~AocCIJVOK0166401664epsmtrp1k;
        Thu, 20 May 2021 01:21:54 +0000 (GMT)
X-AuditID: b6c32a37-04bff70000002660-13-60a5b9b3ef5a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        1F.F8.08163.2B9B5A06; Thu, 20 May 2021 10:21:54 +0900 (KST)
Received: from [10.113.221.102] (unknown [10.113.221.102]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210520012153epsmtip2bde4bad601320244a83865794a32d959~AocB_4yD12141621416epsmtip20;
        Thu, 20 May 2021 01:21:53 +0000 (GMT)
Subject: Re: [PATCH v2 1/1] extcon: intel-mrfld: Sync hardware and software
 state on init
To:     Ferry Toth <ftoth@exalondelft.nl>, linux-kernel@vger.kernel.org
Cc:     MyungJoo Ham <myungjoo.ham@samsung.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        stable@vger.kernel.org
From:   Chanwoo Choi <cw00.choi@samsung.com>
Organization: Samsung Electronics
Message-ID: <c6b40bfa-7629-9309-95e8-2ca877630610@samsung.com>
Date:   Thu, 20 May 2021 10:40:22 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:59.0) Gecko/20100101
        Thunderbird/59.0
MIME-Version: 1.0
In-Reply-To: <20210518212708.301112-1-ftoth@exalondelft.nl>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnk+LIzCtJLcpLzFFi42LZdlhTT3fzzqUJBrt3SVi8nHCY0eLzLTGL
        y7vmsFncblzBZrFg4yNGB1aPns33GT12zrrL7tG3ZRWjx+dNcgEsUdk2GamJKalFCql5yfkp
        mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBrlRTKEnNKgUIBicXFSvp2NkX5
        pSWpChn5xSW2SqkFKTkFlgV6xYm5xaV56XrJ+blWhgYGRqZAhQnZGV2dSgX/eCv+/PjK2sC4
        nbuLkZNDQsBEYvmek6xdjFwcQgI7GCXunljECOF8YpRY+WIGlPOZUWLimQ62LkYOsJafx7Uh
        4rsYJVaf/skE4bxnlFjRM50RZK6wQLTEg6bFzCC2iICzxK6j+9hAbGaBIonldxrBatgEtCT2
        v7gBFucXUJS4+uMxWJxXwE5iz98NYL0sAqoSJ7+0MoHYogJhEie3tUDVCEqcnPmEBcTmFLCW
        6JrzmglivrjErSfzoWx5ie1v5zCDHCch0Mgh8ax7BTvE0y4Sn3/uYYOwhSVeHd8CFZeSeNnf
        BmVXS6w8eYQNormDUWLL/gusEAljif1LJzOBgoJZQFNi/S59iLCixM7fcxkhFvNJvPvawwoJ
        LV6JjjYhiBJlicsP7jJB2JISi9s72SYwKs1C8s4sJC/MQvLCLIRlCxhZVjGKpRYU56anFhsW
        GCNH9iZGcIrUMt/BOO3tB71DjEwcjIcYJTiYlUR4t3svThDiTUmsrEotyo8vKs1JLT7EaAoM
        4InMUqLJ+cAknVcSb2hqZGxsbGFiaGZqaKgkzpvuXJ0gJJCeWJKanZpakFoE08fEwSnVwFTU
        k/vN6cjCVfkpFXX7hNV8z+ld/GaokXf/xh2OMM7loWt6zwoUvrI0jFw0O6NOhVnXb8KhnSpZ
        4rd1OOfI5n9/d+zgtTSPo1ITJUVKhZZktR5wWqSmma/E++aXbNqlbLbiR/nZ+d/+1+3butR9
        /p4SV5tMt8favGX33X8U9t1YuTR5T9Hvs11V9k6ec86uNkrP15WY1L5PKPofQ8YW/oV7Js/u
        PPpTbnMUu8rz+T2y6XVMVlNf6u1Z2+w0VepPyIqFDp9FPp9sP/mO5YPZ7CWylZ2OVdUbJdYo
        bWjlvW8c2aZxRXNqtqoBF/OmtULSrIHOAnJPb4SXXrCU6L7w4eXUAw/tDr56sTRt6daCT0os
        xRmJhlrMRcWJAMD/ZHYaBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsWy7bCSvO6mnUsTDM5uZbV4OeEwo8XnW2IW
        l3fNYbO43biCzWLBxkeMDqwePZvvM3rsnHWX3aNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
        ujqVCv7xVvz58ZW1gXE7dxcjB4eEgInEz+PaXYxcHEICOxglmpa3MHcxcgLFJSWmXTzKDFEj
        LHH4cDFEzVtGiR8t6xlBaoQFoiUeNC0GqxcRcJbYdXQfG4jNLFAkMffgJ0aIhj5Gif2XnrGC
        JNgEtCT2v7gBVsQvoChx9cdjsEG8AnYSe/5uABvEIqAqcfJLKxOILSoQJrFzyWMmiBpBiZMz
        n7CA2JwC1hJdc14zQSxTl/gz7xIzhC0ucevJfKi4vMT2t3OYJzAKz0LSPgtJyywkLbOQtCxg
        ZFnFKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREcK1paOxj3rPqgd4iRiYPxEKMEB7OS
        CO9278UJQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTCd
        0q7L/X590/8XVf+uiRhwSbGUF3Jte/RSu4ZBsFv50frCxWtsb3Oeei55h22NbbeEwMu9SsI5
        zI/muZcveysRlJQTyRq8w22hqsh+ubzFrd/2ej7c+tX9++X57D4OOyqWrTtxdo/x5r7JbUrv
        ni+Z0jXjeeKpcrlFSrefNga9zPe5l3TklsyHe96bLC9s5GlJdmbNeZC9ffHjJWw3PrG3yH46
        2lZw0Gex4P9rC8+InLZgM/06MewN61SD1s+hmsHiMdxNr9bryAt5Hdop/OTz0pKriXttW+Vs
        u9om3Oz8bav15SHHYhPND8fnn/k98aGE3ld+tXlrLA7xsZZoTVV8ZXz6rOD8socte1eqvOCe
        rcRSnJFoqMVcVJwIAMpBqA0EAwAA
X-CMS-MailID: 20210520012154epcas1p17f8894f3dcf351646d2b5eec0f8d0b65
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210518212900epcas1p1ee28319630a51ab22ebf938c5bc222b3
References: <CGME20210518212900epcas1p1ee28319630a51ab22ebf938c5bc222b3@epcas1p1.samsung.com>
        <20210518212708.301112-1-ftoth@exalondelft.nl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/19/21 6:27 AM, Ferry Toth wrote:
> extcon driver for Basin Cove PMIC shadows the switch status used for dwc3
> DRD to detect a change in the switch position. This change initializes the
> status at probe time.
> 
> Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
> Fixes: 492929c54791 ("extcon: mrfld: Introduce extcon driver for Basin Cove PMIC")
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: stable@vger.kernel.org
> ---
> 
> v2:
>  - Clarified patch title (Chanwoo)
> ---
>  drivers/extcon/extcon-intel-mrfld.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/extcon/extcon-intel-mrfld.c b/drivers/extcon/extcon-intel-mrfld.c
> index f47016fb28a8..cd1a5f230077 100644
> --- a/drivers/extcon/extcon-intel-mrfld.c
> +++ b/drivers/extcon/extcon-intel-mrfld.c
> @@ -197,6 +197,7 @@ static int mrfld_extcon_probe(struct platform_device *pdev)
>  	struct intel_soc_pmic *pmic = dev_get_drvdata(dev->parent);
>  	struct regmap *regmap = pmic->regmap;
>  	struct mrfld_extcon_data *data;
> +	unsigned int status;
>  	unsigned int id;
>  	int irq, ret;
>  
> @@ -244,6 +245,14 @@ static int mrfld_extcon_probe(struct platform_device *pdev)
>  	/* Get initial state */
>  	mrfld_extcon_role_detect(data);
>  
> +	/*
> +	 * Cached status value is used for cable detection, see comments
> +	 * in mrfld_extcon_cable_detect(), we need to sync cached value
> +	 * with a real state of the hardware.
> +	 */
> +	regmap_read(regmap, BCOVE_SCHGRIRQ1, &status);
> +	data->status = status;
> +
>  	mrfld_extcon_clear(data, BCOVE_MIRQLVL1, BCOVE_LVL1_CHGR);
>  	mrfld_extcon_clear(data, BCOVE_MCHGRIRQ1, BCOVE_CHGRIRQ_ALL);
>  
> 

Applied it. Thanks.

-- 
Best Regards,
Chanwoo Choi
Samsung Electronics
