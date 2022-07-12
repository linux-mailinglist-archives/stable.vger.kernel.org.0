Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C26B85718D8
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 13:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbiGLLqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 07:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbiGLLqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 07:46:39 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D58B1CD9;
        Tue, 12 Jul 2022 04:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1657626396;
        bh=4DGf9fAelIjMIL4cUJBkvt2Bi+U2qT/l8y6i/0sSxCc=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=bSsxshPVadp1rVWgMuIivI/DsctDGVeCFlgX3X4lk66FpK/ULERrFUue06IgXtBn2
         v7WcOMILMsQGWuH2hAESp3KgybaqEznoVHe3QSYCbSp1DKoc9NOcKm8G/gUB9X0kHn
         EQ+yacEcLivaRRLMHMvTcolHduFQHyc7cC/xKr/w=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.34.68]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N1fmq-1nR8321qH2-011xma; Tue, 12
 Jul 2022 13:46:36 +0200
Message-ID: <b758ebfd-f153-c0e6-14f9-d66c760b2e11@gmx.de>
Date:   Tue, 12 Jul 2022 13:46:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.18 000/112] 5.18.11-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:E7ZaxQ+z/MCf46JzgJ2cLP1+KrC+xzzihykRni5jmO6x6CD/TEL
 iHMXDAbvSjO08ie14o25H9PE37Y2bsYiLtJ9VSxr3uWjTTwTJVwe00dDDhf3GSBFYWYNwOm
 MrEB6sHLKmLPL1VctC9MBRGDhfrwaPMK4L7vthG6+VZvPKTg3JMVbbCkwVQQG4XzUAjxoMH
 DVG6OJcMlxWTEpu7fotlQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:p0PcumnsIYU=:UOQhRZmG7GodKjmzBDyNVA
 J9YORX0U2vR557HI7tqjsL0jEEjb2KGKuIL7HdW4dDwIdNB/Sso0JGmlabwse8NZtjfFje3U3
 A5Yw81hwGTnfZKoyjQYJlzwzjJHqASFtsFYh+X8PyugjeaWw7Zh+R8Nyw8wXx5Kt7s/UEGDou
 z/MY5hDnD8MAkEcHIhG6DLqVGOzL0LH4f5vzUSguZD4dCVcF6oYMHhX77uE6rDZUfkIFxjHq4
 L2Un6uP+4ETenxeKJ1x1quCWvEkAfXWFHjevzmoMF74FXem6wryy8nqJwnYlfLCydlB5tI2WK
 8Pxe+JE0ani4cD+LLRm8TbdpcdA6aa2Wei2c6l4YQibIvfKjcSCvFJ9plo4B3lCEt7zs72dqn
 r2ItjOw9q4Y3HDDIorCTJ7GDwU+644rtHdgmTmSPEqzbsPkqnw314orVfa47+PYil90L8xRQ6
 wXYIkz9JCVy+d4CTDuj3hMOB3pXwoDxIfQX5DZ6B27zkblKLTa9LBIEE9MpI8/h+jDvGMt/y9
 QM6eBtNS31vo109kB51FeQSuTgcOseL56u4TpFnzMAb80czPOP73JcHvIOAfb+cnECcom0YEU
 b5HgYHevvByItDjozzwnZFe1QklHq21W3U0X2/QkN/wFDprZKxGBCwQsIm01Fih6nInrDd6EH
 yPdDXxyw/2BHheP6GWyxhj0ya7bSvIkB6Mjk6ms33wanzUeki7l24lzsyOS1Das2Je/RZa7mx
 N0xO5kTZBgqbvT74iysngKMuBBJ9mOvICDVQ57uZc0ccVEEfVjc3qCbZ0E/GtsGsMaVeRNaSK
 K2IKiarqM2/dGqD0H/DgOPC/YRYjfwgVIskzDiqq5jUDElhJbXhE9wzcZNOgPDLfUNAQqTGUw
 Lt0jhXq3qk5FY+e9XzubMU+zOE8EXNJEyVhpLK7OZKSa4yz10Yi46DMqaJXM/baeEKZckXWZn
 6XDPjtBkCUTYBKfeMHW5WGA9w48PDphpvafp+eHaD2zF8MuGDW2RLjabuiviPud7tMFG+IALP
 baSEsrbmdyzC0chTmqgUUPGU7TYoSKbzLO72wcGMlZAacQNJN0z104iKQvp2pnvAHKpAlmUeT
 GxLkHq9muf07TWcvHSfWAvbMWjl+vxw1FMd
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.18.11-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

Thanks

Tested-by: rwarsow@gmx.de

