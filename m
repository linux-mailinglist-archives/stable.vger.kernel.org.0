Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D653ACB5C
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 09:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfIHHqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 03:46:53 -0400
Received: from mout.gmx.net ([212.227.17.20]:36027 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbfIHHqx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 03:46:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1567928796;
        bh=6F0QummU8imcXMVMrHV6+BZ6LAb4e7PC70awvqL69uU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=aFXc/C/jjspa3E8a5GfmVYXWb7qxSARK4wdrzPrfOobAj7nFr8KoGrUcxN6y08pl2
         gN5f7pdHtCyhcJxFSqWzA9lrvXzTjO0JWwkA49c9DJhdMdtgOga4xOYfcn9Y9gV3R8
         Kof7KAsHVnhoYByvxnhKZ6fdh1CxfGgYRn0koMw8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.90]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N0XD2-1iIswK0UUO-00wSFT; Sun, 08
 Sep 2019 09:46:36 +0200
From:   Stefan Wahren <wahrenst@gmx.net>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Eric Anholt <eric@anholt.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Lukas Wunner <lukas@wunner.de>
Cc:     linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stefan Wahren <wahrenst@gmx.net>, stable@vger.kernel.org
Subject: [PATCH] Revert "mmc: bcm2835: Terminate timeout work synchronously"
Date:   Sun,  8 Sep 2019 09:45:52 +0200
Message-Id: <1567928752-2557-1-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
X-Provags-ID: V03:K1:VwIaAgaE77BXr/OK8ymof3uAGLOUwsyBEkzyr0AbfRe+SAK6zDU
 V38GQU5finceBHAa44KL9PSo2iPyW9hAJ/PllzN7PFdXC3tEeYfcvSNEaXhCtXbWzzA9rBl
 CE2WuWLxEpfsm8XZekOsu+W2lll5TTsganOt/n1ZeJ2Vc4jZVWIe4qpgJnW1wmJQZMXG6St
 cKo+1rp9nrblsX49+AssQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:quBeLoVv08c=:KPB0k4C+t3kzBH3NJ1NLE/
 16Re7YIMzT5wkuoJi+8mXU+2yYQ/EJ18Wh9H0V8EDvdkn5Eycw0CbEF4SxfeTadiR+Qmzq7NJ
 nUFw5XmJzKKU9l2lNTn6+W7pszH36VHeWW3ber5S28h97QdiQUH0u/I5yY/3+3uToSUrXQTmy
 FWv7Z+cWljSc1dVGe3BCMyEcZqiqdNAEfNAmRNBcrV+XcIlf9UhEpsnxoUOupg4BFlNF4Ngyt
 NFyxpLwgPtK2Ay3exIMHnzPI1lk4pItq3OQ/0EJtA5obu4sfjkOzEr4WL8B2wSicyXYXCtLOc
 h/x9X6VFeXw6/ffB+/gtOhlY+dgMKnTcQeqXY2nWlg2Po0003KdRxxjMCnJVpzBXkVfRkYIgd
 o0z9tYgHAeZFTYtjJVP5rGB6h5QGNu6mKUqQ2YFQVkxtHG7/dkSdUfpjAXMksxKt1E+FK9eAc
 kFwShhyMJEv+gvqFh1I5zTLpWS9eYIfxpulEBibfN4D1In6mG5aedxmkX+8OwqbWlCHUbHvvg
 SmgtJLv7I1eUdAU0Rzvp0bn4TgAGufTqVeOwjyJ3SzQjpJR0HMtFz+Pcy/6V0NeRyfXcQp3C9
 EdEMzjYYm/7ut9swjacYShk7A20sfRXKDbieiGAWz5Es7Ams2RRfVU8EnB+mS3QU8QGAbjk3W
 v4Q/es6UUJKhs4QIspuCefnrkaP2EnOhufuYhnzOxsuyHIPt4LHqH4PrnzHw3f+LAtE84dSlU
 K2Ff2258XqdJGgGw84qcq4XkeCMUeZcL56Hq07MrPrtpWZjzeXB6IVfSgQa/+AQJoTS0qc+LX
 7ybr8Z451UDb9B26SyjpKQ+4ryV9RDLYQcORUBAn0++g/6i1vu7fo/78Aak3WqGEVT5XCclFx
 gsdHD5pSITgscj5iH7ppj85cbfsPXd6GXNjjelkVvx3sgcwQ72yBvl0cbM3bOwgeuZS9/yYA6
 WD7SQwMD9+xcFNhnTMeajvchWD2JX7/h16uI2FnZWdkky7gH/LKRVTd7Y0Wi6aeAWpeWUQAoG
 PKLHUciPUDlBPwqkivjAZIMDAycQZ3aOaq4f+XWjuixTukCSNRVkPHH35ygEj2oxpH6bAqs8k
 EBxt2hm+pKJTYQR5NCPrFq1E/Q2fbWfBD+VXYuuaXxOWf8iG6pNHI1+9J0yi+Qx0KRRAEEdwv
 NNa9A+4wr3OFO7hRxlf3EFSoIwOlXg5XpBZEO+3TQHncJkiRizdXrZNbf9o24fm7d4h6w=
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit 37fefadee8bb ("mmc: bcm2835: Terminate timeout work
synchronously") causes lockups in case of hardware timeouts due the
timeout work also calling cancel_delayed_work_sync() on its own.
So revert it.

Fixes: 37fefadee8bb ("mmc: bcm2835: Terminate timeout work synchronously")
Cc: stable@vger.kernel.org
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
=2D--
 drivers/mmc/host/bcm2835.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/bcm2835.c b/drivers/mmc/host/bcm2835.c
index 7e0d3a4..bb31e13 100644
=2D-- a/drivers/mmc/host/bcm2835.c
+++ b/drivers/mmc/host/bcm2835.c
@@ -597,7 +597,7 @@ static void bcm2835_finish_request(struct bcm2835_host=
 *host)
 	struct dma_chan *terminate_chan =3D NULL;
 	struct mmc_request *mrq;

-	cancel_delayed_work_sync(&host->timeout_work);
+	cancel_delayed_work(&host->timeout_work);

 	mrq =3D host->mrq;

=2D-
2.7.4

