Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD871DBEFB
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 21:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgETT5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 15:57:49 -0400
Received: from imap2.colo.codethink.co.uk ([78.40.148.184]:56124 "EHLO
        imap2.colo.codethink.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728389AbgETT5D (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 15:57:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone)
        by imap2.colo.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1jbUpp-0000RR-2m; Wed, 20 May 2020 20:57:01 +0100
Message-ID: <dd3fae1fef7287e944e66333762ed16600449484.camel@codethink.co.uk>
Subject: [stable] KVM: SVM: Fix potential memory leak in svm_cpu_init()
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>
Cc:     stable <stable@vger.kernel.org>
Date:   Wed, 20 May 2020 20:57:00 +0100
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please pick this fix for 4.19 and 5.4 stable branches:

commit d80b64ff297e40c2b6f7d7abc1b3eba70d22a068
Author: Miaohe Lin <linmiaohe@huawei.com>
Date:   Sat Jan 4 16:56:49 2020 +0800

    KVM: SVM: Fix potential memory leak in svm_cpu_init()

It applies cleanly to both.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

