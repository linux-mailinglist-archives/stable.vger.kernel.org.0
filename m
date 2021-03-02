Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB52832B0B4
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345066AbhCCAy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbhCBXz3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 18:55:29 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6520AC06121E
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 15:54:49 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id p21so34093596lfu.11
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 15:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=Y0ytKosyseBJxVWoTPyEL6zvduXVyR6FKtq7JHa1mhQ=;
        b=KOS74ZAkn7aIcHenL42cmCEfricv/6odAWaqPZbjdp0ns+yz6ErY8XTxnLPTLqb6H+
         2inQpX5WNuCwuYDxrYLh/gG6SJkjFFi+cCy2+HZCsMDKRIbLKr1YhS7qaikQi+j6U12B
         ggmdu4fhufeE1h5pZB35Uur/MNXYQtbe7YkMryaNkF92CC2Yivw9+ygNo3hyawxxQAdp
         ctII9lqkHYV/CPvlBfxLyW/Lzkjfxb2fJIzJO9V75TICOQkxE9SmIAK5PGQcUN+IsMuj
         DzjYktSGnOZKAEeAxc1y/KYK7w9s5GL2M0Mbl7DVaCPEHBsANB1pNvRZkUIae541ReA3
         VQ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Y0ytKosyseBJxVWoTPyEL6zvduXVyR6FKtq7JHa1mhQ=;
        b=Cj3OpdX2CbG0Eq/3KGcL89rwTbXt0IEEiwWzKVbJzpxHPRYEzWYalmM8fuy0AyK3QD
         bJVm80hZ/UywpBfK1f1HWG5fWZN0fUOJ9R25VMlODX9UBSbr67maTgk9V9EqJIU/WSTV
         gCLVHb5VQPhsQ1P1/AZJJZWi5U9U4K2JOzrrQDIuQ3CGiD7eedDES/zlv3W7c/V9+oZx
         gCfL/f383FKkvToKClphHzX/T5+k52w253qgtTt3QV1lxfXc2wEkZdm3L0kG4auPxXqB
         gxUa8xYI8n6JdMbgZa7njp5dg4usVJjverlnccUFH1HiVph9L/j761qqKMlHCDFsjKnN
         piKA==
X-Gm-Message-State: AOAM532l6seNlDRMNI/8vH8hlLm/JE3fqd570bMraDzl8Rgpzedmjza8
        zOQ5BL3JAkL7SM2GraqphFGglkzx5RM=
X-Google-Smtp-Source: ABdhPJzRAG1ozRexJr35bkePGcMB0peHkecDs6NKfEXw1SMZRMAh1NLvuXYeD5pJklPxvZYcjVLrsw==
X-Received: by 2002:a05:6512:210b:: with SMTP id q11mr13044707lfr.133.1614729287969;
        Tue, 02 Mar 2021 15:54:47 -0800 (PST)
Received: from [10.0.0.11] (user-5-173-242-247.play-internet.pl. [5.173.242.247])
        by smtp.googlemail.com with ESMTPSA id p10sm2780053lfo.293.2021.03.02.15.54.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Mar 2021 15:54:47 -0800 (PST)
Subject: net: usb: qmi_wwan: support ZTE P685M modem
To:     stable@vger.kernel.org
References: <20210206121322.074ddbd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210223183456.6377-1-lech.perczak@gmail.com>
From:   Lech Perczak <lech.perczak@gmail.com>
Message-ID: <b5a3c87e-5860-2c9b-a442-fa1d889f4392@gmail.com>
Date:   Wed, 3 Mar 2021 00:54:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210223183456.6377-1-lech.perczak@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: pl
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lech Perczak<lech.perczak@gmail.com>

commit 88eee9b7b42e69fb622ddb3ff6f37e8e4347f5b2 upstream.

As commit 6420a569504e212d618d4a4736e2c59ed80a8478:
("USB: serial: option: update interface mapping for ZTE P685M") [1]
was selected for stable, I think its netdev counterpart could also be considered for completeness,
if 6420a569504e is merged.

This patch only adds a new device ID, and would probably make OpenWrt folks happy to drop two backports.
I noticed that 6420a569504e was selected for all currently maintained stable branches, but I think that only
5.4.y and newer would suffice, as 5.4.y is currently used as stable kernel where those two patches are required.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/usb/serial/option.c?id=6420a569504e212d618d4a4736e2c59ed80a8478

--
With kind regards,
Lech

