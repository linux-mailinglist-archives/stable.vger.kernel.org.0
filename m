Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDBA421DA0E
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 17:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbgGMP3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 11:29:41 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56833 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgGMP3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jul 2020 11:29:41 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200713152939euoutp01d99105094794f5f711315a80775fbbff~hWYbr1eqp0534805348euoutp01a
        for <stable@vger.kernel.org>; Mon, 13 Jul 2020 15:29:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200713152939euoutp01d99105094794f5f711315a80775fbbff~hWYbr1eqp0534805348euoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594654179;
        bh=vO5pnPgqndY7d3Zj0BCVf+Evpl+fDIPB8p1F0ud8Gcc=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=aGyPAsz8cAGojcbhcEqCV6V9zFKr9gIHuVuSDpW6JCdFyrYuR4CespiF+AyrZlH+Q
         iTpomQDPUYjPeDDuMLnr7z05E0m2YFtUaiY0BJqhNMqQPhftAMPc+NhOJ3Q+F9y7/i
         PNHXZq2q/b5Oa4rYvwchoEyUwCOd1V4q1d+jHO6A=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200713152938eucas1p10be5680c4b788a011358e3d3a6c4e130~hWYbfVFj23160031600eucas1p1i;
        Mon, 13 Jul 2020 15:29:38 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id A1.88.05997.2ED7C0F5; Mon, 13
        Jul 2020 16:29:38 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200713152938eucas1p2c0e5026e5e8583add0fb589bffdb60d3~hWYbF7Jfz2797427974eucas1p2n;
        Mon, 13 Jul 2020 15:29:38 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200713152938eusmtrp2b19bbf9d1824b895d771f8306ad68ee3~hWYbDYYgZ0741707417eusmtrp2K;
        Mon, 13 Jul 2020 15:29:38 +0000 (GMT)
X-AuditID: cbfec7f4-65dff7000000176d-6c-5f0c7de2e36c
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 48.00.06314.2ED7C0F5; Mon, 13
        Jul 2020 16:29:38 +0100 (BST)
Received: from [106.210.85.205] (unknown [106.210.85.205]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200713152937eusmtip12910505a87ba790d2a0174c3f7e37316~hWYaS01Fz1297512975eusmtip1X;
        Mon, 13 Jul 2020 15:29:37 +0000 (GMT)
Subject: Re: [PATCH] drm/bridge: sil_sii8620: initialize return of
 sii8620_readb
To:     trix@redhat.com, narmstrong@baylibre.com,
        Laurent.pinchart@ideasonboard.com, jonas@kwiboo.se,
        jernej.skrabec@siol.net, airlied@linux.ie, daniel@ffwll.ch,
        architt@codeaurora.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
From:   Andrzej Hajda <a.hajda@samsung.com>
Message-ID: <c79fd5b6-e999-5bec-e373-7709d07f4446@samsung.com>
Date:   Mon, 13 Jul 2020 17:29:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
        Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200712152453.27510-1-trix@redhat.com>
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUhTYRTHeXbv7q5zi+tMdrIyGvXBwJcy60JhGSWX+lD0oSArnXVxopuy
        60v2amW1DGW1NLaiRljaCrXSTaWyRvmCuCTfM1AsyJlisqkparndSX77nXOe//+cPzwkJusW
        BpMpmkxWq1GmKQgxbm2ccYQNXZAkRH6aiaQLHS0C+opuTEj/td7G6M7JcYLumnZidMtoF07f
        vF0qojvqHxC0vSieNr8cQnS3uxXf7c+M914TMR1FhQLm7ZQZZ+7rjEKmWf9FwNimBoXMwK0m
        ATP+rotg3hcacMb1KuSQ+Jh452k2LSWb1UbEJIpV7idOPKNOfGaib0MeekkWID8SqK0w4rKi
        AiQmZVQ5gtHpQSFfuBEMzX/E+MKFoPpOg2hJYjAWi/hBGQKn3uUrxhHY2ksxz6tA6jCUVXR6
        vVZStYvyh3NeOUbFw/M3OuRhggqF+dd9hIelVAwUlkx6+zi1ERoGSnEPB1EnodJpE/BvAqDF
        +MPb96Oiodtg9XmuA9vYA4xnOVxxP/MuBmpCBDO/LRh/914wuQsIngNhpKnal2cN/K17JOD5
        EgyU52O8WIegpqrOJ94B3xyzi2JycUMoVNZHeBCoWOiqPMLjCugdC+BPWAF3rPcwvi0F3XUZ
        77EeBtpqfH5yeNI+SeiRwrQsmGlZGNOyMKb/a80ItyA5m8Wpk1lui4bNCeeUai5Lkxx+Kl39
        Ci3+ttaFJnctqp9LsiOKRAqJFA5KEmRCZTaXq7YjIDHFSumettaTMulpZe5ZVpueoM1KYzk7
        Wk3iCrk06rHzhIxKVmayqSybwWqXpgLSLzgPRUuj4ob1D2ciDEHnPpzYYHkfyd4I8a9qZsLy
        c9SfbY2lSb0LxmL2TFV2nEUlP/CiuCHqqNm+3XI1V25dt2rPwtOvjmFbEdlTErsW629sV4T1
        iy7urcjpTP1zfu47MPu42TLJtsubisQ9+wXhrrvG7btUP48n/hrd/zYz7kWAtkSBcyrl5k2Y
        llP+A148blJpAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t/xu7qPanniDU7eEbHoPXeSyaKp4y2r
        xf9tE5ktrnx9z2Zx9ftLZouTb66yWHROXMJucXnXHDaLQ33RFgs2PmK0uPblNIsDt8f7G63s
        Hpf7epk89n5bwOIxu2Mmq8eJCZeYPLZ/e8Dqcb/7OJPH+31X2TwO9E5m8fi8SS6AK0rPpii/
        tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/OJiU1J7MstUjfLkEv48vSlywFO7kq
        Pt5UaWDcyNHFyMkhIWAiMXnmVPYuRi4OIYGljBI3nzxhhUiIS+ye/5YZwhaW+HOtiw3EFhJ4
        yyjxfIUyiC0sECSxfN0VVpBmEYEdjBKTv00HK2IWiJaY9e8R1NQORolF12aygCTYBDQl/m6+
        CVbEK2An0TvtKyOIzSKgKrH//hKwGlGBOInlW+azQ9QISpyc+QQszilgKnFt8jZ2iAVmEvM2
        P2SGsOUltr+dA2WLSzR9Wck6gVFoFpL2WUhaZiFpmYWkZQEjyypGkdTS4tz03GJDveLE3OLS
        vHS95PzcTYzAaN527OfmHYyXNgYfYhTgYFTi4ZXw54kXYk0sK67MPcQowcGsJMLrdPZ0nBBv
        SmJlVWpRfnxRaU5q8SFGU6DnJjJLiSbnAxNNXkm8oamhuYWlobmxubGZhZI4b4fAwRghgfTE
        ktTs1NSC1CKYPiYOTqkGxlkhRuqut5qizk3uOWwcVPlppaXyvhkmq8I2Wpe/LN/wvr7AWmO2
        vjlH3fm04+cOXnoe9GviihzDhLxS99mbJxsqmS8uP8lxe5VOUKPW9ISLYrpLfaZsvLRiZmHI
        FCF58QCJq5KXaxbfUDbr4fdrW6wS/OVZJFPK7GjV7G8ZH+qenFzsPC87QomlOCPRUIu5qDgR
        AOypkZ/8AgAA
X-CMS-MailID: 20200713152938eucas1p2c0e5026e5e8583add0fb589bffdb60d3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200712152516eucas1p2cd883f7ccfcbfa78d452ba7a5641c363
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200712152516eucas1p2cd883f7ccfcbfa78d452ba7a5641c363
References: <CGME20200712152516eucas1p2cd883f7ccfcbfa78d452ba7a5641c363@eucas1p2.samsung.com>
        <20200712152453.27510-1-trix@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 12.07.2020 17:24, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
>
> clang static analysis flags this error
>
> sil-sii8620.c:184:2: warning: Undefined or garbage value
>    returned to caller [core.uninitialized.UndefReturn]
>          return ret;
>          ^~~~~~~~~~
>
> sii8620_readb calls sii8620_read_buf.
> sii8620_read_buf can return without setting its output
> pararmeter 'ret'.
>
> So initialize ret.
>
> Fixes: ce6e153f414a ("drm/bridge: add Silicon Image SiI8620 driver")
>
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>   drivers/gpu/drm/bridge/sil-sii8620.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/bridge/sil-sii8620.c b/drivers/gpu/drm/bridge/sil-sii8620.c
> index 3540e4931383..da933d477e5f 100644
> --- a/drivers/gpu/drm/bridge/sil-sii8620.c
> +++ b/drivers/gpu/drm/bridge/sil-sii8620.c
> @@ -178,7 +178,7 @@ static void sii8620_read_buf(struct sii8620 *ctx, u16 addr, u8 *buf, int len)
>   
>   static u8 sii8620_readb(struct sii8620 *ctx, u16 addr)
>   {
> -	u8 ret;
> +	u8 ret = 0;


In theory it shouldn't cause any harm, but this protections makes things 
simpler.

Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>

Regards
Andrzej


>   
>   	sii8620_read_buf(ctx, addr, &ret, 1);
>   	return ret;
