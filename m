Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4C622E15
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 10:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbfETIMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 04:12:43 -0400
Received: from 4.mo7.mail-out.ovh.net ([178.32.122.254]:53742 "EHLO
        4.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730445AbfETIMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 04:12:43 -0400
X-Greylist: delayed 1202 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 May 2019 04:12:41 EDT
Received: from player760.ha.ovh.net (unknown [10.108.35.232])
        by mo7.mail-out.ovh.net (Postfix) with ESMTP id CC1DD118D4E
        for <stable@vger.kernel.org>; Mon, 20 May 2019 09:34:09 +0200 (CEST)
Received: from armadeus.com (lfbn-1-7591-179.w90-126.abo.wanadoo.fr [90.126.248.179])
        (Authenticated sender: sebastien.szymanski@armadeus.com)
        by player760.ha.ovh.net (Postfix) with ESMTPSA id 064FF5F24312;
        Mon, 20 May 2019 07:33:54 +0000 (UTC)
Subject: Re: [PATCH RE-RESEND 1/2] drm/panel: Add support for Armadeus ST0700
 Adapt
To:     Sam Ravnborg <sam@ravnborg.org>
References: <20190507152713.27494-1-sebastien.szymanski@armadeus.com>
 <CAOMZO5B2nMsVNO6O_D+YTSjux=-DjNPGxhkEi3AQquOZVODumA@mail.gmail.com>
 <20190507161950.GA24879@ravnborg.org>
 <20190508083303.GR17751@phenom.ffwll.local>
 <20190508090612.GT17751@phenom.ffwll.local>
Cc:     Fabio Estevam <festevam@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        stable <stable@vger.kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
From:   =?UTF-8?Q?S=c3=a9bastien_Szymanski?= 
        <sebastien.szymanski@armadeus.com>
Openpgp: preference=signencrypt
Message-ID: <0c5d70db-e7c1-5d02-9c33-65dabd431a68@armadeus.com>
Date:   Mon, 20 May 2019 09:34:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190508090612.GT17751@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 6372874948130854140
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddtjedguddvgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Sam,

On 5/8/19 11:06 AM, Daniel Vetter wrote:
> On Wed, May 08, 2019 at 10:33:03AM +0200, Daniel Vetter wrote:
>> On Tue, May 07, 2019 at 06:19:50PM +0200, Sam Ravnborg wrote:
>>> Hi Fabio
>>>
>>> On Tue, May 07, 2019 at 12:33:39PM -0300, Fabio Estevam wrote:
>>>> [Adding Sam, who is helping to review/collect panel-simple patches]
>>>>
>>>> On Tue, May 7, 2019 at 12:27 PM Sébastien Szymanski
>>>> <sebastien.szymanski@armadeus.com> wrote:
>>>>>
>>>>> This patch adds support for the Armadeus ST0700 Adapt. It comes with a
>>>>> Santek ST0700I5Y-RBSLW 7.0" WVGA (800x480) TFT and an adapter board so
>>>>> that it can be connected on the TFT header of Armadeus Dev boards.
>>>>>
>>>>> Cc: stable@vger.kernel.org # v4.19
>>>>> Reviewed-by: Rob Herring <robh@kernel.org>
>>>>> Signed-off-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
>>> Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
>>>
>>> If you wil lresend the patch I can apply it.
>>> I have lost the original mail.
>>
>> Usually patchwork should have it already (and you can pipe the raw
>> patchwork mbox into dim apply), but somehow it's not there either.
>> Not sure why, sometimes this is because mails are stuck in moderation,
>> sometimes because people do interesting things with their mails (e.g. smtp
>> servers mangling formatting).
> 
> patchwork was just a bit slow, it's there now:
> 
> https://patchwork.freedesktop.org/series/60408/
> 

Will you take the patch from patchwork or should I resent it ?

Regards,

> Cheers, Daniel
> 


-- 
Sébastien Szymanski
Software engineer, Armadeus Systems
Tel: +33 (0)9 72 29 41 44
Fax: +33 (0)9 72 28 79 26
