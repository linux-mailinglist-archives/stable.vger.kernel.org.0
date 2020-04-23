Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8612A1B66A4
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 00:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbgDWWIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 18:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbgDWWIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 18:08:54 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07883C09B042
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 15:08:53 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id t11so3592882pgg.2
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 15:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=K+G1+PwcxmC0bvv5uLFnP0XXhpkYqmxl+rnFEl1fK8A=;
        b=WeOsBTlnQVcOYjpFrAaEbz1epw7feyrZ0p5/Sa6bxXiY8ldrYM9ZkzONoQya4gEFs1
         Q4Us8hURFg1+V3oKL+NWnt/Md/Thi5B7Ofo3O94kbqIQwXIAI4W+EeLWptzA+hMC4N78
         7Nzbp9NgFGvENhouCup125LTWM1eq9tki9C6YIV6eHcDHYVHwqEZu9nb3kEQaVX8Xc20
         8doajEHxdZHjw49cDGCdad4vd/B+c6OWcXD9ndsM5SMTjyajQS06X3OEUAPx3VH7nTzN
         iy7UJKWlr2Pv1c7Lsdx8y7nWgP5osu9nJAoxITmnagIx8LKoBDjMdcddJb3r1fCukAUc
         HxUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=K+G1+PwcxmC0bvv5uLFnP0XXhpkYqmxl+rnFEl1fK8A=;
        b=h5Wnqv3oX42AMgL9xuoFMtxf8DE9wJTupY1TGU5k8Sc6D9OW12FYHvX0C5hEVO0jiY
         4Po+nzUrPdYPUzsdJBLb6i+3rHnGHUpR4wvk05YL8JaxU4r5jo/7tIvpQnHWWMj1yizr
         hl7ep8zsZ1pix1JMeyQhViMsbggXk85vmWfYj6Dcy9zZGKoL0KBWdM/iqp3DiAFpSycE
         lBurfHrfN/hHJwM67DrugRYu+xps0PT9JZ0A4wXLg80qKEhdnX7MkdqNWcHvAlHrIqDg
         iX8zhrUIbxS1lBPOJLYwnx6/x+w0/oYmp6wpwIzo9g2nNr+Nx30d8UL5gVk5/16ij872
         sY7w==
X-Gm-Message-State: AGi0PubmtODHQia1/EFsqneDyprSgKqcd+zI8qu+DHfKpldFj+AaNZgF
        b4BY/rnWCPJuQSBG81lF1ekadA==
X-Google-Smtp-Source: APiQypKkBkWpwqblD+K39cLu1g6jy24+PyuNlzBZwjmaGnW8igHIOEUeQ2x5RitUQ/Re3M0rwrBxow==
X-Received: by 2002:a63:1d4c:: with SMTP id d12mr6033739pgm.247.1587679732448;
        Thu, 23 Apr 2020 15:08:52 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id t6sm3540270pfh.98.2020.04.23.15.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 15:08:51 -0700 (PDT)
From:   John Stultz <john.stultz@linaro.org>
To:     lkml <linux-kernel@vger.kernel.org>
Cc:     John Stultz <john.stultz@linaro.org>,
        YongQin Liu <yongqin.liu@linaro.org>,
        Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>,
        Yang Fei <fei.yang@intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Jack Pham <jackp@codeaurora.org>, Josh Gao <jmgao@google.com>,
        Todd Kjos <tkjos@google.com>, Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] dwc3: Remove check for HWO flag in dwc3_gadget_ep_reclaim_trb_sg()
Date:   Thu, 23 Apr 2020 22:08:49 +0000
Message-Id: <20200423220849.30280-1-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The check for the HWO flag in dwc3_gadget_ep_reclaim_trb_sg()
causes us to break out of the loop before we call
dwc3_gadget_ep_reclaim_completed_trb(), which is what likely
should be clearing the HWO flag.

This can cause odd behavior where we never reclaim all the trbs
in the sg list, so we never call giveback on a usb req, and that
will causes transfer stalls.

This effectively resovles the adb stalls seen on HiKey960
after userland changes started only using AIO in adbd.

Cc: YongQin Liu <yongqin.liu@linaro.org>
Cc: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
Cc: Yang Fei <fei.yang@intel.com>
Cc: Thinh Nguyen <thinhn@synopsys.com>
Cc: Tejas Joglekar <tejas.joglekar@synopsys.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc: Jack Pham <jackp@codeaurora.org>
Cc: Josh Gao <jmgao@google.com>
Cc: Todd Kjos <tkjos@google.com>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: stable@vger.kernel.org #4.20+
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/usb/dwc3/gadget.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 4d3c79d90a6e..2a26d33520ce 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2457,9 +2457,6 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct dwc3_ep *dep,
 	for_each_sg(sg, s, pending, i) {
 		trb = &dep->trb_pool[dep->trb_dequeue];
 
-		if (trb->ctrl & DWC3_TRB_CTRL_HWO)
-			break;
-
 		req->sg = sg_next(s);
 		req->num_pending_sgs--;
 
-- 
2.17.1

