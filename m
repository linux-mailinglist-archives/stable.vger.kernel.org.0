Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0134519AF
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 00:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349133AbhKOXZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 18:25:34 -0500
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:11699 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348673AbhKOXXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 18:23:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1637018436; x=1668554436;
  h=from:subject:to:message-id:date:mime-version:
   content-transfer-encoding;
  bh=nmTzSN7XSP1zC3315yW7V+QBfeyHimacL8i6+TF2BUs=;
  b=TOedm6q675+rRhTbl/DqHqySgnQ+suekTvy+qELWezGIlHkuuL8it+1J
   p5vph0L4x27mKuoYfiSRxWcwwtOsG+bqvuzkS0OTn83VJJyE///tEQDzX
   m4FiN2k6AO7MeTP64BVZq3MSCZ8NV/5bHXyLxDdVnMk8g3LdrDdF/j2Ac
   o=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 15 Nov 2021 15:20:35 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg03-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 15:20:35 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.19; Mon, 15 Nov 2021 15:20:35 -0800
Received: from [10.47.233.232] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.19; Mon, 15 Nov
 2021 15:20:34 -0800
From:   Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
Subject: [PATCH]: thermal: Fix NULL pointer,dereferences in of_thermal_
 functions
To:     Stable <stable@vger.kernel.org>
Message-ID: <9ccc6a1e-d4f5-5762-b9cc-74699e92913d@quicinc.com>
Date:   Mon, 15 Nov 2021 15:20:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
This patch was sent originally in [1]. I can see it being picked up in 5.16-rc1 [2] now. Can this be applied to 5.10.x and 5.15.x trees please?

Commit id: 96cfe05051fd8543cdedd6807ec59a0e6c409195 <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/thermal/thermal_of.c?h=v5.16-rc1&id=96cfe05051fd8543cdedd6807ec59a0e6c409195>
Reason: To avoid a null pointer de-reference when a thermal sensor device supplying a thermal zone device doesn't probe or probe later when an userspace entity can attempt to set trip thresholds.
Kernel versions to be applied: 5.10.x, 5.15.x

Thanks,
Subbaraman

[1] https://lore.kernel.org/linux-pm/1636070227-15909-1-git-send-email-quic_subbaram@quicinc.com/.
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/thermal/thermal_of.c?h=v5.16-rc1&id=96cfe05051fd8543cdedd6807ec59a0e6c409195
