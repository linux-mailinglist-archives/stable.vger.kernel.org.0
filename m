Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4DA53118D7
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 03:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbhBFCr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 21:47:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbhBFCnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 21:43:03 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8F6C08EE78
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 16:39:08 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id t63so8864412qkc.1
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 16:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ciK0YLExn9NtmT/ujAAKYIWsGrGZcSbTE1owRjIeMgc=;
        b=pAXnADSm+QJgLf+gcgZ5W2l/zhC6+B04AFwPHQBJz4JLGYPoDsNIc13ulxR0xi+VgA
         5wdx+D1TXUPWmcbVeRB7X2AEER4H3vM5FxTtksbE8k/VgrgHLbfzEoVcvwWH/9UNzKYC
         TOJHSec6umfecHTksMS0z7VcT0CXSWQZgehc3S4IfnhxK8aBgnifHSZuAt+8xKVErlMg
         /phlaeoskSC1TmERgVjIE5naLkqyz8swVpMLGpzT/aQYhQTzwz/Bnpq8jeGVmQN2QVcn
         718ES1nRFUVQxTCJDrWdwIkh3qAiApux5QFXfJC32k62ZjWBdEwBy5z3X4Y49fmwbZ+I
         RCvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ciK0YLExn9NtmT/ujAAKYIWsGrGZcSbTE1owRjIeMgc=;
        b=LLQGhftP/fOSLjnrjfO9zSMaHIKBp9ZN96q9Z+7dhdvN4ExhlCT8AJV2d9iMHoTonI
         VB9RCfsn7tyzgs70AkFliQ7cZ3wyBkvpPVCDPDfyibT+K4DWVnIjXxnkWHgleI6impxm
         GVaJTi7A4SSWuXJhZpZzYQhAGOvstbrJXVmzLQgAHoRdHML3wAkSBXeVAyXvcK3qLY+p
         wSU1bcFN3wNabw1d09ScZyPFOWzGQ9U7PvtH/jrAowXTT9sKM3gmVZCgrI8jzH5cDSxG
         2ne7Ua8xAoOY5BOlABpbdDV6xrG/z7ZCwDsm3j1vdixRIrQhIlT19SM3MdT6zyiFILOY
         +D3A==
X-Gm-Message-State: AOAM531OmzsDwwC5hDjlToGiIk14kMCAsvgPomLtk0TSkPTu1+NDdID8
        mWtPT8ZZtoRfqaHLgPKiIg8u+Q==
X-Google-Smtp-Source: ABdhPJwjSuDbU/cvRcr0S0nr4WF6ca/O+BI3ierMwVBkkMT8QdKr0frxBPIeCSqB/NMdwwQ0+hIPFg==
X-Received: by 2002:a37:9c14:: with SMTP id f20mr7383034qke.82.1612571947693;
        Fri, 05 Feb 2021 16:39:07 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id 199sm11376368qkm.126.2021.02.05.16.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 16:39:06 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1l8Bcw-004BCu-4L; Fri, 05 Feb 2021 20:39:06 -0400
Date:   Fri, 5 Feb 2021 20:39:06 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     Lino Sanfilippo <l.sanfilippo@kunbus.com>, peterhuewe@gmx.de,
        jarkko@kernel.org, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] tpm: fix reference counting for struct tpm_chip
Message-ID: <20210206003906.GR4718@ziepe.ca>
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
 <1612482643-11796-2-git-send-email-LinoSanfilippo@gmx.de>
 <20210205130511.GI4718@ziepe.ca>
 <3b821bf9-0f54-3473-d934-61c0c29f8957@kunbus.com>
 <20210205151511.GM4718@ziepe.ca>
 <f6e5dd7d-30df-26d9-c712-677c127a8026@kunbus.com>
 <20210205155808.GO4718@ziepe.ca>
 <db7c90c3-d86a-65c9-81a2-be1527b47e11@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db7c90c3-d86a-65c9-81a2-be1527b47e11@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 10:50:02PM +0100, Lino Sanfilippo wrote:
> On 05.02.21 at 16:58, Jason Gunthorpe wrote:
> eference in the first place).
> >
> > No, they are all chained together because they are all in the same
> > struct:
> >
> > struct tpm_chip {
> > 	struct device dev;
> > 	struct device devs;
> > 	struct cdev cdev;
> > 	struct cdev cdevs;
> >
> > dev holds the refcount on memory, when it goes 0 the whole thing is
> > kfreed.
> >
> > The rule is dev's refcount can't go to zero while any other refcount
> > is != 0.
> >
> > For instance devs holds a get on dev that is put back only when devs
> > goes to 0:
> >
> > static void tpm_devs_release(struct device *dev)
> > {
> > 	struct tpm_chip *chip = container_of(dev, struct tpm_chip, devs);
> >
> > 	/* release the master device reference */
> > 	put_device(&chip->dev);
> > }
> >
> > Both cdev elements do something similar inside the cdev layer.
> 
> Well this chaining is exactly what does not work nowadays and what the patch is supposed
> to fix: currently we dont ever take the extra ref (not even in TPM 2 case, note that
> TPM_CHIP_FLAG_TMP2 is never set), so
> 
> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> -		get_device(&chip->dev);
> +	get_device(&chip->dev);

Oh, hah, yes that is busted up. The patch sketch I sent to James is
the right way to handle it, feel free to take it up

> and tpm_devs_release() is never called, since there is nothing that ever puts devs, so

Yes, that is a pre-existing memory leak

> The race with only get_device()/putdevice() in tpm_common_open()/tpm_common_release() is:

The refcount handling is busted up and not working the way it is
designed, when that is fixed there is no race.

Jason
