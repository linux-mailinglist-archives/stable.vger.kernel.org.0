Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF0110862E
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 01:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfKYA6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Nov 2019 19:58:48 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:19182 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727127AbfKYA6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Nov 2019 19:58:48 -0500
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20191125005846epoutp0240ed5e0fb9e8b1db54b506f423706a84~aQfHNTAVo2453924539epoutp02N
        for <stable@vger.kernel.org>; Mon, 25 Nov 2019 00:58:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20191125005846epoutp0240ed5e0fb9e8b1db54b506f423706a84~aQfHNTAVo2453924539epoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1574643526;
        bh=4skhpBEBX6CXBp8/rVRERvHCz2Nln/qfjqcNNE9xmMs=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=oI0SeHBMm4h0e1CImpIOLjOthjiWEvD8lC1EYf0ZowZohLI0xz2j7SOKxw0hgPxxL
         j4XDKGdK1PZE0bSvVe0S61myzk6NuahooQ8AHiMzMx9wAe7nWQ96Ax48L6uKSEGFtl
         74M1eakuDdt8cOEv888sYRZ4JQtTbu/wiHYVatjs=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20191125005845epcas1p28ed647f6d43872bf301c5c6c34c813bd~aQfGYeZM70635306353epcas1p2Y;
        Mon, 25 Nov 2019 00:58:45 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.158]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 47LpZC068kzMqYkt; Mon, 25 Nov
        2019 00:58:43 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        CB.80.57028.0472BDD5; Mon, 25 Nov 2019 09:58:40 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20191125005839epcas1p4ed0603c2304a0cb59fd934b0bf2fe48f~aQfAzH9-m2921529215epcas1p4z;
        Mon, 25 Nov 2019 00:58:39 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20191125005839epsmtrp1d54f2d130ef20625b74d526b34ef28ff~aQfAyTyjh2222022220epsmtrp1h;
        Mon, 25 Nov 2019 00:58:39 +0000 (GMT)
X-AuditID: b6c32a35-4f3ff7000001dec4-32-5ddb2740faab
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0B.C3.10238.F372BDD5; Mon, 25 Nov 2019 09:58:39 +0900 (KST)
Received: from [10.113.221.102] (unknown [10.113.221.102]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20191125005839epsmtip262bd0be37e092bc1b91f87f54d0c1bd8~aQfAiSLlA1700217002epsmtip2w;
        Mon, 25 Nov 2019 00:58:39 +0000 (GMT)
Subject: Re: [v2 PATCH] PM / devfreq: Add new name attribute for sysfs
To:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rafael.j.wysocki@intel.com, gregkh@linuxfoundation.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        chanwoo@kernel.org, stable@vger.kernel.org
From:   Chanwoo Choi <cw00.choi@samsung.com>
Organization: Samsung Electronics
Message-ID: <d427b9a2-f11d-0739-6cc8-e1b0cb6892a0@samsung.com>
Date:   Mon, 25 Nov 2019 10:04:46 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191125004723.17926-1-cw00.choi@samsung.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHe3e2s7NoeZpaTxY2j5hlrXbaZsfKEBQdZGVXMlh20IOau7Ez
        pduHbtqS1Ib1QXMqaRe1qMTSolioaKKWZaUlSaRJWhYkZhBRO54iv/2e9/n/eS7vQ2CqK3gQ
        kWl1cg4ra6bw2dK7Lcs1mpjwAZP242Aw4+5/IWVOVt3Eme4Tn+VM7/0ynJkoaEXMwPFrODN0
        bVzOVN5+j2IIY9WDUYmxvvYMbvR6rsuNhQ21yDhRH5wk25u1IYNj0ziHmrOm2tIyrenR1KYd
        KbEphkgtraGjmLWU2spauGgqLjFJE59p9vVCqXNYc7bvKYnleWr1xg0OW7aTU2fYeGc0xdnT
        zPYo+yqetfDZ1vRVqTbLOlqrXWPwCfdnZTzui7J7/A9emPA/hkb98hFBAKmHO+6V+UhBqMgm
        BEXD+nw028ffEBQMjEvE4DuC1uYeJKgEQ5HHg8TEQwS55dUyMfiK4PFUBS6o/Ml4cNW8xgQO
        INdB528XJogwsgJBW9lniZDAyQjwfuyfNviRIfDyx9B0CSW5ESo7XyGhPykZBh8+hAgYSO6B
        zklWVMyDjpJhqcAKcj1M3SqSCYyRC+DNcIVE5CXQOF42XRbInziMtD/CxQnioKLtokxkfxhr
        b5CLHASjRXl/+QjUdLTiotmFoMHb89egA+/lYonQEEYuh5v3V4vPIXDvpweJhefCl8mzMnG9
        SnDlqURJKPS+eysReSFUnT6Dn0NU6YxxSmeMUDpjhNL/xSqRtBbN5+y8JZ3jaTs986fr0fSN
        Rhia0Pknic2IJBA1R3nrxhuTSsbm8IcszQgIjApQxnf3m1TKNPbQYc5hS3Fkmzm+GRl8u3Zj
        QYGpNt/FW50ptGGNTqdj9HSkgaapBUrixzOTikxnnVwWx9k5xz+fhFAEHUPLPiVqn+8sufsw
        rPHqZktL16zYo+669WvHOozh8iHX9gGCHem6tGiwIXdbzJ6Ep0llB1corr8vdGmWtozcid8Z
        6d21O9GdPLil+KwmtFdbPpxg2vr6CC0xJWT2GE4E67teORcntyv69iXvr/u1VU1Ux3xpizww
        1hcevGvi6bNTttsmSspnsHQE5uDZP+Kh05C5AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCSvK69+u1Yg8WT5Cwm3rjCYtG8eD2b
        xdmmN+wWl3fNYbP43HuE0eJ24wo2i8cr3rJbLNj4iNGBw2PxnpdMHptWdbJ57J+7ht2jb8sq
        Ro/Pm+QCWKO4bFJSczLLUov07RK4Mk5ctyyYK1wx9bNwA+NL/i5GTg4JAROJ/rlzGbsYuTiE
        BHYzSizdfYkJIiEpMe3iUeYuRg4gW1ji8OFiiJq3jBIf7v1nAakRFnCT6Fh5kxnEFhGwkjj9
        v4MZpIhZYD6jxM7lZ9ggOvoYJT5N3AU2lU1AS2L/ixtsIDa/gKLE1R+PGUFsXgE7iQWnrzGC
        bGMRUJV4+lQRJCwqECHxfPsNqBJBiZMzn4At5hSwlvi+oZ8VxGYWUJf4M+8SM4QtLnHryXwm
        CFteYvvbOcwTGIVnIWmfhaRlFpKWWUhaFjCyrGKUTC0ozk3PLTYsMMxLLdcrTswtLs1L10vO
        z93ECI4qLc0djJeXxB9iFOBgVOLh3bD2VqwQa2JZcWXuIUYJDmYlEV63szdihXhTEiurUovy
        44tKc1KLDzFKc7AoifM+zTsWKSSQnliSmp2aWpBaBJNl4uCUamCcENP6ZtNZzxwhpuATTd0z
        CoJ3T/ByylbUrg77kfUgJubwzENzFm2VPb3Bvf9/lfCkhsx1IZ+NTqc7O3TIhgjvWxUa4JP+
        7ULrgWdTK7tXx+ctWHou+N/Ca5pTj5uElvZETTxetnZ14Hrjf52fngdF+bx62CTj3pgVLtEZ
        2B1Q1HexpYl7wwclluKMREMt5qLiRABcvLMxpgIAAA==
X-CMS-MailID: 20191125005839epcas1p4ed0603c2304a0cb59fd934b0bf2fe48f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20191125004131epcas1p403cab8b34662b44a704d6f91aa4c4a0f
References: <CGME20191125004131epcas1p403cab8b34662b44a704d6f91aa4c4a0f@epcas1p4.samsung.com>
        <20191125004723.17926-1-cw00.choi@samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear all,

Please ignore this patch because it has the my mistake.
I'll send v3 patch.

Best Regards,
Chanwoo Choi

On 11/25/19 9:47 AM, Chanwoo Choi wrote:
> The commit 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X) for
> sysfs") changed the node name to devfreq(x). After this commit, it is not
> possible to get the device name through /sys/class/devfreq/devfreq(X)/*.
> 
> Add new name attribute in order to get device name.
> 
> Cc: stable@vger.kernel.org
> Fixes: 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X) for sysfs")
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
> Changes from v1:
> - Update sysfs-class-devfreq documentation
> - Show device name directly from 'devfreq->dev.parent'
> 
>  Documentation/ABI/testing/sysfs-class-devfreq | 7 +++++++
>  drivers/devfreq/devfreq.c                     | 9 +++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-devfreq b/Documentation/ABI/testing/sysfs-class-devfreq
> index 01196e19afca..75897e2fde43 100644
> --- a/Documentation/ABI/testing/sysfs-class-devfreq
> +++ b/Documentation/ABI/testing/sysfs-class-devfreq
> @@ -7,6 +7,13 @@ Description:
>  		The name of devfreq object denoted as ... is same as the
>  		name of device using devfreq.
>  
> +What:		/sys/class/devfreq/.../name
> +Date:		November 2019
> +Contact:	Chanwoo Choi <cw00.choi@samsung.com>
> +Description:
> +		The /sys/class/devfreq/.../name shows the name of device
> +		of the corresponding devfreq object.
> +
>  What:		/sys/class/devfreq/.../governor
>  Date:		September 2011
>  Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index 61c3e2d08969..2e5f64ee1969 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -1476,7 +1476,16 @@ static ssize_t trans_stat_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(trans_stat);
>  
> +static ssize_t name_show(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	struct devfreq *devfreq = to_devfreq(dev);
> +	return sprintf(buf, "%s\n", dev_name(devfreq->dev.parent));
> +}
> +static DEVICE_ATTR_RO(name);
> +
>  static struct attribute *devfreq_attrs[] = {
> +	&dev_attr_name.attr,
>  	&dev_attr_governor.attr,
>  	&dev_attr_available_governors.attr,
>  	&dev_attr_cur_freq.attr,
> 


