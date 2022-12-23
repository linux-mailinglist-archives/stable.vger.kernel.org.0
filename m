Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 482DF655082
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 13:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236227AbiLWMl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 07:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236362AbiLWMlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 07:41:31 -0500
Received: from factor-ts.ru (mail.factor-ts.ru [194.154.76.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD283B401
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 04:41:14 -0800 (PST)
Received: from localhost.localdomain (unknown [89.23.32.60])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by factor-ts.ru (Postfix) with ESMTPSA id 237CD5EF12FA;
        Fri, 23 Dec 2022 15:34:22 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=factor-ts.ru; s=555;
        t=1671798862; bh=PByfWUc4arZwxo16OpsnXF/3bAn2GTRBg/fm3iBxQhY=;
        h=From:To:Cc:Subject:Date;
        b=iCxHMYn1BO6SKUdpYy2I+Zo/MrRSHSHaMCxqScYwNlQdQFCcVgrLNn24SIQXQDT/7
         EhdvQVw87dQjY6L4F1pybZFoy4ee/S26fC/AJw7xGtXoBHVBClaW6T2c99NIcGo7Sd
         mpQr0OW76ivkDe6Bsi7QiHz0wslwNjq90/NPHo5E=
From:   Semyon Verchenko <semverchenko@factor-ts.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Semyon Verchenko <semverchenko@factor-ts.ru>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: [PATCH 5.10 0/2] wifi: rtlwifi: 8192de: fix IQK reload checking
Date:   Fri, 23 Dec 2022 15:34:14 +0300
Message-Id: <20221223123416.71557-1-semverchenko@factor-ts.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MailScanner-ID: 237CD5EF12FA.A36BF
X-MailScanner: Found to be clean
X-MailScanner-From: semverchenko@factor-ts.ru
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SVACE reports always true condition issue at
tl92d_phy_reload_iqk_setting() in 5.10 stable releases. The problem has
been fixed by the following patches which can be cleanly applied to the
5.10 branch.

Found by Linux Verification Center (linuxtesting.org) with SVACE.
