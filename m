Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3115171E55
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388360AbgB0OJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:09:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:47186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388364AbgB0OJO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:09:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B304424656;
        Thu, 27 Feb 2020 14:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812554;
        bh=chR6BQ7aV20aKrhv3+T7oUb3YyDnnvGFmO+qnTOjOxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZTxmb+J1IY23x1Q93TIBoNp/WBhopcn1aOKh2cPoEAOpw8qbTEalqw/n1tTCXry8
         3RRQn3lKJ2Ks1vuXbb87MbRTMpOHBW6Hi1gPvhRxbXAnvgggQF1nTo7UaeuOZ6ZyZN
         3JygUQJtl7AAxaJh33XPEQlyJDZ+6AMdAcGY7P0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.4 060/135] MAINTAINERS: Update drm/i915 bug filing URL
Date:   Thu, 27 Feb 2020 14:36:40 +0100
Message-Id: <20200227132238.071476244@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

commit 96228b7df33f8eb9006f8ae96949400aed9bd303 upstream.

We've moved from bugzilla to gitlab.

Cc: stable@vger.kernel.org
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200212160434.6437-1-jani.nikula@intel.com
(cherry picked from commit 3a6a4f0810c8ade6f1ff63c34aa9834176b9d88b)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8201,7 +8201,7 @@ M:	Joonas Lahtinen <joonas.lahtinen@linu
 M:	Rodrigo Vivi <rodrigo.vivi@intel.com>
 L:	intel-gfx@lists.freedesktop.org
 W:	https://01.org/linuxgraphics/
-B:	https://01.org/linuxgraphics/documentation/how-report-bugs
+B:	https://gitlab.freedesktop.org/drm/intel/-/wikis/How-to-file-i915-bugs
 C:	irc://chat.freenode.net/intel-gfx
 Q:	http://patchwork.freedesktop.org/project/intel-gfx/
 T:	git git://anongit.freedesktop.org/drm-intel


