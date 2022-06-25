Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7ABB55AC08
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 21:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbiFYTKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 15:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbiFYTKU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 15:10:20 -0400
X-Greylist: delayed 446 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 25 Jun 2022 12:10:14 PDT
Received: from danwin1210.de (danwin1210.de [116.202.17.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B0113F8B
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 12:10:12 -0700 (PDT)
Received: from danwin1210.de (unknown [10.9.0.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X448 server-signature ECDSA (P-384)
         client-signature ED448)
        (Client CN "danwin1210.me", Issuer "danwin1210.me" (verified OK))
        by mail.danwin1210.de (Postfix) with ESMTPS id 8F85E1F58D;
        Sat, 25 Jun 2022 19:02:44 +0000 (UTC)
Received: from dummy.faircode.eu (unknown [10.9.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
        (No client certificate requested)
        by danwin1210.de (Postfix) with ESMTPSA id A45183C02C;
        Sat, 25 Jun 2022 19:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=danwin1210.de;
        s=20211204-rsa; t=1656183763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ProAvTVXht8ufnei2rZZbwJbzDPnci25JufSICAtPtQ=;
        b=VXR+GtRxsl6PhBDCDqIJR1CpdPcApRSo6ApeyMlWu1ytZLl8Ggnfu245G327I3ZuluijHs
        bN9azdCucxJQdvgls+WcPcgDsArdLuItZ2NFvnUvAA3mZkes8bPiTp5YdqffeAbDdzTzy4
        sxAZDeEBdTVNGOjyTyIrB+INYLVv6GZ6AP+JrtjIt6nxPFsvXItl9TFmf7jFnIUacogDIe
        ohjxe3OhmuB/c1GIAHV1M/jC97MKWjEBTO82R7UPAQZpdn1dRRAUA4lJegDMivW/Gm+KdI
        DaIUBl+7l0/CcKW1XO9f6A6nk2q/sh+xgXII+NKk/JNSGPpfDSV1qfyzK+73hg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=danwin1210.de;
        s=20211204-ed25519; t=1656183763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ProAvTVXht8ufnei2rZZbwJbzDPnci25JufSICAtPtQ=;
        b=3jo1DAmIPJOpuHupHLTu+zO8euAp0qJ3MfFSg5IUlmggCCNGABHGZjuXmccU3uoKReJxcJ
        jdKKw5spFoMjUKBg==
Date:   Sat, 25 Jun 2022 19:02:37 +0000 (UTC)
From:   DISCLOSURE <disclosure@danwin1210.de>
Message-ID: <4ead5205-696c-4a16-8cba-5ea96ac5206e@danwin1210.de>
Subject: Echelon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Correlation-ID: <4ead5205-696c-4a16-8cba-5ea96ac5206e@danwin1210.de>
X-Spam-Status: No, score=4.4 required=5.0 tests=BAYES_50,BODY_SINGLE_URI,
        BODY_SINGLE_WORD,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MISSING_HEADERS,NUMBEREND_LINKBAIT,SCC_BODY_SINGLE_WORD,
        SCC_BODY_URI_ONLY,SPF_HELO_PASS,SPF_PASS,TVD_SPACE_RATIO,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

https://defuse.ca/b/4zgLK6gg
