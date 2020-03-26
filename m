Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05992194861
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 21:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgCZUI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 16:08:27 -0400
Received: from er-systems.de ([148.251.68.21]:38368 "EHLO er-systems.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727719AbgCZUI1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 16:08:27 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
        by er-systems.de (Postfix) with ESMTP id DDA7BD6005E;
        Thu, 26 Mar 2020 21:08:22 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on er-systems.de
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=5.0 tests=ALL_TRUSTED,AWL,BAYES_00,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.2
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by er-systems.de (Postfix) with ESMTPS id BECB7D6005A;
        Thu, 26 Mar 2020 21:08:22 +0100 (CET)
Date:   Thu, 26 Mar 2020 21:08:22 +0100 (CET)
From:   Thomas Voegtle <tv@lio96.de>
X-X-Sender: thomas@er-systems.de
To:     Paolo Bonzini <pbonzini@redhat.com>
cc:     stable@vger.kernel.org,
        Zhuang Yanying <ann.zhuangyanying@huawei.com>,
        LinFeng <linfeng23@huawei.com>
Subject: Re: proposing 7df003c85218b5f for v5.5.y, v5.4.y, 4.19.y, v4.14.y,
 v4.9.y
In-Reply-To: <8350b14e-f708-f2e3-19cd-4e85a4a3235c@redhat.com>
Message-ID: <alpine.LSU.2.21.2003262103280.20929@er-systems.de>
References: <alpine.LSU.2.21.2003261831320.11753@er-systems.de> <8350b14e-f708-f2e3-19cd-4e85a4a3235c@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-74181308-1815079019-1585253302=:20929"
X-Virus-Status: No
X-Virus-Checker-Version: clamassassin 1.2.4 with clamdscan / ClamAV 0.102.2/25763/Thu Mar 26 14:07:34 2020 signatures .
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---74181308-1815079019-1585253302=:20929
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT

On Thu, 26 Mar 2020, Paolo Bonzini wrote:

> On 26/03/20 18:43, Thomas Voegtle wrote:
>>
>> Hello,
>>
>> the following one line commit
>>
>> commit 7df003c85218b5f5b10a7f6418208f31e813f38f
>> Author: Zhuang Yanying <ann.zhuangyanying@huawei.com>
>> Date:   Sat Oct 12 11:37:31 2019 +0800
>>
>>     KVM: fix overflow of zero page refcount with ksm running
>>
>>
>> applies cleanly to v5.5.y, v5.4.y, 4.19.y, v4.14.y and v4.9.y.
>>
>> I actually ran into that bug on 4.9.y
>>
>> Thanks in advance,
>>
>>  Thomas
>>
>>
>>
>
> Yes, indeed.  It's not a trivial backport though, so I prefer to do it
> manually.  I can help with that, or with reviews if Yanying already has
> patches ready.

Are you sure we are talking about the same commit? Or do I really see 
something wrong here?
It's an one liner. Applies cleanly. Compiles.
Don't know if it fixes the bug, though.


       Thomas

---74181308-1815079019-1585253302=:20929--

