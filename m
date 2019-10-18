Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29451DBE2D
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 09:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbfJRHSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 03:18:42 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:39622 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbfJRHSm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 03:18:42 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x9I7IVJt118924;
        Fri, 18 Oct 2019 02:18:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1571383111;
        bh=OilUv+GFguDJ3YR661ZCA0FSuZHVAgyHf27fIiSPtBQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=VFA9s4S3oEa6/V0fDs4K7SMjpWK/KswAWW8GBkMBbvZv1jBytBIFi93E2cQNu3kXC
         A8S1vzbTVkmVP6IKcZXBT1/XH/ZTOMwUqeBAyP+Wcoyyq/ZQwnzdI+pAGEgLxzbwyt
         87fEZ/tztleAif7MSNLX9JL2VC3rfhdo/D7JOp8E=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9I7IVZl044520;
        Fri, 18 Oct 2019 02:18:31 -0500
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 18
 Oct 2019 02:18:22 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Fri, 18 Oct 2019 02:18:22 -0500
Received: from [192.168.2.6] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9I7ITTV080168;
        Fri, 18 Oct 2019 02:18:29 -0500
Subject: Re: [PATCH] drm/omap: fix max fclk divider for omap36xx
To:     Adam Ford <aford173@gmail.com>
CC:     dri-devel <dri-devel@lists.freedesktop.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        stable <stable@vger.kernel.org>
References: <20191002122542.8449-1-tomi.valkeinen@ti.com>
 <CAHCN7xLjGkLHMWejEk-3vJ-OwzjB+BXtnPWoonh4mAVxbkzMWQ@mail.gmail.com>
 <CAHCN7xKN7CePgajQLH61dBaoLWZ4VMxo39_xJOWHyvM3x_0i=A@mail.gmail.com>
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <406842b9-18f0-ddf7-5317-4ace265d0ac2@ti.com>
Date:   Fri, 18 Oct 2019 10:18:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAHCN7xKN7CePgajQLH61dBaoLWZ4VMxo39_xJOWHyvM3x_0i=A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17/10/2019 21:05, Adam Ford wrote:

>> Is there any way you can do a patch for the FB version for the older
>> 4.9 and 4.14 kernels?  I think they are still defaulting to the omapfb
>> instead of DRM, so the underflow issue still appears by default and
>> the patch only impacts the DRM version of the driver.  If not, do you
>> have any objections if I submit a patch to stable for those two LTS
>> branches?
> 
> Gentle nudge on this question.  I can do the work, but I just
> permission so don't overstep.

Sure, go ahead.

  Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
