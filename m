Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847452101AA
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 03:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgGABxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 21:53:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13137 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgGABxp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 21:53:45 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200701015340epoutp0262b9b9332c7f4d4a769e2b8a3ff2fc2c~dfgkjaQOM0128701287epoutp02E
        for <stable@vger.kernel.org>; Wed,  1 Jul 2020 01:53:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200701015340epoutp0262b9b9332c7f4d4a769e2b8a3ff2fc2c~dfgkjaQOM0128701287epoutp02E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593568420;
        bh=WsewStPi5NKZSWwcHEuTtX9odtbtY4KKnz15o0zNSXQ=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=BPMflAxZPNCHNDvlIFYRcQ86uCt1B/ilmcGU29pWF9U0Cj7wApp8kGnqHjfTSVFSR
         XEBUsuy7neHyfjg7Lt6bysAfvoZnor80G9yr2o8MNXc1ikOVbO6IYGkPTDWtZ9ZcyG
         nFuGDu+gUrsmWndOiQ2ALVmMwDuJJ7mwMTurmzPU=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200701015340epcas1p2f0e5459da072f597c359e1d7ab854b29~dfgkIcle10632706327epcas1p2w;
        Wed,  1 Jul 2020 01:53:40 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.158]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 49xPQT2ny8zMqYlx; Wed,  1 Jul
        2020 01:53:37 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        F9.CF.28581.D9CEBFE5; Wed,  1 Jul 2020 10:53:33 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200701015332epcas1p29e1c70e156db7004b271f6535136d85c~dfgc1RMPx2928629286epcas1p2n;
        Wed,  1 Jul 2020 01:53:32 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200701015332epsmtrp19153144cf694c76a8d2da45bc13e5ed8~dfgc0hdZ-0911309113epsmtrp1j;
        Wed,  1 Jul 2020 01:53:32 +0000 (GMT)
X-AuditID: b6c32a38-2cdff70000006fa5-c2-5efbec9d2432
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        23.21.08303.C9CEBFE5; Wed,  1 Jul 2020 10:53:32 +0900 (KST)
Received: from [10.113.221.102] (unknown [10.113.221.102]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200701015330epsmtip1f0bfad1efa921b5559635b296aa467fc~dfgbNSVPq0279002790epsmtip1P;
        Wed,  1 Jul 2020 01:53:30 +0000 (GMT)
Subject: Re: [PATCH v3] PM / devfreq: rk3399_dmc: Fix kernel oops when
 rockchip,pmu is absent
To:     Marc Zyngier <maz@kernel.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc:     MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        stable@vger.kernel.org
From:   Chanwoo Choi <cw00.choi@samsung.com>
Organization: Samsung Electronics
Message-ID: <9e2ba2a4-fa6f-d548-9131-31dafdbdf892@samsung.com>
Date:   Wed, 1 Jul 2020 11:04:43 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:59.0) Gecko/20100101
        Thunderbird/59.0
MIME-Version: 1.0
In-Reply-To: <20200630100546.862468-1-maz@kernel.org>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBJsWRmVeSWpSXmKPExsWy7bCmge7cN7/jDCb9ZrNYc/sQo8X/R69Z
        LXZsF7E42/SG3eLyrjlsFp97jzBa7JxzktXiduMKNosFGx8xOnB6bNu9jdVjx90ljB6bVnWy
        efRtWcXosf3aPGaPz5vkAtiism0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTy
        EnNTbZVcfAJ03TJzgI5SUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BRYFugVJ+YW
        l+al6yXn51oZGhgYmQIVJmRnvJtzh7Vgm1TF7cY+xgbGGyJdjJwcEgImEl2nTzF2MXJxCAns
        YJTY0DiNFcL5xCixe/ppqMxnRom+Pc9YYFo+HzvKApHYxSjR+v85VNV7RolFjw8wg1QJC8RL
        nLlzlg3EFhGIkrjc84kZpIhZ4DmjxMne1UwgCTYBLYn9L26AFfELKEpc/fGYEcTmFbCTePDg
        C9g6FgEViTsvf4PFRQXCJE5ua4GqEZQ4OfMJWA2ngKnEhkUbwGYyC4hL3HoyH8qWl9j+dg7Y
        YgmBtRwSa9a9ZIX4wUXixI9mJghbWOLV8S3sELaUxMv+Nii7WmLlySNsEM0djBJb9l+AajaW
        2L90MlAzB9AGTYn1u/QhwooSO3/PZYRYzCfx7msPK0iJhACvREebEESJssTlB3eh1kpKLG7v
        ZJvAqDQLyTuzkLwwC8kLsxCWLWBkWcUollpQnJueWmxYYIIc35sYwUlWy2IH49y3H/QOMTJx
        MB5ilOBgVhLhPW3wK06INyWxsiq1KD++qDQntfgQoykwgCcyS4km5wPTfF5JvKGpkbGxsYWJ
        oZmpoaGSOO9JqwtxQgLpiSWp2ampBalFMH1MHJxSDUz2nVlRP8xOPHOZnr3/gUNKtrzTqacH
        I1dOn81T/rFN2ag/7uqhCo6l1QZcy44rHdq/7665MdsMvoA8y637NsceEu5ZcPL9NeH/r5Xn
        6OUx3ckpUbi1+HePgOmNc3IvFY+tMruhHN+S0Sd3dO6rYNtyLfZfxQwhQdfbUu2j0nRkLnIZ
        GXZPcmtd/2Q3/5SPTZl3+iWc+S0EXVRjVzNLZaxb4ZbsmRbuf/d28nql8qrfkkGGpWcqa+us
        rLLS18aF/rr46PUy3nUimy5fqJvuJWLspnjz9JUfIRFHuKwTNgZdnXe/osM8W/XMpC/v+ffo
        LBDsfXA72K7e9UdPSs97vZ3mQZM2/j1kdGRi9WRVRSWW4oxEQy3mouJEAHrC6YE7BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWy7bCSnO6cN7/jDGZclrNYc/sQo8X/R69Z
        LXZsF7E42/SG3eLyrjlsFp97jzBa7JxzktXiduMKNosFGx8xOnB6bNu9jdVjx90ljB6bVnWy
        efRtWcXosf3aPGaPz5vkAtiiuGxSUnMyy1KL9O0SuDLezbnDWrBNquJ2Yx9jA+MNkS5GTg4J
        AROJz8eOsnQxcnEICexglOj5tJQdIiEpMe3iUeYuRg4gW1ji8OFiiJq3jBJf7q9gBKkRFoiX
        OHPnLBtIjYhAlMSN5WBhZoHnjBKbW0sh6jsYJT7sPcMGkmAT0JLY/+IGmM0voChx9cdjsAZe
        ATuJBw++sIDYLAIqEnde/gaLiwqESexc8pgJokZQ4uTMJ2A1nAKmEhsWbWCCWKYu8WfeJWYI
        W1zi1pP5UHF5ie1v5zBPYBSehaR9FpKWWUhaZiFpWcDIsopRMrWgODc9t9iwwCgvtVyvODG3
        uDQvXS85P3cTIzjStLR2MO5Z9UHvECMTB+MhRgkOZiUR3tMGv+KEeFMSK6tSi/Lji0pzUosP
        MUpzsCiJ836dtTBOSCA9sSQ1OzW1ILUIJsvEwSnVwBS+a/fS5z9W8R9OTOtuffB1cttSNgvD
        XZe2FTou+X5xuc9Bj9qQqTpvT6T/nMillvpE5ZXdPJHOLq+TDW5pM1711jZ/D3Rpktlwxe+f
        WFhGkMhKI/EFzkdeq0emXZ5sOXvmF+3/8U2Pys8JCE6eX6m2tNN+/rYQZXaVKP9ZN2oOVCT6
        tD2JnLrnSZmq1k2+dW6RzPNK6itvnw359UzfwvB0lNeb/P0r4nZ1N06vaXr/O2qS0vbfp4rv
        SCtN/vT9isHJjdrveH7vuba8Qv6NtwWLuv2i6mlBv1K2thwvm7/7yYaPi/mOrfBhr9ulYcWx
        tz7gnaHmzuzHNSIJAX9tcs0d78rNMLZoUDHZdvUZ13wlluKMREMt5qLiRAATfaNnIwMAAA==
X-CMS-MailID: 20200701015332epcas1p29e1c70e156db7004b271f6535136d85c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200630100555epcas1p2eb8c442be31d6da3309135fdfe1a1afd
References: <CGME20200630100555epcas1p2eb8c442be31d6da3309135fdfe1a1afd@epcas1p2.samsung.com>
        <20200630100546.862468-1-maz@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

On 6/30/20 7:05 PM, Marc Zyngier wrote:
> Booting a recent kernel on a rk3399-based system (nanopc-t4),
> equipped with a recent u-boot and ATF results in an Oops due
> to a NULL pointer dereference.
> 
> This turns out to be due to the rk3399-dmc driver looking for
> an *undocumented* property (rockchip,pmu), and happily using
> a NULL pointer when the property isn't there.
> 
> Instead, make most of what was brought in with 9173c5ceb035
> ("PM / devfreq: rk3399_dmc: Pass ODT and auto power down parameters
> to TF-A.") conditioned on finding this property in the device-tree,
> preventing the driver from exploding.
> 
> Cc: stable@vger.kernel.org
> Fixes: 9173c5ceb035 ("PM / devfreq: rk3399_dmc: Pass ODT and auto power down parameters to TF-A.")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> * From v2:
>   - Trimmed down commit message
>   - Cc stable
> 
>  drivers/devfreq/rk3399_dmc.c | 42 ++++++++++++++++++++----------------
>  1 file changed, 23 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/devfreq/rk3399_dmc.c b/drivers/devfreq/rk3399_dmc.c
> index 24f04f78285b..027769e39f9b 100644
> --- a/drivers/devfreq/rk3399_dmc.c
> +++ b/drivers/devfreq/rk3399_dmc.c
> @@ -95,18 +95,20 @@ static int rk3399_dmcfreq_target(struct device *dev, unsigned long *freq,
>  
>  	mutex_lock(&dmcfreq->lock);
>  
> -	if (target_rate >= dmcfreq->odt_dis_freq)
> -		odt_enable = true;
> -
> -	/*
> -	 * This makes a SMC call to the TF-A to set the DDR PD (power-down)
> -	 * timings and to enable or disable the ODT (on-die termination)
> -	 * resistors.
> -	 */
> -	arm_smccc_smc(ROCKCHIP_SIP_DRAM_FREQ, dmcfreq->odt_pd_arg0,
> -		      dmcfreq->odt_pd_arg1,
> -		      ROCKCHIP_SIP_CONFIG_DRAM_SET_ODT_PD,
> -		      odt_enable, 0, 0, 0, &res);
> +	if (dmcfreq->regmap_pmu) {
> +		if (target_rate >= dmcfreq->odt_dis_freq)
> +			odt_enable = true;
> +
> +		/*
> +		 * This makes a SMC call to the TF-A to set the DDR PD
> +		 * (power-down) timings and to enable or disable the
> +		 * ODT (on-die termination) resistors.
> +		 */
> +		arm_smccc_smc(ROCKCHIP_SIP_DRAM_FREQ, dmcfreq->odt_pd_arg0,
> +			      dmcfreq->odt_pd_arg1,
> +			      ROCKCHIP_SIP_CONFIG_DRAM_SET_ODT_PD,
> +			      odt_enable, 0, 0, 0, &res);
> +	}
>  
>  	/*
>  	 * If frequency scaling from low to high, adjust voltage first.
> @@ -371,13 +373,14 @@ static int rk3399_dmcfreq_probe(struct platform_device *pdev)
>  	}
>  
>  	node = of_parse_phandle(np, "rockchip,pmu", 0);
> -	if (node) {
> -		data->regmap_pmu = syscon_node_to_regmap(node);
> -		of_node_put(node);
> -		if (IS_ERR(data->regmap_pmu)) {
> -			ret = PTR_ERR(data->regmap_pmu);
> -			goto err_edev;
> -		}
> +	if (!node)
> +		goto no_pmu;
> +
> +	data->regmap_pmu = syscon_node_to_regmap(node);
> +	of_node_put(node);
> +	if (IS_ERR(data->regmap_pmu)) {
> +		ret = PTR_ERR(data->regmap_pmu);
> +		goto err_edev;
>  	}
>  
>  	regmap_read(data->regmap_pmu, RK3399_PMUGRF_OS_REG2, &val);
> @@ -399,6 +402,7 @@ static int rk3399_dmcfreq_probe(struct platform_device *pdev)
>  		goto err_edev;
>  	};
>  
> +no_pmu:
>  	arm_smccc_smc(ROCKCHIP_SIP_DRAM_FREQ, 0, 0,
>  		      ROCKCHIP_SIP_CONFIG_DRAM_INIT,
>  		      0, 0, 0, 0, &res);
> 

Applied it. Thanks.

-- 
Best Regards,
Chanwoo Choi
Samsung Electronics
