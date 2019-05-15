Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE6B1F040
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfEOLmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:42:06 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:58026 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732360AbfEOL2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 07:28:16 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x4FBS9Dv062207;
        Wed, 15 May 2019 06:28:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1557919689;
        bh=uD0hOed8qFjFZXDyYgxx1HKj4YC6mZZmhn8u4YqN9qU=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=ke2sSvoKvQdNApcRuZbt00b15JHzYjRrbKyKiQaUjvsD6pEcmlO2m1zyf10Wi2ZtT
         IsAknwHtjexvMkkeZIH9JYdR/gcMhM/JaLNJO3/nnisZkSadaGqo2UpAFh5jl02PZn
         LMsRSj9BKzuzHMqHCVxEwkWKIlpqXu6+TfvPrnNk=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x4FBS9Y2079097
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 May 2019 06:28:09 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Wed, 15
 May 2019 06:28:08 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Wed, 15 May 2019 06:28:08 -0500
Received: from [172.22.173.234] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x4FBS72p125930;
        Wed, 15 May 2019 06:28:07 -0500
Subject: Re: [PATCH 4.14 053/115] i2c: omap: Enable for ARCH_K3
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Vignesh R <vigneshr@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <alexander.levin@microsoft.com>
References: <20190515090659.123121100@linuxfoundation.org>
 <20190515090703.440094029@linuxfoundation.org>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <b97de7c6-fb95-33a9-3ac6-4df45eec82c5@ti.com>
Date:   Wed, 15 May 2019 14:28:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190515090703.440094029@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 15.05.19 13:55, Greg Kroah-Hartman wrote:
> [ Upstream commit 5b277402deac0691226a947df71c581686bd4020 ]
> 
> Allow I2C_OMAP to be built for K3 platforms.
> 
> Signed-off-by: Vignesh R <vigneshr@ti.com>
> Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>

This is not v4.14 material as there no support for ARCH_K3.
Could you drop it pls.

-- 
Best regards,
grygorii
