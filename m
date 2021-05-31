Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C783968DE
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 22:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbhEaUdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 16:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbhEaUct (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 16:32:49 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F66C061574;
        Mon, 31 May 2021 13:30:30 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lnoYO-000F87-M7; Mon, 31 May 2021 22:30:28 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v4.9 00/10] wireless security fixes backports
Date:   Mon, 31 May 2021 22:30:11 +0200
Message-Id: <20210531203021.180010-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

One or two of the patches here were already applied since they
applied cleanly, but I'm resending the whole set for review now
anyway.

johannes



