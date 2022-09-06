Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1195AE736
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 14:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238351AbiIFMHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 08:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238137AbiIFMHO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 08:07:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F5D74B90;
        Tue,  6 Sep 2022 05:07:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 905EBCE173E;
        Tue,  6 Sep 2022 12:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D70C433D6;
        Tue,  6 Sep 2022 12:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662466026;
        bh=Voi7EwuGLOxyTnSvu/me8FUDDpxE4VhtOk/qF9mwJM4=;
        h=From:To:Cc:Subject:Date:From;
        b=WORO3HlLTK8pcKr8/oher+FPjdq0Dms+Wz0RvyZ7Lb5UJrOQt1cisQtKUW4mi7Zxa
         9S/jgtVcZYH5e2xc/0ySga3ha1vhQvufLa8Rt1Txe8kXa7d4hY5pF6/cfGyv1T7GJ1
         GYhxMZ3sgtDYf1lLohvcBvJkKx0t6eWqxUqlDRenaswYzuvj0gmnhpVhMaMPhByUKp
         G6HsVQHO6OVRkwaRnZRDD7vV9G34a+bhW3Uo87o2C0n95YhJ2VZ+2i3sYGVtdTEOPf
         9/9E5KFotIiBEry7l3rqNB+yFV9TJZi9y7emGQZucjOdXGvfCYYBlYk3GcAKp7ojav
         Kefsfdm6ObzNg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oVXME-00050G-Rp; Tue, 06 Sep 2022 14:07:10 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH stable-5.15 0/3] usb: dwc3: 5.15 backports
Date:   Tue,  6 Sep 2022 14:06:59 +0200
Message-Id: <20220906120702.19219-1-johan@kernel.org>
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

Here are backports of the three patches that failed to apply to 5.15 due
to trivial context conflicts.

Hopefully they apply to the older stable trees as well as-is.

Note that the last patch depends on features that were not added until
5.9 as mentioned in the commit message. Note that the author of that
patch did not add a stable tag for this one, but backporting shouldn't
hurt.

Johan


Johan Hovold (3):
  usb: dwc3: fix PHY disable sequence
  usb: dwc3: qcom: fix use-after-free on runtime-PM wakeup
  usb: dwc3: disable USB core PHY management

 drivers/usb/dwc3/core.c      | 19 ++++++++++---------
 drivers/usb/dwc3/dwc3-qcom.c | 14 +++++++++++++-
 drivers/usb/dwc3/host.c      | 11 +++++++++++
 3 files changed, 34 insertions(+), 10 deletions(-)

-- 
2.35.1

