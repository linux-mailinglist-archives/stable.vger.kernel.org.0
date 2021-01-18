Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C6D2FACBF
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 22:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388343AbhARVe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 16:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389544AbhARVex (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 16:34:53 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37A8C061574
        for <stable@vger.kernel.org>; Mon, 18 Jan 2021 13:34:12 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id p5so19111663oif.7
        for <stable@vger.kernel.org>; Mon, 18 Jan 2021 13:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Bq7gPaS2AStvsOx0OXYtzM0DsYj/+f7UAzyh9pcSTVE=;
        b=pqGmNSijcfLE2WxEMLqsiK2dxIzB929b9oUtbpT9DFCJpbCSivYDscVsSVQurXRLuO
         S+p0UlB0yCNCM9xMmCkRgSfS6lRwzIa4qoWk2OkatxSQBWPctzpDbsaSI6tsYOauPplJ
         0P9FIlVWqGFLDiZMpeB+o3W0eT9+3mB5nVS1ze/5BaLqTFMx6ibciBgLTZYwwCsWEj8g
         hIBs+9faXPlanWZrQXSLt9BkD/lUnyQ87oqZol1Yc/6GCxqMryYe7PJRqtFayhkf5nFN
         X0YD643xHSZPcEjWcKKUuxqoXfJFVFmsga1Wt0RzJqaQM19iHtNMJXcpPTO7ePY9Nl6Q
         WHIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Bq7gPaS2AStvsOx0OXYtzM0DsYj/+f7UAzyh9pcSTVE=;
        b=Pbr1gtUf64R8EXUlKRzbYh356bs3ATRvATFoTrbFk28RMSYCjjShRQLBFSDT+7UC5m
         +NIEtlKahiV7ytiItD0mUdpILMPnUZn/gdLOzZVIudT1ZgED1Zn6p+pTIP9Te+7rWFm8
         4XuJxsszVhCdwoD67DXQ8gVKsPnFZ+nWEdDe6Mu9LgNhjokJvzudr3oKwG4+UKMcGbYp
         OzCUGuvbmZfZOQu7Q2VFTtFi/WCk10AMaPsFCNN8R8hoQjoRhtfIU134PB2F8ioN1E8z
         7hP87BmA1wnoyLipsxyJCUT10KTnCqMGqs0ynSnJzocH1rHi/s8NZMV2wjRUyp7Oyq1P
         +UPg==
X-Gm-Message-State: AOAM531EeUXoUvdAlPcPQkXIJGwc8KINK6yq6AUASVMn7chGHZdpYGsD
        3Wf3CqnFnBh4prbO5DJFkXOM822vF9rf27+9
X-Google-Smtp-Source: ABdhPJwmc1f3bhbinJtG4bwB3+3PZjCY84Lvx00bTWVP+/APFc0jN2ouq6HrPIav84nWocBdSe7Plg==
X-Received: by 2002:aca:210c:: with SMTP id 12mr784021oiz.45.1611005652279;
        Mon, 18 Jan 2021 13:34:12 -0800 (PST)
Received: from nuclearis2-1.gtech (c-98-195-139-126.hsd1.tx.comcast.net. [98.195.139.126])
        by smtp.gmail.com with ESMTPSA id 2sm2860909otg.6.2021.01.18.13.34.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 13:34:11 -0800 (PST)
To:     stable@vger.kernel.org
From:   "Alex G." <mr.nuke.me@gmail.com>
Subject: [PATCH] drm/panel: otm8009a: allow using non-continuous dsi clock
Cc:     Marek Vasut <marex@denx.de>
Message-ID: <e1d4b851-061c-4959-7333-28b6e57f91df@gmail.com>
Date:   Mon, 18 Jan 2021 15:34:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please consider applying the following commit to v5.10:

880ee3b7615e ("drm/panel: otm8009a: allow using non-continuous dsi clock")

A related patch introduced in v5.10 has accidentally broken the display 
on stm32mp DK2 boards. This commit resolves the issue.

Fixes: c6d94e37bdbb ("drm/bridge/synopsys: dsi: add support for 
non-continuous HS clock")
