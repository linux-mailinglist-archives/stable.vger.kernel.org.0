Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01AE73528A8
	for <lists+stable@lfdr.de>; Fri,  2 Apr 2021 11:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbhDBJ2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Apr 2021 05:28:03 -0400
Received: from comms.puri.sm ([159.203.221.185]:47526 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231160AbhDBJ2D (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Apr 2021 05:28:03 -0400
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id E2C57E0440;
        Fri,  2 Apr 2021 02:27:31 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kz69dXS-f4HA; Fri,  2 Apr 2021 02:27:30 -0700 (PDT)
Message-ID: <a7a6165055ea857a6e0f86591f9235671fb11d02.camel@puri.sm>
Subject: Re: [PATCH] Revert "usb: dwc3: gadget: Prevent EP queuing while
 stopping transfers"
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
To:     Wesley Cheng <wcheng@codeaurora.org>, gregkh@linuxfoundation.org,
        balbi@kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-usb@vger.kernel.org
Date:   Fri, 02 Apr 2021 11:27:25 +0200
In-Reply-To: <57733e4d-7aad-4564-9ebf-8293a9a4d4e4@codeaurora.org>
References: <20210322121932.478878424@linuxfoundation.org>
         <20210401115558.2041768-1-martin.kepplinger@puri.sm>
         <57733e4d-7aad-4564-9ebf-8293a9a4d4e4@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Donnerstag, dem 01.04.2021 um 11:09 -0700 schrieb Wesley Cheng:
> 
> 
> On 4/1/2021 4:55 AM, Martin Kepplinger wrote:
> > This reverts commit 9de499997c3737e0c0207beb03615b320cabe495.
> > 
> > Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
> > ---
> > 
> > I more or less blindly report:
> > commit 9de499997c ("usb: dwc3: gadget: Prevent EP queuing while
> > stopping
> > transfers") results in the below error every time I connect the
> > type-c
> > connector to the dwc3, configured with serial and ethernet gadgets.
> > 
> > fyi, I apply the following to dwc3 on this port:
> > dr_mode =
> > "otg";                                                        
> > snps,dis_u3_susphy_quirk;                                          
> >      
> > hnp-
> > disable;                                                           
> > srp-
> > disable;                                                           
> > adp-
> > disable;                                                           
> > usb-role-switch;
> > 
> > v5.12-rc5 does not have this error so I'm not sure whether it's
> > more appropriate to add something to dwc3 than reverting. I hope
> > usb
> > people to know better and maybe even see the problem.
> > 
> > thanks,
> >                                martin
> > 
> Hi Martin,
> 
> This has been fixed with the below:
> https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/commit/?h=usb-linus&id=5aef629704ad4d983ecf5c8a25840f16e45b6d59
> 
> Can you pull that in and give it a try?
> 
> Thanks
> Wesley Cheng

yes, that's a fix for my problem (and what I secretly had hoped to get
:). Thank you very much. In case it helps:

Tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>


