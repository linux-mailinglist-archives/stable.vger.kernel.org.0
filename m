Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E84129A86
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 20:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfLWTm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 14:42:56 -0500
Received: from [66.170.99.2] ([66.170.99.2]:2580 "EHLO
        sid-build-box.eng.vmware.com" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726824AbfLWTm4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Dec 2019 14:42:56 -0500
Received: by sid-build-box.eng.vmware.com (Postfix, from userid 1000)
        id 04661BA17B7; Tue, 24 Dec 2019 01:07:15 +0530 (IST)
From:   Siddharth Chandrasekaran <csiddharth@vmware.com>
To:     torvalds@linux-foundation.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org, jannh@google.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        siddharth@embedjournal.com,
        Siddharth Chandrasekaran <csiddharth@vmware.com>
Subject: [PATCH 4.19 0/2] Backport readdir sanity checking patches
Date:   Tue, 24 Dec 2019 01:06:28 +0530
Message-Id: <cover.1577128883.git.csiddharth@vmware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1577128778.git.csiddharth@vmware.com>
References: <cover.1577128778.git.csiddharth@vmware.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

This patchset is a backport of upstream commits that makes getdents() and
getdents64() do sanity checking on the pathname that it gives to user
space.

Sid

Linus Torvalds (2):
  Make filldir[64]() verify the directory entry filename is valid
  filldir[64]: remove WARN_ON_ONCE() for bad directory entries

 fs/readdir.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

-- 
2.7.4

