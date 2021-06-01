Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F9A39727B
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 13:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbhFALhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 07:37:51 -0400
Received: from mail-lf1-f42.google.com ([209.85.167.42]:40888 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbhFALhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 07:37:50 -0400
Received: by mail-lf1-f42.google.com with SMTP id w33so21245295lfu.7;
        Tue, 01 Jun 2021 04:36:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=TdRFtnbH0ExCTvn03PErotHkDvtJ1EFwUXPvWflLmSA=;
        b=f3UdWuzj9KjTDPmRX8t9LiSKkWHgzTsYJcsw83JZJHX43NhTB+LPXJjueLFrD2aBut
         jwAJhZcO3LA4azGo+rsL1xzkgpHaw98/XEqREK0BXWSM5rI9+avFFwMT8eb0HlKxDnXP
         1au3TAlV/rHgIcAeghSnBaixFpk23Ida6w1UhqOXtCTU1e59nZyvbgJ1syxPA0IyNWTF
         1pdvqCl04rZkqt+xQ27AwklcEojDTtfFNaEaAZmp7cDt+PvEk8YOayfYdRd4Wkfg7yeq
         WL3DSPu6gpogCLbisf+1cg1EaXgsr/nboFKqQFKR2eh2vW1uKvtj2Dg+TDhhksw9IqMf
         J9Mw==
X-Gm-Message-State: AOAM5314xJTTqfoUASRUEYIc8weKKHdDQUsQjU6XESndjnNlQdjTDWOd
        zhvtlJGwplCTRSWHstM+pT4=
X-Google-Smtp-Source: ABdhPJzOmeE5k1O/Gc2ewTq3aN0xfNQyQMnH8JWvmfaAwYEGfoyWQHNKFkWwabuS5aioe2wLgqODFQ==
X-Received: by 2002:a19:c208:: with SMTP id l8mr18733975lfc.534.1622547366292;
        Tue, 01 Jun 2021 04:36:06 -0700 (PDT)
Received: from rocinante.localdomain ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id e8sm1249324ljj.28.2021.06.01.04.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 04:36:05 -0700 (PDT)
Date:   Tue, 1 Jun 2021 13:36:04 +0200
From:   Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, linux-pci@vger.kernel.org,
        =?utf-8?B?UsO2dHRp?= 
        <espressobinboardarmbiantempmailaddress@posteo.de>,
        Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] PCI: Add Max Payload Size quirk for ASMedia ASM1062 SATA
 controller
Message-ID: <20210601113604.GB189305@rocinante.localdomain>
References: <20210317115924.31885-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210317115924.31885-1-kabel@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marek,

[...]
> +/*
> + * For some reason DECLARE_PCI_FIXUP_HEADER does not work with pci-aardvark
> + * controller. We have to use DECLARE_PCI_FIXUP_EARLY.
> + */
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ASMEDIA, 0x0612, fixup_mpss_256);
[...]

Thank you for fixing this and also for filling the bug report on
Bugzilla!  Appreciated.

Reviewed-by: Krzysztof Wilczyński <kw@linux.com>

	Krzysztof
