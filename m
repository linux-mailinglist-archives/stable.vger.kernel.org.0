Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7102CA8D41
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731731AbfIDQmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:42:14 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:38117 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729471AbfIDQmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 12:42:14 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1i5YMG-0003Uf-5q; Wed, 04 Sep 2019 10:42:12 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1i5YMF-0000Z5-KX; Wed, 04 Sep 2019 10:42:12 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vineet Gupta <vgupta@synopsys.com>,
        linux-snps-arc@lists.infradead.org
References: <20190903162519.7136-1-sashal@kernel.org>
        <20190903162519.7136-111-sashal@kernel.org>
        <87ef0xqq9f.fsf@x220.int.ebiederm.org>
        <20190903194526.GH5281@sasha-vm>
Date:   Wed, 04 Sep 2019 11:41:55 -0500
In-Reply-To: <20190903194526.GH5281@sasha-vm> (Sasha Levin's message of "Tue,
        3 Sep 2019 15:45:26 -0400")
Message-ID: <87y2z4nhd8.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1i5YMF-0000Z5-KX;;;mid=<87y2z4nhd8.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19zYZU/xsW7us0tfO+uH4u3qzYGa3Y2+bo=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa03.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=8.0 tests=ALL_TRUSTED,BAYES_40,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        * -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
        *      [score: 0.3492]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sasha Levin <sashal@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 192 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 6 (3.1%), b_tie_ro: 5 (2.6%), parse: 0.94 (0.5%),
        extract_message_metadata: 11 (5.6%), get_uri_detail_list: 1.19 (0.6%),
        tests_pri_-1000: 10 (5.4%), tests_pri_-950: 1.00 (0.5%),
        tests_pri_-900: 0.85 (0.4%), tests_pri_-90: 20 (10.2%), check_bayes:
        18 (9.5%), b_tokenize: 3.8 (2.0%), b_tok_get_all: 6 (3.1%),
        b_comp_prob: 1.51 (0.8%), b_tok_touch_all: 2.5 (1.3%), b_finish: 0.64
        (0.3%), tests_pri_0: 132 (69.1%), check_dkim_signature: 0.53 (0.3%),
        check_dkim_adsp: 2.3 (1.2%), poll_dns_idle: 0.97 (0.5%), tests_pri_10:
        1.70 (0.9%), tests_pri_500: 6 (2.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH AUTOSEL 4.19 111/167] signal/arc: Use force_sig_fault where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin <sashal@kernel.org> writes:

> On Tue, Sep 03, 2019 at 11:49:16AM -0500, Eric W. Biederman wrote:
>>Sasha Levin <sashal@kernel.org> writes:
>>
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>
>>> [ Upstream commit 15773ae938d8d93d982461990bebad6e1d7a1830 ]
>>
>>To the best of my knowledge this is just a clean up, no changes in
>>behavior are present.
>>
>>The only reason I can see to backport this is so that later fixes could
>>be applied cleanly.
>>
>>So while I have no objections to this patch being backported I don't see
>>why you would want to either.
>
> This patch along with the next one came in as a dependency for
> a8c715b4dd73c ("ARC: mm: SIGSEGV userspace trying to access kernel
> virtual memory").

Thanks for providing the rest of the context.

That looks like a perfect reason for backporting this patch.

Eric


