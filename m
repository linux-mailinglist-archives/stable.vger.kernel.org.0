Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2229331CAC5
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 13:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhBPMy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 07:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbhBPMy0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 07:54:26 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F59AC06174A
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 04:53:44 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id e11so6948692qtg.6
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 04:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=woxF8BM/vVlc+kyoRboo8mnvdf0uku2iGRuKELotd8k=;
        b=LUbXEi6i2pwuM1pWPfk9+hxrUUMeqQxoSbrlNzY/6yhNk9dfRNu+nAqaXQoMy57t3W
         3tCARIk8k2RoY2soECesgvS4gY1ibS7+/JimZEVHufR2iPbq3Dh8yxAiMRZsojZ+xze8
         yKcQ8KeSyiKqlu4rs3CKT2LeGQN/3tbSANnx4HuweH+S4WHAjx55SJs04rjn6Pv1xdhR
         Fpdmc78pEonIE05vd0xJ8iU+vxBiKL3+47LVvFR/fe61J6gOpV0WyqOgdIFszJ1jOTkO
         RG/q5Xxz0LrKD4VSXjYN0thm2+LGMpG2lp18TKKPmhG2LPOZ5DWy+542/ROKi/2RoFl8
         Kj4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=woxF8BM/vVlc+kyoRboo8mnvdf0uku2iGRuKELotd8k=;
        b=Ep8OF4b226Cx/tSfyGiNr4KIpQIhlNL08RO5GSZSQ+KUJMWO5vp7WSGrNstdVelPLW
         Zixx7GGDV7YtHoLqLjdIjOujDELA9pza8gdjjiPd1/2yx1oqhtzFFxnEoq7WCOM2srqb
         bEdlP9TalRcX7jm1KWoTmxW6fzQqSqygyuwxFN+qc2HmAZEul2kNi2bp9zwauBegfusN
         hUYrQsQ5xA8WNmzEXQu4TrRMwXzQKM34nXM8WuRImp4QtEUBWnqOncqGUtlwqB/LCjsP
         0vBltjbdWndohJEbmcNsW7PfPH66aLUCcX0dampbqemFRf79gDzpZ8Vg9cK76lfctaov
         afVw==
X-Gm-Message-State: AOAM531+E3x8W7e6LVbGPrBqMF4OndZw1ccDVi751KzQLR8gHAnrtvhD
        ih1CzRFXGbkb39P77ztVpkVFDg==
X-Google-Smtp-Source: ABdhPJzkc+5g+GZq0JXL+4NNUnYUSXv09Q+4yCDVlR6kqHqT7TKNP1UM3hCqm17/394TIc+2XRFo3A==
X-Received: by 2002:ac8:538a:: with SMTP id x10mr17622726qtp.166.1613480023786;
        Tue, 16 Feb 2021 04:53:43 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id u7sm12554575qta.75.2021.02.16.04.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 04:53:42 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lBzrK-00993E-0h; Tue, 16 Feb 2021 08:53:42 -0400
Date:   Tue, 16 Feb 2021 08:53:42 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     peterhuewe@gmx.de, jarkko@kernel.org, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v4] tpm: fix reference counting for struct tpm_chip
Message-ID: <20210216125342.GU4718@ziepe.ca>
References: <1613435460-4377-1-git-send-email-LinoSanfilippo@gmx.de>
 <1613435460-4377-2-git-send-email-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613435460-4377-2-git-send-email-LinoSanfilippo@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 16, 2021 at 01:31:00AM +0100, Lino Sanfilippo wrote:
>  
> +static int tpm_add_tpm2_char_device(struct tpm_chip *chip)
> +{
> +	int rc;
> +
> +	device_initialize(&chip->devs);
> +	chip->devs.parent = chip->dev.parent;
> +	chip->devs.class = tpmrm_class;
> +
> +	rc = dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
> +	if (rc)
> +		goto out_put_devs;
> +	/*
> +	 * get extra reference on main device to hold on behalf of devs.
> +	 * This holds the chip structure while cdevs is in use. The
> +	 * corresponding put is in the tpm_devs_release.
> +	 */
> +	get_device(&chip->dev);
> +	chip->devs.release = tpm_devs_release;
> +	chip->devs.devt =
> +		MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
> +	cdev_init(&chip->cdevs, &tpmrm_fops);
> +	chip->cdevs.owner = THIS_MODULE;
> +
> +	rc = cdev_device_add(&chip->cdevs, &chip->devs);
> +	if (rc) {
> +		dev_err(&chip->devs,
> +			"unable to cdev_device_add() %s, major %d, minor %d, err=%d\n",
> +			dev_name(&chip->devs), MAJOR(chip->devs.devt),
> +			MINOR(chip->devs.devt), rc);
> +		goto out_put_devs;
> +	}
> +
> +	return 0;
> +
> +out_put_devs:
> +	put_device(&chip->devs);

I'd rather you organize this so chip->devs.release and the get_device
is always sent instead of having the possiblity for a put_device that
doesn't call release

Jason
