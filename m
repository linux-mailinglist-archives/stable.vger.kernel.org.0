Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C11957188D
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 13:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiGLLcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 07:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiGLLcD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 07:32:03 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7021721807;
        Tue, 12 Jul 2022 04:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1657625519;
        bh=4DGf9fAelIjMIL4cUJBkvt2Bi+U2qT/l8y6i/0sSxCc=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=DYH5a1dy32jHuT3Vd+/MgCnLWvDP5p5ulA70CH2G6Q8xdvglBoqSROGr+zx2heg28
         8H0lbJo7bnxta1Ypl3+tbWB7an31+YDrwVjyFAcUKnnoGJjA0M8CHJNaSZj2Wj8JUK
         nM3nGtaq3ulEq/8/1xPmfHVlBMKtGBKpPoaYWuvE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.34.68]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MLzBp-1ntHd03DsH-00Hw06; Tue, 12
 Jul 2022 13:31:59 +0200
Message-ID: <611a0107-d736-e40f-e13f-5495c72cbe4e@gmx.de>
Date:   Tue, 12 Jul 2022 13:31:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.18 000/112] 5.18.11-rc1 review review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:V/3Cc/GjCQrwadwbJAFBot3skc2wdHZSN/bjhIKpRC9QZAyHhWg
 +MmNUWXQv+T+8Ndwt9suYk2PEm2uaIeaP9nYsF99/OjXli3rYPCk91ddGhyzSRacFHO7wDB
 T5nnmR/SzsaZ1bWvGVHXVV2o8ZBorwd/K0zSUQbtVVMEKe5Un59TaEEPT41/1dn4yanNSa1
 aP+j49GR9oIWdttY819lA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:hwzsMyDZv0s=:JcwlVEjJZS0txX2J2zZCaU
 /FtJV/lEHBmsYSuBIKRMtkLtnYm96blBPQR5O4kYVXbVja88/X6zSuSixnpK5phA+hRJLyvGN
 lsn6P635GYMJQaDYIu07/TObH7zJQ2rmwaaCkC1S0acbCe8upD7geF+7b6fSoREzQK+orR8oJ
 1OzYJCMKXvNjAI2fYiT+FjaLwfjq1/0jUxXtbRIitOWqnQMxk0zx2PXd2d6BwTXyhnYeb6ofB
 Jnd1Xci6OY7gXd4zlFDZ8ZnZKL4OjgBM3ThO00d2CBPXOochdsZNI2V5M6rLVycW71VUBkDdO
 LVzIAqm8mzdh2ZNze8/9b8WdpvyBiv1yTkwNk/j7oLcR6oBLgRcyb+66oipALTQ+uDTsOCbHO
 cKe/UlA0KGJZ6yQ/GfgcbTrm7IIIZkPWWl8o7TlJ7ooxQ97+klGwr1aplBIujqZ2kN0NwQeYd
 f5/xVo/QNw2694qPfQYKBbOHrDu0bZZnxQ/Jzzo1sPZwBYCZMrVZx4cS+PQIT1CVphVn3wkfA
 Y5aUuKp61FgzjKxyMeiTBT+KFMIio4S5dX3qA9e8LCPRHm0zt+K+mVbHqIg8VV6uZbfRUo1S0
 fTDOSJJhNFCDeGbzyj/I/xJdMSLl+ngrdtLb/V6+Tj71Q2fXa53D0q0/EjQm2orammZAzCDZZ
 cBvnASwfsSZEcxxpN2hqstcChy/bGZeYKqca4htLBfKvZfNNtvZ9K28RNIlA9f+1Vhxmd0FP1
 0C1DmJE1BoXp1JmEvZLVU9AAo+aPYcS9Uj8TXadZsO55ZrBNr4QeteeH9Zv1G46/U6sUpj1Qd
 M1Y324x+5HVFenPL1V4lhopXJZSiGTUwm8mcB9KdLXb/xHzaDwjLBtNjxL4WiKSilhjkg2by4
 6dIHx4uTKW4aqg3QMhCsZ3zM2Q0sZzAdiJhHWpJbP73onT6W4yfBgfga7cXe1aqoWs9H5iRnR
 FSkyy1+s5IQGVx8ZpGdlLJM4rT6PN43QPMWKdgG5ziS+37OrN0NtQKM/fuy/F2+6RbuDsqy2B
 WDWxu/mB6Ft78wmUK1at5cWjEMLDWjjzcoQnkQnIpOUOA9qix4Vaq4sUG3ZOo7VC0pyRt3hEZ
 yjA2Q0BgsC0WFj+OVIo/rbs9yY1f9ah2LFu
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.18.11-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

Thanks

Tested-by: rwarsow@gmx.de

