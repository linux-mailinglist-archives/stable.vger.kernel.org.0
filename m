Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225B31EB0A7
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 23:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbgFAVFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 17:05:03 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:38967 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727875AbgFAVFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 17:05:02 -0400
Received: by mail-il1-f194.google.com with SMTP id p5so9713948ile.6;
        Mon, 01 Jun 2020 14:05:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1D03z/IZiep6CCx+5QotpyPhtXoURIt0kBSnTWktssg=;
        b=OTzLSgeCeFuqp3fAkh2lFKoQ3RjM0U6DYdXNFlKR1KCAXW8k2tGx5TZNJja5K8a3QQ
         cczHHRAAeIQrvxBccv6ezHb3GFCo0eu7GFVM2HE64zYLI7rv+kB1njGgykri5/wKX5Lo
         b90fQ5orMptaj9TBUJx9zm+DmEixAWoU4ppPbO928sFltE7rFWS+YWnwA6x9aqQJDVFM
         gfmIdfr42mnCscSJFgSHcax1nEi2GBX2bEHgNjTe9iANAaxjDESOrbEoXw7Ty+haXVfn
         MxA1mu6c91wgqM79UR4AbV/dYeMEoqAczKEinObcprsZeMlR0YE3ZiwmR0t+4ELQ6aXr
         0OwA==
X-Gm-Message-State: AOAM5304GzgeWXGNK3KcDMuCmE5S97i8Y3uAG88YQ0Z4TcIHzx39TMt2
        HJKt3Z4kiX5T0RqP7aR00sUDJBI=
X-Google-Smtp-Source: ABdhPJyhibY5+F1D2yq6TqvtALrrKnldo+kKoSRNQDLKJHHZNnvJAkqaVxxkd7KtpDYEmMdv5vLRwQ==
X-Received: by 2002:a92:c948:: with SMTP id i8mr23308936ilq.258.1591045500514;
        Mon, 01 Jun 2020 14:05:00 -0700 (PDT)
Received: from xps15 ([64.188.179.251])
        by smtp.gmail.com with ESMTPSA id 199sm391643ilb.11.2020.06.01.14.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 14:04:59 -0700 (PDT)
Received: (nullmailer pid 1494309 invoked by uid 1000);
        Mon, 01 Jun 2020 21:04:58 -0000
Date:   Mon, 1 Jun 2020 15:04:58 -0600
From:   Rob Herring <robh@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     linux-pci@vger.kernel.org, stable@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        linux-arm-msm@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v4 07/10] PCI: qcom: Define some PARF params needed for
 ipq8064 SoC
Message-ID: <20200601210458.GA1494255@bogus>
References: <20200514200712.12232-1-ansuelsmth@gmail.com>
 <20200514200712.12232-8-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514200712.12232-8-ansuelsmth@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 14 May 2020 22:07:08 +0200, Ansuel Smith wrote:
> Set some specific value for Tx De-Emphasis, Tx Swing and Rx equalization
> needed on some ipq8064 based device (Netgear R7800 for example). Without
> this the system locks on kernel load.
> 
> Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Cc: stable@vger.kernel.org # v4.5+
> ---
>  drivers/pci/controller/dwc/pcie-qcom.c | 27 ++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
