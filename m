Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5F010F7DA
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 07:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfLCGf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 01:35:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:49790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbfLCGf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 01:35:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA6DF206DF;
        Tue,  3 Dec 2019 06:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575354926;
        bh=tfQwQMStmLv/uqKyHBc+f6dzo9IHOr6b1jDEVdf+aio=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ayJVAXAWvH0yTMLSxgNEJYES6BI05nLsWjKObnj7fljpbXqXidJWkcGUAQJJEF9PD
         2WjdJ3TsXTkg8HRk9qGbAyMtRGIUfKk2fQhtG09Bo1uN9FO8ClVtdfmUcPlRgHR/Yh
         ZXbIjZyStJfAiTz8QrU4FN9ZDugX5VVprKpaIF74=
Date:   Tue, 3 Dec 2019 07:35:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     madhuparnabhowmik04@gmail.com
Cc:     stable@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: Re: Boot Test: Linux 5.4.1
Message-ID: <20191203063521.GA1771875@kroah.com>
References: <20191202221310.6189-1-madhuparnabhowmik04@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202221310.6189-1-madhuparnabhowmik04@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 03, 2019 at 03:43:10AM +0530, madhuparnabhowmik04@gmail.com wrote:
> Hi,
> 
> I boot tested Linux 5.4.1, everything seems okay except the following error:
> 
> [    0.275509] platform MSFT0101:00: failed to claim resource 1: [mem 0xfed40000-0xfed40fff]
> [    0.275515] acpi MSFT0101:00: platform device creation failed: -16

Is this new compared to 5.4.0?  Compared to 5.3.y?

thanks,

greg k-h
