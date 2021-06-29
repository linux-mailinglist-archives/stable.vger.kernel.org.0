Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA243B75CE
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 17:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbhF2PqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 11:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbhF2PqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 11:46:02 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123D7C061767
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 08:43:35 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id a133so24529899oib.13
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 08:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XsjqZMs995RZPUKa7Q5/5AxsEU09PC6mvpt5UNfBSbc=;
        b=aNZQHqziLdBPmizCqjLrDoTbPgAeY3ThB2AANo2X0axgp9SWL+O312VSvON2cz3ViJ
         Sil4A6ZGz7G/Pwbf9NqyzhQLnPuIOWiBNnP3T9y7+HkpjnFWaok2rlQUIZwQ/DH1HL/A
         oxQwj9n+FHcXyKz6U7gKYrxmDF0sBbPhIJWsD4AZSUPMLMFS5H9NezSaeuIKoR+t/cR9
         j24B/YPGIxn7FS2a2WeiPTIBjtlmETCz4lbGfqebFHtRQQPnGKd/NqiHSiq7SwcpBJ6C
         wr4CBP66vmI0byNcxkA8zk0WWQTNyEOZdrKesPC5xxKVSkFlOdU6Brnh6OAcWHRrY8+Q
         miBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XsjqZMs995RZPUKa7Q5/5AxsEU09PC6mvpt5UNfBSbc=;
        b=bQfVT2aO6V8v80FddW/i6ognl9+l6+X3B5GYjXEZHAVdFsCoLhUvf3HF8L7TMx6Tto
         Hy2Vy4ly/0aa4HI+nOSheD00Wqwi10OxnPEkaT+8FgErmHdtOfZect7Bs/0SRL5vI7sR
         KVaBLIfqlv4A+/SHux2waXuZtwhcR9W2Uyx60jKpu+vn66bO8VHQavKusemMLeBfU4Uu
         OTJp3YbhFZ84lFsfR331y9bybzQt0N+TZhSTh+Bb7MvGv/TfzAYQ57xjuLB9vjbRGRzt
         4pPsOOushf+BIye42f73jYjuBUpyA3jmqngV5H63ychGmX4TB49ytY1qCbv73XshWgD5
         JZZw==
X-Gm-Message-State: AOAM533xpNDQbbjjqkedtlAUjnYU8kf8D5wY9T0tO2kx9Jr0usn0qT9w
        qo3O1TVI77UNRTQRAoEYEx4HIA==
X-Google-Smtp-Source: ABdhPJz/C5pa381rdz8DJYFMT9aZLoQFlSY+j1NNlhImFGfHK3CslwnJ5bg+fZXHsJj/Tvobyo/H4w==
X-Received: by 2002:a54:460a:: with SMTP id p10mr25566936oip.47.1624981414258;
        Tue, 29 Jun 2021 08:43:34 -0700 (PDT)
Received: from yoga (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id m11sm3057128otp.29.2021.06.29.08.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 08:43:33 -0700 (PDT)
Date:   Tue, 29 Jun 2021 10:43:31 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        thara.gopinath@linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH] soc: qcom: aoss: Fix the out of bound usage of
 cooling_devs
Message-ID: <YNs/o7VVh+JnbxK9@yoga>
References: <20210628172741.16894-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628172741.16894-1-manivannan.sadhasivam@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 28 Jun 12:27 CDT 2021, Manivannan Sadhasivam wrote:

> In "qmp_cooling_devices_register", the count value is initially
> QMP_NUM_COOLING_RESOURCES, which is 2. Based on the initial count value,
> the memory for cooling_devs is allocated. Then while calling the
> "qmp_cooling_device_add" function, count value is post-incremented for
> each child node.
> 
> This makes the out of bound access to the cooling_dev array. Fix it by
> resetting the count value to zero before adding cooling devices.
> 
> While at it, let's also free the memory allocated to cooling_dev if no
> cooling device is found in DT and during unroll phase.
> 
> Cc: stable@vger.kernel.org # 5.4
> Fixes: 05589b30b21a ("soc: qcom: Extend AOSS QMP driver to support resources that are used to wake up the SoC.")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
> 
> Bjorn: I've just compile tested this patch.
> 
>  drivers/soc/qcom/qcom_aoss.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/soc/qcom/qcom_aoss.c b/drivers/soc/qcom/qcom_aoss.c
> index 934fcc4d2b05..98c665411768 100644
> --- a/drivers/soc/qcom/qcom_aoss.c
> +++ b/drivers/soc/qcom/qcom_aoss.c
> @@ -488,6 +488,7 @@ static int qmp_cooling_devices_register(struct qmp *qmp)
>  	if (!qmp->cooling_devs)
>  		return -ENOMEM;
>  
> +	count = 0;

This will address the immediate problem, which is that we assign
cooling_devs[2..] in this loop. But, like Matthias I don't think we
should use "count" as a constant in the first hunk and then reset it
and use it as a counter in the second hunk.

Frankly, I don't see why cooling_devs is dynamically allocated (without
being conditional on there being any children).


So, could you please make the cooling_devs an array of size
QMP_NUM_COOLING_RESOURCES, remove the dynamic allocation here, just
initialize count to 0 and add a check in the loop to generate an error
if count == QMP_NUM_COOLING_RESOURCES?

>  	for_each_available_child_of_node(np, child) {
>  		if (!of_find_property(child, "#cooling-cells", NULL))
>  			continue;
> @@ -497,12 +498,16 @@ static int qmp_cooling_devices_register(struct qmp *qmp)
>  			goto unroll;
>  	}
>  
> +	if (!count)
> +		devm_kfree(qmp->dev, qmp->cooling_devs);

I presume this is just an optimization, to get some memory back when
there's no cooling devices specified in DT.  I don't think this is
necessary and this made me want the static sizing of the array..

> +
>  	return 0;
>  
>  unroll:
>  	while (--count >= 0)
>  		thermal_cooling_device_unregister
>  			(qmp->cooling_devs[count].cdev);
> +	devm_kfree(qmp->dev, qmp->cooling_devs);

I don't remember why we don't fail probe() when this happens, seems like
the DT properties should be optional but the errors adding them should
be fatal. But that's a separate issue.

Regards,
Bjorn

>  
>  	return ret;
>  }
> -- 
> 2.25.1
> 
