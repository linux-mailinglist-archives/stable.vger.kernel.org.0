Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868786E2A3F
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 20:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjDNSva convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 14 Apr 2023 14:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjDNSv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 14:51:29 -0400
Received: from tilde.cafe (tilde.cafe [51.222.161.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBCB65A8;
        Fri, 14 Apr 2023 11:51:27 -0700 (PDT)
Received: from localhost (124.250.94.80.dyn.idknet.com [80.94.250.124])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by tilde.cafe (Postfix) with ESMTPSA id 6AA1B20703;
        Fri, 14 Apr 2023 14:51:25 -0400 (EDT)
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 14 Apr 2023 21:51:23 +0300
Subject: Re: [REGRESSION] Asus X541UAK hangs on suspend and poweroff (v6.1.6
 onward)
Cc:     <linux-acpi@vger.kernel.org>, <regressions@lists.linux.dev>,
        <stable@vger.kernel.org>
From:   "Acid Bong" <acidbong@tilde.cafe>
To:     <acidbong@tilde.cafe>
Message-Id: <CRWPAKIQL542.31GZ9N30HQV3V@bong>
In-Reply-To: <CRWCUOAB4JKZ.3EKQN1TFFMVQL@bong>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For the readers: here's a copy of the letter as it should've looked (it
looks normally in the regressions archive, but wasn't parsed correctly
in stable and linux-acpi lores):
https://tilde.cafe/u/acidbong/kernel/pci-nomsi.txt
