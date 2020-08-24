Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34A224F382
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgHXICT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:02:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgHXICS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:02:18 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 509162074D;
        Mon, 24 Aug 2020 08:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598256138;
        bh=kG1OphosPwy5m1ITgI12ZiAxse53KWA5KDd78MUrY+0=;
        h=From:To:Cc:Subject:Date:From;
        b=CtHN/KcL+8SN5+Ma7XlAhqaQttsLMA66/EIPQAlfCYykkNH8UPABq79LKS+Awipkm
         ZdftfvN3vxnUOXPsHvvZSdPh+Wzvr7mDR7frhZMKPK809Jjp2DcGc88tmcd1EuZqQ+
         JLNYR/WN4LjHR64K9PJiKCuKSvZ5HoiMmNFd4aqQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kA7Qm-0067fK-Bz; Mon, 24 Aug 2020 09:02:16 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org
Subject: [STABLE 4.4 to 5.4][PATCH 0/2] epoll fixes
Date:   Mon, 24 Aug 2020 09:02:09 +0100
Message-Id: <20200824080211.1037550-1-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: stable@vger.kernel.org, gregkh@linuxfoundation.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Here's the backport for a couple of epoll fixes that don't cleanly
backport to anything older than 5.7. These backports cleanly apply
from 5.4 all the way to 4.4.

Thanks,

	M.

Al Viro (1):
  do_epoll_ctl(): clean the failure exits up a bit

Marc Zyngier (1):
  epoll: Keep a reference on files added to the check list

 fs/eventpoll.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

-- 
2.27.0

