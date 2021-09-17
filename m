Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D84740FDD9
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 18:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbhIQQ1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 12:27:32 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:44576 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbhIQQ1b (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Sep 2021 12:27:31 -0400
Received: by mail-pg1-f169.google.com with SMTP id s11so10092449pgr.11;
        Fri, 17 Sep 2021 09:26:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=04r0zffyxbjDL8GKhoDXQgHq9Sxln6WjIJ+A4Y0oe+g=;
        b=XbKQcvcqpCF94P5sHVmkeBPSKgW+T+pTa7mAmxvnNTvWDTptQN/cjcWJhwpDBUZhfU
         QdnPi4Bej2QKjqRBTWnwUAzCfij98dVOdswfRIX6VAueiPxFrLl9m4bdqitFQ5HT2TWR
         G+TCH6FRZ/Xo6NxZklai2wlWi+29st21qcENPAUCQo1dZ1dbGvzVCQ29sfWMl4yDpnj5
         LFymrUpiQSiFAwaVvgOkg9y2rKe9QB5ZF1gSZKYdBwkt7UADnJ86WQ8AUZUlKhUwOl+c
         Ik0QhtUogK0EdNiaHFSNH2cGOCOmNFJGcByuSHSFPx4QNW4vISELqsUzhFYrmFcy7gnP
         Ou8Q==
X-Gm-Message-State: AOAM532KCrO01Bd1L7ZtULMo5Tnaw9oSgB/sdEiVSusoProH9ZInjpg8
        bjvS7wVwDrR53bPfTx0t13Q=
X-Google-Smtp-Source: ABdhPJzRhYlUnXj5NIfelkiH/V3TlcW5T+IIATLukxC+/TmbISYSEYFYrxLG8R9hTmsZ1TPZWaw6BA==
X-Received: by 2002:a62:55c2:0:b0:438:f9ea:ac46 with SMTP id j185-20020a6255c2000000b00438f9eaac46mr11993730pfb.25.1631895969401;
        Fri, 17 Sep 2021 09:26:09 -0700 (PDT)
Received: from localhost ([2601:647:5b00:6f70:be34:681b:b1e9:776f])
        by smtp.gmail.com with ESMTPSA id g19sm10847361pjl.25.2021.09.17.09.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 09:26:08 -0700 (PDT)
Date:   Fri, 17 Sep 2021 09:26:07 -0700
From:   Moritz Fischer <mdf@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Russ Weight <russell.h.weight@intel.com>, mdf@kernel.org,
        linux-fpga@vger.kernel.org, trix@redhat.com, lgoncalv@redhat.com,
        yilun.xu@intel.com, hao.wu@intel.com, matthew.gerlach@intel.com,
        rc@silicom.dk, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] fpga: dfl: Avoid reads to AFU CSRs during enumeration
Message-ID: <YUTBn+klY2i0QNgn@epycbox.lan>
References: <20210916210733.153388-1-russell.h.weight@intel.com>
 <YUQqxBaRHH/Hnk6z@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUQqxBaRHH/Hnk6z@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 17, 2021 at 07:42:28AM +0200, Greg KH wrote:
> On Thu, Sep 16, 2021 at 02:07:33PM -0700, Russ Weight wrote:
> > CSR address space for Accelerator Functional Units (AFU) is not available
> > during the early Device Feature List (DFL) enumeration. Early access
> > to this space results in invalid data and port errors. This change adds
> > a condition to prevent an early read from the AFU CSR space.
> > 
> > Signed-off-by: Russ Weight <russell.h.weight@intel.com>
> > 
> > Fixes: 23bcda750558 ("fpga: dfl: expose feature revision from struct
> > dfl_device")
> 
> Nit, please keep this all on one line or our tools will complain about
> it when we commit it to our trees :(

I had caught that and fixed it when applying :)

Thanks,
Moritz
