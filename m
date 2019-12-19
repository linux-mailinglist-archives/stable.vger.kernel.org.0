Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D9E1265B9
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 16:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfLSP1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 10:27:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:38388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbfLSP1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 10:27:20 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71101206EC;
        Thu, 19 Dec 2019 15:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576769239;
        bh=vS5IESszcyqi+uGDD+X1536i+izXz/NeBl5+PTLCpxo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f/jrqqj4Ik571w7gVJTMsgTFnWBTXFo6IX5k6mfcFgdAgzIDVvfuUKzkPioiaHTYo
         75H7sSeCgF1kXNoM6UQp9oYww5OlytjrUfez0cLiveWmhRN+69no9dumkZ0U/ig2At
         emIuoioQMqpoKK3Fa+dYSntSSF0XMIMTNboZrtUs=
Date:   Thu, 19 Dec 2019 10:27:18 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Brendan Higgins <brendanhiggins@google.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH AUTOSEL 5.4 025/350] objtool: add kunit_try_catch_throw
 to the noreturn list
Message-ID: <20191219152718.GL17708@sasha-vm>
References: <20191210210402.8367-1-sashal@kernel.org>
 <20191210210402.8367-25-sashal@kernel.org>
 <CAFd5g45s-cGXp6at4kv+=8v3cuxfbXLPEOKGUfvJ6E+u1caHcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAFd5g45s-cGXp6at4kv+=8v3cuxfbXLPEOKGUfvJ6E+u1caHcA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 10, 2019 at 01:25:54PM -0800, Brendan Higgins wrote:
>On Tue, Dec 10, 2019 at 1:04 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Brendan Higgins <brendanhiggins@google.com>
>>
>> [ Upstream commit 33adf80f5b52e3f7c55ad66ffcaaff93c6888aaa ]
>>
>> Fix the following warning seen on GCC 7.3:
>>   kunit/test-test.o: warning: objtool: kunit_test_unsuccessful_try() falls through to next function kunit_test_catch()
>>
>> kunit_try_catch_throw is a function added in the following patch in this
>> series; it allows KUnit, a unit testing framework for the kernel, to
>> bail out of a broken test. As a consequence, it is a new __noreturn
>> function that objtool thinks is broken (as seen above). So fix this
>> warning by adding kunit_try_catch_throw to objtool's noreturn list.
>>
>> Reported-by: kbuild test robot <lkp@intel.com>
>> Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
>> Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
>> Link: https://www.spinics.net/lists/linux-kbuild/msg21708.html
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>I don't think this change should be backported. This patch is to
>ignore an erroneous warning introduced by KUnit; it serves no purpose
>prior to the KUnit patches being merged.

I'll drop it, thanks!

-- 
Thanks,
Sasha
