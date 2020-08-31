Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCCF3257DF5
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbgHaPuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727881AbgHaPuh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 11:50:37 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D05C061573
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 08:50:37 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id e41so2155091uad.6
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 08:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=KjLhRL9/9gCuUdlxr3nrBY8CBnWoqJaEBgjnNIftUOQ=;
        b=hKAIspj/RqjlaOwEF4OWf6DykUHi4K8YLcRe4//+Hy0f5h6oicJ7BJV9+EVfgXQTX0
         70jGHfqnpqVUAVa7uQ9vU7cCAt3hIS9V45EDq09Vl3GFb1EhlZaTGOZiSonuSFpZ6N/o
         tvL9ZWxsyVPSwvw5CwYbuIAMC73hkmIi6VtaIQCx5ywZN471V2xLWnoBxpkmi31dGmj4
         gP7nD4vYJfl1TbS2WY2uwIvxpIDbysOboITqL4jO+1W7h/BOEnmW9KVnVFM5yg1pBHGQ
         Oipptz7hWQGpwYKVwqGqwuRYbaOxdGTrz0U1CHMeIIbeL59c1TgYIpepkPU1Cv5D248c
         9Htw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=KjLhRL9/9gCuUdlxr3nrBY8CBnWoqJaEBgjnNIftUOQ=;
        b=p+/jg7+PJxN87VwmKR73Z6LfOReEfvHgTIhj7dpmA7BB7gstQaz95ohlVKCjjw7xCS
         wlqBM0OEuMqSUwMfmObASiIr3jmDsp3JOZ4X/5pBg7tvISN4T1VcvCVxawuXbTh5KyNu
         z0au3jqjJqrE8kzdQKdd/4VJ3Dp2iHvkFsLPulU3tMKKJoBK6ydSwFJ4TFbpRwEv6VKQ
         Wbq00Pb7y6eryHDx9fNRGqWeQJDK/s8A41/owoDjRVmTkieYwx5UmgydcYsCq0TQUcer
         nPDWCjiEMzBOmfuxcew1ZJ9z+LIsrjqJQam9N9C/e/C0WC+vF+EtUpebHbF77wtOhKNm
         noew==
X-Gm-Message-State: AOAM532O0t1pQBzxFQX/4z5MKXwD4l7fSoAoMwq0khgIo+D6QHoTWTnY
        iS2rROVXp7LAdZQy6jZkNCaBilqavI49hQjavRGfHQ==
X-Google-Smtp-Source: ABdhPJzubWQJWcqfOHXItVehGNiyohKbaLVuzgG1YqV4RyT2cyL38XJS+fClfUXdKOvsoZHAbKi/lPmQsHIcAm1/p9Y=
X-Received: by 2002:ab0:679a:: with SMTP id v26mr1459474uar.27.1598889035933;
 Mon, 31 Aug 2020 08:50:35 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 31 Aug 2020 21:20:24 +0530
Message-ID: <CA+G9fYvsNkxvs7hdCB3LC9W+rP8hBa3F1fG3951S+xHfiOJwNA@mail.gmail.com>
Subject: perf: tools/include/linux/kernel.h:53:17: error: comparison of
 distinct pointer types lacks a cast [-Werror]
To:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Building stable-rc 5.4 with gcc 7.3.0 perf build failed for x86_64
and arm64 architectures.

In file included from btf_dump.c:16:0:
btf_dump.c: In function 'btf_align_of':
perf/1.0-r9/perf-1.0/tools/include/linux/kernel.h:53:17: error:
comparison of distinct pointer types lacks a cast [-Werror]
  (void) (&_min1 == &_min2);  \
                 ^
btf_dump.c:770:10: note: in expansion of macro 'min'
   return min(sizeof(void *), t->size);
          ^~~
cc1: all warnings being treated as errors

https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.4/DISTRO=lkft,MACHINE=intel-corei7-64,label=docker-lkft/263/consoleText

- Naresh
