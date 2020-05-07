Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D80E1C9884
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 20:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgEGSAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 14:00:10 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42170 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbgEGSAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 14:00:10 -0400
Received: by mail-ot1-f66.google.com with SMTP id m18so5275836otq.9;
        Thu, 07 May 2020 11:00:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rz7afgEItK/X3b+OTl5u/Z9PROtzkZ7RI3h73BBOTWs=;
        b=C2onDBrrYi8JmgFgYHg2CRjzGOVTh4/msLriWssc985XNsbo4g+EHrTyjDPFKFRVop
         C6gDtRYtTqJNvQ+KwLqt6Ln2JmFORkbEihDL75+XCMHZHzEY5T4LzNezjUi9l7WLTZvu
         C2hx3KuiYEckX9W44UhOTxVaGJCNXjSxyOdzGs0LayCrDza2WcZDNBEn3nxPfCJQEftY
         WqpSmPpz0e0olcv6W+EEQ2ixqDdmS5rZb3BakDJcYfkh6iseuPxS67AgS7cU6DCgiGuY
         i6gnQZrqANyAq0dHeGrRGsurALLEuCBqxhZ6lhtQE3xQ2L8O5teRDW+Bx39E5Dybt3tV
         ztRw==
X-Gm-Message-State: AGi0PuYvvIdtMMVM0PaALm3LibwVZW3olEuB3Ba2Ek5qRR8Ww2q8EDJ6
        DvWzGLeZjttcomfTDwfY+w==
X-Google-Smtp-Source: APiQypJhQbkvsuSj/TDVG5iOrhMJrjOjHURTMckguIQgXNHjamctuKBe2GrLUNQpcXTcwNq7ZO+RZg==
X-Received: by 2002:a9d:730b:: with SMTP id e11mr12377163otk.9.1588874408974;
        Thu, 07 May 2020 11:00:08 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id u82sm1568783oia.35.2020.05.07.11.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 11:00:08 -0700 (PDT)
Received: (nullmailer pid 1908 invoked by uid 1000);
        Thu, 07 May 2020 18:00:07 -0000
Date:   Thu, 7 May 2020 13:00:07 -0500
From:   Rob Herring <robh@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Sham Muthayyan <smuthayy@codeaurora.org>,
        stable@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/11] PCI: qcom: add missing reset for ipq806x
Message-ID: <20200507180007.GA1801@bogus>
References: <20200430220619.3169-1-ansuelsmth@gmail.com>
 <20200430220619.3169-5-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430220619.3169-5-ansuelsmth@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri,  1 May 2020 00:06:11 +0200, Ansuel Smith wrote:
> Add missing ext reset used by ipq8064 SoC in PCIe qcom driver.
> 
> Fixes: 82a823833f4e PCI: qcom: Add Qualcomm PCIe controller driver
> Signed-off-by: Sham Muthayyan <smuthayy@codeaurora.org>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Cc: stable@vger.kernel.org # v4.5+
> ---
>  drivers/pci/controller/dwc/pcie-qcom.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
