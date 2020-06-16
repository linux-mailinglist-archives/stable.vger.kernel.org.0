Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E1F1FADA6
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 12:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgFPKOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 06:14:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726052AbgFPKOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 06:14:02 -0400
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3027620707;
        Tue, 16 Jun 2020 10:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592302442;
        bh=pb2xPqwS+ic4MQDhsY6L+SIR+95UApqkpps6LEE5YV8=;
        h=From:To:Cc:Subject:Date:From;
        b=LQtrYnuI9DwcLpg1gRW2LmAc9QmWsAJGc1yxbYJwTy7f1uUoZwsClGhE2cHiiIeNP
         ESm6Wk7fvYmgsyDMpn7NuRhgbq0VVlh2zczemyN92lIHnMP2gZ9nNETEodL0yEM03B
         EerVidan+F0ezPE1NQCmhWTGS0h3z1BXknoHZUNs=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/4] bootconfig: Fix quote-character issue and return value
Date:   Tue, 16 Jun 2020 19:13:58 +0900
Message-Id: <159230243779.65555.11413773790099102781.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

This is the 2nd version of bootconfig bugfixes.
The previous version is here.

https://lkml.kernel.org/r/159197538852.80267.10091816844311950396.stgit@devnote2

This version fixes the patch description and modify(cleanup) code
according to Steve's comment.

Thank you,

---

Masami Hiramatsu (4):
      proc/bootconfig: Fix to use correct quotes for value
      tools/bootconfig: Fix to use correct quotes for value
      tools/bootconfig: Fix to return 0 if succeeded to show the bootconfig
      tools/bootconfig: Add testcase for show-command and quotes test


 fs/proc/bootconfig.c                |   15 ++++++++++-----
 tools/bootconfig/main.c             |   24 ++++++++++++++----------
 tools/bootconfig/test-bootconfig.sh |   10 ++++++++++
 3 files changed, 34 insertions(+), 15 deletions(-)

--
Masami Hiramatsu (Linaro) <mhiramat@kernel.org>
