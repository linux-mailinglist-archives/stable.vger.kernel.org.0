Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0588A47D182
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 13:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244818AbhLVMJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 07:09:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52112 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244817AbhLVMJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 07:09:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD5E5B81C11
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 12:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB566C36AE8;
        Wed, 22 Dec 2021 12:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640174946;
        bh=y/2cZjtbc+MFafTCfa1LKr12qou4q20bNrpeg0q/hJg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O/3lNRPayWSEoxV6qEP60LXmgrnnQyC6HqGeMI2xoSW0ZwmvJHFCHSD92LqoIcSKu
         kIuRZ+ewFtXeZ1FHrgTBFvsThPDLBYZhj65PxQEnwejIIHA/VtwoCqgRwn8JaVyqHp
         VB5tHDbYAZwn4dUkEJZhz8vGIsRCUOZ3rKqMnjNs=
Date:   Wed, 22 Dec 2021 13:08:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Ji-Ze Hong (Peter Hong)" <hpeter@gmail.com>
Cc:     stable@vger.kernel.org, peter_hong@fintek.com.tw,
        "Ji-Ze Hong (Peter Hong)" <hpeter+linux_kernel@gmail.com>
Subject: Re: [PATCH V1 1/1] serial: 8250_fintek: Fix garbled text for console
Message-ID: <YcMVJsREXW9iUBwp@kroah.com>
References: <20211221090420.19387-1-hpeter+linux_kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221090420.19387-1-hpeter+linux_kernel@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 21, 2021 at 05:04:20PM +0800, Ji-Ze Hong (Peter Hong) wrote:
> This patch is modified and fix conflict for kernel 5.4 from below patch.
> Commit 6c33ff728812 ("serial: 8250_fintek: Fix garbled text for console")

Now queued up, thanks.

greg k-h
