Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304B55AED0A
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241548AbiIFOUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242085AbiIFOTd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:19:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBA2240B9;
        Tue,  6 Sep 2022 06:50:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE651B818D8;
        Tue,  6 Sep 2022 13:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80943C43143;
        Tue,  6 Sep 2022 13:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662472155;
        bh=Nvbd0ye2ChcT2eUG/y6GoM/yq5LubBYPsAay5POGQ2o=;
        h=From:To:Cc:Subject:Date:From;
        b=UdAdwOTGZlv2yPSAOFBLSzpJkIUrvwNBcZM2+jPwzyLwiUb55e6hwTZq99vDQPpCf
         lxdpeT3/u39MpUi/DZfCXO4O6k/oJRlO7MhbT8F6AmI/bfNzSmLeQLNSHBnQRTJwTg
         NxIF8FTEAxbX2fvUPga1EygHGNuGeqLC2V/1dvYU5c0UTCo3pzTZ0kvDoFwwX+b6e2
         tSAnDNbR/qFngDFkWC6OICtuqu77I0QyugWEyJvtSdvpVd/vELgoIdaH/W4mGsKcgz
         USDHy5xdZVWgfixaDtANB9XlhOGCag8DsJW8IaERGn1I8ocLVn/lkdCJpMLoL7ZaRR
         mB0OkCAMwMVsw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oVYx4-00050O-JO; Tue, 06 Sep 2022 15:49:19 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH stable-4.19 0/4] USB: backports to 4.19
Date:   Tue,  6 Sep 2022 15:49:11 +0200
Message-Id: <20220906134915.19225-1-johan@kernel.org>
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

And here are the corresponding backports to 4.19.

Johan


Johan Hovold (4):
  usb: dwc3: fix PHY disable sequence
  usb: dwc3: qcom: fix use-after-free on runtime-PM wakeup
  USB: serial: ch341: fix lost character on LCR updates
  USB: serial: ch341: fix disabled rx timer on older devices

 drivers/usb/dwc3/core.c      | 19 ++++++++++---------
 drivers/usb/dwc3/dwc3-qcom.c | 14 +++++++++++++-
 drivers/usb/dwc3/host.c      |  1 +
 drivers/usb/serial/ch341.c   | 15 +++++++++++++--
 4 files changed, 37 insertions(+), 12 deletions(-)

-- 
2.35.1

