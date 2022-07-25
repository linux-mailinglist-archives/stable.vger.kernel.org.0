Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72274580772
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 00:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiGYWgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 18:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiGYWf7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 18:35:59 -0400
Received: from out20-159.mail.aliyun.com (out20-159.mail.aliyun.com [115.124.20.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF62764D
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 15:35:58 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1482386|-1;BR=01201311R271S85rulernew998_84748_2000303;CH=blue;DM=|CONTINUE|false|;DS=CONTINUE|ham_news_journal|0.0168326-0.000432387-0.982735;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047194;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=1;RT=1;SR=0;TI=SMTPD_---.OdYOjRQ_1658788556;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.OdYOjRQ_1658788556)
          by smtp.aliyun-inc.com;
          Tue, 26 Jul 2022 06:35:56 +0800
Date:   Tue, 26 Jul 2022 06:35:57 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     stable@vger.kernel.org
Subject: apply 'exfat: use updated exfat_chain directly during renaming' to 5.15.y/5.18.y please
Message-Id: <20220726063556.958C.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.75.04 [en]
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

apply 'exfat: use updated exfat_chain directly during renaming' to 5.15.y/5.18.y please.

because it fix some problem of the patch
'exfat-fix-referencing-wrong-parent-directory-informa.patch'
just applied in to 5.15.y/5.18.y

exfat: use updated exfat_chain directly during renaming
    Fixes: d8dad2588add ("exfat: fix referencing wrong parent directory information after renaming")

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2022/07/26


