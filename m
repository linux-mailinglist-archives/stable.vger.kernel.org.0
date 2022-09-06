Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 059F85AE801
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 14:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240047AbiIFMZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 08:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240179AbiIFMYy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 08:24:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEE67F0A8;
        Tue,  6 Sep 2022 05:21:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D781B818B2;
        Tue,  6 Sep 2022 12:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C2FC433B5;
        Tue,  6 Sep 2022 12:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662466889;
        bh=3EctEuCB2/bX9NqB/p4FI8Z33UMK4DnMe+o+nvegim0=;
        h=From:To:Cc:Subject:Date:From;
        b=SjOg5gcAZw4gReK+bFz6lnWJIwFJ+yVM/C8UhoTNa+BoKPkdHLUn/TKgw/AZ9Rgsh
         lGgl8iSgktkd2p/gClh7ZuJSqFCXZdEZZTwlsL0pjghbuIIlhbHPi8OvdbwtZIZoH/
         y3gO3j+D7F0uNb3NwprM3guHyhyQtOGdLdrUf7fciWYecaLQUl/6wjMMNVGyFSk80t
         h4cpdjahOAlkCYKuHZYC6GR8UB7izR75jOizbaUz9zeXe0xRtvMLJuEmtDgy3Z1eyT
         vLTRvGmeK7LavKIbBo5B6bGgGQgIumGO4H+xyqnlnQWuLhhktO9L+KTxXCb5vz479c
         v0eXy9XJP7TeQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oVXaA-00089S-7T; Tue, 06 Sep 2022 14:21:34 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH stable-5.15 0/2] USB: serial: ch341: backports to 5.15
Date:   Tue,  6 Sep 2022 14:21:25 +0200
Message-Id: <20220906122127.31321-1-johan@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Here are backports of two patches that failed to apply to 5.15 and older
stable trees.

Only the first one actually needed to have some context adjusted.

Johan


Johan Hovold (2):
  USB: serial: ch341: fix lost character on LCR updates
  USB: serial: ch341: fix disabled rx timer on older devices

 drivers/usb/serial/ch341.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

-- 
2.35.1

