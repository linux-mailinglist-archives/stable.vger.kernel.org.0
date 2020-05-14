Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998171D2D20
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 12:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbgENKnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 06:43:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:32070 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgENKnJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 06:43:09 -0400
IronPort-SDR: yN+ncDJ/R76n5v8WY6eUIhCGidBmCcU6SIp1WD3wEQ1cCyH44sJ/Zfhh8Z+Aa1QkCbGglychzW
 tlo5rOIpeSAg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 03:43:08 -0700
IronPort-SDR: CsZt3rZH2lATZ2dmDPrf0oL4QC05b0paRhaK5Ku3tpPb91+EidmIN7hZK0mJOYIGQMb/khKFTp
 fZZtJ9RVKPfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,391,1583222400"; 
   d="scan'208";a="298671478"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.170]) ([10.237.72.170])
  by orsmga008.jf.intel.com with ESMTP; 14 May 2020 03:43:05 -0700
Subject: Re: [PATCH v2] usb: host: xhci-plat: keep runtime active when remove
 host
To:     Li Jun <jun.li@nxp.com>, mathias.nyman@intel.com
Cc:     gregkh@linuxfoundation.org, baolin.wang@linaro.org,
        linux-usb@vger.kernel.org, stable@vger.kernel.org,
        linux-imx@nxp.com, peter.chen@nxp.com, stern@rowland.harvard.edu,
        mgautam@codeaurora.org
References: <1589449416-2245-1-git-send-email-jun.li@nxp.com>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Openpgp: preference=signencrypt
Autocrypt: addr=mathias.nyman@linux.intel.com; prefer-encrypt=mutual; keydata=
 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 fiD/
Message-ID: <3fc04e70-d9d0-c0a5-7def-aa488c3e1af2@linux.intel.com>
Date:   Thu, 14 May 2020 13:45:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1589449416-2245-1-git-send-email-jun.li@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14.5.2020 12.43, Li Jun wrote:
> While remove host(e.g. for USB role switch from host to device), if
> runtime pm is enabled by user, below oops are occurs at dwc3
> and cdns3 platform. Keep the xhci-plat device being active during
> remove host fixes them.
> 
> oops1:
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000240
> Mem abort info:
>   ESR = 0x96000004
> xhci-hcd xhci-hcd.1.auto: // Halt the HC
> xhci-hcd xhci-hcd.1.auto: // Reset the HC
> xhci-hcd xhci-hcd.1.auto: Wait for controller to be ready for doorbell rings
>   EC = 0x25: DABT (current EL), IL = 32 bits
>   SET = 0, FnV = 0
>   EA = 0, S1PTW = 0
> Data abort info:
>   ISV = 0, ISS = 0x00000004
> xhci-hcd xhci-hcd.1.auto: // Disabling event ring interrupts
>   CM = 0, WnR = 0
> user pgtable: 4k pages, 48-bit VAs, pgdp=00000001b7b18000
> xhci-hcd xhci-hcd.1.auto: cleaning up memory
> xhci-hcd xhci-hcd.1.auto: Freed event ring
> xhci-hcd xhci-hcd.1.auto: Freed command ring
> [0000000000000240] pgd=0000000000000000
> Internal error: Oops: 96000004 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.4.3-00107-g64d454a-dirty #1219
> Hardware name: FSL i.MX8MP EVK (DT)
> Workqueue: pm pm_runtime_work
> pstate: 60000005 (nZCv daif -PAN -UAO)
> pc : xhci_suspend+0x34/0x698
> lr : xhci_plat_runtime_suspend+0x2c/0x38
> sp : ffff800011ddbbc0
> x29: ffff800011ddbbc0 x28: 0000000000000000
> x27: 0000000000000008 x26: ffff800011b28000
> x25: ffff80001012b328 x24: ffff800011ddbd48
> x23: 0000000000000000 x22: ffff80001076ed78
> x21: ffff000177896000 x20: ffff0001714ebce4
> x19: ffff000177896000 x18: ffffffffffffffff
> x17: 0000000000000000 x16: 0000000000000000
> x15: ffff800011b288c8 x14: 0000000000000261
> x13: 0000000000000001 x12: 0000000000000001
> x11: 0000000000000000 x10: 00000000000009c0
> x9 : ffff800011ddbd40 x8 : fefefefefefefeff
> x7 : 0000000000000000 x6 : 000000003ca92688
> x5 : 00ffffffffffffff x4 : 001b6b0b00000000
> x3 : ffff0001714ebc10 x2 : 0000000000000000
> x1 : 0000000000000001 x0 : ffff000177896250
> Call trace:
>  xhci_suspend+0x34/0x698
>  xhci_plat_runtime_suspend+0x2c/0x38
>  pm_generic_runtime_suspend+0x28/0x40
>  __rpm_callback+0xd8/0x138
>  rpm_callback+0x24/0x98
>  rpm_suspend+0xe0/0x448
>  rpm_idle+0x124/0x140
>  pm_runtime_work+0xa0/0xf8
>  process_one_work+0x1dc/0x370
>  worker_thread+0x48/0x468
>  kthread+0xf0/0x120
>  ret_from_fork+0x10/0x1c
> 
> oops2:
> usb 2-1: USB disconnect, device number 2
> xhci-hcd xhci-hcd.1.auto: remove, state 4
> usb usb2: USB disconnect, device number 1
> xhci-hcd xhci-hcd.1.auto: USB bus 2 deregistered
> xhci-hcd xhci-hcd.1.auto: remove, state 4
> usb usb1: USB disconnect, device number 1
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000138
> Mem abort info:
>   ESR = 0x96000004
>   EC = 0x25: DABT (current EL), IL = 32 bits
>   SET = 0, FnV = 0
>   EA = 0, S1PTW = 0
> Data abort info:
>   ISV = 0, ISS = 0x00000004
>   CM = 0, WnR = 0
> user pgtable: 4k pages, 48-bit VAs, pgdp=00000008b05e8000
> [0000000000000138] pgd=0000000000000000, p4d=0000000000000000
> Internal error: Oops: 96000004 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 2 PID: 7 Comm: kworker/u8:0 Not tainted 5.6.0-rc4-next-20200304-03578-gd6235ff42e2b #101
> Hardware name: Freescale i.MX8QXP MEK (DT)
> Workqueue: 1-0050 tcpm_state_machine_work
> pstate: 20000005 (nzCv daif -PAN -UAO)
> pc : xhci_free_dev+0x214/0x270
> lr : xhci_plat_runtime_resume+0x78/0x88
> sp : ffff80001006b5b0
> x29: ffff80001006b5b0 x28: 0000000000000002
> x27: ffff00083b74fd48 x26: ffff00083a365580
> x25: ffff800010141458 x24: 0000000000000000
> x23: 0000000000000000 x22: ffff000837e58138
> x21: 0000000000000004 x20: ffff000837e58000
> x19: ffff000837e58250 x18: 0000000000000000
> x17: 0000000000000000 x16: 0000000000000001
> x15: 0000000000000004 x14: ffffffffffffffff
> x13: 0000000000004ed8 x12: ffff8000123d1000
> x11: ffff800012158000 x10: ffff8000123d1360
> x9 : ffff800010c74b00 x8 : 0000000000000007
> x7 : 00000000000012c2 x6 : ffff8000123d1000
> x5 : 0000000000000001 x4 : 0000000000000000
> x3 : 0000000000000000 x2 : 0000000000000138
> x1 : 0000000000000000 x0 : 0000000000000138
> Call trace:
>  xhci_free_dev+0x214/0x270
>  xhci_plat_runtime_resume+0x78/0x88
>  pm_generic_runtime_resume+0x30/0x48
>  __rpm_callback+0x90/0x148
>  rpm_callback+0x28/0x88
>  rpm_resume+0x568/0x758
>  rpm_resume+0x260/0x758
>  rpm_resume+0x260/0x758
>  __pm_runtime_resume+0x40/0x88
>  device_release_driver_internal+0xa0/0x1c8
>  device_release_driver+0x1c/0x28
>  bus_remove_device+0xd4/0x158
>  device_del+0x15c/0x3a0
>  usb_disable_device+0xb0/0x268
>  usb_disconnect+0xcc/0x300
>  usb_remove_hcd+0xf4/0x1dc
>  xhci_plat_remove+0x78/0xe0
>  platform_drv_remove+0x30/0x50
>  device_release_driver_internal+0xfc/0x1c8
>  device_release_driver+0x1c/0x28
>  bus_remove_device+0xd4/0x158
>  device_del+0x15c/0x3a0
>  platform_device_del.part.0+0x20/0x90
>  platform_device_unregister+0x28/0x40
>  cdns3_host_exit+0x20/0x40
>  cdns3_role_stop+0x60/0x90
>  cdns3_role_set+0x64/0xd8
>  usb_role_switch_set_role.part.0+0x3c/0x68
>  usb_role_switch_set_role+0x20/0x30
>  tcpm_mux_set+0x60/0xf8
>  tcpm_reset_port+0xa4/0xf0
>  tcpm_detach.part.0+0x28/0x50
>  tcpm_state_machine_work+0x12ac/0x2360
>  process_one_work+0x1c8/0x470
>  worker_thread+0x50/0x428
>  kthread+0xfc/0x128
>  ret_from_fork+0x10/0x18
> Code: c8037c02 35ffffa3 17ffe7c3 f9800011 (c85f7c01)
> ---[ end trace 45b1a173d2679e44 ]---
> 
> Cc: Baolin Wang <baolin.wang@linaro.org>
> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> Cc: <stable@vger.kernel.org>
> Fixes: b0c69b4bace3 ("usb: host: plat: Enable xHCI plat runtime PM")
> Reviewed-by: Peter Chen <peter.chen@nxp.com>
> Tested-by: Peter Chen <peter.chen@nxp.com>
> Signed-off-by: Li Jun <jun.li@nxp.com>
> ---
> changes for v2:
> - Add pm_runtime_put_noidle() to balance pm_runtime_get_sync().
> - Move pm_runtime_set_suspended() to be after pm_runtime_disable().

Thanks, added to queue.
did some minor modification to the commit message at the same time.

-Mathias

