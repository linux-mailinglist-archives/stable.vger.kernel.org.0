Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8433E1FB0B5
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 14:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbgFPMbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 08:31:00 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:48764 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgFPMa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 08:30:59 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05GCUmVc063733;
        Tue, 16 Jun 2020 07:30:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592310648;
        bh=8Qx/5mQW/ObYotai4BueB40LH/bmL06FeT6kWL8joj4=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=hFT1xUBQp1Ur1V5JkzJqVwfO1OXTUz2gJaefj2439LQtzY37HZTA8N8EZK6JZEPcj
         ZpOjvxyf3hMsunjCM/Pkf26TZoxTFxoaSQMrvzJJGXHyW67B9t4OFZSBl3pvls/cAr
         V7iu73M05z3xXo+bVMpYfH35A/oPUQj0WNdfinyI=
Received: from DFLE107.ent.ti.com (dfle107.ent.ti.com [10.64.6.28])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05GCUm6W018956;
        Tue, 16 Jun 2020 07:30:48 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 16
 Jun 2020 07:30:47 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 16 Jun 2020 07:30:47 -0500
Received: from [192.168.2.6] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05GCUjC9103134;
        Tue, 16 Jun 2020 07:30:46 -0500
Subject: Re: [PATCH] drm/panel-simple: fix connector type for LogicPD Type28
 Display
To:     Adam Ford <aford173@gmail.com>, Fabio Estevam <festevam@gmail.com>
CC:     DRI mailing list <dri-devel@lists.freedesktop.org>,
        David Airlie <airlied@linux.ie>,
        Adam Ford-BE <aford@beaconembedded.com>,
        stable <stable@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>
References: <20200615131934.12440-1-aford173@gmail.com>
 <CAOMZO5Bw5qSDirAKBTRcu4_nDafDcfDGpuNRDyuLZs9Zc=HsQA@mail.gmail.com>
 <CAHCN7x+=xjFTy6J4Ej61U2jXTez2rLrt=KtEOzbvV7Tzq6XoPQ@mail.gmail.com>
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <0df0bf28-dbf7-4d1e-06f0-d545df8dc2d5@ti.com>
Date:   Tue, 16 Jun 2020 15:30:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAHCN7x+=xjFTy6J4Ej61U2jXTez2rLrt=KtEOzbvV7Tzq6XoPQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15/06/2020 17:53, Adam Ford wrote:
> On Mon, Jun 15, 2020 at 9:46 AM Fabio Estevam <festevam@gmail.com> wrote:
>>
>> On Mon, Jun 15, 2020 at 10:19 AM Adam Ford <aford173@gmail.com> wrote:
>>>
>>> The LogicPD Type28 display used by several Logic PD products has not
>>> worked since v5.5.
>>
>> Maybe you could tell which commit exactly and then put a Fixes tag?
> 
> I honestly don't know.  I reached out to the omap mailing list,
> because I noted this issue. Tomi V from TI responded with a link that
> he posted which fixes this for another display.
> 
> https://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg312208.html
> 
> I tested that patch and it worked for a different LCD, so I did the
> same thing to the Logic PD Type 28 display as well.
> 
> My patch and commit message were modeled after his, and his commit
> CC's stable with a note about being required for v5.5+
> 
> I added him to the CC list, so maybe he knows which hash needs to be
> referenced from a fixes tag.  I was hoping to not have to go back and
> bisect if it's not required, but I will if necessary.

No, I didn't check when exactly it broke. connector_type was added in v5.5, and my patch applies to 
v5.5, so I set that as stable version. But the WARN comes from panel bridge. Possibly 
89958b7cd9555a5d82556cc9a1f4c62fffda6f96 is the one that adds requirement to have connector_type.

  Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
