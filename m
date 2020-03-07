Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7011F17D095
	for <lists+stable@lfdr.de>; Sun,  8 Mar 2020 00:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgCGXUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Mar 2020 18:20:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:41058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgCGXUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Mar 2020 18:20:34 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA32720836;
        Sat,  7 Mar 2020 23:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583623234;
        bh=CLeIWBGceh4oLqFKnzEDp3/irmSDoOGXQZd4OOB4OrY=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=nM0tEAGagcyXW1ZF4vCpVo/BAKwntC7borNua5PpDgzLZLyaM/dj8LAvWc/NQbk3L
         VuuHNAnPO1v5mHrCWbYnPeD2rSt9jT93YwUyGUmFi/Pz7ZHUjgrscgRIyylLdbWEUo
         EwUtkAC//fH4dd1XaPt3v6QeC+Fq+LA+MH/hEV+Q=
Date:   Sat, 07 Mar 2020 23:20:33 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     linuxtv-commits@linuxtv.org
Cc:     Benoit Parrot <bparrot@ti.com>, stable <stable@vger.kernel.org>
Cc:     stable <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [git:media_tree/master] media: ti-vpe: cal: fix disable_irqs to only the intended target
In-Reply-To: <E1j9yLB-004Dps-EQ@www.linuxtv.org>
References: <E1j9yLB-004Dps-EQ@www.linuxtv.org>
Message-Id: <20200307232033.BA32720836@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.8, v5.4.24, v4.19.108, v4.14.172, v4.9.215, v4.4.215.

v5.5.8: Build OK!
v5.4.24: Build OK!
v4.19.108: Build OK!
v4.14.172: Build OK!
v4.9.215: Build OK!
v4.4.215: Failed to apply! Possible dependencies:
    343e89a792a5 ("[media] media: ti-vpe: Add CAL v4l2 camera capture driver")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
