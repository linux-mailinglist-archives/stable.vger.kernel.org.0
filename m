Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEAAA174B8
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 11:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfEHJLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 05:11:39 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:51651 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725863AbfEHJLi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 May 2019 05:11:38 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04391;MF=wuyihao@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0TRAwvL6_1557306689;
Received: from ali-186590dcce93-2.local(mailfrom:wuyihao@linux.alibaba.com fp:SMTPD_---0TRAwvL6_1557306689)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 08 May 2019 17:11:30 +0800
To:     linux-nfs@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>
Cc:     stable@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>,
        caspar@linux.alibaba.com
From:   Yihao Wu <wuyihao@linux.alibaba.com>
Subject: [PATCH 0/2] Fix two bugs CB_NOTIFY_LOCK failing to wake a water
Message-ID: <d0b6fc01-0a73-e4f7-b393-3ecc9aacffb0@linux.alibaba.com>
Date:   Wed, 8 May 2019 17:11:32 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch set fix bugs related to CB_NOTIFY_LOCK. And it should also fix
the failure when running xfstests generic/089 on a NFSv4.1 filesystem.

Yihao Wu (2):
  NFSv4.1: Again fix a race where CB_NOTIFY_LOCK fails to wake a waiter
  NFSv4.1: Fix bug only the first CB_NOTIFY_LOCK is handled

 fs/nfs/nfs4proc.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

-- 
1.8.3.1
