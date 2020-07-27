Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBA322F8AD
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 21:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgG0THr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 15:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbgG0THq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 15:07:46 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D2FC061794
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 12:07:46 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id c2so13070807pfj.5
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 12:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VDh5LTn5/ZVR5v2GMBstyU78YrxDP+L2saq8RGpE+c4=;
        b=FBylgQWYPAQliUyOpyZR995F+og6FZSavwVJ9cByyqPW63e8clceWvw3rJWslSeLom
         F7vY49UKoNZradMABfaZ6dZxKfLVo6N/GAL4DZLunn8u5mRUOtbcKiU3Flv8GXp65FpX
         pW+l+58g2kDKUm2YVlmoYZL6JWF7zM4A1sNE3BZ7Bvrzoaf4XqWPNBlEkO0I1nxwgv3C
         Tp8mbIQspRYk9GqLw6SUbCV+OsXpfFSH+6Gt/dYKWAiqZnNgne+uOwnDDb8xeYyJZTjO
         GuVGMbtZsGZF0aIcgOD/QXM+AXA0rWrQmUq4DnMmHDRGlhk/hrFZQeXh0KxZifdDZBvZ
         zntQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VDh5LTn5/ZVR5v2GMBstyU78YrxDP+L2saq8RGpE+c4=;
        b=JQXzpO9hbhnWo8d/wlrYhriHwf/oGHLegzCxK4dhWB68UYBwiNJ7OndgsKcYaXseZd
         uhNYhz1uj9fv+qgWjcOFuevVsOEu4EMeGtayJGcrFzMfAKwNT2VYujFdYfKB3SWBMre+
         lhD16ut5NSBP829qYoO0e0IpjcGgvBC5ExUX2Z2+ymEvEB12yi+gYFfO8V8CbBksTahn
         kVx6sixAgh0PgyntAze0kNMXP8STCLNiyjfyPm6J+pjZbEBKahxylj1DVrO1VsLiLggU
         3IphC74n2SsEudg262CTEXhfi0oV57u8lFo/tTH9wJ47A9YOZoLLbw5P2YOGtmmwAUQ2
         eoug==
X-Gm-Message-State: AOAM532Vw0JfjxqBxVSAmxMrS/2dmq2zBUY2MR2aukiIDfCYoiBAZk3n
        q2Z3Zk+uWeaznrtIdrvH+sz/AjFH29EgOARXbI45ZAaQzIF21hfyjITAZTeMkyLrK+q2d1DGE5Q
        mqKsy0uhCZVy+6TwZO8dq5ZYVc8Cv9jx+4DCDKNxn1FWrssSf/5+FjkkQelJlR/asXO68m9tQKr
        boAg==
X-Google-Smtp-Source: ABdhPJz85Hm3+zuS3izsuX4y14jwRqfbAPq0ECjFuEOnQemWuikH6u2mn8A3ot8y5M4shcssTdsIuA6lBEEeB2pXaWg=
X-Received: by 2002:a62:c5c6:: with SMTP id j189mr6755439pfg.145.1595876866244;
 Mon, 27 Jul 2020 12:07:46 -0700 (PDT)
Date:   Mon, 27 Jul 2020 19:07:30 +0000
In-Reply-To: <20200727190731.4035744-1-willmcvicker@google.com>
Message-Id: <20200727190731.4035744-2-willmcvicker@google.com>
Mime-Version: 1.0
References: <20200727175720.4022402-2-willmcvicker@google.com> <20200727190731.4035744-1-willmcvicker@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH 0/1] Netfilter OOB memory access security patch
From:   Will McVicker <willmcvicker@google.com>
To:     stable@vger.kernel.org
Cc:     Will McVicker <willmcvicker@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
The attached patch fixes an OOB memory access security bug. The bug is
already fixed in the upstream kernel due to the vulnerable code being
refactored in commit fe2d0020994c ("netfilter: nat: remove
l4proto->in_range") and commit d6c4c8ffb5e5 ("netfilter: nat: remove
l3proto struct"), but the 4.19 and below LTS branches remain vulnerable.
I have verifed the OOB kernel panic is fixed with this patch on both the
4.19 and 4.14 kernels using the approariate hardware.

Please review the fix and apply to branches 4.19.y, 4.14.y, 4.9.y and
4.4.y.

Thanks,
Will

Will McVicker (1):
  netfilter: nat: add range checks for access to nf_nat_l[34]protos[]

 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c |  6 ++++--
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c |  5 +++--
 net/netfilter/nf_nat_core.c              | 27 ++++++++++++++++++++++--
 net/netfilter/nf_nat_helper.c            |  4 ++++
 4 files changed, 36 insertions(+), 6 deletions(-)

-- 
2.28.0.rc0.142.g3c755180ce-goog

