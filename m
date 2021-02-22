Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70FB33213F8
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 11:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhBVKRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 05:17:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230224AbhBVKRj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 05:17:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A9A864E25;
        Mon, 22 Feb 2021 10:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613989017;
        bh=33TCNY6DybwqQA4egsX1ytYm44Tfux55ULKQ5Qbbk1Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SvzCMrOmJR5ETIxYUa5Kkz2GpBBSQtxYFhvf1dfx5hLEyruP1qd/ukeizg10JW1R/
         eENhp+7RXV/ke4+NDxM6AKOG7aq5OUB0zfAHiex/9Znwp+9sddZ/ExJsTGSDkR8wdg
         efJQU/OU03pyzB4IEe3TnjYdqYkl2UxL0CEPdlbI=
Date:   Mon, 22 Feb 2021 11:16:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zheng Yejian <zhengyejian1@huawei.com>
Cc:     stable@vger.kernel.org, judy.chenhui@huawei.com,
        zhangjinhao2@huawei.com, lee.jones@linaro.org, tglx@linutronix.de
Subject: Re: [PATCH 1/1] futex: Fix OWNER_DEAD fixup
Message-ID: <YDOElnMczO92t4Ee@kroah.com>
References: <20210222040618.2911498-1-zhengyejian1@huawei.com>
 <20210222040618.2911498-2-zhengyejian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222040618.2911498-2-zhengyejian1@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 12:06:18PM +0800, Zheng Yejian wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> commit a97cb0e7b3f4c6297fd857055ae8e895f402f501 upstream.

Why is this not also needed in 4.9.y?  If so, please also provide a
backport there so I can apply this one too.

thanks,

greg k-h
