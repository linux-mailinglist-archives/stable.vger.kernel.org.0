Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCC729CCDC
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 11:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbfHZJwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 05:52:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:41294 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726616AbfHZJwq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 05:52:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B03F9B623;
        Mon, 26 Aug 2019 09:52:45 +0000 (UTC)
Message-ID: <1566813164.5278.3.camel@suse.de>
Subject: iwlwifi: mvm: disable TX-AMSDU on older NICs
From:   Jean Delvare <jdelvare@suse.de>
To:     stable <stable@vger.kernel.org>
Cc:     Johannes Berg <johannes.berg@intel.com>
Date:   Mon, 26 Aug 2019 11:52:44 +0200
Organization: Suse Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please consider picking:

commit cfb21b11b891b08b79be07be57c40a85bb926668
Author: Johannes Berg
Date:   Wed Jun 12 11:09:58 2019 +0200

    iwlwifi: mvm: disable TX-AMSDU on older NICs

for stable kernel 5.2. It was not tagged but it matches all the
criteria. It fixes commit 438af9698b0f1 which went into kernel 5.1.

Thanks,
-- 
Jean Delvare
SUSE L3 Support
