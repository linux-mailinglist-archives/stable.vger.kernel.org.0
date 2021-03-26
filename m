Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16E634A82B
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 14:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhCZNdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Mar 2021 09:33:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230115AbhCZNdb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Mar 2021 09:33:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD37E61A13;
        Fri, 26 Mar 2021 13:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616765611;
        bh=zQQSBgbXWgu1CEHTNySPMPTHks3ugxb2VaoPNH+KTv8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ego8D5Pqqk4Zu8PXaMwF1OutzkJcPhc9XOxU6QdBvjUWB6Stxar8q4In9Ym5j8H1N
         9USYedy/WiiitLj1wbRq8rKukM5fxdDBui/c1JMwPLvUbnVsxkvXlG3Fw+MZf8WBXL
         xaiJWwZuWeFYef1s2OM6aaBamuAFxNBTDsG2+htY=
Date:   Fri, 26 Mar 2021 14:33:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        linux-usb@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        John Youn <John.Youn@synopsys.com>,
        Paul Zimmerman <paulz@synopsys.com>, stable@vger.kernel.org,
        #@synopsys.com, 5.2@synopsys.com, Felipe Balbi <balbi@ti.com>,
        Kever Yang <kever.yang@rock-chips.com>
Subject: Re: [PATCH 3/3] usb: dwc2: Prevent core suspend when port connection
 flag is 0
Message-ID: <YF3iqIsjHVfit9C3@kroah.com>
References: <20210326102510.BDEDEA005D@mailhost.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326102510.BDEDEA005D@mailhost.synopsys.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 26, 2021 at 02:25:09PM +0400, Artur Petrosyan wrote:
> In host mode port connection status flag is "0" when loading
> the driver. After loading the driver system asserts suspend
> which is handled by "_dwc2_hcd_suspend()" function. Before
> the system suspend the port connection status is "0". As
> result need to check the "port_connect_status" if it is "0",
> then skipping entering to suspend.
> 
> Cc: <stable@vger.kernel.org> # 5.2
> Fixes: 6f6d70597c15 ("usb: dwc2: bus suspend/resume for hosts with
> DWC2_POWER_DOWN_PARAM_NONE")

In the future, do not line-wrap the fixes line.

thanks,

greg k-h
