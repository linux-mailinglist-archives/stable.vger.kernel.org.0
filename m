Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9CD99D7DE
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 23:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfHZVAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 17:00:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53374 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727287AbfHZVAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 17:00:04 -0400
Received: from mail-yw1-f71.google.com (mail-yw1-f71.google.com [209.85.161.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 713202A09BA
        for <stable@vger.kernel.org>; Mon, 26 Aug 2019 21:00:03 +0000 (UTC)
Received: by mail-yw1-f71.google.com with SMTP id k63so13312595ywg.7
        for <stable@vger.kernel.org>; Mon, 26 Aug 2019 14:00:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=NForDHU8i8He4ZMhIR86aTbusAC5KDA/CHOPSEaqPyo=;
        b=N9hlE66JFdc+HxipXVURlUsCws79wAfe4CQCm2o23uJ9iOkBujqvWPyqFXWT5tYA1X
         Q3wFSV5nP3XYkiRtdOHP3j0YJNCWibWcogeRAP8E/TZHtuQ5ME9kzjv+1vfEG52FOIZ4
         A9+3VJzXsmg4TR3nnjnOO9XvpcPtKsJ78SiXaqEAUkTBTC8NxVQhLwMQTZJY2RTUWFfG
         6Z5HYcAw1Vq0iS5gbfuFE0cWiRBk2Nf/dGTj+bXan/IZnFFiFd/wpxAw76UkeEMuVGyB
         vMmDe+ifgxoANHFSTBKJMGNYdvBZQYpua3JPKsZHus3Vb+g9OSuFraFRW9pM1WzxU1gz
         zTpA==
X-Gm-Message-State: APjAAAWsy+OwovTd2df3epo4AY9gxBqAZADy4aod5r6NlKmjCALvVkDW
        HWY8AcwiwaXdWgnrD9IxbY5yF3xe12/dgtXe62h7ZCCNoItT+kx5auWtEq7gl17u/irB2a1l2Ep
        c9GJe2sY/hcG4V+8K
X-Received: by 2002:a25:e009:: with SMTP id x9mr15212704ybg.100.1566853202777;
        Mon, 26 Aug 2019 14:00:02 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwTKD3vcPLiY0mPpMGd1YWoXPU6twVtoTb0sNg9MnesCvu9I4XNschWvCvxJqRQ2NufVw591g==
X-Received: by 2002:a25:e009:: with SMTP id x9mr15212684ybg.100.1566853202562;
        Mon, 26 Aug 2019 14:00:02 -0700 (PDT)
Received: from [192.168.10.164] (cpe-24-243-36-151.satx.res.rr.com. [24.243.36.151])
        by smtp.gmail.com with ESMTPSA id t186sm2689310ywt.20.2019.08.26.14.00.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Aug 2019 14:00:02 -0700 (PDT)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Stable_queue=3a_queue-5=2e2?=
To:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Cc:     Xiong Zhou <xzhou@redhat.com>
References: <cki.1B27CFABD6.EYV7VCBJ4I@redhat.com>
From:   Major Hayden <major@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=major@redhat.com; prefer-encrypt=mutual; keydata=
 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 UNdR
Message-ID: <a0f712c6-9253-7c27-bdaf-72e26ef97fcc@redhat.com>
Date:   Mon, 26 Aug 2019 16:00:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <cki.1B27CFABD6.EYV7VCBJ4I@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/26/19 3:33 PM, CKI Project wrote:
>   ppc64le:
>       Host 1:
>          ✅ Boot test [0]
>          ✅ Podman system integration test (as root) [6]
>          ✅ Podman system integration test (as user) [6]
>          ✅ LTP lite [7]
>          ✅ Loopdev Sanity [8]
>          ✅ jvm test suite [9]
>          ✅ AMTU (Abstract Machine Test Utility) [10]
>          ✅ LTP: openposix test suite [11]
>          ✅ Ethernet drivers sanity [12]
>          ✅ Networking socket: fuzz [13]
>          ✅ audit: audit testsuite test [14]
>          ✅ httpd: mod_ssl smoke sanity [15]
>          ✅ iotop: sanity [16]
>          ✅ tuned: tune-processes-through-perf [17]
>          ✅ Usex - version 1.9-29 [18]
> 
>       Host 2:
> 
>          ⚡ Internal infrastructure issues prevented one or more tests (marked
>          with ⚡⚡⚡) from running on this architecture.
>          This is not the fault of the kernel that was tested.
> 
>          ✅ Boot test [0]
>          ❌ xfstests: xfs [1]
>          ⚡⚡⚡ selinux-policy: serge-testsuite [2]
>          ⚡⚡⚡ lvm thinp sanity [3]
>          ⚡⚡⚡ storage: software RAID testing [4]
>          🚧 ⚡⚡⚡ Storage blktests [5]

It looks like this one had a problem with the RPM database shortly after xfstests finished. You can probably ignore this failure for now.

--
Major Hayden
