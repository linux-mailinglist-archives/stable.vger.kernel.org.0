Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1BB1EDAF
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729757AbfEOLMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:12:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729740AbfEOLMU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:12:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99BA22084E;
        Wed, 15 May 2019 11:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918740;
        bh=cXkUWaJKFNGT0UDCgndx8rzLPOQvubfRIOTueJoC8eU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/HmI9G8fsBMMMcqTq2DwDPofahND40EbptZGcpYpanjVcitbiNDwMhD04Jf9FPNG
         1SSlzEDqyBt4w40DbsBbfp34MTWo75GPB0uF+et1arl5XTHvkNHAhH7kRXQzCCbp1Y
         cmBdcHltcGxcxEXBzyXaVAvRMlIGwVd24YPLGw8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tyler Hicks <tyhicks@canonical.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 245/266] x86/speculation/mds: Fix comment
Date:   Wed, 15 May 2019 12:55:52 +0200
Message-Id: <20190515090731.296093965@linuxfoundation.org>
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

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

commit cae5ec342645746d617dd420d206e1588d47768a upstream.

s/L1TF/MDS/

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
[bwh: Backported to 4.4: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -210,7 +210,7 @@ static void x86_amd_ssb_disable(void)
 #undef pr_fmt
 #define pr_fmt(fmt)	"MDS: " fmt
 
-/* Default mitigation for L1TF-affected CPUs */
+/* Default mitigation for MDS-affected CPUs */
 static enum mds_mitigations mds_mitigation = MDS_MITIGATION_FULL;
 
 static const char * const mds_strings[] = {


