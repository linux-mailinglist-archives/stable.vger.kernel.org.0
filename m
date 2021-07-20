Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DA83CF70F
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 11:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235466AbhGTJC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 05:02:28 -0400
Received: from foss.arm.com ([217.140.110.172]:54684 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235929AbhGTJCJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 05:02:09 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 764CA6D;
        Tue, 20 Jul 2021 02:42:14 -0700 (PDT)
Received: from e123648.arm.com (unknown [10.57.6.251])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 32F343F73D;
        Tue, 20 Jul 2021 02:42:11 -0700 (PDT)
From:   Lukasz Luba <lukasz.luba@arm.com>
To:     linux-kernel@vger.kernel.org
Cc:     Chris.Redpath@arm.com, lukasz.luba@arm.com,
        dietmar.eggemann@arm.com, morten.rasmussen@arm.com,
        qperret@google.com, linux-pm@vger.kernel.org,
        stable@vger.kernel.org, peterz@infradead.org, rjw@rjwysocki.net,
        viresh.kumar@linaro.org, vincent.guittot@linaro.org,
        mingo@redhat.com, juri.lelli@redhat.com, rostedt@goodmis.org,
        segall@google.com, mgorman@suse.de, bristot@redhat.com,
        CCj.Yeh@mediatek.com
Subject: [PATCH v2 0/1] Improve EAS energy estimation and increase precision
Date:   Tue, 20 Jul 2021 10:41:52 +0100
Message-Id: <20210720094153.31097-1-lukasz.luba@arm.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

Here is a the v2 improving EAS estimation precision. The v1 and discussion
can be found at:
https://lore.kernel.org/lkml/20210625152603.25960-1-lukasz.luba@arm.com/

changes:
v2:
- dropped first two patches
- implemented better resolution for 64-bit only machines according to
  Peter's comment and scale_load() example
- power value multiplied by 1000 not 10000
- added 'Fixes' tag, so it could be picked into stable trees easily
- extended patch descirpion with example corenr case scenario

Regards,
Lukasz


Lukasz Luba (1):
  PM: EM: Increase energy calculation precision

 include/linux/energy_model.h | 16 ++++++++++++++++
 kernel/power/energy_model.c  |  3 ++-
 2 files changed, 18 insertions(+), 1 deletion(-)

-- 
2.17.1

