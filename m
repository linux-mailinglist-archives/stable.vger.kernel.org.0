Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFBCE96E54
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 02:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfHUAZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 20:25:46 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:40238 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfHUAZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 20:25:46 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x7L0PgIQ014627;
        Tue, 20 Aug 2019 19:25:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1566347142;
        bh=Oq241szXA6ZxlB4T9azpmiBdcJombOOOR3oc550NPNE=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Gihx/POCzcUrjF2/iqXMbKdKs5d6UjDGyKXXEgKASCrg46HlJblpj/8c0Xdc9AM8j
         g4e5uiHA/me1u/mfeJ8KZ+U9u6VrXVPwBMJ4OcObl66msJ/+DqxZpOE6Qe41pNJmHQ
         igjgvStDZZ4JMmzgknR3Z5SKurDjeRF6XrfCGWDI=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x7L0PgGI052702
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 20 Aug 2019 19:25:42 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Tue, 20
 Aug 2019 19:25:42 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Tue, 20 Aug 2019 19:25:42 -0500
Received: from [172.24.190.233] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x7L0PdlO009332;
        Tue, 20 Aug 2019 19:25:40 -0500
Subject: Re: [PATCH] phy: qcom-qmp: Correct ready status, again
To:     Sasha Levin <sashal@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
CC:     <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>,
        Vivek Gautam <vivek.gautam@codeaurora.org>,
        Evan Green <evgreen@chromium.org>,
        Niklas Cassel <niklas.cassel@linaro.org>
References: <20190806004256.20152-1-bjorn.andersson@linaro.org>
 <20190806155040.0B54520C01@mail.kernel.org>
From:   Kishon Vijay Abraham I <kishon@ti.com>
Message-ID: <57556d09-e2db-dc00-45a9-cbb57da02319@ti.com>
Date:   Wed, 21 Aug 2019 05:53:47 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190806155040.0B54520C01@mail.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On 06/08/19 9:20 PM, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 885bd765963b phy: qcom-qmp: Correct READY_STATUS poll break condition.
> 
> The bot has tested the following trees: v5.2.6.
> 
> v5.2.6: Failed to apply! Possible dependencies:
>     520602640419 ("phy: qcom-qmp: Raise qcom_qmp_phy_enable() polling delay")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

Merging of this patch got delayed. Bjorn, Is it okay if this patch gets merged
in the next merge window and backported to stable releases then?

Thanks
Kishon
