Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67EDC2F13EE
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbhAKNQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:16:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:35276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732519AbhAKNQ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:16:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31918223E8;
        Mon, 11 Jan 2021 13:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371002;
        bh=kdYSfKVbYnMc1HgF/pJtkANCjq8Z3mW9TuRs6QU4TNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UUMVpoAXYGsmTACYhrqfD49occ+0Nb8DvZFuhrzfFPl54RoTdq33IYoHB4IZaq9M+
         +0cuTA72KCtYnW4/yH7n5ewFpgpavxHFqZNny8MJWPXXlZCGtkuZQu1z2zJ6ITPozJ
         CXUIxUjuB8pa4VIHdVO2/jV0mHW5sBhpZjZT1m90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 068/145] kbuild: dont hardcode depmod path
Date:   Mon, 11 Jan 2021 14:01:32 +0100
Message-Id: <20210111130051.821753041@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominique Martinet <asmadeus@codewreck.org>

commit 436e980e2ed526832de822cbf13c317a458b78e1 upstream.

depmod is not guaranteed to be in /sbin, just let make look for
it in the path like all the other invoked programs

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -450,7 +450,7 @@ LEX		= flex
 YACC		= bison
 AWK		= awk
 INSTALLKERNEL  := installkernel
-DEPMOD		= /sbin/depmod
+DEPMOD		= depmod
 PERL		= perl
 PYTHON		= python
 PYTHON3		= python3


