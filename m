Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E92A59FD36
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 16:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238818AbiHXOZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 10:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239175AbiHXOZy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 10:25:54 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E8A25C4A
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 07:25:52 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id 67so8453906pfv.2
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 07:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=SPRmeixtANGprxlqh/gVfzAE7+7y4vX0jc8n6DbL0NE=;
        b=y9BFz11+FV+njR3OB9AVA/Pr+JBW1R7I/7HpsB8R+jMKWMFxxp38tay24Y4AJW6xGC
         Urz97Khs6rq8/4pgjEId5GjE5XQxwtvbVf0DdeIs63JqwMV8VCig+YNtTXd2jYX+hC+j
         rhucvZBs4p/q5DL+SCb7aMPyTxhaRVPOEtRsnduBnOGzvfdMcNO63pMVPu8pTjc0a5Oj
         ea9E1IGkg7NJyNPm2NHI8mVkV1Jx2+vNmI6EkJFETYCh0Q0wzSSJffKlkGp3fOKAzRyr
         wy6+HMf+BLvzU1Av1NQ12fmpNWkCXVAPv02yiCGbJCVQOA1pkUGjw/++IuJLHfOF0ouJ
         Z0Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=SPRmeixtANGprxlqh/gVfzAE7+7y4vX0jc8n6DbL0NE=;
        b=Wji9CozsPXRTqRjTb/MDwQeBNcNwe8FL8kJ45q8H2iNyWE3rJMGmpu6iuflbuGf8mF
         hYUx//YrAAiYIhgqcaqOYoh2TxV9R4CfZkKivss/2Z9M8Le6H15Kv17oi1hl3zcvvYFS
         JpLW+aeVh+tPY5JCLA8JBup+tLtz02873brUWbFvLk9Aofi9OFP9gPLDQUAMTho4AAeN
         ec3qvqKVTkgTb0mJ32pkbEFmM5va5c9Ho8PzlIEOBXaF/ICLUR63pcRJVG/GbDF4qlv+
         B1U45C2aYNxYyum87D+Aq+g7i1TMDqHquT2fzYn14qguYnctX9sM4pHtg6sZgMhLCO76
         Kg1w==
X-Gm-Message-State: ACgBeo0bt1wWSWklkaTbngiFTFrZPFndyPpppojyYKVc9Uf9lKHlVs3d
        VT3UGCGWkQ1kXbZT/OyXJr1A
X-Google-Smtp-Source: AA6agR7bUL8jKs60nAv84fgJ6k1WPZq0rKFP9uagQJzNRNPqqFdAv2TklN0Aa/pU3mUMvfMmKWUcYA==
X-Received: by 2002:a63:e345:0:b0:429:fadb:7135 with SMTP id o5-20020a63e345000000b00429fadb7135mr23387825pgj.549.1661351151641;
        Wed, 24 Aug 2022 07:25:51 -0700 (PDT)
Received: from thinkpad ([117.207.24.28])
        by smtp.gmail.com with ESMTPSA id s184-20020a625ec1000000b0052e57ed8cdasm9248610pfb.55.2022.08.24.07.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 07:25:51 -0700 (PDT)
Date:   Wed, 24 Aug 2022 19:55:45 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     kishon@ti.com, lpieralisi@kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, mie@igel.co.jp, kw@linux.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/5] misc: pci_endpoint_test: Fix the return value of
 IOCTL
Message-ID: <20220824142545.GB4767@thinkpad>
References: <20220824123010.51763-1-manivannan.sadhasivam@linaro.org>
 <20220824123010.51763-2-manivannan.sadhasivam@linaro.org>
 <YwYc5kcdv+5RQDsK@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YwYc5kcdv+5RQDsK@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 24, 2022 at 02:43:18PM +0200, Greg KH wrote:
> On Wed, Aug 24, 2022 at 06:00:06PM +0530, Manivannan Sadhasivam wrote:
> > IOCTLs are supposed to return 0 for success and negative error codes for
> > failure. Currently, this driver is returning 0 for failure and 1 for
> > success, that's not correct. Hence, fix it!
> > 
> > Cc: stable@vger.kernel.org #5.10
> > Fixes: 2c156ac71c6b ("misc: Add host side PCI driver for PCI test function device")
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> 
> Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> > ---
> >  drivers/misc/pci_endpoint_test.c | 163 ++++++++++++++-----------------
> >  1 file changed, 76 insertions(+), 87 deletions(-)
> > 
> > diff --git a/drivers/misc/pci_endpoint_test.c b/drivers/misc/pci_endpoint_test.c
> > index 8f786a225dcf..a7d8ae9730f6 100644
> > --- a/drivers/misc/pci_endpoint_test.c
> > +++ b/drivers/misc/pci_endpoint_test.c
> > @@ -174,13 +174,12 @@ static void pci_endpoint_test_free_irq_vectors(struct pci_endpoint_test *test)
> >  	test->irq_type = IRQ_TYPE_UNDEFINED;
> >  }
> >  
> > -static bool pci_endpoint_test_alloc_irq_vectors(struct pci_endpoint_test *test,
> > +static int pci_endpoint_test_alloc_irq_vectors(struct pci_endpoint_test *test,
> >  						int type)
> >  {
> > -	int irq = -1;
> > +	int irq = -ENOSPC;
> 
> No need to set this if you:
> 
> >  	struct pci_dev *pdev = test->pdev;
> >  	struct device *dev = &pdev->dev;
> > -	bool res = true;
> >  
> >  	switch (type) {
> >  	case IRQ_TYPE_LEGACY:
> > @@ -202,15 +201,16 @@ static bool pci_endpoint_test_alloc_irq_vectors(struct pci_endpoint_test *test,
> >  		dev_err(dev, "Invalid IRQ type selected\n");
> 
> This should now return -EINVAL;
> 

ack

> 
> >  	}
> >  
> > +	test->irq_type = type;
> 
> Again, do not make a change to the kernel state if there is an error
> above.  That's wrong to do, and yes, the current code is incorrect,
> don't keep that bug here as well when it's so easy to fix up
> automatically.
> 

Okay. Will fix it in this patch itself.

Thanks,
Mani

> 
> I stopped reviewing here...
> 
> thanks,
> 
> greg k-h

-- 
மணிவண்ணன் சதாசிவம்
