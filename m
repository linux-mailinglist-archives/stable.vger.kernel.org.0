Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C369DF3AF
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 18:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfJUQ4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 12:56:41 -0400
Received: from forward105j.mail.yandex.net ([5.45.198.248]:51155 "EHLO
        forward105j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726276AbfJUQ4k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 12:56:40 -0400
Received: from forward101q.mail.yandex.net (forward101q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb98])
        by forward105j.mail.yandex.net (Yandex) with ESMTP id 52430B206C8
        for <stable@vger.kernel.org>; Mon, 21 Oct 2019 19:50:20 +0300 (MSK)
Received: from mxback2q.mail.yandex.net (mxback2q.mail.yandex.net [IPv6:2a02:6b8:c0e:40:0:640:9c8c:4946])
        by forward101q.mail.yandex.net (Yandex) with ESMTP id 4B161CF4000F
        for <stable@vger.kernel.org>; Mon, 21 Oct 2019 19:50:20 +0300 (MSK)
Received: from vla3-2bcfd5e94671.qloud-c.yandex.net (vla3-2bcfd5e94671.qloud-c.yandex.net [2a02:6b8:c15:350f:0:640:2bcf:d5e9])
        by mxback2q.mail.yandex.net (nwsmtp/Yandex) with ESMTP id FUti0RtGHH-oKG4BYN7;
        Mon, 21 Oct 2019 19:50:20 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; s=mail; t=1571676620;
        bh=9OT4b20GxQ/P+FpNhedSMrs89u9RhhukhGCp/kXr4mU=;
        h=Subject:To:From:Date:Message-Id;
        b=gfqgiihPaoU48EXCfpqR6FeAR1Q7Adi5WIa+HbYwgYIkXWXUiwOftjba/WgC0+OTG
         WQ/MgISxEMsTC6s5wia//uXKro+ce6EBHe56/LbXWZhij2kM3egXMfTXKnBetfOqvg
         jQ0369xe+iabPer/fn+r3L13FKSaMiyk0kUeruUc=
Authentication-Results: mxback2q.mail.yandex.net; dkim=pass header.i=@flygoat.com
Received: by vla3-2bcfd5e94671.qloud-c.yandex.net (nwsmtp/Yandex) with ESMTPSA id rut2FNHrRJ-oEWSTk9D;
        Mon, 21 Oct 2019 19:50:17 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     stable@vger.kernel.org
Subject: Two MIPS fixes backport 
Date:   Tue, 22 Oct 2019 00:49:50 +0800
Message-Id: <20191021164956.1731-1-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi stable folks,

Here are backports of some MIPS fixes failed to apply to stable
tree recently, please take them.

Thanks.
--
Jiaxun Yang


