Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C2C5AEA1D
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiIFNj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240806AbiIFNhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:37:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC841EEFE;
        Tue,  6 Sep 2022 06:34:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D78D8B81632;
        Tue,  6 Sep 2022 13:34:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B533C433C1;
        Tue,  6 Sep 2022 13:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662471275;
        bh=HVSPuHlBxoDidAzhvR+Mhm54R/4PBLFeNLr76nrdaRk=;
        h=From:To:Cc:Subject:Date:From;
        b=YtvTgbI7bKz8Z/ntOzCICPkh8uB53xZU3ojxz/0DRcMfdVnCKKFaLiduD+1GZ02fk
         I+TgdEhD0BqsGGl+jzV/LK9ZUY0DR+dFnvc/5RHGL4v5keRtwaQIzsXh5WktaSsQZA
         0j2BeYaRO6nWdgrI6U4F+Do1JhqfUcBnWogkXLx3Pz22/E8j7QP7PrM/O+VCEB2uqo
         mm905A57ZdBCcRX1EQ7pVy1rHRe3YwPIkEMPNdAkcynoGP1XYyVG6ZUAoF6TlE3kal
         J0TzxOf6hp6Ztu7Jb/Vjs114dVbnLO4yb49+x2su2CKjLLrFXNrgAY50kBknXheXEk
         yeJCNZgBLOWQQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oVYis-0006sv-B4; Tue, 06 Sep 2022 15:34:39 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH stable-5.4 0/3] USB: stable backports to 5.4
Date:   Tue,  6 Sep 2022 15:34:32 +0200
Message-Id: <20220906133435.26452-1-johan@kernel.org>
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

Here are backports of the three patches that didn't apply to 5.4.

Johan


Johan Hovold (3):
  usb: dwc3: qcom: fix use-after-free on runtime-PM wakeup
  USB: serial: ch341: fix lost character on LCR updates
  USB: serial: ch341: fix disabled rx timer on older devices

 drivers/usb/dwc3/dwc3-qcom.c | 14 +++++++++++++-
 drivers/usb/dwc3/host.c      |  1 +
 drivers/usb/serial/ch341.c   | 15 +++++++++++++--
 3 files changed, 27 insertions(+), 3 deletions(-)

-- 
2.35.1

