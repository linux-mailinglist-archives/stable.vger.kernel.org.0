Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58DA3653E2D
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 11:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbiLVKVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 05:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbiLVKVP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 05:21:15 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD1C10B7A
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 02:21:14 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id p1-20020a05600c1d8100b003d8c9b191e0so901475wms.4
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 02:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0l/sBDupILyigR1zS8aEpbTv1w5bYxTAxdx7jTg6MmI=;
        b=WK3vSij9Lw9qS63gH6VvAcgbNBpQ1wijLg/vhj5V8/CmrFjjH4paiSUKBWv2NDeE6M
         DcHkNSecACgFysANBte6A3fIZ/wQboLYZxhQNJXo5AVyyk1X+HY3OB5pGYPIAaTZmt8s
         fTigTBy+SBrUOV3vZKfnnRYNEvolhHfUPUITePUU46IdlBgtKvtVpPYjq1ohA1Ak5Jzp
         udtN5NDOqovgkAsQNaQAVxnj7Gw6GbWuapA6uIwmQmhPcT0FmLCjzY00T2WcyXHuel/B
         30lH7X9MhRYd+CRx2GhSouVCdNJteK2tk2UOZVV/9gfyMC7wjimRtl8/52N+dH86ADge
         h34g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0l/sBDupILyigR1zS8aEpbTv1w5bYxTAxdx7jTg6MmI=;
        b=eIkdAp8yAaOpPzCEhfJhihG8KEAg9vTHfb1CtIkgqwd7Kg3JkGQbqxfw6qkgdCbO5x
         LgviYQ2j43U3wPmfhn658eKQTqszf5vtXoPWTLXv+dzBRVvS1PHtGOpUgmXRhtcH66FC
         ubjbKtVQiXV5j9c5rB649aAU/ibsi1YwPBsX4S2qX3VDprlLLdQY3N4mBLisarExNG63
         nhWlh5SNE2J7mEdXpAH77jrgxkTVY4vjne26SMhtU4mdYyvijWfVEPF2L/8+feNCsses
         GlcPFMf4pemolHIwsRLzqD1H8/5DxVpjEYtwwdDc4J1FuvwBHJ9mbbaylwfwyE19/Ya0
         7Vjw==
X-Gm-Message-State: AFqh2koJiSdhWIBBBjSQOiZGYVPbYFvxWaYmyTCkG3fGVkMS8QIV1kY8
        5bF304AdRf6JuScPg1OTbiahCcjdyXh6ljviM7w=
X-Google-Smtp-Source: AMrXdXvtUaRq8mGfxqBzshY9Esfn+IfWYufq87T5jYLlcq2joY+T2XYZEv0kKPFy3UjKrbpcmwXxkyJsOWvjro0K5J4=
X-Received: by 2002:a05:600c:3d0c:b0:3b5:477:1e80 with SMTP id
 bh12-20020a05600c3d0c00b003b504771e80mr325764wmb.200.1671703995407; Thu, 22
 Dec 2022 02:13:15 -0800 (PST)
MIME-Version: 1.0
Sender: moubely@gmail.com
Received: by 2002:adf:e808:0:0:0:0:0 with HTTP; Thu, 22 Dec 2022 02:13:14
 -0800 (PST)
From:   Aisha Al-Gaddafi <aishaalgaddafi112@gmail.com>
Date:   Thu, 22 Dec 2022 11:13:14 +0100
X-Google-Sender-Auth: GoRAZxn9yR3jgmSkgxQ56NA8pd0
Message-ID: <CA+urYODyzSE0O=8kHj_zNBM3tGTsWKqArUiOqeqttgPykuCeJQ@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Good morning, my name is Aisha Al-Gaddafi.

Please, I have an investment Project transaction of US$27.500.000.00.
that involves transfer and I would like to have your advice on which
Investment / Industry that you think that can bring us profit.

If you're interested, kindly reply for more specific information on
this project.

Thanks,
Mr. Aisha Al-Gaddafi.
