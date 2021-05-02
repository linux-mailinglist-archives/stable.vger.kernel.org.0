Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2274F370AED
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 11:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhEBJvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 05:51:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229651AbhEBJvz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 05:51:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDC71610FA;
        Sun,  2 May 2021 09:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619949064;
        bh=iEyo6sI8yMTVENnxsG6IPpQ24Z/X79z6MTOI3F9ywnk=;
        h=From:To:Cc:Subject:Date:From;
        b=XuFxVeucwwlT7hhyOEYVQH13gnQgWUnuOUHAWDRos5M372zFVg4Yq1SbrJ7RUP1eM
         vc9SfeA/JVt2QE5VOOeJqnO/b/oUtfWc/6aaKKyr619+JUusvDpJo4k2fDf0ZdTl4+
         tjqCAgevoK2TNk+gvVkxIs6ISFWjLLN17XA0vkWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.116
Date:   Sun,  2 May 2021 11:51:00 +0200
Message-Id: <161994906112085@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.116 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                      |    2 
 kernel/bpf/verifier.c                                         |  233 ++++++----
 tools/testing/selftests/bpf/verifier/bounds_deduction.c       |   21 
 tools/testing/selftests/bpf/verifier/bounds_mix_sign_unsign.c |   13 
 tools/testing/selftests/bpf/verifier/unpriv.c                 |    2 
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c        |    6 
 6 files changed, 174 insertions(+), 103 deletions(-)

Daniel Borkmann (8):
      bpf: Move off_reg into sanitize_ptr_alu
      bpf: Ensure off_reg has no mixed signed bounds for all types
      bpf: Rework ptr_limit into alu_limit and add common error path
      bpf: Improve verifier error messages for users
      bpf: Refactor and streamline bounds check into helper
      bpf: Move sanitize_val_alu out of op switch
      bpf: Tighten speculative pointer arithmetic mask
      bpf: Update selftests to reflect new error states

Greg Kroah-Hartman (1):
      Linux 5.4.116

