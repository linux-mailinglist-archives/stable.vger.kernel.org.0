Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFF05781D6
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 14:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234718AbiGRMNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 08:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234893AbiGRMNu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 08:13:50 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9823EF53
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 05:13:49 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id bp15so20844387ejb.6
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 05:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3FNpQi4GXI3RFGhDUZ6sGIelJuJWAhvfzotC36wNc5k=;
        b=eTqLas2P6J4zDSnz9Ea/OBCWmD0L5F5uI4vPVzfClwaMTnTvXpcgqDHxxIx5ySDuql
         4zEI2nHX7u1oQ2D14pkVGXpPcy3EcZWxhHcpr77ltQToruW4THt9EgKG7D6v/dX+4lzU
         9S/OULnHZR8BJulTAhc8Kwb3tEm8l+QwDzbp/OAjRDwkkmsHEJ2ByTmN4hoCK7bFhwqd
         i/S+9K27Hzy3ZifBQd4N7LI89pzzzHg60WlYuIsL/uxhM2aIFGWJruhplxFfnXZlo+md
         b92RHFnvM9siBvVY8OnhKL7g3/dvGJ23Z5zNthZeqhjV1sWXlZIW11N2l6LWODeQDOBX
         OynQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3FNpQi4GXI3RFGhDUZ6sGIelJuJWAhvfzotC36wNc5k=;
        b=dTycgjg874ZlGGkoQjnlC8eb2E6QNZawnbczv42sc0mHejIdiHYYK6JygJZdAbfs29
         5pdClm6d2GlWPwl/t5mCOF5lRgxp0we/6nzJYebhkSKUrCVmJQaGd4/m1ZkSMtx7pyNx
         QFx7TTqK3SPZvcIjamC131jLdGNPN5saiNP3kN72u+C08RVw6IVicX5tubNVOZEOPPtl
         X+86/PnUy3D9TYlPsOqn9ymUD75Wo5Wz2l/ENmO8So4BJhR/bIygMLuFW6sJFXOE8Lzv
         DR8TdzVRM+hkJwoXcJ5ks4eaUfJV/US2prcKSLM137FZvFndeLu4uc7/iToXurikw5dQ
         sbiw==
X-Gm-Message-State: AJIora/B6qIjdddGnxGu7vcOEMMWxK9OI67IpucUN+2XK2jq1Hv7Pzej
        R6DkWHyLMK8Gv/ngoT0JDB9O+Z9+nAg=
X-Google-Smtp-Source: AGRyM1tkB0uHyJRj6sjFMk95nxQWf27gDXPI4W3IrGdYKlKxMGK3NLMq5VIBVmmx/LeZqHsCxW0QuA==
X-Received: by 2002:a17:907:2723:b0:72b:5af3:5a11 with SMTP id d3-20020a170907272300b0072b5af35a11mr25007425ejl.584.1658146427679;
        Mon, 18 Jul 2022 05:13:47 -0700 (PDT)
Received: from labdl-itc-sw06.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id r18-20020a17090609d200b006feed200464sm5364603eje.131.2022.07.18.05.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 05:13:47 -0700 (PDT)
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
X-Google-Original-From: Fabio Porcedda <Fabio.Porcedda@telit.com>
To:     stable@vger.kernel.org
Cc:     Fabio Porcedda <Fabio.Porcedda@telit.com>
Subject: [PATCH 0/2] Backport support for Telit FN980 v1 and FN990 for 3.18
Date:   Mon, 18 Jul 2022 14:13:33 +0200
Message-Id: <20220718121335.386097-1-Fabio.Porcedda@telit.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
these two patches are the backport for 3.18.y of the following commits:

commit a96ef8b504efb2ad445dfb6d54f9488c3ddf23d2
    bus: mhi: host: pci_generic: add Telit FN980 v1 hardware revisio

commit 77fc41204734042861210b9d05338c9b8360affb
    bus: mhi: host: pci_generic: add Telit FN990

The cherry-pick of the original commits don't apply because the commit
89ad19bea649 (bus: mhi: host: pci_generic: Sort mhi_pci_id_table based
on the PID, 2022-04-11) was not cherry-picked. Another solution is to
cherry-pick those three commits all togheter.

In the following days I will send backport for longterm releases.

Thanks!


Daniele Palmas (2):
  bus: mhi: host: pci_generic: add Telit FN980 v1 hardware revision
  bus: mhi: host: pci_generic: add Telit FN990

 drivers/bus/mhi/host/pci_generic.c | 79 ++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

-- 
2.37.1

