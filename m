Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B894658BB
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 23:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbhLAWDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 17:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbhLAWDT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 17:03:19 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43141C061574
        for <stable@vger.kernel.org>; Wed,  1 Dec 2021 13:59:58 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id d72-20020a1c1d4b000000b00331140f3dc8so2191369wmd.1
        for <stable@vger.kernel.org>; Wed, 01 Dec 2021 13:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:cc:content-transfer-encoding;
        bh=hc99won5KzHs6AuVMSns40v6zIa/841yhjNJJeHltcc=;
        b=iDtHSGF8BFgSsWiJ0wLul5EsKKxwfjqCvzsoPyWdayxh9Ore6bsoUAKbFpmCpCsJPG
         GyI51Zt+00I/gSiP/llTGLff/9xQ3P9JYeQ0GFXSeVzs24TQ7ZkHCYoLnMlCylF8jEca
         lduAvvnOqbdOJDLXm9GCmrIV7H2M0Tc+kINRJVrpQLf2kGdVzUq9Zx3Da4BhUTvO5ywo
         lIfFLpUpu4BMgBRHwk34phX2gjKF4UAwGIkJmUlAQY6RDiOg/3FRoLMXKt7PgIkaI0De
         L68gQYIHCE/sGZYHeRppx+GC18gweL1PbsuqcH3S1DYekeoMQlN8GHzxJs1u0DtlupUy
         /zMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:cc:content-transfer-encoding;
        bh=hc99won5KzHs6AuVMSns40v6zIa/841yhjNJJeHltcc=;
        b=PCZeJORik8pJw6qz+EUVrScnWqLDr3rcdj7NcLJ5nyBVHo8G+Ui29XWH8xgD7lLTKm
         yXVStJe7BsTHr753XgsdtvVWNE2oLJVjQ4GOTRSFcKYnRD2mPxeXpiEPY5L+VqlEjXxE
         CZgri0R8LfSGURZDczCDzRXwg+N/kb3WlqVU5huPrj0yqUlvh/TttJHsC3rv4feYO2gi
         7XMgdLT/8LqIwC2W+0+Goqk7RnML8RhA5bNBBdUl+tqhk18vwHzT6CAZCzdYhRXTzhhM
         OUtDsJ9tpTpq0XmB4PfqkPBhJrYKKQ8RND0Z/hoaOEujhYWjENc/Kb2JWusj3Pp/ktnm
         pGBg==
X-Gm-Message-State: AOAM530rSTVkO9ezny3tdHu9EbKiXqBDTX+kqPpKHR3dFs5Lw0n5XK4f
        Yx6y3awyC/fmJ9se/I+2YBGa3m0Scg4=
X-Google-Smtp-Source: ABdhPJxfncKx3Z+e8k/b0jrqTCQcNa9sn0HhPsOlnr8C6Bo9VYP1/nxz1MIK+zuLzztrmqp+KHMUnQ==
X-Received: by 2002:a7b:c10a:: with SMTP id w10mr1035119wmi.183.1638395996778;
        Wed, 01 Dec 2021 13:59:56 -0800 (PST)
Received: from debian64.daheim (p5b0d7321.dip0.t-ipconnect.de. [91.13.115.33])
        by smtp.gmail.com with ESMTPSA id e3sm911578wrp.8.2021.12.01.13.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 13:59:56 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.95)
        (envelope-from <chunkeey@gmail.com>)
        id 1msWgT-001Ulv-Q6;
        Wed, 01 Dec 2021 22:59:55 +0100
Message-ID: <611c8692-d5bf-244b-4f75-b90b33466b49@gmail.com>
Date:   Wed, 1 Dec 2021 22:59:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Content-Language: en-US
To:     stable@vger.kernel.org
From:   Christian Lamparter <chunkeey@gmail.com>
Subject: arm64: dts: mcbin: support 2W SFP modules
Cc:     =?UTF-8?B?54Wn5bGx5ZGo5LiA6YOO?= <teruyama@springboard-inc.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 05abc6a5dec2a8c123a50235ecd1ad8d75ffa7b4 upstream

please consider adding the patch to the 5.4's stable release.
(Tested it with patch, where it applies cleanly.)

Reason: The commit message of the patch states that it is:
"Allow the SFP cages to be used with 2W SFP modules."

This was Reported by: 照山周一郎 <teruyama@springboard-inc.jp> in his
openwrt github PR [0].

Based on the reporters' e-mails in a related thread on the OpenWrt
mailinglist [1]. This aforementioned patch is required to get the popular
(in Japan) SFP module "NTT OCU" working.

Thanks,
Christian Lamparter

[0] <https://github.com/openwrt/openwrt/pull/4803>
[1] <https://patchwork.ozlabs.org/project/openwrt/patch/1638108130-24432-1-git-send-email-teruyama@springboard-inc.jp/>
