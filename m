Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A275F061E
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 09:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiI3H5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 03:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbiI3H5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 03:57:37 -0400
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C4D15ED31
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 00:57:35 -0700 (PDT)
X-QQ-mid: bizesmtp89t1664524181tmo5ygjp
Received: from localhost.localdomain ( [113.200.76.118])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 30 Sep 2022 15:49:39 +0800 (CST)
X-QQ-SSF: 0140000000000060D000000A0000000
X-QQ-FEAT: rZJGTgY0+YNMSaAj0ZC4h7ZHj51c3uWb+/TUF4bjqRvauHJE3h4ruywMvoAX6
        +9Cv7VI8aSpFCR6Oqw/FsjhIYk8YbEd6I4FSwFQdmHcZOkh6Kfi1o2GF2m+SkEyb+y5CfJo
        +6luJ6XeuMYpgL9Z4BuhFJklqtMY6LPPQ9mfXqYgC/035sxXCLwr0yYUAH4V2ewtHZz5w1O
        GOI4vncgrPNwJfOwM2gdTIW8WOiRsF3zVlTlLMLqaMOZaE7oL36aArjnv/M6wyqjLzEfIoF
        VT159ukazhTVpv4aM87MG2lotNiInXl92OUHgWeOf98GSCkKd3UZ6Tb1DYkdMLlekWN87YM
        rkvXKdRUN6qxLk4ixOyGRsYoB6EZ16aX7wgBMLKMXjqOkHi1e4=
X-QQ-GoodBg: 1
From:   gouhao@uniontech.com
To:     stable@vger.kernel.org
Cc:     gouhao@uniontech.com, tyhicks@linux.microsoft.com,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com,
        jmorris@namei.org, serge@hallyn.com
Subject: [PATCH 0/3] Backporting some memory leak of ima policy to 4.19+ from mainline
Date:   Fri, 30 Sep 2022 15:49:34 +0800
Message-Id: <20220930074937.23339-1-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvr:qybglogicsvr7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gou Hao <gouhao@uniontech.com>

patch1: is memory leak of audit rule
patch2~3: is memory leak about 'fsname' field of struct ima_rule_entry

Tyler Hicks (3):
  ima: Have the LSM free its audit rule
  ima: Free the entire rule when deleting a list of rules
  ima: Free the entire rule if it fails to parse

 security/integrity/ima/ima.h        |  5 +++++
 security/integrity/ima/ima_policy.c | 24 ++++++++++++++++++------
 2 files changed, 23 insertions(+), 6 deletions(-)

-- 
2.20.1

