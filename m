Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED955673A8
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 17:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbiGEP72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 11:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiGEP71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 11:59:27 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C067113DF2
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 08:59:25 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id fd6so15870751edb.5
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 08:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Bkb2t3lDURV+9gpABG4pK24ow+hL1RSxnJvzn5vajrk=;
        b=1Z/M5igvv0Rmr0OrX4V65gyT3peDifd6VzU6pHtDqhA5yFORCVa85nrL7jqZxGK3iZ
         oThhYGFLTJieRMIIKx7DHNajY99W8nUnQoJHobOBY4MEvHkAHRPzTxCOAgaqFmoYj4FG
         twEa15zo+Rvd+QVuiQNgKIoUu9e51RgFD1c71W004mitFUa695AqWaz0zE8AR5CqNgvr
         CqJ9i9lUnQcYfskMy1qhUfr+fYAHwSjCf7mX96xdmirL11sNaNx3HXqdYe3GsJ/DeXAO
         8TjE91WpncxpuQBMTAdimKE1JxHjfmRwJT6Ujvt9cX3DMeKLOI57WvMzs950Tdd3ufa9
         5DxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Bkb2t3lDURV+9gpABG4pK24ow+hL1RSxnJvzn5vajrk=;
        b=TA2id2u33IWsp/2LGs2vE7vE2F2zRspspxwYYK4JH5UjAOEBz9c9QxitIK/XElgJEO
         P/nv0rNRyXbO/AcBOTRX4S/EWzUk0nkDUenfOnxPxxjBit4OGXqOgCAD/M8VvhRxp+ZV
         YMhiV2HdKKHQuEQoA5GfMkN0KTyTmGU/+Ftp73laqsnExlI/Tpoy59wSDEYQgKtPKraI
         uUgjH925/JDtuPaYgzUPMaWDqQvBycAEUslxX4ZY/Gl/vOVu3nIcR6TQUodL4dwjIcKA
         WmwzJt57Lglg1HL7DFYe39znYm652yql3sAYJ3OvWmpa0ckdNBx8Z9ltSVrsIcPgitAB
         Easg==
X-Gm-Message-State: AJIora+hnbCxfl/AuMQHwJU5xdyeFNimwet9GK05F7tVbfgMmqFRNDjw
        yjVXZQIfQroFSgh8d4CwUr58Ng==
X-Google-Smtp-Source: AGRyM1uX/8bSp9ptLr5H45URMO7tC+aqTDEkQtq86thF0ZSPXurVHz6F/5XpZPMU+xsesfHwDv98HQ==
X-Received: by 2002:a05:6402:2988:b0:43a:60b5:1e63 with SMTP id eq8-20020a056402298800b0043a60b51e63mr13906468edb.171.1657036764104;
        Tue, 05 Jul 2022 08:59:24 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:a555:352e:f7d5:1df2? ([2a02:578:8593:1200:a555:352e:f7d5:1df2])
        by smtp.gmail.com with ESMTPSA id cf16-20020a0564020b9000b0043a422801f8sm5610074edb.87.2022.07.05.08.59.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 08:59:23 -0700 (PDT)
Message-ID: <a2260559-86af-74ff-ca95-d494688d5ea7@tessares.net>
Date:   Tue, 5 Jul 2022 17:59:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 51/84] selftests: mptcp: add ADD_ADDR timeout test
 case
Content-Language: en-GB
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        MPTCP Upstream <mptcp@lists.linux.dev>
References: <20220705115615.323395630@linuxfoundation.org>
 <20220705115616.814163273@linuxfoundation.org>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20220705115616.814163273@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha,

(+ MPTCP upstream ML)

First, thank you again for maintaining the stable branches!

On 05/07/2022 13:58, Greg Kroah-Hartman wrote:
> From: Geliang Tang <geliangtang@gmail.com>
> 
> [ Upstream commit 8d014eaa9254a9b8e0841df40dd36782b451579a ]
> 
> This patch added the test case for retransmitting ADD_ADDR when timeout
> occurs. It set NS1's add_addr_timeout to 1 second, and drop NS2's ADD_ADDR
> echo packets.
TL;DR: Could it be possible to drop all selftests MPTCP patches from
v5.10 queue please?


I was initially reacting on this patch because it looks like it depends on:

  93f323b9cccc ("mptcp: add a new sysctl add_addr_timeout")

and indirectly to:

  9ce7deff92e8 ("docs: networking: mptcp: Add MPTCP sysctl entries")

to have "net.mptcp.add_addr_timeout" sysctl knob needed for this new
selftest.

But then I tried to understand why this current patch ("selftests:
mptcp: add ADD_ADDR timeout test case") has been selected for 5.10. I
guess it was to ease the backport of another one, right?
Looking at the 'series' file in 5.10 queue, it seems the new
"selftests-mptcp-more-stable-diag-tests" patch requires 5 other patches:

-> selftests-mptcp-more-stable-diag-tests.patch
 -> selftests-mptcp-fix-diag-instability.patch
  -> selftests-mptcp-launch-mptcp_connect-with-timeout.patch
   -> selftests-mptcp-add-add_addr-ipv6-test-cases.patch
    -> selftests-mptcp-add-link-failure-test-case.patch
     -> selftests-mptcp-add-add_addr-timeout-test-case.patch


When looking at these patches in more detail, it looks like "selftests:
mptcp: add ADD_ADDR IPv6 test cases" depends on a new feature only
available from v5.11: ADD_ADDR for IPv6.


Could it be possible to drop all these patches from v5.10 then please?


The two recent fixes for the "diag" selftest mainly helps on slow / busy
CI. I think it is not worth backporting them to v5.10.


(Note that if we want "selftests: mptcp: fix diag instability" patch, we
also need 2e580a63b5c2 ("selftests: mptcp: add cfg_do_w for cfg_remove")
and the top part of 8da6229b9524 ("selftests: mptcp: timeout testcases
for multi addresses"): the list starts to be long.)


One last thing: it looks like when Sasha adds patches to a stable queue,
a notification is sent to less people than when Greg adds patches. For
example here, I have not been notified for this patch when added to the
queue while I was one of the reviewers. I already got notifications from
Greg when I was a reviewer on other patches.
Is it normal? Do you only cc people who signed off on the patch?

It looks like you don't cc maintainers from the MAINTAINERS file but
that's probably on purpose. I didn't get cc for all MPTCP patches of the
series here but I guess I can always subscribe to 'stable' ML for that.


Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
