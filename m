Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B73A939130
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbfFGPmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:42:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730512AbfFGPmW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:42:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 550E02147A;
        Fri,  7 Jun 2019 15:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922141;
        bh=K+5bd6fJvvBu5PYuyR40E8AsVzhI4d5StAL0HDet8hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0NUzi6cy39aTmd9kJoJk5xKLnhrtulT9X2CkRbJG3tPQ5JoNwEqD0p/lI9xa5po3Y
         CN82v3umW1pwLzfGxzn/pHBkYxmSK0wRd1/7XqX1pZc+ZmZyHg4SFw7w0uj4VyUogZ
         lrqbDOOBjnQW2yot6cKOE8wRkaIDBR5tOxUHsUBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 4.14 52/69] docs: Fix conf.py for Sphinx 2.0
Date:   Fri,  7 Jun 2019 17:39:33 +0200
Message-Id: <20190607153854.682187993@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.271562617@linuxfoundation.org>
References: <20190607153848.271562617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Corbet <corbet@lwn.net>

commit 3bc8088464712fdcb078eefb68837ccfcc413c88 upstream.

Our version check in Documentation/conf.py never envisioned a world where
Sphinx moved beyond 1.x.  Now that the unthinkable has happened, fix our
version check to handle higher version numbers correctly.

Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/conf.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -37,7 +37,7 @@ needs_sphinx = '1.3'
 extensions = ['kerneldoc', 'rstFlatTable', 'kernel_include', 'cdomain', 'kfigure']
 
 # The name of the math extension changed on Sphinx 1.4
-if major == 1 and minor > 3:
+if (major == 1 and minor > 3) or (major > 1):
     extensions.append("sphinx.ext.imgmath")
 else:
     extensions.append("sphinx.ext.pngmath")


