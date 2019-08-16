Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73F6690699
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 19:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfHPRSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 13:18:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbfHPRSS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Aug 2019 13:18:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0587020665;
        Fri, 16 Aug 2019 17:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565975897;
        bh=WEtF9VhU9p8WQWvJOB9+6uhaUlrqFJaV4f1NK+HCR+M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XBB17i59JqSmrGqDLsCmK34M+P7Of4skDBtfJAl4PE2N9ZCR1F7syiLpKGExLgEnC
         WFyL76ZbYdOTOKxenzaGMUY7PZqwevN6cktiZ1Nc0lZVQcJUlbIqTrcUXpW7iWk/7C
         EeGgWUSud6A3BLwfKUo5+6zEiIiyEpt83KQpiO/M=
Date:   Fri, 16 Aug 2019 19:18:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     John Keeping <john@metanate.com>
Cc:     stable@vger.kernel.org
Subject: Re: Backport c289d6625237 ("Revert "pwm: Set class for exported
 channels in sysfs"") to 4.19
Message-ID: <20190816171815.GA20411@kroah.com>
References: <20190816165955.3555cfed.john@metanate.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816165955.3555cfed.john@metanate.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 16, 2019 at 04:59:55PM +0100, John Keeping wrote:
> Hi,
> 
> Please consider backporting commit c289d6625237 ("Revert "pwm: Set class
> for exported channels in sysfs"") from 4.20 to 4.19 stable (the original
> buggy commit was introduced in 4.16).
> 
> This one-line revert fixes an oops triggered by writing to sysfs.

Now queued up, thanks.

greg k-h
