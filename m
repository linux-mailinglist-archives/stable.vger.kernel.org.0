Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41CD272CFB
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 13:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfGXLL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 07:11:58 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11767 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfGXLL6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 07:11:58 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d383cfe0000>; Wed, 24 Jul 2019 04:11:58 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 24 Jul 2019 04:11:57 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 24 Jul 2019 04:11:57 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 24 Jul
 2019 11:11:55 +0000
Subject: Re: [PATCH v3] drm/tegra: sor: Enable HDA interrupts at plug-in
To:     Dmitry Osipenko <digetx@gmail.com>,
        Viswanath L <viswanathl@nvidia.com>, <thierry.reding@gmail.com>
CC:     <airlied@linux.ie>, <daniel@ffwll.ch>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <1563885610-27198-1-git-send-email-viswanathl@nvidia.com>
 <0ba35efb-44ec-d56c-b559-59f1daa3e6e4@gmail.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <8b113ad7-07b4-7dfb-e2e5-653514686085@nvidia.com>
Date:   Wed, 24 Jul 2019 12:11:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <0ba35efb-44ec-d56c-b559-59f1daa3e6e4@gmail.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563966718; bh=xQNX1HbPPM6BRzzmB6sq6kMQKmuV/BLtNOO7HydZaZM=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ol8dQr5gzAmLHIj5lTxFkUolWPXhGP2K9CnvI/dSiulgmwl0EHQgzpakvzGsYkqi7
         nXqVwSkg2bNwHOn8wHojRJa1BXx+zvU7xx9RKQeqbFNu2OxabCdJOCvlOenu7KJDAH
         mjpxOE/VhMX/gi73/lX74NFkJ8J4qUVwKNIDI+xJgO0H3kp/dybmAM7JNlD+yHCq6J
         Ejt/3mOhlyxkm5fq9S91Alse4MZFFrc9iD2XMG9fpPrgr/vI/SjvCxmPEeOxi4Zmfh
         SyF3xyg/e9cifD5QDXY4nEWqdi+DQ+LthYFCtQRPCUFmU+G76DYEELYCIOHqpNdR8C
         vbvZDnXw9h69Q==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 24/07/2019 10:27, Dmitry Osipenko wrote:
> 23.07.2019 15:40, Viswanath L =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>> HDMI plugout calls runtime suspend, which clears interrupt registers
>> and causes audio functionality to break on subsequent plug-in; setting
>> interrupt registers in sor_audio_prepare() solves the issue.
>>
>> Signed-off-by: Viswanath L <viswanathl@nvidia.com>
>=20
> Yours signed-off-by always should be the last line of the commit's
> message because the text below it belongs to a person who applies this
> patch, Thierry in this case. This is not a big deal at all and Thierry
> could make a fixup while applying the patch if will deem that as necessar=
y.
>=20
> Secondly, there is no need to add "stable@vger.kernel.org" to the
> email's recipients because the patch will flow into stable kernel
> versions from the mainline once it will get applied. That happens based
> on the stable tag presence, hence it's enough to add the 'Cc' tag to the
> commit's message in order to get patch backported.

I believe 'git send-email' automatically does this.

Jon

--=20
nvpublic
