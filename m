Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E97DF8F7
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfD3Mft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 08:35:49 -0400
Received: from mail-ot1-f52.google.com ([209.85.210.52]:36417 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbfD3Mfs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 08:35:48 -0400
Received: by mail-ot1-f52.google.com with SMTP id b18so2721213otq.3
        for <stable@vger.kernel.org>; Tue, 30 Apr 2019 05:35:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=HzpWxqFB5u3S5nlyhPYnNjkOwa4STcSQTiI4mELmu1k=;
        b=HbQZ5j7M2NPQHtz5RChVpEHHEnus10Xj8CqFtYLypnIufwDXp1qRLIOUjQ7Mni+zjl
         eJqf5e4Bmt2LC+rp0XhEUsr/nKbwq28ysYuXAXTkozhURVd7lonvkuA0mLfcmmyHsCIt
         Wb7UnU6onFX1s+jUc/dsgU8pgWvUQ/tsgeGugaCruCh6mYQKJoxrw1ivOmNAe5OefT8r
         6jZEAoqHlLa7+6Gv0fDXFYWJbKHMq/niq9A2v3hP0k4av9Y/z7wX6gQeSvc0B2iRObMa
         sn+rwnYpvoXZwqGD4+cfosmAq38LnXwZCNlW4X8eKPiq2+v/jptErNZO3PsOwBEMbcH/
         3qeA==
X-Gm-Message-State: APjAAAU0f0f5WnHTOtk0RZRmn3eSh8XGnu3e8nt1Absl2xJxxoGzkdDS
        9YqzDOmKzC4jWuB/X3z5TA0Qm8WC0eM=
X-Google-Smtp-Source: APXvYqy3F9/uLu6ptoBd7BZiuAWAOzwQrQgzWNUAWRqQ74c/b7JdeoiCUSAFuVXk4B2954dO01G58Q==
X-Received: by 2002:a05:6830:1cb:: with SMTP id r11mr6062735ota.344.1556627747452;
        Tue, 30 Apr 2019 05:35:47 -0700 (PDT)
Received: from [192.168.10.164] (cpe-24-243-36-151.satx.res.rr.com. [24.243.36.151])
        by smtp.gmail.com with ESMTPSA id r25sm14290784otk.37.2019.04.30.05.35.46
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 05:35:47 -0700 (PDT)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8e_FAIL=3a_Stable_queue=3a_queue-5=2e0?=
To:     Linux Stable maillist <stable@vger.kernel.org>
References: <cki.6C208109D9.WGQF5P41NS@redhat.com>
From:   Major Hayden <major@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=major@redhat.com; prefer-encrypt=mutual; keydata=
 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 UNdR
Message-ID: <efa70f6a-8854-7494-81a6-f729aeca5351@redhat.com>
Date:   Tue, 30 Apr 2019 07:35:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <cki.6C208109D9.WGQF5P41NS@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/30/19 7:32 AM, CKI Project wrote:
>   aarch64:
>      ✅ Boot test [0]
>      ❎ LTP lite [1]
>      ✅ Loopdev Sanity [2]
>      ✅ AMTU (Abstract Machine Test Utility) [3]
>      ✅ Ethernet drivers sanity [4]
>      ✅ httpd: mod_ssl smoke sanity [5]
>      ✅ iotop: sanity [6]
>      ✅ tuned: tune-processes-through-perf [7]
>      ✅ Usex - version 1.9-29 [8]
>      ✅ lvm thinp sanity [9]
>      ✅ Boot test [0]
>      ✅ xfstests: ext4 [10]
>      ✅ xfstests: xfs [10]
>      🚧 ✅ Networking route: pmtu [11]
>      🚧 ✅ audit: audit testsuite test [12]
>      🚧 ✅ stress: stress-ng [13]

All of the tests look fine for this build, but the aarch64 test failed on mtest06 in LTP:

> <<<test_start>>>
> tag=mtest06 stime=1556617569
> cmdline="  mmap1"
> contacts=""
> analysis=exit
> <<<test_output>>>
> tst_test.c:1085: INFO: Timeout per run is 0h 05m 00s
> tst_test.c:1085: INFO: Timeout per run is 0h 03m 00s
> mmap1.c:234: INFO: [3] mapped: 20000, sigsegv hit: 2864, threads spawned: 8
> mmap1.c:237: INFO: [3] repeated_reads: 0, data_matched: 17590074
> mmap1.c:234: INFO: [6] mapped: 50000, sigsegv hit: 5296, threads spawned: 20
> mmap1.c:237: INFO: [6] repeated_reads: 322, data_matched: 45330029
> Test timeouted, sending SIGKILL!
> tst_test.c:1125: INFO: If you are running on slow machine, try exporting LTP_TIMEOUT_MUL > 1
> tst_test.c:1126: BROK: Test killed! (timeout?)
>  
> Summary:
> passed   0
> failed   0
> skipped  0
> warnings 0
> <<<execution_status>>>
> initiation_status="ok"
> duration=180 termination_type=exited termination_id=2 corefile=no
> cutime=984 cstime=17098
> <<<test_end>>>

This could be due to a slow host on our side and we're still taking a look. I figured that sharing all of the results would be helpful while we investigate. :)

--
Major Hayden
