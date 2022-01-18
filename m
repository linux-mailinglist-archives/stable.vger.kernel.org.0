Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9297492601
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 13:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237210AbiARMtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 07:49:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4604 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234541AbiARMtF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 07:49:05 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IC7hqD016559;
        Tue, 18 Jan 2022 12:49:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=7zk+7nKCLi9ENWrIDerU8vUeqRDxwurdAz2k0Ew1qF4=;
 b=remzBvhSJOgBcBGIWMGUbbKxxnGtIZygt4s7WCdF/qSbB3yKWfghGslJ8vKEgCUzAzHf
 UCAnxFAn+6QWKgP8kkfJNKbDmNi3lnaV3UZ1TvojBiy+Cl18pFV/GvmnZ5xROtDdHstZ
 6Ok3j9cNOtsA+OSZmshvTsRhnCx0KznWK3IZAgjOdIZS7yMhyWGArd/4+VcjLwaBs2/Q
 Sze3v/bcazZiUIG+/+/yn3AURCxJPhpCzV51DW9P+cbSyLxU0qj/pDXJlJczeE/rX3Tm
 PseZ29iQfl/BilnUcPDIz3vpIpY+ScLm/vBwAt82cUl5TqWoa4lXMw7FkfkTn7BoVQ1p Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dntgf57pg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 12:49:03 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20IClku1025136;
        Tue, 18 Jan 2022 12:49:02 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dntgf57ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 12:49:02 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20ICle8p025377;
        Tue, 18 Jan 2022 12:49:00 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3dknw9mauf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 12:49:00 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20ICmwiB41615830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 12:48:58 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AFC742078;
        Tue, 18 Jan 2022 12:48:58 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7DE142047;
        Tue, 18 Jan 2022 12:48:57 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.88.172])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue, 18 Jan 2022 12:48:57 +0000 (GMT)
Date:   Tue, 18 Jan 2022 13:48:55 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH] virtio: acknowledge all features before access
Message-ID: <20220118134855.3e8cbce5.pasic@linux.ibm.com>
In-Reply-To: <20220114200744.150325-1-mst@redhat.com>
References: <20220114200744.150325-1-mst@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LgdXokpGAwTbj_bO38sN3_CjlvHbFl0p
X-Proofpoint-ORIG-GUID: a3jZiu96mqtM74oEA5U3sDEb_0Bwm1nf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_03,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 adultscore=0
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180077
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 14 Jan 2022 15:09:14 -0500
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> The feature negotiation was designed in a way that
> makes it possible for devices to know which config
> fields will be accessed by drivers.
> 
> This is broken since commit 404123c2db79 ("virtio: allow drivers to
> validate features") with fallout in at least block and net.
> We have a partial work-around in commit 2f9a174f918e ("virtio: write
> back F_VERSION_1 before validate") which at least lets devices
> find out which format should config space have, but this
> is a partial fix: guests should not access config space
> without acknowledging features since otherwise we'll never
> be able to change the config space format.
> 
> As a side effect, this also reduces the amount of hypervisor accesses -
> we now only acknowledge features once unless we are clearing any
> features when validating.
> 
> Cc: stable@vger.kernel.org
> Fixes: 404123c2db79 ("virtio: allow drivers to validate features")
> Fixes: 2f9a174f918e ("virtio: write back F_VERSION_1 before validate")
> Cc: "Halil Pasic" <pasic@linux.ibm.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> Halil, I thought hard about our situation with transitional and
> today I finally thought of something I am happy with.
> Pls let me know what you think. Testing on big endian would
> also be much appreciated!
 
Hi Michael!

I was just about to have a look into this. But it does not apply
cleanly to Linus master (fetched a couple of minutes ago). I also tride
with d9679d0013a66849~1 but no luck. What is a suitable base for this
patch?

Regards,
Halil


>  drivers/virtio/virtio.c | 31 +++++++++++++++++--------------
>  1 file changed, 17 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index d891b0a354b0..2ed6e2451fd8 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -168,12 +168,10 @@ EXPORT_SYMBOL_GPL(virtio_add_status);
>  
>  static int virtio_finalize_features(struct virtio_device *dev)
>  {
> -	int ret = dev->config->finalize_features(dev);
>  	unsigned status;
> +	int ret;
>  
>  	might_sleep();
> -	if (ret)
> -		return ret;
>  
>  	ret = arch_has_restricted_virtio_memory_access();
>  	if (ret) {
> @@ -244,17 +242,6 @@ static int virtio_dev_probe(struct device *_d)
>  		driver_features_legacy = driver_features;
>  	}
>  
> -	/*
> -	 * Some devices detect legacy solely via F_VERSION_1. Write
> -	 * F_VERSION_1 to force LE config space accesses before FEATURES_OK for
> -	 * these when needed.
> -	 */
> -	if (drv->validate && !virtio_legacy_is_little_endian()
> -			  && device_features & BIT_ULL(VIRTIO_F_VERSION_1)) {
> -		dev->features = BIT_ULL(VIRTIO_F_VERSION_1);
> -		dev->config->finalize_features(dev);
> -	}
> -
>  	if (device_features & (1ULL << VIRTIO_F_VERSION_1))
>  		dev->features = driver_features & device_features;
>  	else
> @@ -265,10 +252,22 @@ static int virtio_dev_probe(struct device *_d)
>  		if (device_features & (1ULL << i))
>  			__virtio_set_bit(dev, i);
>  
> +	err = dev->config->finalize_features(dev);
> +	if (err)
> +		goto err;
> +
>  	if (drv->validate) {
> +		u64 features = dev->features;
> +
>  		err = drv->validate(dev);
>  		if (err)
>  			goto err;
> +
> +		if (features != dev->features) {
> +			err = dev->config->finalize_features(dev);
> +			if (err)
> +				goto err;
> +		}
>  	}
>  
>  	err = virtio_finalize_features(dev);
> @@ -495,6 +494,10 @@ int virtio_device_restore(struct virtio_device *dev)
>  	/* We have a driver! */
>  	virtio_add_status(dev, VIRTIO_CONFIG_S_DRIVER);
>  
> +	ret = dev->config->finalize_features(dev);
> +	if (ret)
> +		goto err;
> +
>  	ret = virtio_finalize_features(dev);
>  	if (ret)
>  		goto err;

