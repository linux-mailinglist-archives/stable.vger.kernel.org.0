Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14E381A0F9E
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 16:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgDGOsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 10:48:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729060AbgDGOsu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 10:48:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAF8D20747;
        Tue,  7 Apr 2020 14:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586270929;
        bh=a/heueCsMj86xTmZbpNgbMIKaqfKaMRFRwOu5c0tZg0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HZXRdNNLA29mHJdOF1anvrZxRiInY5MCCBqtNZXtLI3hSPOlNxdNKzdMT+MWLk8sa
         YG5KfIGJVBZ2zCLUVkbxKFOwgaZfjKid2s14uw2z2qFi/hoTPzaKTtl9jg/f1DppCF
         5Bv7MtZdkXgROUZgwzliaZKV4hRfmVarageJrKhQ=
Date:   Tue, 7 Apr 2020 16:48:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Wolfram Sang <wsa@the-dreams.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Martin Volf <martin.volf.42@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.5 42/46] i2c: i801: Do not add ICH_RES_IO_SMI for the
 iTCO_wdt device
Message-ID: <20200407144845.GA889211@kroah.com>
References: <20200407101459.502593074@linuxfoundation.org>
 <20200407101503.858623897@linuxfoundation.org>
 <20200407111301.GA1928@ninjato>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407111301.GA1928@ninjato>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 07, 2020 at 01:13:01PM +0200, Wolfram Sang wrote:
> Hi Greg,
> 
> > Fixes: 9424693035a5 ("i2c: i801: Create iTCO device on newer Intel PCHs")
> > [wsa: complete fix needs all of http://patchwork.ozlabs.org/project/linux-i2c/list/?series=160959&state=*]
> 
> Did you pick these others, too, this time?

Ugh, no, I missed that.  Thanks for pointing it out, I have now queued
them up, and will push out -rc2 for these issues.

thanks,

greg k-h
