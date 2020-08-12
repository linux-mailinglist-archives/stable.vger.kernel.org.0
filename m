Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED72242B35
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 16:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbgHLOT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 10:19:29 -0400
Received: from mout.gmx.net ([212.227.15.18]:48351 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726485AbgHLOT3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Aug 2020 10:19:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1597241944;
        bh=2qIIIi+kVG7PNoSbul+CG9EF5Wr4xueF6mcdgIcW3EU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=KjmsEoehBkJWt2WfLKDifatf+nhathRfdQWsUbieC3G4XEsJxHNktlZZq9HdNN4oE
         JH2NtPH+SiluY9OBzFBhByu+/T+tMynOuKF+DqIGL7o3x6QsRhtkP/kGEvj31JOBEF
         guug7jtkFazXpfY09Nqn46/088gEaBZ1+BAfB4to=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [185.53.41.139] ([185.53.41.139]) by web-mail.gmx.net
 (3c-app-gmx-bs32.server.lan [172.19.170.84]) (via HTTP); Wed, 12 Aug 2020
 16:19:04 +0200
MIME-Version: 1.0
Message-ID: <trinity-b7a0d7ed-cbc7-421d-810d-162fd178a8f3-1597241944268@3c-app-gmx-bs32>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Wenbin Mei <wenbin.mei@mediatek.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Wenbin Mei <wenbin.mei@mediatek.com>,
        srv_heupstream@mediatek.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Chaotian Jing <chaotian.jing@mediatek.com>
Subject: Aw: [v2,3/3] mmc: mediatek: add optional module reset property
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 12 Aug 2020 16:19:04 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20200812130129.13519-4-wenbin.mei@mediatek.com>
References: <20200812130129.13519-1-wenbin.mei@mediatek.com>
 <20200812130129.13519-4-wenbin.mei@mediatek.com>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:DI9ytn25Mt7akP/u6K+zVHv5f9HCrC6Cv16qnII6teMTpW2XwfNpVoOFjsieNPVwxH/l4
 cU9JOsQ/EywXacZma3nl2x+nLnZRWJetq0muKjnIFXHkClEF1/JKMVLhiQGD47pDpFys17mtusRl
 IZj0JuYw2/1ZQNpDUsRUHTLewSnpAmCMNyaFY3QyL81a+Exg1Hd9W45f5B3QKDiXi8YPcFl3ujSC
 htEJ6QIHlc+SwUugRjsLYSIYvPxrpe1U85FJ2oxUj1HDNAkgp5/kWi3ABWD/dfqso+NKIE0XQUAB
 MA=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:pT+4PmpTWt0=:MAHvXFTaSHTxJHOLIoWHrt
 oieG5CBLtcg1W4OdS36hlQtCDvmdbxV16P+T5VgicjXog+nlR9AzaD1rc8OhGi9pfBxrkh6IF
 N1BQtB/D649DurS3NpQSXn3DugHgBTDz8BIhxvccpJuvhkliYkmNM9ObXQmMTXrpsiFmYG3bX
 K3ej55UX74QCj7oadVwk3Ml6YQ6+tB6DQ7Ab4eJjDDc9eSoIogYElzPQ4z//Zsvwq6VJgqFID
 7W+fnvwjUO6hUb5fE/Yct+QWj6rH46A/AEuGRsfBFDRUyytFj/ngG0b3WIXy8EvZHszgpO8nQ
 i6jjqHuIJSZEZvlIbgfxHmQSMGVTfR3gcPfoFe6pcjkx/eRm6ZKIkCEJEshGVqTElrtikL3Yc
 +mhl1GcwQcgkSYairRNGXtjkZvKH7A2/dALySYSkYWGa7UtZ8IwB03HXTPXe0VDJvcWRwJZ0n
 YFcHDHDhLh+Ioyn9WTYMCTdsR3uCKjfrTHex4diVF1H9qMrsVBXNnHWcyMIL+G/dBt0nriNL8
 o4NleJ1UuPAt05XXmA75uEJ0lMvjrMtGXBPetM3y+Mpzf6p5iupJ6PU4BXq38KLkvRmzXKccU
 UdR+Ixupe4/pUkzw4pK7mJXlMxPvQZqdzZ3uMTb/5QFYmjQplOEtC9NeNEEH86EWZtWxHezUm
 5VjR2tYCGpgtxm3PBz4FgT28n6s4wMGzFHdRzJacbioG/hokFAsLHRZFufw2d3/VN8sI=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
it looks like you missed Philipps comments in v1

for stable i guess you need only add Cc: Stable-line to signed-off-area (not add it to CC of mail), sorry my mistake

Cc: stable@vger.kernel.org

regards Frank
