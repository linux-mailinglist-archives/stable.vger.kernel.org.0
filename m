Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B2C24280C
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 12:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgHLKI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 06:08:27 -0400
Received: from mout.gmx.net ([212.227.17.21]:52737 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbgHLKI1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Aug 2020 06:08:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1597226878;
        bh=UkqjCxKKHV1HDyi41mZtq9yMhrKx967IftYVnHuBMGo=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=CVa57jyqOd+wAZ7HXJCaZTcWrbj9dKyv+WghkaTGAXpiP2JsIvR0EQYgZWjbrGYiO
         lsBWgX1QG8ZF82HjYytXjIkoJrHZCMtWf3yQ1+ICaGkXnM6d6nfr+pmeun5MhEhTqE
         zqpiozDA1NGXVxf3FFncbmNurNIBF6Kx6a5QKPTs=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [185.53.41.139] ([185.53.41.139]) by web-mail.gmx.net
 (3c-app-gmx-bap56.server.lan [172.19.172.126]) (via HTTP); Wed, 12 Aug 2020
 12:07:58 +0200
MIME-Version: 1.0
Message-ID: <trinity-5b810acf-eb8f-452e-b08a-30e1fe46226d-1597226878715@3c-app-gmx-bap56>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Wenbin Mei <wenbin.mei@mediatek.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Wenbin Mei <wenbin.mei@mediatek.com>,
        srv_heupstream@mediatek.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        stable@vger.kernel.org
Subject: Aw: [PATCH 3/3] mmc: mediatek: add optional module reset property
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 12 Aug 2020 12:07:58 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20200812093726.10123-4-wenbin.mei@mediatek.com>
References: <20200812093726.10123-1-wenbin.mei@mediatek.com>
 <20200812093726.10123-4-wenbin.mei@mediatek.com>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:t+v+dbXvTKFePvkpJQAkYHe5HoNVIemuMfLD56cl7pscYB573WfuroyNnOcU3eKU+Ux0w
 Bzr/Ckkf3ghFKTc0HwsL4hjb7JZpcAuLKIGlYRTDdvf/jlTHtulh0AIxWzbgZD0o/QUDiCzNjkkT
 sO5kefkm7G1UW6cNByINedYydy1x5x1KSNZ4caJ/jgdEUkwBF3dN/4r2t4BJSmLaKk6FpWb6i+m/
 LIO56ZvPG/DHOzaEApF96sk+MKAwEB1GS2joHA8xJDYDQNhmgLVskiKFp++wXff8gvYfNKazeZL8
 Bo=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:1lebNj6ihXA=:yKrs1mlHJa1VH4DNmWf8T7
 QJv04DKWPHCKukADg6WgoibuSsh8OqnB3RcbFU3Hime9w81JXHzcUKJZhuZcawE6T0x8wLLKD
 JiDKf7eLoturt4bAUdUxm1LFnv2JmFegH1M35dhP0jeqQbe8FxWjYrS9hg53qbKvLsipJwhnN
 92goZdJzEhOQbDBdxP8Vtq2F62SWwzwnixojAUFr8ieyEdQAojALTxVrP6q5a8gxqhCIDeoV4
 THzEuSaCf33VF+3EIRe59nHodktmpEc42dTqERD8uQWsd0cfPmh6Ieb5eSfhGbHDoScIK7EO6
 w/ETHBOlzdCYaknwVuG9lGJu2/gdYUID21RXu0CJSmF04V/4aALKHIAu/mGfRd0ykYkIfF3Ht
 pNwVjBCIqtZriHaxV+77szPbiiWBK2xEvReXULdqZwX5X0jZkYhtheoWT2z98SDx2hAiNEOUU
 MfPblapX0RDVVZ4p0+02p4WfY2rW2t5fSwFD9AZD9vHdyBxM6LOe3k5B05lY+Ehlp/YZv7UH3
 oBgrvgJ0On8H4UXi5FKrZ0xPqu9qxwDb+Yyre98Ot4FfxvMOUbCHGbQhW4tI71aH7TeLjWBvO
 rLnf0guUcE+asNRp8rcfkVl0RIBrEgcoDSf7iW8OvwIFa4C9I8a0hWHQ9y51edL70I44SAAMB
 zLSiW3Buc5mCvDUdGE+2uhCK5m2ifvaVV4mBafLf+nGumAfwR77CEoehMf1ob2y5Za+0=
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Gesendet: Mittwoch, 12. August 2020 um 11:37 Uhr
> Von: "Wenbin Mei" <wenbin.mei@mediatek.com>
> Betreff: [PATCH 3/3] mmc: mediatek: add optional module reset property

> This patch adds a optional reset management for msdc.
> Sometimes the bootloader does not bring msdc register
> to default state, so need reset the msdc controller.
>
> Signed-off-by: Wenbin Mei <wenbin.mei@mediatek.com>

Thanks for posting the fix to Mainline

imho this should contain a fixes-Tag as it fixes eMMC-Access on mt7622/Bpi=
-R64

before we got these Errors on mounting eMMC ion R64:

[   48.664925] blk_update_request: I/O error, dev mmcblk0, sector 204800 o=
p 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
[   48.676019] Buffer I/O error on dev mmcblk0p1, logical block 0, lost sy=
nc page write

Fixes: 966580ad236e ("mmc: mediatek: add support for MT7622 SoC")
Tested-By: Frank Wunderlich <frank-w@public-files.de>

and it needs to be fixed at least for 5.4+, so adding stable-CC

Cc: stable@vger.kernel.org
