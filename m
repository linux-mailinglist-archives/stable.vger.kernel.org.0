Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B0D63B240
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 20:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbiK1TaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 14:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233510AbiK1TaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 14:30:06 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1C12CC92
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 11:30:05 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id bx10so6514156wrb.0
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 11:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qyAC9pGA3bM4rM543zM+YmJ53hSTj7w0+tIgvP3ytYE=;
        b=BuD8lWara1niE7mnh/o5qy3U4E2CWGxLIaPpl0XbX8rw2hyPnp/nz/cSZHBqSuMHWn
         dpYpeZlwIwC/Y7Vdh6MTJgkvZZIW8/XLhFRqneZqM8SuBkUbQbCi2oLxrQVvpMqHCZA+
         LFzWQiu41crvSAw/U20dwlrmQf5paHN5evgWb49hB3hX8LLUClYIcbFfnhMW1FWUYdZB
         wbKzG4BqWGPuF5lC8LZTnu9sIGIxucB2uUUNPVnnzpV7raTr8hkgE9aAyZ4F3Qb2i3sA
         bLYJ6ua8J6qBiUdqi16IAA/sgQQMVkT9K/s94foPpG/CusA9sVkrWhhKn2C5VTsT2Ec3
         fDWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qyAC9pGA3bM4rM543zM+YmJ53hSTj7w0+tIgvP3ytYE=;
        b=u2CbqfNlqAN85C/UGTv4J5OuB1MR+buHqskK3Kt3dpYIWU1a54wTmlNEtaxOY1Kl2E
         3YWuhmdhDZpXe0sPQTZCh3BUaHGftjSkNQ3oDmSiQywUvA6FJ7rG2fNWcHUqrSHiz5Bq
         PlHW2JjfZuU5uyBjBgYA6jo8Z1G2PjZTMlD/G+V02aFFWaLYQMkY9NS7PPsQ+ezbhtoA
         vsawTSd+9dVw5YJbHNVX7GpwE8K0lVOSbUQ3X+oGdWo8BfiAWgtFPaJs7B1XU4/cvLw+
         xoM8aPprh3yX15smoif0jQk3ddfgw80Xp9EGMA6nGTLrUbg3zO/tB5XNH/LH7QQd1CsA
         uRUg==
X-Gm-Message-State: ANoB5pmJalLEy17Q2j0eR5oxiN9Jxsahv7NBkUAhMpAsRed0BSEXie/j
        J4/0RSXeLVqmbm7ks3o0gqBmaEYi7dyrPEl6GjU=
X-Google-Smtp-Source: AA0mqf67sypwCCVf7CltBYA/W9XeoKINP8+XV8Y0KwDCCroIl/CGk0m6p+Qqi9Or+GbTMBQp+TDU/a5uKOXfIrZvc74=
X-Received: by 2002:adf:fe46:0:b0:242:13dd:c4a1 with SMTP id
 m6-20020adffe46000000b0024213ddc4a1mr5065977wrs.669.1669663803553; Mon, 28
 Nov 2022 11:30:03 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a5d:5a04:0:b0:236:8fa0:cf29 with HTTP; Mon, 28 Nov 2022
 11:30:03 -0800 (PST)
Reply-To: abrahamamesse@outlook.com
From:   Abraham Amesse <gmark3575@gmail.com>
Date:   Mon, 28 Nov 2022 19:30:03 +0000
Message-ID: <CAPG1wpO8r+h2wkfKoYwLJVzPLWYHutdTYJQVrBswTcjF0sxkCw@mail.gmail.com>
Subject: ///////'//////////Ugrent
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I am contacting you again further to my previous email which you never
responded to. Please confirm to me if you are still using this email
address. However, I apologize for any inconvenience.
