Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48C6D4DACFC
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 09:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349454AbiCPI5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 04:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354708AbiCPI5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 04:57:32 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B5F6514D
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 01:56:18 -0700 (PDT)
To:     stable@vger.kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1647420976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=xk4JxtjUChMb3xp+OyO/mIhCnEVOaH6wGJY++csp8pA=;
        b=RuufooCBH0tQsjZhmerTZpAqby0tKDR7/UNKbKB1/RrPWFANfGNg6aF55rUewJvSlKnpx1
        fvjNBcZn1NOIIQ0Sn0fv0eltIvbmVFYFrFX3ONskpnRlpvFNde82rI/mammmA64lgJ0FWG
        5mECZuTVL26nPFl53nmMV6mhGF/dfSI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: question about one acpi-cpufreq commit
Cc:     gregkh@linuxfoundation.org, guoqing.jiang@linux.dev
Message-ID: <87723ab6-2aa7-cf7f-0e91-38a35b29f92b@linux.dev>
Date:   Wed, 16 Mar 2022 16:56:11 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I just found the commit in 5.10 stable kernel.

stable-linux> git tag --sort=taggerdate --contain 
8a3fc32b322cc3081dd3569047c9834f496b4ab0 | head -1
v5.10.17

commit 8a3fc32b322cc3081dd3569047c9834f496b4ab0
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Thu Feb 4 18:25:37 2021 +0100

     cpufreq: ACPI: Extend frequency tables to cover boost frequencies

     commit 3c55e94c0adea4a5389c4b80f6ae9927dd6a4501 upstream.

    [ ... ]

     Fixes: 41ea667227ba ("x86, sched: Calculate frequency invariance 
for AMD systems")
     Fixes: 976df7e5730e ("x86, sched: Use midpoint of max_boost and 
max_P for frequency invariance on AMD EPYC")
     Fixes: db865272d9c4 ("cpufreq: Avoid configuring old governors as 
default with intel_pstate")

Except db865272d9c4 was applied in v5.10-rc2, the others (41ea667227ba 
and 976df7e5730e)
were first appeared in v5.11-rc1.

linux> git tag --sort=taggerdate --contain 41ea667227ba | head -1
v5.11-rc1
linux> git tag --sort=taggerdate --contain 976df7e5730e | head -1
v5.11-rc1
linux> git tag --sort=taggerdate --contain db865272d9c4 | head -1
v5.10-rc2

So I am wondering if the mentioned commit is suitable for 5.10 stable 
kernel, or what am I missing?

Thanks,
Guoqing
