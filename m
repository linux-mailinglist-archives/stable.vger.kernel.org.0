Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A80B4A304F
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 08:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbfH3G75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Aug 2019 02:59:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40632 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbfH3G75 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Aug 2019 02:59:57 -0400
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 507D17FDF5
        for <stable@vger.kernel.org>; Fri, 30 Aug 2019 06:59:57 +0000 (UTC)
Received: by mail-lf1-f72.google.com with SMTP id n18so108252lfe.22
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 23:59:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Vpmsa9DBbnVa1aZPRQX/dxqKBSahl9/K5Vqaz/obSfY=;
        b=F0uHH+i+oUCTmpHtoR4g+pGHIOeKR/HnkM1WkdluRs8Ha3RC8MjDam4MwZh7Qsma9v
         J4aVu9TcHly86vO1Ep/duKfrvAlAoFUQDDv/7MVweV/hLhkFKqvXp2yMIKmRLeN8n9pn
         jfjxGoNbnkS9MI4u3T7pG+oSglOg3Mlp6K3S/72Q7uZ7I49Pr4KOUT5QlnssfHjlt+qG
         BQe5Zets4RTZcmqDa71imXaQJqMSEmCN3YZtoZYdPJ4xOUOqpWi7T7kXs9USuDsiIqF3
         ZZ3ybD0qabAGzxgsnJ9IX7M27JbbzUjpTlLBZYS1u9916OCGJ02c8YpOJgdD09ymkwk1
         SSfQ==
X-Gm-Message-State: APjAAAVuW3qEwnk0RpclIjNtt2Kyqso4SinbfSjg4HTRXfJebbUfuLIN
        CYqz1Tc545FWSShDuBBgJESQYtSCZwbQKA4vueeVwCN5MvQ47V5i5tFrKZ0UoNH9ergBCCG19o/
        3Kj+BcLucy5yDPm5q
X-Received: by 2002:a19:f819:: with SMTP id a25mr477709lff.45.1567148395361;
        Thu, 29 Aug 2019 23:59:55 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz3Q1kEtSKNAinQdyEd8yGfO5Gq60or2rKRFfh9lX1GyLM7KCT5KLuaxjNYHXpnigsOWdKjfw==
X-Received: by 2002:a19:f819:: with SMTP id a25mr477698lff.45.1567148395141;
        Thu, 29 Aug 2019 23:59:55 -0700 (PDT)
Received: from localhost ([146.158.73.239])
        by smtp.gmail.com with ESMTPSA id x21sm694278ljj.57.2019.08.29.23.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 23:59:54 -0700 (PDT)
Date:   Fri, 30 Aug 2019 08:59:53 +0200
From:   Oleksandr Natalenko <oleksandr@redhat.com>
To:     stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Backport 2a92b08b1855 ("mt76: usb: fix rx A-MSDU support")
Message-ID: <20190830065953.nsye4cq2eisyqcko@butterfly.localdomain>
References: <20190815090359.eevqqk3vt4dcrw3k@butterfly.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190815090359.eevqqk3vt4dcrw3k@butterfly.localdomain>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 15, 2019 at 11:03:59AM +0200, Oleksandr Natalenko wrote:
> I'd like to get 2a92b08b1855 squeezed into a stable tree since it fixes
> the following splat in the kernel log when using an MTK-based Wi-Fi
> access point:
> 
> [135577.311588] usb 1-3: rx data too big 2044
> [135577.311689] usb 1-3: rx data too big 2044
> [135578.166351] usb 1-3: rx data too big 2044
> 
> See also: https://bugzilla.kernel.org/show_bug.cgi?id=203789
> 
> The patch applies to the v5.2.x series without conficts.
> 
> Lorenzo, are you fine with this?

Gentle ping.

-- 
  Best regards,
    Oleksandr Natalenko (post-factum)
    Senior Software Maintenance Engineer
