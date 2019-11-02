Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 851FFECF2B
	for <lists+stable@lfdr.de>; Sat,  2 Nov 2019 15:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfKBOgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Nov 2019 10:36:10 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:60888 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbfKBOgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 2 Nov 2019 10:36:10 -0400
Received: from [IPv6:2001:4dd6:fcbc:0:458:8bb2:1939:dc7b] (2001-4dd6-fcbc-0-458-8bb2-1939-dc7b.ipv6dyn.netcologne.de [IPv6:2001:4dd6:fcbc:0:458:8bb2:1939:dc7b])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: whissi)
        by smtp.gentoo.org (Postfix) with ESMTPSA id DB73834C6ED;
        Sat,  2 Nov 2019 14:36:08 +0000 (UTC)
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     luciano.coelho@intel.com
From:   Thomas Deutschmann <whissi@gentoo.org>
Subject: Please backport 12e36d98d3e for 5.1+: iwlwifi: exclude GEO SAR
 support for 3168
Organization: Gentoo Foundation, Inc
Message-ID: <7a5f833a-3183-6a64-cd35-80d131343089@gentoo.org>
Date:   Sat, 2 Nov 2019 15:36:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

please backport

<<<<snip
From 12e36d98d3e5acf5fc57774e0a15906d55f30cb9 Mon Sep 17 00:00:00 2001
From: Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 8 Oct 2019 13:10:53 +0300
Subject: iwlwifi: exclude GEO SAR support for 3168

We currently support two NICs in FW version 29, namely 7265D and 3168.
Out of these, only 7265D supports GEO SAR, so adjust the function that
checks for it accordingly.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Fixes: f5a47fae6aa3 ("iwlwifi: mvm: fix version check for
GEO_TX_POWER_LIMIT support")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
snap>>>

This was the first patch of a 2 patch patch series. The second patch,
aa0cc7dde17 ("iwlwifi: pcie: change qu with jf devices to use qu
configuration") had "Cc: stable@vger.kernel.org # 5.1+" and was added.
The first one was missed.


-- 
Regards,
Thomas Deutschmann / Gentoo Linux Developer
C4DD 695F A713 8F24 2AA1 5638 5849 7EE5 1D5D 74A5
