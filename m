Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E2455B3A9
	for <lists+stable@lfdr.de>; Sun, 26 Jun 2022 20:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiFZSzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jun 2022 14:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiFZSzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jun 2022 14:55:41 -0400
Received: from danwin1210.de (danwin1210.de [116.202.17.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277B4654F
        for <stable@vger.kernel.org>; Sun, 26 Jun 2022 11:55:37 -0700 (PDT)
Received: from danwin1210.de (unknown [10.9.0.4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X448 server-signature ECDSA (P-384)
         client-signature ED448)
        (Client CN "danwin1210.me", Issuer "danwin1210.me" (verified OK))
        by mail.danwin1210.de (Postfix) with ESMTPS id D51401F4FA;
        Sun, 26 Jun 2022 18:55:34 +0000 (UTC)
Received: from dummy.faircode.eu (unknown [10.9.0.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
        (No client certificate requested)
        by danwin1210.de (Postfix) with ESMTPSA id E089A3C067;
        Sun, 26 Jun 2022 18:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=danwin1210.de;
        s=20211204-rsa; t=1656269734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MCno6/6PgH1087qTZYZneXJic3my9OKBUo/z9RSelIw=;
        b=qfJmn9pVokmkm70EkGQTj/x3bZtZz6zEHunxAmrmbqExcPd2svzsU117uP5MQmqIFC7ztq
        Meoo6oIUe8tYEp9XKr4cAw7e1f+VSX+Aj8czm+yXKbOzxVeIQaBJMf39iEXn6aBjAjIljK
        suLBfedqVq+goQ3V7fuFKh6tvheRpDzTxBXScuYIA8Nzu6Smpma4OQz4Mq8MGRR7wmr284
        kEsp8KFAqc5jwUI6X+zE8RMpErVu1tYtS3yAh97yzzu22nyCixyCSNJWQM+Aoo/bxnCzTR
        tji6cPNh/vIylqiMP8SEgZ/tAc4SqWX8m0W1L7KopKn9NRznFiXcDIqs7Qv4iQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=danwin1210.de;
        s=20211204-ed25519; t=1656269734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MCno6/6PgH1087qTZYZneXJic3my9OKBUo/z9RSelIw=;
        b=pkaHa3CkMfgSYw5MSN6PhrkvglKAD4LpgZcC4JPsab2TxSyipeR4a+3NMircdvHKpfAdFV
        JDozpAmL8chWInDg==
Date:   Sat, 25 Jun 2022 23:54:29 +0000 (UTC)
From:   DISCLOSURE <disclosure@danwin1210.de>
Message-ID: <988f8bd0-3d4b-43bf-99b0-5584ff0ef008@danwin1210.de>
Subject: Protections
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Correlation-ID: <988f8bd0-3d4b-43bf-99b0-5584ff0ef008@danwin1210.de>
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_40,DATE_IN_PAST_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        NUMBEREND_LINKBAIT,SCC_BODY_URI_ONLY,SPF_HELO_PASS,SPF_PASS,
        TVD_SPACE_RATIO,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

https://paste.uguu.se/?beeeb28510425c98#EqFwsdgLJ9xApvS8erufypdYNuXNmorcbBohYGtLqsXG
