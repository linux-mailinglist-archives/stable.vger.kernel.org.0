Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82238124C50
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 16:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbfLRP7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 10:59:49 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36411 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbfLRP7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 10:59:49 -0500
Received: by mail-pg1-f193.google.com with SMTP id k3so1510088pgc.3;
        Wed, 18 Dec 2019 07:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vcRsV+GyYVCdqNxO9/KlH1EXlf/d0/mBnssyXPuxyRY=;
        b=US4SiMhXMeTy11uj01hBaMlSQs315XYCGkgVIeQHLMGX6H/U+w6mIGFBva/i/Quvqy
         CFkbsQ0Gur0z8MfkRtYB55qJLnfEuZitL+YauR8voLDv2KA8G6FjZGkcnQ89XLPnh5m2
         wdcmvpim/2HDb4QzKEHrWItXams2UmKmP9f2DlEljR/+U+3Q30rqqCMLkSmj5atbtK99
         KNnmzKeEtwDa4/vUPHrp1/zsNwLHtOGVIRNLENwIwu5K37II8F9KQ3T0ptBsfGeUezDT
         uE1JD7N08KgTD38uyJGYPhBvgduj5q1UIpGAeoMAoN+iMTN7MtQhNzO6Yo2gLUHO7au3
         8Iqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=vcRsV+GyYVCdqNxO9/KlH1EXlf/d0/mBnssyXPuxyRY=;
        b=U02SW62bBuo7Nu6Q11hefOSOEbBO3MBdaSU076vgYCBd43WqLfIg1FpTlSK3BGy13/
         11It0btvLglhrlTmKI5wTmOgXlV9cGN1JEL0XGzosA+TXA+ld5n2KIIfc6iba33wrDhS
         6p7wLxojyzx4spw66kxBu8ScAHTWcpARO5f8gNgYFlEMNFg5iJs4pFggK5Zv6I7oZH33
         52wqvO+Qmk0KTujcl4pN1Mvmbrht7Jk3sCv68Abal+gOp4FYImjnUegUpBrgbDb39bff
         1FBtqFe84Qx4fZYxfEkg4n2TJDdSgODCCZcWO3PMaRiOacGsyx3YnAFyUYejErPdQzwc
         CnzA==
X-Gm-Message-State: APjAAAXoQKP/NARH+YdMXEU0eaHfM5yzFVZDrxBvzEfwyGViEHODf1Ny
        +c0NC58y4S65BRTJgYqNZVY=
X-Google-Smtp-Source: APXvYqzcIk58RSqNhgs226XfFCNdym1HtwnkDO3OOMdo09IDJZgZOiWUbYKCdDNdcomWrmsRyHnizw==
X-Received: by 2002:a65:66ce:: with SMTP id c14mr3976919pgw.262.1576684788637;
        Wed, 18 Dec 2019 07:59:48 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p16sm3873989pgi.50.2019.12.18.07.59.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 18 Dec 2019 07:59:47 -0800 (PST)
Date:   Wed, 18 Dec 2019 07:59:46 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henry Lin <henryl@nvidia.com>, stable@vger.kernel.org
Subject: Re: [PATCH] usb: xhci: Fix build warning seen with CONFIG_PM=n
Message-ID: <20191218155946.GA331@roeck-us.net>
References: <20191218011911.6907-1-linux@roeck-us.net>
 <20191218142932.GA237894@kroah.com>
 <04cef5f6-2bc2-b056-d2c4-e79ba5498225@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04cef5f6-2bc2-b056-d2c4-e79ba5498225@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 18, 2019 at 05:38:06PM +0200, Mathias Nyman wrote:
> On 18.12.2019 16.29, Greg Kroah-Hartman wrote:
> > On Tue, Dec 17, 2019 at 05:19:11PM -0800, Guenter Roeck wrote:
> > > The following build warning is seen if CONFIG_PM is disabled.
> > > 
> > > drivers/usb/host/xhci-pci.c:498:13: warning:
> > > 	unused function 'xhci_pci_shutdown'
> > > 
> > > Fixes: f2c710f7dca8 ("usb: xhci: only set D3hot for pci device")
> > > Cc: Henry Lin <henryl@nvidia.com>
> > > Cc: stable@vger.kernel.org	# all stable releases with 2f23dc86c3f8

Somehow I messed up the commit sha here. It is f2c710f7dca8, obviously.
2f23dc86c3f8 is the sha from v4.19.y. Sorry for that.

Guenter

> > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > ---
> > >   drivers/usb/host/xhci-pci.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Nice catch.
> > 
> > Mathias, I can queue this up now if you give me an ack.
> 
> Yes, please
> 
> Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> 
