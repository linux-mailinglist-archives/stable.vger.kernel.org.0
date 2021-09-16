Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A12C40ED4A
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 00:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240978AbhIPWZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 18:25:56 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:34383 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbhIPWZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 18:25:55 -0400
Received: by mail-pl1-f171.google.com with SMTP id o8so4873592pll.1;
        Thu, 16 Sep 2021 15:24:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OGGvwLTy3palcoEN2dNH1AJwlmz0atE31sH3JI3RfZg=;
        b=PIBFRD5WzRRcCQlurz8ragOkpzob9jYWkp/PXI/wQ9M1i3iZCYQuzQFVs+s6zatnIZ
         nKAgSL+eQqEW8y7kHPnlhIzj81FYHulf6PwrDfhueLms0vMSnXnsP2s55c7qZ7pYE9J9
         OuklvH4tqebFUOiL7H507by2MJAKhljf7/zR7CKpUD7SFZi6+dBgev1kaPNZtEm0iMzf
         NUfpA5QPOg8YJSclKoMPHHOvWV6HXYeBay+0PQuRPP+1HHbQYt+B6KGUI7jCVoCqCfQ0
         3FCYLp90Uz6bwcmPDS8udlSnYZj1JiXZrGh8bmu1k6GfUMPnMudA4FPa3INjyqmOydyB
         RlLQ==
X-Gm-Message-State: AOAM532GG7jHXLezaPvScamxfX2PmY8qbhXaNkC72py3r+M9qJeyhnNA
        /00DLGFn9XdEyrqIFhv/Ctmb/eCA69M=
X-Google-Smtp-Source: ABdhPJzbdbu4Gq/g6wJbXxCuuQ7EN3iEXjEVylMMctSGZlFahM5zRs9uQxLO16y/Ro5/TTRHMqGzRw==
X-Received: by 2002:a17:902:d892:b0:138:abfd:ec7d with SMTP id b18-20020a170902d89200b00138abfdec7dmr6809708plz.15.1631831074275;
        Thu, 16 Sep 2021 15:24:34 -0700 (PDT)
Received: from localhost ([2601:647:5b00:6f70:be34:681b:b1e9:776f])
        by smtp.gmail.com with ESMTPSA id x65sm4044956pfb.29.2021.09.16.15.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 15:24:33 -0700 (PDT)
Date:   Thu, 16 Sep 2021 15:24:32 -0700
From:   Moritz Fischer <mdf@kernel.org>
To:     Russ Weight <russell.h.weight@intel.com>
Cc:     mdf@kernel.org, linux-fpga@vger.kernel.org, trix@redhat.com,
        lgoncalv@redhat.com, yilun.xu@intel.com, hao.wu@intel.com,
        matthew.gerlach@intel.com, rc@silicom.dk, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] fpga: dfl: Avoid reads to AFU CSRs during enumeration
Message-ID: <YUPEIDk7jMc/WpAQ@epycbox.lan>
References: <20210916210733.153388-1-russell.h.weight@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916210733.153388-1-russell.h.weight@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 16, 2021 at 02:07:33PM -0700, Russ Weight wrote:
> CSR address space for Accelerator Functional Units (AFU) is not available
> during the early Device Feature List (DFL) enumeration. Early access
> to this space results in invalid data and port errors. This change adds
> a condition to prevent an early read from the AFU CSR space.
> 
> Signed-off-by: Russ Weight <russell.h.weight@intel.com>
> 
> Fixes: 23bcda750558 ("fpga: dfl: expose feature revision from struct
> dfl_device")
Did you mean:

Fixes: 1604986c3e6b ("fpga: dfl: expose feature revision from struct dfl_device")

And for future please don't line break those, or we'll get yelled at :)

I can locally fix it up, no need to resubmit

- Moritz
