Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB63221B878
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 16:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgGJOYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 10:24:01 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36987 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728521AbgGJOX6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 10:23:58 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200710142357euoutp02d93d03b2129e14c4e6f9c8c23f994cd1~gajOLAUXS0738007380euoutp02d
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 14:23:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200710142357euoutp02d93d03b2129e14c4e6f9c8c23f994cd1~gajOLAUXS0738007380euoutp02d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594391037;
        bh=+Qvo0XwtXckoH/AUrFmMc7w7gy5RtXKGS7/7n/Ctqy8=;
        h=From:Subject:To:Cc:Date:In-Reply-To:References:From;
        b=q9QOI9/xIZY3AZ3d1s8UDhZUOn1yDZJunSKkoK4dusx/D8NzLPTAwiI3k2w7u3vJF
         3JRFflqueC1LkhARejrA1uTZytOPULgsWOpbbq76tQw5uZxlAg83M92zFDwavwuDKs
         gLDTD9E4M3YIwIencTOpsnLhbv7D4ahBv/1vn6uo=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200710142357eucas1p1f51947db6ba1918ff5e55ed8f63493bf~gajN7olP_0594905949eucas1p1c;
        Fri, 10 Jul 2020 14:23:57 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 0D.DE.06318.DF9780F5; Fri, 10
        Jul 2020 15:23:57 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200710142357eucas1p1908fe8cf542f43520d448a62bad52192~gajNjMH9Y0592905929eucas1p1c;
        Fri, 10 Jul 2020 14:23:57 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200710142357eusmtrp14ad7bd0285374a5f1465db4533739ced~gajNiiE8j1135411354eusmtrp1d;
        Fri, 10 Jul 2020 14:23:57 +0000 (GMT)
X-AuditID: cbfec7f5-371ff700000018ae-47-5f0879fd93b4
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 5E.D1.06314.CF9780F5; Fri, 10
        Jul 2020 15:23:56 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200710142356eusmtip11d7318b84521021556174f0b106a8445~gajNKh3d10397803978eusmtip1J;
        Fri, 10 Jul 2020 14:23:56 +0000 (GMT)
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] omapfb: dss: Fix max fclk divider for omap36xx
To:     Adam Ford <aford173@gmail.com>
Cc:     linux-fbdev@vger.kernel.org, stable@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Rob Clark <robdclark@gmail.com>, linux-omap@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Message-ID: <e7bb19a5-774c-63c3-058f-1977d29cd94c@samsung.com>
Date:   Fri, 10 Jul 2020 16:23:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200630182636.439015-1-aford173@gmail.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsWy7djPc7p/KzniDVoWSVrcuX2a2eLE9UVM
        Fle+vmezONH3gdXi8q45bBazl/SzWDxf+IPZYsHGR4wW6+ffYnPg9Ng56y67x/3u40wex29s
        Z/L4vEkugCWKyyYlNSezLLVI3y6BK+Pa5jOMBd+5K87PeMrcwHiHs4uRk0NCwESi/XQ7axcj
        F4eQwApGiaV7ZkE5Xxglrh9dwg7hfAZyPr5jhWlZ9vUbVGI5o8SjvesZIZy3jBJPfrSzg1Sx
        CVhJTGxfxQhiCws4S9zu6AGzRQSUJO6e+QvWwCzQxCTxfV8D2FheATuJ43fvsYDYLAKqEveX
        LARrEBWIkPj04DBUjaDEyZlPwGo4BSwl1q87wgRiMwuIS9x6Mh/KlpfY/nYOM8gCCYFd7BIL
        fvUDXcQB5LhI9L+whXhBWOLV8S3sELaMxOnJPSwQ9esYJf52vIBq3s4osXzyPzaIKmuJO+d+
        sYEMYhbQlFi/Sx8i7Chx7dRWZoj5fBI33gpC3MAnMWnbdKgwr0RHmxBEtZrEhmUb2GDWdu1c
        yTyBUWkWks9mIflmFpJvZiHsXcDIsopRPLW0ODc9tdg4L7Vcrzgxt7g0L10vOT93EyMwIZ3+
        d/zrDsZ9f5IOMQpwMCrx8C5I5IgXYk0sK67MPcQowcGsJMLrdPZ0nBBvSmJlVWpRfnxRaU5q
        8SFGaQ4WJXFe40UvY4UE0hNLUrNTUwtSi2CyTBycUg2M3qePLBBZXhlhtE4ra0Mbu6HzsyP/
        K0WexItOOnD6i7jR3effZ23TN2jnztoXYX7uVP07jf6GXwIT/X4u0OCpuyqyo2Dx7aozvatj
        7or4/LyW/ebgR7uPzxuZrwq5i5avvx03lfO2wYxlZesvzf4n/fPQZJZbCW7TOU8mtE1hmnjt
        7I2vZmd+PVRiKc5INNRiLipOBABMxWzDRAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t/xu7p/KzniDXaLWNy5fZrZ4sT1RUwW
        V76+Z7M40feB1eLyrjlsFrOX9LNYPF/4g9liwcZHjBbr599ic+D02DnrLrvH/e7jTB7Hb2xn
        8vi8SS6AJUrPpii/tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/OJiU1J7MstUjf
        LkEv49rmM4wF37krzs94ytzAeIezi5GTQ0LARGLZ12/sXYxcHEICSxklXh7tYeti5ABKyEgc
        X18GUSMs8edaFxtEzWtGiR0rHzKBJNgErCQmtq9iBLGFBZwlbnf0gNkiAkoSd8/8ZQRpYBZo
        YpLYsX8zVHcPo0RT/z6wKl4BO4njd++xgNgsAqoS95csBIuLCkRIHN4xC6pGUOLkzCdgNZwC
        lhLr1x0B28wsoC7xZ94lZghbXOLWk/lQcXmJ7W/nME9gFJqFpH0WkpZZSFpmIWlZwMiyilEk
        tbQ4Nz232FCvODG3uDQvXS85P3cTIzD+th37uXkH46WNwYcYBTgYlXh4FyRyxAuxJpYVV+Ye
        YpTgYFYS4XU6ezpOiDclsbIqtSg/vqg0J7X4EKMp0HMTmaVEk/OBqSGvJN7Q1NDcwtLQ3Njc
        2MxCSZy3Q+BgjJBAemJJanZqakFqEUwfEwenVAOjhrRSax/bk6rWB4fP2Lm4S+6zzZ4cq/BC
        K883LyGR21vea6OpkG3EfeMO3eenT1UtcX7/9+V/7cjvTwpmNiVUNfYv3xO/IVPjenT7+ai9
        Mpr6wt8qOZTd3v/4ZFtiIe92QGr+E/8F098v4HD+FXd8zVueJIV8w+WPJ/RG+/xUCTS6PvOo
        v6kSS3FGoqEWc1FxIgDDaxKK1QIAAA==
X-CMS-MailID: 20200710142357eucas1p1908fe8cf542f43520d448a62bad52192
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200630182652eucas1p1ce5e07b065127e32ab734f4447c2f735
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200630182652eucas1p1ce5e07b065127e32ab734f4447c2f735
References: <CGME20200630182652eucas1p1ce5e07b065127e32ab734f4447c2f735@eucas1p1.samsung.com>
        <20200630182636.439015-1-aford173@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 6/30/20 8:26 PM, Adam Ford wrote:
> The drm/omap driver was fixed to correct an issue where using a
> divider of 32 breaks the DSS despite the TRM stating 32 is a valid
> number.  Through experimentation, it appears that 31 works, and
> it is consistent with the value used by the drm/omap driver.
> 
> This patch fixes the divider for fbdev driver instead of the drm.
> 
> Fixes: f76ee892a99e ("omapfb: copy omapdss & displays for omapfb")
> 
> Cc: <stable@vger.kernel.org> #4.9+
> Signed-off-by: Adam Ford <aford173@gmail.com>

Applied to drm-misc-next tree, thanks.

(I marked patch as applicable to stable 4.5+ while merging)

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> ---
> Linux 4.4 will need a similar patch, but it doesn't apply cleanly.
> 
> The DRM version of this same fix is:
> e2c4ed148cf3 ("drm/omap: fix max fclk divider for omap36xx")
> 
> 
> diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dss.c b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> index 7252d22dd117..bfc5c4c5a26a 100644
> --- a/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> +++ b/drivers/video/fbdev/omap2/omapfb/dss/dss.c
> @@ -833,7 +833,7 @@ static const struct dss_features omap34xx_dss_feats = {
>  };
>  
>  static const struct dss_features omap3630_dss_feats = {
> -	.fck_div_max		=	32,
> +	.fck_div_max		=	31,
>  	.dss_fck_multiplier	=	1,
>  	.parent_clk_name	=	"dpll4_ck",
>  	.dpi_select_source	=	&dss_dpi_select_source_omap2_omap3,
> 
