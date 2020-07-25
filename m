Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A248A22D695
	for <lists+stable@lfdr.de>; Sat, 25 Jul 2020 12:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgGYKHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jul 2020 06:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726572AbgGYKHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Jul 2020 06:07:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3EA3206D7;
        Sat, 25 Jul 2020 10:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595671620;
        bh=DXKTp7F9hVX/ZMZ3cMvlM+waZARTWo/ANSvb7sYnEho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=csoeNhZKhfy/PaKNHDzhb6fewTblIs59HKYmONeMkW7H74jifgwJGAr6lPRX4Vxlw
         Z7+gvZk8JV6ESWik0r9XZf9nTKM+BHkr7Qjq2D4AQsu3HRqL+SabERQUdkBlDdSpup
         e4N/tbzlVOUSYcVU4+kHmshhXryc9aBAsUBwgFMM=
Date:   Sat, 25 Jul 2020 12:07:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     stable@vger.kernel.org, Scott Branden <scott.branden@broadcom.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Jessica Yu <jeyu@kernel.org>, SeongJae Park <sjpark@amazon.de>,
        KP Singh <kpsingh@chromium.org>, linux-efi@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 03/19] firmware_loader: EFI firmware loader must
 handle pre-allocated buffer
Message-ID: <20200725100700.GB1073708@kroah.com>
References: <20200724213640.389191-1-keescook@chromium.org>
 <20200724213640.389191-4-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724213640.389191-4-keescook@chromium.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 24, 2020 at 02:36:24PM -0700, Kees Cook wrote:
> The EFI platform firmware fallback would clobber any pre-allocated
> buffers. Instead, correctly refuse to reallocate when too small (as
> already done in the sysfs fallback), or perform allocation normally
> when needed.
> 
> Fixes: e4c2c0ff00ec ("firmware: Add new platform fallback mechanism and firm ware_request_platform()")

"firmware_request_platform()" :)

