Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C56F1F440A
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729875AbgFIR7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:59:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733156AbgFIRyy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:54:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FF6E20774;
        Tue,  9 Jun 2020 17:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725293;
        bh=KBJDsnC/ruZzhFkAosuSNvcMKVC5aIEuK5TDQj8MtJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrsFxg9lKy5VRXjh4P6wtSHNs+tCVj2Gmvt8BCvsxUTiF8mS1WBd8wPUfnqW9dukK
         ByVoI6ttZXIClCdrz5yy0kmdvSUEE8o9jCxwUEo+5Ifuw3kDLFChksIm1IVD0Dr2yI
         kS8UgKAUGhUGAZuLGAOA5TZPK+VIzLqw24UzdqVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.6 39/41] x86/speculation: Add Ivy Bridge to affected list
Date:   Tue,  9 Jun 2020 19:45:41 +0200
Message-Id: <20200609174115.821419119@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174112.129412236@linuxfoundation.org>
References: <20200609174112.129412236@linuxfoundation.org>
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
 Documentation/admin-guide/hw-vuln/special-register-buffer-data-sampling.rst |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/hw-vuln/special-register-buffer-data-sampling.rst
+++ b/Documentation/admin-guide/hw-vuln/special-register-buffer-data-sampling.rst
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


