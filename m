Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6187A1D0257
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 00:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbgELWbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 18:31:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:30729 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728220AbgELWbL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 18:31:11 -0400
IronPort-SDR: VO0cHnu+E7kqKkn9tp4oYaMVQIqBc3gEPn0/wIsLlifCS99OCO0KmZ7l2Du5y3tDsCowpdeFGx
 aCwb5Hzo8dsA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2020 15:31:10 -0700
IronPort-SDR: XRLFWql053IDiBcm7q1gUGBFEToh/pT+tsHjKkor/HY3Zi+y1955gkdU+leW/T4LkKQ8PWR6Rm
 ATrW4OLVlVCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,385,1583222400"; 
   d="scan'208";a="371709677"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.170]) ([10.237.72.170])
  by fmsmga001.fm.intel.com with ESMTP; 12 May 2020 15:31:08 -0700
Subject: Re: [PATCH 1/1] usb: host: xhci-plat: keep runtime active when remove
 host
To:     Peter Chen <peter.chen@nxp.com>,
        Manu Gautam <mgautam@codeaurora.org>,
        "mathias.nyman@intel.com" <mathias.nyman@intel.com>
Cc:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        dl-linux-imx <linux-imx@nxp.com>, Jun Li <jun.li@nxp.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <20200512023547.31164-1-peter.chen@nxp.com>
 <a5ba9001-0371-e675-e013-b8dd4f1c38e2@codeaurora.org>
 <AM7PR04MB7157A3036C121654E7C70FB38BBE0@AM7PR04MB7157.eurprd04.prod.outlook.com>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Openpgp: preference=signencrypt
Autocrypt: addr=mathias.nyman@linux.intel.com; prefer-encrypt=mutual; keydata=
 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 fiD/
Message-ID: <62e24805-5c80-f6b4-b8ba-cb6d649a878b@linux.intel.com>
Date:   Wed, 13 May 2020 01:33:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <AM7PR04MB7157A3036C121654E7C70FB38BBE0@AM7PR04MB7157.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12.5.2020 7.03, Peter Chen wrote:
> 
>> 
>> On 5/12/2020 8:05 AM, Peter Chen wrote:
>>> Cc: Baolin Wang <baolin.wang@linaro.org> Cc: Mathias Nyman 
>>> <mathias.nyman@linux.intel.com> Cc: <stable@vger.kernel.org> 
>>> Fixes: b0c69b4bace3 ("usb: host: plat: Enable xHCI plat runtime 
>>> PM") Reviewed-by: Peter Chen <peter.chen@nxp.com> Signed-off-by: 
>>> Li Jun <jun.li@nxp.com> --- drivers/usb/host/xhci-plat.c | 1 + 1 
>>> file changed, 1 insertion(+)
>>> 
>>> diff --git a/drivers/usb/host/xhci-plat.c 
>>> b/drivers/usb/host/xhci-plat.c index 1d4f6f85f0fe..f38d53528c96 
>>> 100644 --- a/drivers/usb/host/xhci-plat.c +++ 
>>> b/drivers/usb/host/xhci-plat.c @@ -362,6 +362,7 @@ static int 
>>> xhci_plat_remove(struct platform_device *dev) struct clk
>>> *reg_clk = xhci->reg_clk; struct usb_hcd *shared_hcd =
>>> xhci->shared_hcd;
>>> 
>>> +	pm_runtime_get_sync(&dev->dev);
>> Where is corresponding _put() call?
>> 
> 
> At the end of this function, there is a 
> pm_runtime_set_suspended(&dev->dev). Calling 
> pm_runtime_put_sync(&dev->dev) will cause xhci_plat_runtime_suspend 
> is called which is not expected.
> 
> Peter
> 

This seems odd,
I don't understand why pm_runtime_set_suspended() would call pm_runtime_put_sync()?
I thought pm_runtime_set_suspended() is used to let pm core know the hardware is suspended,
and inform the parent of this, possibly allowing parent to runtime suspend. 
Not sure if it's needed in the remove function. 
It makes sense to allow the parent to suspend, but xhci isn't really suspended.
Yes is stopped, but we can't resume our way back to a active state.

Could it be that the runtime suspend call you are seeing is because we are removing all child devices,
disconnecting and freeing everything, including roothubs and hcd's. 
Maybe runtime pm should be disabled a bit earlier.

Currently probe and remove looks like:

xhci_plat_probe()
  pm_runtime_set_active()
  pm_runtime_enable()
  pm_runtime_get_noresume()
  ...
  pm_runtime_put_noidle()
  pm_runtime_forbid()

xhci_plat_remove()
  <remove and put both hcd's>
  pm_runtime_set_suspended()
  pm_runtime_disable()
  
Would it make sense to change xhci_plat_remove() to

xhci_plat_remove()
  pm_runtime_disable()
  <remove and put both hcd's>
  pm_runtime_set_suspended()

or possibly wrapping the remove in a runtime get/put:

xhci_plat_remove()
  pm_runtime_get_noresume()
  pm_runtime_disable()
  <remove and put both hcd's>
  pm_runtime_set_suspended()
  pm_runtime_put_noidle()

-Mathias 

