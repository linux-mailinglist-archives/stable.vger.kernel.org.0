Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244471EC739
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 04:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgFCCQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 22:16:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14771 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgFCCQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 22:16:29 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200603021626epoutp03f002518cf27c3c7409a4f3d4e4d5d76d~U5wdFmJZs0170601706epoutp03L
        for <stable@vger.kernel.org>; Wed,  3 Jun 2020 02:16:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200603021626epoutp03f002518cf27c3c7409a4f3d4e4d5d76d~U5wdFmJZs0170601706epoutp03L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1591150586;
        bh=bME66dlOtQH0kCIkca74ydV/mIVf+pc4dS66rCLdntM=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=sep8wLwJEUqW+EQlKiaqL1y1VWArw7hWeBv9XtzS+13HMxxiA1n3i9zKQve+38S9d
         fnTJjEULSUsxY34cR23pJg8hUVCnSOHSN1yl/dnmSR1cnfGuWe5dQ/lZEqWdjvmvq/
         uwTpqsGd3RH49vzbHvUimpO5sUrPSfp6ttL+uh7s=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200603021626epcas1p2fe69e3ba066c56157785f5fe0ce125ea~U5wcqGusS1285112851epcas1p2s;
        Wed,  3 Jun 2020 02:16:26 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.160]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 49cCFh4SS9zMqYkX; Wed,  3 Jun
        2020 02:16:24 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        D9.BF.18978.7F707DE5; Wed,  3 Jun 2020 11:16:23 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200603021623epcas1p2dc700151a39d0315b1cc4158287ecf99~U5wZ18UnG1287212872epcas1p2e;
        Wed,  3 Jun 2020 02:16:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200603021623epsmtrp1d527b3372964f3120f343c85793df63a~U5wZ1R-mW0421804218epsmtrp1d;
        Wed,  3 Jun 2020 02:16:23 +0000 (GMT)
X-AuditID: b6c32a35-5edff70000004a22-d8-5ed707f74f41
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        50.A9.08382.7F707DE5; Wed,  3 Jun 2020 11:16:23 +0900 (KST)
Received: from namjaejeon01 (unknown [10.88.104.63]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200603021623epsmtip2344435f7960b49d0073ea4253b0345eb~U5wZrFTNK1151211512epsmtip2o;
        Wed,  3 Jun 2020 02:16:23 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Al Viro'" <viro@zeniv.linux.org.uk>
Cc:     <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <syzkaller@googlegroups.com>, <butterflyhuangxx@gmail.com>,
        <sj1557.seo@samsung.com>, <stable@vger.kernel.org>
In-Reply-To: <20200603015808.GS23230@ZenIV.linux.org.uk>
Subject: RE: [PATCH] exfat: fix memory leak in exfat_parse_param()
Date:   Wed, 3 Jun 2020 11:16:23 +0900
Message-ID: <015501d6394c$fa4aeb80$eee0c280$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHbISVtbnT/hIiybKuhVppdlkZmogJhygbYAe6wsq2omdNeMA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOJsWRmVeSWpSXmKPExsWy7bCmvu539utxBm9eKVjMWTWFzWLP3pMs
        Fpd3zWGz2PLvCKvFgo2PGC2OvOlmtjj/9zirA7vHzll32T32TDzJ5tG3ZRWjx+dNch6bnrxl
        CmCNyrHJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMATpD
        SaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgaFCgV5yYW1yal66XnJ9rZWhgYGQK
        VJmQk/F6ykbWglcsFU+XNLI2MH5j7mLk5JAQMJGY9GYakM3FISSwg1FiWnMbK0hCSOATo8Si
        SVCJb4wS+xZ9h+s49uEoE0RiL6NE35/r7BDOS0aJCe93s4BUsQnoSvz7s58NxBYR0JT4P3cC
        2Chmge2MEp8WTwAq4uDgFLCQaH7mB1IjLOAksfT7ZXYQm0VAReL0laOMIDavgKXEoUkdzBC2
        oMTJmU/A5jMLyEtsfzsH6iIFiZ9Pl7FC7HKSeHXrGStEjYjE7M42sL0SAjM5JNYt/sQO0eAi
        sfPSVyYIW1ji1fEtUHEpiZf9bewgt0kIVEt83A81v4NR4sV3WwjbWOLm+g2sICXMQH+t36UP
        EVaU2Pl7LiPEWj6Jd197WCGm8Ep0tAlBlKhK9F06DLVUWqKr/QP7BEalWUgem4XksVlIHpiF
        sGwBI8sqRrHUguLc9NRiwwJD5LjexAhOoVqmOxgnvv2gd4iRiYPxEKMEB7OSCK+V7LU4Id6U
        xMqq1KL8+KLSnNTiQ4ymwKCeyCwlmpwPTOJ5JfGGpkbGxsYWJmbmZqbGSuK84jIX4oQE0hNL
        UrNTUwtSi2D6mDg4pRqY9kvHhsmo2KUd0DBbE7Oqd/FmHk7hdqfd9SXaj12zZ540NPt+3K43
        Q/hi6Rvu2gO+rYlShnk1JevnafwQTL+Wfki601JkzS8DozPFq/fPLO80ljYqvd/OXcUUn1e/
        b8qy5/Pnx9RJiAQVnHDbVfKU68/p2931z7YLCQnoJe0NmJzbuHnBjjOtFzderjwu73vJ8DFD
        BeNLxf+afxwYFiz3nynNJltx5+vHdt0X6wrf6KxUb1vptnizUuR3LpPcZ1XLxJIf/VyhlNV7
        bUE9Nz93s1RtnF6r0o6cXV0JaqnVqyc/OTZpn1pcxZ8VoTNqRfKU1LfIT83KfyTmqOC9+gzD
        hTv6YiFRJ7W9fBIfXlRiKc5INNRiLipOBABjx/YzKgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42LZdlhJXvc7+/U4gx8dAhZzVk1hs9iz9ySL
        xeVdc9gstvw7wmqxYOMjRosjb7qZLc7/Pc7qwO6xc9Zddo89E0+yefRtWcXo8XmTnMemJ2+Z
        AlijuGxSUnMyy1KL9O0SuDJeT9nIWvCKpeLpkkbWBsZvzF2MnBwSAiYSxz4cZepi5OIQEtjN
        KHHjwgMmiIS0xLETZ4CKOIBsYYnDh4shap4zSnzdto4dpIZNQFfi35/9bCC2iICmxP+5E5hB
        ipgF9jJKTLh4mA2iYyejxJGlq1lAJnEKWEg0P/MDaRAWcJJY+v0y2CAWARWJ01eOMoLYvAKW
        EocmdTBD2IISJ2c+AWtlFtCTaNsIVsIsIC+x/e0cqAcUJH4+XcYKcYOTxKtbz1ghakQkZne2
        MU9gFJ6FZNIshEmzkEyahaRjASPLKkbJ1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT83E2M4FjS
        0tzBuH3VB71DjEwcjIcYJTiYlUR4rWSvxQnxpiRWVqUW5ccXleakFh9ilOZgURLnvVG4ME5I
        ID2xJDU7NbUgtQgmy8TBKdXAlPJSuLfM/euJ5mmGP71feHCt+VP35e1mVhmLaS87pyQyiXaV
        RfAXT7hwMPetSVv6EzH9gNDyF7Zci0O/m9yMecYg1Lf7aACXPCOD/80cvYwuiS3mjcovHSXy
        th0pdOW7vr/JqWXjpUr2nPp9Bk9FQ0P1T3vuNmZtPXJ4MWueYTPT/j2e9TzFDJufz1dcf6zm
        bkm2647JTn4RcXp/br4w+eTM7tcTJKuVIXSf77ZdTGrDCnPP+seRLrVuvub1y/4dreqNWDBl
        0jKF3QckT2+o33tG72Ozo332+ntlIrvSV1m8ebvXaPLDgyVOE3zKH1nsMH/+mW/vPf6DJwpE
        pnlxfNmpwBH2erLKysIPvCxKLMUZiYZazEXFiQAL1PK7FAMAAA==
X-CMS-MailID: 20200603021623epcas1p2dc700151a39d0315b1cc4158287ecf99
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200603013447epcas1p45c6537dab8fee50f1f5b8fe7fd21da2b
References: <CGME20200603013447epcas1p45c6537dab8fee50f1f5b8fe7fd21da2b@epcas1p4.samsung.com>
        <20200603012957.9200-1-namjae.jeon@samsung.com>
        <20200603015808.GS23230@ZenIV.linux.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Wed, Jun 03, 2020 at 10:29:57AM +0900, Namjae Jeon wrote:
> 
> > exfat_free() should call exfat_free_iocharset() after stealing
> > param->string instead of kstrdup in exfat_parse_param().
> 
> ITYM
> 	extfat_free() should call exfat_free_iocharset(), to prevent a leak in case we fail after
> parsing iocharset= but before calling
> get_tree_bdev()
> 
> 	Additionally, there's no point copying param->string in
> exfat_parse_param() - just steal it, leaving NULL in param->string.
> That's independent from the leak or fix thereof - it's simply avoiding an extra copy.
Updated it in v2.
Thanks!

