Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04894628C57
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 23:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbiKNWuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 17:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiKNWuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 17:50:23 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B5C120BF
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 14:50:22 -0800 (PST)
Received: (Authenticated sender: alexandre.belloni@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 950DCFF802;
        Mon, 14 Nov 2022 22:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1668466218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wVNQpnB0O3nnAFMkzPFmO9Bkxx89nPM74j8GMCfmxu4=;
        b=g4QV+/oDqAABSglAv/otKtAMqjMqnslZYtptK8W0aHMmXiT7+GV/C//F9viZ1agzeorceQ
        Ie8/k9WdVDJCYvm+/PoMvZl+KrWcKxNgFc7QivpXpVo/fH7YfO+pu7YOA8YhpSRs6uqi2q
        6L+vkg1pUvrRDiEa+I+12vxxf2eEtU5yi0T0ZOaYRpzpESW8RcFJ8DnaIQZaiIISMBqlQw
        fx8Y2j7mzkJugfNrygcFgFXS70bXN6c2IOM4yt71PO+RNCo86PdMvA5j4N6PP/HXWhuf5B
        c/tEbu+Kn6lTCzqwj+FnFLKfi7dlwR+ur2ayRs1ciX2w+WWRVx43x3re1hT6ZQ==
Date:   Mon, 14 Nov 2022 23:50:18 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Ian Abbott <abbotti@mev.co.uk>, linux-rtc@vger.kernel.org
Cc:     stable@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH] rtc: ds1347: fix value written to century register
Message-ID: <166846619726.2125405.18251869444474918297.b4-ty@bootlin.com>
References: <20221027163249.447416-1-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027163249.447416-1-abbotti@mev.co.uk>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Oct 2022 17:32:49 +0100, Ian Abbott wrote:
> In `ds1347_set_time()`, the wrong value is being written to the
> `DS1347_CENTURY_REG` register.  It needs to be converted to BCD.  Fix
> it.
> 
> 

Applied, thanks!

[1/1] rtc: ds1347: fix value written to century register
      commit: c397361d7339fa3a2949758ffd5298231fb43173

Best regards,

-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
