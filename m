Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2B024D1D9D
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 17:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbiCHQmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 11:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbiCHQml (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 11:42:41 -0500
X-Greylist: delayed 158 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Mar 2022 08:41:34 PST
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC9651E7B;
        Tue,  8 Mar 2022 08:41:32 -0800 (PST)
Received: (Authenticated sender: alexandre.belloni@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1F8A5C000B;
        Tue,  8 Mar 2022 16:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1646757690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g3N81fA+vJADPOjYhZ3sl82OW76Cy0oeLIM010Hh6ho=;
        b=cJm0/6b6Q65dqVCXybrIAtOM4hTkRDKnfDns7ad3Mk3eo62xB8XQdxU/dbsoTJ1i3HmXdW
        7ZXUdKndUEv9D7D5Ac5hWapd6p5QuTVyAe5QeDEDuX9QcUGZ9pWYmSDZhEV6d0uUv/tjKj
        QR7lKKNGZi4/6Q5KoM4jzfOS69YlLwxJ0ZkNXml1Kp36FU66jF5h//s1Dgvq9A093Kumh1
        93BKb4oFXHg/rHsyShpdKM+UYWVHpB4IZaUhx+FnncSBkMYr6EytqzqmJ4vykvdGunXOZO
        TJePyB3MyfnQDRyZCG5yvPgFcuGbXF6J/nGNhZXJ0CC8ghAIPd9ramE+xTm0zQ==
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Alessandro Zummo <a.zummo@towertech.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Elliot Berman <quic_eberman@quicinc.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rtc@vger.kernel.org, stable@vger.kernel.org,
        Carl van Schaik <quic_cvanscha@quicinc.com>,
        Ali Pouladi <quic_apouladi@quicinc.com>
Subject: Re: [PATCH] rtc: pl031: fix rtc features null pointer dereference
Date:   Tue,  8 Mar 2022 17:41:28 +0100
Message-Id: <164675768067.58101.5701419137609469239.b4-ty@bootlin.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220225161924.274141-1-quic_eberman@quicinc.com>
References: <20220225161924.274141-1-quic_eberman@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Feb 2022 08:19:24 -0800, Elliot Berman wrote:
> From: Ali Pouladi <quic_apouladi@quicinc.com>
> 
> When there is no interrupt line, rtc alarm feature is disabled.
> 
> The clearing of the alarm feature bit was being done prior to allocations
> of ldata->rtc device, resulting in a null pointer dereference.
> 
> [...]

Applied, thanks!

[1/1] rtc: pl031: fix rtc features null pointer dereference
      commit: 75445c15916421993d47c338a17d49f3449b516f

Best regards,
-- 
Alexandre Belloni <alexandre.belloni@bootlin.com>
