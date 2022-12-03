Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9E464197E
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 23:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiLCWgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 17:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiLCWgM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 17:36:12 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351EC1A227;
        Sat,  3 Dec 2022 14:36:11 -0800 (PST)
Received: from localhost.localdomain (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 4B6E8419E9CA;
        Sat,  3 Dec 2022 22:36:09 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 4B6E8419E9CA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1670106969;
        bh=clHJo2Gmz5r6hdvyvONrV9lJgxf5iVxbUmGef/DQeAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=svRMQsm35moE/fEAmf+vuZ2CSEWAxkDpyB7z5t0Sy6pjzlNxybPu3uAN0Y/j5jKtP
         kOGfTRXbuDXGVxZfYyfqt7M5qP/0dDSJN/F7lL4XLXimToDgFBpT7mzJB5hDEXU9Jr
         Tcvm3M+gcf31kGR0pkrGebBLloMNxV0CDcFmfshM=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>, linux-kernel@vger.kernel.org,
        Daniel Starke <daniel.starke@siemens.com>,
        jirislaby@kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org, Pavel Machek <pavel@denx.de>
Subject: [PATCH 5.19 0/2] tty: n_gsm: revert tx_mutex usage
Date:   Sun,  4 Dec 2022 01:35:24 +0300
Message-Id: <20221203223526.11185-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <Y4tQjdqL2vbDnTX8@kroah.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks for notice, n_gsm tx_mutex patches just were added to 5.19, not
5.15, so we need to revert them.

I'm sorry for the inconvenience with 5.10 revert patch, fixed that in
the corresponding thread.
