Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C74CA1EDC1
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729929AbfEOLNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:13:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729896AbfEOLNI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:13:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C567420644;
        Wed, 15 May 2019 11:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918788;
        bh=NQmfRXX5E4NyWdw6oYf7TSksuQ8l64eBkhFcOl1ifTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FFs4fdBUn2Y/MoeHeuo8Fc/HLNwn9Hf8GmBlnjN3ghe0JmBXIYr/dO031q2wzTOoV
         TZjPcKdP/gVgrQKWcfzg1hTpoe0IofmzR6OuxiJ2VYqvXECDNThb3d73D7xMIQRXeK
         f6vbTf0HCM0Vkz8LSU5G2iHKszcgry5MRLXceMQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 251/266] Documentation: Correct the possible MDS sysfs values
Date:   Wed, 15 May 2019 12:55:58 +0200
Message-Id: <20190515090731.506456823@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyler Hicks <tyhicks@canonical.com>

commit ea01668f9f43021b28b3f4d5ffad50106a1e1301 upstream.

Adjust the last two rows in the table that display possible values when
MDS mitigation is enabled. They both were slightly innacurate.

In addition, convert the table of possible values and their descriptions
to a list-table. The simple table format uses the top border of equals
signs to determine cell width which resulted in the first column being
far too wide in comparison to the second column that contained the
majority of the text.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 4.4: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/hw-vuln/mds.rst |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

--- a/Documentation/hw-vuln/mds.rst
+++ b/Documentation/hw-vuln/mds.rst
@@ -95,22 +95,19 @@ mitigations are active. The relevant sys
 
 The possible values in this file are:
 
-  =========================================   =================================
-  'Not affected'				The processor is not vulnerable
+  .. list-table::
 
-  'Vulnerable'					The processor is vulnerable,
-						but no mitigation enabled
-
-  'Vulnerable: Clear CPU buffers attempted'	The processor is vulnerable but
-						microcode is not updated.
-						The mitigation is enabled on a
-						best effort basis.
-						See :ref:`vmwerv`
-
-  'Mitigation: CPU buffer clear'		The processor is vulnerable and the
-						CPU buffer clearing mitigation is
-						enabled.
-  =========================================   =================================
+     * - 'Not affected'
+       - The processor is not vulnerable
+     * - 'Vulnerable'
+       - The processor is vulnerable, but no mitigation enabled
+     * - 'Vulnerable: Clear CPU buffers attempted, no microcode'
+       - The processor is vulnerable but microcode is not updated.
+
+         The mitigation is enabled on a best effort basis. See :ref:`vmwerv`
+     * - 'Mitigation: Clear CPU buffers'
+       - The processor is vulnerable and the CPU buffer clearing mitigation is
+         enabled.
 
 If the processor is vulnerable then the following information is appended
 to the above information:


