Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFAB562D5A
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 10:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235858AbiGAICH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 04:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235869AbiGAICD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 04:02:03 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61026F35F
        for <stable@vger.kernel.org>; Fri,  1 Jul 2022 01:01:59 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220701080154euoutp010080b59eea023c6744736de6ee1444ab~9pceeaNoH2137521375euoutp01P
        for <stable@vger.kernel.org>; Fri,  1 Jul 2022 08:01:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220701080154euoutp010080b59eea023c6744736de6ee1444ab~9pceeaNoH2137521375euoutp01P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1656662514;
        bh=37hgzFuSB72hJ0nZxyD8/Efa1iqZgcicCr7uv9+9jJk=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=gH/SsaJ/KAbw8kAZT3d1GjNGiD3OM9bYuY0/wkhhivjRmeEDj6tukgL36hVU2QkIQ
         Xx+IW6vPadPtfEDO1Xe2lZC4EkOam8JFaTKgHb8/vXdfH+G5mOQ7CGeaxfpJ6Ij6X3
         9208F77AiZnc0QJw4hMZVEN8E7r3ti3WmevKC3b0=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220701080154eucas1p27e450ba3cd6aa0d04cd23e5d1dc89ba9~9pceTrfDU1713917139eucas1p2a;
        Fri,  1 Jul 2022 08:01:54 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 89.77.09580.2F9AEB26; Fri,  1
        Jul 2022 09:01:54 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220701080154eucas1p2c545476306b23c62ebddcabf2616b828~9pcd6KkDn0621806218eucas1p2S;
        Fri,  1 Jul 2022 08:01:54 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220701080154eusmtrp2e8ed8dfbdaf947fe9f05b257b1c5a683~9pcd5XmAs1056510565eusmtrp2a;
        Fri,  1 Jul 2022 08:01:54 +0000 (GMT)
X-AuditID: cbfec7f5-9c3ff7000000256c-b7-62bea9f2b86d
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 6F.74.09038.1F9AEB26; Fri,  1
        Jul 2022 09:01:54 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220701080153eusmtip2445003c726ff761066986ffc474c576f~9pcdWHJSq0800808008eusmtip2F;
        Fri,  1 Jul 2022 08:01:53 +0000 (GMT)
Message-ID: <4ea890c9-7df1-b5b2-0e13-0f23eb452d49@samsung.com>
Date:   Fri, 1 Jul 2022 10:01:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH] PM / devfreq: Rework freq_table to be local to devfreq
 struct
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>
Cc:     stable@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20220619220351.29891-1-ansuelsmth@gmail.com>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsWy7djPc7qfVu5LMljzXcZi6slvLBbXvzxn
        tTh/fgO7xdmmN+wWl3fNYbP43HuE0WLG+X1MFrcbV7BZLNj4iNGB02PnrLvsHptWdbJ59G1Z
        xejxeZNcAEsUl01Kak5mWWqRvl0CV8aFT/fYCxqSKtY85W9gbPXrYuTkkBAwkVi3dDJbFyMX
        h5DACkaJA433mCGcL4wSf9e2MEE4nxkl/t3+zQbTMudYLztEYjmjxO9Pf6CqPjJKrLl6nAWk
        ilfATmJNSzdQBwcHi4CKxJNVQhBhQYmTM5+AlYgKJEucO3sVrERYIETi5otgkDCzgLjErSfz
        wUaKCBxjkliw8QcjREJKYt2nQ2BHsAkYSnS97QKzOQWsJH69m8IOUSMv0bx1NtgLEgJPOCRe
        nDjHAnG1i8TnRcuYIWxhiVfHt7BD2DIS/3eCbOMAsvMl/s4whghXSFx7vQaq3FrizrlfYHcy
        C2hKrN+lDxF2lFgz9z4bRCefxI23ghAX8ElM2jadGSLMK9HRJgRRrSYx6/g6uJ0HL1xinsCo
        NAspTGYheX4Wkl9mIexdwMiyilE8tbQ4Nz212DgvtVyvODG3uDQvXS85P3cTIzANnf53/OsO
        xhWvPuodYmTiYDzEKMHBrCTCyzZvb5IQb0piZVVqUX58UWlOavEhRmkOFiVx3uTMDYlCAumJ
        JanZqakFqUUwWSYOTqkGJpaNq7y7Yg0vL+ZrsdzsU3Rv6Yvy2g9/nA5P4ZipvjiSVd2LK/bL
        2TfnJj5+mNHdU2/XebBMxu7BZKY/3h803f68Emssc29ntIq4PzNvpl382niJc883bQ/h2XZ6
        keSkr36BH6Zf+1W9I8Gr8d6tKBd72+0J3X5yJj+S3Kb/elP+3k12td12pkMf8j2OyK7ffaJx
        Y3eLmYVU2NEH/bvOpF2+JXPP5MPf7yETD9/d+Hd71+rw5zLiYg5xjakfL/Tph666uPJboKf4
        36OtIbH+Xzfv+vP8K7M1o9DVM9NShF+92eAd+au/aLly9/Wnh3gF44o2ymgGHnDfnPSWyfkW
        W2TprK5N9wpPfP8fyh7n1K7EUpyRaKjFXFScCAAfoV3zsgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t/xe7qfVu5LMnj5hNFi6slvLBbXvzxn
        tTh/fgO7xdmmN+wWl3fNYbP43HuE0WLG+X1MFrcbV7BZLNj4iNGB02PnrLvsHptWdbJ59G1Z
        xejxeZNcAEuUnk1RfmlJqkJGfnGJrVK0oYWRnqGlhZ6RiaWeobF5rJWRqZK+nU1Kak5mWWqR
        vl2CXsaFT/fYCxqSKtY85W9gbPXrYuTkkBAwkZhzrJe9i5GLQ0hgKaPE+xdL2SESMhInpzWw
        QtjCEn+udbFBFL1nlLhwr5sZJMErYCexpqUbKMHBwSKgIvFklRBEWFDi5MwnLCC2qECyRPOW
        Q0wgJcICIRI3XwSDhJkFxCVuPZnPBDJSROAUk8SPs9tZIBJSEus+HWIDsYUELCWO7T/BBGKz
        CRhKdL3tAotzClhJ/Ho3hR2i3kyia2sXI4QtL9G8dTbzBEahWUjOmIVk3ywkLbOQtCxgZFnF
        KJJaWpybnltspFecmFtcmpeul5yfu4kRGHvbjv3csoNx5auPeocYmTgYDzFKcDArifCyzdub
        JMSbklhZlVqUH19UmpNafIjRFBgUE5mlRJPzgdGfVxJvaGZgamhiZmlgamlmrCTO61nQkSgk
        kJ5YkpqdmlqQWgTTx8TBKdXANNGrWtBfOnlVY/zurKCQHcKcv9M/bVlYH95wvDay8Mm7+ESt
        Ks636+rDOKy4A0PnefLNkQ93SuYSvZS5RXxpr4WT8ZWXOWqKB7bmMGqnfK7qNq9YcdXk1wlV
        Ld0eg8Kw87Uv4749dZsjKvU5fFks1+LFTG+8nTivM9Qw9NUwarhFyq5rllj4OuHJ/rd817N3
        7/0xY/rL0/8/Hv3Vs6WA2WDDLBYG6U+b90mECCs2JMtV7P7XXdsQ18xpX8l0ycVtr1mDAGeY
        Q7wei3FTd/ZBlkkZP89dZ1j0a8Gq48kLhM79jbSLf2XDb7VZKP3OsVjtRQzLCw2PCWzsZzV5
        /iSGXfqnte2GzSc/1Vkl9iuxFGckGmoxFxUnAgCTsXsvRgMAAA==
X-CMS-MailID: 20220701080154eucas1p2c545476306b23c62ebddcabf2616b828
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220701080154eucas1p2c545476306b23c62ebddcabf2616b828
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220701080154eucas1p2c545476306b23c62ebddcabf2616b828
References: <20220619220351.29891-1-ansuelsmth@gmail.com>
        <CGME20220701080154eucas1p2c545476306b23c62ebddcabf2616b828@eucas1p2.samsung.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi All,

On 20.06.2022 00:03, Christian Marangi wrote:
> On a devfreq PROBE_DEFER, the freq_table in the driver profile struct,
> is never reset and may be leaved in an undefined state.
>
> This comes from the fact that we store the freq_table in the driver
> profile struct that is commonly defined as static and not reset on
> PROBE_DEFER.
> We currently skip the reinit of the freq_table if we found
> it's already defined since a driver may declare his own freq_table.
>
> This logic is flawed in the case devfreq core generate a freq_table, set
> it in the profile struct and then PROBE_DEFER, freeing the freq_table.
> In this case devfreq will found a NOT NULL freq_table that has been
> freed, skip the freq_table generation and probe the driver based on the
> wrong table.
>
> To fix this and correctly handle PROBE_DEFER, use a local freq_table and
> max_state in the devfreq struct and never modify the freq_table present
> in the profile struct if it does provide it.
>
> Fixes: 0ec09ac2cebe ("PM / devfreq: Set the freq_table of devfreq device")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

This patch landed in linux next-20220630 as commit b5d281f6c16d ("PM / 
devfreq: Rework freq_table to be local to devfreq struct"). 
Unfortunately it causes the following regression on my Exynos based test 
systems:

8<--- cut here ---
Unable to handle kernel NULL pointer dereference at virtual address 00000000
[00000000] *pgd=00000000
Internal error: Oops: 5 [#1] PREEMPT SMP ARM
Modules linked in:
CPU: 3 PID: 49 Comm: kworker/u8:3 Not tainted 5.19.0-rc4-next-20220630 #5312
Hardware name: Samsung Exynos (Flattened Device Tree)
Workqueue: events_unbound deferred_probe_work_func
PC is at exynos_bus_probe+0x604/0x684
LR is at device_add+0x14c/0x908
pc : [<c090aef4>]    lr : [<c06cf77c>]    psr: 80000053
...
Process kworker/u8:3 (pid: 49, stack limit = 0x(ptrval))
Stack: (0xf0a15d30 to 0xf0a16000)
...
  exynos_bus_probe from platform_probe+0x5c/0xb8
  platform_probe from really_probe+0xe0/0x414
  really_probe from __driver_probe_device+0xa0/0x208
  __driver_probe_device from driver_probe_device+0x30/0xc0
  driver_probe_device from __device_attach_driver+0xa4/0x11c
  __device_attach_driver from bus_for_each_drv+0x7c/0xc0
  bus_for_each_drv from __device_attach+0xac/0x20c
  __device_attach from bus_probe_device+0x88/0x90
  bus_probe_device from deferred_probe_work_func+0x98/0xe0
  deferred_probe_work_func from process_one_work+0x288/0x774
  process_one_work from worker_thread+0x44/0x504
  worker_thread from kthread+0xf4/0x128
  kthread from ret_from_fork+0x14/0x2c
Exception stack(0xf0a15fb0 to 0xf0a15ff8)
...
---[ end trace 0000000000000000 ]---

This issue is caused by bus->devfreq->profile->freq_table being NULL here:

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/drivers/devfreq/exynos-bus.c?h=next-20220630#n451


>   drivers/devfreq/devfreq.c          | 71 ++++++++++++++----------------
>   drivers/devfreq/governor_passive.c | 14 +++---
>   include/linux/devfreq.h            |  5 +++
>   3 files changed, 46 insertions(+), 44 deletions(-)
>
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index 01474daf4548..2e2b3b414d67 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -123,7 +123,7 @@ void devfreq_get_freq_range(struct devfreq *devfreq,
>   			    unsigned long *min_freq,
>   			    unsigned long *max_freq)
>   {
> -	unsigned long *freq_table = devfreq->profile->freq_table;
> +	unsigned long *freq_table = devfreq->freq_table;
>   	s32 qos_min_freq, qos_max_freq;
>   
>   	lockdep_assert_held(&devfreq->lock);
> @@ -133,11 +133,11 @@ void devfreq_get_freq_range(struct devfreq *devfreq,
>   	 * The devfreq drivers can initialize this in either ascending or
>   	 * descending order and devfreq core supports both.
>   	 */
> -	if (freq_table[0] < freq_table[devfreq->profile->max_state - 1]) {
> +	if (freq_table[0] < freq_table[devfreq->max_state - 1]) {
>   		*min_freq = freq_table[0];
> -		*max_freq = freq_table[devfreq->profile->max_state - 1];
> +		*max_freq = freq_table[devfreq->max_state - 1];
>   	} else {
> -		*min_freq = freq_table[devfreq->profile->max_state - 1];
> +		*min_freq = freq_table[devfreq->max_state - 1];
>   		*max_freq = freq_table[0];
>   	}
>   
> @@ -169,8 +169,8 @@ static int devfreq_get_freq_level(struct devfreq *devfreq, unsigned long freq)
>   {
>   	int lev;
>   
> -	for (lev = 0; lev < devfreq->profile->max_state; lev++)
> -		if (freq == devfreq->profile->freq_table[lev])
> +	for (lev = 0; lev < devfreq->max_state; lev++)
> +		if (freq == devfreq->freq_table[lev])
>   			return lev;
>   
>   	return -EINVAL;
> @@ -178,7 +178,6 @@ static int devfreq_get_freq_level(struct devfreq *devfreq, unsigned long freq)
>   
>   static int set_freq_table(struct devfreq *devfreq)
>   {
> -	struct devfreq_dev_profile *profile = devfreq->profile;
>   	struct dev_pm_opp *opp;
>   	unsigned long freq;
>   	int i, count;
> @@ -188,25 +187,22 @@ static int set_freq_table(struct devfreq *devfreq)
>   	if (count <= 0)
>   		return -EINVAL;
>   
> -	profile->max_state = count;
> -	profile->freq_table = devm_kcalloc(devfreq->dev.parent,
> -					profile->max_state,
> -					sizeof(*profile->freq_table),
> -					GFP_KERNEL);
> -	if (!profile->freq_table) {
> -		profile->max_state = 0;
> +	devfreq->max_state = count;
> +	devfreq->freq_table = devm_kcalloc(devfreq->dev.parent,
> +					   devfreq->max_state,
> +					   sizeof(*devfreq->freq_table),
> +					   GFP_KERNEL);
> +	if (!devfreq->freq_table)
>   		return -ENOMEM;
> -	}
>   
> -	for (i = 0, freq = 0; i < profile->max_state; i++, freq++) {
> +	for (i = 0, freq = 0; i < devfreq->max_state; i++, freq++) {
>   		opp = dev_pm_opp_find_freq_ceil(devfreq->dev.parent, &freq);
>   		if (IS_ERR(opp)) {
> -			devm_kfree(devfreq->dev.parent, profile->freq_table);
> -			profile->max_state = 0;
> +			devm_kfree(devfreq->dev.parent, devfreq->freq_table);
>   			return PTR_ERR(opp);
>   		}
>   		dev_pm_opp_put(opp);
> -		profile->freq_table[i] = freq;
> +		devfreq->freq_table[i] = freq;
>   	}
>   
>   	return 0;
> @@ -246,7 +242,7 @@ int devfreq_update_status(struct devfreq *devfreq, unsigned long freq)
>   
>   	if (lev != prev_lev) {
>   		devfreq->stats.trans_table[
> -			(prev_lev * devfreq->profile->max_state) + lev]++;
> +			(prev_lev * devfreq->max_state) + lev]++;
>   		devfreq->stats.total_trans++;
>   	}
>   
> @@ -835,6 +831,9 @@ struct devfreq *devfreq_add_device(struct device *dev,
>   		if (err < 0)
>   			goto err_dev;
>   		mutex_lock(&devfreq->lock);
> +	} else {
> +		devfreq->freq_table = devfreq->profile->freq_table;
> +		devfreq->max_state = devfreq->profile->max_state;
>   	}
>   
>   	devfreq->scaling_min_freq = find_available_min_freq(devfreq);
> @@ -870,8 +869,8 @@ struct devfreq *devfreq_add_device(struct device *dev,
>   
>   	devfreq->stats.trans_table = devm_kzalloc(&devfreq->dev,
>   			array3_size(sizeof(unsigned int),
> -				    devfreq->profile->max_state,
> -				    devfreq->profile->max_state),
> +				    devfreq->max_state,
> +				    devfreq->max_state),
>   			GFP_KERNEL);
>   	if (!devfreq->stats.trans_table) {
>   		mutex_unlock(&devfreq->lock);
> @@ -880,7 +879,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
>   	}
>   
>   	devfreq->stats.time_in_state = devm_kcalloc(&devfreq->dev,
> -			devfreq->profile->max_state,
> +			devfreq->max_state,
>   			sizeof(*devfreq->stats.time_in_state),
>   			GFP_KERNEL);
>   	if (!devfreq->stats.time_in_state) {
> @@ -1665,9 +1664,9 @@ static ssize_t available_frequencies_show(struct device *d,
>   
>   	mutex_lock(&df->lock);
>   
> -	for (i = 0; i < df->profile->max_state; i++)
> +	for (i = 0; i < df->max_state; i++)
>   		count += scnprintf(&buf[count], (PAGE_SIZE - count - 2),
> -				"%lu ", df->profile->freq_table[i]);
> +				"%lu ", df->freq_table[i]);
>   
>   	mutex_unlock(&df->lock);
>   	/* Truncate the trailing space */
> @@ -1690,7 +1689,7 @@ static ssize_t trans_stat_show(struct device *dev,
>   
>   	if (!df->profile)
>   		return -EINVAL;
> -	max_state = df->profile->max_state;
> +	max_state = df->max_state;
>   
>   	if (max_state == 0)
>   		return sprintf(buf, "Not Supported.\n");
> @@ -1707,19 +1706,17 @@ static ssize_t trans_stat_show(struct device *dev,
>   	len += sprintf(buf + len, "           :");
>   	for (i = 0; i < max_state; i++)
>   		len += sprintf(buf + len, "%10lu",
> -				df->profile->freq_table[i]);
> +				df->freq_table[i]);
>   
>   	len += sprintf(buf + len, "   time(ms)\n");
>   
>   	for (i = 0; i < max_state; i++) {
> -		if (df->profile->freq_table[i]
> -					== df->previous_freq) {
> +		if (df->freq_table[i] == df->previous_freq)
>   			len += sprintf(buf + len, "*");
> -		} else {
> +		else
>   			len += sprintf(buf + len, " ");
> -		}
> -		len += sprintf(buf + len, "%10lu:",
> -				df->profile->freq_table[i]);
> +
> +		len += sprintf(buf + len, "%10lu:", df->freq_table[i]);
>   		for (j = 0; j < max_state; j++)
>   			len += sprintf(buf + len, "%10u",
>   				df->stats.trans_table[(i * max_state) + j]);
> @@ -1743,7 +1740,7 @@ static ssize_t trans_stat_store(struct device *dev,
>   	if (!df->profile)
>   		return -EINVAL;
>   
> -	if (df->profile->max_state == 0)
> +	if (df->max_state == 0)
>   		return count;
>   
>   	err = kstrtoint(buf, 10, &value);
> @@ -1751,11 +1748,11 @@ static ssize_t trans_stat_store(struct device *dev,
>   		return -EINVAL;
>   
>   	mutex_lock(&df->lock);
> -	memset(df->stats.time_in_state, 0, (df->profile->max_state *
> +	memset(df->stats.time_in_state, 0, (df->max_state *
>   					sizeof(*df->stats.time_in_state)));
>   	memset(df->stats.trans_table, 0, array3_size(sizeof(unsigned int),
> -					df->profile->max_state,
> -					df->profile->max_state));
> +					df->max_state,
> +					df->max_state));
>   	df->stats.total_trans = 0;
>   	df->stats.last_update = get_jiffies_64();
>   	mutex_unlock(&df->lock);
> diff --git a/drivers/devfreq/governor_passive.c b/drivers/devfreq/governor_passive.c
> index 72c67979ebe1..ce24a262aa16 100644
> --- a/drivers/devfreq/governor_passive.c
> +++ b/drivers/devfreq/governor_passive.c
> @@ -131,18 +131,18 @@ static int get_target_freq_with_devfreq(struct devfreq *devfreq,
>   		goto out;
>   
>   	/* Use interpolation if required opps is not available */
> -	for (i = 0; i < parent_devfreq->profile->max_state; i++)
> -		if (parent_devfreq->profile->freq_table[i] == *freq)
> +	for (i = 0; i < parent_devfreq->max_state; i++)
> +		if (parent_devfreq->freq_table[i] == *freq)
>   			break;
>   
> -	if (i == parent_devfreq->profile->max_state)
> +	if (i == parent_devfreq->max_state)
>   		return -EINVAL;
>   
> -	if (i < devfreq->profile->max_state) {
> -		child_freq = devfreq->profile->freq_table[i];
> +	if (i < devfreq->max_state) {
> +		child_freq = devfreq->freq_table[i];
>   	} else {
> -		count = devfreq->profile->max_state;
> -		child_freq = devfreq->profile->freq_table[count - 1];
> +		count = devfreq->max_state;
> +		child_freq = devfreq->freq_table[count - 1];
>   	}
>   
>   out:
> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> index dc10bee75a72..34aab4dd336c 100644
> --- a/include/linux/devfreq.h
> +++ b/include/linux/devfreq.h
> @@ -148,6 +148,8 @@ struct devfreq_stats {
>    *		reevaluate operable frequencies. Devfreq users may use
>    *		devfreq.nb to the corresponding register notifier call chain.
>    * @work:	delayed work for load monitoring.
> + * @freq_table:		current frequency table used by the devfreq driver.
> + * @max_state:		count of entry present in the frequency table.
>    * @previous_freq:	previously configured frequency value.
>    * @last_status:	devfreq user device info, performance statistics
>    * @data:	Private data of the governor. The devfreq framework does not
> @@ -185,6 +187,9 @@ struct devfreq {
>   	struct notifier_block nb;
>   	struct delayed_work work;
>   
> +	unsigned long *freq_table;
> +	unsigned int max_state;
> +
>   	unsigned long previous_freq;
>   	struct devfreq_dev_status last_status;
>   

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

