Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F1B338D08
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhCLM0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:26:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:59232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232136AbhCLM0c (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 07:26:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08EDB64F6C;
        Fri, 12 Mar 2021 12:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615551992;
        bh=r/iw/jptawwP1hioz1NioDibQqxcAuOcwfNFieCImFA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=irMHt1lLB+QK2FzD4KX8RFWXcowdxio+9mF/4kou+6S/g/aExAOzSa1taQeyeu96k
         5RIwIe07mHj5o6NIzy9GttKfdI5S3qQbGL26+NHIcODuOpuNFbwZ+2FMo+fKDs0wVE
         UsQSWRVDMVCyrFwkXOUl7R1367SfXPmqssPe1zGg=
Date:   Fri, 12 Mar 2021 13:26:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linus.walleij@linaro.org, mika.westerberg@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] gpio: pca953x: Set IRQ type when handle
 Intel Galileo Gen 2" failed to apply to 5.10-stable tree
Message-ID: <YEtd9ZAEbqu4Lssx@kroah.com>
References: <161548729112453@kroah.com>
 <YEta2IUohT5m28Oi@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YEta2IUohT5m28Oi@smile.fi.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 02:13:12PM +0200, Andy Shevchenko wrote:
> On Thu, Mar 11, 2021 at 07:28:11PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> This is strange. I have just cherry-picked it clean on top of v5.10.23.

Did you build it:

drivers/gpio/gpio-pca953x.c:119:40: error: ‘ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER’ undeclared here (not in a function)
  119 |  { "irq-gpios", &pca953x_irq_gpios, 1, ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER },
      |                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


:(
