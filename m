Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 879DF13D689
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 10:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgAPJPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 04:15:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59956 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgAPJPM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 04:15:12 -0500
Received: from mail-wm1-f71.google.com ([209.85.128.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <juerg.haefliger@canonical.com>)
        id 1is1F8-0003Ll-M3
        for stable@vger.kernel.org; Thu, 16 Jan 2020 09:15:10 +0000
Received: by mail-wm1-f71.google.com with SMTP id s25so419036wmj.3
        for <stable@vger.kernel.org>; Thu, 16 Jan 2020 01:15:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JATSiYPu6V7o3PEkRbw/A6BJvXS/O8nLMpNaJ1IEruc=;
        b=tjqwAlJA6LargokmQLP9+pd2Wv0HR28kMOjeQ4WLn72pRTJcwqROgL8HornHZEf2or
         YmHJ44seByKOixQ9OTU4tdrUUaaTGdUEVlATmgFltYFA+CWCW5+99Vjbhcb2rz0GUBpE
         +QFIvhBA1RR9SNjt7C1TvaBxVmyTQdk9pplblK9aHWDNZVhQygbervBoVeyik0TaZuqE
         7QBhnlsQMOhM7M4MCzDRsu1u2EKWTGtcQWeEZRAsC/LL8SJCNDW0uyFvmcv4+Wlr9HY6
         q7RzDFEYDoKuHDwdY3RtU1UnpfoD87srdZTTMTbtv+K4VQmGpi3ahLSdtaK2l0B+g/gI
         PO/w==
X-Gm-Message-State: APjAAAV6wzmocD41Yqz4N82Bj7QXxLM4mSa15/dVOHEOOZwgXtSY7mHr
        Q4oTZ7hkkjqrfmdTr5hvDw1HTkHWiXMwix5VkeMp+mQltANkkNEanMbJFUcugNkdYKPIz7vypz7
        BtRCLTR5JpcO34/rtheQxPnxLRmDZR4/z1g==
X-Received: by 2002:a1c:ba89:: with SMTP id k131mr5059684wmf.123.1579166110133;
        Thu, 16 Jan 2020 01:15:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqyJfes4icT/HwKWIwIId3YayoWmuma8LozfxTKPClNdxCvN0jmdvMu4qn9mNFUda3nycO/HBg==
X-Received: by 2002:a1c:ba89:: with SMTP id k131mr5059665wmf.123.1579166109905;
        Thu, 16 Jan 2020 01:15:09 -0800 (PST)
Received: from localhost.localdomain ([81.221.209.144])
        by smtp.gmail.com with ESMTPSA id f1sm28478062wru.6.2020.01.16.01.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 01:15:09 -0800 (PST)
From:   Juerg Haefliger <juerg.haefliger@canonical.com>
X-Google-Original-From: Juerg Haefliger <juergh@canonical.com>
To:     stable@vger.kernel.org
Cc:     Juerg Haefliger <juergh@canonical.com>
Subject: [PATCH 4.14 0/2] arm64 KPTI fixes
Date:   Thu, 16 Jan 2020 10:14:20 +0100
Message-Id: <20200116091422.8413-1-juergh@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please consider the following two patches for inclusion in 4.14.

The second patch fixes a boot issue on ThunderX when erratum 27456 is
enabled. Without it, KPTI is not turned off due to the incorrect order
of evaluating features and errata which leads to all sorts of problems.

Dirk Mueller (1):
  arm64: Check for errata before evaluating cpu features

Mark Rutland (1):
  arm64: add sentinel to kpti_safe_list

 arch/arm64/kernel/cpufeature.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
2.20.1

