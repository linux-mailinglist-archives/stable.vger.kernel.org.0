Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785C41B815C
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 23:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgDXU7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 16:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgDXU6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 16:58:53 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D25C09B048
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 13:58:52 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id t16so4189661plo.7
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 13:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=BMO7flYykLCqjC0wOSF5yIdivWl0tpC7uHElpNFb+2w=;
        b=umBynn/LNJsrhY4ngtbcwnIZLEBJTueslUS9YSKyVh6n7EfMH/S8F26NFonD0+d4BZ
         dtEp32bGYV5aMjCpp+r2T6KOI1vpZYBj2TH29zRNKSpcOVg2KKNVUBAZ+icPg85KrPUG
         aj9y1iXjM0mmmbbXeTrAA1aey4DDLKazLBMRgVs7cLXo8iI2gMIxkLY9N5+3i0j/05Pk
         0LR807cuSw0RKdGtxaF2iPAxrY4v0VZkYPOJTYC2g/bKYeCBAP8+3zC2BR6bTEmNi9Xk
         lVGeH2frbJ1UxfBjNDzS7EfqG4sX31YpyQVDjRxuW9xSHr50Kt422nszphrYpKFoz6jS
         yv+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=BMO7flYykLCqjC0wOSF5yIdivWl0tpC7uHElpNFb+2w=;
        b=REJmIOfsHu3MzIJ/rd6WhQ6RS6rmBeWJRpe3rFrkgw70Ne1xtEz1DQGSd2DJfcDd3h
         C3xzmbilJQyDfaXgl1SkSGRu6/Ho4Qjy4HMbAVqMY+okFqshlUeKl0OiJ05NR5fL/0kq
         p5/z770VIjwzBanQ4L4HAB3ZsqPm5614GtyEQsodDGxKWoC79u4sg+xi2RUSPi46Cob5
         VOlEw4O1JLWsXav27vHTapGoG2UVtmcGdxMdWPyp6p0kaoeexzJL3GBKKtvyzS5mqlFs
         nkyu91DJjhUze/cDhEmP8zuyBqeDyuJYO3vXaINQVwhv1hdaoyErTqmiqvwt+//4nNFM
         ALOQ==
X-Gm-Message-State: AGi0PuaD567A+uKgCJTAXoK1X9fZhAC4O9hwx3IefmytA3m+tz8mJ5dA
        OyIUosKXwTSBTxttJ1taJyc2r7yJqqpptw==
X-Google-Smtp-Source: APiQypJapC3+KTu+NcbHfVncjf9RktLyUkneDNAhcPwAzWZmu5zlhNZMEmtRQbxaEp2DZGBVFzSwLQ==
X-Received: by 2002:a17:90b:4d09:: with SMTP id mw9mr3821713pjb.55.1587761931349;
        Fri, 24 Apr 2020 13:58:51 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id ml24sm5304323pjb.48.2020.04.24.13.58.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2020 13:58:50 -0700 (PDT)
To:     stable@vger.kernel.org
From:   Jens Axboe <axboe@kernel.dk>
Subject: Queue up bc0c4d1e176e
Message-ID: <8ed4e92d-b226-61a9-6679-b807dbc4fcbc@kernel.dk>
Date:   Fri, 24 Apr 2020 14:58:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Can you queue up this:

commit bc0c4d1e176eeb614dc8734fc3ace34292771f11
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Apr 24 11:10:58 2020 -0700

    mm: check that mm is still valid in madvise()

for 5.6-stable?

-- 
Jens Axboe

