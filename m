Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE65E3ACE22
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 16:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbhFRPAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 11:00:45 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:31043 "EHLO
        mailout1.w2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234832AbhFRPAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 11:00:40 -0400
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20210618144958usoutp01dbe60fb1587904053c63b483a55f60d5~JtK2bToOM0166701667usoutp01F;
        Fri, 18 Jun 2021 14:49:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20210618144958usoutp01dbe60fb1587904053c63b483a55f60d5~JtK2bToOM0166701667usoutp01F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624027798;
        bh=iUVr5JmOMO+MwdqHyU8GkgmRUeFPf/64YB/2H+HZjfs=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=SfexU4HsrPI3fbtaApn0xP13/BAv+hAHP0YMMP5YQucisbFJEbQoZTwRXdo6YU/Iu
         rBz765PysC8fUrqvpVlU1tRVlwJmxiIiN/dgwg/f/Z37QbnTKpJX6Oad5XedHnyqc2
         5caV5xiwslTk5RJzsakGFG5hkWclz1n9yot+GFcs=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210618144958uscas1p18dd396f8ce5c74c2332e6f742da3abc6~JtK2P33qd2510025100uscas1p1-;
        Fri, 18 Jun 2021 14:49:58 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id 3E.49.53491.692BCC06; Fri,
        18 Jun 2021 10:49:58 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210618144957uscas1p2b49a0cb5c20870a96842a9fab548a56e~JtK1c0dWM0843908439uscas1p2o;
        Fri, 18 Jun 2021 14:49:57 +0000 (GMT)
X-AuditID: cbfec36f-f09ff7000001d0f3-49-60ccb296f8f9
Received: from SSI-EX1.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 9E.93.26904.492BCC06; Fri,
        18 Jun 2021 10:49:57 -0400 (EDT)
Received: from SSI-EX1.ssi.samsung.com (105.128.2.226) by
        SSI-EX1.ssi.samsung.com (105.128.2.226) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Fri, 18 Jun 2021 07:49:56 -0700
Received: from SSI-EX1.ssi.samsung.com ([fe80::255d:1bae:c3ae:e3c3]) by
        SSI-EX1.ssi.samsung.com ([fe80::255d:1bae:c3ae:e3c3%7]) with mapi id
        15.01.2242.008; Fri, 18 Jun 2021 07:49:56 -0700
From:   Adam Manzanares <a.manzanares@samsung.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
CC:     Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Shaun Tancheff <shaun@tancheff.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jens Axboe <axboe@fb.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] blk-zoned: allow BLKREPORTZONE without
 CAP_SYS_ADMIN
Thread-Topic: [PATCH v3 2/2] blk-zoned: allow BLKREPORTZONE without
        CAP_SYS_ADMIN
Thread-Index: AQHXYRgQCVfFQ7HNWEWEcKzi48L9sqsaVZAA
Date:   Fri, 18 Jun 2021 14:49:56 +0000
Message-ID: <20210618144956.GB33886@bgt-140510-bm01>
In-Reply-To: <20210614122303.154378-3-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B5CDFD0C97F7DA4584EDD78FCE32D6C1@ssi.samsung.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsWy7djXc7rTNp1JMLi9gs3i/55jbBar7/az
        WbS2f2OyWPBmL5vF3lvaFpd3zWGzWH78H5PFgz+P2S0mnz7BarFg4yNGBy6Pic3v2D0uny31
        +Pj0FovH+i1XWTxu3J/C5PF5k5xH+4FupgD2KC6blNSczLLUIn27BK6M1RO3sxT85Km4O+c+
        YwPjca4uRk4OCQETiSO/DrOC2EICKxklVuyvhrBbmSR2TdSGqTn1vYWpi5ELKL6WUeLz7SeM
        EM5HRok3T1ZBOQcYJY7duQg2ik3AQOL38Y3MILaIgKbE51NrweLMAlOZJfa1uoDYwgJBEotm
        TmWHqAmWePrtOSOEbSSxfN0DsDiLgKrE0T+rmEBsXqAzVrb/BpvDKWAjMeHNCbB6RgExie+n
        1jBBzBeXuPVkPhPE2YISi2bvYYawxST+7XrIBmErStz//pIdol5HYsHuT2wQtp3Elv5GFghb
        W2LZwtfMEHsFJU7OfMIC0SspcXDFDRaQhyUEmjklOqb2sUMkXCRO74Y4SEJAWuLv3WVMEEW7
        GCXmzP7ICuEcZpTYdGE5VJW1xI2XXYwTGFVmIbl8FpKrZiG5ahaSq2YhuWoBI+sqRvHS4uLc
        9NRio7zUcr3ixNzi0rx0veT83E2MwIR2+t/h/B2M12991DvEyMTBeIhRgoNZSYSXM/NMghBv
        SmJlVWpRfnxRaU5q8SFGaQ4WJXFepoiJ8UIC6YklqdmpqQWpRTBZJg5OqQYmI7YPmnc1qiRK
        bDeb6n35m3q4du2RC/67RCU8WZeVmxrseJz/Qy5z9qMpd5sXLu2T/PR3hYBY1q3I1WEz28wK
        uVmzNu+8ExG6RJUtTHxW7qElE2t3z3ljX2X4NvitmDTjvppTRgemmVk1FUvNWFrbsUK9QG33
        hyt9xotP5PZqv+11Zk8+KbF2PdOe+LCsxewrPhVVfHG1Nz4XXOHG+cDn+9xfS/27LDevWlke
        sub6Ay/j/jucc8JyT39Srn557+COjbdOL/krx3rJ+eXB+DO85yrVX+xx/SbILrVA2IXn8qPf
        NcvzTax5e3aecd7CG71ALLhvoY7YtrM//EIPLdqzNWfS3Jc6tp9/lHWkXlX/ocRSnJFoqMVc
        VJwIAHXQT+3XAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsWS2cA0SXfqpjMJBkffclv833OMzWL13X42
        i9b2b0wWC97sZbPYe0vb4vKuOWwWy4//Y7J48Ocxu8Xk0ydYLRZsfMTowOUxsfkdu8fls6Ue
        H5/eYvFYv+Uqi8eN+1OYPD5vkvNoP9DNFMAexWWTkpqTWZZapG+XwJWxeuJ2loKfPBV359xn
        bGA8ztXFyMkhIWAicep7C1MXIxeHkMBqRolFDz+xQDgfGSV+fbrKDuEcYJRY/aODFaSFTcBA
        4vfxjcwgtoiApsTnU2tZQYqYBaYySzxdsZsdJCEsECSxaOZUdoiiYIm/S5+xQNhGEsvXPQCL
        swioShz9s4oJxOYFumNl+29WiG0HGSWOr78Dto1TwEZiwpsTjCA2o4CYxPdTa8AamAXEJW49
        mc8E8YSAxJI955khbFGJl4//sULYihL3v79kh6jXkViw+xMbhG0nsaW/kQXC1pZYtvA1M8QR
        ghInZz5hgeiVlDi44gbLBEaJWUjWzUIyahaSUbOQjJqFZNQCRtZVjOKlxcW56RXFRnmp5XrF
        ibnFpXnpesn5uZsYgeng9L/D0TsYb9/6qHeIkYmD8RCjBAezkggvZ+aZBCHelMTKqtSi/Pii
        0pzU4kOM0hwsSuK8L6MmxgsJpCeWpGanphakFsFkmTg4pRqYGCqfTSj1+qFh8uZvqKSKQ4KT
        6PS9DH8OrC2x2rBxN88DvzWOB8K+fWK2i5UxnnXwHU/jauvI4zwVAtcnLr+nueJDgGEl8zdX
        Nn2ZsxLSOm87r4ZPVNvldXXl+zuPLCXOfNrxZe49k6poXY656fuvLe++uXKizdSGjgteHsKZ
        j4xXWs2e/yo8xWPuef4tW/Im3s1+dChH7FR4YLr/jvPmpfFOVnN3vWS/ZCUXHjHF+G9R1ZMk
        hxtbHwtn709b+qvkyYr7Kf6WlodKJ02/Z/lo4W4NUYuvrzxNhb7vSSiessYs3fVT7W0b7TtX
        K24JPmEtVmt5uGFdwap3aZvbl9Tzrtmv1/Pyw6TpPWEbJK9u3q/EUpyRaKjFXFScCADjvWr5
        dgMAAA==
X-CMS-MailID: 20210618144957uscas1p2b49a0cb5c20870a96842a9fab548a56e
CMS-TYPE: 301P
X-CMS-RootMailID: 20210614122358uscas1p1b06438713a13aef1eb31a9b0a6c359dc
References: <20210614122303.154378-1-Niklas.Cassel@wdc.com>
        <CGME20210614122358uscas1p1b06438713a13aef1eb31a9b0a6c359dc@uscas1p1.samsung.com>
        <20210614122303.154378-3-Niklas.Cassel@wdc.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 12:23:21PM +0000, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
>=20
> A user space process should not need the CAP_SYS_ADMIN capability set
> in order to perform a BLKREPORTZONE ioctl.
>=20
> Getting the zone report is required in order to get the write pointer.
> Neither read() nor write() requires CAP_SYS_ADMIN, so it is reasonable
> that a user space process that can read/write from/to the device, also
> can get the write pointer. (Since e.g. writes have to be at the write
> pointer.)
>=20
> Fixes: 3ed05a987e0f ("blk-zoned: implement ioctls")
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> Cc: stable@vger.kernel.org # v4.10+
> ---
> Changes since v2:
> -Drop the FMODE_READ check. Right now it is possible to open() the device=
 with
> O_WRONLY and get the zone report from that fd. Therefore adding a FMODE_R=
EAD
> check on BLKREPORTZONE would break existing applications. Instead, just r=
emove
> the existing CAP_SYS_ADMIN check.
>=20
>  block/blk-zoned.c | 3 ---
>  1 file changed, 3 deletions(-)
>=20
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 0789e6e9f7db..457eceabed2e 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -288,9 +288,6 @@ int blkdev_report_zones_ioctl(struct block_device *bd=
ev, fmode_t mode,
>  	if (!blk_queue_is_zoned(q))
>  		return -ENOTTY;
> =20
> -	if (!capable(CAP_SYS_ADMIN))
> -		return -EACCES;
> -
>  	if (copy_from_user(&rep, argp, sizeof(struct blk_zone_report)))
>  		return -EFAULT;
> =20
> --=20
> 2.31.1

LGTM

Reviewed-by: Adam Manzanares <a.manzanares@samsung.com>=
