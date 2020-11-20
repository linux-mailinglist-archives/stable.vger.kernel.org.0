Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B562BB0E1
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 17:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730086AbgKTQqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 11:46:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54437 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730085AbgKTQqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 11:46:42 -0500
Received: from 3.general.kamal.us.vpn ([10.172.68.53] helo=ascalon)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kamal@canonical.com>)
        id 1kg9YW-0007LN-1T; Fri, 20 Nov 2020 16:46:40 +0000
Received: from kamal by ascalon with local (Exim 4.90_1)
        (envelope-from <kamal@ascalon>)
        id 1kg9YR-0003A8-Ma; Fri, 20 Nov 2020 08:46:35 -0800
Date:   Fri, 20 Nov 2020 08:46:34 -0800
From:   Kamal Mostafa <kamal@canonical.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: Re: pick up "usb: dwc2: Avoid leaving the error_debugfs label unused"
Message-ID: <20201120164632.GA10906@ascalon>
References: <20201119222342.13619-1-kamal@canonical.com>
 <X7eAyumuMGcWBG81@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X7eAyumuMGcWBG81@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 20, 2020 at 09:39:38AM +0100, Greg KH wrote:
> On Thu, Nov 19, 2020 at 02:23:42PM -0800, Kamal Mostafa wrote:
> > Hi Sasha-
> > 
> > To fix an unused-label warning, please pick up this mainline commit:
> > 
> > 190bb01b72d2 ("usb: dwc2: Avoid leaving the error_debugfs label unused")
> > 
> > in these stable branches:
> > 
> >     linux-5.8.y
> 
> 5.8.y is long end-of-life, nothing I can do there.
> 
> >     linux-5.9.y
> 
> It does not apply cleanly to this kernel tree, are you sure it is needed
> there?  If so, can you provide a working backport?
> 

It is needed for 5.9 -- backport on the way.

Thanks,

 -Kamal
