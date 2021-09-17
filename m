Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E16E40F1B6
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 07:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244923AbhIQFoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 01:44:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237123AbhIQFoI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Sep 2021 01:44:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D7EE61019;
        Fri, 17 Sep 2021 05:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631857366;
        bh=SxmnxeSoE5SYqqll/HB5Dwbk6q8HnTxWVT6Tjg6Nxu8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=THh09TfN92sZdVYB9TYGu9+ZTxeY63c3kBZQYTumSleYY6l3Ua/rHSbKBL9dpuHVg
         wwYl9ROO97wSj1S3JLYhf4oeNr+jNOyVqLuMnV28xAe26kQhdbYDrRM1x559XCQKwT
         ukx++B/TSabTyDBMV8smmepOLw96TuEfBtB1F9Jw=
Date:   Fri, 17 Sep 2021 07:42:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Russ Weight <russell.h.weight@intel.com>
Cc:     mdf@kernel.org, linux-fpga@vger.kernel.org, trix@redhat.com,
        lgoncalv@redhat.com, yilun.xu@intel.com, hao.wu@intel.com,
        matthew.gerlach@intel.com, rc@silicom.dk, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] fpga: dfl: Avoid reads to AFU CSRs during enumeration
Message-ID: <YUQqxBaRHH/Hnk6z@kroah.com>
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

Nit, please keep this all on one line or our tools will complain about
it when we commit it to our trees :(

thanks,

greg k-h
