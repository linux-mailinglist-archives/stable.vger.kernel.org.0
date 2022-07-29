Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE284584DE5
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 11:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiG2JM3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 29 Jul 2022 05:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiG2JM2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 05:12:28 -0400
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6487B7D7AD
        for <stable@vger.kernel.org>; Fri, 29 Jul 2022 02:12:24 -0700 (PDT)
X-QQ-mid: bizesmtp62t1659085938t22d4uiw
Received: from smtpclient.apple ( [111.193.9.146])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 29 Jul 2022 17:12:17 +0800 (CST)
X-QQ-SSF: 01400000002000B0V000B00A0000000
X-QQ-FEAT: LrCnY+iDm+PtRvK9zTya4sW1br3ZNt5kqnTarvOC6UDh9/ZQxOhU+/wSPWXAd
        YlCmsGMnpnUiL6rNmRU9WlR8ySB1mPMNA7JaR7Bg17MQnBVAA0S6USfrdubFIR2qTjvlEZ8
        ZOWiDxiiORn+9vHMiszXeQ3Cq3iFX1OkLrLbOhAdFC75rRnmhh38ojBdV70bRDx1Jbk4MZ7
        +9wSRU93qS/FCGf4eO54udhtNEP03Q9lPUgW3oAqtj0xmqiAoJ9hs1Pw+xa1D2mslGQg3tc
        JyGlkHr9smWOtrRDrAck/ERTPQa7DAfInPOS2I6wfb7ISmRgf+9GBI+xGu90aU9LQafA+Av
        ARpGkip3EAPFLSD4wpOOIdoCqGvaylgGJt21gCJh6cJji/6bJNWIsHzFvDO3er+JvWf4egp
X-QQ-GoodBg: 2
From:   Yan Xinyu <sdlyyxy@bupt.edu.cn>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Backport request for 829eea7c94e0 ("mt7601u: add USB device ID for
 some versions of XiaoDu WiFi Dongle.")
Message-Id: <ED02634A-1156-4A85-A2AD-EBFD32BF5549@bupt.edu.cn>
Date:   Fri, 29 Jul 2022 17:12:16 +0800
Cc:     =?utf-8?B?54eV5paw5a6H?= <sdlyyxy@bupt.edu.cn>
To:     stable@vger.kernel.org
X-Mailer: Apple Mail (2.3696.100.31)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:bupt.edu.cn:qybgforeign:qybgforeign3
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Could you please backport the following patch to 4.9/4.14/4.19/5.4/5.10?

829eea7c94e0 ("mt7601u: add USB device ID for some versions of XiaoDu WiFi Dongle.")

The patch has been merged to mainline on 5.14. This will make the
devices run on these older kernels.

The original patch need to be offset 8 lines for 4.9/4.14/4.19. If it
cannot be applied, please let me know and I will send new patches.

Thanks,
sdlyyxy

