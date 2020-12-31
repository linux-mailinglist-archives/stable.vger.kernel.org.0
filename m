Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D16C2E7D57
	for <lists+stable@lfdr.de>; Thu, 31 Dec 2020 01:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgLaAQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 19:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgLaAQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 19:16:37 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A27BC061575
        for <stable@vger.kernel.org>; Wed, 30 Dec 2020 16:15:57 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id i5so12235803pgo.1
        for <stable@vger.kernel.org>; Wed, 30 Dec 2020 16:15:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxace-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=au5deversDUhjJZ37Ftd3WtVvchDXjoeRWjmb+KgOHU=;
        b=MhWOQFZsHAE0uuFnYbB/Jc8/42rNUcbi/V4UxJV83oD22AQ+STPyLsxxBUt9LSBWuM
         FiiC6HSt0I3g688dwrqFrS9xKAS1mKVlI6cgloEQg4yCBCQLm6ui3hqiLfXYOZDQjN/c
         yTGw1jWAMEKEVCQNRT0ZsV4ES9Gxz2o6MX03p4k0xdRw88kqJLS5RVQuaVrp2cUQjavc
         IqcpA3rfmXAVgK2akbcJ+3xDoJPULOv/4EtSlbJ9NkqCFgPO1OACDhkN+azVbi3QkVw+
         1EJUqE//dWefJfE996DoJfPls6PQUy2Ym3Ic6dSPDorr/9f/pG5KIBhHH2x75WAtLWyo
         ttEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=au5deversDUhjJZ37Ftd3WtVvchDXjoeRWjmb+KgOHU=;
        b=HiHYmMDSZYW6CmWo5g5UtkyFaZ0vavH7YKmA+t3Xyfl3tp5Nd+A6XcXPT1ENw/7rW6
         mQHH6sr4B+n9nHcH82phdhO3dRFgVfWv/oPq6EjO/FUNPlhi9FY+sme3bR7xkSmhc0l1
         5Uequ3PhJKbJKe9H6h5u+W652wc+vSGyTusEpyg7odKmfM0RymQ3ScsjutQMNGi5Duf1
         0l+F0lGyAluhgMs7uXpfOaufzop71cmDgysvh6PMHZA8QhQqG3bfCJDFDVwtAjsrpk4x
         XXccEr7T1Fx0CXKmzQz2WH7xemBpfC/dBduVuGo07vgt09tfhIcEJTnlD5QfwRjeuEP5
         kqAA==
X-Gm-Message-State: AOAM530INNvyzqRHf5KtzJnrpeI2evb+SmEfBzTcdR+VtWpsGTnV6L9G
        uvVUZH9myxjj2OWBlYyFnHIwuA==
X-Google-Smtp-Source: ABdhPJwcB47Au0SCL2bya0Ek9wpMqDiNDQIFM8LUop6tXifOpwCBlrKfIqN2Er69MYwJ7KdsZOMWEw==
X-Received: by 2002:a63:da50:: with SMTP id l16mr38832354pgj.447.1609373757086;
        Wed, 30 Dec 2020 16:15:57 -0800 (PST)
Received: from home.linuxace.com (cpe-23-243-7-246.socal.res.rr.com. [23.243.7.246])
        by smtp.gmail.com with ESMTPSA id h18sm44326353pfo.172.2020.12.30.16.15.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 16:15:56 -0800 (PST)
Date:   Wed, 30 Dec 2020 16:15:53 -0800
From:   Phil Oester <kernel@linuxace.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        hch@infradead.org, Arnd Bergmann <arnd@arndb.de>,
        stable@vger.kernel.org, Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] scsi: megaraid_sas: check user-provided offsets
Message-ID: <20201231001553.GB16945@home.linuxace.com>
References: <20200908213715.3553098-1-arnd@arndb.de>
 <20200908213715.3553098-2-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908213715.3553098-2-arnd@arndb.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 08, 2020 at 11:36:22PM +0200, Arnd Bergmann wrote:
> It sounds unwise to let user space pass an unchecked 32-bit
> offset into a kernel structure in an ioctl. This is an unsigned
> variable, so checking the upper bound for the size of the structure
> it points into is sufficient to avoid data corruption, but as
> the pointer might also be unaligned, it has to be written carefully
> as well.
> 
> While I stumbled over this problem by reading the code, I did not
> continue checking the function for further problems like it.

Sorry for replying to an ancient thread, but this patch just recently
made it into 5.10.3 and has caused unintended consequences.  On Dell
servers with PERC RAID controllers, booting 5.10.3+ with this patch
causes a PCI parity error.  Specifically:

Event Message: A PCI parity error was detected on a component at bus 0 device 5 function 0.
Severity: Critical
Message ID: PCI1308

I reverted this single patch and the errors went away.

Thoughts?

Phil Oester
