Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50EDA55484F
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 14:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357785AbiFVLsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 07:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346969AbiFVLsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 07:48:42 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90AD03CA41
        for <stable@vger.kernel.org>; Wed, 22 Jun 2022 04:48:39 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id BE99622238;
        Wed, 22 Jun 2022 13:48:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1655898518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Zs1EkfZopk6gYpI9D/aDrFtaGA3Bq1d5LQ1+2qZaZ/M=;
        b=en02T/e/d9NrIJHmdu52BfnBjUtJUtPCHJIvDG92tORJLbSFGV8Pbh/sWc6Y13R6qtZrNy
        EQyofvhMzuUWQ+oL/Zqn3F15pRnVwSj2F7bIOYBUh4YrY8EGKvQ08zjTpbS6oRH4Ipp9fc
        /7jUJGhdqd+djHliLsh6St8rydAQti0=
From:   Michael Walle <michael@walle.cc>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sean Anderson <sean.anderson@seco.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Michael Walle <michael@walle.cc>
Subject: backport of 8cb0cd68bef7 (dt-bindings: nvmem: sfp: Add clock properties)
Date:   Wed, 22 Jun 2022 13:48:10 +0200
Message-Id: <20220622114810.3398108-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

This patch should have been picked for the 5.18 branch where the device
tree binding was introcuded first, but instead it landed in -next without a
Fixes: tag [1].

Now there is a backwards incompatible change between 5.18 and the upcoming
5.19. Thus, can this be picked up for the 5.18 tree?

More background can be found in [2].

-michael

[1] https://lore.kernel.org/r/3b8fc56f64508f7604f3b9e14b048568@walle.cc
[2] https://lore.kernel.org/r/4a45db184fbadc278624571dfbeb5004@walle.cc
