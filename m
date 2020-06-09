Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E551F45C5
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732399AbgFIRsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:48:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732384AbgFIRsr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:48:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16430207F9;
        Tue,  9 Jun 2020 17:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591724927;
        bh=L7YJy0y9nLm8blOqjElc3xEZMQQ5twDSw/fGhd5AN1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hs0zG06/EC+oKQuvkoz5tq4yTKaGXxPkQLSeygvUL/1/sUCV3+wtx+CtsI6hL3mHa
         NBl78fFqDDnW8o/AdGHgplaB5/oe+MSz/Xvi1cJ3gTKhxP5KXt+fkdgTBMTZ2Na0Ns
         ODjcNgO/hRS9AfROGIUZTVc/cJ43jkvaHHhnkzDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.9 40/42] x86/speculation: Add Ivy Bridge to affected list
Date:   Tue,  9 Jun 2020 19:44:46 +0200
Message-Id: <20200609174019.965928408@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174015.379493548@linuxfoundation.org>
References: <20200609174015.379493548@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 3798cc4d106e91382bfe016caa2edada27c2bb3f upstream

Make the docs match the code.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/hw-vuln/special-register-buffer-data-sampling.rst |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/Documentation/hw-vuln/special-register-buffer-data-sampling.rst
+++ b/Documentation/hw-vuln/special-register-buffer-data-sampling.rst
@@ -27,6 +27,8 @@ by software using TSX_CTRL_MSR otherwise
   =============  ============  ========
   common name    Family_Model  Stepping
   =============  ============  ========
+  IvyBridge      06_3AH        All
+
   Haswell        06_3CH        All
   Haswell_L      06_45H        All
   Haswell_G      06_46H        All
@@ -37,9 +39,8 @@ by software using TSX_CTRL_MSR otherwise
   Skylake_L      06_4EH        All
   Skylake        06_5EH        All
 
-  Kabylake_L     06_8EH        <=0xC
-
-  Kabylake       06_9EH        <=0xD
+  Kabylake_L     06_8EH        <= 0xC
+  Kabylake       06_9EH        <= 0xD
   =============  ============  ========
 
 Related CVEs


