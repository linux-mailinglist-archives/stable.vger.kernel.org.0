Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D65EF1FAD
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 21:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbfKFUXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 15:23:55 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34448 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727550AbfKFUXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 15:23:55 -0500
Received: by mail-pf1-f195.google.com with SMTP id n13so8070703pff.1
        for <stable@vger.kernel.org>; Wed, 06 Nov 2019 12:23:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=y3ErlOr8zz0pSn0wPZ07CUTX0RGvOBpRtPLCuFwaNrU=;
        b=YC4Z2dHC4F15YVKn4yT41EJQgMIWuL7hjQk/OTXa3g0MxmASCu11F86facfUqg8IVP
         H74cF+N1vvF5qMKFjmYP/NyKznq/EYetZgGS6zVJbgY1dq/+fq8p9BCFpLgDY21xH6Fb
         ZF/c657P0QvNsknVIoB/RiiAskAZw8n8Aq8cRFXGQTepkqAifg9k8nR5fdGYuGUgUx6+
         4XvGXYfoPd0lD6/8+1TpiijrbwEPhh1HVGRAe18sBeWRhwhIdywCsQE6zJIAM+uGLl6o
         yJo1tYhCreBBrUBwKunybHKS/ir9sY/sAXJ37HcoRlpzhHLnq321EmAL3WxZbE3Pe/n8
         ENHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=y3ErlOr8zz0pSn0wPZ07CUTX0RGvOBpRtPLCuFwaNrU=;
        b=WvhaK85v7tZhkEfF5tHm9EjKZKmqXiI4IbOaIgH7H5si+Bj8a1v9iO3sB/nVrBDzNq
         sZNdOMrptE1W1d9onYhJAHFaiSr7FlMWRBcgD98whNja9FanHwDbQanHAMFXj6uekcRj
         +CafJJNJZDle4atIyotxdkDrgor7poW/O8VlBVlQD6UxCvyQMG8zBMS2S/et4dNjaICX
         Z9KQT81H6qthITxgmgiOTjxUI2YjZBA9Dfqr6o0B/StxpDlguD7Uus/IRYjRrwJo6KuY
         YLwzf2CgjvOoYdZToHiZ20naLLlQ5DfMeD2nI4JjRWyjsa9BKafCN99qk7zD16D4Hd65
         pZWw==
X-Gm-Message-State: APjAAAUr6kNTa9YUCtgUZdDYwIEENFTvhpj57MTnFpWDHBQzt7WQKNQc
        ohPkp3wvVxXlN0zlgGKW3RfKEw==
X-Google-Smtp-Source: APXvYqyYQ890RT5KorI4LSOMnM/qz6CZ76JmLNXzmgX+AVICrIQOgPg99MRUcCBfttjdwh5qqH78Sw==
X-Received: by 2002:a65:47cd:: with SMTP id f13mr5023056pgs.356.1573071834146;
        Wed, 06 Nov 2019 12:23:54 -0800 (PST)
Received: from minitux (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id p9sm27469818pfq.40.2019.11.06.12.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 12:23:53 -0800 (PST)
Date:   Wed, 6 Nov 2019 12:23:51 -0800
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Stanimir Varbanov <svarbanov@mm-sol.com>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] PCI: qcom: Fix the fixup of PCI_VENDOR_ID_QCOM
Message-ID: <20191106202351.GE36595@minitux>
References: <20191102002420.4091061-1-bjorn.andersson@linaro.org>
 <f1e89dcc-4d5f-cc1f-8036-dcb062645cb0@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1e89dcc-4d5f-cc1f-8036-dcb062645cb0@mm-sol.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 04 Nov 05:00 PST 2019, Stanimir Varbanov wrote:

> Hi Bjorn,
> 
> Thanks for the fix!
> 
> On 11/2/19 2:24 AM, Bjorn Andersson wrote:
> > There exists non-bridge PCIe devices with PCI_VENDOR_ID_QCOM, so limit
> > the fixup to only affect the PCIe 2.0 (0x106) and PCIe 3.0 (0x107)
> > bridges.
> 
> Are you sure that this will not break ops_1_0_0 (Qcom IP rev.: 1.0.0
> Synopsys IP rev.: 4.11a) i.e. apq8084 ?
> 

I am not, I've only tested this on db820c and db845c. Unfortunately I'm
unable to find a branch with the necessary dts snippets to test it. Do
you perhaps have a branch somewhere?

Regards,
Bjorn

> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> > ---
> >  drivers/pci/controller/dwc/pcie-qcom.c | 3 ++-
> >  include/linux/pci_ids.h                | 2 ++
> >  2 files changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
> > index 35f4980480bb..b91abf4d4905 100644
> > --- a/drivers/pci/controller/dwc/pcie-qcom.c
> > +++ b/drivers/pci/controller/dwc/pcie-qcom.c
> > @@ -1441,7 +1441,8 @@ static void qcom_fixup_class(struct pci_dev *dev)
> >  {
> >  	dev->class = PCI_CLASS_BRIDGE_PCI << 8;
> >  }
> > -DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, PCI_ANY_ID, qcom_fixup_class);
> > +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, PCIE_DEVICE_ID_QCOM_PCIE20, qcom_fixup_class);
> > +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_QCOM, PCIE_DEVICE_ID_QCOM_PCIE30, qcom_fixup_class);
> >  
> >  static struct platform_driver qcom_pcie_driver = {
> >  	.probe = qcom_pcie_probe,
> > diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> > index 21a572469a4e..3d0724ee4d2f 100644
> > --- a/include/linux/pci_ids.h
> > +++ b/include/linux/pci_ids.h
> > @@ -2413,6 +2413,8 @@
> >  #define PCI_VENDOR_ID_LENOVO		0x17aa
> >  
> >  #define PCI_VENDOR_ID_QCOM		0x17cb
> > +#define PCIE_DEVICE_ID_QCOM_PCIE20	0x0106
> > +#define PCIE_DEVICE_ID_QCOM_PCIE30	0x0107
> >  
> >  #define PCI_VENDOR_ID_CDNS		0x17cd
> >  
> > 
> 
> -- 
> regards,
> Stan
