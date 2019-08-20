Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0AE6961F9
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 16:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730114AbfHTOH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 10:07:57 -0400
Received: from ns.iliad.fr ([212.27.33.1]:55558 "EHLO ns.iliad.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729988AbfHTOH5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 10:07:57 -0400
Received: from ns.iliad.fr (localhost [127.0.0.1])
        by ns.iliad.fr (Postfix) with ESMTP id 29796205F8;
        Tue, 20 Aug 2019 16:07:55 +0200 (CEST)
Received: from [192.168.108.37] (freebox.vlq16.iliad.fr [213.36.7.13])
        by ns.iliad.fr (Postfix) with ESMTP id 14B2620554;
        Tue, 20 Aug 2019 16:07:55 +0200 (CEST)
Subject: Re: [PATCH] phy: qcom-qmp: Correct ready status, again
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Cc:     MSM <linux-arm-msm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Vivek Gautam <vivek.gautam@codeaurora.org>,
        Evan Green <evgreen@chromium.org>,
        Niklas Cassel <niklas.cassel@linaro.org>
References: <20190806004256.20152-1-bjorn.andersson@linaro.org>
From:   Marc Gonzalez <marc.w.gonzalez@free.fr>
Message-ID: <d455b4b3-0ee6-5612-ead9-b0087e11b22e@free.fr>
Date:   Tue, 20 Aug 2019 16:07:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190806004256.20152-1-bjorn.andersson@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: ClamAV using ClamSMTP ; ns.iliad.fr ; Tue Aug 20 16:07:55 2019 +0200 (CEST)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/08/2019 02:42, Bjorn Andersson wrote:

> Despite extensive testing of 885bd765963b ("phy: qcom-qmp: Correct
> READY_STATUS poll break condition") I failed to conclude that the
> PHYSTATUS bit of the PCS_STATUS register used in PCIe and USB3 falls as
> the PHY gets ready. Similar to the prior bug with UFS the code will
> generally get past the check before the transition and thereby
> "succeed".
> 
> Correct the name of the register used PCIe and USB3 PHYs, replace
> mask_pcs_ready with a constant expression depending on the type of the
> PHY and check for the appropriate ready state.
> 
> Cc: stable@vger.kernel.org
> Cc: Vivek Gautam <vivek.gautam@codeaurora.org>
> Cc: Evan Green <evgreen@chromium.org>
> Cc: Niklas Cassel <niklas.cassel@linaro.org>
> Reported-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
> Fixes: 885bd765963b ("phy: qcom-qmp: Correct READY_STATUS poll break condition")
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>  drivers/phy/qualcomm/phy-qcom-qmp.c | 33 ++++++++++++++---------------
>  1 file changed, 16 insertions(+), 17 deletions(-)

FWIW, for msm8998:

Tested-by: Marc Gonzalez <marc.w.gonzalez@free.fr>

Regards.
