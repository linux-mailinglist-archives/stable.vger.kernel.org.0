Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B052B9D9B
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 23:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgKSWXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 17:23:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55824 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgKSWXt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 17:23:49 -0500
Received: from 3.general.kamal.us.vpn ([10.172.68.53] helo=ascalon)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kamal@canonical.com>)
        id 1kfsLE-0005ey-RG; Thu, 19 Nov 2020 22:23:49 +0000
Received: from kamal by ascalon with local (Exim 4.90_1)
        (envelope-from <kamal@ascalon>)
        id 1kfsLB-0003aE-BZ; Thu, 19 Nov 2020 14:23:45 -0800
From:   Kamal Mostafa <kamal@canonical.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: pick up "usb: dwc2: Avoid leaving the error_debugfs label unused"
Date:   Thu, 19 Nov 2020 14:23:42 -0800
Message-Id: <20201119222342.13619-1-kamal@canonical.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha-

To fix an unused-label warning, please pick up this mainline commit:

190bb01b72d2 ("usb: dwc2: Avoid leaving the error_debugfs label unused")

in these stable branches:

    linux-5.8.y
    linux-5.9.y

For reference, the warning was introduced by the stable backports of
[mainline] e1c08cf23172 ("usb: dwc2: Add missing cleanups when usb_add_gadget_udc() fails")

Thanks!

 -Kamal
