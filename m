Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4BD3106A6
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 09:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbhBEI2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 03:28:10 -0500
Received: from mail.jv-coder.de ([5.9.79.73]:58462 "EHLO mail.jv-coder.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229514AbhBEI2F (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 03:28:05 -0500
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Feb 2021 03:28:04 EST
Received: from [192.168.178.40] (unknown [188.192.1.224])
        by mail.jv-coder.de (Postfix) with ESMTPSA id 6833AA0730;
        Fri,  5 Feb 2021 08:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jv-coder.de; s=dkim;
        t=1612513153; bh=feZfZqxM5ipQZZcNm0UoaUxlMVweqtwo1raVw7QMp3w=;
        h=To:From:Subject:Message-ID:Date:MIME-Version;
        b=IkoC87/OQMwpdQcxolcdzTAsWDm/vQrWbyOG90N/4Ap6BwK1gsl96PrfUz+IyLX8s
         +KOGDyYCUOMmaxzIq2PiyhuQj2/u/ybnGF9SELg+6kDRVUL7KRImvevCF+01ovi/Xn
         HIyiliz+Fildao8ztnr08ffw5rebBcu8VNQSDS2I=
To:     stable@vger.kernel.org, Christian Brauner <christian@brauner.io>
From:   Joerg Vehlow <lkml@jv-coder.de>
Subject: [PATCH 4.19] sysctl: handle overflow in proc_get_long
Message-ID: <e63d4566-3100-5659-0cb6-53f799abf963@jv-coder.de>
Date:   Fri, 5 Feb 2021 09:20:02 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.1 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF autolearn=ham
        autolearn_force=no version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.jv-coder.de
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

this upstream patch 7f2923c4f73f21cfd714d12a2d48de8c21f11cfe, should 
also be applied to 4.19.
The other patch of this series (sysctl: handle overflow for file-max) 
was already applied.

This was found by ltp test (sysctl02).

Thanks,
Joerg
