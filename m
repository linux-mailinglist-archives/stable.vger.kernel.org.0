Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAC14A95F4
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357388AbiBDJV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:21:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40582 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357426AbiBDJVM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:21:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A686615C6;
        Fri,  4 Feb 2022 09:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6F1C004E1;
        Fri,  4 Feb 2022 09:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966471;
        bh=/Pp8SlxXCCL22wDsYOvb5Wwy21cTYp+xDoOEpKIfey4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WuWgvAN551pF9BCix1GuWjWh11JnHP5wskjyILmhWeRCuTSpbdtMDWsTDSJLse+4Q
         Rgoxmez7QZJSfzIufvE+b0WetHs0hoBOafO9wbVxRkSd0GDTovvlq87tzwQ6oqzSy7
         RMedgktXlyH0m+2heMDIbOuAMuoK19Y5QGHW6syQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.10 10/25] x86/mce: Add Xeon Sapphire Rapids to list of CPUs that support PPIN
Date:   Fri,  4 Feb 2022 10:20:17 +0100
Message-Id: <20220204091914.626046318@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091914.280602669@linuxfoundation.org>
References: <20220204091914.280602669@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

commit a331f5fdd36dba1ffb0239a4dfaaf1df91ff1aab upstream.

New CPU model, same MSRs to control and read the inventory number.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20210319173919.291428-1-tony.luck@intel.com
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
+	case INTEL_FAM6_SAPPHIRERAPIDS_X:
 	case INTEL_FAM6_XEON_PHI_KNL:
 	case INTEL_FAM6_XEON_PHI_KNM:
 


