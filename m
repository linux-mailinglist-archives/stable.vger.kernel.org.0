Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF844A4283
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359830AbiAaLMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:12:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42912 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377357AbiAaLJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:09:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6889060E76;
        Mon, 31 Jan 2022 11:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF0FC340E8;
        Mon, 31 Jan 2022 11:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627396;
        bh=Xg9f6CFllZYrzcO1n0gxcgeybqgoqA71gctmrnJvsx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nyf7ZE1gMIWJgxubvO6ZHNRJtUvx+3/tZNIsQTeLkr+fw9c0ZSOoZKdYWw91eAIZ7
         jX5j3nxfHW6E4lHxYkt8UppWISA2p75Vg1yLaATdJueDf3dV0E+hEe3Hk2PCa09Rwx
         OxLw5O9EiE0q97GjTzWN+aSyhFnkmy2U+7IEMCNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ailin Xu <ailin.xu@intel.com>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.15 071/171] x86/cpu: Add Xeon Icelake-D to list of CPUs that support PPIN
Date:   Mon, 31 Jan 2022 11:55:36 +0100
Message-Id: <20220131105232.439940276@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

commit e464121f2d40eabc7d11823fb26db807ce945df4 upstream.

Missed adding the Icelake-D CPU to the list. It uses the same MSRs
to control and read the inventory number as all the other models.

Fixes: dc6b025de95b ("x86/mce: Add Xeon Icelake to list of CPUs that support PPIN")
Reported-by: Ailin Xu <ailin.xu@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220121174743.1875294-2-tony.luck@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -486,6 +486,7 @@ static void intel_ppin_init(struct cpuin
 	case INTEL_FAM6_BROADWELL_X:
 	case INTEL_FAM6_SKYLAKE_X:
 	case INTEL_FAM6_ICELAKE_X:
+	case INTEL_FAM6_ICELAKE_D:
 	case INTEL_FAM6_SAPPHIRERAPIDS_X:
 	case INTEL_FAM6_XEON_PHI_KNL:
 	case INTEL_FAM6_XEON_PHI_KNM:


