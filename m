Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AFB48BE51
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 06:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350867AbiALF2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 00:28:20 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:52118 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350864AbiALF2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 00:28:19 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220112052817epoutp015ad5d9a86752be08486cba4b73c73574~Jbr0joUS92428224282epoutp01S
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 05:28:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220112052817epoutp015ad5d9a86752be08486cba4b73c73574~Jbr0joUS92428224282epoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1641965297;
        bh=DBlpt8zEyfBoFiTfnSV9HfySIF4tMQGpL5xC3LD+qFA=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=RTZrhLb7feEbAi2HJSHSpQr3smdDiDxys3/2h/nBxR6zrAh4n+TEi2u4QM+CABO08
         nz/dJYpfd8X+NxvPq7uMhBfcPsokSzRMGnYuuVfYm/wwTzZL8ivdx41MUEQZZwgRh+
         k5Sp7UuM5VyIrPkXMPFlgiJvtT7Uw+NfPVhJdcWk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20220112052816epcas2p12ad21681638fe0f4dd707fc70a1df9b7~JbrzxFrtY1284812848epcas2p1Z;
        Wed, 12 Jan 2022 05:28:16 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.91]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4JYbgd4l7fz4x9QC; Wed, 12 Jan
        2022 05:28:13 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        B8.01.12141.9E66ED16; Wed, 12 Jan 2022 14:28:09 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20220112052809epcas2p2ab6e44808c234ebd240e9f75868d8853~JbrsoLvZi0312903129epcas2p2h;
        Wed, 12 Jan 2022 05:28:09 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220112052809epsmtrp2f93038a20ac9058510e44e5203484866~JbrsnDPcH0560405604epsmtrp2f;
        Wed, 12 Jan 2022 05:28:09 +0000 (GMT)
X-AuditID: b6c32a48-d5dff70000002f6d-61-61de66e90dfe
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        46.1A.08738.8E66ED16; Wed, 12 Jan 2022 14:28:08 +0900 (KST)
Received: from KORCO082417 (unknown [10.229.8.121]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220112052808epsmtip2c4988f2b65f4eb2f70fc070d11faf4f3~JbrsYWI1S3232232322epsmtip2I;
        Wed, 12 Jan 2022 05:28:08 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Krzysztof Kozlowski'" <krzysztof.kozlowski@canonical.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc:     "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Sam Protsenko'" <semen.protsenko@linaro.org>,
        "'Alim Akhtar'" <alim.akhtar@gmail.com>, <stable@vger.kernel.org>
In-Reply-To: <20220111201426.326777-2-krzysztof.kozlowski@canonical.com>
Subject: RE: [PATCH v2 01/28] pinctrl: samsung: drop pin banks references on
 error paths
Date:   Wed, 12 Jan 2022 14:28:08 +0900
Message-ID: <000201d80775$2f22af80$8d680e80$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEPsg0rhN1RyLWOER/EMv1WEdO3IgGScUn2AfcCpqit0zqE4A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMJsWRmVeSWpSXmKPExsWy7bCmhe7LtHuJBnP/6FssvVVtMf/IOVaL
        jW9/MFlM+bOcyWLT42usFpvn/2G0uLxrDpvFjPP7mCzWHrnLbtG69wi7xeE37awWz/uAYgs2
        PmK0WLXrD6MDn8eshl42j52z7rJ7bFrVyeZx59oeNo/NS+o9+rasYvT4vEkugD0q2yYjNTEl
        tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6GIlhbLEnFKgUEBi
        cbGSvp1NUX5pSapCRn5xia1SakFKToF5gV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbGzZX32AqW
        clWsfr2CqYHxO0cXIweHhICJxKVpql2MXBxCAjsYJY503maHcD4xSrTd+M8M4XxmlDhw/jyQ
        wwnWMfXYeRaIxC5GiY2vFkBVvQByGmeCVbEJ6Eu87NjGCpIQEVjELLF6z2lGEIdZYBWjxO4V
        88CqOAU8JDYumANmCwtESRx/OJkJxGYRUJV48aKZBeRCXgFLiQcX3UHCvAKCEidnPmEBsZkF
        5CW2v50DdZKCxM+ny1hBbBEBJ4nG1zMYIWpEJGZ3toFdJyFwg0Pi3uTP7BANLhKd/08yQdjC
        Eq+Ob4GKS0l8freXDaKhm1Fi0su7UIkZjBLvbuZA2MYSs561M4IcxyygKbF+lz4kJJUljtyC
        uo1PouPwX3aIMK9ER5sQRKO6xIHt01kgbFmJ7jmfWScwKs1C8tksJJ/NQvLBLIRdCxhZVjGK
        pRYU56anFhsVmMBjOzk/dxMjODVreexgnP32g94hRiYOxkOMEhzMSiK8ZTF3E4V4UxIrq1KL
        8uOLSnNSiw8xmgKDeiKzlGhyPjA75JXEG5pYGpiYmRmaG5kamCuJ83qlbEgUEkhPLEnNTk0t
        SC2C6WPi4JRqYFot+/7lc9fNvpo7W1L+RjpNSlc3OZURX3Oqxv2Ge7+Pxlf1iJnptiWlNgYi
        xVF16S5/L3NVLjt7S7t7tscKHhHJpHzzffMf2HurcK3WYBZxvFBzXZmdv+sgx0ZZpsULszZr
        HlJNFtXnXfPFNHTPG3GZFbMeJ4dfj6+UEOJdETktc4Vor+vLvtz7El83PczxXLj0jDaDwi/v
        VVZyS2ZcMLP4NfuMw8Fpm1yELoRbH2+d/vrd/JaDx+6/miH7tkWhnCdLhqGu4UqO6Jx7znXV
        7Oq3nj2aemTjLueotQwlv57kMJ+0lVz5bGfor6Y70nynlrT3R5/94qzxkl07a+nU3IfVxtc2
        sjVNEitT9nALV2Ipzkg01GIuKk4EADFJpdpWBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWy7bCSvO6LtHuJBpdPmlssvVVtMf/IOVaL
        jW9/MFlM+bOcyWLT42usFpvn/2G0uLxrDpvFjPP7mCzWHrnLbtG69wi7xeE37awWz/uAYgs2
        PmK0WLXrD6MDn8eshl42j52z7rJ7bFrVyeZx59oeNo/NS+o9+rasYvT4vEkugD2KyyYlNSez
        LLVI3y6BK+PmyntsBUu5Kla/XsHUwPido4uRk0NCwERi6rHzLF2MXBxCAjsYJSaueMUIkZCV
        ePZuBzuELSxxv+UIK0TRM0aJo1uWgxWxCehLvOzYBpYQEVjBLPH9yVU2EIdZYA2jRMfZz2wQ
        LVcZJS5fO8kM0sIp4CGxccEcMFtYIELiyrqfYDtYBFQlXrxoBjqEg4NXwFLiwUV3kDCvgKDE
        yZlPwMLMAnoSbRvBFjMLyEtsfwsxRUJAQeLn02WsILaIgJNE4+sZUDUiErM725gnMArPQjJp
        FsKkWUgmzULSsYCRZRWjZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnCUamntYNyz6oPe
        IUYmDsZDjBIczEoivGUxdxOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCeWJKanZpa
        kFoEk2Xi4JRqYErzsIxZ6xMpzZT375ezq5q5jc4srz3LJR/wfD11jc/zbcTfdX5nReN0X27X
        YcgIUbbnKZ11NK6u4ovwW9PzacFppx7oBXBd0/t8VOHdOhnXfGWhGAfpLZpeGnv+RLf63mSx
        3O2mGNAQGe3wfq1ZfkT1Gdv7Fo/fh24NE+ye8mpTlUTf3VV2inV/vlZYscZ83Ck/Y8X3U2df
        Sj3dev3LI0elj4rXnxmKB8wMlLM+HJkdyqc9RWCdbNRBy/Tc9Zsio9wr12hOtrOsFMoT4tvN
        tefLomf7YmwF7v64URm0+6TtuhUTPffkOYlVlBS0iG8oTjVxdntreeWiiWX0RtmzCQd4nrVE
        pcw2fqDwQIdZiaU4I9FQi7moOBEA8fqK3UEDAAA=
X-CMS-MailID: 20220112052809epcas2p2ab6e44808c234ebd240e9f75868d8853
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220111201525epcas2p144b5308bb4ce008232366fae822ba464
References: <20220111201426.326777-1-krzysztof.kozlowski@canonical.com>
        <CGME20220111201525epcas2p144b5308bb4ce008232366fae822ba464@epcas2p1.samsung.com>
        <20220111201426.326777-2-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> -----Original Message-----
> From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> Sent: Wednesday, January 12, 2022 5:14 AM
> To: Tomasz Figa <tomasz.figa@gmail.com>; Krzysztof Kozlowski
> <krzysztof.kozlowski@canonical.com>; Sylwester Nawrocki
> <s.nawrocki@samsung.com>; Linus Walleij <linus.walleij@linaro.org>; Rob
> Herring <robh+dt@kernel.org>; linux-arm-kernel@lists.infradead.org; linux-
> samsung-soc@vger.kernel.org; linux-gpio@vger.kernel.org;
> devicetree@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>; Sam Protsenko
> <semen.protsenko@linaro.org>; Chanho Park <chanho61.park@samsung.com>;
> Alim Akhtar <alim.akhtar@gmail.com>; stable@vger.kernel.org
> Subject: [PATCH v2 01/28] pinctrl: samsung: drop pin banks references on
> error paths
> 
> The driver iterates over its devicetree children with
> for_each_child_of_node() and stores for later found node pointer.  This
> has to be put in error paths to avoid leak during re-probing.
> 
> Fixes: ab663789d697 ("pinctrl: samsung: Match pin banks with their device
> nodes")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

Reviewed-by: Chanho Park <chanho61.park@samsung.com>

Best Regards,
Chanho Park

