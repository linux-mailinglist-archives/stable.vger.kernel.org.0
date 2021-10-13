Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F9042C3E6
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 16:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhJMOuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 10:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237434AbhJMOuE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 10:50:04 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA7AC061570
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 07:48:01 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id w19so11508429edd.2
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 07:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=gLJgOZ4E1/bA7d+Zfd9nN0Vl6oH0H/24y3NricMLcy0=;
        b=pve+zA9q/BhMS0Fj5CKjy40eEe5/T96FHxIv52IkILImUHU9CPpFWpBXHGdRQyqXOb
         m0f4X7mmMWAAhasyWWUZG+KnDfpiCWeYiwJW+564xFyKB0yIOEDCObb4gCLCxmaO6ZHI
         tOqp3NQPHVQb+xeInuZkq3izlonLhIB3TUfo1vVsU36No0APL+M/AXJeBV4xrJl7b0YE
         tdEiVtjGWwC1g3jsvpgp71q62DqMMmzJikXDENGYhm14I9vRGfrvfSGj/2X0jm5BOM/Z
         rrLYxEbhxKUNIKuBAmhVuhp4ivFOsjY69IT8vFgwNWMrskof+9cbyPMSbWr5WMlbJC8/
         Gpnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=gLJgOZ4E1/bA7d+Zfd9nN0Vl6oH0H/24y3NricMLcy0=;
        b=hvSn5OyGcdlkuH+rhWgV3NIVtYFqHMCXttGQxw3VMiJU/IwwPgyaGkKZ7nUq2X4f6N
         b8x0H/fpTcj86idpItn/3Qe1arn+pN8eabIA+TMhZw8d9xZX+ckgA1AlWgRvyefcSwED
         vFwoGPcEHkMcQ7tU7AmFc/2/m2LeLzAQZad06Fp2v31Q8phBqZXso0I3MnNwei9GIiOB
         ssr9I1eBId5x6QYSeoR5bn6o2CPH54UF6/UcKeGKt5w3dXti0psXsFUTbyiNESM/CrgS
         DdtgilMbHzdNpKv3nNXwLAAio7vj9mL5mhlgmBUVAFTzNh4weoqpC2ScsOu6rzif7XBF
         htTQ==
X-Gm-Message-State: AOAM530ssUIcrUrJU2scWUyaoJoVsKIZoPmuDTHcvDYmeKnj4PC7FTx2
        I5Rkv5tiIs11vCgcGYbzoKfGsjvEEmzzZw==
X-Google-Smtp-Source: ABdhPJxhuXvTd2IMPpVTPzqXwlZCrEwDxCufL7PcN3oMhFxTeKfwOkXdGsuHwWN6hr/L40nhN+3L9Q==
X-Received: by 2002:a05:6402:3554:: with SMTP id f20mr10486500edd.210.1634136476771;
        Wed, 13 Oct 2021 07:47:56 -0700 (PDT)
Received: from [192.168.178.46] ([213.211.156.121])
        by smtp.gmail.com with ESMTPSA id j22sm6829326ejt.11.2021.10.13.07.47.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 07:47:56 -0700 (PDT)
Message-ID: <19ffe0d6-f957-135c-cbae-14a0a46f3183@tessares.net>
Date:   Wed, 13 Oct 2021 16:47:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Content-Language: en-GB
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Use of "Fixes" tag for trivial fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha,

First, thank you for your great job maintaining the stable versions!

In our work related to MPTCP, we were wondering if we should/can add the
"Fixes" tag for trivial/stable fixes.

It is certainly easier to explain that with an example: we have a small
patch [1] to stop exposing a function that is only used from one .c file
and declared there too. So the signature is removed from the .h file and
the 'static' keyword is added in the .c file. It should have been like
that since the introduction of this function.

We don't know if we can/should add the "Fixes" tag for such cases: the
"mistake" has been introduced by one specific commit so we could add the
"Fixes" tag but we also know patches with such tags are certainly going
to be automatically backported. The patch is not really fixing a bug,
more a "cleaning". Does it make sense to backport these patches then?

On one hand, we might think it would be interesting to backport it to
reduce the differences with the last version: if the idea is to backport
simple fixes to ease future and maybe more complex backports later. But
on the other hand, it is more work for you to backport it: if the idea
is to backport only actual bug-fix patches. So what is the preferred policy?

We didn't find anything in the doc on "when not to add the 'Fixes' tag"
but we know the Stable Kernel Rules doc mentions to avoid trivial fixes.
Maybe this patch is not "trivial", it is not really a bug-fix either but
that's not the real question here, more: does this rule -- and other
ones from Stable Kernel doc -- apply to the "Fixes" tag as well?

Cheers,
Matt

[1]
https://lore.kernel.org/mptcp/d40a139-9f3b-974d-31f-faa28099c527@linux.intel.com/T/
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
