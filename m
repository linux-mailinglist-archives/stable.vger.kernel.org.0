Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A3A4DB34B
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244143AbiCPOcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355073AbiCPOcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:32:15 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095A34C436
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 07:31:00 -0700 (PDT)
Received: from fsav115.sakura.ne.jp (fsav115.sakura.ne.jp [27.133.134.242])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 22GEUxXM013765;
        Wed, 16 Mar 2022 23:30:59 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav115.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav115.sakura.ne.jp);
 Wed, 16 Mar 2022 23:30:59 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav115.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 22GEUwhw013760
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 16 Mar 2022 23:30:58 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <fc88e012-ff4b-8746-5f9d-d60018ff88a8@I-love.SAKURA.ne.jp>
Date:   Wed, 16 Mar 2022 23:30:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: apply commit 61cc4534b655 ("locking/lockdep: Avoid potential
 access of invalid memory in lock_class") to linux-5.4-stable
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Cheng Jui Wang <cheng-jui.wang@mediatek.com>
Cc:     stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-mediatek@lists.infradead.org,
        Eason-YH Lin <eason-yh.lin@mediatek.com>
References: <6eb2052f463d323b0a82e795d765afb9d5925f6e.camel@mediatek.com>
 <YjHzl3Arey7KH0CB@kroah.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <YjHzl3Arey7KH0CB@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/03/16 23:26, Greg KH wrote:
> On Wed, Mar 16, 2022 at 02:01:12PM +0800, Cheng Jui Wang wrote:
>> Hi Reviewers,
>>
>> This patch fixes a use-after-free error when /proc/lockdep is read by
>> user after a lockdep splat.
>>
>> I checked and I think this patch can be applied to stable-5.4 and
>> later. 
>>
>> commit: 61cc4534b6550997c97a03759ab46b29d44c0017
>> Subject: locking/lockdep: Avoid potential access of invalid memory in
>> lock_class
> 
> I do not see that commit id in Linus's tree, are you sure it is correct?

It is in linux-next.git, and will be sent to linux.git when next merge window opens.
