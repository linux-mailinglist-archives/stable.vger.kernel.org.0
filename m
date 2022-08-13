Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A84C5925EC
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 20:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiHNSTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 14:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiHNSTj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 14:19:39 -0400
X-Greylist: delayed 398 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 14 Aug 2022 11:19:35 PDT
Received: from danwin1210.de (danwin1210.de [IPv6:2a01:4f8:c010:d56::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949431CB26
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 11:19:35 -0700 (PDT)
Received: from danwin1210.de (unknown [10.9.0.3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X448 server-signature ECDSA (P-384)
         client-signature ED448)
        (Client CN "danwin1210.me", Issuer "danwin1210.me" (verified OK))
        by mail.danwin1210.de (Postfix) with ESMTPS id 0A7EB1F4AE;
        Sun, 14 Aug 2022 18:12:54 +0000 (UTC)
Received: from dummy.faircode.eu (unknown [10.9.0.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
        (No client certificate requested)
        by danwin1210.de (Postfix) with ESMTPSA id EE05E5A4A3;
        Sun, 14 Aug 2022 18:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=danwin1210.de;
        s=20211204-rsa; t=1660500774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ToSglJN9ze67xVNIQb5nayaI+6PFGXerJqHrH1O0RCo=;
        b=XqXSxcRGLM+RIpohMG2NC+ZW9+RXsfPkoAuPkxe4ncheu5E8nE4y8b08WGCdkIetOQ2WEx
        dZRYruQ6OFVne/P6gwQs7Glc6EP+k1TPJUnaowcelWJPxBINNCuR6mHEdxpkhsqr/w4PLt
        mbNHLGBw/VdoDiNh2KeBmXEIkBp6JeSGTgW7WBiEz37+Aq7VZtl2XceNX+k0XStnRrbkQT
        8r7+w83gBXRmEJQ58Hjr3HXYAn1gomJCSJLgzU3TGeTC5vys2PuaH8dDFnK3ND1cwmKpiR
        u5lxMN/rqufcJ/4+PDYI0pc95AIVfIC+RYyU1Nl0dDoo9BdRru5DuIg2fDRxww==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=danwin1210.de;
        s=20211204-ed25519; t=1660500774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ToSglJN9ze67xVNIQb5nayaI+6PFGXerJqHrH1O0RCo=;
        b=csEoeDrWWEqchZ32ZXrKR/DTY47fJxfiq2OWKJAUAGpcmPlIHW7KMOHMz+uiJLRWZHO5Vd
        8Y7RaqXlI/BOeGDw==
Date:   Sat, 13 Aug 2022 23:10:38 +0000 (UTC)
From:   DISCLOSURE <disclosure@danwin1210.de>
Message-ID: <f5d11154-ccaf-454e-887c-b84410174e9e@danwin1210.de>
Subject: Quantum
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Correlation-ID: <f5d11154-ccaf-454e-887c-b84410174e9e@danwin1210.de>
X-Spam-Status: No, score=2.0 required=5.0 tests=BAYES_50,DATE_IN_PAST_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        RCVD_IN_DNSWL_MED,SCC_BODY_URI_ONLY,SPF_HELO_PASS,SPF_PASS,
        TVD_SPACE_RATIO,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

https://paste.uguu.se/?f20b16a2be63ec49#G1FhorRgULkGtz7oPZD2mAWGshAawxdqWmnHAuvjd7ET
