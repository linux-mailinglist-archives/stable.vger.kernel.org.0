Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598F04108DB
	for <lists+stable@lfdr.de>; Sun, 19 Sep 2021 00:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240411AbhIRWxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Sep 2021 18:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbhIRWxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Sep 2021 18:53:06 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D2DC061574
        for <stable@vger.kernel.org>; Sat, 18 Sep 2021 15:51:42 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id p2so19414385oif.1
        for <stable@vger.kernel.org>; Sat, 18 Sep 2021 15:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=fBqjkR3Yla4Z618kwDYQXSqaf8nqr3ll3vIrzZwI4oA=;
        b=WWvhk4PGhl1o5GdePhSFmpEJ8HTgacLHfcSk2gUKjdRR1U/T2t0lWXmZ3Nedrc8YQw
         gNRzsMe2kk6bZgghwAaDdVkpuzD0Qw/li165OowEtuOjDWRbGM5jpZYUiFGsf0YnfhhR
         9IhmXWw6Ps1kTAaC992J1NpPjzP4CS36TG9ZYn0ycbNPmUDHqWIFsa2IHKvxBHmKWlj4
         5e01YU9q6hu6WhKtRX3WNBYY6GEWdppMQZ53kn6Ffsdv1mdYwPs/9x6+IdXWQoxXpqEA
         ljy2XCcfw53MXG2aCwNDZzBryj/lv5R7svPYmBRmsl7gsEzP63APFPzdSvxvJfSuHInT
         f+Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=fBqjkR3Yla4Z618kwDYQXSqaf8nqr3ll3vIrzZwI4oA=;
        b=O2VkulsBwMNJoMV+xg0wlZM3b1zipyfSGpqNGemJmWTsuyH4Lnw5Ud1IkDhFxBH+QK
         CNjSd6TMPiueqfz5/mdKFbaVNLl2d7YeShzE+QGlGBVouGsWTVzya/ga1WHSQk0PYHdK
         aW4zRRdSYIZyBz4cHnQc+ZK12+8lMzLNDwktth7xwEOCB3046ff/uWUSSz/+FB8nRZkY
         Ak5lOO6BLmp7X+4JXMEhB7QWVO15cXQmbKbrlt2XzwLNdwu9nkW12/bVoEfNskvGty1r
         eo3T9E9H9gtYKyPqpYtOlg/DyzOH8JBTxNEwwR25758kScE+6UJmm4/RRUSwy4CNcn4t
         HyXw==
X-Gm-Message-State: AOAM532++xZaRoS7ctHkR7UQu4Sk4j2EaE1kp8LHnN+tNC9s7bFXVwxT
        pU7dpXaWdouGOXHExlnXCChTBnkplsUoiA==
X-Google-Smtp-Source: ABdhPJyhZgXLGZq51AllIIgcN7g84DyGiBZ0qdZSqzuCi8l/iolYPN7HETnBGUcHtjAwe4Ez2ljdMw==
X-Received: by 2002:a05:6808:90:: with SMTP id s16mr8773282oic.100.1632005501126;
        Sat, 18 Sep 2021 15:51:41 -0700 (PDT)
Received: from MacBook-Pro.hackershack.net (cpe-173-173-107-246.satx.res.rr.com. [173.173.107.246])
        by smtp.gmail.com with ESMTPSA id g16sm2568553otr.20.2021.09.18.15.51.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Sep 2021 15:51:40 -0700 (PDT)
To:     stable@vger.kernel.org
From:   Steev Klimaszewski <steev@kali.org>
Subject: net: qrtr: revert check in qrtr_endpoint_post()
Message-ID: <2f3c9215-0211-0719-880d-080178e8755d@kali.org>
Date:   Sat, 18 Sep 2021 17:51:39 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

net: qrtr: revert check in qrtr_endpoint_post()


d2cabd2dc8da78faf9b690ea521d03776686c9fe
<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d2cabd2dc8da78faf9b690ea521d03776686c9fe>

Applied to 5.14 if possible - Have tested it locally, and it applies
without any issues.


The reason for the request is that 5.14.4 had net: qrtr: make checks in
qrtr_endpoint_post() stricter applied, and this breaks qrtr on at least
my Lenovo Yoga C630 which means that it no longer has working wifi
without the patch above.  I thought it had already been requested, but
there have been 3 point releases of 5.14 since the break and it doesn't
look like it's queued up anywhere.


Apologies if I did this incorrectly, I'm trying to follow Option 2 in
stable-kernel-rules since it doesn't appear to have been CC'd on the
initial patch.

