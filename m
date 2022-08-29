Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCFD55A4924
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbiH2LUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiH2LTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:19:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB1B75FC2;
        Mon, 29 Aug 2022 04:13:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24ADD61211;
        Mon, 29 Aug 2022 11:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6AEC433C1;
        Mon, 29 Aug 2022 11:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771622;
        bh=vHOP5kvxzs+2Ky4SsWI9e/BdipXe6+F7K0c2gRIs+NQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aXdUlgZzBj/BaAxnccf7c4sNEpN0FTx1cTISoaNX3Yqyln+/iVz1Zzkbo/NbMr6O2
         tqYW9ub7Quk5d9HKhD8ympaicxiDqJGdhLZTcTqFM5jfrZFOAWpRN62G5K4MWwp+4E
         Sa3GKXDroxWhdU2vH0uVM78Y44bwoDZS87ebVy5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Salvatore Bonaccorso <carnil@debian.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.15 128/136] Documentation/ABI: Mention retbleed vulnerability info file for sysfs
Date:   Mon, 29 Aug 2022 12:59:55 +0200
Message-Id: <20220829105809.949023168@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Salvatore Bonaccorso <carnil@debian.org>

commit 00da0cb385d05a89226e150a102eb49d8abb0359 upstream.

While reporting for the AMD retbleed vulnerability was added in

  6b80b59b3555 ("x86/bugs: Report AMD retbleed vulnerability")

the new sysfs file was not mentioned so far in the ABI documentation for
sysfs-devices-system-cpu. Fix that.

Fixes: 6b80b59b3555 ("x86/bugs: Report AMD retbleed vulnerability")
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20220801091529.325327-1-carnil@debian.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -521,6 +521,7 @@ What:		/sys/devices/system/cpu/vulnerabi
 		/sys/devices/system/cpu/vulnerabilities/tsx_async_abort
 		/sys/devices/system/cpu/vulnerabilities/itlb_multihit
 		/sys/devices/system/cpu/vulnerabilities/mmio_stale_data
+		/sys/devices/system/cpu/vulnerabilities/retbleed
 Date:		January 2018
 Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
 Description:	Information about CPU vulnerabilities


