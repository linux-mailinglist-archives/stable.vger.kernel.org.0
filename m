Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27406673372
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 09:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjASIQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 03:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjASIQB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 03:16:01 -0500
X-Greylist: delayed 603 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 Jan 2023 00:15:59 PST
Received: from cu-gy11p00im-quki08142302.gy.silu.net (cu-gy11p00im-quki08142302.gy.silu.net [157.255.1.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3386145BDD;
        Thu, 19 Jan 2023 00:15:55 -0800 (PST)
Received: from smtpclient.apple (unknown [101.88.202.253])
        by gy11p00im-quki08142302.gy.silu.net (Postfix) with ESMTPSA id 7AA0B18C011C;
        Thu, 19 Jan 2023 07:59:41 +0000 (UTC)
From:   =?utf-8?B?5YiY55Cm?= <liuqi405@icloud.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH] clocksource/drivers/arm_arch_timer: Update sched_clock
 when non-boot CPUs need counter workaround
Message-Id: <757D0727-BB99-4FB0-8A7C-70410E9D7BAD@icloud.com>
Date:   Thu, 19 Jan 2023 15:59:38 +0800
Cc:     daniel.lezcano@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        quic_ylal@quicinc.com, stable@vger.kernel.org, tglx@linotronix.de,
        will@kernel.org,
        =?utf-8?B?546L5rOV5p2w?= <wangfajie@longcheer.com>,
        liurenwang@longcheer.com, zhanghui5@longcheer.com,
        liangke1@xiaomi.com
To:     maz@kernel.org
X-Mailer: Apple Mail (2.3693.20.0.1.32)
X-Proofpoint-GUID: 9SYkpPGIVTQThF0M0EnhEzPmoQH2FFSv
X-Proofpoint-ORIG-GUID: 9SYkpPGIVTQThF0M0EnhEzPmoQH2FFSv
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.528,18.0.895,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2022-09-21=5F12:2022-09-20=5F02,2022-09-21=5F12,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0 mlxscore=0
 mlxlogscore=807 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2301190065
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Test Report]
Result: Test Pass

A total of two rounds of pending testing
     a. The first round of hanging test
          Number of machines: 200
          Hanging test duration: 48h
          Hanging test results: no walt crash problem
     b. The second round of hanging test
          Number of machines: 200
          Hanging test duration: 72h
          Hanging test results: no walt crash problem

Tested-by: wangfajie <wangfajie@longcheer.com>
Tested-by: liurenwang <liurenwang@longcheer.com>
Tested-by: zhanghui <zhanghui5@longcheer.com>
Tested-by: liangke <liangke1@xiaomi.com>
