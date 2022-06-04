Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF66053D437
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 03:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbiFDBKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 21:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbiFDBKf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 21:10:35 -0400
Received: from out20-157.mail.aliyun.com (out20-157.mail.aliyun.com [115.124.20.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F5C433B3
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 18:10:23 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.5621983|-1;BR=01201311R841S17rulernew998_84748_2000303;CH=blue;DM=|CONTINUE|false|;DS=CONTINUE|ham_enroll_verification|0.0205712-0.000874484-0.978554;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047213;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=2;RT=2;SR=0;TI=SMTPD_---.Nynm2tA_1654304999;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.Nynm2tA_1654304999)
          by smtp.aliyun-inc.com(33.37.72.11);
          Sat, 04 Jun 2022 09:10:00 +0800
Date:   Sat, 04 Jun 2022 09:10:02 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     stable@vger.kernel.org
Subject: drop 'exfat-fix-referencing-wrong-parent-directory-information-after-renaming.patch' please
Cc:     Yuezhang.Mo@sony.com
Message-Id: <20220604091001.D570.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.75.04 [en]
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

drop 'exfat-fix-referencing-wrong-parent-directory-information-after-renaming.patch' please.

When this patch is applied, the flowing xfstests/exfat become to fail.
- generic/011
- generic/013
- generic/028
- generic/035
and more.

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2022/06/04


