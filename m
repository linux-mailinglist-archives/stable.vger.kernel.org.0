Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07762242847
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 12:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgHLKd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 06:33:59 -0400
Received: from mout.gmx.net ([212.227.17.21]:55981 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbgHLKd6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Aug 2020 06:33:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1597228421;
        bh=kyxDKOrNtFwAET7ssBuwQAdW/EMV3Yiruqvshw/MQC8=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=F9oHOFd2NE49uWlyTBzMzsO0oF/XRpAZ+oojzB4cv+rcTAaknj3nNAdioxWIXyE5K
         fRs17zeH8O3XXiVG2KtZ3d+SQkt3yBESKsjN/l5voxMCdsdPOtQjXKSa1pWP2xBOSi
         AHEzJVMgNHbMMrQpL1vTOBIbpsmi9BCaVUh2JTEE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [185.53.41.139] ([185.53.41.139]) by web-mail.gmx.net
 (3c-app-gmx-bap56.server.lan [172.19.172.126]) (via HTTP); Wed, 12 Aug 2020
 12:33:41 +0200
MIME-Version: 1.0
Message-ID: <trinity-a4a4e709-ca8d-4867-8f90-d0ddbfca05cb-1597228420620@3c-app-gmx-bap56>
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
Subject: Aw: [PATCH 2/3] arm64: dts: mt7622: add reset node for mmc device
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 12 Aug 2020 12:33:41 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20200812093726.10123-3-wenbin.mei@mediatek.com>
References: <20200812093726.10123-1-wenbin.mei@mediatek.com>
 <20200812093726.10123-3-wenbin.mei@mediatek.com>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:gfeTfH9cl5G8lIBSMXcX0ttEubv7Ajx1wwPT2iBKRJ8x3w1qe/q3Aq2pU6G5w045XTeaU
 X3ie2/s10R6kks7/xbD1Thbuozc+5ABCC2Am3V7c0VHKbNgHXHKbBPCnlOP3yA6NpDTgQGfnLfXq
 mt68050gHBqeVdojky2SpvZFPnuyuXuTIKNpYZQDJlmALzYVzEsr7oh5nBHW3UOVkKg9+6w/Yd7C
 mosrh9PR2Acwn92c2U2/n4y7rw6QPDbkY6e14wwmYMzPyk45sRS9ZKLVepc6Kb+jqmWobwfkqN7j
 Zk=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6zVhbMh56Ig=:LxG6KCEOEFw5ug8YyG4aUq
 I+jIPz9C525zCUaVy4FFHPQrjwvKyfNMVhdvoNAxO76lVanL4HNBm+m2p6TG4qr1wYnRk20f/
 ppp/o0zMRE4hRqy0nzwabB6XZjhs8iOj7iXl1FjT+atnR3DK6LvDSef+2nZKrAhrsgc1y6TtW
 rQJ4Glp5O2TaYSJv4vwZlMJT10hIPMxPDSspftOdzccie4sIdOWD03Y6nouD6rbdqpD6QfCS8
 3a9K9GqPy9XTqO0THuFMFkBCjBGSGSv/gOc5N+4v0BqrF2CUmS7727+FbOXnBLX5G7Fnc3c0z
 URfCQ1gYwVCVU7g7VlQZSAyKjXDosXZJdPzJHgnpZB1esDMQjk4szyd6Fj3OiFR4BnW4Ylzdp
 EESsEPaiOwz1hOkfwJmnrhmIqch1bBhtFKzbXw+P6xMspti9EQAaHAr+hR5MyqCdDdjXPm3SR
 uHW5qbD2yIiwmCVxwq4sNXPwxj7wbgYJerkmBUy0Sfi5MAiKrm8sefwdJXxGO7Go9eWSM2HLi
 R3wE2hz33osl8exD//FrrkQitMLMrHexG7/6cOxFEZc1JTUXpnLdIOxLMMe5rCcWdi/zKiRut
 ggVUvJ162ZiXRbjBBpCIEaO2Qcf/mGKWRUDa+yGGCprJ9ERmqs6kh8XFXmoxGG3hDoE3ePiLc
 St+5o7ZXfgAdZQElB2i0R6/B+ExcHvo8wclRPylKghS3nXR+p3QK8eiWju9YQ1vWk6qc=
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
same as 3/3, dts-patch is also needed for fixing eMMC-Issue on R64

Fixes: 966580ad236e ("mmc: mediatek: add support for MT7622 SoC")
Tested-By: Frank Wunderlich <frank-w@public-files.de>

and it needs to be fixed at least for 5.4+, so adding stable-CC

Cc: stable@vger.kernel.org
