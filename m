Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3097A6DC4C9
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 11:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjDJJCa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 10 Apr 2023 05:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjDJJC3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 05:02:29 -0400
X-Greylist: delayed 1540 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 10 Apr 2023 02:02:28 PDT
Received: from tilde.cafe (tilde.cafe [51.222.161.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1077A2D63
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 02:02:27 -0700 (PDT)
Received: from [127.0.0.1] (196.97.221.62.dyn.idknet.com [62.221.97.196])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by tilde.cafe (Postfix) with ESMTPSA id C69EB204A4;
        Mon, 10 Apr 2023 04:36:44 -0400 (EDT)
Date:   Mon, 10 Apr 2023 11:36:41 +0300
From:   Acid Bong <acidbong@tilde.cafe>
To:     gregkh@linuxfoundation.org
CC:     stable@vger.kernel.org
Subject: No updates in rolling branches
Message-ID: <D5189C7F-B690-4296-A005-A2C0A1EC85F9@tilde.cafe>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-0.0 required=5.0 tests=SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi there, hello,

I've noticed that the recent (at the moment) releases 6.2.10 and 6.1.23 weren't merged into linux-rolling-stable and linux-rolling-lts respectively. Is there something wrong with them that they require the delay?

Kind regards,
~acidbong
