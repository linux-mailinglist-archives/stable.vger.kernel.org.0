Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 140B01945BA
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 18:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgCZRn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 13:43:29 -0400
Received: from er-systems.de ([148.251.68.21]:34906 "EHLO er-systems.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbgCZRn3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 13:43:29 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
        by er-systems.de (Postfix) with ESMTP id 16E04D6005E;
        Thu, 26 Mar 2020 18:43:27 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on er-systems.de
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=5.0 tests=ALL_TRUSTED,AWL,BAYES_05,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.2
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by er-systems.de (Postfix) with ESMTPS id EA971D6005A;
        Thu, 26 Mar 2020 18:43:26 +0100 (CET)
Date:   Thu, 26 Mar 2020 18:43:26 +0100 (CET)
From:   Thomas Voegtle <tv@lio96.de>
X-X-Sender: thomas@er-systems.de
To:     stable@vger.kernel.org
cc:     Zhuang Yanying <ann.zhuangyanying@huawei.com>,
        LinFeng <linfeng23@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: proposing 7df003c85218b5f for v5.5.y, v5.4.y, 4.19.y, v4.14.y,
 v4.9.y
Message-ID: <alpine.LSU.2.21.2003261831320.11753@er-systems.de>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-Virus-Status: No
X-Virus-Checker-Version: clamassassin 1.2.4 with clamdscan / ClamAV 0.102.2/25763/Thu Mar 26 14:07:34 2020 signatures .
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello,

the following one line commit

commit 7df003c85218b5f5b10a7f6418208f31e813f38f
Author: Zhuang Yanying <ann.zhuangyanying@huawei.com>
Date:   Sat Oct 12 11:37:31 2019 +0800

     KVM: fix overflow of zero page refcount with ksm running


applies cleanly to v5.5.y, v5.4.y, 4.19.y, v4.14.y and v4.9.y.

I actually ran into that bug on 4.9.y

Thanks in advance,

  Thomas



